<%
/**
 *	$RCSfile: pending.jsp,v $
 *	$Revision: 1.8.4.1 $
 *	$Date: 2003/06/06 04:41:42 $
 */
%>

<%@ page import="java.util.*,
                 com.jivesoftware.util.*,
                 com.jivesoftware.forum.*,
				 com.jivesoftware.forum.util.*"
    errorPage="error.jsp"
%>

<%! // Global vars, methods, etc:

    // Returns an Iterator of pending messages in the system:
    Iterator getPendingMessages(ForumFactory forumFactory) {
        // Create the result filter needed to get pending messages:
        ResultFilter filter = new ResultFilter();
        filter.setModerationRangeMax(0);
        filter.setModerationRangeMin(0);
        // get only one message for efficency's sake:
        filter.setNumResults(1);
        // Sort by oldest creation date
        filter.setSortField(JiveConstants.CREATION_DATE);
        filter.setSortOrder(ResultFilter.ASCENDING);
        // return the iterator:
        return forumFactory.getRootForumCategory().getMessages(filter);
    }
%>

<%@ include file="global.jsp" %>

<%  // Permission check
    if (!isSystemAdmin && !isCatAdmin && !isForumAdmin && !isModerator) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }
    
    // get parameters
    long messageID = ParamUtils.getLongParameter(request,"message",-1L);
    boolean approve = ParamUtils.getBooleanParameter(request,"approve");
    boolean edit = ParamUtils.getBooleanParameter(request,"edit");
    boolean reject = ParamUtils.getBooleanParameter(request,"reject");
    String subject = ParamUtils.getParameter(request,"subject");
    String body = ParamUtils.getParameter(request,"body");
    boolean showEditedByText = ParamUtils.getBooleanParameter(request,"showEditedByText");
    String editedByText = ParamUtils.getParameter(request,"editedByText");
    boolean msgapprove = ParamUtils.getBooleanParameter(request,"msgapprove");
    boolean msgreject = ParamUtils.getBooleanParameter(request,"msgreject");
    
    boolean errors = false;

    // Do a message edit
    if (edit) {
        // check for errors
        if (subject == null || body == null) {
            errors = true;
        }
        if (!errors) {
            ForumMessage message = forumFactory.getMessage(messageID);
            ForumThread thread = message.getForumThread();
            message.setSubject(subject);
            if (showEditedByText && editedByText != null) {
                message.setBody(body + "\n" + editedByText);
            }
            else {
                message.setBody(body);
            }
            // set the correct moderation values
            if (thread.getRootMessage().getID() == message.getID()) {
                // root message so set both thread and message mod values,
                thread.setModerationValue(JiveConstants.FORUM_MODERATION_VISIBLE, authToken);
                message.setModerationValue(JiveConstants.FORUM_MODERATION_VISIBLE, authToken);
            }
            else {
                message.setModerationValue(JiveConstants.FORUM_MODERATION_VISIBLE, authToken);
            }
            response.sendRedirect("pending.jsp?msgapprove=true");
            return;
        }
    }

    // Approve a message
    if (approve) {
        ForumMessage message = forumFactory.getMessage(messageID);
        ForumThread thread = message.getForumThread();
        // set the correct moderation values
        if (thread.getRootMessage().getID() == message.getID()) {
            // root message so set both thread and message mod values,
            thread.setModerationValue(JiveConstants.FORUM_MODERATION_VISIBLE, authToken);
            message.setModerationValue(JiveConstants.FORUM_MODERATION_VISIBLE, authToken);
        }
        else {
            message.setModerationValue(JiveConstants.FORUM_MODERATION_VISIBLE, authToken);
        }
        response.sendRedirect("pending.jsp?msgapprove=true");
        return;
    }

    // Reject a message
    if (reject) {
        ForumMessage message = forumFactory.getMessage(messageID);
        ForumThread thread = message.getForumThread();
        Forum forum = thread.getForum();
        if (thread.getRootMessage().getID() == message.getID()) {
            forum.deleteThread(thread);
        }
        else {
            thread.deleteMessage(message);
        }
        response.sendRedirect("pending.jsp?msgreject=true");
        return;
    }

    // The message we're going to moderate. If there are no moderate-able messages, this variable
    // will remain null
    ForumMessage message = null;
    // The thread and forum the message is in:
    ForumThread thread = null;
    Forum forum = null;

    // If there is a message ID passed, use that message. Otherwise, grab the first pending message
    // in the system:
    if (messageID != -1L) {
        message = forumFactory.getMessage(messageID);
        thread = message.getForumThread();
        forum = thread.getForum();
    }
    else {
        // Get an iterator of all pending messages in the system:
        Iterator pendingMessages = getPendingMessages(forumFactory);

        if (pendingMessages.hasNext()) {
            message = (ForumMessage)pendingMessages.next();
            thread = message.getForumThread();
            forum = thread.getForum();
        }
    }

    // Indicates if there is anything to moderate:
    boolean canModerate = (message != null);
%>

<%@ include file="header.jsp" %>

<%  // Title of this page and breadcrumbs
    String title = "View Pending Submissions";
    String[][] breadcrumbs = {
        {"Main", "main.jsp"},
        {title, "pending.jsp"}
    };
%>
<%@ include file="title.jsp" %>


<%  if (canModerate) { %>

    Below is a form you can use to approve, edit or reject pending messages. For each message below,
    the thread and forum it is in is listed. To jump between pending messages in different forums,
    use the select box below.

<%  } else { %>

    There are no pending messages in any forums or categories.

<%  } %>


<%  // Only show the form below if there something to moderate
    if (canModerate) {
%>

    <p>

    <%  if (edit && errors) { %>

        <p class="jive-error-text">
        There were errors editing the message. Please make sure you include
        the subject and body of the message, and
        <a href="#edit">edit this message</a> again.
        </p>

    <%  } %>

    <%  if (msgapprove) { %>

        <p class="jive-success-text">
        Message approved.
        </p>

    <%  } else if (msgreject) { %>

        <p class="jive-success-text">
        Message rejected.
        </p>

    <%  } %>

    <table cellpadding="0" cellspacing="0" border="0" width="100%">
    <tr>
        <td>

            <%  if (message.getID() != thread.getRootMessage().getID()) { %>

                <b>Pending Message: <%= message.getSubject() %></b>

            <%  } else { %>

                <b>Pending Thread: <%= message.getSubject() %></b>

            <%  } %>

        </td>
        <td align="right">
            &nbsp;
        </td>
    </tr>
    </table>

    <br>

    <table cellpadding="2" cellspacing="0" border="0">
    <tr>
        <td>Author:</td>
        <td rowspan="99"><img src="images/blank.gif" width="5" height="1" border="0"></td>
        <%  String username = "<i>Guest</i>";
            if (message.getUser() != null) {
                username = message.getUser().getUsername();
            }
        %>
        <td><%= username %></td>
    </tr>
    <tr>
        <td>Posted:</td>
        <td>
            <%= SkinUtils.formatDate(request,pageUser,message.getCreationDate()) %>
            (<%= SkinUtils.dateToText(request,pageUser,message.getCreationDate()) %>)
            <%  String ip = message.getProperty("IP");
                if (ip != null) {
            %>  from IP: <%= ip %>
            <%  } %>

        </td>
    </tr>
    <tr>
        <td>Forum:</td>
        <td>
            <a href="forumContent.jsp?forum=<%= forum.getID() %>"
             ><%= forum.getName() %></a>

        </td>
    </tr>
    <%  if (message.getID() != thread.getRootMessage().getID()) { %>
    <tr>
        <td>Thread:</td>
        <td>
            <a href="forumContent.jsp?forum=<%= forum.getID() %>&thread=<%= thread.getID() %>"
             ><%= thread.getName() %></a>

        </td>
    </tr>
    <%  } %>
    </table>
    <br>

    <table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="100%">
    <tr><td>
    <table bgcolor="<%= tblBorderColor %>" cellpadding="6" cellspacing="1" border="0" width="100%">
    <tr bgcolor="#ffffff">
        <td>

            <%= message.getBody() %>

        </td>
    </tr>
    </table>
    </td></tr>
    </table>
    <br>
    <table cellpadding="2" cellspacing="0" border="0">
    <tr>
        <td><img src="images/button_approve.gif" width="17" height="17" border="0"></td>
        <td><a href="pending.jsp?approve=true&forum=<%= forum.getID() %>&thread=<%= thread.getID() %>&message=<%= message.getID() %>"
             onclick="return confirm('Are you sure you want to approve this message?');"
             title="Approve This Message"
             >Approve Message</a>
        </td>
        <td>&nbsp;</td>
        <td><img src="images/button_edit.gif" width="17" height="17" border="0"></td>
        <td><a href="#edit"
             title="Edit This Message"
             >Edit Message</a>
        </td>
        <td>&nbsp;</td>
        <td><img src="images/button_delete.gif" width="17" height="17" border="0"></td>
        <td><a href="pending.jsp?reject=true&forum=<%= forum.getID() %>&thread=<%= thread.getID() %>&message=<%= message.getID() %>"
             onclick="return confirm('Are you sure you want to reject this message?');"
             title="Reject This Message"
             >Reject Message</a>
        </td>
    </tr>
    </table>

    <p><br>

    <form action="pending.jsp">
    <input type="hidden" name="forum" value="<%= forum.getID() %>">
    <input type="hidden" name="thread" value="<%= thread.getID() %>">
    <input type="hidden" name="message" value="<%= message.getID() %>">
    <input type="hidden" name="edit" value="true">

    <a name="edit" style="text-decoration:none;"></a>
    <b>Edit Message</b>
    <p>
    <table cellpadding="2" cellspacing="0" border="0">
    <tr><td>Subject</td>
        <td><input type="text" name="subject" value="<%= StringUtils.escapeHTMLTags(message.getUnfilteredSubject()) %>" size="65" maxlength="200"></td>
    </tr>
    <tr><td valign="top">Message</td>
        <td>
        <textarea name="body" cols="60" rows="8" wrap="virtual"><%= StringUtils.escapeHTMLTags(message.getUnfilteredBody()) %></textarea>
        </td>
    </tr>
    <tr>
        <td valign="top" align="right">Edit Stamp:</td>
        <td>

            <input type="checkbox" name="showEditedByText" checked id="cb01">
            <label for="cb01">Include the following at the bottom of this message:</label>
            <br>

    <textarea rows="3" cols="60" name="editedByText" wrap="virtual">

    [Edited by: <%= pageUser.getUsername() %> on <%= SkinUtils.formatDate(request,pageUser,new Date()) %>]</textarea>
    </td>
    </tr>
    <tr><td>&nbsp;</td>
        <td><input type="submit" value="Save Changes and Approve Message"></td>
    </tr>
    </table>

    <br><br><br><br><br>
    <br><br><br><br><br>
    <br><br><br><br><br>
    <br><br><br><br><br>

<%  } // end if canModerate %>

<%@ include file="footer.jsp" %>

<%
/**
 *	$RCSfile: forumContent_delete.jsp,v $
 *	$Revision: 1.2.12.3 $
 *	$Date: 2003/07/25 03:29:45 $
 */
%>

<%@ page import="java.util.*,
                 java.text.SimpleDateFormat,
                 com.jivesoftware.forum.*,
                 com.jivesoftware.forum.util.*,
                 com.jivesoftware.util.ParamUtils"
	errorPage="error.jsp"
%>

<%!	// Global variables, methods, etc
    
    // default range & starting point for the thread iterators
	private final static int RANGE = 15;
	private final static int START = 0;
%>

<%@ include file="global.jsp" %>
 
<%	// Get parameters
	long forumID = ParamUtils.getLongParameter(request,"forum",-1L);
	long[] threadIDs = ParamUtils.getLongParameters(request,"thread",-1L);
    long messageID = ParamUtils.getLongParameter(request,"message",-1L);
	boolean doDelete = ParamUtils.getBooleanParameter(request,"doDelete");
    String submitButton = ParamUtils.getParameter(request,"submitButton");
    if (threadIDs == null) {
        threadIDs = new long[0];
    }
    
    // Get the Forum
    Forum forum = forumFactory.getForum(forumID);

    // Permissions check
    if (!isSystemAdmin && !forum.isAuthorized(ForumPermissions.FORUM_CATEGORY_ADMIN | ForumPermissions.FORUM_ADMIN | ForumPermissions.MODERATOR)) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }
    
    boolean errors = false;
    
    // Load a list of threads
    List threads = new java.util.LinkedList();
    for (int i=0; i<threadIDs.length; i++) {
        try {
            ForumThread thread = forum.getThread(threadIDs[i]);
            threads.add(thread);
        }
        catch (Exception ignored) {}
    }
    errors = threads.size() == 0;
    
    // Optionally load the message we're working with
    ForumMessage message = null;
    if (!errors && messageID != -1L) {
        ForumThread thread = (ForumThread)threads.get(0);
        message = thread.getMessage(messageID);
    }
    
    // variables to indicate what this page does
    boolean deleteThread = false;
    if (!errors) {
        if (message == null) {
            deleteThread = true;
        }
        else {
            ForumThread thread = (ForumThread)threads.get(0);
            if (thread.getRootMessage().getID() == message.getID()) {
                deleteThread = true;
            }
        }
    }
    
    // Cancel if requested
    if ("Cancel".equals(submitButton)) {
        if (deleteThread) {
            response.sendRedirect("forumContent.jsp?forum="+forumID);
            return;
        } else {
            ForumThread thread = (ForumThread)threads.get(0);
            response.sendRedirect("forumContent_thread.jsp?forum="+forumID+"&thread="+thread.getID());
            return;
        }
    }
    
    // Delete a thread if necessary
	if (!errors && doDelete) {
        if (deleteThread) {
            for (int i=0; i<threads.size(); i++) {
                forum.deleteThread((ForumThread)threads.get(i));
            }
            /*
            ForumThread[] deleteables = new long[threads.size()];
            for (int i=0; i<threads.size(); i++) {
                deleteables[i] = (ForumThread)threads.get(i);
            }
            for (int i=0; deletables.length; i++) {
                forum.deleteThread(deleteables[i]);
            }
            */
        }
        else {
            ForumThread thread = (ForumThread)threads.get(0);
            thread.deleteMessage(message);
        }
        // Indicate that the thread was deleted successfully
        if (deleteThread) {
            setOneTimeMessage(session, "message", "Thread deleted");
        }
        else {
            setOneTimeMessage(session, "message", "Message deleted");
        }
        if (deleteThread) {
		    response.sendRedirect("forumContent.jsp?forum="+forumID);
		    return;
        } else {
            ForumThread thread = (ForumThread)threads.get(0);
		    response.sendRedirect("forumContent_thread.jsp?forum="+forumID+"&thread="+thread.getID());
		    return;
        }
	}
%>

<%  // special onload command to load the sidebar
    onload = " onload=\"parent.frames['sidebar'].location.href='sidebar.jsp?sidebar=forum';\"";
%>
<%@ include file="header.jsp" %>

<p>

<%  String title = (deleteThread) ? "Manage Content: Delete Thread" : "Manage Content: Delete Message";
    String[][] breadcrumbs = null;
    if (!isSystemAdmin && !isCatAdmin && !isForumAdmin && isModerator) {
        breadcrumbs = new String[][] {
            {"Main", "main.jsp"},
            {"Categories &amp; Forums", "forumContent.jsp"},
            {"Manage Content", "forumContent.jsp?forum="+forumID},
            {(deleteThread) ? "Delete Thread" : "Delete Message", ""}
        };
    }
    else {
        breadcrumbs = new String[][] {
            {"Main", "main.jsp"},
            {"Categories &amp; Forums", "forums.jsp?cat=" + forum.getForumCategory().getID()},
            {"Edit Forum", "editForum.jsp?forum="+forumID},
            {"Manage Content", "forumContent.jsp?forum="+forumID},
            {(deleteThread) ? "Delete Thread" : "Delete Message", ""}
        };
    }
%>

<%@ include file="title.jsp" %>

<%  if (errors) { %>

<font size="-1">
Error: No threads to delete.
</font>

<p>
<form action="forumContent.jsp">
<input type="hidden" name="forum" value="<%= forumID %>">
<center>
    <input type="submit" value="Back to thread list">
</center>
</form>

<%  } else { // no errors %>

<font size="-1">
<%  if (deleteThread) { %>
Warning! You are about to delete a thread and all its messages.
<%  } else { %>
Warning! You are about to delete a message and all its replies.
<%  } %>
</font>

<p>

<form action="forumContent_delete.jsp">
<input type="hidden" name="doDelete" value="true">
<input type="hidden" name="forum" value="<%= forumID %>">
<%  for (int i=0; i<threads.size(); i++) {
        ForumThread thread = (ForumThread)threads.get(i);
%>
    <input type="hidden" name="thread" value="<%= thread.getID() %>">
<%  } %>
<input type="hidden" name="message" value="<%= messageID %>">

<%  if (deleteThread) { %>
<font size="-1">
<%  if (threads.size() == 1) { %>
Are you sure you want to delete the following thread?
<%  } else { %>
Are you sure you want to delete all of the following threads?
<%  } %>
<p>
<table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="100%">
<tr><td>
<table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
<tr bgcolor="#eeeeee">
    <td align="center"><font size="-2" face="verdana"><b>SUBJECT</b></font></td>
    <td align="center"><font size="-2" face="verdana"><b>REPLIES</b></font></td>
    <td align="center"><font size="-2" face="verdana"><b>AUTHOR</b></font></td>
    <td align="center"><font size="-2" face="verdana"><b>LAST MODIFIED</b></font></td>
</tr>
<%  for (int i=0; i<threads.size(); i++) {
        ForumThread thread = (ForumThread)threads.get(i);
        User author = thread.getRootMessage().getUser();
%>
<tr bgcolor="#ffffff">
    <td width="97%"><font size="-1"><%= thread.getName() %></font></td>
    <td align="center" width="1%" nowrap><font size="-1"><%= thread.getMessageCount()-1 %></font></td>
    <td align="center" width="1%" nowrap>
    <%  if (author != null) { %>
        <font size="-1"><%= author.getUsername() %></font>
    <%  } else { %>
        <font size="-1"><i>Guest</i></font>
    <%  } %>
    </td>
    <td align="center" width="1%" nowrap><font size="-1">&nbsp;<%= SkinUtils.formatDate(request,pageUser,thread.getModificationDate()) %>&nbsp;</font></td>
</tr>
<%  } %>
</table>
</td></tr>
</table>
<p>
<center>
<input type="submit" name="submitButton" value="Delete">
<input type="submit" name="submitButton" value="Cancel">
</center>
</font>
<%  } else {
        User author = message.getUser();
        ForumThread thread = (ForumThread)threads.get(0);
        TreeWalker treeWalker = thread.getTreeWalker();
%>
<font size="-1">
Are you sure you want to delete the following message (and its replies)?
<p>
<table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="100%">
<tr><td>
<table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
<tr bgcolor="#eeeeee">
    <td align="center"><font size="-2" face="verdana"><b>SUBJECT</b></font></td>
    <td align="center"><font size="-2" face="verdana"><b>REPLIES</b></font></td>
    <td align="center"><font size="-2" face="verdana"><b>AUTHOR</b></font></td>
    <td align="center"><font size="-2" face="verdana"><b>CREATED</b></font></td>
    <td align="center"><font size="-2" face="verdana"><b>MODIFIED</b></font></td>
</tr>
<tr bgcolor="#ffffff">
    <td width="96%"><font size="-1"><%= message.getSubject() %></font></td>
    <td align="center" width="1%" nowrap><font size="-1"><%= treeWalker.getRecursiveChildCount(message) %></font></td>
    <td align="center" width="1%" nowrap>
    <%  if (author != null) { %>
        <font size="-1"><%= author.getUsername() %></font>
    <%  } else { %>
        <font size="-1"><i>Guest</i></font>
    <%  } %>
    </td>
    <td align="center" width="1%" nowrap><font size="-1">&nbsp;<%= SkinUtils.formatDate(request,pageUser,message.getCreationDate()) %>&nbsp;</font></td>
    <td align="center" width="1%" nowrap><font size="-1">&nbsp;<%= SkinUtils.formatDate(request,pageUser,message.getModificationDate()) %>&nbsp;</font></td>
</tr>
<tr bgcolor="#ffffff">
    <td colspan="5"><font size="-1"><%= message.getBody() %></font></td>
</tr>
</table>
</td></tr>
</table>
<p>
<center>
<input type="submit" name="submitButton" value="Delete">
<input type="submit" name="submitButton" value="Cancel">
</center>
</font>
<%  } %>
</form>

<%  } %>

<p>

<%@ include file="footer.jsp" %>    
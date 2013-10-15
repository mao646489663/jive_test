<%@ page import="com.jivesoftware.forum.ForumMessage,
                 com.jivesoftware.forum.action.PostAction" %>
 <%--
  -
  - $RCSfile: viewpreview.jsp,v $
  - $Revision: 1.17.2.2 $
  - $Date: 2003/06/23 15:28:04 $
  -
--%>

<%@ taglib uri="webwork" prefix="ww" %>
<%@ taglib uri="jivetags" prefix="jive" %>

<%@ include file="global.jsp" %>

<%  // Get the action associated with this view:
    PostAction action = (PostAction)getAction(request);
%>

<jsp:include page="header.jsp" flush="true" />
<div style="width:960px; margin:0px auto;">
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr valign="top">
    <td width="98%">

        <%-- Breadcrumbs (customizable via the admin tool) --%>

        <jsp:include page="breadcrumbs.jsp" flush="true" />

        <%-- Page title --%>

        <p>
        <span class="jive-page-title">

        <%  if (action.isReply()) { %>

            <%-- Message Preview: Reply --%>
            <jive:i18n key="preview.post_reply" />

        <%  } else { %>

            <%-- Message Preview: New Topic --%>
            <jive:i18n key="preview.post_new" />

        <%  } %>
        </span>
        </p>

    </td>
    <td width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>
    <td width="1%">

        <%@ include file="accountbox.jsp" %>

    </td>
</tr>
</table>

<%-- preview description --%>
<p>
<jive:i18n key="preview.description" />
</p>

<br>

<form action="post!execute.jspa" method="post">

<input type="hidden" name="forumID" value="<%= action.getForumID() %>">
<input type="hidden" name="threadID" value="<%= action.getThreadID() %>">
<input type="hidden" name="messageID" value="<%= action.getMessageID() %>">
<input type="hidden" name="reply" value="<%= action.isReply() %>">
<input type="hidden" name="resolution" value="<%= action.getResolution() %>">
<input type="hidden" name="from" value="preview">

<div class="jive-preview-box">
<table class="jive-box" cellpadding="3" cellspacing="0" border="0" width="100%">
<tr valign="top" class="jive-odd">
    <td width="1%">
        <table cellpadding="0" cellspacing="0" border="0" width="180">
        <tr>
            <td>
                <%  if (action.getPageUser() != null) { %>

                    <a href="profile.jspa?userID=<%= action.getPageUser().getID() %>"
                     ><%= action.getPageUser().getUsername() %></a>
                    <br><br>
                    <%-- Posts: --%>
                    <jive:i18n key="global.posts" /><jive:i18n key="global.colon" />

                    <%= action.getNumberFormat().format(action.getForumFactory().getUserMessageCount(action.getPageUser())) %>

                    <br>
                    <%-- Registered --%>
                    <jive:i18n key="global.registered" /><jive:i18n key="global.colon" />

                    <%= action.getShortDateFormat().format(action.getPageUser().getCreationDate()) %>

                <%  } else { %>

                    <%-- Guest --%>
                    <i><jive:i18n key="global.guest" /></i>

                <%  } %>
            </td>
        </tr>
        </table>
    </td>

    <%  // Get the previewed message
        ForumMessage previewedMessage = action.getPreviewedMessage();
    %>

    <td width="99%">
        <table cellpadding="0" cellspacing="0" border="0" width="100%">
        <tr>
            <td width="99%">
                <span class="jive-subject">
                <%= previewedMessage.getSubject() %>
                </span>
                <br>
                <%-- posted: --%>
                <jive:i18n key="global.posted" /><jive:i18n key="global.colon" />
                <%= (action.getDateFormat().format(previewedMessage.getCreationDate())) %>
            </td>
            <td width="1%">
                <table cellpadding="3" cellspacing="0" border="0">
                <tr>
                    <td>
                        <img src="images/reply-16x16.gif" width="16" height="16" border="0" alt="<jive:i18n key="global.reply" />">
                    </td>
                    <td>
                        <%-- Reply --%>
                        <jive:i18n key="global.reply" />
                    </td>
                </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td colspan="2" style="border-top: 1px #ccc solid;">
                <br>
                <%= previewedMessage.getBody() %>
                <br><br>
            </td>
        </tr>
        </table>
    </td>

</tr>
</table>
</div>

<br>

<%-- go back/edit --%>
<input type="submit" name="doGoBack" value="<jive:i18n key="global.go_back_or_edit" />">
<%-- Post message --%>
<input type="submit" name="doPost" value="<jive:i18n key="global.post_message" />">
</form>
</div>
<jsp:include page="footer.jsp" flush="true" />

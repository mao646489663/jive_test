<%--
  -
  - $RCSfile: editform.jsp,v $
  - $Revision: 1.18 $
  - $Date: 2003/05/26 15:36:35 $
  -
--%>

<%@ page import="com.jivesoftware.forum.action.*,
                 java.text.DateFormat,
                 com.jivesoftware.forum.ForumMessage,
                 com.jivesoftware.util.StringUtils"
%>

<%@ taglib uri="webwork" prefix="ww" %>
<%@ taglib uri="jivetags" prefix="jive" %>

<%@ include file="global.jsp" %>

<%  // Get the action associated with this view:
    EditAction action = (EditAction)getAction(request);
    // Get the message we're editing - common used object
    ForumMessage message = action.getMessage();
%>

<jsp:include page="header.jsp" flush="true" />

<script language="JavaScript" type="text/javascript" src="utils.js"></script>
<div style="width:960px; margin:0px auto;">
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr valign="top">
    <td width="98%">

        <%-- Breadcrumbs (customizable via the admin tool) --%>

        <jsp:include page="breadcrumbs.jsp" flush="true" />

        <p class="jive-page-title">
        <%-- Edit Message --%>
        <jive:i18n key="edit.title" />
        </p>

        <%-- Editing message: XXX in forum: YYY --%>
        <jive:i18n key="edit.edit_message_in_forum">
            <jive:arg>
                <a href="thread.jspa?threadID=<%= action.getThreadID() %>&messageID=<%= action.getMessageID() %>#<%= action.getMessageID() %>"
                 ><%= message.getSubject() %></a>
            </jive:arg>
            <jive:arg>
                <a href="forum.jspa?forumID=<%= action.getForumID() %>"><%= action.getForum().getName() %></a>
            </jive:arg>
        </jive:i18n>

    </td>
    <td width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>
    <td width="1%">

        <%@ include file="accountbox.jsp" %>

    </td>
</tr>
</table>

<p>
<%--
    Use the form below to edit this message. When you're done, click "Save" to save the message and
    return to the topic. You can preview your changes by clicking "Preview" or cancel and go back
    to the topic by clicking "Cancel".
--%>
<jive:i18n key="edit.description" />
</p>

<ww:if test="hasErrors == true || hasErrorMessages == true">

    <table class="jive-error-message" cellpadding="3" cellspacing="0" border="0" width="350">
    <tr valign="top">
        <td width="1%"><img src="images/error-16x16.gif" width="16" height="16" border="0"></td>
        <td width="99%">

            <span class="jive-error-text">

            <ww:if test="errors['subject']">

                <%-- Please enter a subject. --%>
                <jive:i18n key="post.error_subject" />

            </ww:if>
            <ww:elseIf test="errors['body']">

                <%-- You can not post a blank message. Please type your message and try again. --%>
                <jive:i18n key="post.error_body" />

            </ww:elseIf>
            <ww:else>
                <ww:iterator value="errorMessages">
                    <ww:property /> <br>
                </ww:iterator>
            </ww:else>

            </span>

        </td>
    </tr>
    </table>

    <br>

</ww:if>

<ww:if test="hasInfoMessages == true">

    <table class="jive-info-message" cellpadding="3" cellspacing="0" border="1" width="350">
    <tr valign="top">
        <td width="1%"><img src="images/info-icon.gif" width="16" height="16" border="1"></td>
        <td width="99%">

            <span class="jive-info-text">

            <ww:iterator value="infoMessages">
                <ww:property /> <br>
            </ww:iterator>

            </span>

        </td>
    </tr>
    </table>

    <br><br>

</ww:if>

<ww:if test="hasWarningMessages == true">

    <table class="jive-warning-message" cellpadding="3" cellspacing="0" border="1" width="350">
    <tr valign="top">
        <td width="1%"><img src="images/warning-icon.gif" width="16" height="16" border="1"></td>
        <td width="99%">

            <span class="jive-warning-text">

            <ww:iterator value="warningMessages">
                <ww:property /> <br>
            </ww:iterator>

            </span>

        </td>
    </tr>
    </table>

    <br><br>

</ww:if>

<form action="edit!execute.jspa" method="post" name="editform" onsubmit="return checkPost();">
<input type="hidden" name="messageID" value="<%= message.getID() %>">
<input type="hidden" name="reply" value="<%= action.isReply() %>">

<%  int tabIndex = 0; %>

<div class="jive-post-form">

<table cellpadding="3" cellspacing="0" border="0">

<%  if (action.isGuest()) { %>

    <tr>
        <td class="jive-label">
            <%-- Name: --%>
            <jive:i18n key="global.name" /><jive:i18n key="global.colon" />
        </td>
        <td>
            <input type="text" name="name" size="30" maxlength="75" tabindex="<%= tabIndex++ %>"
             value="<%= ((action.getName() != null) ? action.getName() : "") %>">
        </td>
    </tr>
    <tr>
        <td class="jive-label">
            <%-- Email: --%>
            <jive:i18n key="global.email" /><jive:i18n key="global.colon" />
        </td>
        <td>
            <input type="text" name="email" size="30" maxlength="75" tabindex="<%= tabIndex++ %>"
             value="<%= ((action.getEmail() != null) ? action.getEmail() : "") %>">
        </td>
    </tr>

<%  } %>

<tr>
    <td class="jive-label">
        <%-- Subject: --%>
        <jive:i18n key="global.subject" /><jive:i18n key="global.colon" />
    </td>
    <td>
        <%  String subj = action.getMessage().getUnfilteredSubject();
            if (subj != null) {
                subj = StringUtils.escapeHTMLTags(subj);
                subj = StringUtils.replace(subj, "\"", "&quot;");
            }
        %>
        <input type="text" name="subject" size="60" maxlength="75" tabindex="<%= tabIndex++ %>"
         value="<%= ((subj != null) ? subj : "") %>">
    </td>
</tr>
<tr>
    <td>&nbsp;</td>
    <td>
        <table class="jive-font-buttons" cellpadding="2" cellspacing="0" border="0">
        <tr>
            <td><a href="#" onclick="styleTag('b',document.editform.body);return false;"
                 title="<jive:i18n key="post.bold" />"
                 ><img src="images/bold.gif" width="20" height="22" border="0" alt="<jive:i18n key="post.bold" />"></a></td>
            <td><a href="#" onclick="styleTag('i',document.editform.body);return false;"
                 title="<jive:i18n key="post.italic" />"
                 ><img src="images/italics.gif" width="20" height="22" border="0" alt="<jive:i18n key="post.italic" />"></a></td>
            <td><a href="#" onclick="styleTag('u',document.editform.body);return false;"
                 title="<jive:i18n key="post.underline" />"
                 ><img src="images/underline.gif" width="20" height="22" border="0" alt="<jive:i18n key="post.underline" />"></a></td>
        </tr>
        </table>
    </td>
</tr>
<tr>
    <td class="jive-label" valign="top">
        <%-- Message: --%>
        <jive:i18n key="global.message" /><jive:i18n key="global.colon" />
    </td>
    <td>
        <%  String bod = action.getMessage().getUnfilteredBody();
            if (bod != null) {
                bod = StringUtils.escapeHTMLTags(bod);
                bod = StringUtils.replace(bod, "\"", "&quot;");
            }
        %>
        <textarea name="body" wrap="virtual" cols="58" rows="12" tabindex="<%= tabIndex++ %>"
         ><%= ((bod != null) ? bod : "") %></textarea>
    </td>
</tr>
<tr>
    <td>&nbsp;</td>
    <td>
        <input type="checkbox" name="addComment" value="true" id="cb01" checked>
        <label for="cb01"><jive:i18n key="edit.add_text" /></label> - <jive:i18n key="edit.add_text_explanation" />
    </td>
</tr>
<tr>
    <td>&nbsp;</td>
    <td>

    <%  // Date formatter for the date in the textare below
        DateFormat formatter = DateFormat.getDateTimeInstance(DateFormat.MEDIUM, DateFormat.SHORT);
    %>

<textarea name="comment" cols="58" rows="2" wrap="virtual">
<%-- Message was edited by: USERNAME at DATE --%>
<jive:i18n key="edit.message_edit_by">
    <jive:arg>
        <%= action.getPageUser().getUsername() %>
    </jive:arg>
</jive:i18n>
</textarea>

    </td>
</tr>
<tr>
    <td>&nbsp;</td>
    <td>
        <%-- Save --%>
        <input type="submit" name="doPost" value="<jive:i18n key="global.save" />" tabindex="<%= tabIndex++ %>">
        &nbsp;
        <%-- Cancel --%>
        <input type="submit" name="doCancel" value="<jive:i18n key="global.cancel" />" tabindex="<%= tabIndex++ %>">
    </td>
</tr>
</table>

</div>

</form>

<script language="JavaScript" type="text/javascript">
<!--
    <ww:if test="guest == true">
        document.editform.name.focus();
    </ww:if>
    <ww:else>
        document.editform.body.focus();
    </ww:else>
//-->
</script>
</div>
<jsp:include page="footer.jsp" flush="true" />


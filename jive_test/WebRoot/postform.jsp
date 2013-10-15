 <%--
  - $RCSfile: postform.jsp,v $
  - $Revision: 1.37.2.1 $
  - $Date: 2003/06/09 07:36:37 $
  -
  - Copyright (C) 2002-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software. Use is subject to license terms.
--%>

<%@ page import="com.jivesoftware.forum.action.PostAction,
                 com.jivesoftware.base.*,
                 com.jivesoftware.forum.action.util.Guest,
                 com.jivesoftware.forum.*" %>

<%@ include file="global.jsp" %>

<%@ taglib uri="webwork" prefix="ww" %>
<%@ taglib uri="jivetags" prefix="jive" %>

<jsp:include page="header.jsp" flush="true" />

<%  // Get the action associated with this view:
    PostAction action = (PostAction)getAction(request);
    // There is guaranteed to be a valid forum object available at this point:
    Forum forum = action.getForum();
%>

<script language="JavaScript" type="text/javascript" src="utils.js"></script>


<div style="width:960px; margin:0px auto;">
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr valign="top">
    <td width="98%">

        <%-- Breadcrumbs (customizable via the admin tool) --%>

        <jsp:include page="breadcrumbs.jsp" flush="true" />

        <%-- Page title --%>

        <%  if (action.isReply()) { %>

            <p class="jive-page-title">
            <%-- Post Message: Reply --%>
            <jive:i18n key="post.title_reply" />
            </p>

            <%-- Post a reply in forum: {forum name}, to message: {message subject} --%>
            <jive:i18n key="post.reply_in_forum_to_message">
                <jive:arg>
                    <a href="forum.jspa?forumID=<%= forum.getID() %>"><%= forum.getName() %></a>
                </jive:arg>
                <jive:arg>
                    <a href="thread.jspa?forumID=<%= forum.getID() %>&threadID=<%= action.getThreadID() %>&messageID=<%= action.getMessage().getID() %>#<%= action.getMessage().getID() %>"
                     ><%= action.getMessage().getSubject() %></a>
                </jive:arg>
            </jive:i18n>

        <%  } else { %>

            <p class="jive-page-title">
            <%-- Post Message: New Topic --%>
            <jive:i18n key="post.title_new" />
            </p>

            <%-- Post new topic in forum: {forum name} --%>
            <jive:i18n key="post.post_in_forum">
                <jive:arg>
                    <a href="forum.jspa?forumID=<%= forum.getID() %>&start=0"><%= forum.getName() %></a>
                </jive:arg>
            </jive:i18n>

        <%  } %>

    </td>
    <td width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>
    <td width="1%">

        <%@ include file="accountbox.jsp" %>

    </td>
</tr>
</table>

<p>
<%  if (action.isReply()) { %>

    <%--
        Type a reply to the topic using the form below. When finished, you can optionally preview your reply by
        clicking on the "Preview" button. Otherwise, click the "Post Message" button to submit your message immediately.
    --%>
    <jive:i18n key="post.reply_description" />

<%  } else { %>

    <%--
        Type your message using the form below. When finished, you can optionally preview your post
        by clicking on the "Preview" button. Otherwise, click the "Post Message" button to submit
        your message immediately.
    --%>
    <jive:i18n key="post.new_description" />

<%  } %>
</p>

<%  if (action.getHasErrors() || action.getHasErrorMessages()) { %>

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

<%  } %>

<%  if (action.getHasInfoMessages()) { %>

    <table class="jive-info-message" cellpadding="3" cellspacing="0" border="0">
    <tr valign="top">
        <td width="1%"><img src="images/info-16x16.gif" width="16" height="16" border="0"></td>
        <td width="99%">

            <span class="jive-info-text">

            <ww:iterator value="infoMessages">
                <ww:property /> <br>
            </ww:iterator>

            </span>

        </td>
    </tr>
    </table>

    <br>

<%  } %>

<%  if (action.getHasWarningMessage()) { %>

    <table class="jive-warning-message" cellpadding="3" cellspacing="0" border="0">
    <tr valign="top">
        <td width="1%"><img src="images/warning-16x16.gif" width="16" height="16" border="0"></td>
        <td width="99%">

            <span class="jive-warning-text">

            <ww:iterator value="warningMessages">
                <ww:property /> <br>
            </ww:iterator>

            </span>

        </td>
    </tr>
    </table>

    <br>

<%  } %>

<form action="post!post.jspa" method="post" name="postform" onsubmit="return checkPost();">
<input type="hidden" name="forumID" value="<%= forum.getID() %>">

<%  if (action.getThreadID() != -1L) { %>
    <input type="hidden" name="threadID" value="<%= action.getThreadID() %>">
<%  } %>

<%  if (action.getMessageID() != -1L) { %>
    <input type="hidden" name="messageID" value="<%= action.getMessageID() %>">
<%  } %>

<%  if (action.isReply()) { %>
    <input type="hidden" name="reply" value="<%= action.isReply() %>">
<%  } %>

<%  // Counter for the tab index:
    int tabIndex = 1;
%>

<span class="jive-post-form">

<table cellpadding="3" cellspacing="2" border="0">
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
        <%  if (action.isReply()) { %>

            <input type="text" name="subject" size="60" maxlength="75" tabindex="<%= tabIndex++ %>"
             value="<%= ((action.getReplySubject() != null) ? action.getReplySubject() : "") %>">

        <%  } else { %>

            <input type="text" name="subject" size="60" maxlength="75" tabindex="<%= tabIndex++ %>"
             value="<%= ((action.getSubject() != null) ? action.getSubject() : "") %>">

        <%  } %>
    </td>
</tr>
<tr>
    <td>&nbsp;</td>
    <td>
        <table class="jive-font-buttons" cellpadding="2" cellspacing="0" border="0">
        <tr>
            <td><a href="#" onclick="styleTag('b',document.postform.body);return false;"
                 title="<jive:i18n key="post.bold" />"
                 ><img src="images/bold.gif" width="20" height="22" border="0" alt="<jive:i18n key="post.bold" />"></a></td>
            <td><a href="#" onclick="styleTag('i',document.postform.body);return false;"
                 title="<jive:i18n key="post.italic" />"
                 ><img src="images/italics.gif" width="20" height="22" border="0" alt="<jive:i18n key="post.italic" />"></a></td>
            <td><a href="#" onclick="styleTag('u',document.postform.body);return false;"
                 title="<jive:i18n key="post.underline" />"
                 ><img src="images/underline.gif" width="20" height="22" border="0" alt="<jive:i18n key="post.underline" />"></a></td>
            <td><input type="submit" name="doSpellCheck" accesskey="s" class="fontButton" value="<jive:i18n key="post.spell_check" />"></td>

            <%  if (action.isReply()) { %>

                <td><input type="submit" name="doQuoteOriq" accesskey="q" class="fontButton" value="<jive:i18n key="post.quote" />" tabindex="<%= tabIndex++ %>"></td>

            <%  } %>
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
        <textarea name="body" wrap="virtual" cols="58" rows="12" tabindex="<%= tabIndex++ %>"
         ><%= ((action.getBody() != null) ? action.getBody() : "") %></textarea>
    </td>
</tr>
<tr>
    <td>&nbsp;</td>
    <td>
        <%-- Preview --%>
        <input type="submit" name="doPreview" value="<jive:i18n key="global.preview" />" tabindex="<%= tabIndex++ %>">

        <%  if (action.getCanAttach(forum)) { %>
            <%-- attach files --%>
            <input type="submit" name="doAttach" value="<jive:i18n key="post.attach_files" />" tabindex="<%= tabIndex++ %>">
        <%  } %>

        <%-- post message --%>
        <input type="submit" name="doPost" value="<jive:i18n key="global.post_message" />" tabindex="<%= tabIndex++ %>">
        &nbsp;
        <%-- cancel --%>
        <input type="submit" name="doCancel" value="<jive:i18n key="global.cancel" />" tabindex="<%= tabIndex++ %>">
    </td>
</tr>
</table>


</form>

<script language="JavaScript" type="text/javascript">
<!--
    <%  if (action.isGuest()) { %>

        document.postform.name.focus();

    <%  } else { %>

        <%  if (action.isReply()) { %>

            document.postform.body.focus();

        <%  } else { %>

            document.postform.subject.focus();

        <%  } %>

    <%  } %>
//-->
</script>

<%  if (action.isReply()) { %>

    <%-- Original Message: --%>
    <jive:i18n key="post.original" /><jive:i18n key="global.colon" />

    <br><br>

    <%  // Get the parent message:
        ForumMessage parent = action.getMessage();
    %>

    <span class="jive-message-list">
    <table class="jive-box" cellpadding="3" cellspacing="2" border="0" width="100%">
    <tr valign="top" class="jive-odd">
        <td width="1%">
            <table cellpadding="0" cellspacing="0" border="0" width="180">
            <tr>
                <td>
                    <%  if (parent.getUser() != null) {
                            User author = parent.getUser();
                    %>

                        <a href="profile.jspa?userID=<%= author.getID() %>"
                         title="<%= ((author.getName() != null) ? author.getName() : "") %>"
                         ><%= author.getUsername() %></a>
                        <br><br>
                        <jive:i18n key="global.posts" /><jive:i18n key="global.colon" />
                        <%= action.getNumberFormat().format(action.getForumFactory().getUserMessageCount(author)) %>
                        <br>
                        <%  if (author.getProperty("jiveLocation") != null) { %>

                            <%-- From: --%>
                            <jive:i18n key="global.from" /><jive:i18n key="global.colon" />
                            <%= author.getProperty("jiveLocation") %>
                            <br>

                        <%  } %>

                        <%-- Registered: --%>
                        <jive:i18n key="global.registered" /><jive:i18n key="global.colon" />
                        <%= action.getShortDateFormat().format(author.getCreationDate()) %>

                    <%  } else { %>

                        <%  // Create a 'guest' bean - this helps us render the guest properties
                            Guest guest = new Guest();
                            guest.setMessage(parent);
                        %>

                        <span class="jive-guest">
                        <%  if (guest.getEmail() != null) { %>

                            <a href="mailto:<%= guest.getEmail() %>"><%= guest.getDisplay() %></a>

                        <%  } else { %>

                            <%= guest.getDisplay() %>

                        <%  } %>
                        </span>

                    <%  } %>
                </td>
            </tr>
            </table>
        </td>
        <td width="99%">
            <table cellpadding="0" cellspacing="0" border="0" width="100%">
            <tr valign="top">
                <td>
                    <span class="jive-subject">
                    <%= parent.getSubject() %>
                    </span>
                    <br>
                    <%-- Posted: --%>
                    <jive:i18n key="global.posted" /><jive:i18n key="global.colon" />
                    <%= action.getDateFormat().format(parent.getCreationDate()) %>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="border-top: 1px #ccc solid;">
                    <br>
                    <%= parent.getBody() %>
                    <br><br>
                </td>
            </tr>
            </table>
        </td>
    </tr>
    </table>
    
	</span>
<%  } %>
</div>


<jsp:include page="footer.jsp" flush="true" />
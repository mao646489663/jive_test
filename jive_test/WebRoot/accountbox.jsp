<%--
  - $RCSfile: accountbox.jsp,v $
  - $Revision: 1.18.2.1 $
  - $Date: 2003/07/01 05:45:15 $
  -
  - Copyright (C) 1999-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software.  Use is subject to license terms.
--%>

<%@ page import="com.jivesoftware.base.action.JiveActionSupport" %>

<%  // This file is included statically and needs access to a ForumSupportAction instance.
    // Since "action" might be a declared variable in another file, we'll use
    // the name "_action" in this file.
    JiveActionSupport _action = (JiveActionSupport)getAction(request);
    boolean noLoginRedirect = "true".equals(request.getAttribute("noLoginRedirect"));
%>

<div class="jive-account-box">
<table class="jive-box" cellpadding="3" cellspacing="0" border="0" width="200">

<%  if (_action.isGuest()) { %>

    <tr>
        <th colspan="2">
            <%-- Welcome, Guest --%>
            <jive:i18n key="loginbox.welcome_guest" />
        </th>
    </tr>
    <tr>
        <td width="1%"><a href="<%= ((noLoginRedirect) ? "login!default.jspa?referrer=index.jspa" : "login!withRedirect.jspa") %>"><img src="images/login-16x16.gif" width="16" height="16" border="0" alt="<jive:i18n key="global.login" />"></a></td>
        <td width="99%">
            <%-- Login --%>
            <a href="<%= ((noLoginRedirect) ? "login!default.jspa?referrer=index.jspa" : "login!withRedirect.jspa") %>"><jive:i18n key="global.login" /></a>
        </td>
    </tr>
    <tr>
        <td width="1%"><a href="settings.jsp"><img src="images/settings-16x16.gif" width="16" height="16" border="0" alt="<jive:i18n key="loginbox.guest_settings" />"></a></td>
        <td width="99%">
            <%-- Guest Settings --%>
            <a href="settings!default.jspa"><jive:i18n key="loginbox.guest_settings" /></a>
        </td>
    </tr>

<%  } else { %>

    <tr>
        <th colspan="2">
            <%-- Welcome, USERNAME --%>
            <jive:i18n key="loginbox.welcome_user">
                <jive:arg>
                    <a href="profile.jspa?userID=<%= _action.getPageUser().getID() %>"
                    ><%= _action.getPageUser().getUsername() %></a>
                </jive:arg>
            </jive:i18n>
        </th>
    </tr>
    <tr>
        <td width="1%"><a href="logout.jspa"><img src="images/logout-16x16.gif" width="16" height="16" border="0" alt="<jive:i18n key="global.logout" />"></a></td>
        <td width="99%">
            <%-- Logout --%>
            <a href="logout.jspa"><jive:i18n key="global.logout" /></a>
        </td>
    </tr>
    <tr>
        <td width="1%"><a href="settings!default.jspa"><img src="images/settings-16x16.gif" width="16" height="16" border="0" alt="<jive:i18n key="loginbox.your_control_panel" />"></a></td>
        <td width="99%">
            <%-- Your Control Panel --%>
            <a href="settings!default.jspa"><jive:i18n key="loginbox.your_control_panel" /></a>
        </td>
    </tr>

<%  } %>

<tr>
    <td width="1%"><a href="help.jspa"><img src="images/help-16x16.gif" width="16" height="16" border="0" alt="<jive:i18n key="global.help" />"></a></td>
    <td width="99%">
        <a href="help.jspa"><jive:i18n key="global.help" /></a>
    </td>
</tr>
</table>
</div>
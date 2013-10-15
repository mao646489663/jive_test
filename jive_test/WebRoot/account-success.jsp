<%--
  - $RCSfile: account-success.jsp,v $
  - $Revision: 1.7 $
  - $Date: 2003/05/27 21:28:20 $
  -
  - Copyright (C) 1999-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software.  Use is subject to license terms.
--%>

<%@ taglib uri="webwork" prefix="ww" %>
<%@ taglib uri="jivetags" prefix="jive" %>

<%@ include file="global.jsp" %>

<jsp:include page="header.jsp" flush="true" />
<div style="width:960px; margin:0px auto;">
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr valign="top">
    <td width="98%">

        <%-- Breadcrumbs (customizable via the admin tool) --%>

        <jsp:include page="breadcrumbs.jsp" flush="true" />

        <%-- Text describing your community (customizable via the admin tool) --%>

        <p class="jive-page-title">
        <%-- Account Creation Successful --%>
        <jive:i18n key="accountsuccess.success" />
        </p>

    </td>
    <td width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>
    <td width="1%">

        <%@ include file="accountbox.jsp" %>

    </td>
</tr>
</table>

<br><br>

<%-- Your user account has been created.... --%>
<jive:i18n key="accountsuccess.created" />

<ul>
    <li><%-- Go to: The Main Forums Page --%>
        <jive:i18n key="global.go_to" /><jive:i18n key="global.colon" />
        <a href="index.jspa"><jive:i18n key="global.the_main_forums_page" /></a>

    <li><%-- Go to: Your Settings --%>
        <a href="settings!default.jspa"><jive:i18n key="settings.your_settings" /></a>
</ul>

<br><br>
</div>
<jsp:include page="footer.jsp" flush="true" />
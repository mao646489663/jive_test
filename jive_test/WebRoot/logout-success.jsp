<%--
  - $RCSfile: logout-success.jsp,v $
  - $Revision: 1.11.2.1 $
  - $Date: 2003/07/01 05:45:15 $
  -
  - Copyright (C) 1999-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software.  Use is subject to license terms.
--%>

<%@ include file="global.jsp" %>

<%@ taglib uri="webwork" prefix="ww" %>
<%@ taglib uri="jivetags" prefix="jive" %>

<jsp:include page="header.jsp" flush="true" />

<div style="width:960px; margin:0px auto;">

<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr valign="top">
    <td width="98%">

        <%-- Breadcrumbs (customizable via the admin tool) --%>

        <jsp:include page="breadcrumbs.jsp" flush="true" />

        <%-- Text describing your community (customizable via the admin tool) --%>

        <p class="jive-page-title">
        <%-- User Logout --%>
        <jive:i18n key="logout.title" />
        </p>

    </td>
    <td width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>
    <td width="1%">

        <% request.setAttribute("noLoginRedirect", "true"); %>
        <%@ include file="accountbox.jsp" %>

    </td>
</tr>
</table>

<br><br>

<%-- You have been successfully logged out of the system. --%>
<jive:i18n key="logout.success" />

<ul>
    <ww:if test="previousURL">

        <li><%-- Go to: the last page you visited --%>
            <jive:i18n key="global.go_to" /><jive:i18n key="global.colon" />
            <a href="<ww:property value="previousURL" />"><jive:i18n key="global.the_last_page_you_visited" /></a>
        </li>

    </ww:if>

    <li><%-- Go to: main forum page --%>
        <jive:i18n key="global.go_to" /><jive:i18n key="global.colon" />
        <a href="index.jspa"><jive:i18n key="global.the_main_forums_page" /></a>
    </li>

    <li><%-- Go to: Guest settings --%>
        <jive:i18n key="global.go_to" /><jive:i18n key="global.colon" />
        <a href="settings!default.jspa"><jive:i18n key="loginbox.guest_settings" /></a>
    </li>

</ul>

<br><br>

</div>

<jsp:include page="footer.jsp" flush="true" />
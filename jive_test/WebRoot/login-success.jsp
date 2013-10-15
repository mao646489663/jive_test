<%--
  - $RCSfile: login-success.jsp,v $
  - $Revision: 1.12 $
  - $Date: 2003/05/27 21:28:20 $
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

        <p class="jive-page-title">
        <%-- Login Successful --%>
        <jive:i18n key="login.success_title" />
        </p>

    </td>
    <td width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>
    <td width="1%">

        <%@ include file="accountbox.jsp" %>

    </td>
</tr>
</table>

<br><br>

<%-- You have successfully logged in. --%>
<jive:i18n key="login.success_description" />

<ul>
    <ww:if test="previousURL">

        <li><%-- Go to: The last page you visited. --%>
            <jive:i18n key="global.go_to" /><jive:i18n key="global.colon" />
            <a href="<ww:property value="previousURL" />"><jive:i18n key="global.the_last_page_you_visited" /></a>
        </li>

    </ww:if>

    <li><%-- Go to: main forum page --%>
        <jive:i18n key="global.go_to" /><jive:i18n key="global.colon" />
        <a href="index.jspa"><jive:i18n key="global.the_main_forums_page" /></a>
    </li>

    <li><%-- Go to: your control panel --%>
        <jive:i18n key="global.go_to" /><jive:i18n key="global.colon" />
        <a href="settings!default.jspa"><jive:i18n key="loginbox.your_control_panel" /></a>
    </li>
</ul>

<br><br>

</div>

<jsp:include page="footer.jsp" flush="true" />
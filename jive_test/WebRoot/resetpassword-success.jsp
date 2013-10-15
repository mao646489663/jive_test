<%--
  - $RCSfile: resetpassword-success.jsp,v $
  - $Revision: 1.6 $
  - $Date: 2003/05/27 21:31:13 $
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

        <span class="jive-page-title">
        <p>
        <jive:i18n key="resetpassword.title" />
        </p>
        </span>

    </td>
    <td width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>
    <td width="1%">

        <%@ include file="accountbox.jsp" %>

    </td>
</tr>
</table>

<br>

<p><jive:i18n key="resetpassword.success" /></p>

<%-- knowledge base home and login buttons --%>
<center>
<script language="JavaScript" type="text/javascript">
<!-- // cancel the form, go back to the index page
function loginForm() {
    window.location.href='login!default.jspa?referer=index.jsp';
}
//-->
</script>
<form action="index.jsp">
<input type="submit" name="index" value="<jive:i18n key="global.go_back_to_forum_list" />">
<input type="submit" name="login" value="<jive:i18n key="login.login_jive" />"
onclick="loginForm();return false;">
</form>
</center>

</div>

<jsp:include page="footer.jsp" flush="true" />
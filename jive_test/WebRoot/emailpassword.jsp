<%--
  - $RCSfile: emailpassword.jsp,v $
  - $Revision: 1.7 $
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

<p><jive:i18n key="resetpassword.howto_description" /></p>

<%-- error message --%>
<ww:if test="hasErrorMessages == true">
    <p>
        <ww:iterator value="errorMessages">
          <span class="jive-error-text"><ww:property /></span><br>
        </ww:iterator>
    </p>
</ww:if>

<%-- Email password form --%>
<form action="emailPasswordToken.jspa" method="get" name="resetForm">
<table class="jive-box" cellpadding="3" cellspacing="0" border="0" width="300" align="center">

<%-- username --%>
<tr>
    <td class="jive-label" width="40%">
        <jive:i18n key="global.username" /><jive:i18n key="global.colon" />
    </td>
    <td width="60%">
        <input type="text" class="jive-field" name="username" size="15" maxlength="50">
    </td>
</tr>

<%-- continue and cancel buttons --%>
<tr>
    <td class="jive-button-row" colspan="2" align="center" width="100%">
        <script language="JavaScript" type="text/javascript">
        <!-- // cancel the form, go back to the referring page
        function cancelForm() {
            window.location.href='login!default.jspa';
        }
        //-->
        </script>
        <input type="submit" value="<jive:i18n key="global.continue" />" name="saveButton"
        class="jive-main-button">
        <input type="submit" value="<jive:i18n key="global.cancel" />"
        onclick="cancelForm();return false;" class="jive-main-button">
    </td>
</tr>
</table>
</form>

</div>

<jsp:include page="footer.jsp" flush="true" />
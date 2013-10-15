<%--
  - $RCSfile: resetpassword.jsp,v $
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

<p><jive:i18n key="resetpassword.reset_description" /></p>

<%-- error message --%>
<ww:if test="hasErrorMessages == true">
    <p>
        <ww:iterator value="errorMessages">
          <span class="jive-error-text"><ww:property /></span><br>
        </ww:iterator>
    </p>
</ww:if>

<%-- reset password form --%>
<form action="resetPassword.jspa" method="post" name="resetForm">
<table class="jive-box" cellpadding="3" cellspacing="0" border="0" width="300" align="center">
<tr>
    <th colspan="2"><jive:i18n key="resetpassword.reset_password" /></td>
</tr>

<%-- user id --%>
<tr>
    <td class="jive-label" width="40%">
        <jive:i18n key="global.userid" /><jive:i18n key="global.colon" />
        <ww:if test="errors['userid']">
            <br>
            <span class="jive-error-text"><ww:property value="errors['userid']" /></span>
        </ww:if>
    </td>
    <td width="60%">
        <input type="text" name="userid" value="<ww:if test="userid > 1"><ww:property value="userid" /></ww:if>" size="15" maxlength="20">
    </td>
</tr>

<%-- password token --%>
<tr>
    <td class="jive-label" width="40%">
        <jive:i18n key="global.token" /><jive:i18n key="global.colon" />
        <ww:if test="errors['token']">
            <br>
            <span class="jive-error-text"><ww:property value="errors['token']" /></span>
        </ww:if>
    </td>
    <td width="60%">
        <input type="text" class="jive-field" name="token" size="15" maxlength="8" value="<ww:property value="token" />">
    </td>
</tr>

<%-- new password --%>
<tr>
    <td class="jive-label" width="40%">
        <jive:i18n key="global.new_password" /><jive:i18n key="global.colon" />
        <ww:if test="errors['newPassword']">
            <br>
            <span class="jive-error-text"><ww:property value="errors['newPassword']" /></span>
        </ww:if>
    </td>
    <td width="60%">
        <input type="password" class="jive-field" name="newPassword" size="15" maxlength="50">
    </td>
</tr>

<%-- confirm new password --%>
<tr>
    <td class="jive-label" width="40%">
        <jive:i18n key="global.confirm_password" /><jive:i18n key="global.colon" />
        <ww:if test="errors['confirmNewPassword']">
            <br>
            <span class="jive-error-text"><ww:property value="errors['confirmNewPassword']" /></span>
        </ww:if>
    </td>
    <td width="60%">
        <input type="password" class="jive-field" name="confirmNewPassword" size="15" maxlength="50">
    </td>
</tr>

<%-- save and cancel buttons --%>
<tr>
    <td class="jive-button-row" colspan="2" align="center" width="100%">
        <script language="JavaScript" type="text/javascript">
        <!-- // cancel the form, go back to the index page
        function cancelForm() {
            window.location.href='index.jsp';
        }
        //-->
        </script>
        <input type="submit" value="<jive:i18n key="global.reset" />" name="saveButton"
        class="jive-main-button">
        <input type="submit" value="<jive:i18n key="global.cancel" />"
        onclick="cancelForm();return false;" class="jive-cancel-button">
    </td>
</tr>
</table>

</div>

<jsp:include page="footer.jsp" flush="true" />
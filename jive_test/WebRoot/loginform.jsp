<%--
  -
  - $RCSfile: loginform.jsp,v $
  - $Revision: 1.20.2.1 $
  - $Date: 2003/06/17 03:41:49 $
  -
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
        <%-- User Login --%>
        <jive:i18n key="login.title" />
        </p>

    </td>
    <td width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>
    <td width="1%">

        <%@ include file="accountbox.jsp" %>

    </td>
</tr>
</table>

<br>

<%-- Print info messages if they exist --%>
<ww:if test="infoMessages/hasNext == true">
    <%@ include file="info-messages.jsp" %>
    <br><br>
</ww:if>

<%-- Print the error message if an error is flagged --%>
<ww:if test="hasErrorMessages == true">

    <table class="jive-error-message" cellpadding="3" cellspacing="0" border="0" width="350">
    <tr valign="top">
        <td width="1%"><img src="images/error-16x16.gif" width="16" height="16" border="0"></td>
        <td width="99%">

            <span class="jive-error-text">
            <jive:i18n key="login.invalid_username_or_password" />
            </span>

        </td>
    </tr>
    </table><br>

</ww:if>

<%-- Login using the form below. --%>
<jive:i18n key="login.description" />

<%  if (!"false".equals(JiveGlobals.getJiveProperty("skin.default.newAccountCreationEnabled"))) { %>

    <%--
        Or, <a href="account!default.jspa">create a new account</a>
        if you don't already have one.
    --%>
    <jive:i18n key="login.create_account">
        <jive:arg>
            <a href="account!default.jspa">
        </jive:arg>
        <jive:arg>
            </a>
        </jive:arg>
    </jive:i18n>

<%  } %>

<br><br>

<ww:bean name="'com.jivesoftware.webwork.util.Counter'" id="tabIndex" />

<table cellpadding="3" cellspacing="0" border="0" width="80%" align="center">

<form action="login.jspa" method="post" name="loginForm">

<tr>
    <td class="jive-label">
        <%-- Username: --%>
        <jive:i18n key="global.username" /><jive:i18n key="global.colon" />
    </td>
    <td>
        <input type="text" name="username" size="30" maxlength="150" value="" tabindex="<ww:property value="@tabIndex/next" />">
        <ww:if test="errors['username']">
            <span class="jive-error-text">
            <br>
            <%-- Invalid username --%>
            <jive:i18n key="login.error_username" />
            </span>
        </ww:if>
    </td>
</tr>
<tr>
    <td class="jive-label">
        <%-- Password: --%>
        <jive:i18n key="global.password" /><jive:i18n key="global.colon" />
    </td>
    <td>
        <input type="password" name="password" size="30" maxlength="150" value="" tabindex="<ww:property value="@tabIndex/next" />">
        <ww:if test="errors['password']">
            <span class="jive-error-text">
            <br>
            <%-- Invalid password --%>
            <jive:i18n key="login.error_password" />
            </span>
        </ww:if>
    </td>
</tr>
<tr>
    <td>&nbsp;</td>
    <td>
        <input type="checkbox" name="autoLogin" id="autoLoginCb" value="true" tabindex="<ww:property value="@tabIndex/next" />">
        <label for="autoLoginCb"><jive:i18n key="global.remember_me" /></label>
    </td>
</tr>
<jive:property if="passwordReset.enabled">
    <tr>
        <td>&nbsp;</td>
        <td>
            <%-- I forgot my password --%>
            <a href="emailPasswordToken!default.jspa"><jive:i18n key="login.reset_password" /></a>
        </td>
    </tr>
</jive:property>
<tr>
    <td>&nbsp;</td>
    <td>
        <br>
        <%-- Login --%>
        <input type="submit" name="doLogin" value="<jive:i18n key="global.login" />" tabindex="<ww:property value="@tabIndex/next" />">
        <%-- Cancel --%>
        <input type="submit" name="cancel" value="<jive:i18n key="global.cancel" />" tabindex="<ww:property value="@tabIndex/next" />">
    </td>
</tr>

</form>

<form action="account!default.jspa">

<tr>
    <td>&nbsp;</td>
    <td>
        <br>
        <%-- Login --%>
        <input type="submit" value="<jive:i18n key="global.create_account" />">
    </td>
</tr>

</form>

</table>

<script language="JavaScript" type="text/javascript">
<!--
    document.loginForm.username.focus();
//-->
</script>

</div>

<jsp:include page="footer.jsp" flush="true" />
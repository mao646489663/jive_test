<%--
  - $RCSfile: accountform.jsp,v $
  - $Revision: 1.18.2.1 $
  - $Date: 2003/06/08 18:57:52 $
  -
  - Copyright (C) 1999-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software.  Use is subject to license terms.
--%>

<%@ page import="com.jivesoftware.forum.action.*" %>

<%@ taglib uri="webwork" prefix="ww" %>
<%@ taglib uri="jivetags" prefix="jive" %>

<%@ include file="global.jsp" %>

<jsp:include page="header.jsp" flush="true" />



<%  // Get the action associated with this view:
    AccountAction action = (AccountAction)getAction(request);
%>
<div style="width:960px; margin:0px auto;">
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr valign="top">
    <td width="98%">

        <%-- Breadcrumbs (customizable via the admin tool) --%>

        <jsp:include page="breadcrumbs.jsp" flush="true" />

        <%-- Text describing your community (customizable via the admin tool) --%>

        <p class="jive-page-title">
        <%-- Create New Account --%>
        <jive:i18n key="account.title" />
        </p>

    </td>
    <td width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>
    <td width="1%">

        <%@ include file="accountbox.jsp" %>

    </td>
</tr>
</table>

<p>
<jive:i18n key="account.description" />
</p>

<ww:if test="hasErrorMessages == true">

    <p class="jive-error-text">
    <ww:iterator value="errorMessages">
        <ww:property />
    </ww:iterator>
    </p>

</ww:if>

<form action="account.jspa" method="post" name="accountform">
<input type="hidden" name="command" value="execute">

<ww:bean name="'com.jivesoftware.webwork.util.Counter'" id="tabIndex">
    <ww:param name="'first'" value="1" />
</ww:bean>

<%  // Variable for the tab index
    int tabIndex = 1;
%>

<div class="jive-account-form">
<table cellpadding="3" cellspacing="0" border="0">
<tr>
    <td class="jive-label" valign="top" rowspan="2">
        <span class="jive-required">
        <%-- Name: --%>
        <jive:i18n key="global.name" /><jive:i18n key="global.colon" />
        </span>
    </td>
    <td>
        <input type="text" name="name" size="40" maxlength="80" value="<%= ((action.getName() != null) ? action.getName() : "") %>"
         onfocus="this.select();" tabindex="<%= tabIndex++ %>">

        <ww:if test="errors['name']">
            <span class="jive-error-text">
            <br><ww:property value="errors['name']" />
            </span>
        </ww:if>
    </td>
</tr>
<tr>
    <td>
        <input type="radio" name="nameVisible" value="true" id="nv01"<%= ((action.getNameVisible()==Boolean.TRUE) ? " checked" : "") %>>
        <%-- Show --%>
        <label for="nv01"><jive:i18n key="global.show" /></label>
        &nbsp;
        <input type="radio" name="nameVisible" value="false" id="nv02"<%= ((action.getNameVisible()==Boolean.FALSE) ? " checked" : "") %>>
        <%-- Hide --%>
        <label for="nv02"><jive:i18n key="global.hide" /></label>
    </td>
</tr>
<tr>
    <td class="jive-label" valign="top" rowspan="2">
        <span class="jive-required">
        <%-- Email Address: --%>
        <jive:i18n key="global.email" /><jive:i18n key="global.colon" />
        </span>
    </td>
    <td>
        <input type="text" name="email" size="40" maxlength="80" value="<%= ((action.getEmail() != null) ? action.getEmail() : "") %>"
         onfocus="this.select();" tabindex="<%= tabIndex++ %>">

        <ww:if test="errors['email']">
            <span class="jive-error-text">
            <br><ww:property value="errors['email']" />
            </span>
        </ww:if>
    </td>
</tr>
<tr>
    <td>
        <input type="radio" name="emailVisible" value="true" id="ev01"<%= ((action.getEmailVisible()==Boolean.TRUE) ? " checked" : "") %>>
        <label for="ev01"><jive:i18n key="global.show" /></label>
        &nbsp;
        <input type="radio" name="emailVisible" value="false" id="ev02"<%= ((action.getEmailVisible()==Boolean.FALSE) ? " checked" : "") %>>
        <label for="ev02"><jive:i18n key="global.hide" /></label>
    </td>
</tr>
<tr>
    <td class="jive-label">
        <span class="jive-required">
        <%-- Desired Username: --%>
        <jive:i18n key="account.desired_username" /><jive:i18n key="global.colon" />
        </span>
    </td>
    <td>
        <input type="text" name="username" size="30" maxlength="30" value="<%= ((action.getUsername() != null) ? action.getUsername() : "") %>"
         onfocus="this.select();" tabindex="<%= tabIndex++ %>">

        <ww:if test="errors['username']">
            <span class="jive-error-text">
            <br><ww:property value="errors['username']" />
            </span>
        </ww:if>
    </td>
</tr>
<tr>
    <td class="jive-label">
        <span class="jive-required">
        <%-- Password: --%>
        <jive:i18n key="global.password" /><jive:i18n key="global.colon" />
        </span>
    </td>
    <td>
        <input type="password" name="password" size="15" maxlength="30" value="<%= ((action.getPassword() != null) ? action.getPassword() : "") %>"
         onfocus="this.select();" tabindex="<%= tabIndex++ %>">

        <ww:if test="errors['password']">
            <span class="jive-error-text">
            <br><ww:property value="errors['password']" />
            </span>
        </ww:if>
    </td>
</tr>
<tr>
    <td class="jive-label">
        <span class="jive-required">
        <%-- Confirm Password: --%>
        <jive:i18n key="global.confirm_password" /><jive:i18n key="global.colon" />
        </span>
    </td>
    <td>
        <input type="password" name="passwordConfirm" size="15" maxlength="30" value="<%= ((action.getPasswordConfirm() != null) ? action.getPasswordConfirm() : "") %>"
         onfocus="this.select();" tabindex="<%= tabIndex++ %>">

        <ww:if test="errors['passwordConfirm']">
            <span class="jive-error-text">
            <br><ww:property value="errors['passwordConfirm']" />
            </span>
        </ww:if>
    </td>
</tr>
<ww:elseIf test="errors['passwordMatch']">
<tr>
    <td>&nbsp;</td>
    <td>
        <span class="jive-error-text">
        <ww:property value="errors['passwordMatch']" />
        </span>
    </td>
</tr>
</ww:elseIf>
<tr>
    <td colspan="2">&nbsp;</td>
</tr>
<tr>
    <td class="jive-label">
        <%-- Location: --%>
        <jive:i18n key="global.location" /><jive:i18n key="global.colon" />
    </td>
    <td>
        <input type="text" name="location" size="30" maxlength="150"
         value="<%= ((action.getLocation() != null) ? action.getLocation() : "") %>"
         onfocus="this.select();" tabindex="<%= tabIndex++ %>">

        <ww:if test="errors['location']">
            <span class="jive-error-text">
            <br><ww:property value="errors['location']" />
            </span>
        </ww:if>
    </td>
</tr>
<tr>
    <td class="jive-label">
        <%-- Occupation: --%>
        <jive:i18n key="global.occupation" /><jive:i18n key="global.colon" />
    </td>
    <td>
        <input type="text" name="occupation" size="30" maxlength="150"
         value="<%= ((action.getOccupation() != null) ? action.getOccupation() : "") %>"
         onfocus="this.select();" tabindex="<%= tabIndex++ %>">

        <ww:if test="errors['occupation']">
            <span class="jive-error-text">
            <br><ww:property value="errors['occupation']" />
            </span>
        </ww:if>
    </td>
</tr>
<tr>
    <td class="jive-label">
        <%-- Homepage: --%>
        <jive:i18n key="global.homepage" /><jive:i18n key="global.colon" />
    </td>
    <td>
        <input type="text" name="homepage" size="30" maxlength="200"
         value="<%= ((action.getHomepage() != null) ? action.getHomepage() : "http://") %>"
         onfocus="this.select();" tabindex="<%= tabIndex++ %>">

        <ww:if test="errors['homepage']">
            <span class="jive-error-text">
            <br><ww:property value="errors['homepage']" />
            </span>
        </ww:if>
    </td>
</tr>
<tr>
    <td class="jive-label" valign="top">
        <%-- Biography: --%>
        <jive:i18n key="global.biography" /><jive:i18n key="global.colon" />
    </td>
    <td>
        <textarea name="biography" cols="30" rows="4" onfocus="this.select();" tabindex="<%= tabIndex++ %>"
         ><%= ((action.getBiography() != null) ? action.getBiography() : "") %></textarea>

        <ww:if test="errors['biography']">
            <span class="jive-error-text">
            <br><ww:property value="errors['biography']" />
            </span>
        </ww:if>
    </td>
</tr>
<%--
<tr>
    <td class="jive-label" valign="top" rowspan="2">
        <!-- Signature: -->
        <jive:i18n key="global.signature" /><jive:i18n key="global.colon" />
    </td>
    <td>
        <textarea name="signature" cols="30" rows="4" onfocus="this.select();" tabindex="<%= tabIndex++ %>"
         ><ww:if test="signature"><ww:property value="signature"/></ww:if></textarea>

        <ww:if test="errors['signature']">
            <span class="jive-error-text">
            <br><ww:property value="errors['signature']" />
            </span>
        </ww:if>
    </td>
</tr>
<tr>
    <td>
        <input type="radio" name="sigVisible" value="true" id="sv01"<ww:if test="signatureVisible==true"> checked</ww:if>>
        <label for="sv01"><jive:i18n key="global.show" /></label>
        &nbsp;
        <input type="radio" name="sigVisible" value="false" id="sv02"<ww:if test="signatureVisible!=true"> checked</ww:if>>
        <label for="sv02"><jive:i18n key="global.hide" /></label>
    </td>
</tr>
--%>
<tr>
    <td colspan="2">&nbsp;</td>
</tr>
<tr>
    <td class="jive-label">
        <%-- Auto-Login: --%>
        <jive:i18n key="global.auto_login" /><jive:i18n key="global.colon" />
    </td>
    <td>
        <input type="checkbox" name="autoLogin" id="cb01"<ww:if test="autoLogin == true"> checked</ww:if>>
        <%-- Remember Me --%>
        <label for="cb01"><jive:i18n key="global.remember_me" /></label>
    </td>
</tr>
<tr>
    <td colspan="2">&nbsp;</td>
</tr>
<tr>
    <td colspan="2">

        <input type="submit" name="doCreate" value="<jive:i18n key="global.create_account" />" tabindex="<%= tabIndex++ %>">
        &nbsp;
        <input type="submit" name="doCancel" value="<jive:i18n key="global.cancel" />" tabindex="<%= tabIndex++ %>">

    </td>
</tr>
</table>
</div>

</form>

<script language="JavaScript" type="text/javascript">
<!--
    document.accountform.name.focus();
//-->
</script>
</div>
<jsp:include page="footer.jsp" flush="true" />
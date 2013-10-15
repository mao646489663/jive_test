<%--
  - $RCSfile: editprofile.jsp,v $
  - $Revision: 1.19.2.2 $
  - $Date: 2003/07/25 04:19:31 $
  -
  - Copyright (C) 1999-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software.  Use is subject to license terms.
--%>

<%@ page import="com.jivesoftware.forum.action.*" %>

<%@ include file="global.jsp" %>

<%@ taglib uri="webwork" prefix="ww" %>
<%@ taglib uri="jivetags" prefix="jive" %>

<%  // Get the action assocated with this view. This is necessary to get a handle on the
    // internationalization methods.
    EditProfileAction action = (EditProfileAction)getAction(request);

    // Get the user of this page:
    User pageUser = action.getPageUser();
%>
<jsp:include page="header.jsp" flush="true" />

<div style="width:960px; margin:0px auto;">

<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr valign="top">
    <td width="98%">

        <%-- Breadcrumbs (customizable via the admin tool) --%>

        <jsp:include page="breadcrumbs.jsp" flush="true" />

        <%-- Forum name and brief info about the forum --%>

        <p class="jive-page-title">
        <%-- Edit Your Profile --%>
        <jive:i18n key="profile.edit" />
        </p>

        <%@ include file="back-link.jsp" %>

    </td>
    <td width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>
    <td width="1%">

        <%@ include file="accountbox.jsp" %>

    </td>
</tr>
</table>

<br>

<%  String selectedTab = action.getText("settings.your_profile"); %>
<%@ include file="tabs.jsp" %>

<br>

<a name="personal"></a>
<span class="jive-cp-header">
<%-- Personal Information --%>
<jive:i18n key="profile.personal_information" />
</span>
<br><br>

<%  int tabIndex = 0; %>

<form action="editprofile.jspa" method="post">
<input type="hidden" name="command" value="execute">

<div class="jive-cp-formbox">
<table cellpadding="3" cellspacing="0" border="0">
<tr>
    <td class="jive-label" valign="top">
        <%-- Username: --%>
        <jive:i18n key="global.username" /><jive:i18n key="global.colon" />
    </td>
    <td>
        <%= pageUser.getUsername() %>
    </td>
</tr>
<tr>
    <td class="jive-label" valign="top">
        <%-- Name: --%>
        <jive:i18n key="global.name" /><jive:i18n key="global.colon" />
    </td>
    <td>
        <input type="text" name="name" size="40" maxlength="80"
         value="<%= ((pageUser.getName() != null) ? pageUser.getName() : "") %>"
         onfocus="this.select();" tabindex="<%= tabIndex++ %>">

        <ww:if test="errors['name']">
            <span class="jive-error-text">
            <br>
            <%-- Please enter a valid name. --%>
            <jive:i18n key="edit.error_name" />
            </span>
        </ww:if>
    </td>
</tr>
<tr>
    <td>&nbsp;</td>
    <td>
        <input type="radio" name="nameVisible" value="true" id="nv01"<%= ((pageUser.isNameVisible()) ? " checked" : "") %>>
        <%-- Show --%>
        <label for="nv01"><jive:i18n key="global.show" /></label>
        &nbsp;
        <input type="radio" name="nameVisible" value="false" id="nv02"<%= ((pageUser.isNameVisible()) ? "" : " checked") %>>
        <%-- Hide --%>
        <label for="nv02"><jive:i18n key="global.hide" /></label>
    </td>
</tr>
<tr>
    <td class="jive-label" valign="top">
        <%-- Email Address: --%>
        <jive:i18n key="global.email" /><jive:i18n key="global.colon" />
    </td>
    <td>
        <input type="text" name="email" size="40" maxlength="80"
         value="<%= ((pageUser.getEmail() != null) ? pageUser.getEmail() : "") %>"
         onfocus="this.select();" tabindex="<%= tabIndex++ %>">

        <ww:if test="errors['email']">
            <span class="jive-error-text">
            <br>
            <%-- Please enter a valid email address. --%>
            <jive:i18n key="edit.error_email" />
            </span>
        </ww:if>
    </td>
</tr>
<tr>
    <td>&nbsp;</td>
    <td>
        <input type="radio" name="emailVisible" value="true" id="ev01"<%= ((pageUser.isEmailVisible()) ? " checked" : "") %>>
        <%-- Show --%>
        <label for="ev01"><jive:i18n key="global.show" /></label>
        &nbsp;
        <input type="radio" name="emailVisible" value="false" id="ev02"<%= ((pageUser.isEmailVisible()) ? "" : " checked") %>>
        <%-- Hide --%>
        <label for="ev02"><jive:i18n key="global.hide" /></label>
    </td>
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
    </td>
</tr>
<tr>
    <td class="jive-label">
        <%-- Homepage: --%>
        <jive:i18n key="global.homepage" /><jive:i18n key="global.colon" />
    </td>
    <td>
        <input type="text" name="homepage" size="30" maxlength="200"
         value="<%= ((action.getHomepage() != null) ? action.getHomepage() : "") %>"
         onfocus="this.select();" tabindex="<%= tabIndex++ %>">
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
    </td>
</tr>
<tr>
    <td>&nbsp;</td>
    <td>
        <input type="submit" name="doUpdateAccount" value="<jive:i18n key="profile.update_account" />">
    </td>
</tr>
</table>
</div>

<br>
<%  if (!"false".equals(JiveGlobals.getJiveProperty("skin.default.changePasswordEnabled"))) { %>

    <a name="password"></a>
    <span class="jive-cp-header">
    <%-- Change Password --%>
    <jive:i18n key="changepassword.title" />
    </span>
    <br><br>

    </form>

    <div class="jive-cp-formbox">
    <table cellpadding="3" cellspacing="0" border="0">
    <tr>
        <td class="jive-label">
            <%-- New Password: --%>
            <jive:i18n key="global.new_password" />
        </td>
        <td>
            <input type="password" name="password" size="15" maxlength="30" value="<%= ((action.getPassword() != null) ? action.getPassword() : "") %>"
             onfocus="this.select();" tabindex="<%= tabIndex++ %>">
        </td>
    </tr>
    <tr>
        <td class="jive-label">
            <%-- Confirm New Password: --%>
            <jive:i18n key="changepassword.confirm_new_password" />
        </td>
        <td>
            <input type="password" name="passwordConfirm" size="15" maxlength="30" value="<%= ((action.getPasswordConfirm() != null) ? action.getPasswordConfirm() : "") %>"
             onfocus="this.select();" tabindex="<%= tabIndex++ %>">
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td>
            <%-- Update Password --%>
            <input type="submit" name="doUpdatePassword" value="<jive:i18n key="changepassword.update_password" />">
        </td>
    </tr>
    </table>
    </div>

    <%  } %>

<br><br><br>
</div>

<jsp:include page="footer.jsp" flush="true" />
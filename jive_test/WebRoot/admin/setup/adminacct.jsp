<%
/**
 * $RCSfile: adminacct.jsp,v $
 * $Revision: 1.5 $
 * $Date: 2003/01/23 06:48:50 $
 *
 * Copyright (C) 1999-2002 Jive Software. All rights reserved.
 *
 * This software is the proprietary information of Jive Software. Use is subject to license terms.
 */
%>

<%@ page import="com.jivesoftware.forum.Version"%>

<%@ taglib uri="webwork" prefix="ww" %>

<%@ include file="global.jsp" %>

<%@ include file="header.jsp" %>

<p class="jive-setup-page-header">
Admin Account Setup
</p>

<p>
Enter settings for the system administrator account below. It is important choose a password for the
account that cannot be easily guessed -- for example, at least six characters long and containing a
mix of letters and numbers.
</p>

<form action="setup.adminacct!execute.jspa" name="acctform" method="post">

<table cellpadding="3" cellspacing="2" border="0">
<tr valign="top">
    <td class="jive-label">
        Current Password:
    </td>
    <td>
        <input type="text" name="currentPassword" size="20" maxlength="50"
         value="<ww:if test="currentPassword"><ww:property value="currentPassword" /></ww:if>">
        <span class="jive-description">
        <br>
        If this is a new Jive Forums installation, the current password will be <b>admin</b>.
        </span>
        <ww:if test="errors['currentPassword']">
            <span class="jive-error-text">
            <br><ww:property value="errors['currentPassword']" />
            </span>
        </ww:if>
    </td>
</tr>
<tr valign="top">
    <td class="jive-label">
        Admin Email Address:
    </td>
    <td>
        <input type="text" name="email" size="40" maxlength="150"
         value="<ww:if test="email"><ww:property value="email" /></ww:if>">
        <span class="jive-description">
        <br>
        A valid email address for the admin account.
        </span>
        <ww:if test="errors['email']">
            <span class="jive-error-text">
            <br><ww:property value="errors['email']" />
            </span>
        </ww:if>
    </td>
</tr>
<tr valign="top">
    <td class="jive-label">
        New Password:
    </td>
    <td>
        <input type="password" name="password" size="20" maxlength="50"
         value="<ww:if test="password"><ww:property value="password" /></ww:if>">
        <span class="jive-description">

        </span>
        <ww:if test="errors['password']">
            <span class="jive-error-text">
            <br><ww:property value="errors['password']" />
            </span>
        </ww:if>
    </td>
</tr>
<tr valign="top">
    <td class="jive-label">
        Confirm Password:
    </td>
    <td>
        <input type="password" name="confirmPassword" size="20" maxlength="50"
         value="<ww:if test="confirmPassword"><ww:property value="confirmPassword" /></ww:if>">
        <span class="jive-description">

        </span>
        <ww:if test="errors['confirmPassword']">
            <span class="jive-error-text">
            <br><ww:property value="errors['confirmPassword']" />
            </span>
        </ww:if>
    </td>
</tr>
</table>


<br><br>

<hr size="0">

<div align="right">
    <input type="submit" value=" Continue ">
    <input type="submit" name="doSkip" value="Skip This Step">
</div>

</form>

<script language="JavaScript" type="text/javascript">
<!--
document.acctform.currentPassword.focus();
//-->
</script>

<%@ include file="footer.jsp" %>
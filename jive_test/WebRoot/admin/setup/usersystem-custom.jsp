<%
/**
 * $RCSfile: usersystem-custom.jsp,v $
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
Custom User System
</p>

<p>
Enter the classnames of your custom classes below. A valid classname should be something like
<tt>com.mycompany.MyUserManager</tt>. Please see the developer's guide and Javadocs for more
information about defining your own user, group, and authentication managers.
</p>

<ww:if test="hasErrorMessages == true">

    <p class="jive-error-text">
    <ww:iterator value="errorMessages">
        <ww:property />
    </ww:iterator>
    </p>

</ww:if>

<form action="setup.usersystem!custom.jspa" method="post">

<span class="jive-custom-datasource">

<table cellpadding="3" cellspacing="0" border="0" width="100%">
<tr>
    <td>
        <span class="jive-label">
        UserManager implementation
        </span>
    </td>
</tr>
<tr>
    <td><ww:if test="errors['userClassname']">
            <span class="jive-error-text">
            <ww:property value="errors['userClassname']" />
            <br>
            </span>
        </ww:if>
        <input type="text" name="userClassname" size="60" maxlength="100" value="<ww:if test="userClassname"><ww:property value="userClassname" /></ww:if>">
    </td>
</tr>
<tr><td>&nbsp;</td></tr>
<tr>
    <td>
        <span class="jive-label">
        GroupManager implementation
        <br>
        </span>
    </td>
</tr>
<tr>
    <td><ww:if test="errors['groupClassname']">
            <span class="jive-error-text">
            <ww:property value="errors['groupClassname']" />
            <br>
            </span>
        </ww:if>
        <input type="text" name="groupClassname" size="60" maxlength="100" value="<ww:if test="groupClassname"><ww:property value="groupClassname" /></ww:if>">
    </td>
</tr>
<tr><td>&nbsp;</td></tr>
<tr>
    <td>
        <span class="jive-label">
        AuthFactory implementation
        <br>
        </span>
    </td>
</tr>
<tr>
    <td><ww:if test="errors['authClassname']">
            <span class="jive-error-text">
            <ww:property value="errors['authClassname']" />
            <br>
            </span>
        </ww:if>
        <input type="text" name="authClassname" size="60" maxlength="100" value="<ww:if test="authClassname"><ww:property value="authClassname" /></ww:if>">
    </td>
</tr>
</table>

<!--
<tr>
    <td width="1%" nowrap>
        GroupManager implementation:
    </td>
    <td width="99%">
        <input type="text" name="groupClassname" size="40" maxlength="100" value="<ww:if test="groupClassname"><ww:property value="groupClassname" /></ww:if>">
        <ww:if test="errors['groupClassname']">
            <span class="jive-error-text">
            <br>
            <ww:property value="errors['groupClassname']" />
            </span>
        </ww:if>
    </td>
</tr>
<tr>
    <td width="1%" nowrap>
        AuthFactory implementation:
    </td>
    <td width="99%">
        <input type="text" name="authClassname" size="40" maxlength="100" value="<ww:if test="authClassname"><ww:property value="authClassname" /></ww:if>">
        <ww:if test="errors['authClassname']">
            <span class="jive-error-text">
            <br>
            <ww:property value="errors['authClassname']" />
            </span>
        </ww:if>
    </td>
</tr>
</table>
-->

</span>

<br><br>

<hr size="0">

<div align="right"><input type="submit" value=" Continue "></div>

</form>

<%@ include file="footer.jsp" %>
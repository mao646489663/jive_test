<%
/**
 * $RCSfile: usersystem.jsp,v $
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
User, Group and Authentication Systems
</p>

<p>
Choose a user, group and authentication system below. Most installations should use the default
implementation. The other options can be used when you need to integrate Jive Forums with an
existing user database or authentication system.
</p>

<ww:if test="hasErrorMessages == true">

    <span class="jive-error-text">
    Error:
    <ul>
    <ww:iterator value="errorMessages">
        <li><ww:property />
    </ww:iterator>
    </ul>
    </span>

</ww:if>

<form action="setup.usersystem.jspa">
<input type="hidden" name="command" value="execute">

<table cellpadding="3" cellspacing="2" border="0" width="100%">
<tr valign="top">
    <td width="1%">
        <input type="radio" name="mode" value="standard" id="rb01"<ww:if test="mode == 'standard'"> checked</ww:if>
    </td>
    <td width="99%">
        <label for="rb01">
        Default
        </label>
        - Use the Jive Forums default user, group and authentication implementations.
    </td>
</tr>
<tr valign="top">
    <td width="1%">
        <input type="radio" name="mode" value="custom" id="rb02"<ww:if test="mode == 'custom'"> checked</ww:if>>
    </td>
    <td width="99%">
        <label for="rb02">
        Custom
        </label>
        - Specify a custom user, group or authentication implementation.
    </td>
</tr>
</table>

<br><br>

<hr size="0">

<div align="right"><input type="submit" value=" Continue "></div>

</form>

<%@ include file="footer.jsp" %>
<%
/**
 * $RCSfile: email.jsp,v $
 * $Revision: 1.7 $
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
Email Settings
</p>

<p>
For email watch updates, password resetting and other features, Jive Forums needs a way to connect
to an email (SMTP) server. Please enter your email settings below. Advanced settings can be found
in the main admin tool. You can skip this step by clicking "Skip This Step" below.
</p>

<form action="setup.email!execute.jspa">

<table cellpadding="3" cellspacing="2" border="0">
<tr valign="top">
    <td class="jive-label" nowrap>
        Email Host:
    </td>
    <td>
        <input type="text" name="host" size="40" maxlength="150"
         value="<ww:if test="host"><ww:property value="host" /></ww:if>">
        <span class="jive-description">
        <br>
        A valid SMTP host, ie: myemailserver.com.
        </span>
        <ww:if test="errors['host']">
            <span class="jive-error-text">
            <br><ww:property value="errors['host']" />
            </span>
        </ww:if>
    </td>
</tr>
<tr valign="top">
    <td class="jive-label" nowrap>
        Email Port:
    </td>
    <td>
        <input type="text" name="port" size="5" maxlength="7"
         value="<ww:if test="port"><ww:property value="port" /></ww:if>">
        <span class="jive-description">
        <br>
        A valid SMTP port. Default is 25 (recommended).
        </span>
        <ww:if test="errors['port']">
            <span class="jive-error-text">
            <br><ww:property value="errors['port']" />
            </span>
        </ww:if>
    </td>
</tr>
<tr valign="top">
    <td class="jive-label" nowrap>
        Site URL:
    </td>
    <td>
        <input type="text" name="jiveURL" size="40" maxlength="150"
         value="<ww:if test="jiveURL"><ww:property value="jiveURL" /></ww:if>">
        <span class="jive-description">
        <br>
        Emails sent by Jive Forums include links for the user to follow back to the application.
        Specify the URL for your Jive Forums installation (e.g. http://www.example.com/jive3).
        </span>
        <ww:if test="errors['jiveURL']">
            <span class="jive-error-text">
            <br><ww:property value="errors['jiveURL']" />
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

<%@ include file="footer.jsp" %>
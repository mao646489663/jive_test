
<%@ page import="com.jivesoftware.forum.Version"%>

<html>
<head>
	<title>Jive Forums Setup</title>

	<link rel="stylesheet" type="text/css" href="style.css">
</head>

<body>

<span class="jive-setup-header">
<table cellpadding="8" cellspacing="0" border="0" width="100%">
<tr>
    <td width="99%">
        Jive Forums 3 Setup
    </td>
    <td width="1%" nowrap>
        <font size="-2" face="arial,helvetica,sans-serif" color="#ffffff">
        <b>
        Jive Forums <%= Version.getEdition().getName() %>
        <%= Version.getVersionNumber() %>
        </b>
        </font>
    </td>
</tr>
</table>
</span>
<table bgcolor="#bbbbbb" cellpadding="0" cellspacing="0" border="0" width="100%">
<tr><td><img src="images/blank.gif" width="1" height="1" border="0"></td></tr>
</table>
<table bgcolor="#dddddd" cellpadding="0" cellspacing="0" border="0" width="100%">
<tr><td><img src="images/blank.gif" width="1" height="1" border="0"></td></tr>

</table>
<table bgcolor="#eeeeee" cellpadding="0" cellspacing="0" border="0" width="100%">
<tr><td><img src="images/blank.gif" width="1" height="1" border="0"></td></tr>
</table>

<br>

<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr valign="top">

    <td width="98%">

<p class="jive-setup-page-header">
Setup Already Run
</p>

<p>
It appears setup has already been run. To administer your community, please use the
<a href="../">Jive Forums Admin Tool</a>. To re-run
setup, you need to stop your appserver, delete the "setup" property from the jive_config.xml file,
restart your appserver then reload the setup tool.
</p>

<form action="../index.jsp">

<br><br>

<center>
<input type="submit" value="Login to Admin Tool">
</center>

</form>


<%@ include file="footer.jsp"%>
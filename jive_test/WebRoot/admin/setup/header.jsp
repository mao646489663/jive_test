<%
/**
 * $RCSfile: header.jsp,v $
 * $Revision: 1.7 $
 * $Date: 2003/01/23 06:48:50 $
 *
 * Copyright (C) 1999-2002 Jive Software. All rights reserved.
 *
 * This software is the proprietary information of Jive Software. Use is subject to license terms.
 */
%>

<%@ page import="com.jivesoftware.forum.Version"%>

<html>
<head>
	<title>Jive Forums <%= Version.getEdition().getName() %> Setup</title>
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
    <%  if (showSidebar) { %>
        <td width="1%" nowrap>
            <jsp:include page="sidebar.jsp" flush="true" />
        </td>
        <td width="1%" nowrap><img src="images/blank.gif" width="15" height="1" border="0"></td>
    <%  } %>
    <td width="98%">
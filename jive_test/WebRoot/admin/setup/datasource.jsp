<%
/**
 * $RCSfile: datasource.jsp,v $
 * $Revision: 1.7 $
 * $Date: 2003/04/22 04:27:19 $
 *
 * Copyright (C) 1999-2002 Jive Software. All rights reserved.
 *
 * This software is the proprietary information of Jive Software. Use is subject to license terms.
 */
%>

<%@ page import="com.jivesoftware.forum.Version,
                 com.jivesoftware.forum.action.setup.DatasourceSetupAction"%>

<%@ taglib uri="webwork" prefix="ww" %>

<%@ include file="global.jsp" %>

<%@ include file="header.jsp" %>

<p class="jive-setup-page-header">
Database Settings
</p>

<p>
Choose how you'd like to connect to the Jive Forums database.
</p>

<form action="setup.datasource!execute.jspa">

<table cellpadding="3" cellspacing="2" border="0">
<tr>
    <td align="center" valign="top">
        <input type="radio" name="mode" value="thirdparty" id="rb02"<ww:if test="mode == 'thirdparty'"> checked</ww:if>>
    </td>
    <td>
        <label for="rb02"><b>Standard Database Connection</b></label> -
        Use an external database with the built-in connection pool.
    </td>
</tr>
<tr>
    <td align="center" valign="top">
        <input type="radio" name="mode" value="datasource" id="rb03"<ww:if test="mode == 'datasource'"> checked</ww:if>>
    </td>
    <td>
        <label for="rb03"><b>JNDI Datasource</b></label> -
        Use a datasource defined by your application server via JNDI.
    </td>
</tr>
<tr>
    <td align="center" valign="top">
        <input type="radio" name="mode" value="embedded" id="rb01"<ww:if test="mode == 'embedded'"> checked</ww:if>>
    </td>
    <td>
        <label for="rb01"><b>Embedded Database</b></label> -
        Use the embedded database, powered by hsqldb. This option is not recommended for
        large communities.
    </td>
</tr>
</table>

<br><br>

<hr size="0">

<div align="right"><input type="submit" value=" Continue "></div>

</form>

<%@ include file="footer.jsp" %>
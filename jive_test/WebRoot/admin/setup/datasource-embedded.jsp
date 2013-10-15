<%
/**
 * $RCSfile: datasource-embedded.jsp,v $
 * $Revision: 1.4 $
 * $Date: 2003/01/23 06:48:50 $
 *
 * Copyright (C) 1999-2002 Jive Software. All rights reserved.
 *
 * This software is the proprietary information of Jive Software. Use is subject to license terms.
 */
%>

<%@ page import="com.jivesoftware.forum.Version,
                 com.jivesoftware.forum.action.setup.DatasourceSetupAction,
                 com.jivesoftware.base.JiveGlobals,
                 java.io.File,
                 com.jivesoftware.util.StringUtils"%>

<%@ taglib uri="webwork" prefix="ww" %>

<%@ include file="global.jsp" %>

<%@ include file="header.jsp" %>

<p class="jive-setup-page-header">
Embedded Database Settings
</p>

<ww:if test="hasErrorMessages == true">

    There was an error configuring the embedded database. For more information,
    please check the error log located at:
    <%= StringUtils.replace(JiveGlobals.getJiveHome(),"\\\\","\\")
        + File.separator + "logs" + File.separator + "jive.error.log" %>

</ww:if>
<ww:else>

    The embedded database has been configured and works properly.

    <br><br>

    <hr size="0">

    <form action="setup.email!default.jspa">

    <div align="right"><input type="submit" value=" Continue "></div>

    </form>

</ww:else>

<%@ include file="footer.jsp" %>
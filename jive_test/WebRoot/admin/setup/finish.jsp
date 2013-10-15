<%
/**
 * $RCSfile: finish.jsp,v $
 * $Revision: 1.4 $
 * $Date: 2003/01/23 06:48:50 $
 *
 * Copyright (C) 1999-2002 Jive Software. All rights reserved.
 *
 * This software is the proprietary information of Jive Software. Use is subject to license terms.
 */
%>

<%@ page import="com.jivesoftware.forum.Version,
                 com.jivesoftware.base.JiveGlobals"%>

<%@ taglib uri="webwork" prefix="ww" %>

<%  boolean showSidebar = false; %>

<%@ include file="header.jsp" %>

<p class="jive-setup-page-header">
Jive Forums Setup Complete!
</p>

<p>
This installation of Jive Forums is now complete. To continue, click the button below
to exit this tool and login to the Jive Forums Admin tool.
</p>

<form action="../index.jsp">

<br><br>

<center>
<input type="submit" value="Login to Admin Tool">
</center>

</form>

<%@ include file="footer.jsp" %>
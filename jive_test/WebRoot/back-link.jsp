<%--
  - $RCSfile: back-link.jsp,v $
  - $Revision: 1.7 $
  - $Date: 2003/05/27 21:28:20 $
  -
  - Copyright (C) 1999-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software.  Use is subject to license terms.
--%>

<%@ page import="com.jivesoftware.base.action.util.RedirectAction" %>

<%  String previousURL = RedirectAction.getPreviousURL(request);
    if (previousURL != null) {
%>
    <!--

    <table cellpadding="3" cellspacing="0" border="0">
    <tr>
        <td><img src="images/back-to-16x16.gif" width="16" height="16" border="0"></td>
        <td>
            <%-- Go Back --%>
            <a href="<%= previousURL %>"><jive:i18n key="global.go_back" /></a>
        </td>
    </tr>
    </table>

    -->

<%  } %>
<%--
  - $RCSfile: footer.jsp,v $
  - $Revision: 1.12.2.2 $
  - $Date: 2003/06/30 23:10:33 $
  -
  - Copyright (C) 1999-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software.  Use is subject to license terms.
--%>

<%@ page import="com.jivesoftware.forum.*,
                 com.jivesoftware.forum.util.*,
                 java.util.*,
                 com.jivesoftware.base.*"
%>

<%  // Set the content type
    response.setContentType("text/html; charset=" + JiveGlobals.getCharacterEncoding());

    // Load the resource bundle used for this skin.
    String bundleName = "jive_forums_i18n";
    try {
        ResourceBundle bundle = ResourceBundle.getBundle(bundleName, JiveGlobals.getLocale());
        // Put the bundle in the request as an attribute:
        request.setAttribute("jive.i18n.bundle", bundle);
    }
    catch (MissingResourceException mre) {
        Log.error("Unable to load bundle, basename '" + bundleName + "'");
    }
%>

<%@ taglib uri="jivetags" prefix="jive" %>

<br><br>

<table id="jive-footer" cellpadding="6" cellspacing="0" border="0" width="100%">
<tr>
    <td>
        <%-- Forum Home --%>
        <a href="index.jspa"><jive:i18n key="global.forum_home" /></a>
        |
        <%-- Login --%>
        <a href="login!default.jspa"><jive:i18n key="global.login" /></a>

        <%  if (!"false".equals(JiveGlobals.getJiveProperty("skin.default.newAccountCreationEnabled"))) { %>
            |
            <%-- create account --%>
            <a href="account!default.jspa"><jive:i18n key="global.create_account" /></a>
        <%  } %>
        |
        <%-- Help --%>
        <a href="help.jspa"><jive:i18n key="global.help" /></a>

        <%  if (!"false".equals(JiveGlobals.getJiveProperty("search.enabled"))) { %>
            |
            <%-- Search --%>
            <a href="search!default.jspa"><jive:i18n key="global.search" /></a>
        <%  } %>

        <br>
        <%-- Powered by Jive Software --%>
        <a href="http://www.jivesoftware.com/poweredby/" target="_blank"><jive:i18n key="footer.powered_by" /></a>
    </td>
</tr>
</table>

</body>
</html>


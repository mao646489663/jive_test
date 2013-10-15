<%
/**
 *	$RCSfile: error.jsp,v $
 *	$Revision: 1.4.10.2 $
 *	$Date: 2003/07/24 19:03:15 $
 */
%>

<%@ page import="java.io.*,
                 com.jivesoftware.forum.*,
                 com.jivesoftware.forum.util.*,
                 com.jivesoftware.base.*,
                 com.jivesoftware.util.ParamUtils"
    isErrorPage="true"
%>

<font size="-1" face="arial,helvetica,sans-serif">
<b>Jive Forums <%= Version.getEdition() %> <%= Version.getVersionNumber() %> Admin Error</b>
</font>
<hr size="0">

<%  boolean debug = "true".equals(JiveGlobals.getJiveProperty("skin.default.debug"));
    if (debug) {
        exception.printStackTrace();
    }
%>

<%  if (exception instanceof LicenseException) {

%>
    <font size="-1" face="arial,helvetica,sans-serif">
    This copy of Jive Forums has expired.
    </font>

<%  } else if (exception instanceof UnauthorizedException) {
        String message = exception.getMessage();
        if (message == null) {
            message = "You don't have admin privileges to perform this operation.";
        }
%>
    <font size="-1" face="arial,helvetica,sans-serif">
    <%= message %>
    </font>

<%  } else if (exception instanceof ForumNotFoundException) {
        long forumID = ParamUtils.getLongParameter(request,"forum",-1L);
%>

    <font size="-1" face="arial,helvetica,sans-serif">
    The requested forum
    <%  if (forumID != -1L) { %>
        (id: <%= forumID %>)
    <%  } %>
    was not found.
    </font>

<%  } else if (exception instanceof ForumThreadNotFoundException) {
        long threadID = ParamUtils.getLongParameter(request,"thread",-1L);
%>

    <font size="-1" face="arial,helvetica,sans-serif">
    The requested forum thread
    <%  if (threadID != -1L) { %>
        (id: <%= threadID %>)
    <%  } %>
    was not found.
    </font>

<%  } else if (exception instanceof UserNotFoundException) {
        String user = ParamUtils.getParameter(request,"user");
%>

    <font size="-1" face="arial,helvetica,sans-serif">
    The requested user
    <%  if (user != null) { %>
        (id: <%= user %>)
    <%  } %>
    was not found.
    </font>

<%  } else if (exception instanceof GroupNotFoundException) { %>

    <font size="-1" face="arial,helvetica,sans-serif">
    <%= exception.getMessage() %>
    </font>
    
<%  } else {
        exception.printStackTrace();

        String msg = exception.getMessage();
        if (msg != null) {
%>
        <%= msg %>

<%      }
    }
%>

</body>
</html>

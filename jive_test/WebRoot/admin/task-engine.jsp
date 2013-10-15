<%--
  -
  - $RCSfile: task-engine.jsp,v $
  - $Revision: 1.1 $
  - $Date: 2003/05/22 15:26:38 $
  -
--%>

<%@ page import="com.jivesoftware.util.ParamUtils,
                 com.jivesoftware.util.EmailTask,
                 com.jivesoftware.util.TaskEngine,
                 com.jivesoftware.util.SmtpProxy,
                 javax.mail.internet.MimeMessage,
                 javax.mail.Message,
                 javax.mail.internet.InternetAddress,
                 javax.mail.MessagingException,
                 javax.mail.AuthenticationFailedException"
    errorPage="error.jsp"
%>

<%@ include file="global.jsp" %>

<%	// Permission check
    if (!isSystemAdmin) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }
%>

<%@ include file="header.jsp" %>

<%  // Title of this page and breadcrumbs
    String title = "Task Engine Monitor";
    String[][] breadcrumbs = {
        {"Main", "main.jsp"},
        {title, "task-engine.jsp"}
    };
%>
<%@ include file="title.jsp" %>

Below is the current state of the task engine.

<br><br>

<table cellpadding="3" cellspacing="1" border="0" width="400" style="border:1px #ccc solid;">
<tr>
    <td width="1%" nowrap bgcolor="#eeeeee" style="padding-left:10px;">
        Available workers:
    </td>
    <td width="99%">
        <%= TaskEngine.getNumWorkers() %>
    </td>
</tr>
<tr>
    <td width="1%" nowrap bgcolor="#eeeeee" style="padding-left:10px;">
        Number of current workers:
    </td>
    <td width="99%">
        <%= TaskEngine.size() %>
    </td>
</tr>
</table>

<%@ include file="footer.jsp" %>
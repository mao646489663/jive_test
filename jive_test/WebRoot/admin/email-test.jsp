<%--
  -
  - $RCSfile: email-test.jsp,v $
  - $Revision: 1.3.2.1 $
  - $Date: 2003/06/17 22:07:24 $
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

    // Get paramters
    boolean doTest = request.getParameter("test") != null;
    boolean cancel = request.getParameter("cancel") != null;
    boolean sent = ParamUtils.getBooleanParameter(request,"sent");
    boolean success = ParamUtils.getBooleanParameter(request,"success");
    String from = ParamUtils.getParameter(request,"from");
    String to = ParamUtils.getParameter(request,"to");
    String subject = ParamUtils.getParameter(request,"subject");
    String body = ParamUtils.getParameter(request,"body");

    // Cancel if requested
    if (cancel) {
        response.sendRedirect("email.jsp");
        return;
    }

    // Variable to hold messaging exception, if one occurs
    Exception mex = null;

    // Validate input
    Map errors = new HashMap();
    if (doTest) {
        if (from == null) { errors.put("from",""); }
        if (to == null) { errors.put("to",""); }
        if (subject == null) { errors.put("subject",""); }
        if (body == null) { errors.put("body",""); }

        // Get mail server props:
        String host = JiveGlobals.getJiveProperty("mail.smtp.host");
        int port = 25;
        try {
            port = Integer.parseInt(JiveGlobals.getJiveProperty("mail.smtp.port"));
        }
        catch (NumberFormatException ignored) {}
        String username = JiveGlobals.getJiveProperty("mail.smtp.username");
        String password = JiveGlobals.getJiveProperty("mail.smtp.password");
        boolean sslEnabled = "true".equals(JiveGlobals.getJiveProperty("mail.smtp.ssl"));

        // Validate host - at a minimum, it needs to be set:
        if (host == null) {
            errors.put("host","");
        }

        // if no errors, continue
        if (errors.size() == 0) {
            // Create a new email task
            SmtpProxy smtp = new SmtpProxy();
            smtp.setDebugEnabled(true);
            smtp.setHost(host);
            smtp.setPort(port);
            if (username != null) {
                smtp.setUsername(username);
            }
            if (password != null) {
                smtp.setPassword(password);
            }
            smtp.setSSLEnabled(sslEnabled);
            // create a message:
            MimeMessage message = smtp.createMessage();
            // set to and from
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(to, null));
            message.setFrom(new InternetAddress(from, null));
            message.setSubject(subject);
            message.setText(body);
            // Send the message, wrap in a try/catch:
            try {
                ArrayList messages = new ArrayList(1);
                messages.add(message);
                smtp.send(messages);
                // success, so indicate this:
                response.sendRedirect("email-test.jsp?sent=true&success=true");
                return;
            }
            catch (MessagingException me) {
                me.printStackTrace();
                mex = me;
            }
        }
    }

    // Set var defaults
    if (from == null) {
        from = pageUser.getEmail();
    }
    if (to == null) {
        to = pageUser.getEmail();
    }
    if (subject == null) {
        subject = "Test email sent via Jive Forums";
    }
    if (body == null) {
        body = "This is a test message.";
    }
%>

<%@ include file="header.jsp" %>

<%  // Title of this page and breadcrumbs
    String title = "Send Test Email";
    String[][] breadcrumbs = {
        {"Main", "main.jsp"},
        {"Email Settings", "email.jsp"},
        {title, "email-test.jsp"}
    };
%>
<%@ include file="title.jsp" %>

<%  if (doTest || sent) { %>

    <table bgcolor="#cccccc" cellpadding="1" cellspacing="0" border="0">
    <tr><td>
        <table bgcolor="#eeeeee" cellpadding="4" cellspacing="0" border="0">
        <tr><td>

            <%  if (success) { %>

                <b>Message was sent successfully!</b> Verify it was sent by checking the mail
                account you sent the message to.

            <%  } else { %>

                <b>Sending message failed.</b>

                <%  if (mex != null) { %>

                    <%  if (mex instanceof AuthenticationFailedException) { %>

                        Authenticating to the SMTP server failed - make sure your username
                        and password are correct, or that "guest" users can authenticate
                        to send emails.

                    <%  } else { %>

                        <%= mex.getMessage() %>

                    <%  } %>

                <%  } %>

            <%  } %>

            </td>
        </tr>
        </table>
        </td>
    </tr>
    </table>

    <br>

<%  } %>

Use the form below to send a test message.

<br><br>

<script language="JavaScript" type="text/javascript">
var clicked = false;
function checkClick(el) {
    if (!clicked) {
        clicked = true;
        return true;
    }
    return false;
}
</script>

<form action="email-test.jsp" method="post" name="f" onsubmit="return checkClick(this);">

<table cellpadding="3" cellspacing="0" border="0">
<tr>
    <td>
        From:
    </td>
    <td>
        <input type="text" name="from" value="<%= ((from!=null) ? from : "") %>"
         size="40" maxlength="100">
    </td>
</tr>
<tr>
    <td>
        To:
    </td>
    <td>
        <input type="text" name="to" value="<%= ((to!=null) ? to : "") %>"
         size="40" maxlength="100">
    </td>
</tr>
<tr>
    <td>
        Subject:
    </td>
    <td>
        <input type="text" name="subject" value="<%= ((subject!=null) ? subject : "") %>"
         size="40" maxlength="100">
    </td>
</tr>
<tr valign="top">
    <td>
        Body:
    </td>
    <td>
        <textarea name="body" cols="45" rows="5" wrap="virtual"><%= body %></textarea>
    </td>
</tr>
<tr>
    <td colspan="2">
        <br>
        <input type="submit" name="test" value="Send Email">
        <input type="submit" name="cancel" value="Cancel/Go Back">
    </td>
</tr>
</table>

</form>

<%@ include file="footer.jsp" %>
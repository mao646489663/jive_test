<%--
  -
  - $RCSfile: email.jsp,v $
  - $Revision: 1.6 $
  - $Date: 2003/05/15 05:39:05 $
  -
--%>

<%@ page import="com.jivesoftware.util.ParamUtils"
    errorPage="error.jsp"
%>

<%@ include file="global.jsp" %>

<%	// Permission check
    if (!isSystemAdmin) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }

    // get parameters
    String host = ParamUtils.getParameter(request,"host");
    String port = ParamUtils.getParameter(request,"port");
    String username = ParamUtils.getParameter(request,"username");
    String password = ParamUtils.getParameter(request,"password");
    boolean ssl = ParamUtils.getBooleanParameter(request,"ssl");
    boolean save = request.getParameter("save") != null;
    boolean test = request.getParameter("test") != null;
    boolean success = ParamUtils.getBooleanParameter(request,"success");
    boolean debug = ParamUtils.getBooleanParameter(request, "debug");
    String jiveURL = ParamUtils.getParameter(request,"jiveURL");
    boolean isProfessional = false;
    boolean errors = false;

    try {
        LicenseManager.validateLicense("Jive Forums Professional","3.0");
        isProfessional = true;
    }
    catch (Exception e) {}

    // Handle a test request
    if (test) {
        response.sendRedirect("email-test.jsp");
        return;
    }

    // save the email settings if requested
    if (save) {
        if (host != null) {
            JiveGlobals.setJiveProperty("mail.smtp.host", host);
        }
        else {
            errors = true;
        }
        if (port != null) {
            try {
                int p = Integer.parseInt(port);
                if (p > 0) {
                    JiveGlobals.setJiveProperty("mail.smtp.port", port);
                }
            }
            catch (Exception e) {}
        }
        else {
            JiveGlobals.deleteJiveProperty("mail.smtp.port");
        }
        if (username != null) {
            JiveGlobals.setJiveProperty("mail.smtp.username", username);
        }
        else {
            JiveGlobals.deleteJiveProperty("mail.smtp.username");
        }
        if (password != null) {
            JiveGlobals.setJiveProperty("mail.smtp.password", password);
        }
        else {
            JiveGlobals.deleteJiveProperty("mail.smtp.password");
        }
        if (jiveURL != null && !"".equals(jiveURL.trim())) {
            JiveGlobals.setJiveProperty("mail.jiveURL", jiveURL.trim());
        }
        else {
            errors = true;
        }
        JiveGlobals.setJiveProperty("mail.debug", ""+debug);
        if (isProfessional) {
            if (ssl) {
                JiveGlobals.setJiveProperty("mail.smtp.ssl", ""+ssl);
            }
            else {
                JiveGlobals.deleteJiveProperty("mail.smtp.ssl");
            }
        }

        if (!errors) {
            success = true;
        }
    }

    host = JiveGlobals.getJiveProperty("mail.smtp.host");
    port = JiveGlobals.getJiveProperty("mail.smtp.port");
    username = JiveGlobals.getJiveProperty("mail.smtp.username");
    password = JiveGlobals.getJiveProperty("mail.smtp.password");
    ssl = "true".equals(JiveGlobals.getJiveProperty("mail.smtp.ssl"));
    debug = "true".equals(JiveGlobals.getJiveProperty("mail.debug"));
    jiveURL = JiveGlobals.getJiveProperty("mail.jiveURL");
%>

<%@ include file="header.jsp" %>

<%  // Title of this page and breadcrumbs
    String title = "Email Settings";
    String[][] breadcrumbs = {
        {"Main", "main.jsp"},
        {title, "email.jsp"}
    };
%>
<%@ include file="title.jsp" %>

Use the form below to set email settings for Jive. At a minimum, you should
set the SMTP host. If you have problems sending email, please check
the SMTP configuration on your mail server.

<%  if (success) { %>

    <p style="color:#090;">
    SMTP settings updated successfully.
    </p>

<%  } %>

<%  // print error messages
	if( !success && errors ) {
%>
	<p class="jive-error-text">
    An error occured. Please verify that you have filled out all required fields correctly
    and try again.
	</p>
<%	} %>

<p>

<form action="email.jsp" name="f">

<b>SMTP Settings</b>

<ul>
    <table cellpadding="3" cellspacing="0" border="0">
    <tr>
        <td width="1%" nowrap>
            SMTP Host:
        </td>
        <td width="99%">
            <input type="text" name="host" value="<%= (host!=null)?host:"" %>" size="40" maxlength="150">
        </td>
    </tr>
    <tr>
        <td width="1%" nowrap>
            SMTP Port (Optional):
        </td>
        <td width="99%">
            <input type="text" name="port" value="<%= (port!=null)?port:"" %>" size="10" maxlength="15">
        </td>
    </tr>
    <tr>
        <td width="1%" nowrap>
            Mail Debugging:
        </td>
        <td width="99%">
            <input type="radio" name="debug" value="true"<%= (debug?" checked":"") %> id="rb01"> <label for="rb01">On</label>
            &nbsp;
            <input type="radio" name="debug" value="false"<%= (debug?"":" checked") %> id="rb02"> <label for="rb02">Off</label>
            &nbsp; (may require appserver restart)

        </td>
    </tr>

    <%-- spacer --%>
    <tr><td colspan="2">&nbsp;</td></tr>

    <tr>
        <td width="1%" nowrap>
            SMTP Username (Optional):
        </td>
        <td width="99%">
            <input type="text" name="username" value="<%= (username!=null)?username:"" %>" size="40" maxlength="150">
        </td>
    </tr>
    <tr>
        <td width="1%" nowrap>
            SMTP Password (Optional):
        </td>
        <td width="99%">
            <input type="password" name="password" value="<%= (password!=null)?password:"" %>" size="40" maxlength="150">
        </td>
    </tr>

    <%  if (isProfessional) { %>

        <tr>
            <td width="1%" nowrap>
                Use SSL (Optional):
            </td>
            <td width="99%">
                <input type="checkbox" name="ssl"<%= (ssl)?" checked":"" %>>
            </td>
        </tr>

    <%  } %>

    <%-- spacer --%>
    <tr><td colspan="2">&nbsp;</td></tr>

    <tr>
        <td colspan="2">
            Emails sent by Jive Forums include links for the user to follow back to the application.
            Specify the URL for your Jive Forums installation (e.g. http://www.example.com/jive3).
        </td>
    </tr>

    <%-- spacer --%>
    <tr><td colspan="2">&nbsp;</td></tr>

    <tr>
        <td width="1%" nowrap>
            URL to your installation:
        </td>
        <td width="99%">
            <input type="text" name="jiveURL" value="<%= (jiveURL!=null)?jiveURL:"" %>" size="40" maxlength="150">
        </td>
    </tr>
    </table>
</ul>

<br>

<input type="submit" name="save" value="Save Changes">
<input type="submit" name="test" value="Send Test Email...">

</form>

<%@ include file="footer.jsp" %>
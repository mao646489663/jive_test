<%
    /**
     *	$RCSfile: importGateway.jsp,v $
     *	$Revision: 1.1.8.1 $
     *	$Date: 2003/07/24 19:03:18 $
     */
%>

<%@ page import="java.util.*,
                     java.text.*,
                     com.jivesoftware.util.*,
                     com.jivesoftware.forum.*,
                     com.jivesoftware.forum.gateway.*,
                     com.jivesoftware.forum.util.*,
                 com.jivesoftware.base.UnauthorizedException"
    errorPage="error.jsp"
%>

<%@ include file="global.jsp" %>

<%	// get parameters
    long forumID = ParamUtils.getLongParameter(request,"forum",-1L);
    boolean doRunOnce = ParamUtils.getBooleanParameter(request, "doRunOnce");
    String exportAfter = ParamUtils.getParameter(request, "exportAfter", false);
    String installType = ParamUtils.getParameter(request, "installType");
    int index = ParamUtils.getIntParameter(request, "index", -1);

    // Get the Forum
    Forum forum = forumFactory.getForum(forumID);

    // Make sure the user has admin priv on this forum.
    if (!isSystemAdmin && !forum.isAuthorized(ForumPermissions.FORUM_CATEGORY_ADMIN | ForumPermissions.FORUM_ADMIN)) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }

    // Go back to the gateways page if "cancel" is clicked:
    String submitButton = ParamUtils.getParameter(request, "submitButton");
    if ("Cancel".equals(submitButton)) {
        response.sendRedirect("gateways.jsp?forum="+forumID);
        return;
    }

    if (doRunOnce) {
        if (installType == null) {
            // no choice selected, redirect back to this page
            response.sendRedirect("gateways.jsp?forum="+forumID);
            return;
        }
        else {
            // redirect to the specific edit page
            if ("email".equals(installType)) {
                response.sendRedirect("editEmailGateway.jsp?forum="+forumID+"&add=true&importOnce=true");
            }
            else if ("news".equals(installType)) {
                response.sendRedirect("editNewsgroupGateway.jsp?forum="+forumID+"&add=true&importOnce=true");
            }
            else if ("mbox".equals(installType)) {
                response.sendRedirect("editMboxGateway.jsp?forum="+forumID+"&importOnce=true");
            }
            else {
                response.sendRedirect("gateways.jsp?forum="+forumID);
            }
            return;
        }
    }

    // Get a GatewayManager from the forum
    GatewayManager gatewayManager = forum.getGatewayManager();

    // Check to see if any of the gateways are installed
    boolean isEmailGatewayInstalled = false;
    boolean isNewsGatewayInstalled = false;

    int gatewayCount = gatewayManager.getGatewayCount();
    for (int i=0; i<gatewayCount; i++) {
        try {
            if (gatewayManager.getGateway(i) instanceof EmailGateway ||
                    gatewayManager.getGateway(i) instanceof ImapGateway)
            {
                isEmailGatewayInstalled = true;
            }
            else if (gatewayManager.getGateway(i) instanceof NewsgroupGateway) {
                isNewsGatewayInstalled = true;
            }
        }
        catch (Exception ignored) {}
    }
%>

<%@ include file="header.jsp" %>

<p>

<%  // Title of this page and breadcrumbs
    String title = "Import Data";
    String[][] breadcrumbs = {
        {"Main", "main.jsp"},
        {"Categories &amp; Forums", "forums.jsp?cat=" + forum.getForumCategory().getID()},
        {"Edit Forum", "editForum.jsp?forum="+forumID},
        {"Gateways", "gateways.jsp?forum="+forumID},
        {"Import Data", "importGateway.jsp?forum="+forumID}
    };
%>
<%@ include file="title.jsp" %>
<%  // Number of installed gateways for this forum. Only show this section
    // if there are gateways to display
    gatewayCount = gatewayManager.getGatewayCount();
%>
<font size="-1">
Import all messages into this forum from <% if (gatewayCount > 0) { %>an existing gateway or <% } %> a new gateway.
</font>
<p>
<% if (gatewayCount > 0) { %>
<p>
<font size="-1"><b>Installed Gateway</b></font>
<ul>
    <font size="-1">Import all available messages from an existing gateway.</font><p>
    <table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="">
    <tr><td>
    <table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
    <tr bgcolor="#eeeeee">
        <td align="center" colspan="2"><font size="-2" face="verdana"><b>SOURCE</b></font></td>
        <td align="center"><font size="-2" face="verdana"><b>IMPORT</b></font></td>
    </tr>
<%  // Loop through the list of installed gateways, show some info about each
    for (int i=0; i<gatewayCount; i++) {
        Gateway gateway = gatewayManager.getGateway(i);
        boolean isEmailGateway = (gateway instanceof EmailGateway || gateway instanceof ImapGateway);
        boolean isNewsgroupGateway = (gateway instanceof NewsgroupGateway);
%>
    <tr bgcolor="#ffffff">
        <%  String displayName = "";
            if (isEmailGateway) {
                if (gateway instanceof EmailGateway) {
                    EmailGateway emailGateway = (EmailGateway) gateway;
                    Pop3Importer pop3Importer = (Pop3Importer) emailGateway.getGatewayImporter();
                    displayName = pop3Importer.getHost();
                }
                else if (gateway instanceof ImapGateway) {
                    ImapGateway imapGateway = (ImapGateway) gateway;
                    ImapImporter imapImporter = (ImapImporter) imapGateway.getGatewayImporter();
                    displayName = imapImporter.getHost();
                }
        %>
        <td><img src="images/button_email.gif" width="17" height="17" alt="" border="0"></td>
        <td>
            <font size="-1">
            <b>Email<% if (displayName!=null) { %>:<% } %></b>
            <% if (displayName!=null) { %><%= displayName%><% } %>
            </font>
        </td>
        <%  } else if (isNewsgroupGateway) {
                NewsgroupGateway newsgroupGateway = (NewsgroupGateway) gateway;
                NewsgroupImporter newsgroupImporter = (NewsgroupImporter) newsgroupGateway.getGatewayImporter();
                displayName = newsgroupImporter.getNewsgroup();
                if (displayName == null) {
                    displayName = newsgroupImporter.getHost();
                }
        %>
        <td><img src="images/button_newsgroup.gif" width="17" height="17" alt="" border="0"></td>
        <td>
            <font size="-1">
            <b>News<% if (displayName!=null) { %>:<% } %></b>
            <% if (displayName!=null) { %><%= displayName%><% } %>
            </font>
        </td>
        <%  } %>
        <td align="center">
        <%  if (isEmailGateway) { %>
            <a href="editEmailGateway.jsp?edit=true&importOnce=true&forum=<%= forumID %>&index=<%= i %>"
            ><img src="images/button_edit.gif" width="17" height="17" alt="Import using this gateway" border="0"
            ></a>
        <%  } else if (isNewsgroupGateway) { %>
            <a href="editNewsgroupGateway.jsp?edit=true&importOnce=true&forum=<%= forumID %>&index=<%= i %>"
            ><img src="images/button_edit.gif" width="17" height="17" alt="Import using this gateway" border="0"
            ></a>
        <%  } %>
        </td>
    </tr>
<%  } %>
    </table>
    </td></tr>
    </table>
</ul>
<%  } // end if gatewayCount > 0 %>

<p>
<font size="-1"><b>Import Once</b></font>
<ul>
    <font size="-1">Import all available messages from a new gateway.</font><p>
    <form action="importGateway.jsp">
    <input type="hidden" name="forum" value="<%= forumID %>">
    <input type="hidden" name="doRunOnce" value="true">
    <table cellpadding="3" cellspacing="0" border="0">
    <tr>
    	<td valign="top"><input type="radio" name="installType" value="email" id="rb04"></td>
        <td valign="top"><img src="images/button_addemail.gif" width="17" height="17" border="0"></td>
    	<td><font size="-1"><label for="rb04">Email Gateway -- Import all available messages from an email account or mailing list.</label></font></td>
    </tr>
    <tr>
    	<td valign="top"><input type="radio" name="installType" value="news" id="rb06"></td>
        <td valign="top"><img src="images/button_addnewsgroup.gif" width="17" height="17" border="0"></td>
    	<td><font size="-1"><label for="rb06">Newsgroup Gateway -- Import all available messages from a NNTP newsgroup.</label></font></td>
    </tr>
    <tr>
    	<td valign="top"><input type="radio" name="installType" value="mbox" id="rb07"></td>
        <td valign="top"><img src="images/button_addemail.gif" width="17" height="17" border="0"></td>
    	<td><font size="-1"><label for="rb75">Mbox Gateway -- Import all available message from a mbox file.</label></font></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td colspan="2"><input type="submit" name="submitButton" value="Import"> <input type="submit" name="submitButton" value="Cancel"></td>
    </tr>
    </table>
    </form>
</ul>
<p>

<%@ include file="footer.jsp" %>

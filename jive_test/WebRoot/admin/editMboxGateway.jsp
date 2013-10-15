
<%
    /**
     *	$RCSfile: editMboxGateway.jsp,v $
     *	$Revision: 1.1.12.1 $
     *	$Date: 2003/07/24 19:03:18 $
     */
%>

<%@ page import="java.util.*,
                 java.text.*,
                 com.jivesoftware.forum.*,
                 com.jivesoftware.forum.gateway.*,
                 com.jivesoftware.forum.util.*,
                 com.jivesoftware.forum.Forum,
                 com.jivesoftware.util.ParamUtils,
                 com.jivesoftware.util.TaskEngine,
                 com.jivesoftware.base.UnauthorizedException"
	errorPage="error.jsp"
%>

<%@	include file="global.jsp" %>

<%	// get parameters
    boolean doImport = ParamUtils.getBooleanParameter(request,"doImport");
    long forumID = ParamUtils.getLongParameter(request,"forum",-1L);
    String file  = ParamUtils.getParameter(request,"mboxfile");
    long startTime = ParamUtils.getLongParameter(request,"startTime",-1L);
    boolean inboundAttach = ParamUtils.getBooleanParameter(request, "inboundAttach", false);
    boolean subjectCheckEnabled = ParamUtils.getBooleanParameter(request, "subjectCheckEnabled", true);

    // Get the Gateway
    Forum forum = forumFactory.getForum(forumID);

    // Make sure the user has admin priv on this forum.
    if (!isSystemAdmin && !forum.isAuthorized(ForumPermissions.FORUM_CATEGORY_ADMIN | ForumPermissions.FORUM_ADMIN)) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }

    MboxGateway gateway = null;
    GatewayImportTask importTask = null;

    // import file
    if (doImport && file != null && !("").equals(file)) {
        gateway = new MboxGateway(forumFactory, forum);
        MboxImporter mboxImporter = (MboxImporter) gateway.getGatewayImporter();
        mboxImporter.setMboxFile(file);
        mboxImporter.setAttachmentsEnabled(inboundAttach);
        mboxImporter.setSubjectParentageCheckEnabled(subjectCheckEnabled);
        importTask = new GatewayImportTask(gateway, new Date(1));
        TaskEngine.addTask(importTask);
        session.setAttribute("mboxfile", file);
        session.setAttribute("mboxGateway", gateway);
        session.setAttribute("mboxImportTask", importTask);
        startTime = System.currentTimeMillis();
        response.sendRedirect("editMboxGateway.jsp?forum="+forumID+"&startTime="+startTime);
        return;
    }

    if (session.getAttribute("mboxGateway") != null) {
        gateway = (MboxGateway) session.getAttribute("mboxGateway");
        importTask = (GatewayImportTask) session.getAttribute("mboxImportTask");
    }
%>

<%@ include file="header.jsp" %>

<%  // Title of this page and breadcrumbs
    String title = "Mbox File Import";
    String[][] breadcrumbs = {
    {"Main", "main.jsp"},
    {"Categories &amp; Forums", "forums.jsp?cat=" + forum.getForumCategory().getID()},
    {"Gateways", "gateways.jsp?forum="+forumID},
    {title, "editMboxGateway.jsp?forum="+forumID+"&doImport="+doImport}
    };
%>
<%@ include file="title.jsp" %>

<font size="-1">
The mbox gateway imports messages stored in a mbox formatted file into a forum.
</font>

<%  if (gateway == null || (importTask.hasRun() && !importTask.isBusy())) {
       session.removeAttribute("mboxGateway");
       session.removeAttribute("mboxImportTask");
       session.removeAttribute("mboxfile");
%>
<p>

<font size="-1"><b>Import Settings</b></font><p>
<p>
    <font size="-1">This will import the following mbox file into this forum<br><br></font>
    <form action="editMboxGateway.jsp">
    <input type="hidden" name="doImport" value="true">
    <input type="hidden" name="forum" value="<%= forumID %>">
<ul>
    <table cellpadding="3" cellspacing="0" border="0">
    <tr>
    	<td><font size="-1">File:</font></td>
    	<td><font size="-1"><input type="text" name="mboxfile" size="50"></font></td>
    </tr>
    <tr>
    	<td><font size="-1">Allow import of<br>attachments:</font></td>
    	<td><font size="-1"><input type="radio" name="inboundAttach" value="true" <% if (inboundAttach) { %>checked<% } %>>Enabled <input type="radio" name="inboundAttach" value="false" <% if (!inboundAttach) { %>checked<% } %>>Disabled</font></td>
    </tr>
    <tr>
    	<td><font size="-1">Enabled threading via<br>subject line matching:<br></font></td>
        <td><font size="-1"><input type="radio" name="subjectCheckEnabled" value="true" <% if (subjectCheckEnabled) { %>checked<% } %>>Enabled <input type="radio" name="subjectCheckEnabled" value="false" <% if (!subjectCheckEnabled) { %>checked<% } %>>Disabled</font></td>
    </tr>
    </table>
</ul>
    <input type="submit" name="submit" value="Import mbox">
    </form>
</p>

<%  } else { // is running task %>

<script language="JavaScript" type="text/javascript">
<!--
function reloadPage() {
    self.location="editMboxGateway.jsp?forum=<%=forumID%>&startTime=<%=startTime%>";
}
setTimeout(reloadPage,5000);
//-->
</script>

<p>
<font size="-1"><b>Importing...</b></font><p>
<ul>
    <font size="-1">
    <b><%= ((MboxImporter) gateway.getGatewayImporter()).getPercentComplete() %>% complete (<%= ((MboxImporter) gateway.getGatewayImporter()).getCurrentMessageCount()%> of approximately <%= ((MboxImporter) gateway.getGatewayImporter()).getTotalMessageCount() %> messages)</b>
    <br><br>
    Jive is currently importing messages into forum <i><%=forum.getName()%></i> from file <%= (String) session.getAttribute("mboxfile") %>  <br>
    <% if (startTime != -1) {%>
        (<%= (int) ((System.currentTimeMillis() - startTime)/1000) %> seconds and counting)
    <% } %>
    </font>
</ul>

<%  } %>

<%@ include file="footer.jsp" %>
<%--
  -
  - $RCSfile: reports.jsp,v $
  - $Revision: 1.9.2.2 $
  - $Date: 2003/07/24 19:03:15 $
  -
  - Copyright (C) 1999-2002 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software.  Use is subject to license terms.
  -
--%>

<%@ page import="java.awt.*,
                 java.awt.image.*,
                 java.io.*,
                 java.util.*,
				 java.text.*,
				 com.jivesoftware.util.*,
                 com.jivesoftware.forum.*,
				 com.jivesoftware.forum.database.*,
                 com.jivesoftware.forum.stats.*,
				 com.jivesoftware.forum.util.*,
                 com.jivesoftware.base.stats.util.*,
                 com.jivesoftware.util.DateRange,
                 com.jivesoftware.util.RelativeDateRange,
                 java.util.List"
    errorPage="error.jsp"
%>

<%@ include file="global.jsp" %>
 
<%	// Permission check
    if (!isSystemAdmin) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }

    // get actions
    boolean save = ParamUtils.getBooleanParameter(request,"save");
    boolean test = ParamUtils.getBooleanParameter(request,"testGraphics");

    boolean useDefaultOutputDir = ParamUtils.getBooleanParameter(request,"useDefaultOutputDir");
    String outputDir = ParamUtils.getParameter(request,"outputDir",true);
    boolean createDir = ParamUtils.getBooleanParameter(request,"createDir");
    long[] forumIDs = ParamUtils.getLongParameters(request,"forum",-1L);
    long[] excludedForumIDs = ParamUtils.getLongParameters(request,"excludedForum",-1L);
    boolean addExcludedForumID = request.getParameter("addExcludedForumID") != null;
    boolean removeExcludedForumID = request.getParameter("removeExcludedForumID") != null;
    String datePresetValue = ParamUtils.getParameter(request,"datePresetValue");
    boolean setDatePresetValue = request.getParameter("setDatePresetValue") != null;
    boolean enableUserGroupReports = ParamUtils.getBooleanParameter(request,"enableUserGroupReports");
    boolean saveUserGroupReportPref = request.getParameter("saveUserGroupReportPref") != null;
    boolean useTimestampDir = ParamUtils.getBooleanParameter(request,"useTimestampDir");

    // Get the report manager
    ReportManager reportManager = ReportManager.getInstance();

    // Set the default output directory
    String defaultOutputDir = (reportManager.getOutputDir()).toString();

    if (saveUserGroupReportPref) {
        reportManager.setEnableUserReports(enableUserGroupReports);
        response.sendRedirect("reports.jsp");
        return;
    }
    enableUserGroupReports = reportManager.isEnableUserReports();

    if (setDatePresetValue) {
        RelativeDateRange dateRange = new RelativeDateRange("", datePresetValue);
        reportManager.setGlobalDateRange(dateRange);
        response.sendRedirect("reports.jsp");
        return;
    }
    DateRange datePreset = reportManager.getGlobalDateRange();

    if (addExcludedForumID) {
        for (int i=0; i<forumIDs.length; i++) {
            if (forumIDs[i] != -1L) {
                try {
                    Forum f = forumFactory.getForum(forumIDs[i]);
                    reportManager.addExcludedForumID(forumIDs[i]);
                }
                catch (ForumNotFoundException fnfe) {}
            }
        }
        response.sendRedirect("reports.jsp");
        return;
    }

    if (removeExcludedForumID) {
        for (int i=0; i<excludedForumIDs.length; i++) {
            if (excludedForumIDs[i] != -1L) {
                try {
                    Forum f = forumFactory.getForum(excludedForumIDs[i]);
                    reportManager.removeExcludeForumID(excludedForumIDs[i]);
                }
                catch (ForumNotFoundException fnfe) {}
            }
        }
        response.sendRedirect("reports.jsp");
        return;
    }

    // Get the list of excluded forums:
    java.util.List excludedForums = reportManager.getExcludedForumIDs();

    boolean testSuccess = false;
    if (test) {
        // try to create a BufferedImage, get a graphics context
        try {
            BufferedImage image = new BufferedImage(10,10,BufferedImage.TYPE_INT_RGB);
            Graphics2D g2d = (Graphics2D)image.getGraphics();
            testSuccess = true;
        }
        catch (Throwable t) {
            //t.printStackTrace();
        }
    }
    
    boolean outputDirErrors = false;
    boolean createDirErrors = false;
    if (save) {
        if (useDefaultOutputDir) {
            outputDir = JiveGlobals.getJiveHome() + File.separator + "stats" + File.separator + "reports";
        }
        try {
            File dir = new File(outputDir);
            if (!dir.exists()) {
                if (createDir) {
                    if (!dir.mkdir()) {
                        createDirErrors = true;
                    }
                }
                else {
                    outputDirErrors = true;
                }
            }
            if (!dir.canRead()) {
                outputDirErrors = true;
            }
        }
        catch (Exception e) {
            outputDirErrors = true;
        }
    }
    
    if (save && !outputDirErrors && !createDirErrors) {
        // save the report output dir
        JiveGlobals.setJiveProperty("stats.useDefaultOutputDir", ""+useDefaultOutputDir);
        if (useTimestampDir) {
            JiveGlobals.setJiveProperty("stats.useTimestampDir", "true");
        }
        else {
            JiveGlobals.deleteJiveProperty("stats.useTimestampDir");
        }
        if (outputDir != null) {
            reportManager.setOutputDir(new File(outputDir.trim()));
            response.sendRedirect("reports.jsp");
            return;
        }
        // indicate if we should use a
    }
    
    String currentUseDefaultOutputDir = JiveGlobals.getJiveProperty("stats.useDefaultOutputDir");
    if (currentUseDefaultOutputDir == null || "".equals(currentUseDefaultOutputDir)) {
        useDefaultOutputDir = true;
    }
    else {
        useDefaultOutputDir = "true".equals(JiveGlobals.getJiveProperty("stats.useDefaultOutputDir"));
    }
    String currentOutputDir = JiveGlobals.getJiveProperty("stats.outputDir");
    if (currentOutputDir == null || "".equals(currentOutputDir)) {
        if (!defaultOutputDir.equals(currentOutputDir)) {
            outputDir = "";
        }
        else {
            outputDir = defaultOutputDir;
        }
    }
    else {
        outputDir = currentOutputDir;
    }
    useTimestampDir = "true".equals(JiveGlobals.getJiveProperty("stats.useTimestampDir"));
%>

<%@ include file="header.jsp" %>

<%  // Title of this page and breadcrumbs
    String title = "Configure Reports";
    String[][] breadcrumbs = {
        {"Main", "main.jsp"},
        {title, "reports.jsp"}
    };
%>
<%@ include file="title.jsp" %>

<%  // Check to see if there is a report running - if so, don't display
    // any of the options below
    if (reportManager.isReportRunning()) {
%>
    <p>
    A report is currently running. Once the report is finished you will be able
    to change the report settings.
    </p>

    <p>
    To view the stats of the report, please see the
    <a href="runReports.jsp">report status</a> page.
    </p>

<%  }
    // No report is running so show the report options
    else {
%>
    <form action="reports.jsp" method="post" name="reportsForm">
    <input type="hidden" name="testGraphics" value="true">

    <b>Test Server-Side Graphics Capability</b>

    <a href="#" onclick="helpwin('reports','server_side_graphics');return false;"
         title="Click for help"
         ><img src="images/help-16x16.gif" width="16" height="16" border="0"></a>

    <ul>
        <p>
        The reporting package requires that your server environment support creating images. By
        default, many Unix-based servers are not configured for this
        support and require installation of the <a href="pja-install.html" target="_new">PJA Toolkit</a>
        or the use of JDK 1.4's "headless mode."
        Use the button below to test whether your server environment is properly
        configured to support image generation.
        </p>

        <%  if (test && testSuccess) { %>

            <p style="color:#090;">
            <b>Test Successful</b>
            <br>
            Your server-side environment is correctly configured
            to run the Jive Forums reporting tools.
            </p>

        <%  } else if (test && !testSuccess) { %>

            <p style="color:#f00;">
            <b>Test Failed</b>
            <br>
            Your appserver is not properly configured to run the
            Jive Forums reporting tools. Please follow the
            <a href="pja-install.html" target="_new">PJA Toolkit</a> documentation,
            restart your appserver and attempt this test again.
            </p>

        <%  } %>

        <input type="submit" value="Run Test">

    </ul>
    </form>

    <form action="reports.jsp" method="post" name="reportsForm">
    <input type="hidden" name="save" value="true">

    <b>Reports Output Directory</b>
    <a href="#" onclick="helpwin('reports','output_directory');return false;"
         title="Click for help"
         ><img src="images/help-16x16.gif" width="16" height="16" border="0"></a>
    <ul>
        <p>
        Report information is saved to the directory listed below. By default,
        reports are written to your jiveHome directory so you will need to browse
        your filesystem in order to view them. You may wish to enter an
        alternative directory that is in the path of your webserver documents directory
        so that the reports are publicly viewable.
        </p>

        <%  if (save && outputDirErrors) { %>

            <p class="jive-error-text">
            <b>Error:</b>
            The directory you submitted is not valid. Make sure it exists and that your appserver
            has permission to write to it.<p>
            </p>

        <%  } %>

        <%  if (save && createDirErrors) { %>

            <p class="jive-error-text">
            <b>Error:</b>
            Unable to create the directory <%= outputDir %> -- your appserver may not have
            permission to create this directory.
            </p>

        <%  } %>

        <p>
        Current output directory:
        <tt style="border : 1px dashed #999; padding : 3px; background-color : #eee;"
         ><b><%= defaultOutputDir %></b></tt>
        </p>

        <p>
        Change output directory settings:
        </p>

        <ul>

            <table cellpadding="3" cellspacing="0" border="0">
            <tr>
                <td align="center">
                    <input type="radio" name="useDefaultOutputDir" value="true" id="rb01"
                    <%= (useDefaultOutputDir)?" checked":"" %>>
                </td>
                <td>
                    <label for="rb01">Use the default output directory:</label>
                    &lt;jiveHome&gt;<%= File.separator %>stats<%= File.separator %>reports
                </td>
            </tr>
            <tr>
                <td valign="top" align="center">
                    <input type="radio" name="useDefaultOutputDir" value="false" id="rb02"
                    <%= (!useDefaultOutputDir)?" checked":"" %>>
                </td>
                <td>
                    <label for="rb02">Save generated reports to this directory:</label>
                </td>
            </tr>
            <tr>
                <td align="center">&nbsp;</td>
                <td>
                    <input type="text" name="outputDir" value="<%= ((!useDefaultOutputDir)?defaultOutputDir:"") %>"
                     size="50" maxlength="255"
                     onfocus="this.form.useDefaultOutputDir[1].checked=true;">
                </td>
            </tr>
            <tr>
                <td valign="top" align="center">
                    <input type="checkbox" name="useTimestampDir" value="true" id="cb02"
                     <%= ((useTimestampDir) ? "checked" : "") %>>
                </td>
                <td>
                    <label for="cb02">Create each report in a</label>
                    <a href="#" onclick="helpwin('reports','output_directory');return false;"
                     tile="Click for more info"
                     >timestamp directory</a>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <br>
                    <input type="submit" value="Save Settings">
                </td>
            </tr>
            </table>

        </ul>

    </ul>
    </form>


    <form action="reports.jsp" method="post" name="reportsForm">

    <b>Excluded Forums</b>
    <a href="#" onclick="helpwin('reports','excluded_forums');return false;"
         title="Click for help"
         ><img src="images/help-16x16.gif" width="16" height="16" border="0"></a>
    <ul>

        You may wish to not run reports on some of your forums. To do so,
        add forums to the "excluded forums" list.
        <p>
        <table cellpadding="2" cellspacing="0" border="0">
        <tr>
            <td align="center"><font size="-2" face="verdana"><b>Included Forums</b></td>
            <td>&nbsp;</td>
            <td align="center"><font size="-2" face="verdana"><b>Excluded Forums</b></td>
        </tr>
        <tr>
            <td valign="top">
                <select size="5" name="forum" multiple>
            <%  // Get a list of all forums in the system
                List allForums = new java.util.LinkedList();
                for (Iterator i=forumFactory.getRootForumCategory().getRecursiveForums(); i.hasNext(); )
                {
                    allForums.add(i.next());
                }
                // Sort the forum list based on alphabetical name
                Collections.sort(allForums, new Comparator() {
                    public int compare(Object obj1, Object obj2) {
                        String n1 = ((Forum)obj1).getName().toLowerCase();
                        String n2 = ((Forum)obj2).getName().toLowerCase();
                        return n1.compareTo(n2);
                    }
                });
                // Print out all forums, exclude those that are in the exclude list.
                for (int i=0; i<allForums.size(); i++) {
                    Forum forum = (Forum)allForums.get(i);
                    if (!excludedForums.contains(new Long(forum.getID()))) {
            %>
                    <option value="<%= forum.getID() %>"><%= forum.getName() %>
                        [<%= LocaleUtils.getLocalizedNumber(forum.getMessageCount()) %>]

            <%      }
                }
            %>
                </select>
            </td>
            <td>
                <input type="submit" value=" &gt; " name="addExcludedForumID">
                <br>
                <input type="submit" value=" &lt; " name="removeExcludedForumID">
            </td>
            <td valign="top">
                <select size="5" name="excludedForum" multiple>
            <%  for (int i=0; i<excludedForums.size(); i++) {
                    long forumID = ((Long)excludedForums.get(i)).longValue();
                    try {
                        Forum forum = forumFactory.getForum(forumID);
            %>
                    <option value="<%= forum.getID() %>"><%= forum.getName() %>
                        [<%= LocaleUtils.getLocalizedNumber(forum.getMessageCount()) %>]
            <%      }
                    catch (ForumNotFoundException ignored) {}
                }
            %>
                </select>
            </td>
        </tr>
        </table>
    </ul>
    </form>

    <form action="reports.jsp">

    <b>User and Group Reports</b>
    <a href="#" onclick="helpwin('reports','user_group');return false;"
         title="Click for help"
         ><img src="images/help-16x16.gif" width="16" height="16" border="0"></a>
    <ul>

        You may wish to not run reports on users or groups, especially if you have a
        customer user or group implementation. User reports are reports that detail
        things like active users, users created over time or user domains.
        <p></p>
        <table cellpadding="3" cellspacing="0" border="0">
        <tr>
            <td><input type="radio" name="enableUserGroupReports" value="true" id="ug01"
                 <%= (enableUserGroupReports)?" checked":"" %>>
            </td>
            <td>
                <label for="ug01">
                Enable User and Group Reports
                </label>

            </td>
        </tr>
        <tr>
            <td><input type="radio" name="enableUserGroupReports" value="false" id="ug02"
                 <%= (!enableUserGroupReports)?" checked":"" %>>
            </td>
            <td>
                <label for="ug02">
                Disable User and Group Reports
                </label>

            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td><input type="submit" name="saveUserGroupReportPref" value="Save Settings"></td>
        </tr>
        </table>
    </ul>

    </form>

    <form action="reports.jsp">

    <b>Global Date Range</b>
    <a href="#" onclick="helpwin('reports','date_range');return false;"
         title="Click for help"
         ><img src="images/help-16x16.gif" width="16" height="16" border="0"></a>
    <ul>

        You can set a global date range to restrict the size of data being examined. This is useful
        if you have a large amount of forum traffic because examining all data will take
        a long time and will increase your database load quite a bit.
        <p></p>
        <table bgcolor="#bbbbbb" cellspacing="0" cellpadding="0" border="0">
        <tr><td>
        <table bgcolor="#bbbbbb" cellpadding="3" cellspacing="1" border="0">
        <tr bgcolor="#eeeeee">
            <td align="center" bgcolor="#DFE6F9"><input type="radio" name="datePresetValue"
                    value="<%= RelativeDateRange.LAST_7_DAYS.toString() %>" id="d01"
                    <%= (datePreset.equals(RelativeDateRange.LAST_7_DAYS))?" checked":"" %>>
            </td>
            <td align="center" bgcolor="#C1D2FA"><input type="radio" name="datePresetValue"
                    value="<%= RelativeDateRange.LAST_30_DAYS.toString() %>" id="d02"
                    <%= (datePreset.equals(RelativeDateRange.LAST_30_DAYS))?" checked":"" %>>
            </td>
            <td align="center" bgcolor="#A6BEFB"><input type="radio" name="datePresetValue"
                    value="<%= RelativeDateRange.LAST_90_DAYS.toString() %>" id="d03"
                    <%= (datePreset.equals(RelativeDateRange.LAST_90_DAYS))?" checked":"" %>>
            </td>
            <td align="center" bgcolor="#8CADFD"><input type="radio" name="datePresetValue"
                    value="<%= RelativeDateRange.ALL.toString() %>" id="d04"
                    <%= (datePreset.equals(RelativeDateRange.ALL))?" checked":"" %>>
            </td>
        </tr>
        <tr bgcolor="#ffffff">
            <td align="center" nowrap>

                <label for="d01">
                &nbsp; Last 7 Days &nbsp;
                </label>

            </td>
            <td align="center" nowrap>

                <label for="d02">
                &nbsp; Last 30 Days &nbsp;
                </label>

            </td>
            <td align="center" nowrap>

                <label for="d03">
                &nbsp; Last 90 Days &nbsp;
                </label>

            </td>
            <td align="center" nowrap>

                <label for="d04">
                &nbsp; All &nbsp;
                </label>

                <font size="-2">
                <br>(Not recommended for<br>large communities)

            </td>
        </tr>
        </table>
        </td></tr>
        </table>
        <p>
        <input type="submit" name="setDatePresetValue" value="Save Settings">
        </p>
    </ul>

    </form>

<%  } // end else %>

<%@ include file="footer.jsp" %>


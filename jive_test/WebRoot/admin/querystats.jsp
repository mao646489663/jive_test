<%--
  - $RCSfile: querystats.jsp,v $
  - $Revision: 1.4 $
  - $Date: 2003/05/18 21:17:10 $
  -
  - Copyright (C) 2002-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software. Use is subject to license terms.
--%>

<%@ page import="java.sql.*,
                 com.jivesoftware.util.ParamUtils,
                 com.jivesoftware.base.database.*,
                 java.text.*"
    errorPage="error.jsp"
%>

<%@ include file="global.jsp" %>

<%! // Global methods, vars

    // Default refresh values
    static final int[] REFRESHES = {10,30,60,90};
%>

<%  // Permission check
    if (!isSystemAdmin) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }

    // Get parameters
    boolean doClear = request.getParameter("doClear") != null;
    String enableStats = ParamUtils.getParameter(request,"enableStats");
    int refresh = ParamUtils.getIntParameter(request,"refresh", -1);
    boolean doSortByTime = ParamUtils.getBooleanParameter(request,"doSortByTime");

    // Var for the alternating colors
    int rowColor = 0;

    // clear the statistics
    if (doClear) {
        ProfiledConnection.resetStatistics();
    }

    // Enable/disable stats
    if ("true".equals(enableStats)) {
        ConnectionManager.setProfilingEnabled(true);
    }
    else if ("false".equals(enableStats)) {
        ConnectionManager.setProfilingEnabled(false);
    }

    boolean showQueryStats = ConnectionManager.isProfilingEnabled();

    // Number intFormat for pretty printing of large number values and decimals:
    NumberFormat intFormat = NumberFormat.getInstance(JiveGlobals.getLocale());
    DecimalFormat decFormat = new DecimalFormat("#,##0.00");
%>

<%@ include file="header.jsp" %>

<%  // Enable refreshing if specified
    if (refresh >= 10) {
%>
    <meta http-equiv="refresh" content="<%= refresh %>;URL=querystats.jsp?refresh=<%= refresh %>">

<%  } %>

<%  // Title of this page and breadcrumbs
    String title = "Query Statistics";
    String[][] breadcrumbs = {
        {"Main", "main.jsp"},
        {title, "querystats.jsp"}
    };
%>
<%@ include file="title.jsp" %>

Enable query statistics to trace all database queries made by Jive Forums. This can
be useful to debug issues and monitor database performance. However, it's not recommended that
you leave query statistics permanently running, as they will cause performance to degrade slightly.

<p><b>Query Statistics Status</b></p>

<form action="querystats.jsp">
<ul>
    <table cellpadding="3" cellspacing="1" border="0">
    <tr>
        <td>
            <input type="radio" name="enableStats" value="true" id="rb01" <%= ((showQueryStats) ? "checked":"") %>>
            <label for="rb01"><%= ((showQueryStats) ? "<b>Enabled</b>":"Enabled") %></label>
        </td>
        <td>
            <input type="radio" name="enableStats" value="false" id="rb02" <%= ((!showQueryStats) ? "checked":"") %>>
            <label for="rb02"><%= ((!showQueryStats) ? "<b>Disabled</b>":"Disabled") %></label>
        </td>
        <td>
            <input type="submit" name="" value="Update">
        </td>
    </tr>
    </table>
</ul>
</form>

<%  if (showQueryStats) { %>

    <p><b>Query Statistics Settings</b></p>

    <form action="querystats.jsp">
    <ul>
        <table cellpadding="3" cellspacing="1" border="0">
        <tr>
            <td>
                Refresh:
                <select size="1" name="refresh" onchange="this.form.submit();">
                <option value="none">None

                <%  for (int j=0; j<REFRESHES.length; j++) {
                        String selected = ((REFRESHES[j] == refresh) ? " selected" : "");
                %>
                    <option value="<%= REFRESHES[j] %>"<%= selected %>
                     ><%= REFRESHES[j] %> seconds

                <%  } %>
                </select>
            </td>
            <td>
                <input type="submit" name="" value="Set">
            </td>
            <td>|</td>
            <td>
                <input type="submit" name="" value="Update Now">
            </td>
            <td>|</td>
            <td>
                <input type="submit" name="doClear" value="Clear All Stats">
            </td>
        </tr>
        </table>
    </ul>
    </form>

    <br>

    <p>
    <b>SELECT Query Statistics</b>
    </p>

    <ul>

    <table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="600">
    <tr><td>
    <table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
    <tr bgcolor="#ffffff">
        <td>Total # of selects</td>
        <td><%= intFormat.format(ProfiledConnection.getQueryCount(ProfiledConnection.SELECT)) %></td>
    </tr>
    <tr bgcolor="#ffffff">
        <td>Total time for all selects (ms)</td>
        <td><%= intFormat.format(ProfiledConnection.getTotalQueryTime(ProfiledConnection.SELECT)) %></td>
    </tr>
    <tr bgcolor="#ffffff">
        <td>Average time for all selects (ms)</td>
        <td><%= decFormat.format(ProfiledConnection.getAverageQueryTime(ProfiledConnection.SELECT)) %></td>
    </tr>
    <tr bgcolor="#ffffff">
        <td>Selects per second</td>
        <td><%= decFormat.format(ProfiledConnection.getQueriesPerSecond(ProfiledConnection.SELECT)) %></td>
    </tr>
    <tr bgcolor="#ffffff">
        <td>20 Most common selects</td>
        <td bgcolor="#ffffff"><%
                    ProfiledConnectionEntry[] list = ProfiledConnection.getSortedQueries(ProfiledConnection.SELECT, doSortByTime);

                    if (list == null || list.length < 1) {
                        out.println("No queries");
                    }
                    else { %>
                &nbsp;
         </td>
    </tr>
    </table>
    </td></tr>
    </table>

    <br>

    <table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="600">
    <tr><td>
    <table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="0" border="0" width="100%">
    <tr bgcolor="#ffffff"><td>
    <%      out.println("<table width=\"100%\" cellpadding=\"3\" cellspacing=\"1\" border=\"0\" bgcolor=\"" + tblBorderColor + "\"><tr><td bgcolor=\"#ffffff\" align=\"middle\"><b>Query</b></td>");
            out.println("<td bgcolor=\"#ffffff\"><b><a href=\"javascript:location.href='querystats.jsp?doSortByTime=false&refresh=" + refresh + "';\">Count</a></b></td>");
            out.println("<td bgcolor=\"#ffffff\"><b>Total Time (ms)</b></td>");
            out.println("<td bgcolor=\"#ffffff\"><b><a href=\"javascript:location.href='querystats.jsp?doSortByTime=true&refresh=" + refresh + "';\">Average Time</a> (ms)</b></td></tr>");

            for (int i = 0; i < ((list.length > 20) ? 20 : list.length); i++) {
                ProfiledConnectionEntry pce = list[i];
                out.println("<tr><td bgcolor=\"" + ((rowColor%2 == 0) ? "#dddddd" : "#ffffff") + "\">" + pce.sql + "</td>");
                out.println("<td bgcolor=\"" + ((rowColor%2 == 0) ? "#dddddd" : "#ffffff") + "\">" + intFormat.format(pce.count) + "</td>");
                out.println("<td bgcolor=\"" + ((rowColor%2 == 0) ? "#dddddd" : "#ffffff") + "\">" + intFormat.format(pce.totalTime) + "</td>");
                out.println("<td bgcolor=\"" + ((rowColor++%2 == 0) ? "#dddddd" : "#ffffff") + "\">" + intFormat.format(pce.totalTime/pce.count) + "</td></tr>");
            }
            out.println("</table>");
        }
     %></td>
    </tr>
    </table>
    </td></tr>
    </table>

    </ul>

    <b>INSERT Query Statistics</b>

    <ul>

    <table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="600">
    <tr><td>
    <table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
    <tr bgcolor="#ffffff">
        <td>Total # of inserts</td>
        <td><%= ProfiledConnection.getQueryCount(ProfiledConnection.INSERT) %></td>
    </tr>
    <tr bgcolor="#ffffff">
        <td>Total time for all inserts (ms)</td>
        <td><%= ProfiledConnection.getTotalQueryTime(ProfiledConnection.INSERT) %></td>
    </tr>
    <tr bgcolor="#ffffff">
        <td>Average time for all inserts (ms)</td>
        <td><%= decFormat.format(ProfiledConnection.getAverageQueryTime(ProfiledConnection.INSERT)) %></td>
    </tr>
    <tr bgcolor="#ffffff">
        <td>Inserts per second</td>
        <td><%= decFormat.format(ProfiledConnection.getQueriesPerSecond(ProfiledConnection.INSERT)) %></td>
    </tr>
    <tr bgcolor="#ffffff">
        <td>10 Most common inserts</td>
        <td bgcolor="#ffffff"><%
                    list = ProfiledConnection.getSortedQueries(ProfiledConnection.INSERT, doSortByTime);

                    if (list == null || list.length < 1) {
                        out.println("No queries");
                    }
                    else {  %>
                &nbsp;
         </td>
    </tr>
    </table>
    </td></tr>
    </table>

    <br>

    <table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="600">
    <tr><td>
    <table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="0" border="0" width="100%">
    <tr bgcolor="#ffffff"><td>
    <%
                out.println("<table width=\"100%\" cellpadding=\"3\" cellspacing=\"1\" border=\"0\" bgcolor=\"" + tblBorderColor + "\"><tr><td bgcolor=\"#ffffff\" align=\"middle\"><b>Query</b></td>");
                out.println("<td bgcolor=\"#ffffff\"><b><a href=\"javascript:location.href='querystats.jsp?doSortByTime=false&refresh=" + refresh + "';\">Count</a></b></td>");
                out.println("<td bgcolor=\"#ffffff\"><b>Total Time (ms)</b></td>");
                out.println("<td bgcolor=\"#ffffff\"><b><a href=\"javascript:location.href='querystats.jsp?doSortByTime=true&refresh=" + refresh + "';\">Average Time</a> (ms)</b></td></tr>");

                rowColor = 0;

                for (int i = 0; i < ((list.length > 10) ? 10 : list.length); i++) {
                    ProfiledConnectionEntry pce = list[i];
                    out.println("<tr><td bgcolor=\"" + ((rowColor%2 == 0) ? "#dddddd" : "#ffffff") + "\">" + pce.sql + "</td>");
                    out.println("<td bgcolor=\"" + ((rowColor%2 == 0) ? "#dddddd" : "#ffffff") + "\">" + intFormat.format(pce.count) + "</td>");
                    out.println("<td bgcolor=\"" + ((rowColor%2 == 0) ? "#dddddd" : "#ffffff") + "\">" + intFormat.format(pce.totalTime) + "</td>");
                    out.println("<td bgcolor=\"" + ((rowColor++%2 == 0) ? "#dddddd" : "#ffffff") + "\">" + intFormat.format(pce.totalTime/pce.count) + "</td></tr>");
                }
                out.println("</table>");
            }
        %></td>
    </tr>
    </table>
    </td></tr>
    </table>

    </ul>

    <b>UPDATE Query Statistics</b>

    <ul>

    <table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="600">
    <tr><td>
    <table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
    <tr bgcolor="#ffffff">
        <td>Total # of updates</td>
        <td><%= ProfiledConnection.getQueryCount(ProfiledConnection.UPDATE) %></td>
    </tr>
    <tr bgcolor="#ffffff">
        <td>Total time for all updates (ms)</td>
        <td><%= ProfiledConnection.getTotalQueryTime(ProfiledConnection.UPDATE) %></td>
    </tr>
    <tr bgcolor="#ffffff">
        <td>Average time for all updates (ms)</td>
        <td><%= decFormat.format(ProfiledConnection.getAverageQueryTime(ProfiledConnection.UPDATE)) %></td>
    </tr>
    <tr bgcolor="#ffffff">
        <td>Updates per second</td>
        <td><%= decFormat.format(ProfiledConnection.getQueriesPerSecond(ProfiledConnection.UPDATE)) %></td>
    </tr>
    <tr bgcolor="#ffffff">
        <td>10 Most common updates</td>
        <td bgcolor="#ffffff"><%
                    list = ProfiledConnection.getSortedQueries(ProfiledConnection.UPDATE, doSortByTime);

                    if (list == null || list.length < 1) {
                        out.println("No queries");
                    }
                    else { %>
                &nbsp;
         </td>
    </tr>
    </table>
    </td></tr>
    </table>

    <br>

    <table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="600">
    <tr><td>
    <table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="0" border="0" width="100%">
    <tr bgcolor="#ffffff"><td>
    <%
                out.println("<table width=\"100%\" cellpadding=\"3\" cellspacing=\"1\" border=\"0\" bgcolor=\"" + tblBorderColor + "\"><tr><td bgcolor=\"#ffffff\" align=\"middle\"><b>Query</b></td>");
                out.println("<td bgcolor=\"#ffffff\"><b><a href=\"javascript:location.href='querystats.jsp?doSortByTime=false&refresh=" + refresh + "';\">Count</a></b></td>");
                out.println("<td bgcolor=\"#ffffff\"><b>Total Time (ms)</b></td>");
                out.println("<td bgcolor=\"#ffffff\"><b><a href=\"javascript:location.href='querystats.jsp?doSortByTime=true&refresh=" + refresh + "';\">Average Time</a> (ms)</b></td></tr>");

                rowColor = 0;

                for (int i = 0; i < ((list.length > 10) ? 10 : list.length); i++) {
                    ProfiledConnectionEntry pce = list[i];
                    out.println("<tr><td bgcolor=\"" + ((rowColor%2 == 0) ? "#dddddd" : "#ffffff") + "\">" + pce.sql + "</td>");
                    out.println("<td bgcolor=\"" + ((rowColor%2 == 0) ? "#dddddd" : "#ffffff") + "\">" + intFormat.format(pce.count) + "</td>");
                    out.println("<td bgcolor=\"" + ((rowColor%2 == 0) ? "#dddddd" : "#ffffff") + "\">" + intFormat.format(pce.totalTime) + "</td>");
                    out.println("<td bgcolor=\"" + ((rowColor++%2 == 0) ? "#dddddd" : "#ffffff") + "\">" + intFormat.format(pce.totalTime/pce.count) + "</td></tr>");
                }
                out.println("</table>");
            }
        %></td>
    </tr>
    </table>
    </td></tr>
    </table>

    </ul>

    <b>DELETE Query Statistics</b>

    <ul>

    <table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="600">
    <tr><td>
    <table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
    <tr bgcolor="#ffffff">
        <td>Total # of deletes</td>
        <td><%= ProfiledConnection.getQueryCount(ProfiledConnection.DELETE) %></td>
    </tr>
    <tr bgcolor="#ffffff">
        <td>Total time for all deletes (ms)</td>
        <td><%= ProfiledConnection.getTotalQueryTime(ProfiledConnection.DELETE) %></td>
    </tr>
    <tr bgcolor="#ffffff">
        <td>Average time for all deletes (ms)</td>
        <td><%= decFormat.format(ProfiledConnection.getAverageQueryTime(ProfiledConnection.DELETE)) %></td>
    </tr>
    <tr bgcolor="#ffffff">
        <td>Deletes per second</td>
        <td><%= decFormat.format(ProfiledConnection.getQueriesPerSecond(ProfiledConnection.DELETE)) %></td>
    </tr>
    <tr bgcolor="#ffffff">
        <td>10 Most common deletes</td>
        <td bgcolor="#ffffff"><%
                    list = ProfiledConnection.getSortedQueries(ProfiledConnection.DELETE, doSortByTime);

                    if (list == null || list.length < 1) {
                        out.println("No queries");
                    }
                    else { %>
                &nbsp;
         </td>
    </tr>
    </table>
    </td></tr>
    </table>

    <br>

    <table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="600">
    <tr><td>
    <table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="0" border="0" width="100%">
    <tr bgcolor="#ffffff"><td>
    <%
                out.println("<table width=\"100%\" cellpadding=\"3\" cellspacing=\"1\" border=\"0\" bgcolor=\"" + tblBorderColor + "\"><tr><td bgcolor=\"#ffffff\" align=\"middle\"><b>Query</b></td>");
                out.println("<td bgcolor=\"#ffffff\"><b><a href=\"javascript:location.href='querystats.jsp?doSortByTime=false&refresh=" + refresh + "';\">Count</a></b></td>");
                out.println("<td bgcolor=\"#ffffff\"><b>Total Time (ms)</b></td>");
                out.println("<td bgcolor=\"#ffffff\"><b><a href=\"javascript:location.href='querystats.jsp?doSortByTime=true&refresh=" + refresh + "';\">Average Time</a> (ms)</b></td></tr>");

                rowColor = 0;

                for (int i = 0; i < ((list.length > 10) ? 10 : list.length); i++) {
                    ProfiledConnectionEntry pce = list[i];
                    out.println("<tr><td bgcolor=\"" + ((rowColor%2 == 0) ? "#dddddd" : "#ffffff") + "\">" + pce.sql + "</td>");
                    out.println("<td bgcolor=\"" + ((rowColor%2 == 0) ? "#dddddd" : "#ffffff") + "\">" + intFormat.format(pce.count) + "</td>");
                    out.println("<td bgcolor=\"" + ((rowColor%2 == 0) ? "#dddddd" : "#ffffff") + "\">" + intFormat.format(pce.totalTime) + "</td>");
                    out.println("<td bgcolor=\"" + ((rowColor++%2 == 0) ? "#dddddd" : "#ffffff") + "\">" + intFormat.format(pce.totalTime/pce.count) + "</td></tr>");
                }
                out.println("</table>");
            }
        %></td>
    </tr>
    </table>
    </td></tr>
    </table>

    </ul>

<% } %>

<br><br>

<%@ include file="footer.jsp" %>
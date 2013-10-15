<%--
  -
  - $RCSfile: searchSettings.jsp,v $
  - $Revision: 1.14.2.2 $
  - $Date: 2003/07/25 16:09:16 $
  -
--%>

<%@ page import="java.util.*,
	             java.text.*,
                 com.jivesoftware.forum.*,
                 com.jivesoftware.forum.database.*,
                 com.jivesoftware.forum.util.*,
                 java.io.File,
                 com.jivesoftware.util.*"
	errorPage="error.jsp"
%>

<%@ include file="global.jsp" %>

<%! // Global vars, methods, etc

    // Types of search indexers
    static final String[][] INDEXERS = {
        { "com.jivesoftware.util.search.StandardSynonymAnalyzer",    "English (Standard, Non-stemming)" },
        { "com.jivesoftware.util.search.CJKAnalyzer",                "Chinese, Japanese and Korean" },
        { "com.jivesoftware.util.search.DanishStemmingAnalyzer",     "Danish *" },
        { "com.jivesoftware.util.search.DutchStemmingAnalyzer",      "Dutch *" },
        { "com.jivesoftware.util.search.EnglishStemmingAnalyzer",    "English *" },
        { "com.jivesoftware.util.search.FinnishStemmingAnalyzer",    "Finnish *" },
        { "com.jivesoftware.util.search.FrenchStemmingAnalyzer",     "French *" },
        { "com.jivesoftware.util.search.GermanStemmingAnalyzer",     "German *" },
        { "com.jivesoftware.util.search.ItalianStemmingAnalyzer",    "Italian *" },
        { "com.jivesoftware.util.search.NorwegianStemmingAnalyzer",  "Norwegian *" },
        { "com.jivesoftware.util.search.PortugueseStemmingAnalyzer", "Portuguese *" },
        { "com.jivesoftware.util.search.RussianStemmingAnalyzer",    "Russian *" },
        { "com.jivesoftware.util.search.SpanishStemmingAnalyzer",    "Spanish *" },
        { "com.jivesoftware.util.search.SwedishStemmingAnalyzer",    "Swedish *" }
    };
%>

<%	// Permission check
    if (!isSystemAdmin) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }

    // get parameters
    boolean searchEnabled = ParamUtils.getBooleanParameter(request,"searchEnabled");
    boolean setSearchEnabled = ParamUtils.getBooleanParameter(request,"setSearchEnabled");
    boolean saveSettings = ParamUtils.getBooleanParameter(request,"saveSettings");
	boolean autoIndexEnabled = ParamUtils.getBooleanParameter(request,"autoIndexEnabled");
    boolean wildcardIgnored = ParamUtils.getBooleanParameter(request,"wildcardIgnored");
    boolean groupByThread = ParamUtils.getBooleanParameter(request,"groupByThread");
    int updateInterval = ParamUtils.getIntParameter(request,"updateInterval",5);
	boolean doUpdateIndex = ParamUtils.getBooleanParameter(request,"doUpdateIndex");
    boolean doRebuildIndex = ParamUtils.getBooleanParameter(request,"doRebuildIndex");
    boolean doOptimizeIndex = ParamUtils.getBooleanParameter(request,"doOptimizeIndex");
    boolean isOptimizing = ParamUtils.getBooleanParameter(request,"isOptimizing");
    String indexType = ParamUtils.getParameter(request,"indexType");

    if (indexType == null) {
        indexType = JiveGlobals.getJiveProperty("search.analyzer.className");

        if (indexType == null) {
            indexType = "com.jivesoftware.util.search.StandardSynonymAnalyzer";
        }
    }

    // Get the search manager
	SearchManager searchManager = forumFactory.getSearchManager();

    // enable or disable search
    if (setSearchEnabled) {
        searchManager.setSearchEnabled(searchEnabled);
        response.sendRedirect("searchSettings.jsp");
        return;
    }

    // Alter search settings
    if (saveSettings) {
        // auto indexing
        searchManager.setAutoIndexEnabled(autoIndexEnabled);
        // index interval
        searchManager.setAutoIndexInterval(updateInterval);
        // indexer type
        DbSearchManager.setAnalyzer(indexType);
        // wildcards
        searchManager.setWildcardIgnored(wildcardIgnored);
        // group results by thread:
        if (groupByThread) {
            JiveGlobals.setJiveProperty("search.results.groupByThread","true");
        }
        else {
            JiveGlobals.setJiveProperty("search.results.groupByThread","false");
        }
        // All done, so redirect and indicate success:
        response.sendRedirect("searchSettings.jsp?success=true");
    }

    // update index if requested
    if (doUpdateIndex) {
        searchManager.updateIndex();
        // wait 1 second before returning to give the search indexer a chance to start:
        try {
            Thread.sleep(1000L);
        }
        catch (InterruptedException ignored) {}
        response.sendRedirect("searchSettings.jsp");
        return;
    }

    // rebuild index if requested
    if (doRebuildIndex) {
        searchManager.rebuildIndex();
        // wait 1 second before returning to give the search indexer a chance to start:
        try {
            Thread.sleep(1000L);
        }
        catch (InterruptedException ignored) {}
        response.sendRedirect("searchSettings.jsp");
        return;
    }

    if (doOptimizeIndex) {
        searchManager.optimize();
        // wait 1 second before returning to give the search indexer a chance to start:
        try {
            Thread.sleep(1000L);
        }
        catch (InterruptedException ignored) {}
        response.sendRedirect("searchSettings.jsp?isOptimizing=true");
        return;
    }

    wildcardIgnored = searchManager.isWildcardIgnored();
	autoIndexEnabled = searchManager.isAutoIndexEnabled();
    searchEnabled = searchManager.isSearchEnabled();
    updateInterval = searchManager.getAutoIndexInterval();
    groupByThread = "true".equals(JiveGlobals.getJiveProperty("search.results.groupByThread"));
%>

<%@ include file="header.jsp" %>

<%  // Title of this page and breadcrumbs
    String title = "Search Settings";
    String[][] breadcrumbs = {
        {"Main", "main.jsp"},
        {"Search Settings", "searchSettings.jsp"}
    };
%>
<%@ include file="title.jsp" %>

<%  // If we're doing any indexing operation, display a message
    if (searchManager.isBusy()) {
%>
    <%  if (isOptimizing) { %>

        <script language="JavaScript" type="text/javascript">
        function reloadPage() {
            location.href='searchSettings.jsp?isOptimizing=true';
        }
        setTimeout(reloadPage,4000);
        </script>

        <p><b>Optimizing...</b></p>
        <ul>
            Jive Forums is currently optimizing the search index. This may take
            a few moments....
        </ul>

    <%  } else { %>

        <script language="JavaScript" type="text/javascript">
        function reloadPage() {
            location.href='searchSettings.jsp?isIndexing=true';
        }
        setTimeout(reloadPage,4000);
        </script>

        <p><b>Indexing...</b></p>
        <ul>
            <b><%= searchManager.getPercentComplete() %>% complete.</b>

            <%  if (searchManager.getTotalCount() != -1) { %>

                Documents indexed:
                <%= LocaleUtils.getLocalizedNumber(searchManager.getCurrentCount(), JiveGlobals.getLocale()) %>,
                total documents:
                <%= LocaleUtils.getLocalizedNumber(searchManager.getTotalCount(), JiveGlobals.getLocale()) %>.
                <p>
                Jive Forums is currently updating or rebuilding the search index. This may take
                a few moments....

            <%  } %>
            </p>
        </ul>

    <%  } %>

<%
    }
    else {
        // Else, if the search manager is not busy, show search settings:
%>

    <table cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td>
            <b>Search Status</b>
        </td>
        <td>
            <a href="#" onclick="helpwin('search','search_status');return false;"
             title="Click for help"
             ><img src="images/help-16x16.gif" width="16" height="16" border="0" hspace="8"></a>
        </td>
    </tr>
    </table>

    <ul>
        <p>
        Turn the search feature on or off:
        </p>

        <form action="searchSettings.jsp">
        <input type="hidden" name="setSearchEnabled" value="true">
        <table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="300">
        <tr><td>
            <table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
            <tr bgcolor="#ffffff">
                <td align="center"<%= (searchEnabled)?" bgcolor=\"#99cc99\"":"" %>>

                    <input type="radio" name="searchEnabled" value="true" id="rb01"
                     <%= (searchEnabled)?"checked":"" %>>
                    <label for="rb01"><%= (searchEnabled)?"<b>On</b>":"On" %></label>

                </td>
                <td align="center"<%= (!searchEnabled)?" bgcolor=\"#cc6666\"":"" %>>

                    <input type="radio" name="searchEnabled" value="false" id="rb02"
                     <%= (!searchEnabled)?"checked":"" %>>
                    <label for="rb02"><%= (!searchEnabled)?"<b>Off</b>":"Off" %></label>

                </td>
                <td align="center">
                    <input type="submit" value="Update">
                </td>
            </tr>
            </table>
        </td></tr>
        </table>
        </form>

        <%  // Show index info if search is enabled
            if (searchEnabled) {
                // Compute the size of the index:
                double size = 0;
                DecimalFormat megFormatter = new DecimalFormat("#,##0.00");
                File searchHome = new File(JiveGlobals.getJiveHome() + File.separator + "search"
                        + File.separator + JiveGlobals.getJiveProperty("search.directory"));
                if (searchHome.exists()) {
                    File[] files = searchHome.listFiles();
                    for (int i=0; i<files.length; i++) {
                        size += files[i].length();
                    }
                    size /= 1024.0*1024.0;
                }
        %>
                <table cellpadding="2" cellspacing="0" border="0">
                <tr>
                    <td>Index Location:</td>
                    <td><%= searchHome %></td>
                </tr>
                <tr>
                    <td>Index Files:</td>
                    <td><%= LocaleUtils.getLocalizedNumber(searchHome.listFiles().length) %></td>
                </tr>
                <tr>
                    <td>Index Size:</td>
                    <td><%= megFormatter.format(size) %> MB</td>
                </tr>
                <tr>
                    <td>Index Last Updated:</td>
                    <td>
                        <%= SkinUtils.formatDate(request,pageUser,searchManager.getLastIndexedDate()) %>
                    </td>
                </tr>
                </table>

        <%  } %>

    </ul>

    <%  // only show the following section if the search feature is enabled
        if (searchEnabled) {
    %>
        <table cellpadding="0" cellspacing="0" border="0">
        <tr>
            <td>
                <b>Search Settings</b>
            </td>
            <td>
                <a href="#" onclick="helpwin('search','index_settings');return false;"
                 title="Click for help"
                 ><img src="images/help-16x16.gif" width="16" height="16" border="0" hspace="8"></a>
            </td>
        </tr>
        </table>

        <ul>
            <%  if ("true".equals(request.getParameter("success"))) { %>

                <p class="jive-success-text">
                Settings updated successfully.
                </p>

            <%  } %>

            <form action="searchSettings.jsp" method="post" name="settingsForm">
            <input type="hidden" name="saveSettings" value="true">

            <table cellpadding="3" cellspacing="0" border="0">
            <tr>
                <td>
                    Automatically index forum content:
                </td>
                <td>
                    <input type="radio" name="autoIndexEnabled" value="true"
                     id="aie01" <%= (autoIndexEnabled)?"checked":"" %>>
                    <label for="aie01">Yes</label>
                    &nbsp;
                    <input type="radio" name="autoIndexEnabled" value="false" id="aie02"
                     <%= (!autoIndexEnabled)?"checked":"" %>>
                    <label for="aie02">No</label>
                </td>
            </tr>
            <tr>
                <td>
                    Index update time (in minutes):
                </td>
                <td>
                    <select size="1" name="updateInterval">
                        <%  for (int i=1; i<=60;) {
                                String selected = "";
                                if (updateInterval == i) {
                                    selected = " selected";
                                }
                        %>
                            <option value="<%= i %>"<%= selected %>><%= i %>

                            <%  if (i >= 10) {
                                    i+=5;
                                } else {
                                    i++;
                                }
                            %>

                        <%  } %>
                    </select>
                </td>
            </tr>
            <tr>
                <td>
                    Indexer Type (* Supports
                    <a href="#" onclick="helpwin('search','index_settings');return false;"
                     >Stemming</a>):
                </td>
                <td>
                    <select size="1" name="indexType" onchange="handleIndexChange(this);">
                    <%  for (int i=0; i<INDEXERS.length; i++) { %>

                        <option value="<%= INDEXERS[i][0] %>"
                         <%= (indexType.equals(INDEXERS[i][0])?" selected":"") %>
                         ><%= INDEXERS[i][1] %>

                    <%  } %>
                    </select>
                </td>
            </tr>
            <tr>
                <td>
                    Allow wildcards in search queries (ie, *, ~, ?):
                </td>
                <td>
                    <input type="radio" name="wildcardIgnored" value="false"
                     id="wi01" <%= (!wildcardIgnored)?"checked":"" %> >
                    <label for="wi01">Yes</label>
                    &nbsp;
                    <input type="radio" name="wildcardIgnored" value="true"
                     id="wi02" <%= (wildcardIgnored)?"checked":"" %>>
                    <label for="wi02">No</label>
                </td>
            </tr>
            <tr>
                <td>
                    Group search results by thread:
                </td>
                <td>
                    <input type="radio" name="groupByThread" value="true"
                     id="gbt01" <%= (groupByThread)?"checked":"" %>>
                    <label for="gbt01">Yes</label>
                    &nbsp;
                    <input type="radio" name="groupByThread" value="false"
                     id="gbt02" <%= (!groupByThread)?"checked":"" %>>
                    <label for="gbt02">No</label>
                </td>
            </tr>
            </table>

            <br>

            <input type="submit" value="Save Settings">
            </form>

            <script language="JavaScript" type="text/javascript">
            var index = document.settingsForm.indexType.selectedIndex;
            function handleIndexChange(el) {
                var message = "Warning: You will need to rebuild your search index after changing the index type.\n\n";
                message += "Are you sure you want to proceed?";
                var proceed = confirm(message);
                if (!proceed) {
                    el.selectedIndex = index;
                }
            }
            </script>

        </ul>

        <form action="searchSettings.jsp">
        <table cellpadding="0" cellspacing="0" border="0">
        <tr>
            <td>
                <b>Update Index</b>
            </td>
            <td>
                <a href="#" onclick="helpwin('search','update_index');return false;"
                 title="Click for help"
                 ><img src="images/help-16x16.gif" width="16" height="16" border="0" hspace="8"></a>
            </td>
        </tr>
        </table>

        <ul>
            <p>
            Manually update the index. This will update the search index with new content since
            it was last updated on
            <%= SkinUtils.formatDate(request,pageUser,searchManager.getLastIndexedDate()) %>.
            </p>

            <input type="hidden" name="doUpdateIndex" value="true">
            <input type="submit" value="Update Index">
        </ul>
        </form>

        <form action="searchSettings.jsp">
        <table cellpadding="0" cellspacing="0" border="0">
        <tr>
            <td>
                <b>Rebuild Index</b>
            </td>
            <td>
                <a href="#" onclick="helpwin('search','rebuild_index');return false;"
                 title="Click for help"
                 ><img src="images/help-16x16.gif" width="16" height="16" border="0" hspace="8"></a>
            </td>
        </tr>
        </table>

        <ul>
            <p>
            Manually rebuild the index. This will re-index <i>all</i> content and may take a
            long time if you have a lot of content.
            </p>

            <input type="hidden" name="doRebuildIndex" value="true">
            <input type="submit" value="Rebuild Index">
        </ul>
        </form>

        <form action="searchSettings.jsp">
        <table cellpadding="0" cellspacing="0" border="0">
        <tr>
            <td>
                <b>Optimize Index</b>
            </td>
            <td>
                <a href="#" onclick="helpwin('search','optimize_index');return false;"
                 title="Click for help"
                 ><img src="images/help-16x16.gif" width="16" height="16" border="0" hspace="8"></a>
            </td>
        </tr>
        </table>

        <ul>
            <p>
            Optimize the index for quicker searches. Note, this rarely needs to be done but can
            help if you have a lot of data.
            </p>

            <input type="hidden" name="doOptimizeIndex" value="true">
            <input type="submit" value="Optimize Index">
        </ul>
        </form>

    <%  } %>

<%  } %>

<%@ include file="footer.jsp" %>

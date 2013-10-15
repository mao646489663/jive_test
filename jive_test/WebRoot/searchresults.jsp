<%--
  - $RCSfile: searchresults.jsp,v $
  - $Revision: 1.26.2.3 $
  - $Date: 2003/06/25 04:51:45 $
  -
  - Copyright (C) 2002-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software. Use is subject to license terms.
--%>

<%@ page import="com.jivesoftware.forum.action.SearchAction,
                 java.util.Date,
                 com.jivesoftware.forum.*,
                 com.jivesoftware.util.*,
                 com.jivesoftware.forum.action.util.*"
%>

<%@ include file="global.jsp" %>

<%@ taglib uri="webwork" prefix="ww" %>
<%@ taglib uri="jivetags" prefix="jive" %>

<%  // Get the action for this view.
    SearchAction action = (SearchAction)getAction(request);
    String queryText = action.getQ();
%>

<jsp:include page="header.jsp" flush="true" />

<div style="width:960px; margin:0px auto;">

<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr valign="top">
    <td width="98%">

        <%-- Breadcrumbs (customizable via the admin tool) --%>

        <jsp:include page="breadcrumbs.jsp" flush="true" />

        <%-- Forum name and brief info about the forum --%>

        <p class="jive-page-title">
        <%-- Forum Search --%>
        <jive:i18n key="search.title" />
        </p>

        <%--
            Use the form below to search the forum content. You can choose to search all content
            or restrict it to certain forums or dates. Also, you can filter the results by
            a username or user ID.
        --%>
        <jive:i18n key="search.description" />

    </td>
    <td width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>
    <td width="1%">

        <%@ include file="accountbox.jsp" %>

    </td>
</tr>
</table>

<br>

<form action="search!execute.jspa" name="searchform">
<%  long categoryID = ParamUtils.getLongParameter(request, "categoryID", -1L);
    long forumID = ParamUtils.getLongParameter(request, "forumID", -1L);

    if (categoryID != -1L) {
%>
    <input type="hidden" name="categoryID" value="<%= categoryID %>">
<%  }
    if (forumID != -1) {
%>
    <input type="hidden" name="forumID" value="<%= forumID %>">
<%  } %>

<div class="jive-search-form">
<table cellpadding="3" cellspacing="0" border="0" width="100%">
<tr>
    <th colspan="3">
        <%-- Search Forum Content --%>
        <jive:i18n key="search.search_forum_content" />
    </th>
</tr>
<tr>
    <td align="right" width="1%" nowrap>
        <%-- Search Terms: --%>
        <jive:i18n key="search.search_terms" /><jive:i18n key="global.colon" />
    </td>
    <td width="1%"><input type="text" name="q" size="40" maxlength="100" value="<%= ((queryText != null) ? queryText : "") %>"></td>
    <%-- Search (button) --%>
    <td width="98%"><input type="submit" value="<jive:i18n key="global.search" />"></td>
</tr>
<ww:if test="errors['q']">
    <tr>
        <td align="right" width="1%" nowrap>&nbsp;</td>
        <td colspan="2" width="99%">
            <span class="jive-error-text">
            <ww:property value="errors['q']" />
            </span>
        </td>
    </tr>
</ww:if>
<tr>
    <td align="right" width="1%" nowrap>
        <%-- Category or Forum: --%>
        <jive:i18n key="search.category_or_forum" /><jive:i18n key="global.colon" />
    </td>
    <td colspan="2" width="99%">
        <select size="1" name="objID">
        <option value="" style="border-bottom:2px #ccc solid">
        <%-- All Categories --%>
          <jive:i18n key="search.all_categories" />

        <%-- Print all root-level forums --%>
        <%  for (Iterator iter=action.getForumFactory().getForums(); iter.hasNext(); ) {
                Forum f = (Forum)iter.next();
        %>
            <option value="f<%= f.getID() %>"
                <%= ((action.getForumSelected(f.getID())) ? " selected" : "") %>
            >&nbsp;

            &#149; <%= f.getName() %>

        <%  } %>

        <%  // Get the root level category
            ForumCategory root = action.getForumFactory().getRootForumCategory();
        %>

        <%-- Print all categories and forums --%>
        <%  for (Iterator cats=root.getRecursiveCategories(); cats.hasNext(); ) {
                ForumCategory c = (ForumCategory)cats.next();
        %>
            <option value="c<%= c.getID() %>" style="border-bottom:1px #ccc dotted"
                <%= ((action.getCategorySelected(c.getID())) ? " selected" : "") %>
                >

            <%= getSpacer("&nbsp;&nbsp;",c.getCategoryDepth()) %>

            <%= c.getName() %>

            <%-- Loop through the forums in this category --%>
            <%  for (Iterator forums=c.getForums(); forums.hasNext(); ) {
                    Forum f = (Forum)forums.next();
            %>
                <option value="f<%= f.getID() %>" style="border-bottom:1px #ccc dotted"
                    <%= ((action.getForumSelected(f.getID())) ? " selected" : "") %>
                >&nbsp;

                <%= getSpacer("&nbsp;&nbsp;",c.getCategoryDepth()) %>

                &#149; <%= f.getName() %>

            <%  } %>

        <%  } %>

        </select>
    </td>
</tr>
<tr>
    <td align="right" width="1%" nowrap>
        <%-- Date Range: --%>
        <jive:i18n key="search.date_range" /><jive:i18n key="global.colon" />
    </td>
    <td colspan="2" width="99%">

        <select size="1" name="dateRange">

        <%  // Print out available dates
            RelativeDateRange[] ranges = action.getDateRanges();
            String currentRangeID = action.getDateRange();
            Date now = new Date();

            for (int i=0; i<ranges.length; i++) {
                RelativeDateRange range = ranges[i];
        %>
            <option value="<%= range.getID() %>"
             <%= ((range.getID().equals(currentRangeID)) ? "selected" : "") %>>

             <jive:i18n key="<%= range.getI18nKey() %>" />

             <% if (!"all".equals(range.getID())) { %>

                 -
                 <%= action.getShortDateFormat().format(range.getStartDate(now)) %>

             <% } %>

        <%
            }
        %>

        </select>
    </td>
</tr>
<tr>
    <td align="right" width="1%" nowrap>
        <%-- Username or User ID: --%>
        <jive:i18n key="search.username" /><jive:i18n key="global.colon" />
    </td>
    <td colspan="2" width="99%">
        <input type="text" name="userID" size="20" maxlength="50"
        <%  if (action.getSearchedUser() != null) { %>

            value="<%= action.getSearchedUser().getUsername() %>"

        <%  } else if (action.getUserID() != null) { %>

            value="<%= action.getUserID() %>"

        <%  } else { %>

            value=""

        <%  } %>
        >
        <span class="jive-description">
        <%-- (Leave field blank to search all users) --%>
        <jive:i18n key="search.note" />
        </span>
    </td>
</tr>
<ww:if test="errors['userID']">
    <tr>
        <td align="right" width="1%" nowrap>&nbsp;</td>
        <td colspan="2" width="99%">
            <span class="jive-error-text">
            <ww:property value="errors['userID']" />
            </span>
        </td>
    </tr>
</ww:if>
<tr>
    <td align="right" width="1%" nowrap>
        <%-- Results Per Page: --%>
        <jive:i18n key="search.results_page" /><jive:i18n key="global.colon" />
    </td>
    <td colspan="2" width="99%">
        <select size="1" name="numResults">
        <%-- loop through the number of results options --%>
        <%  int[] numResultOptions = action.getNumResultOptions();
            for (int i=0; i<numResultOptions.length; i++) {
        %>
            <option value="<%= numResultOptions[i] %>"
                <%= ((action.getNumResults() == numResultOptions[i]) ? " selected" : "") %>
            >
            <%= numResultOptions[i] %>

        <%  } %>
        </select>
    </td>
</tr>
</table>
</div>

</form>

<script language="JavaScript" type="text/javascript">
<!--
document.searchform.q.focus();
//-->
</script>

<%  // Get the Iterator of results:
    Iterator results = action.getResults();
    if (results != null) {
        // counter for num results
        int resultNum = action.getResultStart();
%>
    <div class="jive-search-results">
    <table cellpadding="3" cellspacing="0" border="0" width="100%">
    <tr>
        <th colspan="2" style="text-align:left;border-bottom:1px #ccc solid;">

            <%  if (action.getResultCount() == 0) { %>

                <%-- No Results - please try a less restrictive search. --%>
                <jive:i18n key="search.no_results" />

            <%  } else { %>

                <%-- Results: {NUM} --%>
                <jive:i18n key="search.result_count">
                    <jive:arg>
                        <%= action.getNumberFormat().format(action.getResultCount()) %>
                    </jive:arg>
                </jive:i18n>

                <%  if (queryText != null) { %>

                    &nbsp;
                    <%-- Search Terms: {terms} --%>
                    <jive:i18n key="search.search_terms_display">
                        <jive:arg>
                            <%= StringUtils.escapeHTMLTags(queryText) %>
                        </jive:arg>
                    </jive:i18n>

                <%  } %>

            <%  } %>

        </th>
    </tr>

    <%  if (action.getCorrectedQ() != null) { %>

        <tr>
            <td align="right" width="1%" nowrap>
            <%-- Perhaps You Meant: --%>
                <span class="jive-error-text">
                <jive:i18n key="search.did_you_mean" /><jive:i18n key="global.colon" />
                </span>
            </td>
            <td colspan="2" width="99%">
            <a href="search!execute.jspa?<ww:property value="correctedSearchParams" />">
            <ww:property value="correctedQ" /></a>
            </td>
        </tr>

    <%  } %>

    <%  Paginator paginator = new Paginator(action);
        if (action.getResultCount() > 0 && paginator.getNumPages() > 1) {
    %>

        <tr>
            <td colspan="2" style="text-align:left;border-bottom:1px #ccc solid;">
            <jive:cache id="paginator">

                <%-- Pages: XXX --%>
                <jive:i18n key="global.pages" /><jive:i18n key="global.colon" />
                <%= paginator.getNumPages() %>

                <%  if (paginator.getNumPages() > 1) { %>

                    <span class="jive-paginator">
                    [
                    <%  if (paginator.getPreviousPage()) { %>

                        <%-- previous --%>
                        <a href="search!execute.jspa?<%= action.getSearchParams() %>&start=<%= paginator.getPreviousPageStart() %>"
                         ><jive:i18n key="global.previous" /></a> |

                    <%  } %>

                    <%-- show result page numbers --%>
                    <%  Page[] pages = paginator.getPages();
                        for (int i=0; i<pages.length; i++) {
                    %>
                        <%  if (pages[i] != null) { %>

                            <a href="search!execute.jspa?<%= action.getSearchParams() %>&start=<%= pages[i].getStart() %>"
                             class="<%= ((pages[i].getStart()==action.getStart()) ? "jive-current" : "") %>"
                             ><%= pages[i].getNumber() %></a>

                        <%  } else { %>

                            ...

                        <%  } %>

                    <%  } %>

                    <%  if (paginator.getNextPage()) { %>

                        <%-- previous --%>
                        | <a href="search!execute.jspa?<%= action.getSearchParams() %>&start=<%= paginator.getNextPageStart() %>"
                         ><jive:i18n key="global.next" /></a>

                    <%  } %>
                    ]
                    </span>

                <%  } %>

            </jive:cache>
            </td>
        </tr>

    <%  } %>

    <tr><td colspan="2">&nbsp;</td></tr>
    </table>

    <%-- Loop through all search results for this page: --%>
    <%  while (results.hasNext()) {
            ForumMessage message = (ForumMessage)results.next();
    %>

        <table cellpadding="3" cellspacing="0" border="0" width="100%">
        <tr valign="top">
            <td width="1%"><%= (resultNum++) %>)</td>
            <td width="99%">
                <span class="jive-search-result">
                <a href="thread.jspa?forumID=<%= message.getForumThread().getForum().getID() %>&threadID=<%= message.getForumThread().getID() %>&messageID=<%= message.getID() %>#<%= message.getID() %>"
                 ><%= message.getSubject() %></a>
                <br>
                <span class="jive-info">
                <%--
                    Posted on: {date}, by: {user}
                --%>
                <jive:i18n key="search.search_result_info">
                    <jive:arg>
                        <%= action.getDateFormat().format(message.getCreationDate()) %>
                    </jive:arg>
                    <jive:arg>
                        <%  if (message.getUser() != null) { %>

                            <a href="profile.jspa?userID=<%= message.getUser().getID() %>"
                             ><%= message.getUser().getUsername() %></a>

                        <%  } else { %>

                            <%-- use a guest bean to format the display of guest properties --%>
                            <%  Guest guest = new Guest();
                                guest.setMessage(message);
                            %>
                            <%  if (guest.getEmail() != null) { %>

                                <i><a href="mailto:<%= StringUtils.escapeHTMLTags(guest.getEmail()) %>"
                                    ><%= guest.getDisplay() %></a></i>

                            <%  } else { %>

                                <i><%= guest.getDisplay() %></i>

                            <%  } %>

                        <%  } %>
                    </jive:arg>
                </jive:i18n>
                </span>

                <%  if (queryText != null) { %>

                    <br>
                    <%  String bodyPreview = action.getMessageBodyPreview(message);
                        if (bodyPreview != null) {
                    %>
                        <span class="jive-body">
                        <%= bodyPreview %>
                        </span>

                    <%  } %>

                <%  } %>

                </span>
                <% if (action.isDisplayPerThread() && action.getThreadID() == null) {
                %>
                <br>
                    <span>
                        <a href="search!execute.jspa?<%=action.getSearchParams()%>&threadID=<%= message.getForumThread().getID() %>"><jive:i18n key="search.search_within_thread"/></a>
                    <span>
                <%
                }
                %>
                <br><br>
            </td>
        </tr>
        </table>

    <%  } %>

    <%  if (results != null) { %>

        <table cellpadding="3" cellspacing="0" border="0" width="100%">
            <tr>
                <td colspan="2" style="text-align:left;border-top:1px #ccc solid;">
                    <jive:cache id="paginator" />
                </td>
            </tr>
        </table>

    <%  } %>
    </span>

<%  } else { %>

    <%  if (queryText != null) { %>

        <br><hr size="0">

        <p>
        <%--
            No search results for "{0}". You should try a less restrictive search.
        --%>
        <jive:i18n key="search.no_results_query">
            <jive:arg>
                <%= StringUtils.escapeHTMLTags(queryText) %>
            </jive:arg>
        </jive:i18n>
        </p>

    <%  } %>

<%  } %>

</div>

<jsp:include page="footer.jsp" flush="true" />

<%! // Method for printing spacers
    String getSpacer(String spacer, int num) {
        if (num <= 1) {
            return spacer;
        }
        StringBuffer buf = new StringBuffer(spacer.length()*num);
        for (int i=0; i<num; i++) {
            buf.append(spacer);
        }
        return buf.toString();
    }
%>

<%--
  - $RCSfile: category.jsp,v $
  - $Revision: 1.2.2.5 $
  - $Date: 2003/07/28 16:01:02 $
  -
  - Copyright (C) 1999-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software.  Use is subject to license terms.
--%>

<%@ page import="java.util.Iterator,
                 com.jivesoftware.forum.*,
                 com.jivesoftware.forum.action.ForumCategoryAction,
                 com.jivesoftware.base.*,
                 com.jivesoftware.forum.action.util.*"
%>

<%@ include file="global.jsp" %>

<%@ taglib uri="webwork" prefix="ww" %>
<%@ taglib uri="jivetags" prefix="jive" %>

<%  // Get the action for this view.
    ForumCategoryAction action = (ForumCategoryAction)getAction(request);
    // Get the forum factory and category - they're often used variables:
    ForumFactory forumFactory = action.getForumFactory();
    ForumCategory category = action.getCategory();
    // Also get the root category
    ForumCategory rootCategory = forumFactory.getRootForumCategory();
%>

<jsp:include page="header.jsp" flush="true" />
<div style="width:960px; margin:0px auto;">
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr valign="top">
    <td width="98%">

        <%-- Breadcrumbs (customizable via the admin tool) --%>

        <jsp:include page="breadcrumbs.jsp" flush="true" />

        <p>
        <span class="jive-page-title">
        <%-- Category: CAT_NAME --%>
        <jive:i18n key="global.category" /><jive:i18n key="global.colon" />
        <%  if (category.equals(rootCategory)) { %>

            <jive:i18n key="global.root_category" />

        <%  } else { %>

            <%= category.getName() %>

        <%  } %>
        </span>
        <br>
        <%-- Sub-Categories: NUM, Forums: NUM --%>
        <jive:i18n key="index.sub_cat_count_forum_count">
            <jive:arg>
                <%= action.getNumberFormat().format(category.getCategoryCount()) %>
            </jive:arg>
            <jive:arg>
                <%= action.getNumberFormat().format(category.getForumCount()) %>
            </jive:arg>
        </jive:i18n>

        <%-- show last post info if there are posts in this forum --%>
        <%  if (category.getMessageCount() > 0) { %>

            &nbsp;
            <%-- Last Post: [category last modified date] --%>
            <jive:i18n key="global.last_post" /><jive:i18n key="global.colon" />
                <%= action.getDateFormat().format(category.getModificationDate()) %>

        <%  } %>

        </p>

        <%  if (category.getDescription() != null) { %>
            <span class="jive-description">
            <%= category.getDescription() %>
            </span>
        <%  } %>

        <%-- Search box --%>

        <form action="search!execute.jspa">
        <input type="hidden" name="dateRange" value="last90days">

        <table cellpadding="3" cellspacing="0" border="0" width="100%">
        <tr>
            <td width="1%" nowrap>
                <%  if (category.equals(rootCategory)) { %>

                    <jive:i18n key="search.search_all" />:

                <%  } else { %>

                    <jive:i18n key="search.search_category" />:

                    <input type="hidden" name="objID" value="c<%= category.getID() %>">

                <%  } %>
            </td>
            <td width="1%" nowrap>
                <input type="text" name="q" value="" size="40" maxlength="100">
            </td>
            <td width="98%">
                <input type="submit" value="<jive:i18n key="global.go" />">
            </td>
        </tr>
        </table>

        </form>

    </td>
    <td width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>
    <td width="1%">

        <%@ include file="accountbox.jsp" %>

    </td>
</tr>
</table>

<br>

<jive:property if="watches.enabled">

    <%  if (action.getPageUser() != null) { %>

        <%  if (action.getForumFactory().getWatchManager().isWatched(action.getPageUser(), category)) { %>

            <table class="jive-info-message" cellpadding="3" cellspacing="0" border="0" width="100%">
            <tr valign="top">
                <td width="1%"><img src="images/info-16x16.gif" width="16" height="16" border="0"></td>
                <td width="99%">

                    <span class="jive-info-text">

                    <%-- You are watching this category. To remove this watch, click "Stop Watching Category" below. --%>
                    <jive:i18n key="index.watching_category" />

                    <%-- Watch options --%>
                    <a href="editwatches!default.jspa"><jive:i18n key="global.watch_options" /></a>

                    </span>

                </td>
            </tr>
            </table>
            <br>

        <%  } %>

    <%  } %>

</jive:property>

<div class="jive-button">
<table cellpadding="0" cellspacing="0" border="0">
<tr>
    <%  if (category.getParentCategory() != null) { %>

        <td>
            <table cellpadding="3" cellspacing="0" border="0">
            <tr>
                <td><a href="category.jspa?categoryID=<%= category.getParentCategory().getID() %>"><img src="images/up-16x16.gif" width="16" height="16" border="0" alt="<jive:i18n key="index.up_one_category" />"></a></td>
                <td>
                    <span class="jive-button-label">
                    <%-- Up one category --%>
                    <a href="index.jspa?categoryID=1"
                     ><jive:i18n key="index.up_one_category" /></a>
                    </span>
                </td>
            </tr>
            </table>
        </td>

    <%  } %>
    <td>
        <table cellpadding="3" cellspacing="0" border="0">
        <tr>
            <td>
                <a href="index.jspa?categoryID=1"
                 ><img src="images/back-to-16x16.gif" width="16" height="16" border="0"
                 alt="<jive:i18n key="index.back_to_main_cat" />"
                 ></a>
            </td>
            <td>
                <span class="jive-button-label">
                <%-- Back to main category --%>
                <a href="index.jspa?categoryID=1"><jive:i18n key="index.back_to_main_cat" /></a>
                </span>
            </td>
        </tr>
        </table>
    </td>

    <jive:property if="watches.enabled">

        <%  if (action.getPageUser() != null) { %>
            <td>
                <table cellpadding="3" cellspacing="0" border="0">
                <tr>
                    <td>
                        <%  boolean isWatched = action.getForumFactory().getWatchManager().isWatched(action.getPageUser(), category);
                            if (isWatched) {
                        %>
                            <a href="watches!remove.jspa?categoryID=<%= category.getID() %>"
                             ><img src="images/watch-16x16.gif" width="16" height="16" border="0" alt="<jive:i18n key="index.stop_watching_category" />"></a>

                        <%  } else { %>

                            <a href="watches!add.jspa?categoryID=<%= category.getID() %>"
                             ><img src="images/watch-16x16.gif" width="16" height="16" border="0" alt="<jive:i18n key="global.watch_category" />"></a>

                        <%  } %>
                    </td>
                    <td>
                        <span class="jive-button-label">
                        <%  if (isWatched) { %>

                            <%-- Stop watching category --%>
                            <a href="watches!remove.jspa?categoryID=<%= category.getID() %>"
                             ><jive:i18n key="index.stop_watching_category" /></a>

                        <%  } else { %>

                            <%-- Watch category --%>
                            <a href="watches!add.jspa?categoryID=<%= category.getID() %>"
                             ><jive:i18n key="global.watch_category" /></a>

                        <%  } %>
                        </span>
                    </td>
                </tr>
                </table>
            </td>
        <%  } %>

    </jive:property>

</tr>
</table>
</div>

<br>

<%-- Category and forum table: --%>

<table id="jive-cat-forum-list" class="jive-list" cellpadding="3" cellspacing="0" width="100%">
<tr>
    <th class="jive-forum-name" colspan="2" width="98%">
        <%-- Forum / Category --%>
        <jive:i18n key="global.forum" />
        <jive:i18n key="global.slash" />
        <jive:i18n key="global.category" />
    </th>
    <th class="jive-counts" nowrap width="1%">
        <%-- Topics / Messages --%>
        <jive:i18n key="global.topics" />
        <jive:i18n key="global.slash" />
        <jive:i18n key="global.messages" />
    </th>
    <th class="jive-date" nowrap width="1%">
        <%-- Last Post --%>
        <jive:i18n key="global.last_post" />
    </th>
</tr>

<%-- Print all forums in the current category --%>

<%  int status = 0;
    for (Iterator forums=category.getForums(); forums.hasNext(); ) {
        Forum forum = (Forum)forums.next();
%>
    <%@ include file="forum-row.jsp" %>

<%  } %>

<%-- Print all subcategories and subforums in this category --%>

<%  for (Iterator categories=category.getCategories(); categories.hasNext();) {
        ForumCategory subCategory = (ForumCategory)categories.next();
%>
    <tr>
        <td class="jive-category-name" colspan="4">
            <a href="category.jspa?categoryID=<%= subCategory.getID() %>"><%= subCategory.getName() %></a>
            <%  if (subCategory.getDescription() != null) { %>
                <span class="jive-description">
                <br><%= subCategory.getDescription() %>
                </span>
            <%  } %>
        </td>
    </tr>

    <%  status = 0;
        for (Iterator forums=subCategory.getForums(); forums.hasNext();) {
            Forum forum = (Forum)forums.next();
    %>
        <%@ include file="forum-row.jsp" %>

    <%  } %>

<%  } %>

</table>

<%  // Print out any topics in this category.
    Iterator threads = action.getThreads();

    // Print out a spacer if there are threads to show, as well as the table header
    if (threads.hasNext()) {
%>
    <a name="topics"></a>
    <p>
    Recent topics in this category:
    </p>

    <div id="jive-topic-list">
    <table class="jive-list" cellpadding="3" cellspacing="0" width="100%">
    <tr>
        <th class="jive-forum-name" colspan="2">
            <%-- Topic --%>
            <jive:i18n key="global.topic" />
        </th>
        <th class="jive-author">
            <%-- Author --%>
            <jive:i18n key="global.author" />
        </th>
        <th class="jive-forum">
            <%-- Author --%>
            <jive:i18n key="global.forum" />
        </th>
        <th class="jive-counts">
            <%-- Replies --%>
            <jive:i18n key="global.replies" />
        </th>
        <th class="jive-date" nowrap>
            <%-- Last Post --%>
            <jive:i18n key="global.last_post" />
        </th>
    </tr>

    <%  // Decleare variables required by the thread-row.jsp page:
        status = 0;
        boolean showForumColumn = true;
        boolean shortLastPost = true;
        RewardManager rewardManager = null;
        boolean rewardsEnabled = "true".equals(JiveGlobals.getJiveProperty("rewards.enabled"));
        if (rewardsEnabled) {
            rewardManager = action.getForumFactory().getRewardManager();
        }
        WatchManager watchManager = null;
        boolean watchesEnabled = "true".equals(JiveGlobals.getJiveProperty("watches.enabled"));
        if (watchesEnabled) {
            watchManager = action.getForumFactory().getWatchManager();
        }
        // Loop through the thread iterator.
        while (threads.hasNext()) {
            ForumThread thread = (ForumThread)threads.next();
    %>
        <%@ include file="thread-row.jsp" %>

    <%  } %>

    </tr></table></div>

    <%  // Get a paginator for this action. Since the action implements Pageable, just pass
        // in the action object to the Paginator constructor

        Paginator paginator = new Paginator(action);
    %>

    <table cellpadding="3" cellspacing="0" border="0" width="100%">
    <tr valign="top">
        <td>

            <%-- Pages: --%>
            <jive:i18n key="global.pages" /><jive:i18n key="global.colon" />
            <%= paginator.getNumPages() %>

            <%  if (paginator.getNumPages() > 1) { %>

                <span class="jive-paginator">
                [
                <%  if (paginator.getPreviousPage()) { %>

                    <%-- Previous --%>
                    <a href="category.jspa?categoryID=<%= category.getID() %>&start=<%= paginator.getPreviousPageStart() %>#topics"
                     ><jive:i18n key="global.previous" /></a> |

                <%  } %>

                <%  Page[] pages = paginator.getPages();
                    for (int i=0; i<pages.length; i++) {
                %>
                    <%  if (pages[i] == null) { %>

                        <jive:i18n key="global.elipse" />

                    <%  } else { %>

                        <a href="category.jspa?categoryID=<%= category.getID() %>&start=<%= pages[i].getStart() %>#topics"
                         class="<%= ((paginator.getStart()==pages[i].getStart())?"jive-current":"") %>"
                         ><%= pages[i].getNumber() %></a>

                     <% } %>

                <%  } %>

                <%  if (paginator.getNextPage()) { %>

                    <%-- Next --%>
                    | <a href="category.jspa?categoryID=<%= category.getID() %>&start=<%= paginator.getNextPageStart() %>#topics"
                     ><jive:i18n key="global.next" /></a>

                <%  } %>
                ]
                </span>

            <%  } %>

        </td>
    </tr>
    </table>

<%  } %>

<%-- Legend --%>

<br>

<table cellpadding="3" cellspacing="0" border="0">
<tr>
    <td><img src="images/unread.gif" width="9" height="9" border="0"></td>
    <td>
        <span class="jive-description">
        <%-- Denotes unread or updated content since your last visit. --%>
        <jive:i18n key="global.new_messages_explained" />
        </span>
    </td>
</tr>
</table>

</div>
<jsp:include page="footer.jsp" flush="true" />
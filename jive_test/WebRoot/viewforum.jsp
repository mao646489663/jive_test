<%--
  - $RCSfile: viewforum.jsp,v $
  - $Revision: 1.18.2.3 $
  - $Date: 2003/07/25 21:26:51 $
  -
  - Copyright (C) 1999-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software.  Use is subject to license terms.
--%>

<%@ page import="com.jivesoftware.forum.action.ForumAction,
                 com.jivesoftware.forum.util.SkinUtils,
                 java.util.Iterator,
                 com.jivesoftware.webwork.util.ValueStack,
                 com.jivesoftware.forum.*,
                 com.jivesoftware.base.*,
                 com.jivesoftware.forum.action.util.*"
%>

<%@ include file="global.jsp" %>

<%@ taglib uri="webwork" prefix="ww" %>
<%@ taglib uri="jivetags" prefix="jive" %>

<%  // Get the action for this view.
    ForumAction action = (ForumAction)getAction(request);
    Forum forum = action.getForum();
%>

<jsp:include page="header.jsp" flush="true" />

<div style="width:960px; margin:0px auto;">

<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr valign="top">
    <td width="98%">

        <%-- Breadcrumbs (customizable via the admin tool) --%>

        <jsp:include page="breadcrumbs.jsp" flush="true" />

        <%-- Forum name and brief info about the forum --%>

        <p>
        <span class="jive-page-title">
        <%-- Forum: [forum name] --%>
        <jive:i18n key="global.forum" /><jive:i18n key="global.colon" />
        <%= forum.getName() %>
        </span>
        <br>
        <%-- Messages: [message count] --%>
        <jive:i18n key="global.messages" /><jive:i18n key="global.colon" />
            <%= action.getNumberFormat().format(forum.getMessageCount()) %> &nbsp;
        <%-- Topics: [topic count] --%>
        <jive:i18n key="global.topics" /><jive:i18n key="global.colon" />
            <%= action.getNumberFormat().format(forum.getThreadCount()) %> &nbsp;

        <%-- show last post info if there are posts in this forum --%>
        <%  if (forum.getMessageCount() > 0) { %>

            <%-- Last Post: [forum last modified date] --%>
            <jive:i18n key="global.last_post" /><jive:i18n key="global.colon" />
                <%= action.getDateFormat().format(forum.getModificationDate()) %>,

            <%-- by: [username, linked to the last post] --%>
            <%  ForumMessage lastPost = SkinUtils.getLastPost(forum); %>

            <%  if (lastPost != null) { %>

                <jive:i18n key="global.by" /><jive:i18n key="global.colon" />
                <%  if (lastPost.getUser() != null) { %>

                    <nobr>
                    <a href="thread.jspa?threadID=<%= lastPost.getForumThread().getID() %>&messageID=<%= lastPost.getID() %>#<%= lastPost.getID() %>"
                     ><%= lastPost.getUser().getUsername() %> &raquo;</a>
                    </nobr>

                <%  } else {
                        Guest guest = new Guest();
                        guest.setMessage(lastPost);
                %>
                    <span class="jive-guest">
                    <nobr>
                    <a href="thread.jspa?threadID=<%= lastPost.getForumThread().getID() %>&messageID=<%= lastPost.getID() %>#<%= lastPost.getID() %>"
                     ><%= guest.getDisplay() %> &raquo;</a>
                    </nobr>
                    </span>

                <%  } %>

            <%  } %>

        <%  } %>
        </p>

        <%-- [forum description] --%>
        <%  if (forum.getDescription() != null) { %>
            <p class="jive-description">
            <%= forum.getDescription() %>
            </p>
        <%  } %>

    </td>
    <td width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>
    <td width="1%">

        <%@ include file="accountbox.jsp" %>

    </td>
</tr>
</table>

<br>

<%-- Print info messages if they exist --%>
<ww:if test="infoMessages/hasNext == true">
    <%@ include file="info-messages.jsp" %>
    <br><br>
</ww:if>

<jive:property if="watches.enabled">

    <ww:if test="pageUser">

        <%  if (action.getForumFactory().getWatchManager().isWatched(action.getPageUser(), forum)) { %>

            <table class="jive-info-message" cellpadding="3" cellspacing="0" border="0" width="100%">
            <tr valign="top">
                <td width="1%"><img src="images/info-16x16.gif" width="16" height="16" border="0"></td>
                <td width="99%">

                    <span class="jive-info-text">

                    <%-- You are watching this forum. To remove this watch, click "Stop Watching Forum" below. --%>
                    <jive:i18n key="forum.watching_forum" />

                    <%-- More watch options --%>
                    <a href="editwatches!default.jspa"><jive:i18n key="global.watch_options" /></a>

                    </span>

                </td>
            </tr>
            </table>
            <br>

        <%  } %>

    </ww:if>

</jive:property>

<div class="jive-button">
<table cellpadding="0" cellspacing="0" border="0">
<tr>
    <% if (!"true".equals(action.getForum().getProperty("jiveDisablePostLinks"))) { %>
        <td>
            <table cellpadding="3" cellspacing="0" border="0">
            <tr>
                <td><a href="post!default.jspa?forumID=<%= forum.getID() %>"><img src="images/post-16x16.gif" width="16" height="16" border="0"></a></td>
                <td>
                    <span class="jive-button-label">
                    <%-- Post New Topic --%>
                    <a href="post!default.jspa?forumID=<%= forum.getID() %>"
                     ><jive:i18n key="global.post_new_topic" /></a>
                    </span>
                </td>
            </tr>
            </table>
        </td>
    <%  } %>

    <%  if (!"false".equals(JiveGlobals.getJiveProperty("search.enabled"))) { %>

        <td>
            <table cellpadding="3" cellspacing="0" border="0">
            <tr>
                <td><a href="search!default.jspa?forumID=<%= forum.getID() %>"><img src="images/search-16x16.gif" width="16" height="16" border="0"></a></td>
                <td>
                    <span class="jive-button-label">
                    <%-- Search Forum --%>
                    <a href="search!default.jspa?forumID=<%= forum.getID() %>"
                     ><jive:i18n key="global.search_forum" /></a>
                    </span>
                </td>
            </tr>
            </table>
        </td>

    <%  } %>

    <%  if (!action.isGuest()) { %>

        <jive:property if="watches.enabled">
            <td>
                <table cellpadding="3" cellspacing="0" border="0">
                <tr>
                    <td>
                        <%  boolean isWatching = action.getForumFactory().getWatchManager().isWatched(action.getPageUser(), forum);
                            if (isWatching) {
                        %>
                            <a href="watches!remove.jspa?forumID=<%= forum.getID() %>"
                             ><img src="images/watch-16x16.gif" width="16" height="16" border="0" alt="<jive:i18n key="forum.stop_watch" />"></a>

                        <%  } else { %>

                            <a href="watches!add.jspa?forumID=<%= forum.getID() %>"
                             ><img src="images/watch-16x16.gif" width="16" height="16" border="0" alt="<jive:i18n key="global.watch_forum" />"></a>

                        <%  } %>
                    </td>
                    <td>
                        <span class="jive-button-label">

                        <%  if (isWatching) { %>

                            <%-- stop watching forum --%>
                            <a href="watches!remove.jspa?forumID=<%= forum.getID() %>"
                             ><jive:i18n key="forum.stop_watch" /></a>

                        <%  } else { %>

                            <%-- Watch Forum --%>
                            <a href="watches!add.jspa?forumID=<%= forum.getID() %>"
                             ><jive:i18n key="global.watch_forum" /></a>

                        <%  } %>
                        </span>
                    </td>
                </tr>
                </table>
            </td>
        </jive:property>
        <jive:property if="readTracker.enabled">
            <%  if (action.getForumFactory().getReadTracker().getUnreadMessageCount(action.getPageUser(),forum) > 0) { %>
            <td>
                <table cellpadding="3" cellspacing="0" border="0">
                <tr>
                    <td>
                        <%  if (action.getStart() == 0) { %>
                            <a href="markread!execute.jspa?forumID=<%= forum.getID() %>"
                        <%  } else { %>
                            <a href="markread!execute.jspa?forumID=<%= forum.getID() %>&start=<%= action.getStart() %>"
                        <%  } %>
                         ><img src="images/markread-16x16.gif" width="16" height="16" border="0" alt="<jive:i18n key="global.mark_all_topics_as_read" />"
                         ></a>
                    </td>
                    <td>
                        <span class="jive-button-label">
                        <%-- Mark All Topics as Read --%>
                        <%  if (action.getStart() == 0) { %>
                            <a href="markread!execute.jspa?forumID=<%= forum.getID() %>"
                        <%  } else { %>
                            <a href="markread!execute.jspa?forumID=<%= forum.getID() %>&start=<%= action.getStart() %>"
                        <%  } %>
                         ><jive:i18n key="global.mark_all_topics_as_read" /></a>
                        </span>
                    </td>
                </tr>
                </table>
            </td>
            <%  } %>
        </jive:property>

    <%  } %>

    <td>
        <table cellpadding="3" cellspacing="0" border="0">
        <tr>
            <td>
                <a href="index.jspa"
                 ><img src="images/back-to-16x16.gif" width="16" height="16" border="0"
                 alt="<jive:i18n key="global.go_back_to_forum_list" />"
                 ></a>
            </td>
            <td>
                <span class="jive-button-label">
                <%-- Go Back to Forum List --%>
                <a href="index.jspa"
                 ><jive:i18n key="global.go_back_to_forum_list" /></a>
                </span>
            </td>
        </tr>
        </table>
    </td>
</tr>
</table>
</div>

<br>

<jive:cache id="paginator">

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
                    <a href="forum.jspa?forumID=<%= forum.getID() %>&start=<%= paginator.getPreviousPageStart() %>"
                     ><jive:i18n key="global.previous" /></a> |

                <%  } %>

                <%  Page[] pages = paginator.getPages();
                    for (int i=0; i<pages.length; i++) {
                %>
                    <%  if (pages[i] == null) { %>

                        <jive:i18n key="global.elipse" />

                    <%  } else { %>

                        <a href="forum.jspa?forumID=<%= forum.getID() %>&start=<%= pages[i].getStart() %>"
                         class="<%= ((paginator.getStart()==pages[i].getStart())?"jive-current":"") %>"
                         ><%= pages[i].getNumber() %></a>

                     <% } %>

                <%  } %>

                <%  if (paginator.getNextPage()) { %>

                    <%-- Next --%>
                    | <a href="forum.jspa?forumID=<%= forum.getID() %>&start=<%= paginator.getNextPageStart() %>"
                     ><jive:i18n key="global.next" /></a>

                <%  } %>
                ]
                </span>

            <%  } %>

        </td>
    </tr>
    </table>

</jive:cache>

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
    <th class="jive-counts">
        <%-- Replies --%>
        <jive:i18n key="global.replies" />
    </th>
    <th class="jive-date" nowrap>
        <%-- Last Post --%>
        <jive:i18n key="global.last_post" />
    </th>
</tr>

<%-- Print all forums in the current category --%>

<%  int status = 0;
    boolean showForumColumn = false;
    boolean shortLastPost = false;
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
    for (Iterator threads=action.getThreads(); threads.hasNext(); ) {
        ForumThread thread = (ForumThread)threads.next();
%>
    <%@ include file="thread-row.jsp" %>

<%  } %>

</table>
</div>

<jive:cache id="paginator" />

<br>

<table cellpadding="3" cellspacing="0" border="0">
<tr>
    <td><img src="images/unread.gif" width="9" height="9" border="0"></td>
    <td>
        <span class="jive-description">
        <%-- Denotes unread messages since your last visit. --%>
        <jive:i18n key="global.unread_messages_explained" />
        </span>
    </td>
</tr>
<tr>
    <td><img src="images/updated.gif" width="9" height="9" border="0"></td>
    <td>
        <span class="jive-description">
        <%-- Denotes updated messages since your last visit. --%>
        <jive:i18n key="global.updated_messages_explained" />
        </span>
    </td>
</tr>
</table>
</div>
<jsp:include page="footer.jsp" flush="true" />
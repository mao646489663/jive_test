<%--
  -
  - $RCSfile: editwatches.jsp,v $
  - $Revision: 1.23.2.2 $
  - $Date: 2003/06/30 20:54:29 $
  -
--%>

<%@ page import="com.jivesoftware.forum.action.*,
                 com.jivesoftware.base.*,
                 com.jivesoftware.forum.*"
%>

<%@ page import="com.jivesoftware.forum.action.*" %>

<%@ include file="global.jsp" %>

<%@ taglib uri="webwork" prefix="ww" %>
<%@ taglib uri="jivetags" prefix="jive" %>

<%  // Get the action for this view.
    EditWatchesAction action = (EditWatchesAction)getAction(request);

    // Variable to indicate of email watches are enabled:
    boolean emailWatchesEnabled = false;
    if (!"false".equals(JiveGlobals.getJiveProperty("watches.emailNotifyEnabled"))) {
        emailWatchesEnabled = true;
    }
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
        <%-- Your Watches --%>
        <jive:i18n key="watches.title" />
        </p>

        <%@ include file="back-link.jsp" %>

    </td>
    <td width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>
    <td width="1%">

        <%@ include file="accountbox.jsp" %>

    </td>
</tr>
</table>

<br>

<%  String selectedTab = action.getText("global.watches"); %>
<%@ include file="tabs.jsp" %>

<form action="editwatches.jspa" method="post">
<input type="hidden" name="command" value="execute">

<br>

<a name="cats"></a>
<span class="jive-cp-header">
<%-- Watched Categories (COUNT) --%>
<jive:i18n key="watches.watched_cat_count">
    <jive:arg>
        <%= action.getWatchedCategoryCount() %>
    </jive:arg>
</jive:i18n>
</span>
<br><br>

<%  int catRowCount = 0; %>

<%  if (action.getWatchedCategoryCount() > 0) { %>

    <div class="jive-watch-list">

    <table class="jive-box" cellpadding="3" cellspacing="0" border="0" width="100%">
    <tr>
        <th colspan="3" class="jive-name">
            <%-- Category Name --%>
            <jive:i18n key="global.category_name" />
        </th>

        <%  if (emailWatchesEnabled) { %>

            <th nowrap>
                <%-- Email Updates --%>
                <jive:i18n key="global.email_updates" />
            </th>

        <%  } %>

        <th nowrap>
            <%-- Save --%>
            <jive:i18n key="global.save" />
        </th>
        <th nowrap>
            <%-- Delete --%>
            <jive:i18n key="global.delete" />
        </th>
    </tr>

    <%  for (Iterator iter=action.getWatchedCategories(); iter.hasNext(); ) {
            ForumCategory cat = (ForumCategory)iter.next();
            catRowCount++;
    %>
        <tr class="jive-<%= ((catRowCount%2==0) ? "even" : "odd") %>">
            <td width="1%" align="center">
                <%= catRowCount %>
            </td>
            <td class="jive-bullet" width="1%">

                <%  if (action.getReadStatus(cat, ReadTracker.UNREAD)) { %>

                    <img src="images/unread.gif" width="9" height="9" border="0" vspace="4">

                <%  } else if (action.getReadStatus(cat, ReadTracker.UPDATED)) { %>

                    <img src="images/updated.gif" width="9" height="9" border="0" vspace="4">

                <%  } else { %>

                    <img src="images/read.gif" width="9" height="9" border="0" vspace="4">

                <%  } %>

            </td>
            <td width="96%" class="jive-name">
                <a href="index.jspa?categoryID=<%= cat.getID() %>"
                 ><%= cat.getName() %></a>
            </td>

            <%  if (emailWatchesEnabled) { %>

                <td width="1%" align="center">
                    <input type="checkbox" name="email-cat-<%= cat.getID() %>" value="<%= cat.getID() %>"
                     <%= ((action.getHasEmailWatch(cat)) ? "checked" : "") %>>
                </td>

            <%  } %>

            <td width="1%" align="center">
                <input type="checkbox" name="save-cat-<%= cat.getID() %>" value="<%= cat.getID() %>"
                 <%= ((!action.getIsExpirableWatch(cat)) ? "checked" : "") %>>
            </td>
            <td width="1%" align="center" class="jive-delete">
                <input type="checkbox" name="delete-cat-<%= cat.getID() %>" value="<%= cat.getID() %>">
            </td>
        </tr>

    <%  } %>

    <tr class="jive-button-row">
        <td width="97%" colspan="3">
            &nbsp;
        </td>
        <td colspan="<%= ((emailWatchesEnabled) ? "2" : "1") %>" width="2%" align="center" class="jive-update-button">
            <%-- Update Watches --%>
            <input type="submit" name="doCatWatchUpdate" value="<jive:i18n key="global.update_watches" />">
        </td>
        <td width="1%" align="center" class="jive-delete-button">
            <%-- Delete --%>
            <input type="submit" name="doCatWatchDelete" value="<jive:i18n key="global.delete" />">
        </td>
    </tr>
    </table>
    <br>

    </div>

<%  } %>

<a name="forums"></a>
<span class="jive-cp-header">
<%-- Watched Forums (COUNT) --%>
<jive:i18n key="watches.watched_forum_count">
    <jive:arg>
        <%= action.getWatchedForumCount() %>
    </jive:arg>
</jive:i18n>
</span>
<br><br>

<%  int forumRowCount = 0; %>

<%  if (action.getWatchedForumCount() > 0) { %>

    <div class="jive-watch-list">

    <table class="jive-box" cellpadding="3" cellspacing="0" border="0" width="100%">
    <tr>
        <th colspan="3" class="jive-name">
            <%-- Forum Name --%>
            <jive:i18n key="global.forum_name" />
        </th>

        <%  if (emailWatchesEnabled) { %>

            <th nowrap>
                <%-- Email Updates --%>
                <jive:i18n key="global.email_updates" />
            </th>

        <%  } %>

        <th nowrap>
            <%-- Save --%>
            <jive:i18n key="global.save" />
        </th>
        <th nowrap>
            <%-- Delete --%>
            <jive:i18n key="global.delete" />
        </th>
    </tr>

    <%  for (Iterator iter=action.getWatchedForums(); iter.hasNext(); ) {
            Forum forum = (Forum)iter.next();
            forumRowCount++;
    %>

        <tr class="jive-<%= ((forumRowCount%2==0) ? "even" : "odd") %>">
            <td width="1%" align="center">
                <%= forumRowCount %>
            </td>
            <td class="jive-bullet" width="1%">

                <%  if (action.getReadStatus(forum, ReadTracker.UNREAD)) { %>

                    <img src="images/unread.gif" width="9" height="9" border="0" vspace="4">

                <%  } else if (action.getReadStatus(forum, ReadTracker.UPDATED)) { %>

                    <img src="images/updated.gif" width="9" height="9" border="0" vspace="4">

                <%  } else { %>

                    <img src="images/read.gif" width="9" height="9" border="0" vspace="4">

                <%  } %>

            </td>
            <td width="95%" class="jive-name">
                <a href="forum.jspa?forumID=<%= forum.getID() %>"><%= forum.getName() %></a>
            </td>

            <%  if (emailWatchesEnabled) { %>

                <td width="1%" align="center">
                    <input type="checkbox" name="email-forum-<%= forum.getID() %>" value="<%= forum.getID() %>"
                     <%= ((action.getHasEmailWatch(forum)) ? "checked" : "") %>>
                </td>

            <%  } %>

            <td width="1%" align="center">
                <input type="checkbox" name="save-forum-<%= forum.getID() %>" value="<%= forum.getID() %>"
                 <%= ((!action.getIsExpirableWatch(forum)) ? "checked" : "") %>>
            </td>
            <td width="1%" align="center" class="jive-delete">
                <input type="checkbox" name="delete-forum-<%= forum.getID() %>" value="<%= forum.getID() %>">
            </td>
        </tr>

    <%  } %>

    <tr class="jive-button-row">
        <td width="97%" colspan="3">
            &nbsp;
        </td>
        <td colspan="<%= ((emailWatchesEnabled) ? "2" : "1") %>" width="2%" align="center" class="jive-update-button">
            <%-- Update Watches --%>
            <input type="submit" name="doForumWatchUpdate" value="<jive:i18n key="global.update_watches" />">
        </td>
        <td width="1%" align="center" class="jive-delete-button">
            <%-- Delete --%>
            <input type="submit" name="doForumWatchDelete" value="<jive:i18n key="global.delete" />">
        </td>
    </tr>
    </table>
    <br>

    </div>

<%  } %>

<a name="topics"></a>
<span class="jive-cp-header">
<%-- Watched Topics (COUNT) --%>
<jive:i18n key="watches.watched_topic_count">
    <jive:arg>
        <%= action.getWatchedThreadCount() %>
    </jive:arg>
</jive:i18n>
</span>
<br><br>

<%  int threadRowCount = 0; %>

<%  if (action.getWatchedThreadCount() > 0) { %>

    <div class="jive-watch-list">

    <table class="jive-box" cellpadding="3" cellspacing="0" border="0" width="100%">
    <tr>
        <th colspan="3" class="jive-name">
            <%-- Topic --%>
            <jive:i18n key="global.topic" />
        </th>
        <th nowrap>
            <%-- Forum --%>
            <jive:i18n key="global.forum" />
        </th>

        <%  if (emailWatchesEnabled) { %>

            <th nowrap>
                <%-- Email Updates --%>
                <jive:i18n key="global.email_updates" />
            </th>

        <%  } %>

        <th nowrap>
            <%-- Save --%>
            <jive:i18n key="global.save" />
        </th>
        <th nowrap>
            <%-- Delete --%>
            <jive:i18n key="global.delete" />
        </th>
    </tr>

    <%  for (Iterator iter=action.getWatchedThreads(); iter.hasNext(); ) {
            ForumThread thread = (ForumThread)iter.next();
            threadRowCount++;
    %>
        <tr class="jive-<%= ((threadRowCount%2==0) ? "even" : "odd") %>">
            <td width="1%" align="center">
                <%= threadRowCount %>
            </td>
            <td class="jive-bullet" width="1%" nowrap>

                <%  if (action.getReadStatus(thread, ReadTracker.UNREAD)) { %>

                    <img src="images/unread.gif" width="9" height="9" border="0" vspace="4" hspace="2">

                <%  } else if (action.getReadStatus(thread, ReadTracker.UPDATED)) { %>

                    <img src="images/updated.gif" width="9" height="9" border="0" vspace="4" hspace="2">

                <%  } else { %>

                    <img src="images/read.gif" width="9" height="9" border="0" vspace="4" hspace="2">

                <%  } %>

            </td>
            <td width="94%" class="jive-name">
                <a href="thread.jspa?threadID=<%= thread.getID() %>"
                 ><%= thread.getName() %></a>
            </td>
            <td width="1%" nowrap>
                <a href="forum.jspa?forumID=<%= thread.getForum().getID() %>"
                 ><%= thread.getForum().getName() %></a>
            </td>

            <%  if (emailWatchesEnabled) { %>

                <td width="1%" align="center">
                    <input type="checkbox" name="email-thread-<%= thread.getID() %>" value="<%= thread.getForum().getID() %>-<%= thread.getID() %>"
                     <%= ((action.getHasEmailWatch(thread)) ? "checked" : "") %>>
                </td>

            <%  } %>

            <td width="1%" align="center">
                <input type="checkbox" name="save-thread-<%= thread.getID() %>" value="<%= thread.getForum().getID() %>-<%= thread.getID() %>"
                 <%= ((!action.getIsExpirableWatch(thread)) ? "checked" : "") %>>
            </td>
            <td width="1%" align="center" class="jive-delete">
                <input type="checkbox" name="delete-thread-<%= thread.getID() %>" value="<%= thread.getForum().getID() %>-<%= thread.getID() %>">
            </td>
        </tr>

    <%  } %>

    <tr class="jive-button-row">
        <td width="97%" colspan="4">
            &nbsp;
        </td>
        <td colspan="<%= ((emailWatchesEnabled) ? "2" : "1") %>" width="2%" align="center" class="jive-update-button">
            <%-- Update Watches --%>
            <input type="submit" name="doThreadWatchUpdate" value="<jive:i18n key="global.update_watches" />">
        </td>
        <td width="1%" align="center" class="jive-delete-button">
            <%-- Delete --%>
            <input type="submit" name="doThreadWatchDelete" value="<jive:i18n key="global.delete" />">
        </td>
    </tr>
    </table>
    <br>

    </div>

<%  } %>


<a name="users"></a>
<span class="jive-cp-header">
<%-- Watched Users (COUNT) --%>
<jive:i18n key="watches.watched_user_count">
    <jive:arg>
        <%= action.getWatchedUserCount() %>
    </jive:arg>
</jive:i18n>
</span>
<br><br>

<%  int userRowCount = 0; %>

<%  if (action.getWatchedUserCount() > 0) { %>

    <div class="jive-watch-list">

    <table class="jive-box" cellpadding="3" cellspacing="0" border="0" width="100%">
    <tr>
        <th colspan="2" class="jive-name">
            <%-- User --%>
            <jive:i18n key="global.user" />
        </th>
        <th nowrap align="left">
            <%-- Name --%>
            <jive:i18n key="global.name" />
        </th>

        <%  if (emailWatchesEnabled) { %>

            <th nowrap>
                <%-- Email Updates --%>
                <jive:i18n key="global.email_updates" />
            </th>

        <%  } %>

        <th nowrap>
            <%-- Delete --%>
            <jive:i18n key="global.delete" />
        </th>
    </tr>

    <%  for (Iterator iter=action.getWatchedUsers(); iter.hasNext(); ) {
            User user = (User)iter.next();
            userRowCount++;
    %>
        <tr class="jive-<%= ((userRowCount%2==0) ? "even" : "odd") %>">
            <td width="1%" align="center">
                <%= userRowCount %>
            </td>
            <td width="72%" class="jive-name">
                <a href="profile.jspa?userID=<%= user.getID() %>"
                 ><%= user.getUsername() %></a>
            </td>
            <td width="25%" nowrap>
                <a href="profile.jspa?userID=<%= user.getID() %>"
                 ><%= ((user.getName() != null) ? user.getName() : action.getText("global.hidden")) %></a>
            </td>

            <%  if (emailWatchesEnabled) { %>

                <td width="1%" align="center">
                    <input type="checkbox" name="email-user-<%= user.getID() %>" value="<%= user.getID() %>"
                     <%= ((action.getHasEmailWatch(user)) ? "checked" : "") %>>
                </td>

            <%  } %>

            <td width="1%" align="center" class="jive-delete">
                <input type="checkbox" name="delete-user-<%= user.getID() %>" value="<%= user.getID() %>">
            </td>
        </tr>

    <%  } %>
    <tr class="jive-button-row">
        <td width="98%" colspan="3">
            &nbsp;
        </td>

        <%  if (emailWatchesEnabled) { %>

            <td width="1%" align="center" class="jive-update-button">
                <%-- Update Watches --%>
                <input type="submit" name="doUserWatchUpdate" value="<jive:i18n key="global.update_watches" />">
            </td>

        <%  } %>

        <td width="1%" align="center" class="jive-delete-button">
            <%-- Delete --%>
            <input type="submit" name="doUserWatchDelete" value="<jive:i18n key="global.delete" />">
        </td>
    </tr>
    </table>
    <br>

    </div>

<%  } %>

</form>

</div>

<jsp:include page="footer.jsp" flush="true" />
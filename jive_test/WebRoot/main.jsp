<%--
  - $RCSfile: main.jsp,v $
  - $Revision: 1.51.2.4 $
  - $Date: 2003/06/30 23:10:33 $
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
    // Get the category - it will be the root category
    ForumCategory category = action.getCategory();
%>

<jsp:include page="header.jsp" flush="true" />

<div style="width:960px; margin:0px auto;">
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr valign="top">
    <td width="98%">

        <%-- Breadcrumbs (customizable via the admin tool) --%>

        <jsp:include page="breadcrumbs.jsp" flush="true" />

        <%-- Text describing your community (customizable via the admin tool) --%>

        <p>
        <%  if (!"false".equals(getProp("useDefaultWelcomeText"))) { %>
            <jive:i18n key="global.community_text" />
        <%  } else { %>
            <%= getProp("communityDescription") %>
        <%  } %>
        </p>

        <%-- Search box --%>

        <%  if (!"false".equals(JiveGlobals.getJiveProperty("search.enabled"))) { %>

            <form action="search!execute.jspa">
            <input type="hidden" name="dateRange" value="last90days">

            <table cellpadding="0" cellspacing="0" border="0" width="100%">
            <tr>
                <td width="1%" nowrap>

                    <%-- Search All Forums: --%>
                    <jive:i18n key="search.search_all" /><jive:i18n key="global.colon" />

                </td>
                <td width="1%" nowrap>
                    &nbsp;
                    <input type="text" name="q" value="" size="40" maxlength="100">
                </td>
                <td width="98%" nowrap>
                    &nbsp;
                    <input type="submit" value="<jive:i18n key="global.go" />">
                </td>
            </tr>
            </table>

            </form>

        <%  } %>

        <p>
        <%-- Online Users: --%>
        <jive:i18n key="online.online_users" /><jive:i18n key="global.colon" />

        <%  PresenceManager presenceManager = action.getForumFactory().getPresenceManager(); %>

        <%-- Online users: XX guest(s), YY user(s) online. --%>
        <jive:i18n key="online.summary">
            <jive:arg>
                <%= presenceManager.getOnlineGuestCount() %>
            </jive:arg>
            <jive:arg>
                <%= presenceManager.getOnlineUserCount() %>
            </jive:arg>
        </jive:i18n>

        <%-- More info: --%>
        <a href="online.jspa"><jive:i18n key="global.more_info" /> &raquo;</a>
        </p>

    </td>
    <td width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>
    <td width="1%">

        <%@ include file="accountbox.jsp" %>

    </td>
</tr>
</table>

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
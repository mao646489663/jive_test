<%
/**
 *    $RCSfile: mergeForumsSuccess.jsp,v $
 *    $Revision: 1.1.8.1 $
 *    $Date: 2003/07/24 19:03:15 $
 */
%>

<%@ page import="java.util.*,
                 java.text.*,
                 com.jivesoftware.util.*,
                 com.jivesoftware.forum.*,
                 com.jivesoftware.forum.database.*,
                 com.jivesoftware.forum.util.*"
    errorPage="error.jsp"
%>

<%@ include file="global.jsp" %>

<%  // Get parameters
    long forumID = ParamUtils.getLongParameter(request,"forum",-1L);

    // Load forums
    Forum forum = forumFactory.getForum(forumID);

    // Permissions check
    if (!isSystemAdmin && !forum.isAuthorized(ForumPermissions.FORUM_CATEGORY_ADMIN | ForumPermissions.FORUM_ADMIN)) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }
%>

<%  // Put the forum in the session (is needed by the sidebar)
    session.setAttribute("admin.sidebar.forums.currentForumID", ""+forumID);

    // special onload command to load the sidebar
    onload = " onload=\"parent.frames['sidebar'].location.href='sidebar.jsp?sidebar=forum';\"";
%>

<%@ include file="header.jsp" %>

<%  // Title of this page and breadcrumbs
    String title = "Merge Forum Data - Success";
    String[][] breadcrumbs = {
        {"Main", "main.jsp"},
        {"Categories &amp; Forums", "forums.jsp?cat=" + forum.getForumCategory().getID()},
        {title, "mergeForumsSuccess.jsp?forum="+forumID}
    };
%>
<%@ include file="title.jsp" %>

<p>
You have successfully merged data into the forum "<b><%= forum.getName() %></b>". Use the
links to the left to edit the forum or go back to the main list of categories and forums.
</p>

<%@ include file="footer.jsp" %>
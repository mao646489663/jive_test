<%
/**
 *	$RCSfile: removeForum.jsp,v $
 *	$Revision: 1.2.4.1 $
 *	$Date: 2003/07/24 19:03:15 $
 */
%>

<%@ page import="java.util.*,
                 com.jivesoftware.forum.*,
                 com.jivesoftware.forum.util.*,
                 com.jivesoftware.util.ParamUtils"
    errorPage="error.jsp"
 %>

<%@ include file="global.jsp" %>
 
<%	// get parameters
	long forumID = ParamUtils.getLongParameter(request,"forum",-1L);
	boolean delete = ParamUtils.getBooleanParameter(request,"delete");
    
    // Load up the forum specified
    Forum forum = forumFactory.getForum(forumID);

    // Permissions check
    if (!isSystemAdmin && !forum.getForumCategory().isAuthorized(ForumPermissions.FORUM_CATEGORY_ADMIN)) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }

    // cancel if requested
    if ("Cancel".equals(ParamUtils.getParameter(request,"submitButton"))) {
        response.sendRedirect("forums.jsp");
        return;
    }
    // Put the forum in the session (is needed by the sidebar)
    session.setAttribute("admin.sidebar.forums.currentForumID", ""+forumID);
    
	if (delete) {
        forumFactory.deleteForum(forum);
        // Remove the forumID from the session
        session.removeAttribute("admin.sidebar.forums.currentForumID");
		response.sendRedirect("forums.jsp");
		return;
	}
%>

<%  // special onload command to load the sidebar
    onload = " onload=\"parent.frames['sidebar'].location.href='sidebar.jsp?sidebar=forum';\"";
%>
<%@ include file="header.jsp" %>

<p>

<%  // Title of this page and breadcrumbs
    String title = "Delete Forum";
    String[][] breadcrumbs = {
        {"Main", "main.jsp"},
        {"Categories &amp; Forums", "forums.jsp?cat=" + forum.getForumCategory().getID()},
        {"Delete Forum", "removeForum.jsp?forum="+forumID}
    };
%>
<%@ include file="title.jsp" %>

<script language="JavaScript" type="text/javascript">
<!--
var clicked = false;
function checkClick() {
    if (!clicked) {
        clicked = true;
        return true;
    }
    return false;
}
//-->
</script>

<form action="removeForum.jsp" name="deleteForm" onsubmit="return checkClick();">
<input type="hidden" name="delete" value="true">
<input type="hidden" name="forum" value="<%= forumID %>">

<font size="-1"><b>Confirm Forum Deletion</b></font><p>
<ul>
    <font size="-1">
	Warning: This will permanently delete the forum <b><%= forum.getName() %></b>.
    Are you sure you really want to do this?
    <p>
    </font>
	<input type="submit" name="submitButton" value="Delete Forum">
	&nbsp;
	<input type="submit" name="submitButton" value="Cancel">
</ul>
</form>

<%@ include file="footer.jsp" %>
<%
/**
 *	$RCSfile: deleteCategory.jsp,v $
 *	$Revision: 1.1.12.1 $
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

<%	// Perm check
    if (!isSystemAdmin && !isCatAdmin) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }

    // cancel if requested
    if ("Cancel".equals(ParamUtils.getParameter(request,"submitButton"))) {
        response.sendRedirect("forums.jsp");
        return;
    }

    // get parameters
	long categoryID = ParamUtils.getLongParameter(request,"cat",-1L);
	boolean delete = ParamUtils.getBooleanParameter(request,"delete");

    // Load the specified forum category
    ForumCategory category = forumFactory.getForumCategory(categoryID);
    ForumCategory parentCategory = category.getParentCategory();

    // Make sure the user has cat admin priv on this category.
    if (!isSystemAdmin && !parentCategory.isAuthorized(ForumPermissions.FORUM_CATEGORY_ADMIN)) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }

	if (delete) {
        parentCategory.deleteCategory(category);
        // Remove the forumID from the session
		response.sendRedirect("forums.jsp?cat=" + parentCategory.getID());
		return;
	}
%>

<%  // special onload command to load the sidebar
    onload = " onload=\"parent.frames['sidebar'].location.href='sidebar.jsp?sidebar=forum';\"";
%>
<%@ include file="header.jsp" %>

<p>

<%  // Title of this page and breadcrumbs
    String title = "Delete Category";
    String[][] breadcrumbs = {
        {"Main", "main.jsp"},
        {"Categories &amp; Forums", "forums.jsp?cat=" + category.getID()},
        {title, "deleteCategory.jsp?cat="+categoryID}
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

<form action="deleteCategory.jsp" name="deleteForm" onsubmit="return checkClick();">
<input type="hidden" name="delete" value="true">
<input type="hidden" name="cat" value="<%= categoryID %>">

<font size="-1"><b>Confirm Category Deletion</b></font><p>
<ul>
    <font size="-1">
	Warning: This will permanently delete the category <b><%= category.getName() %></b>
    and all forums and subcategories under it.
    Are you sure you really want to do this?
    <p>
    </font>
	<input type="submit" name="submitButton" value="Delete Category">
	&nbsp;
	<input type="submit" name="submitButton" value="Cancel">
</ul>
</form>

<script language="JavaScript" type="text/javascript">
<!--
// focus the "cancel" button -- if the user accidentally hits enter or
// space on this page, the default action would be to cancel, not delete
// the forum ;)
document.deleteForm.cancelButton.focus();
//-->
</script>

<%@ include file="footer.jsp" %>
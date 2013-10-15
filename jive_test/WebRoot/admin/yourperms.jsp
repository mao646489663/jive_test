<%
/**
 *	$RCSfile: yourperms.jsp,v $
 *	$Revision: 1.1.12.1 $
 *	$Date: 2003/07/24 19:03:18 $
 */
%>

<%@ page import="java.util.*,
                 com.jivesoftware.forum.*,
                 com.jivesoftware.forum.util.*"
    errorPage="error.jsp"
%>

<%@ include file="global.jsp" %>

<%@ include file="header.jsp" %>

<%  // Title of this page and breadcrumbs
    String title = "Your Permissions";
    String[][] breadcrumbs = null;
%>
<%@ include file="title.jsp" %>

In the Jive Forums system, users can have different roles. Below is a list of roles available to
you.

<br><br>

<span class="jive-table">
<table cellpadding="3" cellspacing="2" border="0" width="100%">
<tr>
    <th>Role and Description</th>
    <th>You Have Role</th>
</tr>
<tr class="odd">
    <td>
        System Admin
        <span class="jive-description">
        <br>Top-level admin - this role allows all administration tasks.
        </span>
    </td>
    <td align="center">
        <%  if (isSystemAdmin) { %>
            <img src="images/check-13x13.gif" width="13" height="13" border="0">
        <%  } else { %>
            <img src="images/x-13x13.gif" width="13" height="13" border="0">
        <%  } %>
    </td>
</tr>
<tr class="even">
    <td>
        Category Admin
        <span class="jive-description">
        <br>An admin with privileges over all or specified categories.
        </span>
    </td>
    <td align="center">
        <%  if (isCatAdmin) { %>
            <img src="images/check-13x13.gif" width="13" height="13" border="0">
        <%  } else { %>
            <img src="images/x-13x13.gif" width="13" height="13" border="0">
        <%  } %>
    </td>
</tr>
<tr class="odd">
    <td>
        Forum Admin
        <span class="jive-description">
        <br>An admin with privileges over all or specified forums.
        </span>
    </td>
    <td align="center">
        <%  if (isForumAdmin) { %>
            <img src="images/check-13x13.gif" width="13" height="13" border="0">
        <%  } else { %>
            <img src="images/x-13x13.gif" width="13" height="13" border="0">
        <%  } %>
    </td>
</tr>
<tr class="even">
    <td>
        Group Admin
        <span class="jive-description">
        <br>Manage group membership.
        </span>
    </td>
    <td align="center">
        <%  if (isGroupAdmin) { %>
            <img src="images/check-13x13.gif" width="13" height="13" border="0">
        <%  } else { %>
            <img src="images/x-13x13.gif" width="13" height="13" border="0">
        <%  } %>
    </td>
</tr>
<tr class="odd">
    <td>
        User Admin
        <span class="jive-description">
        <br>Delete and manage user accounts.
        </span>
    </td>
    <td align="center">
        <%  if (isUserAdmin) { %>
            <img src="images/check-13x13.gif" width="13" height="13" border="0">
        <%  } else { %>
            <img src="images/x-13x13.gif" width="13" height="13" border="0">
        <%  } %>
    </td>
</tr>
<tr class="even">
    <td>
        Moderator
        <span class="jive-description">
        <br>Edit or delete content.
        </span>
    </td>
    <td align="center">
        <%  if (isModerator) { %>
            <img src="images/check-13x13.gif" width="13" height="13" border="0">
        <%  } else { %>
            <img src="images/x-13x13.gif" width="13" height="13" border="0">
        <%  } %>
    </td>
</tr>
</table>
</span>

<%@ include file="footer.jsp" %>
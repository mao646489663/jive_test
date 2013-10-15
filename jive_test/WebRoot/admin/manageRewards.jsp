<%
/**
 *	$RCSfile: manageRewards.jsp,v $
 *	$Revision: 1.4 $
 *	$Date: 2003/02/08 16:38:24 $
 */
%>

<%@ page import="java.util.*,
				 java.text.*,
                 java.sql.*,
				 com.jivesoftware.util.*,
                 com.jivesoftware.forum.*,
				 com.jivesoftware.forum.database.*,
				 com.jivesoftware.forum.util.*"
    errorPage="error.jsp"
%>

<%@ include file="global.jsp" %>

<%	// Permission check
    if (!isSystemAdmin) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }

    // get parameters
    int start = ParamUtils.getIntParameter(request,"start",0);
    int range = ParamUtils.getIntParameter(request,"range",15);

    // Get the reward manager
    RewardManager rewardManager = forumFactory.getRewardManager();

    // Get an iterator of the top users in the system
    Iterator topUsers = rewardManager.getTopUsers(start, range);
%>

<%@ include file="header.jsp" %>

<p>

<%  // Title of this page and breadcrumbs
    String title = "Manage Reward Points";
    String[][] breadcrumbs = {
        {"Main", "main.jsp"},
        {title, "manageReports.jsp"}
    };
%>
<%@ include file="title.jsp" %>

Below is a summary of the top users in the system, ranked by the amount of points they have
earned. To manage a user's rewards, click on their username. If the user you're interested
in is not in the list below, use the form and enter their username or user ID.

<p>
<b>Load User</b>
</p>

<p>
Use the form below to load a user by their username or user ID.
</p>

<ul>
    <form action="manageUserRewards.jsp">
    ID: <input type="text" name="userID" value="" size="5" maxlength="6">
    or Username: <input type="text" name="username" size="30" maxlength="60" value="">
    <input type="submit" name="doSubmit" value="Go">
    </form>
</ul>

<p>
<b>Top Users by Points Earned</b>
</p>

<p>
Below is a list of the top users in the system by points earned. To manage a user's points,
click their username.
</p>

<table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="100%">
<tr><td>
<table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
<tr bgcolor="#eeeeee">
    <td align="center" nowrap><font size="-2" face="verdana"><b>USER ID</b></font></td>
    <td align="center" nowrap><font size="-2" face="verdana"><b>USERNAME</b></font></td>
    <td align="center" nowrap><font size="-2" face="verdana"><b>POINTS</b></font></td>
    <td align="center" nowrap><font size="-2" face="verdana"><b>NAME</b></font></td>
    <td align="center" nowrap><font size="-2" face="verdana"><b>EMAIL</b></font></td>
    <td align="center" nowrap><font size="-2" face="verdana"><b>EDIT</b></font></td>
</tr>
<%  if (!topUsers.hasNext()) { %>

    <tr bgcolor="#ffffff">
        <td colspan="6" align="center">
            <i>
            No top users calculated in the system. Use the form above to load a user.
            </i>
        </td>
    </tr>

<%
    }
    while (topUsers.hasNext()) {
        User user = (User)topUsers.next();
        String name = user.getName();
        String email = user.getEmail();
%>
    <tr bgcolor="#ffffff">
        <td align="center" width="2%"><%= user.getID() %></td>
        <td width="30%">
            <a href="manageUserRewards.jsp?userID=<%= user.getID() %>"><%= user.getUsername() %></a>
        </td>
        <td width="2%" nowrap align="center">
            <%= rewardManager.getPointsEarned(user) %>
        </td>
        <td width="30%">
            <%= (name!=null)?name:"" %>
        </td>
        <td width="28%">
            <%= (email!=null)?email:"" %>
        </td>
        <td align="center" width="4%"
            ><a href="manageUserRewards.jsp?userID=<%= user.getID() %>"
            ><img src="images/button_edit.gif" width="17" height="17" alt="Edit User Properties..." border="0"
            ></a
            ></td>
    </tr>
<%  } %>
</table>
</td></tr>
</table>

<%@ include file="footer.jsp" %>
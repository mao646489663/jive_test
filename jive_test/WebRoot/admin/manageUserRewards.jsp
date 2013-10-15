<%
/**
 *	$RCSfile: manageUserRewards.jsp,v $
 *	$Revision: 1.4 $
 *	$Date: 2003/04/07 04:59:03 $
 */
%>

<%@ page import="java.util.*,
				 java.text.*,
                 java.sql.*,
				 com.jivesoftware.util.*,
                 com.jivesoftware.forum.*,
				 com.jivesoftware.forum.database.*,
				 com.jivesoftware.forum.util.*,
                 com.jivesoftware.base.database.ConnectionManager"
    errorPage="error.jsp"
%>

<%! // Global vars, methods, etc

    private static final String USER_POINTS_SQL
        = "SELECT jiveReward.creationDate,jiveReward.rewardPoints,messageID,jiveReward.threadID, " +
            "forumID FROM jiveReward,jiveThread WHERE userID=? AND " +
            "jiveReward.threadID=jiveThread.threadID ORDER BY jiveReward.creationDate DESC";
%>

<%@ include file="global.jsp" %>

<%	// Permission check
    if (!isSystemAdmin) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }

    // get parameters
    int start = ParamUtils.getIntParameter(request,"start",0);
    int range = ParamUtils.getIntParameter(request,"range",15);
    long userID = ParamUtils.getLongParameter(request,"userID",-1L);
    String username = ParamUtils.getParameter(request,"username");
    boolean alterUserPoints = ParamUtils.getBooleanParameter(request,"alterUserPoints");
    int points = ParamUtils.getIntParameter(request,"points",0);
    String mode = ParamUtils.getParameter(request,"mode");

    // Load the user:
    User user = null;
    try {
        if (userID > 0L) {
            user = forumFactory.getUserManager().getUser(userID);
        }
    }
    catch (UserNotFoundException unfe) {}
    if (user == null && username != null) {
        try {
            user = forumFactory.getUserManager().getUser(username);
        }
        catch (UserNotFoundException unfe) {}
    }

    if (user == null) {
        throw new UserNotFoundException("User was not found.");
    }

    // Get the reward manager
    RewardManager rewardManager = forumFactory.getRewardManager();

    // alter user points if requested:

    boolean errors = false;
    if (alterUserPoints) {
        if (points == 0) {
            errors = true;
        }
        else {
            if ("add".equals(mode)) {
                points = Math.abs(points);
            }
            else if ("remove".equals(mode)) {
                points = - Math.abs(points);
            }
            rewardManager.addBankPoints(user, points);
            response.sendRedirect("manageUserRewards.jsp?userID=" + user.getID());
            return;
        }
    }
%>

<%@ include file="header.jsp" %>

<p>

<%  // Title of this page and breadcrumbs
    String title = "Manage User Reward Points";
    String[][] breadcrumbs = {
        {"Main", "main.jsp"},
        {"Manage Rewards", "manageRewards.jsp"},
        {title, "manageUserRewards.jsp?userID=" + user.getID()}
    };
%>
<%@ include file="title.jsp" %>

Below is summary of the user's reward points. You can adjust the amount of points they have
and see an audit of award points they have.

<p>
<b>Reward Points Summary: <%= user.getUsername() %></b>
</p>

<ul>
    <table cellpadding="3" cellspacing="0" border="0" width="75%">
    <tr>
        <td>User ID:</td>
        <td><%= user.getID() %></td>
    </tr>
    <tr>
        <td>Username:</td>
        <td><%= user.getUsername() %></td>
    </tr>
    <tr>
        <td>Name:</td>
        <td><%= ((user.getName()!=null)?user.getName():"<i>Not Entered or Hidden</i>") %></td>
    </tr>
    <tr>
        <td>Email:</td>
        <td><%= ((user.getEmail()!=null)?user.getEmail():"<i>Not Entered or Hidden</i>") %></td>
    </tr>
    <tr>
        <td>Current Reward Points:</td>
        <td><%= rewardManager.getBankPoints(user) %></td>
    </tr>
    <tr>
        <td>Reward Points Earned:</td>
        <td><%= rewardManager.getPointsEarned(user) %></td>
    </tr>
    <tr>
        <td>Reward Points Awarded:</td>
        <td><%= rewardManager.getPointsRewarded(user) %></td>
    </tr>
    </table>
</ul>

<p>
<b>User Point Audit</b>
</p>

<p>
Below is an audit of up to the most recent <%= range %> reward point transactions.
</p>

<table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="100%">
<tr><td>
<table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
<tr bgcolor="#eeeeee">
    <td>&nbsp;</td>
    <td align="center" nowrap><font size="-2" face="verdana"><b>DATE</b></font></td>
    <td align="center" nowrap><font size="-2" face="verdana"><b>POINTS</b></font></td>
    <td align="center" nowrap><font size="-2" face="verdana"><b>REWARDER</b></font></td>
    <td align="center" nowrap><font size="-2" face="verdana"><b>THREAD ID</b></font></td>
    <td align="center" nowrap><font size="-2" face="verdana"><b>MESSAGE ID</b></font></td>
</tr>
<%  Connection con = null;
    PreparedStatement pstmt = null;
    boolean less = false;
    boolean more = false;
    boolean hasResults = false;
    try {
        con = ConnectionManager.getConnection();
        pstmt = con.prepareStatement(USER_POINTS_SQL);
        pstmt.setLong(1, user.getID());
        ResultSet rs = pstmt.executeQuery();
        int count = 0;
        while (count < start) {
            count++;
            rs.next();
            hasResults = true;
            less = true;
        }
        while (rs.next() && (count < (start+range))) {
            hasResults = true;
            long date = rs.getLong(1);
            int pts = rs.getInt(2);
            long mID = rs.getLong(3);
            if (rs.wasNull()) {
                mID = -1L;
            }
            long tID = rs.getLong(4);
            if (rs.wasNull()) {
                tID = -1L;
            }
            long fID = rs.getLong(5);

%>
    <tr bgcolor="#ffffff">
        <td width="1%"><%= ++count %></td>
        <td align="center" width="43%">&nbsp;<%= JiveGlobals.formatDateTime(new java.util.Date(date)) %>&nbsp;</td>
        <td align="center" width="1%"><%= pts %></td>
        <td align="center" width="43%">
            <%  if (tID == -1L) { %>
                N/A
            <%  } else {
                    ForumThread thread = null;
                    if (fID > 0L && tID > 0L) {
                        try {
                            Forum forum = forumFactory.getForum(fID);
                            thread = forum.getThread(tID);
                        }
                        catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                    if (thread != null) {
            %>
                    <%= thread.getRootMessage().getUser().getUsername() %>

                <%  } else { %>

                    N/A

            <%      }
                }
            %>
        </td>
        <td align="center" width="1%">
            <%  if (tID != -1L) { %>
                <%= tID %>
            <%  } else { %>
                &nbsp;
            <%  } %>
        </td>
        <td align="center" width="%">
            <%  if (mID != -1L) { %>
                <%= mID %>
            <%  } else { %>
                &nbsp;
            <%  } %>
        </td>
    </tr>
<%
        }
        if (rs.next()) {
            more = true;
        }
    }
    catch (SQLException sqle) {
        sqle.printStackTrace();
    }
    finally {
        try {  pstmt.close();   }
        catch (Exception e) { e.printStackTrace(); }
        try {  con.close();   }
        catch (Exception e) { e.printStackTrace(); }
    }
    if (!hasResults) {
%>
    <tr bgcolor="#ffffff">
        <td colspan="6" align="center"><i>No reward activity.</i></td>
    </tr>
<%
    }
%>
</table>
</td></tr>
</table>

<p>
<b>Manage User Points</b>
</p>

<p>
Use the form below to add or remove points to this user. (Note, this won't be reflected in the
audit list above but only in the user's amount of total points.)
</p>

<%  if (errors) { %>

    <p class="jive-error-text">
    Invalid amount of points.
    </p>

<%  } %>

<form action="manageUserRewards.jsp">
<input type="hidden" name="alterUserPoints" value="true">
<input type="hidden" name="userID" value="<%= user.getID() %>">

<select size="1" name="mode">
    <option value="add">Add
    <option value="remove">Remove
</select>
<input type="text" name="points" value="" size="5" maxlength="5"> point(s).
<input type="submit" name="doupdate" value="Update">

</form>


<%@ include file="footer.jsp" %>
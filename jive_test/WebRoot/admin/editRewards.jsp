<%
/**
 *	$RCSfile: editRewards.jsp,v $
 *	$Revision: 1.10.4.4 $
 *	$Date: 2003/07/25 16:14:10 $
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

<%@ include file="global.jsp" %>

<%	// Permission check
    if (!isSystemAdmin) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }

    // get parameters
    boolean enable = "enable".equals(request.getParameter("toggle"));
    boolean disable = "disable".equals(request.getParameter("toggle"));
    boolean doToggle = request.getParameter("doToggle") != null;
    boolean savePointMaxes = ParamUtils.getBooleanParameter(request,"savePointMaxes");
    int maxThreadPoints = ParamUtils.getIntParameter(request,"maxThreadPoints",-1);
    int maxMessagePoints = ParamUtils.getIntParameter(request,"maxMessagePoints",-1);
    boolean topicPtsUnlimited = ParamUtils.getBooleanParameter(request,"topicPtsUnlimited");
    boolean msgPtsUnlimited = ParamUtils.getBooleanParameter(request,"msgPtsUnlimited");
    boolean doSaveBank = ParamUtils.getBooleanParameter(request,"doSaveBank");
    boolean bankEnabled = ParamUtils.getBooleanParameter(request,"bankEnabled");
    int initialBankPoints = ParamUtils.getIntParameter(request,"initialBankPoints",-1);
    int maxBankPoints = ParamUtils.getIntParameter(request,"maxBankPoints",-1);
    String maxBankPointMode = ParamUtils.getParameter(request,"maxBankPointMode");
    boolean globalAddPoints = ParamUtils.getBooleanParameter(request,"globalAddPoints");
    int points = ParamUtils.getIntParameter(request,"points",0);
    boolean pointSuccess = ParamUtils.getBooleanParameter(request,"pointSuccess");

    if (doToggle && enable) {
        JiveGlobals.setJiveProperty("rewards.enabled", "true");
        response.sendRedirect("editRewards.jsp");
        return;
    }
    if (doToggle && disable) {
        JiveGlobals.deleteJiveProperty("rewards.enabled");
        response.sendRedirect("editRewards.jsp");
        return;
    }

    RewardManager rewardManager = forumFactory.getRewardManager();

    if (globalAddPoints && points > 0) {
        rewardManager.addBankPoints(points);
        response.sendRedirect("editRewards.jsp?pointSuccess=true");
        return;
    }

    Map errors = new HashMap();

    if (savePointMaxes) {
        // error check
        if (!topicPtsUnlimited && maxThreadPoints <= 0) {
            errors.put("topicPtsUnlimited","");
        }
        if (!msgPtsUnlimited && maxMessagePoints <= 0) {
            errors.put("msgPtsUnlimited","");
        }
        if (errors.size() == 0) {
            if (topicPtsUnlimited) {
                rewardManager.setMaxThreadPoints(-1);
            }
            else if (maxThreadPoints > 0) {
                rewardManager.setMaxThreadPoints(maxThreadPoints);
            }
            if (msgPtsUnlimited) {
                rewardManager.setMaxMessagePoints(-1);
            }
            else if (maxMessagePoints > 0) {
                rewardManager.setMaxMessagePoints(maxMessagePoints);
            }
            response.sendRedirect("editRewards.jsp");
            return;
        }
    }

    if (doSaveBank) {
        rewardManager.setBankEnabled(bankEnabled);
        if (initialBankPoints > -1) {
            rewardManager.setInitialBankPoints(initialBankPoints);
        }
        else {
            rewardManager.setInitialBankPoints(0);
        }
        if ("unlimited".equals(maxBankPointMode)) {
            rewardManager.setMaxBankPoints(-1);
        }
        else if ("limited".equals(maxBankPointMode)) {
            if (maxBankPoints > -1 && maxBankPoints != rewardManager.getMaxBankPoints()) {
                rewardManager.setMaxBankPoints(maxBankPoints);
            }
        }
        response.sendRedirect("editRewards.jsp");
        return;
    }

    enable = "true".equals(JiveGlobals.getJiveProperty("rewards.enabled"));
    maxThreadPoints = rewardManager.getMaxThreadPoints();
    maxMessagePoints = rewardManager.getMaxMessagePoints();
    topicPtsUnlimited = maxThreadPoints == -1;
    msgPtsUnlimited = maxMessagePoints == -1;
    bankEnabled = rewardManager.isBankEnabled();
    initialBankPoints = rewardManager.getInitialBankPoints();
    maxBankPoints = rewardManager.getMaxBankPoints();
%>

<%@ include file="header.jsp" %>

<p>

<%  // Title of this page and breadcrumbs
    String title = "Reward Settings";
    String[][] breadcrumbs = {
        {"Main", "main.jsp"},
        {title, "editRewards.jsp"}
    };
%>
<%@ include file="title.jsp" %>

Reward points are a virtual currency between users that can encourage people
to answer each other's questions. Users who create topics can assign a number
of reward points to their topic and then dole them out to the best answers.

<%  if (pointSuccess) { %>

    <p class="jive-success-text">
    Reward points successfully added.
    </p>

<%  } %>

<p>
<b>Reward Point Status</b>
</p>

<p>
The reward points feature is curently <%= (enable?"enabled":"disabled") %>.
To change this, use the form below. Note, this does not erase or alter any
of the reward point data - it simply disables the feature from being used.
</p>

<form action="editRewards.jsp">

<ul>
    <table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="300">
    <tr><td>
    <table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
    <tr bgcolor="#ffffff">
    <td align="center"<%= (enable)?" bgcolor=\"#99cc99\"":"" %>>
        <font size="-1">
        <input type="radio" name="toggle" value="enable" id="rb01"
         <%= (enable)?"checked":"" %>>
        <label for="rb01"><%= (enable)?"<b>On</b>":"On" %></label>
        </font>
    </td>
    <td align="center"<%= (!enable)?" bgcolor=\"#cc6666\"":"" %>>
        <font size="-1">
        <input type="radio" name="toggle" value="disable" id="rb02"
         <%= (!enable)?"checked":"" %>>
        <label for="rb02"><%= (!enable)?"<b>Off</b>":"Off" %></label>
        </font>
    </td>
    </tr>
    </table>
    </td></tr>
    </table>
    <br>
    <input type="submit" name="doToggle" value="Update">
</ul>

</form>

<%  if (enable) { %>

    <script language="JavaScript" type="text/javascript">
    var cur = <%= maxBankPoints %>;
    function validate(el) {
        var pts = el.maxBankPoints.value;
        if (pts < cur || (cur == -1 && pts > -1)) {
            return confirm("Warning: You are about to set the maximum earnable bank points lower.\n"
                         + "This will auto-adjust users point values lower if they have more than\n"
                         + pts + " point" + ((pts!=1) ? "s" : "") + ".\n\n"
                         + "Are you sure you want to do this?");
        }
        else {
            return true;
        }
    }
    </script>

    <p>
    <b>Reward Point Mode</b>
    </p>

    <p>
    When user bank points are enabled users can store points they've earned. When bank points
    are disabled, users will have no store of points.
    </p>

    </form>

    <form action="editRewards.jsp" onsubmit="return validate(this);">
    <input type="hidden" name="doSaveBank" value="true">

    <ul>
        <table cellpadding="3" cellspacing="0" border="0">
        <tr>
            <td>
                <input type="radio" name="bankEnabled" value="false" id="bankEnabled1"
                 <%= (!bankEnabled ? "checked" : "") %>>
            </td>
            <td colspan="3"><label for="bankEnabled1">Disable User Banks</label></td>
        </tr>
        <tr>
            <td>
                <input type="radio" name="bankEnabled" value="true" id="bankEnabled0"
                 <%= (bankEnabled ? "checked" : "") %>>
            </td>
            <td colspan="3"><label for="bankEnabled0">Enable User Banks</label></td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>&#149;</td>
            <td colspan="2">
                Initial Bank Points (for new users):
                <input type="text" size="5" maxlength="5" name="initialBankPoints"
                 value="<%= ((initialBankPoints > -1) ? ""+initialBankPoints : "0") %>">
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td rowspan="3" valign="top">&#149;</td>
            <td colspan="2">
                Maximum Earnable Bank Points:
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>
                <input type="radio" name="maxBankPointMode" value="unlimited" id="mbpm01"
                 <%= ((maxBankPoints <= -1) ? "checked" : "") %>>
            </td>
            <td>
                <label for="mbpm01">Unlimited</label>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>
                <input type="radio" name="maxBankPointMode" value="limited" id="mbpm02"
                 <%= ((maxBankPoints > -1) ? "checked" : "") %>>
            </td>
            <td>
                <label for="mbpm02">Limited to</label>
                <input type="text" size="5" maxlength="5" name="maxBankPoints" value="<%= ((maxBankPoints>-1) ? ""+maxBankPoints : "") %>"
                 onfocus="this.form.maxBankPointMode[1].checked=true;">
                <label for="mbpm02">points</label>
            </td>
        </tr>
        </table>

        <br>

        <input type="submit" name="submit" value="Update">
    </ul>

    </form>

    <p>
    <b>Maximum Points</b>
    </p>

    <p>
    You can specify the maximum amount of points that can be allocated to a topic
    or message. This limits the amount of points a topic author can award per
    topic or message.
    </p>

    <form action="editRewards.jsp" name="f">
    <input type="hidden" name="savePointMaxes" value="true">

    <ul>
        Maximum awardable topic points: <br>

        <table cellpadding="3" cellspacing="0" border="0">
        <tr>
            <td>
                <input type="radio" name="topicPtsUnlimited" value="true" id="topicPtsUnlimited0"
                 <%= (topicPtsUnlimited) ? "checked" : "" %>>
                <label for="topicPtsUnlimited0">Unlimited</label>
            </td>
        </tr>
        <tr>
            <td>
                <input type="radio" name="topicPtsUnlimited" value="false" id="topicPtsUnlimited1"
                 <%= (!topicPtsUnlimited) ? "checked" : "" %>>
                <label for="topicPtsUnlimited1">Limited to</label>
                <input type="text" name="maxThreadPoints" size="5"
                 value="<%= ((maxThreadPoints > -1) ? ""+maxThreadPoints : "") %>"
                 onfocus="this.form.topicPtsUnlimited[1].checked=true;">
                <label for="topicPtsUnlimited1">points</label>
            </td>
        </tr>
        </table>

        <br>

        Maximum awardable message points: <br>

        <table cellpadding="3" cellspacing="0" border="0">
        <tr>
            <td>
                <input type="radio" name="msgPtsUnlimited" value="true" id="msgPtsUnlimited0"
                 <%= (msgPtsUnlimited) ? "checked" : "" %>>
                <label for="msgPtsUnlimited0">Unlimited</label>
            </td>
        </tr>
        <tr>
            <td>
                <input type="radio" name="msgPtsUnlimited" value="false" id="msgPtsUnlimited1"
                 <%= (!msgPtsUnlimited) ? "checked" : "" %>>
                <label for="msgPtsUnlimited1">Limited to</label>
                <input type="text" name="maxMessagePoints" size="5"
                 value="<%= ((maxMessagePoints > -1) ? ""+maxMessagePoints : "") %>"
                 onfocus="this.form.msgPtsUnlimited[1].checked=true;">
                <label for="msgPtsUnlimited1">points</label>
            </td>
        </tr>
        </table>

        <br>

        <input type="submit" name="doSubmit" value="Update">
    </ul>

    <p>
    <b>Globally Add Reward Points</b>
    </p>

    <p>
    Use the form below to add a specific amount of points to all users.
    </p>

    <form action="editRewards.jsp" name="f2">
    <input type="hidden" name="globalAddPoints" value="true">

    <ul>
        Add
        <input type="text" name="points" value="" size="5" maxlength="9">
        reward point(s) to all users.

        <br><br>

        <input type="submit" name="doSubmit" value="Add Points">
    </ul>

    </form>

<%  } %>

<br>

</body>
</html>
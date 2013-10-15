<%--
  - $RCSfile: myrewards.jsp,v $
  - $Revision: 1.9.2.3 $
  - $Date: 2003/06/09 05:39:06 $
  -
  - Copyright (C) 1999-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software.  Use is subject to license terms.
--%>

<%@ page import="java.util.Iterator,
                 com.jivesoftware.forum.*,
                 com.jivesoftware.forum.action.ForumCategoryAction,
                 com.jivesoftware.base.*"
%>

<%@ include file="global.jsp" %>

<%  // Get the action associated with this view:
    MyRewardsAction action = (MyRewardsAction)getAction(request);
    // Get the page user:
    User pageUser = action.getPageUser();
    // Get the forum factory
    ForumFactory forumFactory = action.getForumFactory();
    // Get a reward manager
    RewardManager rewardManager = forumFactory.getRewardManager();
%>

<%@ taglib uri="webwork" prefix="ww" %>
<%@ taglib uri="jivetags" prefix="jive" %>

<jsp:include page="header.jsp" flush="true" />

<div style="width:960px; margin:0px auto;">

<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr valign="top">
    <td width="98%">

        <%-- Breadcrumbs (customizable via the admin tool) --%>

        <jsp:include page="breadcrumbs.jsp" flush="true" />

        <%-- Forum name and brief info about the forum --%>

        <p class="jive-page-title">
        <%-- Reward Points Summary --%>
        <jive:i18n key="rewards.reward_point_summary" />
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

<%  String selectedTab = action.getText("rewards.reward_points"); %>
<%@ include file="tabs.jsp" %>

<br>

<a name=""></a>
<span class="jive-cp-header">
<%-- Reward Point Summary --%>
<jive:i18n key="rewards.reward_point_summary" />
</span>
<br><br>

<div class="jive-cp-formbox">
<table cellpadding="3" cellspacing="0" border="0" width="100%">

<%  // only show if banks are on
    if (rewardManager.isBankEnabled()) {
%>

    <tr>
        <td width="1%" nowrap>
            <%-- Current reward points you have: --%>
            <jive:i18n key="rewards.current_reward_points_you_have" /><jive:i18n key="global.colon" />
        </td>
        <td>
            <%= action.getNumberFormat().format(rewardManager.getBankPoints(pageUser)) %>
        </td>
    </tr>

<%  } %>

<tr>
    <td width="1%" nowrap>
        <%-- Total reward points you've earned: --%>
        <jive:i18n key="rewards.total_reward_points_earned" /><jive:i18n key="global.colon" />
    </td>
    <td>
        <%= action.getNumberFormat().format(rewardManager.getPointsEarned(pageUser)) %>
    </td>
</tr>
<tr>
    <td width="1%" nowrap>
        <%-- Total reward points you've awarded: --%>
        <jive:i18n key="rewards.total_reward_points_rewarded" /><jive:i18n key="global.colon" />
    </td>
    <td>
        <%= action.getNumberFormat().format(rewardManager.getPointsRewarded(pageUser)) %>
    </td>
</tr>
</table>
</div>

<%  // Get an iterator of topics the user needs to reward. If there are topics to be
    // rewarded, show them:
    Iterator topicsToBeRewarded = rewardManager.getPendingRewardThreads(pageUser);
    if (topicsToBeRewarded.hasNext()) {
%>
    <br><br>

    <a name=""></a>
    <span class="jive-cp-header">
    <%-- Topics Yet To Be Rewarded --%>
    <jive:i18n key="rewards.topics_to_be_rewarded" />
    </span>
    <br><br>

    <table class="jive-box" cellpadding="3" cellspacing="0" border="0" width="100%">
    <tr>
        <th colspan="2" class="jive-name">
            <%-- Topic --%>
            <jive:i18n key="global.topic" />
        </th>
        <th nowrap>
            <%-- Points --%>
            <jive:i18n key="rewards.points" />
        </th>
        <th nowrap>
            <%-- Replies --%>
            <jive:i18n key="global.replies" />
        </th>
        <th nowrap>
            <%-- Last Updated --%>
            <jive:i18n key="global.last_post" />
        </th>
    </tr>

    <%  while (topicsToBeRewarded.hasNext()) {
            ForumThread topic = (ForumThread)topicsToBeRewarded.next();
    %>
        <tr>
            <td></td>
            <td>
                <a href="thread.jspa?threadID=<%= topic.getID() %>"><%= topic.getName() %></a>
            </td>
            <td align="center"><%= action.getNumberFormat().format(rewardManager.getPoints(topic)) %></td>
            <td align="center"><%= action.getNumberFormat().format(topic.getMessageCount()-1) %></td>
            <td><%= action.getDateFormat().format(topic.getModificationDate()) %></td>
        </tr>

    <%  } %>

    </table>

<%
    }
%>

</div>

<jsp:include page="footer.jsp" flush="true" />
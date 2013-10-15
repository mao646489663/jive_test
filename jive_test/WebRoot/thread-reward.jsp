<%--
  - $RCSfile: thread-reward.jsp,v $
  - $Revision: 1.9.2.3 $
  - $Date: 2003/07/25 15:32:32 $
  -
  - Copyright (C) 1999-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software.  Use is subject to license terms.
--%>

<%@ page import="com.jivesoftware.forum.action.QuestionAction,
                 com.jivesoftware.forum.RewardManager,
                 com.jivesoftware.base.User" %>

<%  // This page assumes an "action" variable which is an instance of ForumThreadAction
    // and a "thread" variable which is an instance of ForumThread.
%>

<%  // Get the reward manager
    RewardManager manager = action.getForumFactory().getRewardManager();
%>

<%  // Indicates the page user is also the author of the topic
    boolean isThreadAuthor = action.isAuthor(thread.getRootMessage());
    // Current points assigned to the topic (these are the points that have not been awarded)
    int threadPoints = manager.getPoints(thread);
    // The number of reward points the page user has.
    int userPoints = 0;
    if (!action.isGuest()) {
        userPoints = manager.getBankPoints(action.getPageUser());
    }
    int pointsAssigned = 0;
    if (isThreadAuthor) {
        pointsAssigned = manager.getPointsRewarded(thread);
    }
    // max thread points. -1 value means unlimited
    int maxThreadPoints = manager.getMaxThreadPoints();
    // Indicates we should show reward information.
    boolean showRewardBox = !action.isLocked() && (threadPoints > 0) ||
            (threadPoints == 0 && userPoints > 0 && isThreadAuthor) &&
            (maxThreadPoints == -1 || pointsAssigned < maxThreadPoints);

    if (showRewardBox) {
%>
    <table class="jive-info-message" cellpadding="3" cellspacing="0" border="0" width="100%">
    <tr valign="top">
        <td width="1%"><img src="images/reward-16x16.gif" width="16" height="16" border="0"></td>
        <td width="99%">
            <span class="jive-info-text">

<%      if (isThreadAuthor) {
            if (threadPoints == 0) {
                // No points assigned to this topic. Indicate to the page user that they
                // can add points but only if they have available points to assign:
                if (userPoints > 0) {
%>
                    <%--
                        <b> reward point(s) assigned top this topic.
                        [link]Assign reward points[/link] to encourage others to reply to
                        your topic.
                    --%>
                    <jive:i18n key="rewards.no_points_assign_to_encourage">
                        <jive:arg>
                            <b>0</b>
                        </jive:arg>
                        <jive:arg>
                            <a href="rewards!default.jspa?mode=assign&threadID=<%= thread.getID() %>">
                        </jive:arg>
                        <jive:arg>
                            </a>
                        </jive:arg>
                    </jive:i18n>

                    <%-- Reward Point Help --%>
                    (<a href="rewardhelp.jspa"><jive:i18n key="rewards.reward_point_help" /></a>)

<%              }
            }
            else {
                // There are points assigned to this topic. Indicate this to the user.
%>
                <%--
                    XX point(s) assigned to this topic. YY point(s) have been awarded so far.
                --%>
                <jive:i18n key="rewards.x_points_so_far_y_points_awarded">
                    <jive:arg>
                        <%= manager.getPoints(thread) %>
                    </jive:arg>
                    <jive:arg>
                        <%= manager.getPointsRewarded(thread) %>
                    </jive:arg>
                </jive:i18n>

<%              // If there are no replies to this topic, offer the page user the ability to
                // remove points assigned to this topic:
                if (thread.getMessageCount()-1 == 0) {
%>
                    <%--
                        If you added points to this topic in error, you can
                        [link]remove[/link] points while there are no replies.
                    --%>
                    <jive:i18n key="rewards.can_remove_points_if_no_replies">
                        <jive:arg>
                            <a href="rewards!default.jspa?mode=unassign&threadID=<%= thread.getID() %>">
                        </jive:arg>
                        <jive:arg>
                            </a>
                        </jive:arg>
                    </jive:i18n>

                    <%-- Reward Point Help --%>
                    (<a href="rewardhelp.jspa"><jive:i18n key="rewards.reward_point_help" /></a>)

<%              }
                else {
                    // Indicate to the user they should reward users because there are replies
%>
                    <%--
                        Click the assign points icon on the messages below to reward the rest of
                        the remaining points.
                    --%>
                    <jive:i18n key="rewards.click_icon_to_assign_points" />

                    <%-- Reward Point Help --%>
                    (<a href="rewardhelp.jspa"><jive:i18n key="rewards.reward_point_help" /></a>)

<%              }
            }
        }
        else {
            if (threadPoints > 0) {
                // Indicate to the user that there are points available in this topic.
%>
                <%--
                    Reward points available in this topic: XXX.
                --%>
                <jive:i18n key="rewards.x_points_available_in_topic">
                    <jive:arg>
                        <b><%= threadPoints %></b>
                    </jive:arg>
                </jive:i18n>


                <%-- Reward Point Help --%>
                (<a href="rewardhelp.jspa"><jive:i18n key="rewards.reward_point_help" /></a>)

<%          }
        }
%>
            </span>
        </td>
    </tr>
    </table>

<%
    }
%>
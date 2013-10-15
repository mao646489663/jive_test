<%--
  -
  - $RCSfile: rewards.jsp,v $
  - $Revision: 1.6.2.1 $
  - $Date: 2003/06/09 06:08:32 $
  -
--%>

<%@ page import="java.util.Iterator,
                 com.jivesoftware.forum.*,
                 com.jivesoftware.base.*,
                 com.jivesoftware.forum.action.*"
%>

<%@ include file="global.jsp" %>

<%@ taglib uri="webwork" prefix="ww" %>
<%@ taglib uri="jivetags" prefix="jive" %>

<%  // Get the WebWork action that controls this view:
    RewardsAction action = (RewardsAction)getAction(request);
%>

<jsp:include page="header.jsp" flush="true" />

<div style="width:960px; margin:0px auto;">

<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr valign="top">
    <td width="98%">

        <%-- Breadcrumbs (customizable via the admin tool) --%>
        <jsp:include page="breadcrumbs.jsp" flush="true" />
        <br><br>

        <span class="jive-page-title">
        <%  if ("assign".equals(action.getMode())) { %>

            <%-- Assign Reward Points --%>
            <jive:i18n key="rewards.assign_reward_points" />

        <%  } else if ("unassign".equals(action.getMode())) { %>

            <%-- Unassign Reward Points --%>
            <jive:i18n key="rewards.unassign_reward_points" />

        <%  } else if ("transfer".equals(action.getMode())) { %>

            <%-- Transfer Reward points --%>
            <jive:i18n key="rewards.transfer_reward_points" />

        <%  } else { %>

            <%-- Reward Points --%>
            <jive:i18n key="rewards.reward_points" />

        <%  } %>
        </span>
        <br>

        <%-- Show any error messages --%>
        <ww:if test="hasErrorMessages == true">

            <br>
            <table class="jive-error-message" cellpadding="3" cellspacing="0" border="0" width="350">
            <tr valign="top">
                <td width="1%"><img src="images/error-16x16.gif" width="16" height="16" border="0"></td>
                <td width="99%">

                    <span class="jive-error-text">
                    <ww:iterator value="errorMessages">
                        <ww:property />
                    </ww:iterator>
                    </span>

                </td>
            </tr>
            </table><br>

        </ww:if>

        <%  if ("transfer".equals(action.getMode())) { %>

            <%  int threadPoints = action.getRewardManager().getPoints(action.getThread()); %>

            <p>
            <%--
                There are <b><%= threadPoints %></b> reward point(s)
                available in this topic to be rewarded. Use the form below to award all or some
                of these points.
            --%>
            <jive:i18n key="rewards.spef_points_to_be_rewarded_use_form">
                <jive:arg>
                    <b><%= threadPoints %></b>
                </jive:arg>
            </jive:i18n>
            </p>

            <p>
            <%-- Learn more about reward points --%>
            <a href="rewardhelp.jspa" target="_blank"><jive:i18n key="rewards.learn_more" /> &raquo;</a>
            </p>

            <form action="rewards!execute.jspa" method="post">
            <input type="hidden" name="mode" value="<%= action.getMode() %>">
            <input type="hidden" name="forumID" value="<%= action.getForumID() %>">
            <input type="hidden" name="threadID" value="<%= action.getThreadID() %>">
            <input type="hidden" name="messageID" value="<%= action.getMessageID() %>">

            <p>
            <%-- Reward XX point(s) to the reply "YY". --%>
            <jive:i18n key="rewards.reward_points_to_reply">
                <jive:arg>
                    <select name="points">
                    <%  for (int i=action.getRewardManager().getPoints(action.getThread()); i>0; i--) { %>

                        <option value="<%= i %>"><%= i %>

                    <%  } %>
                    </select>
                </jive:arg>
                <jive:arg>
                    <b><a href="thread.jspa?threadID=<%= action.getThreadID() %>&messageID=<%= action.getMessageID() %>" target="_blank"
                        ><%= action.getMessage().getSubject() %></a></b>
                </jive:arg>
            </jive:i18n>
            </p>

            <br>

            <%-- Reward Message --%>
            <input type="submit" name="doAssign" value="<jive:i18n key="rewards.reward_message" />">
            <%-- Cancel --%>
            <input type="submit" name="cancel" value="<jive:i18n key="global.cancel" />">

            </form>

        <%  } else if ("assign".equals(action.getMode())) { %>

            <%  // Variables needed for this section
                int bankPoints = action.getRewardManager().getBankPoints(action.getPageUser());
                int maxAssignable = action.getMaxAssignablePoints();
            %>

            <p>
            <%  if (bankPoints < maxAssignable || maxAssignable == -1) { %>

                <%-- You have <b><%= bankPoints %></b> bank point(s). --%>
                <jive:i18n key="rewards.you_have_x_bank_points">
                    <jive:arg>
                        <b><%= bankPoints %></b>
                    </jive:arg>
                </jive:i18n>

            <%  } else {
                    int assignable = maxAssignable;
                    if (bankPoints < assignable) {
                        assignable = bankPoints;
                    }
                    assignable -= action.getRewardManager().getPoints(action.getThread());
                    assignable -= action.getRewardManager().getPointsRewarded(action.getThread());
            %>
                <%-- You have <b><%= bankPoints %></b> bank point(s). --%>
                <jive:i18n key="rewards.you_have_x_bank_points">
                    <jive:arg>
                        <b><%= bankPoints %></b>
                    </jive:arg>
                </jive:i18n>

                <%-- You can assign up to <b><%= assignable %></b> point(s) to this topic. --%>
                <jive:i18n key="rewards.you_can_assign_up_to">
                    <jive:arg>
                        <b><%= assignable %></b>
                    </jive:arg>
                </jive:i18n>

            <%  } %>
            </p>

            <p>
            <%-- Learn more about reward points --%>
            <a href="rewardhelp.jspa" target="_blank"><jive:i18n key="rewards.learn_more" /> &raquo;</a>
            </p>

            <br>

            <form action="rewards!execute.jspa" method="post">
            <input type="hidden" name="mode" value="<%= action.getMode() %>">
            <input type="hidden" name="forumID" value="<%= action.getForumID() %>">
            <input type="hidden" name="threadID" value="<%= action.getThreadID() %>">

            <%-- Assign XXX point(s) to the topic YYY. --%>

            <p>
            <jive:i18n key="rewards.assign_points_to_specified_topic">
                <jive:arg>
                    <select name="points">
                    <%  int max = action.getMaxAssignablePoints();
                        int assignable = maxAssignable;
                        if (bankPoints < assignable) {
                            assignable = bankPoints;
                        }
                        assignable -= action.getRewardManager().getPoints(action.getThread());
                        assignable -= action.getRewardManager().getPointsRewarded(action.getThread());
                        int middle = assignable/2;
                        for (int i=assignable; i>0; i--) {
                    %>

                        <option value="<%= i %>"<%= ((middle==i) ? " selected" : "") %>><%= i %>

                    <%  } %>
                    </select>
                </jive:arg>
                <jive:arg>
                    <b><a href="thread.jspa?threadID=<%= action.getThreadID() %>" target="_blank"
                        >"<%= action.getThread().getName() %>"</a></b>
                </jive:arg>
            </jive:i18n>
            </p>

            <%-- Assign Points --%>
            <input type="submit" name="doAssign" value="<jive:i18n key="rewards.assign_points" />">
            <%-- Cancel --%>
            <input type="submit" name="cancel" value="<jive:i18n key="global.cancel" />">

            </form>

        <%  } else if ("unassign".equals(action.getMode())) { %>

            <%  int threadPoints = action.getRewardManager().getPoints(action.getThread()); %>

            <p>
            <%--
                There are <b><%= threadPoints %></b> point(s) assigned
                to this topic. Because no one has replied yet, you can un-assign these points
                and add them back to your point bank.
            --%>
            <jive:i18n key="rewards.can_unassign_points">
                <jive:arg>
                    <b><%= threadPoints %></b>
                </jive:arg>
            </jive:i18n>
            </p>

            <p>
            <%-- Learn more about reward points --%>
            <a href="rewardhelp.jspa" target="_blank"><jive:i18n key="rewards.learn_more" /> &raquo;</a>
            </p>

            <p>
            <%--
                Click the button below to unassign reward points to the topic
                "<%= action.getThread().getName() %>".
            --%>
            <jive:i18n key="rewards.click_to_unassign">
                <jive:arg>
                    <b><a href="thread.jspa?threadID=<%= action.getThreadID() %>" target="_blank"
                        >"<%= action.getThread().getName() %>"</a></b>
                </jive:arg>
            </jive:i18n>
            </p>

            <form action="rewards!execute.jspa" method="post">
            <input type="hidden" name="mode" value="<%= action.getMode() %>">
            <input type="hidden" name="points" value="<%= action.getRewardManager().getPoints(action.getThread()) %>">
            <input type="hidden" name="forumID" value="<%= action.getForumID() %>">
            <input type="hidden" name="threadID" value="<%= action.getThreadID() %>">
            <input type="hidden" name="messageID" value="<%= action.getMessageID() %>">

            <input type="submit" name="doUnassign" value="Unassign Points">
            <input type="submit" name="cancel" value="Cancel">

            </form>

        <%  } %>

    </td>
    <td width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>
    <td width="1%">

        <%@ include file="accountbox.jsp" %>

    </td>
</tr>
</table>

</div>

<jsp:include page="footer.jsp" flush="true" />
<%--
  -
  - $RCSfile: viewprofile.jsp,v $
  - $Revision: 1.24.2.5 $
  - $Date: 2003/07/23 13:46:15 $
  -
--%>

<%@ page import="com.jivesoftware.forum.ForumFactory,
                 com.jivesoftware.forum.action.ProfileAction,
                 com.jivesoftware.base.User,
                 com.jivesoftware.util.StringUtils,
                 com.jivesoftware.forum.RewardManager"
    errorPage="error.jsp"
%>

<%@ taglib uri="webwork" prefix="ww" %>
<%@ taglib uri="jivetags" prefix="jive" %>

<%@ include file="global.jsp" %>

<%  // Get the user object - the user we're viewing:
    ProfileAction action = (ProfileAction) getAction(request);
    ForumFactory forumFactory = action.getForumFactory();
    User user = action.getUser();
    // The user looking at this page - might be null if it's a guest:
    User pageUser = action.getPageUser();
    // Determine if this user is watched by the page user:
    boolean isWatchedUser = false;
    if (pageUser != null && forumFactory.getWatchManager().isWatched(pageUser, user)) {
        isWatchedUser = true;
    }
%>

<jsp:include page="header.jsp" flush="true" />
<div style="width:960px; margin:0px auto;">
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr valign="top">
    <td width="98%">

        <%-- Breadcrumbs (customizable via the admin tool) --%>

        <jsp:include page="breadcrumbs.jsp" flush="true" />

        <%-- Forum name and brief info about the forum --%>

        <p class="jive-page-title">
        <%-- User Profile: {username} --%>
        <jive:i18n key="profile.title">
            <jive:arg>
                <%= user.getUsername() %>
            </jive:arg>
        </jive:i18n>
        </p>

        <jive:property if="watches.enabled">

            <%  // See if the page user has a watch on this user
                if (isWatchedUser) {
            %>
                <table class="jive-info-message" cellpadding="3" cellspacing="0" border="0" width="100%">
                <tr valign="top">
                    <td width="1%"><img src="images/info-16x16.gif" width="16" height="16" border="0"></td>
                    <td width="99%">

                        <span class="jive-info-text">

                        You are watching this user. To remove this watch, click "Stop Watching User"
                        below.

                        <%-- Watch Options --%>
                        (<a href="editwatches!default.jspa"><jive:i18n key="global.watch_options" /></a>)

                        </span>

                    </td>
                </tr>
                </table>
                <br>

            <%  } %>

        </jive:property>

        <table cellpadding="0" cellspacing="0" border="0">
        <tr>
            <td>
                <%@ include file="back-link.jsp" %>
            </td>

            <jive:property if="watches.enabled">

                <%  if (!action.isGuest() && pageUser != null && pageUser.getID() != user.getID()) { %>

                    <td>
                        <table cellpadding="3" cellspacing="0" border="0">
                        <tr>
                            <td><img src="images/watch-16x16.gif" width="16" height="16" border="0"></td>
                            <td>
                                <%  if (isWatchedUser) { %>

                                    <a href="watches!remove.jspa?userID=<%= user.getID() %>">Stop Watching User</a>

                                <%  } else { %>

                                    <a href="watches!add.jspa?userID=<%= user.getID() %>">Watch this User</a>

                                <%  } %>
                            </td>
                        </tr>
                        </table>
                    </td>

                <%  } %>

            </jive:property>

        </tr>
        </table>
        <br>

    </td>
    <td width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>
    <td width="1%">

        <%@ include file="accountbox.jsp" %>

    </td>
</tr>
</table>

<span class="jive-profile">

<table cellpadding="3" cellspacing="0" border="0" width="100%">
<tr>
    <th colspan="2">
        <%-- Profile for: {0} --%>
        <jive:i18n key="profile.user_profile_for">
            <jive:arg>
                <%= user.getUsername() %>
            </jive:arg>
        </jive:i18n>
    </th>
</tr>
<tr>
    <td width="30%" class="jive-label">
        <%-- ID: --%>
        <jive:i18n key="global.userid" /><jive:i18n key="global.colon" />
    </td>
    <td width="70%">
        <%= user.getID() %>
    </td>
</tr>
<tr>
    <td width="30%" class="jive-label">
        <%-- Name: --%>
        <jive:i18n key="global.name" /><jive:i18n key="global.colon" />
    </td>
    <td width="70%">
        <%  if (pageUser != null && pageUser.getID() == user.getID()) { %>

            <%  if (user.getName() != null) { %>

                <%= StringUtils.escapeHTMLTags(user.getName()) %>

                <%  if (!user.isNameVisible()) { %>

                    <i><jive:i18n key="profile.hidden" /></i>

                <%  } %>

            <%  } %>

        <%  } else { %>

            <%  if (user.getName() != null) { %>

                <%  if (user.isNameVisible()) { %>

                    <%= StringUtils.escapeHTMLTags(user.getName()) %>

        <%  } else { %>

                    <i><jive:i18n key="profile.hidden" /></i>

        <%  } %>

            <%  } %>

        <%  } %>
            </td>
        </tr>
<tr>
    <td width="30%" class="jive-label">
        <%-- Email: --%>
        <jive:i18n key="global.email" /><jive:i18n key="global.colon" />
    </td>
    <td width="70%">
        <%  if (pageUser != null && pageUser.getID() == user.getID()) { %>

            <%  if (user.getEmail() != null) { %>

                <a href="mailto:<%= StringUtils.escapeHTMLTags(user.getEmail()) %>"
                 ><%= StringUtils.escapeHTMLTags(user.getEmail()) %></a>

                <%  if (!user.isEmailVisible()) { %>

                    <i><jive:i18n key="profile.hidden" /></i>

                <%  } %>

            <%  } %>

        <%  } else { %>

            <%  if (user.getEmail() != null) { %>

                <%  if (user.isEmailVisible()) { %>

                    <a href="mailto:<%= StringUtils.escapeHTMLTags(user.getEmail()) %>"
                     ><%= StringUtils.escapeHTMLTags(user.getEmail()) %></a>

                <%  } else { %>

                    <i><jive:i18n key="profile.hidden" /></i>

                <%  } %>

            <%  } %>

        <%  } %>
    </td>
</tr>
    <tr>
        <td width="30%" class="jive-label">
            <%-- Registered: --%>
            <jive:i18n key="global.registered" /><jive:i18n key="global.colon" />
        </td>
        <td width="70%">
        <%= action.getShortDateFormat().format(user.getCreationDate()) %>
        </td>
    </tr>
<%  if (user.getProperty("jiveOccupation") != null) { %>
    <tr>
        <td width="30%" class="jive-label">
            <%-- Occupation: --%>
            <jive:i18n key="global.occupation" /><jive:i18n key="global.colon" />
        </td>
        <td width="70%">
            <%= StringUtils.escapeHTMLTags(user.getProperty("jiveOccupation")) %>
        </td>
    </tr>
<%  } %>
<%  if (user.getProperty("jiveLocation") != null) { %>
    <tr>
        <td width="30%" class="jive-label">
            <%-- Location: --%>
            <jive:i18n key="global.location" /><jive:i18n key="global.colon" />
        </td>
        <td width="70%">
            <%= StringUtils.escapeHTMLTags(user.getProperty("jiveLocation")) %>
        </td>
    </tr>
<%  } %>
<%  if (user.getProperty("jiveHomepage") != null) { %>
    <tr>
        <td width="30%" class="jive-label">
            <%-- Homepage: --%>
            <jive:i18n key="global.homepage" /><jive:i18n key="global.colon" />
        </td>
        <td width="70%">
            <%  String homepage = StringUtils.escapeHTMLTags(user.getProperty("jiveHomepage")); %>

            <a href="<%= homepage %>" target="_blank"><%= homepage %></a>
        </td>
    </tr>
<%  } %>
<%  if (user.getProperty("jiveBiography") != null) { %>
    <tr>
        <td width="30%" class="jive-label">
            <%-- Biography: --%>
            <jive:i18n key="global.biography" /><jive:i18n key="global.colon" />
        </td>
        <td width="70%">
            <%= StringUtils.escapeHTMLTags(user.getProperty("jiveBiography")) %>
        </td>
    </tr>
<%  } %>
<tr>
    <td width="30%" class="jive-label">
        <%-- Total Posts: --%>
        <jive:i18n key="global.total_posts" /><jive:i18n key="global.colon" />
    </td>
    <td width="70%">
        <%= action.getNumberFormat().format(action.getForumFactory().getUserMessageCount(user)) %>
    </td>
</tr>

<%  // Print out reward point summary if that feature is enabled:
    if ("true".equals(JiveGlobals.getJiveProperty("rewards.enabled"))) {
        // Get a reward manager:
        RewardManager manager = forumFactory.getRewardManager();
%>
    <tr>
        <td width="1%" nowrap>
            <%-- Reward Points Earned: --%>
            <jive:i18n key="rewards.reward_points_earned" /><jive:i18n key="global.colon" />
        </td>
        <td>
            <%= action.getNumberFormat().format(manager.getPointsEarned(user)) %>
        </td>
    </tr>
    <tr>
        <td width="1%" nowrap>
            <%-- Reward Points Awarded: --%>
            <jive:i18n key="rewards.reward_points_awarded" /><jive:i18n key="global.colon" />
        </td>
        <td>
            <%= action.getNumberFormat().format(manager.getPointsRewarded(user)) %>
        </td>
    </tr>

<%  } %>

</table>

<ww:if test="hasRecentMessages(10) == true">

    <ww:bean name="'com.jivesoftware.webwork.util.Counter'" id="counter">
        <ww:param name="first" value="1" />
    </ww:bean>

    <br><br>

    <span class="jive-message-list">

    <table class="jive-box" cellpadding="3" cellspacing="0" border="0" width="100%">
    <tr>
        <th colspan="2">
            <%-- Recent Messages --%>
            <jive:i18n key="profile.recent_messages" />
        </th>
        <th>
            <%-- Forum --%>
            <jive:i18n key="global.forum" />
        </th>
        <th>
            <%-- Posted --%>
            <jive:i18n key="global.posted" />
        </th>
    </tr>
    <ww:iterator value="recentMessages(10)" status="'status'">

        <tr class="<ww:if test="@status/even==true">jive-even</ww:if><ww:else>jive-odd</ww:else>">
            <td width="1%" nowrap align="center">
                <ww:property value="@counter/next" />
            </td>
            <td width="97%">
                <ww:if test="subject">
                    <a href="thread.jspa?threadID=<ww:property value="forumThread/ID" />&messageID=<ww:property value="ID" />#<ww:property value="ID" />"
                     ><ww:property value="subject" /></a>
                </ww:if>
                <ww:else>
                    &nbsp;
                </ww:else>
            </td>
            <td width="1%" nowrap>
                <a href="forum.jspa?forumID=<ww:property value="forumThread/forum/ID" />"
                ><ww:property value="forumThread/forum/name" /></a>
            </td>
            <td width="1%" nowrap>
                <ww:property value="dateFormat/format(creationDate)" />
            </td>
        </tr>

    </ww:iterator>
    </table>

    <br>

    <%-- show all user messages --%>
    <a href="search!execute.jspa?userID=<%= user.getID() %>"
     ><jive:i18n key="profile.show_all_messages" /></a>

    </span>

</ww:if>

</span>

<br><br>
</div>
<jsp:include page="footer.jsp" flush="true" />


<%--
  - $RCSfile: thread-row.jsp,v $
  - $Revision: 1.3.2.4 $
  - $Date: 2003/07/01 17:32:53 $
  -
  - Copyright (C) 1999-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software.  Use is subject to license terms.
--%>

<%@ page import="com.jivesoftware.forum.action.util.Guest,
                 com.jivesoftware.forum.*,
                 com.jivesoftware.forum.util.SkinUtils"
%>

<%--
  - Variables assumed by this page:
  -     * action            ForumActionSupport  Action associated with this view.
  -     * thread            ForumThread         The thread we're displaying in this row.
  -     * rewardManager     RewardManager       A reward manager to see if reward points exist for this thread.
  -     * rewardsEnabled    boolean             Indicates if the reward point feature is enabled.
  -     * watchManager      WatchManager        A watch manager to see if the thread is watched.
  -     * watchesEnabled    boolean             Indicates if the thread is being watched by the current user.
  -     * status            int                 Used to properly print alternating row colors.
  -     * showForumColumn   boolean             Indicates whether or not to show the forum column (the forum the thread is located in).
  -     * shortLastPost     boolean             Indicates the "Last Post" column should be shortened.
--%>

<%  // Variables unique to this thread:

    // Indicates this thread is locked:
    boolean locked = "true".equals(thread.getProperty("locked"));

    // Indicates this thread has been marked as a question:
    boolean isQuestion = "true".equals(thread.getProperty("isQuestion"));
%>

<tr class="<%= ((status++%2==1)?"jive-odd":"jive-even") %>" valign="top">
    <td class="jive-bullet" width="1%" nowrap>

        <%  if (action.getReadStatus(thread, ReadTracker.UNREAD)) { %>

            <img src="images/unread.gif" width="9" height="9" border="0" vspace="4" hspace="2">

        <%  } else if (action.getReadStatus(thread, ReadTracker.UPDATED)) { %>

            <img src="images/updated.gif" width="9" height="9" border="0" vspace="4" hspace="2">

        <%  } else { %>

            <img src="images/read.gif" width="9" height="9" border="0" vspace="4" hspace="2">

        <%  } %>

    </td>
    <td class="jive-topic-name" width="<%= ((showForumColumn) ? "95" : "96") %>%">

        <%  if (locked) { %>

            <img src="images/lock.gif" width="9" height="12" border="0">

            <a href="thread.jspa?threadID=<%= thread.getID() %>&tstart=<%= action.getStart() %>"
             ><%= thread.getName() %></a>

        <%  } else { %>

            <a href="thread.jspa?threadID=<%= thread.getID() %>&tstart=<%= action.getStart() %>"
             ><%= thread.getName() %></a>

            <%  if (isQuestion) { %>

                <img src="images/question-9x9.gif" width="9" height="9" border="0" hspace="4"
                 title="<jive:i18n key="question.this_topic_is_question" />">

            <%  } %>

            <%  if (rewardsEnabled && rewardManager.getPoints(thread) > 0) { %>

                <img src="images/reward-9x9.gif" width="9" height="9" border="0" hspace="4"
                 title="<jive:i18n key="rewards.this_topic_has" />">

            <%  } %>

            <%  if (action.getPageUser() != null && watchesEnabled
                        && watchManager.isWatched(action.getPageUser(), thread))
                {
            %>
                <img src="images/watch-10x10.gif" width="10" height="10" border="0" hspace="4"
                 title="<jive:i18n key="watches.you_are_watching_this_topic" />">

            <%  } %>

        <%  } %>

    </td>
    <td class="jive-author" width="1%" nowrap>

        <%  if (thread.getRootMessage().getUser() != null) { %>

            <a href="profile.jspa?userID=<%= thread.getRootMessage().getUser().getID() %>"
             ><%= thread.getRootMessage().getUser().getUsername() %></a>

            <%  if (action.getPageUser() != null && watchesEnabled
                        && watchManager.isWatched(action.getPageUser(), thread.getRootMessage().getUser()))
                {
            %>
                <img src="images/watch-10x10.gif" width="10" height="10" border="0" hspace="4"
                 title="<jive:i18n key="watches.you_are_watching_this_user" />">

            <%  } %>

        <%  } else {
                Guest guest = new Guest();
                guest.setMessage(thread.getRootMessage());
        %>
            <span class="jive-guest">
            <%  if (guest.getEmail() != null) { %>

                <a href="mailto:<%= guest.getEmail() %>"><%= guest.getDisplay() %></a>

            <%  } else { %>

                <%= guest.getDisplay() %>

            <%  } %>
            </span>

        <%  } %>

    </td>

    <%  if (showForumColumn) { %>

        <td class="jive-forum" width="1%" nowrap>

            <a href="forum.jspa?forumID=<%= thread.getForum().getID() %>"
             ><%= (thread.getForum().getName()) %></a>

        </td>

    <%  } %>

    <td class="jive-counts" width="1%">

        <%= (thread.getMessageCount()-1) %>

    </td>
    <td class="jive-date" width="1%" nowrap>

        <table cellpadding="0" cellspacing="0" border="0" width="100%">
        <tr>
            <td width="99%" nowrap>

                <%-- Last modified (last post) date --%>
                <%= action.getDateFormat().format(thread.getModificationDate()) %>

            </td>
            <td width="1%" nowrap align="right">

                <%  ForumMessage lastPost = SkinUtils.getLastPost(thread); %>

                <%  if (lastPost != null) { %>

                    <jive:property if="skin.default.showLastPostLink">

                        <%  if (shortLastPost) { %>

                            <a href="thread.jspa?messageID=<%= lastPost.getID() %>#<%= lastPost.getID() %>"
                             > &raquo;</a>

                        <%  } else { %>

                            <span class="jive-last-post">
                            <%-- by: {LAST_POST} --%>
                            <jive:i18n key="global.last_post_by">
                                <jive:arg>

                                    <%  if (lastPost.getUser() != null) { %>

                                        <a href="thread.jspa?messageID=<%= lastPost.getID() %>#<%= lastPost.getID() %>"
                                         ><%= lastPost.getUser().getUsername() %> &raquo;</a>

                                    <%  } else {
                                            Guest guest = new Guest();
                                            guest.setMessage(lastPost);
                                    %>
                                        <span class="jive-guest">
                                        <a href="thread.jspa?messageID=<%= lastPost.getID() %>#<%= lastPost.getID() %>"
                                         ><%= guest.getDisplay() %> &raquo;</a>
                                        </span>

                                    <%  } %>

                                </jive:arg>
                            </jive:i18n>
                            </span>

                        <%  } %>

                    </jive:property>

                <%  } %>

            </td>
        </tr>
        </table>

    </td>
</tr>
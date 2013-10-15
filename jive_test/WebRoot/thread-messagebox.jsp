<%--
  - $RCSfile: thread-messagebox.jsp,v $
  - $Revision: 1.21.2.6 $
  - $Date: 2003/07/25 21:26:51 $
  -
  - Copyright (C) 1999-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software.  Use is subject to license terms.
--%>

<%@ page import="com.jivesoftware.forum.action.util.*,
                 java.util.Iterator,
                 com.jivesoftware.base.*,
                 com.jivesoftware.util.*,
                 com.jivesoftware.forum.action.*,
                 com.jivesoftware.forum.*"
%>

<%  // This page is meant to be *included statically* in the thread pages. This is because
    // the box that contains the actual message content (subject, body, reply buttons,
    // moderator buttons, etc).
    //
    // Variables assumed on this page:
    //
    // action - an instance of ForumThreadAction
    // forumFactory - the ForumFactory object
    // forum - the forum this thread is in
    // thread - the thread we're in
    // message - the specific message we're displaying
    // status - an int variable we use to mod 2 with so we can calculate alternating row colors.
    //
    // All other variables needed are declared below.
%>

<%  User author = message.getUser();
    boolean canEdit = action.getCanEdit(message);
    boolean isModerator = action.isModerator(forum);
    boolean readTrackerEnabled = "true".equals(JiveGlobals.getJiveProperty("readTracker.enabled"));
    RewardManager rewardManager = null;
    boolean canRewardMessage = action.getCanRewardMessage(message);
    boolean rewardsEnabled = "true".equals(JiveGlobals.getJiveProperty("rewards.enabled"));
    if (rewardsEnabled) {
        rewardManager = forumFactory.getRewardManager();
    }
    ByteFormat byteFormat = new ByteFormat();
%>

<table class="jive-box" cellpadding="3" cellspacing="0" border="0" width="100%">
<tr valign="top" class="<%= ((status++%2==0)?"jive-odd":"jive-even") %>">
    <td width="1%">
        <table cellpadding="0" cellspacing="0" border="0" width="150">
        <tr>
            <td>
                <%  if (author == null) {
                        Guest guest = new Guest();
                        guest.setMessage(message);
                %>
                    <span class="jive-guest">
                    <%  if (guest.getEmail() != null) { %>

                        <a href="mailto:<%= guest.getEmail() %>"><%= guest.getDisplay() %></a>

                    <%  } else { %>

                        <%= guest.getDisplay() %>

                    <%  } %>
                    </span>

                <%  } else { %>

                    <a href="profile.jspa?userID=<%= author.getID() %>"
                     title="<%= ((author.getName()!=null)?author.getName():"") %>"
                     ><%= author.getUsername() %></a>

                    <br><br>

                    <span class="jive-description">

                    <%-- Posts: --%>
                    <jive:i18n key="global.posts" /><jive:i18n key="global.colon" />
                    <%= action.getNumberFormat().format(forumFactory.getUserMessageCount(author)) %>
                    <br>
                    <%  if (author.getProperty("jiveLocation") != null) { %>

                        <%-- From: --%>
                        <jive:i18n key="global.from" /><jive:i18n key="global.colon" />
                        <%= author.getProperty("jiveLocation") %><br>

                    <%  } %>

                    <%-- Registered: --%>
                    <%  if (author.getCreationDate() != null) { %>
                        <jive:i18n key="global.registered" /><jive:i18n key="global.colon" />
                        <%= action.getShortDateFormat().format(author.getCreationDate()) %>
                    <%  } %>

                    </span>

                <%  } %>
            </td>
        </tr>
        </table>
    </td>
    <td width="99%">
        <table cellpadding="0" cellspacing="0" border="0" width="100%">
        <tr valign="top">
            <td width="99%">

                <%  if (readTrackerEnabled && !action.isGuest()) {
                        ReadTracker readTracker = action.getForumFactory().getReadTracker();
                        // Get the current read status
                        int currentReadStatus = readTracker.getReadStatus(action.getPageUser(), message);
                        // Mark the current message as read
                        readTracker.markRead(action.getPageUser(), message);
                %>
                    <%  if (ReadTracker.UPDATED == currentReadStatus) { %>
                        <img src="images/updated.gif" width="9" height="9" border="0">
                    <%  } else if (ReadTracker.UNREAD == currentReadStatus) { %>
                        <img src="images/unread.gif" width="9" height="9" border="0">
                    <%  } else { %>
                        <img src="images/read.gif" width="9" height="9" border="0">
                    <%  } %>

                <%  } %>

                <span class="jive-subject">
                <a name="<%= message.getID() %>"></a>
                <%= message.getSubject() %>
                </span>

                <%  if (rewardsEnabled) {
                        int points = rewardManager.getPoints(message);
                        if (points > 0) {
                %>
                    &nbsp;
                    <%-- Points awarded to this topic: X --%>

                    <nobr>[<img src="images/reward-9x9.gif" width="9" height="9" border="0"
                     title="<jive:i18n key="rewards.points_awarded_to_message"><jive:arg><%= points %></jive:arg></jive:i18n>">

                    <%-- X pts --%>
                     <jive:i18n key="rewards.num_points_short"><jive:arg><%= points %></jive:arg></jive:i18n>
                     ]</nobr>

                <%      }
                    }
                %>

                <br>

                <%-- Posted: --%>
                <jive:i18n key="global.posted" /><jive:i18n key="global.colon" />
                <%= action.getDateFormat().format(message.getCreationDate()) %>
            </td>
            <td width="1%">
                <table cellpadding="3" cellspacing="0" border="0">
                <tr>
                    <%  if (canRewardMessage) { %>
                        <%-- Reward button --%>
                        <td>
                            <a href="rewards!default.jspa?messageID=<%= message.getID() %>&mode=transfer"
                             title=""
                             ><img src="images/reward-16x16.gif" width="16" height="16" border="0"></a>
                        </td>
                    <%  } %>

                    <%  if (canEdit) { %>
                        <%-- Edit button --%>
                        <td>
                            <a href="edit!default.jspa?messageID=<%= message.getID() %>"
                             title="<jive:i18n key="thread.click_edit_message" />"
                             ><img src="images/edit-16x16.gif" width="16" height="16" border="0"></a>
                        </td>
                    <%  } %>

                    <%  if (isModerator) { %>

                        <%  if (thread.getRootMessage().getID() == message.getID()) { %>

                            <%  if (!action.isLocked()) { %>

                                <%-- Lock Topic button --%>
                                <td>
                                    <a href="lock!default.jspa?threadID=<%= thread.getID() %>"
                                     title="<jive:i18n key="thread.click_to_lock_topic" />"
                                     ><img src="images/lock-16x16.gif" width="16" height="16" border="0"></a>
                                </td>

                            <%  } else { %>

                                <%-- Unlock Topic button --%>
                                <td>
                                    <a href="unlock!default.jspa?threadID=<%= thread.getID() %>"
                                     title="<jive:i18n key="thread.click_to_unlock_topic" />"
                                     ><img src="images/unlock-16x16.gif" width="16" height="16" border="0"></a>
                                </td>

                            <%  } %>

                            <%-- Delete button --%>
                            <td>
                                <%-- Need to show different messages for root message vs other messages --%>
                                <a href="delete!default.jspa?messageID=<%= message.getID() %>"
                                 title="<jive:i18n key="thread.click_to_delete_topic" />"
                                 ><img src="images/delete-16x16.gif" width="16" height="16" border="0"></a>
                            </td>
                            <%-- Move button --%>
                            <td>
                                <a href="move!default.jspa?messageID=<%= message.getID() %>"
                                 title="<jive:i18n key="thread.click_to_move_topic" />"
                                 ><img src="images/move-16x16.gif" width="16" height="16" border="0"></a>
                            </td>

                        <%  } else { %>

                            <%-- Delete button --%>
                            <td>
                                <%-- Need to show different messages for root message vs other messages --%>
                                <a href="delete!default.jspa?messageID=<%= message.getID() %>"
                                 title="<jive:i18n key="thread.click_to_delete_message" />"
                                 ><img src="images/delete-16x16.gif" width="16" height="16" border="0"></a>
                            </td>
                            <%-- Branch button --%>
                            <td>
                                <a href="branch!default.jspa?messageID=<%= message.getID() %>"
                                 title="<jive:i18n key="thread.click_to_branch_message" />"
                                 ><img src="images/branch-16x16.gif" width="16" height="16" border="0"></a>
                            </td>

                        <%  } %>

                    <%  } %>

                    <%-- Reply button --%>
                    <%  if (!action.isLocked() && !action.isArchived() &&
                            !"true".equals(action.getForum().getProperty("jiveDisablePostLinks")))
                        {
                    %>

                        <td>&nbsp;</td>
                        <td>
                            <a href="post!reply.jspa?messageID=<%= message.getID() %>"
                             title="<jive:i18n key="thread.click_reply" />"
                             ><img src="images/reply-16x16.gif" width="16" height="16" border="0"></a>
                        </td>
                        <td>
                            <a href="post!reply.jspa?messageID=<%= message.getID() %>"
                             title="<jive:i18n key="thread.click_reply" />"
                             ><jive:i18n key="global.reply" /></a>
                        </td>

                    <%  } %>
                </tr>
                </table>
            </td>
        </tr>
        <%  if (message.getAttachmentCount() > 0) { %>
            <tr>
                <td colspan="2">
                    <div class="jive-attachment-list">
                    <table cellpadding="3" cellspacing="0" border="0" width="100%">
                    <%  boolean first = true;
                        for (Iterator attachments=message.getAttachments(); attachments.hasNext(); ) {
                            Attachment attachment = (Attachment)attachments.next();
                    %>
                    <tr>
                        <td width="1%"
                            ><a href="servlet/JiveServlet/download/<%= forum.getID() %>-<%= thread.getID() %>-<%= message.getID() %>-<%= attachment.getID() %>/<%= attachment.getName() %>"
                            ><img src="servlet/JiveServlet?attachImage=true&contentType=<%= java.net.URLEncoder.encode(attachment.getContentType()) %>&attachment=<%= attachment.getID() %>" border="0"></a
                            ></td>
                        <td width="98%">
                            <a href="servlet/JiveServlet/download/<%= forum.getID() %>-<%= thread.getID() %>-<%= message.getID() %>-<%= attachment.getID() %>/<%= attachment.getName() %>"
                             ><%= attachment.getName() %></a>
                             (<%= byteFormat.format(new Long(attachment.getSize())) %>)
                        </td>
                        <%  if (first && action.getCanEditAttach(message)) {
                                first = false;
                        %>
                            <td width="1%" rowspan="99" valign="top" nowrap>
                                <%-- edit attachments --%>
                                <a href="editattach!default.jspa?forumID=<%= forum.getID() %>&threadID=<%= thread.getID() %>&messageID=<%= message.getID() %>"
                                 ><jive:i18n key="editattach.edit_attachments" /></a>
                            </td>
                        <%  } %>
                    </tr>
                    <%  } %>
                    </table>
                    </div>
                </td>
            </tr>
        <%  } %>
        <tr>
            <td colspan="2" style="border-top: 1px #ccc solid;">
                <br>
                <%= message.getBody() %>
                <br><br>
            </td>
        </tr>
        </table>
    </td>
</tr>
</table>
<%--
  - $RCSfile: thread-buttons.jsp,v $
  - $Revision: 1.11.2.3 $
  - $Date: 2003/07/25 21:26:51 $
  -
  - Copyright (C) 1999-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software.  Use is subject to license terms.
--%>

<%  // This page is meant to be *included statically* in the thread pages.
    //
    // Variables assumed on this page:
    //
    // action - an instance of ForumThreadAction
    // forum - the forum this thread is in
    // thread - the thread we're in
%>

<div class="jive-button">
<table cellpadding="0" cellspacing="0" border="0">
<tr>
    <%  // Only show the reply button if the thread is not locked & not archived
        if (!action.isLocked() && !action.isArchived() &&
                !"true".equals(action.getForum().getProperty("jiveDisablePostLinks")))
        {
    %>
        <td>
            <table cellpadding="3" cellspacing="0" border="0">
            <tr>
                <td><a href="post!reply.jspa?threadID=<%= thread.getID() %>"
                     ><img src="images/reply-16x16.gif" width="16" height="16" border="0" alt="<jive:i18n key="thread.reply_topic" />"></a></td>
                <td>
                    <%-- Reply to this topic --%>
                    <span class="jive-button-label">
                    <a href="post!reply.jspa?threadID=<%= thread.getID() %>"
                     ><jive:i18n key="thread.reply_topic" /></a>
                    </span>
                </td>
            </tr>
            </table>
        </td>
    <%  } %>
    <td>
        <table cellpadding="3" cellspacing="0" border="0">
        <tr>
            <td><a href="search!default.jspa?forumID=<%= forum.getID() %>&threadID=<%= thread.getID() %>"
                 ><img src="images/search-16x16.gif" width="16" height="16" border="0" alt="<jive:i18n key="global.search_forum" />"></a></td>
            <td>
                <%-- Search Forum --%>
                <span class="jive-button-label">
                <a href="search!default.jspa?forumID=<%= forum.getID() %>&threadID=<%= thread.getID() %>"
                 ><jive:i18n key="global.search_forum" /></a>
                </span>
            </td>
        </tr>
        </table>
    </td>

    <jive:property if="watches.enabled">

        <%  if (action.getPageUser() != null) { %>
            <td>
                <table cellpadding="3" cellspacing="0" border="0">
                <tr>
                    <td>
                        <%  boolean isWatched = action.getForumFactory().getWatchManager().isWatched(action.getPageUser(), thread);
                            if (isWatched) {
                        %>
                            <a href="watches!remove.jspa?forumID=<%= forum.getID() %>&threadID=<%= thread.getID() %>"
                             ><img src="images/watch-16x16.gif" width="16" height="16" border="0" alt="<jive:i18n key="thread.stop_watch" />"></a>

                        <%  } else { %>

                            <a href="watches!add.jspa?forumID=<%= forum.getID() %>&threadID=<%= thread.getID() %>"
                             ><img src="images/watch-16x16.gif" width="16" height="16" border="0" alt="<jive:i18n key="global.watch_topic" />"></a>

                        <%  } %>
                    </td>
                    <td>
                        <span class="jive-button-label">
                        <%  if (isWatched) { %>

                            <%-- Stop watching topic --%>
                            <a href="watches!remove.jspa?forumID=<%= forum.getID() %>&threadID=<%= thread.getID() %>"
                             ><jive:i18n key="thread.stop_watch" /></a>

                        <%  } else { %>

                            <%-- Watch Topic --%>
                            <a href="watches!add.jspa?forumID=<%= forum.getID() %>&threadID=<%= thread.getID() %>"
                             ><jive:i18n key="global.watch_topic" /></a>

                        <%  } %>
                        </span>
                    </td>
                </tr>
                </table>
            </td>
        <%  } %>

    </jive:property>

</tr>
</table>
</div>
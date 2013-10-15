 <%--
  - $RCSfile: viewonline.jsp,v $
  - $Revision: 1.4.2.2 $
  - $Date: 2003/07/01 17:32:53 $
  -
  - Copyright (C) 1999-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software.  Use is subject to license terms.
--%>

<%@ page import="com.jivesoftware.forum.action.OnlineAction,
                 java.util.Iterator,
                 com.jivesoftware.base.*,
                 com.jivesoftware.util.StringUtils,
                 com.jivesoftware.forum.action.util.Paginator,
                 com.jivesoftware.forum.action.util.Page,
                 com.jivesoftware.forum.util.SkinUtils" %>

<%@ include file="global.jsp" %>

<%@ taglib uri="webwork" prefix="ww" %>
<%@ taglib uri="jivetags" prefix="jive" %>

<%  // Get the action assoicated with this view:
    OnlineAction action = (OnlineAction)getAction(request);
    // Get the presence manager
    PresenceManager presenceManager = action.getPresenceManager();
    // FOr convenience, get the online & guest user counts:
    int userCount = presenceManager.getOnlineUserCount();
    int guestCount = presenceManager.getOnlineGuestCount();
%>

<jsp:include page="header.jsp" flush="true" />
<div style="width:960px; margin:0px auto;">
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr valign="top">
    <td width="98%">

        <%-- Breadcrumbs (customizable via the admin tool) --%>

        <jsp:include page="breadcrumbs.jsp" flush="true" />

        <%-- Forum name and brief info about the forum --%>

        <p>
        <span class="jive-page-title">
        <jive:i18n key="online.online_users" />
        </span>
        </p>

        <p>
        <%  if (userCount > 0) { %>

            <%--
                Below is a summary of all online users. There are
                <%= userCount %> user(s) online and <%= guestCount %> guest(s).
            --%>
            <jive:i18n key="online.below_summary">
                <jive:arg>
                    <%= userCount %>
                </jive:arg>
                <jive:arg>
                    <%= guestCount %>
                </jive:arg>
            </jive:i18n>

            <%  if (userCount > OnlineAction.RANGE) { %>

                <%--
                <%= OnlineAction.RANGE %> users are shown per page.
                --%>
                <jive:i18n key="online.users_per_page">
                    <jive:arg>
                        <%= OnlineAction.RANGE %>
                    </jive:arg>
                </jive:i18n>

            <%  } %>

        <%  } else { %>

            <%--
                There are no online users and <%= guestCount %> guest(s) viewing the forums.
            --%>
            <jive:i18n key="online.no_online_guest_count">
                <jive:arg>
                    <%= guestCount %>
                </jive:arg>
            </jive:i18n>

        <%  } %>
        </p>

    </td>
    <td width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>
    <td width="1%">

        <%@ include file="accountbox.jsp" %>

    </td>
</tr>
</table>

<%-- Only show user list if there are users to show --%>

<%  if (userCount > 0) { %>

    <br>

    <jive:cache id="paginator">

        <%  // Get a paginator for this action. Since the action implements Pageable, just pass
            // in the action object to the Paginator constructor

            Paginator paginator = new Paginator(action);
        %>

        <table cellpadding="3" cellspacing="0" border="0" width="100%">
        <tr valign="top">
            <td>

                <%-- Pages: --%>
                <jive:i18n key="global.pages" /><jive:i18n key="global.colon" />
                <%= paginator.getNumPages() %>

                <%  if (paginator.getNumPages() > 1) { %>

                    <span class="jive-paginator">
                    [
                    <%  if (paginator.getPreviousPage()) { %>

                        <%-- Previous --%>
                        <a href="online.jspa?start=<%= paginator.getPreviousPageStart() %>"
                         ><jive:i18n key="global.previous" /></a> |

                    <%  } %>

                    <%  Page[] pages = paginator.getPages();
                        for (int i=0; i<pages.length; i++) {
                    %>
                        <%  if (pages[i] == null) { %>

                            <jive:i18n key="global.elipse" />

                        <%  } else { %>

                            <a href="online.jspa?start=<%= pages[i].getStart() %>"
                             class="<%= ((paginator.getStart()==pages[i].getStart())?"jive-current":"") %>"
                             ><%= pages[i].getNumber() %></a>

                         <% } %>

                    <%  } %>

                    <%  if (paginator.getNextPage()) { %>

                        <%-- Next --%>
                        | <a href="online.jspa?start=<%= paginator.getNextPageStart() %>"
                         ><jive:i18n key="global.next" /></a>

                    <%  } %>
                    ]
                    </span>

                <%  } %>

            </td>
        </tr>
        </table>

    </jive:cache>

    <div class="jive-message-list">

    <table class="jive-box" cellpadding="3" cellspacing="0" border="0" width="100%">
    <tr>
        <th colspan="2"><jive:i18n key="global.username" /></th>
        <th><jive:i18n key="global.login_time" /></th>
        <th><jive:i18n key="global.posts" /></th>
    </tr>

    <%  int counter = 0;
        for (Iterator iter=action.getOnlineUsers(); iter.hasNext(); ) {
            counter++;
            User user = (User)iter.next();
            Presence presence = presenceManager.getPresence(user);
            Date login = presence.getLoginTime();
    %>
        <tr class="jive-<%= ((counter%2==1) ? "odd" : "even") %>" valign="top">

            <td width="1%" nowrap>
                <%= (action.getStart() + counter) %>
            </td>
            <td width="39%">
                <a href="profile.jspa?userID=<%= user.getID() %>"><%= user.getUsername() %></a>

                <%  String name = user.getName(); %>

                <%  if (name != null) { %>

                    -- <%= StringUtils.escapeHTMLTags(name) %>

                <%  } else { %>

                    &nbsp;

                <%  } %>
            </td>
            <td width="40%" nowrap>
                <%= action.getDateFormat().format(login) %>
            </td>
            <td width="20%">
                <%= action.getNumberFormat().format(action.getForumFactory().getUserMessageCount(user)) %>
            </td>
        </tr>

    <%  } %>

    </table>

    </div>

    <jive:cache id="paginator" />

<%  } %>
</div>
<jsp:include page="footer.jsp" flush="true" />
<%--
  - $RCSfile: tabs.jsp,v $
  - $Revision: 1.25.2.1 $
  - $Date: 2003/06/06 03:37:38 $
  -
  - Copyright (C) 1999-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software.  Use is subject to license terms.
--%>

<%@ page import="com.jivesoftware.forum.action.*,
                 java.util.*,
                 com.jivesoftware.base.JiveGlobals"
%>

<%  // Get the action assocated with this view. This is necessary to get a handle on the
    // internationalization methods.
    ForumActionSupport act = (ForumActionSupport)getAction(request);
%>

<%  // This page will print out tabs that look something like this:
    //
    //   +-------+ +-------+ +-------+
    //   |       | |       | |       |
    //   |       +-----------------------------------------+
    //   +-------------------------------------------------+
    //
    // Below is a "tabs" variable which is where the name and link for each tab is stored.
    // Each item in the array is another array of 2 length - the display name of the
    // tab and its URL.
    // Also, a String variable "selectedTab" is assumed which should match the name
    // of the tab that is selected.
    //
    // This page makes good use of CSS to render the tabs - see style.jsp
%>

<%  // The "tabs" and "subtabs" data structures are lists of String arrays.
    // This makes it easy to add in extra tabs based on whether or not certain
    // features are enabled:
    List tabs = null;
%>

<%  if (act.getPageUser() != null) { %>

    <%  tabs = new ArrayList(5);
        tabs.add(new String[] {act.getText("global.general_settings"), "settings!tab.jspa"});

        tabs.add(new String[] {act.getText("settings.your_profile"), "editprofile!default.jspa"});

        // watches
        if ("true".equals(JiveGlobals.getJiveProperty("watches.enabled"))) {
            tabs.add(new String[] {act.getText("global.watches"), "editwatches!default.jspa"});
        }

        // rewards
        if ("true".equals(JiveGlobals.getJiveProperty("rewards.enabled"))) {
            tabs.add(new String[] {act.getText("rewards.reward_points"), "myrewards.jspa"});
        }
    %>

<%  } else { %>

    <%  tabs = new ArrayList(5);
        tabs.add(new String[] {act.getText("global.general_settings"), "settings!tab.jspa"});
    %>

<%  } %>

<table class="jive-tabs" cellpadding="0" cellspacing="0" border="0">
<tr>
    <td class="jive-tab-spacer" width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>

    <%  int selectedTabIndex = 0;
        for (int i=0; i<tabs.size(); i++) {
            String[] tabData = (String[])tabs.get(i);
            boolean selected = selectedTab.equals(tabData[0]);
            if (selected) {
                selectedTabIndex = i;
            }
    %>

        <td class="jive-<%= (selected?"selected-":"") %>tab" width="1%" nowrap>
            <a href="<%= tabData[1] %>"><%= tabData[0] %></a>
        </td>
        <td class="jive-tab-spacer" width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>

    <%  } %>

    <td class="jive-tab-spring" width="<%= (99-(tabs.size()*2)) %>%">&nbsp;</td>
</tr>
<tr>
    <td class="jive-tab-bar" colspan="99">
        &nbsp;
    </td>
</tr>
</table>
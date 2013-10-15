<%
/**
 *	$RCSfile: readTracking.jsp,v $
 *	$Revision: 1.1 $
 *	$Date: 2003/02/12 14:58:17 $
 */
%>

<%@ page import="com.jivesoftware.util.ParamUtils"
    errorPage="error.jsp"
%>

<%! // Load a group
    private Group loadGroup(ForumFactory forumFactory, String name) {
        Group group = null;
        if (name != null) {
            try {
                group = forumFactory.getGroupManager().getGroup(name);
            }
            catch (GroupNotFoundException gnfe) {}
        }
        return group;
    }
%>

<%@ include file="global.jsp" %>

<%  // Permissions check
    if (!isSystemAdmin) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }

    // Get parameters
    String readTrackingStatus = ParamUtils.getParameter(request,"readTrackingStatus");
    String groupName = ParamUtils.getParameter(request,"groupName");
    boolean updateStatus = ParamUtils.getBooleanParameter(request,"updateStatus");

    // Try to load group:
    Group group = loadGroup(forumFactory, groupName);

    if (updateStatus) {
        if ("disabled".equals(readTrackingStatus)) {
            JiveGlobals.setJiveProperty("readTracker.enabled","false");
        }
        else if ("enabled".equals(readTrackingStatus)) {
            JiveGlobals.setJiveProperty("readTracker.enabled","false");
        }
        else {
            if (group != null && "enabledGroup".equals(readTrackingStatus)) {
                JiveGlobals.setJiveProperty("readTracker.enabled","true");
                JiveGlobals.setJiveProperty("readTracker.enabled.groupName", group.getName());
            }
        }
        response.sendRedirect("readTracking.jsp");
        return;
    }

    // Page vars for the form
    if ("true".equals(JiveGlobals.getJiveProperty("readTracker.enabled"))) {
        readTrackingStatus = "enabled";
    }
    else {
        readTrackingStatus = "disabled";
    }
    String groupNameProp = JiveGlobals.getJiveProperty("readTracker.enabled.groupName");
    Group tempGroup = loadGroup(forumFactory, groupNameProp);
    if (tempGroup != null) {
        readTrackingStatus = "enabledGroup";
        group = tempGroup;
    }
%>

<%@ include file="header.jsp" %>

<p>

<%  // Title of this page and breadcrumbs
    String title = "Read Tracking Settings";
    String[][] breadcrumbs = {
        {"Main", "main.jsp"},
        {title, "readTracking.jsp"}
    };
%>
<%@ include file="title.jsp" %>

Page description here

<p>
<b>Read Tracking Status</b>
</p>

<p>
Use the form below to disable read tracking or enable it for registered users or groups.
</p>

<form action="readTracking.jsp" name="f">
<input type="hidden" name="updateStatus" value="true">

<ul>
    <table cellpadding="3" cellspacing="0" border="0">
    <tr>
        <td>
            <input type="radio" name="readTrackingStatus" value="disabled" id="readTrackingStatus0"
             onfocus="this.form.groupName.disabled=true;"
             <%= ("disabled".equals(readTrackingStatus) ? "checked" : "") %>>
        </td>
        <td>
            <label for="readTrackingStatus0">Read tracking disabled</label>
        </td>
    </tr>
    <tr>
        <td>
            <input type="radio" name="readTrackingStatus" value="enabled" id="readTrackingStatus1"
             onfocus="this.form.groupName.disabled=true;"
             <%= ("enabled".equals(readTrackingStatus) ? "checked" : "") %>>
        </td>
        <td>
            <label for="readTrackingStatus1">Read tracking enabled for registered users</label>
        </td>
    </tr>
    <tr valign="top">
        <td>
            <input type="radio" name="readTrackingStatus" value="enabledGroup" id="readTrackingStatus2"
             onfocus="this.form.groupName.disabled=false;this.form.groupName.focus();"
             <%= ("enabledGroup".equals(readTrackingStatus) ? "checked" : "") %>>
        </td>
        <td>
            <label for="readTrackingStatus2">Read tracking enabled for members of this group:</label>
            <br>
            <input type="text" name="groupName" size="30" maxlength="60"
             onfocus="this.form.readTrackingStatus[2].checked=true;"
             <%= ("enabledGroup".equals(readTrackingStatus) ? "" : "disabled") %>
             value="<%= (group != null) ? group.getName() : "" %>">
        </td>
    </tr>
    </table>

    <br>
    <input type="submit" name="submit" value="Update">
</ul>

</form>

<%@ include file="footer.jsp" %>
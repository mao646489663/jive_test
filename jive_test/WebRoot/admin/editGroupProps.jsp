<%
    /**
     * $RCSfile: editGroupProps.jsp,v $
     * $Revision: 1.4 $
     * $Date: 2003/04/30 16:31:39 $
     *
     * Copyright (C) 2002-2003 Jive Software. All rights reserved.
     *
     * This software is the proprietary information of Jive Software. Use is subject to license terms.
     */
%>

<%@ page import="java.util.*,
                 com.jivesoftware.forum.*,
                 com.jivesoftware.util.ParamUtils"
    errorPage="error.jsp"
%>

<%@ include file="global.jsp" %>

<%	// Security check
    if (!isSystemAdmin && !isGroupAdmin) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }

    // get parameters
    long groupID = ParamUtils.getLongParameter(request,"group",-1L);
    String propName = ParamUtils.getParameter(request,"propName");
    String propValue = ParamUtils.getParameter(request,"propValue");
    boolean edit = ParamUtils.getBooleanParameter(request, "edit", false);
    boolean cancel = (ParamUtils.getParameter(request, "cancel", false)) != null;

    // Get a group manager
    GroupManager groupManager = forumFactory.getGroupManager();

    // Load the specified group
    Group group = groupManager.getGroup(groupID);

    // Put the group in the session (is needed by the sidebar)
    session.setAttribute("admin.sidebar.groups.currentGroupID", ""+groupID);

    if (cancel) {
        response.sendRedirect("editGroupProps.jsp?group=" + groupID);
    }

    if ("true".equals(request.getParameter("saveProperty"))) {
        // Add a property
        if (propName != null && propValue != null) {
            group.setProperty(propName, propValue);
        }
        else {
            setOneTimeMessage(session, "addMessage", "Both the property name and value are required " +
                    "to add a property");
        }
        response.sendRedirect("editGroupProps.jsp?group=" + groupID);
        return;
    }

    if ("true".equals(request.getParameter("delete"))) {
        if (propName != null) {
            group.deleteProperty(propName);
        }
        else {
            setOneTimeMessage(session, "message", "Unable to delete property - no property name given.");
        }
        response.sendRedirect("editGroupProps.jsp?group=" + groupID);
        return;
    }

    // special onload command to load the sidebar
    onload = " onload=\"parent.frames['sidebar'].location.href='sidebar.jsp?sidebar=users';\"";
%>
<%@ include file="header.jsp" %>

<%  // Title of this page and breadcrumbs
    String title = "Edit Group Properties";
    String[][] breadcrumbs = {
        {"Main", "main.jsp"},
        {"Groups Summary", "groups.jsp"},
        {title, "editGroupProps.jsp?group="+groupID}
    };
%>
<%@ include file="title.jsp" %>

Edit extended group properties using the form below.

<p>

<b>Extended Properties for group <i><%= group.getName() %></i></b>

<ul>

To edit the value of a property, use the form below.

<%  String message = getOneTimeMessage(session, "message");
    if (message != null) { %>
    <p><span class="jive-error-text"><%= message %></span></p>
<%  } // end if message %>

<p>

<table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0" width="">
<tr><td>
<table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
<tr bgcolor="#eeeeee">
    <td align="center"><font size="-2" face="verdana,arial,helvetica,sans-serif"><b>PROPERTY NAME</b></font></td>
    <td align="center"><font size="-2" face="verdana,arial,helvetica,sans-serif"><b>PROPERTY VALUE</b></font></td>
    <td align="center"><font size="-2" face="verdana,arial,helvetica,sans-serif"><b>EDIT</b></font></td>
    <td align="center"><font size="-2" face="verdana,arial,helvetica,sans-serif"><b>DELETE</b></font></td>
</tr>
<%  Iterator properties = group.getPropertyNames();
    if (!properties.hasNext()) {
%>
    <tr bgcolor="#ffffff">
        <td align="center" colspan="4"><i>No properties</i></td>
    </tr>
<%  }
    while (properties.hasNext()) {
        String pName = (String)properties.next();
        String pValue = group.getProperty(pName);
%>
    <tr bgcolor="#ffffff">
        <td><%= pName %></td>
        <td><%= pValue %></td>
        <td align="center"><a href="editGroupProps.jsp?group=<%= groupID %>&edit=true&propName=<%= pName %>"
            ><img src="images/button_edit.gif" width="17" height="17" alt="Click to edit this property" border="0"></a
            >
        </td>
        <td align="center"><a href="editGroupProps.jsp?group=<%= groupID %>&delete=true&propName=<%= pName %>"
            ><img src="images/button_delete.gif" width="17" height="17" alt="Click to delete this property" border="0"></a
            >
        </td>
    </tr>
<%  } %>
</table>
</td></tr>
</table>
</ul>

<form action="editGroupProps.jsp">
<input type="hidden" name="group" value="<%= groupID %>">
<input type="hidden" name="saveProperty" value="true">
<%  if (!edit) { %>
        <b>Add Extended Properties</b>
<%  } else { %>
        <b>Edit Extended Property</b>
<%  } %>

<%  message = getOneTimeMessage(session, "addMessage");
    if (message != null) {
%>
    <p><span class="jive-error-text"><%= message %></span></p>
<%  } // end if message %>

<ul>
<table bgcolor="#cccccc" cellpadding="0" cellspacing="0" border="0" width="">
<tr><td>
<table bgcolor="#cccccc" cellpadding="3" cellspacing="1" border="0" width="100%">
<tr bgcolor="#ffffff">
    <td>Property Name:</td>
<%  if (edit) { %>
    <td>
        <input type="hidden" name="propName" value="<%= propName %>">
        <%= propName %>
    </td>
<%  } else { %>
    <td><input type="text" name="propName" size="20" maxlength="100"></td>
<%  } %>
</tr>
<tr bgcolor="#ffffff">
    <td valign="top">Property Value:</td>
 <%  if (edit) { %>
    <td><textarea cols="40" rows="10" name="propValue" wrap="virtual"><%= group.getProperty(propName) %></textarea></td>
<%  } else { %>
    <td><textarea cols="40" rows="10" name="propValue" wrap="virtual"></textarea></td>
<% } %>
</tr>
<tr bgcolor="#ffffff">
    <td colspan="2">
    <input type="submit" name="saveButton" value="Save Property">
<%  if (edit) { %>
        &nbsp;
        <input type="submit" name="cancel" value="Cancel">
<%  } %>
    </td>
</tr>
</table>
</td></tr>
</table>
</form>

<%@ include file="footer.jsp" %>

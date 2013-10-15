<%
/**
 * $RCSfile: editUserProps.jsp,v $
 * $Revision: 1.3 $
 * $Date: 2003/04/30 16:29:35 $
 *
 * Copyright (C) 2002-2003 Jive Software. All rights reserved.
 *
 * This software is the proprietary information of Jive Software. Use is subject to license terms.
 */
%>

<%@ page import="java.util.*,
                 com.jivesoftware.util.ParamUtils,
                 com.jivesoftware.util.StringUtils"
    errorPage="error.jsp"
%>

<%@ include file="global.jsp" %>

<%	// Security check
    if (!isSystemAdmin && !isUserAdmin) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }

    // get parameters
	long userID = ParamUtils.getLongParameter(request,"user",-1L);
    String propName = ParamUtils.getParameter(request,"propName");
    String propValue = ParamUtils.getParameter(request,"propValue");
    boolean edit = ParamUtils.getBooleanParameter(request, "edit", false);
    boolean cancel = (ParamUtils.getParameter(request, "cancel", false)) != null;

	// Get a user manager
	UserManager userManager = forumFactory.getUserManager();

    // Load the specified user
	User user = userManager.getUser(userID);

    // Put the user in the session (is needed by the sidebar)
    session.setAttribute("admin.sidebar.user.currentUserID", ""+userID);

    if (cancel) {
        response.sendRedirect("editUserProps.jsp?user="+userID);
    }

    if ("true".equals(request.getParameter("saveProperty"))) {
        // Add a property
        if (propName != null && propValue != null) {
            user.setProperty(propName, propValue);
        }
        else {
            setOneTimeMessage(session, "addMessage", "Both the property name and value are required " +
                    "to add a property");
        }
        response.sendRedirect("editUserProps.jsp?user=" + userID);
        return;
    }

    if ("true".equals(request.getParameter("delete"))) {
        if (propName != null) {
            user.deleteProperty(propName);
        }
        else {
            setOneTimeMessage(session, "message", "Unable to delete property - no property name given.");
        }
        response.sendRedirect("editUserProps.jsp?user=" + userID);
        return;
    }

    // special onload command to load the sidebar
    onload = " onload=\"parent.frames['sidebar'].location.href='sidebar.jsp?sidebar=users';\"";
%>

<%@ include file="header.jsp" %>

<%  // Title of this page and breadcrumbs
    String title = "Edit User Properties";
    String[][] breadcrumbs = {
        {"Main", "main.jsp"},
        {"User Summary", "users.jsp"},
        {title, "editUserProps.jsp?user="+userID}
    };
%>
<%@ include file="title.jsp" %>

Edit extended user properties using the form below. Note, saving a property with
the same name will update the value of the property.

<p>

<b>Extended Properties for <i><%= StringUtils.escapeHTMLTags(user.getUsername()) %></i></b>

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
    <%  Iterator properties = user.getPropertyNames();
        if (!properties.hasNext()) {
    %>
    <tr bgcolor="#ffffff">
        <td align="center" colspan="4"><i>No properties</i></td>
    </tr>
    <%  }
        while (properties.hasNext()) {
            String pName = (String)properties.next();
            String pValue = user.getProperty(pName);
    %>
    <tr bgcolor="#ffffff">
        <td><%= pName %></td>
        <td><%= StringUtils.escapeHTMLTags(pValue) %></td>
        <td align="center"><a href="editUserProps.jsp?user=<%= userID %>&edit=true&propName=<%= pName %>"
            ><img src="images/button_edit.gif" width="17" height="17" alt="Click to edit this property" border="0"></a
            >
        </td>
        <td align="center"><a href="editUserProps.jsp?user=<%= userID %>&delete=true&propName=<%= pName %>"
            ><img src="images/button_delete.gif" width="17" height="17" alt="Click to delete this property" border="0"></a
            >
        </td>
    </tr>
    <%  } %>
    </table>
    </td></tr>
    </table>
</ul>

<form action="editUserProps.jsp" method="post">
<input type="hidden" name="user" value="<%= userID %>">
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
    <td><textarea cols="40" rows="10" name="propValue" wrap="virtual"><%= user.getProperty(propName) %></textarea></td>
<%  } else { %>
    <td><textarea cols="40" rows="10" name="propValue" wrap="virtual"></textarea></td>
<% } %>
</tr>
<tr bgcolor="#ffffff">
    <td colspan="2">
    <input type="submit" name="submitButton" value="Save Property">
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
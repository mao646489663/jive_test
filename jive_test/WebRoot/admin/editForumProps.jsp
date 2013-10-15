<%
/**
 * $RCSfile: editForumProps.jsp,v $
 * $Revision: 1.3.4.1 $
 * $Date: 2003/07/24 19:03:15 $
 *
 * Copyright (C) 2002-2003 Jive Software. All rights reserved.
 *
 * This software is the proprietary information of Jive Software. Use is subject to license terms.
 */
%>

<%@ page import="java.util.*,
                 java.text.*,
                 com.jivesoftware.forum.*,
                 com.jivesoftware.util.ParamUtils"
    errorPage="error.jsp"
%>

<%@ include file="global.jsp" %>

<%	// Get parameters
	long forumID = ParamUtils.getLongParameter(request,"forum",-1L);
    String propertyName = ParamUtils.getParameter(request,"propName");
    String propertyValue = ParamUtils.getParameter(request,"propValue");
    boolean edit = ParamUtils.getBooleanParameter(request, "edit", false);
    boolean cancel = (ParamUtils.getParameter(request, "cancel", false)) != null;

    // Load up the forum specified
    Forum forum = forumFactory.getForum(forumID);

    // Permissions check
    if (!isSystemAdmin && !forum.isAuthorized(ForumPermissions.FORUM_CATEGORY_ADMIN | ForumPermissions.FORUM_ADMIN)) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }

    // Put the forum in the session (is needed by the sidebar)
    session.setAttribute("admin.sidebar.forum.currentForumID", new Long(forumID));

    if (cancel) {
        response.sendRedirect("editForumProps.jsp?forum="+forumID);
    }

    // save the name & description if requested
    if ("true".equals(request.getParameter("saveProperty"))) {
        if (propertyName != null && propertyValue != null) {
            forum.setProperty(propertyName, propertyValue);
        }
        else {
            setOneTimeMessage(session, "addMessage", "Both the property name and value are required " +
                    "to add a property");
        }
        response.sendRedirect("editForumProps.jsp?forum="+forumID);
        return;
    }

    if ("true".equals(request.getParameter("delete"))) {
        if (propertyName != null) {
            forum.deleteProperty(propertyName);
        }
        else {
            setOneTimeMessage(session, "message", "Unable to delete property - no property name given.");
        }
        response.sendRedirect("editForumProps.jsp?forum=" + forumID);
        return;
    }

    // special onload command to load the sidebar
    onload = " onload=\"parent.frames['sidebar'].location.href='sidebar.jsp?sidebar=forum';\"";
%>
<%@ include file="header.jsp" %>

<%  // Title of this page and breadcrumbs
    String title = "Forum Extended Properties";
    String[][] breadcrumbs = {
        {"Main", "main.jsp"},
        {"Categories &amp; Forums", "forums.jsp?cat=" + forum.getForumCategory().getID()},
        {title, "editForumProps.jsp?forum="+forumID}
    };
%>
<%@ include file="title.jsp" %>

<p>

Edit the extended properties of a forum using the form below.

<p>

<b>Extended Properties</b>

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
<%  Iterator properties = forum.getPropertyNames();
    if (!properties.hasNext()) {
%>
<tr bgcolor="#ffffff">
    <td align="center" colspan="4"><i>No properties</i></td>
</tr>
<%  }
    while (properties.hasNext()) {
        String pName = (String)properties.next();
        String pValue = forum.getProperty(pName);
%>
    <tr bgcolor="#ffffff">
        <td><%= pName %></td>
        <td><%= pValue %></td>
        <td align="center"><a href="editForumProps.jsp?forum=<%= forumID %>&edit=true&propName=<%= pName %>"
            ><img src="images/button_edit.gif" width="17" height="17" alt="Click to edit this property" border="0"></a
            >
        </td>
        <td align="center"><a href="editForumProps.jsp?forum=<%= forumID %>&delete=true&propName=<%= pName %>"
            ><img src="images/button_delete.gif" width="17" height="17" alt="Click to delete this property" border="0"></a
            ></td>
    </tr>
<%  } %>
</table>
</td></tr>
</table>
</ul>

<form action="editForumProps.jsp" method="post">
<input type="hidden" name="forum" value="<%= forumID %>">
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
        <input type="hidden" name="propName" value="<%= propertyName %>">
        <%= propertyName %>
    </td>
<%  } else { %>
    <td><input type="text" name="propName" size="20" maxlength="100"></td>
<%  } %>
</tr>
<tr bgcolor="#ffffff">
    <td valign="top">Property Value:</td>
<%  if (edit) { %>
    <td><textarea cols="40" rows="10" name="propValue" wrap="virtual"><%= forum.getProperty(propertyName) %></textarea></td>
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
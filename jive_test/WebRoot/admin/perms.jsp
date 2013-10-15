<%--
  -
  - $RCSfile: perms.jsp,v $
  - $Revision: 1.10.2.13 $
  - $Date: 2003/08/07 18:41:55 $
  -
  - Copyright (C) 2002-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software. Use is subject to license terms.
  -
--%>

<%@ page import="java.util.*,
                 java.net.URLEncoder,
                 com.jivesoftware.forum.*,
                 com.jivesoftware.forum.util.*,
                 com.jivesoftware.util.ParamUtils,
                 com.jivesoftware.forum.database.DbForumFactory"
    errorPage="error.jsp"
%>

<%@ include file="global.jsp" %>

<%!	// Global variables, methods, etc

    // ALL CONSTANTS REFERRED TO IN THIS FILE ARE DEFINED IN
    // permMethods.jsp

    static final Map permNames = new HashMap();
    static {
        permNames.put(new Long(READ_FORUM), "Read Forum");
        permNames.put(new Long(CREATE_THREAD), "Create Thread");
        permNames.put(new Long(CREATE_MESSAGE), "Create Message");
        permNames.put(new Long(MODERATOR), "Moderator");
        permNames.put(new Long(CREATE_MESSAGE_ATTACHMENT), "Create Attachment");
        permNames.put(new Long(SYSTEM_ADMIN), "System Admin");
        permNames.put(new Long(CAT_ADMIN), "Category Admin");
        permNames.put(new Long(FORUM_ADMIN), "Forum Admin");
        permNames.put(new Long(GROUP_ADMIN), "Group Admin");
        permNames.put(new Long(USER_ADMIN), "User Admin");
    }

    // types of users/groups to give permissions to
    static final int ANYBODY = 1;
    static final int REGISTERED = 2;
    static final int USER = 3;
    static final int GROUP = 4;

    // anonymous user & special user constants
    static final long GUEST_ID = -1L;
    static final long REGISTERED_ID = 0L;

    private User parseUser(String key, UserManager userManager) {
        int pos = key.lastIndexOf('_');
        long userID = Long.parseLong(key.substring("cb_update_u_".length(), pos));
        try {
            return userManager.getUser(userID);
        }
        catch (NumberFormatException nfe) {}
        catch (UserNotFoundException ignored) {}
        return null;
    }

    private Group parseGroup(String key, GroupManager groupManager) {
        int pos = key.lastIndexOf('_');
        try {
            long groupID = Long.parseLong(key.substring("cb_update_g_".length(), pos));
            return groupManager.getGroup(groupID);
        }
        catch (Exception e) {}
        return null;
    }

    private SortedMap getUserPermMap(PermissionsManager permManager, long[] permGroup) {
        TreeMap userPermMap = new TreeMap(JiveComparators.USER);
        // for each perm type, get the Iterator of users with that perm
        for (int i=0; i<permGroup.length; i++) {
            Iterator usersWithPerm = permManager.usersWithPermission(permGroup[i]);
            // for each perm, get the user associated with it and store it and the perm in
            // the user perm map
            while (usersWithPerm.hasNext()) {
                User user = (User)usersWithPerm.next();
                Permissions newPerm = new Permissions(permGroup[i]);
                if (userPermMap.containsKey(user)) {
                    newPerm = new Permissions((Permissions)userPermMap.get(user), newPerm);
                }
                userPermMap.put(user, newPerm);
            }
        }
        return userPermMap;
    }

    private SortedMap getGroupPermMap(PermissionsManager permManager, long[] permGroup) {
        TreeMap groupPermMap = new TreeMap(JiveComparators.GROUP);
        // for each perm type, get the Iterator of users with that perm
        for (int i=0; i<permGroup.length; i++) {
            Iterator groupsWithPerm = permManager.groupsWithPermission(permGroup[i]);
            // for each perm, get the user associated with it and store it and the perm in
            // the user perm map
            while (groupsWithPerm.hasNext()) {
                Group group = (Group)groupsWithPerm.next();
                Permissions newPerm = new Permissions(permGroup[i]);
                if (groupPermMap.containsKey(group)) {
                    newPerm = new Permissions((Permissions)groupPermMap.get(group), newPerm);
                }
                groupPermMap.put(group, newPerm);
            }
        }
        return groupPermMap;
    }

    private boolean contains(long[] array, long num) {
        for (int i=0; i<array.length; i++) {
            if (array[i] == num) {
                return true;
            }
        }
        return false;
    }
%>

<%	// Permission check
    if (!isSystemAdmin && Version.getEdition() == Version.Edition.LITE) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }
    else if (!isSystemAdmin && !isForumAdmin && !isCatAdmin) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }

    // Check to see what group of perms we're going to administer. We can
    // either modify user & group perms or admin permissions.
    int permGroup = ParamUtils.getIntParameter(request,"permGroup",-1);
    if (permGroup != CONTENT_GROUP && permGroup != ADMIN_GROUP) {
        throw new Exception("No permission group specified");
    }

    // Get parameters
    long forumID = ParamUtils.getLongParameter(request,"forum",-1L);
    long categoryID = ParamUtils.getLongParameter(request,"cat",-1L);
    long userID = ParamUtils.getLongParameter(request,"user", -1L);
    long groupID = ParamUtils.getLongParameter(request,"group", -1L);
    boolean remove = request.getParameter("remove") != null;
    boolean add = request.getParameter("add") != null && !remove;
    boolean cancel = request.getParameter("cancel") != null;
    boolean doAdd = request.getParameter("doAdd") != null && !remove && !cancel;
    boolean update = request.getParameter("update") != null;
    boolean updatedPerms = ParamUtils.getBooleanParameter(request,"updatedPerms");
    long[] newPerms = ParamUtils.getLongParameters(request,"newperm",-1L);
    String show = ParamUtils.getParameter(request,"show");
    String userlist = ParamUtils.getParameter(request,"userlist");
    String grouplist = ParamUtils.getParameter(request,"grouplist");
    String removetype = ParamUtils.getParameter(request,"removetype");

    if (show == null) {
        // show users by default
        show = "perms";
    }
    // also, make sure 'show' equals 'users' or 'groups' only:
    if (!show.equals("perms") && !show.equals("new")) {
        show = "perms";
    }

    if (cancel) {
        response.sendRedirect("perms.jsp?cat="+categoryID+"&forum=" + forumID + "&permGroup="+permGroup+"&show=perms");
    }

    boolean isError = false;

    // UserManager for getting and setting users or lists of users
	UserManager userManager = forumFactory.getUserManager();

    // GroupManager for getting and setting groups or list of groups
	GroupManager groupManager = forumFactory.getGroupManager();

    // Load the category
    ForumCategory category = null;
    if (categoryID != -1L) {
        category = forumFactory.getForumCategory(categoryID);
    }

    // Load the forum
    Forum forum = null;
    if (forumID != -1L) {
        forum = forumFactory.getForum(forumID);
    }

	// Get the permissions manager for the appropriate mode we're in:
	PermissionsManager permManager = null;

    if (category != null) {
        permManager = category.getPermissionsManager();
    }
    else if (forum != null) {
        permManager = forum.getPermissionsManager();
    }
    else {
        permManager = forumFactory.getPermissionsManager();
    }

    // Create the group of permissions we're going to administer:
    long[] permGroupDef = null;
    if (permGroup == CONTENT_GROUP) {
        permGroupDef = new long[] {
            READ_FORUM, CREATE_THREAD, CREATE_MESSAGE, CREATE_MESSAGE_ATTACHMENT
        };
    }
    else if (permGroup == ADMIN_GROUP) {
        if (forum == null) {
            if (category == null) {
                permGroupDef = new long[] {
                    SYSTEM_ADMIN, CAT_ADMIN, FORUM_ADMIN, USER_ADMIN, MODERATOR
                };
            }
            else {
                permGroupDef = new long[] {
                    CAT_ADMIN, FORUM_ADMIN, /*USER_ADMIN,*/ MODERATOR
                };
            }
        }
        else {
            permGroupDef = new long[] {
                FORUM_ADMIN, MODERATOR
            };
        }
    }

    // Update permissions
    if (update) {

        // Build up a Map of the state the checkboxes were in:
        Map oldPerms = new HashMap();

        // Load the map from parameters in the request prefixed by "was"
        for (Enumeration enumm=request.getParameterNames(); enumm.hasMoreElements(); ) {
            String param = (String)enumm.nextElement();
            if (param.startsWith("was")) {
                String key = param.substring(3,param.length()); // remove the "was"
                try {
                    oldPerms.put(key, new Long(Long.parseLong(request.getParameter(param))));
                }
                catch (NumberFormatException nfe) {}
            }
        }

        // Now that we have an idea of what the permissions were, loop over them and compare
        // with the new state of the check boxes. Based on what changed, add or remove perms.

        // Iterate over old permissions
        for (Iterator iter=oldPerms.keySet().iterator(); iter.hasNext(); ) {
            // Get the old value
            String key = (String)iter.next();
            long oldValue = ((Long)oldPerms.get(key)).longValue();
            // Get the new value - it's the param with the same name as the key
            long newValue = ParamUtils.getLongParameter(request,key,-1L);

            // If the new param was not found, so we need to remove the perm:
            if (newValue == -1L) {

                if (key.indexOf("anon") > -1) {
                    permManager.removeAnonymousUserPermission(oldValue);
                }
                else if (key.indexOf("reg") > -1) {
                    permManager.removeRegisteredUserPermission(oldValue);
                }
                else {
                    // get the user, remove the perm
                    User user = parseUser(key, userManager);
                    if (user != null) {
                        permManager.removeUserPermission(user, oldValue);
                    }
                }
            }
            // Otherwise, we need to add the permission:
            else {
                // First check to see if the permission already exists. If it doesn't, add it.
                boolean anonExists = permManager.anonymousUserHasPermission(newValue);
                boolean regExists = permManager.registeredUserHasPermission(newValue);
                if (key.indexOf("anon") > -1) {
                    if (!anonExists) {
                        permManager.addAnonymousUserPermission(newValue);
                    }
                }
                else if (key.indexOf("reg") > -1) {
                    if (!regExists) {
                        permManager.addRegisteredUserPermission(newValue);
                    }
                }
                else {
                    // get the user, add the perm
                    User user = parseUser(key, userManager);
                    if (user != null) {
                        permManager.addUserPermission(user, oldValue);
                    }
                }
            }
        }

        // Basically the same scheme as above. Loop through old group perms compare
        // them to what changed then add or remove permissions:
        if (getGroupPermMap(permManager, permGroupDef).size() > 0) {
            for (Iterator iter=oldPerms.keySet().iterator(); iter.hasNext(); ) {
                // Old value
                String key = (String)iter.next();
                long oldValue = ((Long)oldPerms.get(key)).longValue();
                // New value
                long newValue = ParamUtils.getLongParameter(request,key,-1L);
                // Needs to be removed:
                if (newValue == -1L) {
                    Group group = parseGroup(key, groupManager);
                    if (group != null) {
                        permManager.removeGroupPermission(group, oldValue);
                    }
                }
                // Otherwise, perm needs to be added:
                else {
                    Group group = parseGroup(key, groupManager);
                    if (group != null) {
                        permManager.addGroupPermission(group, oldValue);
                    }
                }
            }
        }

        if (!isError) {
            // Done, so redirect:
            response.sendRedirect("perms.jsp?cat="+categoryID+"&forum=" + forumID + "&permGroup="+permGroup+"&show="+show+"&updatedPerms=true");
            return;
        }
    }

    // Add a *new* user permission (not an update - that's handled above).
    List userErrors = new ArrayList();
    List groupErrors = new ArrayList();
    boolean noPermSelected = false;
    boolean noPermTargetSelected = false;
    if (doAdd) {
        if (newPerms.length == 0) {
            noPermSelected = true;
        }
        if (userlist == null && grouplist == null) {
            noPermTargetSelected = true;
        }

        List users = new java.util.LinkedList();
        List groups = new java.util.LinkedList();
        // Add a new user permission
        if (userlist != null && userlist.length() > 0) {
            StringTokenizer tokenizer = new StringTokenizer(userlist.trim(), ",");
            while (tokenizer.hasMoreTokens()) {
                String username = tokenizer.nextToken().trim();
                try {
                    User user = userManager.getUser(username);
                    users.add(user);
                }
                catch (UserNotFoundException unfe) {
                    userErrors.add(username);
                }
            }
        }
        // Add a new group perm
        if (grouplist != null && grouplist.length() > 0) {
            StringTokenizer tokenizer = new StringTokenizer(grouplist.trim(), ",");
            while (tokenizer.hasMoreTokens()) {
                String groupname = tokenizer.nextToken().trim();
                try {
                    Group group = groupManager.getGroup(groupname);
                    groups.add(group);
                    for (int i=0; i<newPerms.length; i++) {
                        permManager.addGroupPermission(group, newPerms[i]);
                    }
                }
                catch (GroupNotFoundException gnfe) {
                    groupErrors.add(groupname);
                }
            }
        }
        if (userErrors.size() == 0 && groupErrors.size() == 0 && !noPermSelected
                && !noPermTargetSelected)
        {
            for (int i=0; i<users.size(); i++) {
                User user = (User)users.get(i);
                for (int j=0; j<newPerms.length; j++) {
                    permManager.addUserPermission(user, newPerms[j]);
                }
            }
            for (int i=0; i<groups.size(); i++) {
                Group group = (Group)groups.get(i);
                for (int j=0; j<newPerms.length; j++) {
                    permManager.addGroupPermission(group, newPerms[j]);
                }
            }
            response.sendRedirect("perms.jsp?cat="+categoryID+"&forum=" + forumID + "&permGroup="+permGroup+"&show=perms&updatedPerms=true");
            return;
        }
    }

    // Remove permissions - this is a removal of all user permissions for a particular
    // user group.
    if (remove) {
        if ("anon".equals(removetype)) {
            for (int i=0; i<permGroupDef.length; i++) {
                permManager.removeAnonymousUserPermission(permGroupDef[i]);
            }
        }
        else if ("reg".equals(removetype)) {
            for (int i=0; i<permGroupDef.length; i++) {
                permManager.removeRegisteredUserPermission(permGroupDef[i]);
            }
        }
        else if ("user".equals(removetype)) {
            // Get the user:
            User user = userManager.getUser(userID);
            for (int i=0; i<permGroupDef.length; i++) {
                permManager.removeUserPermission(user, permGroupDef[i]);
            }
        }
        else if ("group".equals(removetype)) {
            // Get the user:
            Group group = groupManager.getGroup(groupID);
            for (int i=0; i<permGroupDef.length; i++) {
                permManager.removeGroupPermission(group, permGroupDef[i]);
            }
        }
        response.sendRedirect("perms.jsp?cat=" + categoryID + "&forum=" + forumID
                + "&permGroup=" + permGroup + "&show=perms&updatedPerms=true");
        return;
    }

    if (isError) {
        cancel = true;
    }
%>

<%  // special onload command to load the sidebar
    if (category != null) {
        onload = " onload=\"parent.frames['sidebar'].location.href='sidebar.jsp?sidebar=forum';\"";
    }
    String bookmark = "";
    if (permGroup == ADMIN_GROUP) {
        bookmark = "admin_perm_group";
    }
    else if (permGroup == CONTENT_GROUP) {
        bookmark = "content_perm_group";
    }
%>
<%@ include file="header.jsp" %>

<p>

<%  // Title of this page and breadcrumbs
    String title = null;
    String[][] breadcrumbs = null;
    // Print out different breadcrumbs depending if we're editing
    // category permissions or if we're editing any admin perms.
    if (permGroup == ADMIN_GROUP) {
        title = "Administrators &amp; Moderators";
        if (category != null) {
            breadcrumbs = new String[][] {
                {"Main", "main.jsp"},
                {"Categories & Forums", "forums.jsp?cat=" + categoryID},
                {"Admins &amp; Moderators", "perms.jsp?cat="+categoryID+"&forum=" + forumID + "&permGroup="+permGroup+"&show="+show}
            };
        }
        else {
            breadcrumbs = new String[][] {
                {"Main", "main.jsp"},
                {"Admins &amp; Moderators", "perms.jsp?forum=" + forumID + "&permGroup="+permGroup+"&show="+show}
            };
        }
    }
    else if (permGroup == CONTENT_GROUP) {
        if (category == null && forum == null) {
            title = "Global Permissions";
            breadcrumbs = new String[][] {
                {"Main", "main.jsp"},
                {title, "perms.jsp?permGroup="+permGroup+"&show="+show}
            };
        }
        else if (category != null && forum == null) {
            title = "Category Permissions";
            breadcrumbs = new String[][] {
                {"Main", "main.jsp"},
                {"Categories & Forums", "forums.jsp?cat=" + categoryID},
                {title, "perms.jsp?cat="+categoryID+"&permGroup="+permGroup+"&show="+show}
            };
        }
        else {
            title = "Forum Permissions";
            breadcrumbs = new String[][] {
                {"Main", "main.jsp"},
                {"Categories & Forums", "forums.jsp?cat=" + forum.getForumCategory().getID()},
                {title, "perms.jsp?forum="+forumID+"&permGroup="+permGroup+"&show="+show}
            };
        }
    }
%>
<%@ include file="title.jsp" %>

<%  if (permGroup == ADMIN_GROUP) { %>

    <%  if (category != null) { %>

        <a href="forums.jsp?cat=<%= category.getID() %>"
         ><b>Category List</b></a> <b>&raquo;</b> <b><%= category.getName() %></b>

        <p>

        Grant category administrator privileges to users or groups for this category.
        Permissions are always additive, such that the final permissions for a category
        will be global permissions, plus category and forum specific permissions.

    <%  } else if (forum != null) { %>

        <a href="forums.jsp?cat=<%= forum.getForumCategory().getID() %>"
         ><b>Category List</b></a> <b>&raquo;</b> <b><%= forum.getName() %></b>

        <p>

        Grant forum administrator privileges to users or groups for this forum.
        Permissions are always additive, such that the final permissions for a forum
        will be global permissions, plus parent category permissions, plus forum
        specific permissions.

    <%  } else { // global %>

        Grant global category admin or system admin privileges to users or groups.
        Note, this sets permission for admins over all categories. To designate
        administrators for individual categories, click on the "Content" tab,
        choose a category then choose "Admins/Moderators" from the left menu.

        Permissions are always additive, such that the final permissions for a category
        will be global permissions, plus category and forum specific permissions.

    <%  } %>

<%  } else if (permGroup == CONTENT_GROUP) {
        if (category != null) { %>

        <a href="forums.jsp?cat=<%= category.getID() %>"
         ><b>Category List</b></a> <b>&raquo;</b> <b><%= category.getName() %></b>

        <p>

        Edit category permissions to set the permissions policies that the category will use.

    <%  } else if (forum != null) { %>

        <a href="forums.jsp?cat=<%= forum.getForumCategory().getID() %>"
         ><b>Category List</b></a> <b>&raquo;</b> <b><%= forum.getName() %></b>

        <p>

        Edit forum permissions to set the permissions policies that the forum will use.

    <%  } else { %>

        Permissions are always additive, such that the final permissions for a
        category will be global permissions, plus category and forum
        specific permissions.

    <%  }
    } %>

    For more information about permissions, please read the administrator guide distributed
    with this product or click the help icon below.

<p>

<%  if (isError) { %>

    <font color="red">An error occurred when attempting the requested action.<br><br>
    <%= getOneTimeMessage(session, "message") %></font>
    <br><br>

<%  } %>

<%  String message = getOneTimeMessage(session, "message");
    if (message != null) {
%>
	<font size="-1" color="#339900"><b><i><%= message %></i></b></font>
    <p>
<%	} %>

<script language="JavaScript" type="text/javascript">

// States
var initialState = "";
var rowStates = new Array();

// Setter for the total state
/* public */
function setInitialState(aForm) {
    // Set current state
    initialState = _getCurrentState(aForm);
}

/*
function setInitialRowState(aForm, index, partialName) {
    rowStates[index] = _getCurrentState(aForm, partialName);
}
*/

//
/* public */
function alertButtons(aForm, buttonNames) {
    var buttons = buttonNames.split(",");
    var currentState = _getCurrentState(aForm);
    for (var i=0; i<buttons.length; i++) {
        var button = eval("document." + aForm.name + "." + buttons[i]);
        if (initialState == currentState) {
            button.disabled = true;
        }
        else {
            button.disabled = false;
        }
    }
}

/* public */
/*
function alertImages(aForm, index, partialName, imgName) {
    var currentRowState = _getCurrentState(aForm, partialName);
    if (rowStates[index] == currentRowState) {

    }
}
*/

// Returns the state of all checkboxes as a string of bits
/* private */
function _getCurrentState(aForm) {
    var state = "";
    var elements = aForm.elements;
    for (var i=0; i<elements.length; i++) {
        var element = elements[i];
        if (element.type == 'checkbox') {
            state += ((element.checked) ? "1" : "0");
        }
    }
    return state;
}
</script>

<style type="text/css">
#jive-permlegend TABLE, #jive-permlegend TD {
	border-width : 1px 1px 0px 1px;
    border-color : #ccc;
    border-style : solid;
}
#jive-permlegend TD {
	border-width : 0px 0px 1px 0px;
	padding : 0px 25px 0px 5px;
    font-size : 0.7em;
}
.jive-userlist TH {
    font-size : 0.7em;
    font-weight : normal;
    text-align : center;
    padding : 3px 5px 3px 5px;
}
.jive-permslist .jive-perm-cell, .jive-permslist .jive-perm-cell-admin {
	text-align : center;
}
.jive-permslist .jive-perm-cell-admin {
    background-color : #fcc;
}
.jive-permslist .jive-odd, .jive-permslist .jive-special {
	background-color : #eee;
}
.jive-permslist .jive-first {
	padding : 4px 6px 4px 6px;
}
/* tabs */
.jive-permslist .jive-permtabs .jive-selected-permtab,
.jive-permslist .jive-permtabs .jive-permtab,
.jive-permslist .jive-permtabs .jive-spacertab,
.jive-permslist .jive-permtabs .jive-springtab,
.jive-permslist .jive-userlist TABLE  {
	border-width : 1px 1px 1px 1px;
	border-color : #bbb;
	border-style : solid;
	padding : 3px 8px 3px 8px;
}
.jive-permslist .jive-permtabs .jive-selected-permtab {
	border-width : 1px 1px 0px 1px;
	background-color : #fff;
}
.jive-permslist .jive-permtabs .jive-permtab {
	border-width : 1px 1px 1px 1px;
	background-color : #eee;
}
.jive-permslist .jive-permtabs .jive-spacertab {
	border-width : 0px 0px 1px 0px;
	padding : 2px;
}
.jive-permslist .jive-permtabs .jive-springtab {
	border-width : 0px 0px 1px 0px;
}
.jive-permslist .jive-userlist .jive-perm-box {
	border-width : 0px 1px 1px 1px;
	padding : 0px;
}
.jive-selected-permtab A, .jive-permtab A,
.jive-selected-permtab A:hover, .jive-permtab A:hover,
.jive-selected-permtab A:visited, .jive-permtab A:visited {
	text-decoration : none;
	color : #000;
}
.jive-selected-permtab A:hover, .jive-permtab A:hover {
	text-decoration : underline;
}
.jive-tabtext {
    padding : 0px 2px 5px 2px;
}
.jive-perm-headerrow {
    font-size : 11px;
    font-weight : normal;
    padding : 2px 2px 2px 5px;
    border-bottom : 1px #ddd solid;
    font-weight : bold;
}
.jive-perm-box TABLE {
    border-width : 0px !important;
}
.jive-deletebutton {
    font-size : 11px;
    font-family : tahoma;
}
</style>


<table cellpadding="0" cellspacing="0" border="0">
<%  if ("perms".equals(show)) { %>

    <tr>
        <td>
            <b>Permissions Summary</b>&nbsp;
        </td>
        <td>
            <a href="#" onclick="helpwin('perms','general');return false;"
             title="Click for help"
             ><img src="images/help-16x16.gif" width="16" height="16" border="0" hspace="8"></a>
        </td>
    </tr>

<%  } else if ("new".equals(show)) { %>

    <tr>
        <td>
            <b>Grant New Permissions</b>&nbsp;
        </td>
        <td>
            <a href="#" onclick="helpwin('perms','new');return false;"
             title="Click for help"
             ><img src="images/help-16x16.gif" width="16" height="16" border="0" hspace="8"></a>
        </td>
    </tr>

<%  } %>
</table>

<%  if (userErrors.size() > 0 || groupErrors.size() > 0) { %>

    <p class="jive-error-text">
    Errors adding permission - see below.
    </p>

<%  } else if (updatedPerms) { %>

    <p style="color:#090;">
    Permissions updated successfully.
    </p>

<%  } %>

<br>

<form action="perms.jsp" method="post" name="permform">
<input type="hidden" name="cat" value="<%= categoryID %>">
<input type="hidden" name="forum" value="<%= forumID %>">
<input type="hidden" name="permGroup" value="<%= permGroup %>">
<input type="hidden" name="show" value="<%= show %>">
<input type="hidden" name="add" value="<%= add %>">

<div class="jive-permslist">
<table cellpadding="0" cellspacing="0" border="0" width="100%">

<%-- ===== Tabs Row ===== --%>

<tr>
	<td>
		<div class="jive-permtabs">
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<tr>
			<td class="jive-spacertab" width="1%">&nbsp;</td>
			<td class="jive-<%= (("perms".equals(show)) ? "selected-" : "") %>permtab" width="1%" nowrap>
				<div class="jive-tabtext">
                <a href="perms.jsp?cat=<%= categoryID %>&forum=<%= forumID %>&permGroup=<%= permGroup %>&show=perms"
                 >Permission Summary</a>
                </div>
			</td>
			<td class="jive-spacertab" width="1%">&nbsp;</td>
			<td class="jive-<%= (("new".equals(show)) ? "selected-" : "") %>permtab" width="1%" nowrap>
				<div class="jive-tabtext">
                <a href="perms.jsp?cat=<%= categoryID %>&forum=<%= forumID %>&permGroup=<%= permGroup %>&show=new"
                 >Grant New Permission</a>
                </div>
			</td>
			<td class="jive-springtab" width="97%">&nbsp;</td>
		</tr>
		</table>
		</div>
	</td>
</tr>

<%-- ===== Perm Summary ===== --%>

<%  boolean hadAnyPermsSet = false; %>

<%  if ("perms".equals(show)) { %>

    <tr>
        <td>

            <div class="jive-userlist">
            <table class="jive-perm-box" cellpadding="0" cellspacing="1" border="0" width="100%">
            <tr>
                <th width="39%">&nbsp;</th>

                <%  for (int i=0; i<permGroupDef.length; i++) {
                        String permGroupName = (String)permNames.get(new Long(permGroupDef[i]));
                %>
                    <th bgcolor="#dddddd" width="<%= (60/permGroupDef.length) %>%"><%= permGroupName %></th>

                <%  } %>

                <th width="1%">
                    Remove
                </th>
            </tr>

            <%  if ("perms".equals(show) && permGroup == CONTENT_GROUP) { %>

                <tr>
                    <td colspan="<%= (permGroupDef.length+1) %>">
                        <div class="jive-perm-headerrow">
                        User Types
                        </div>
                    </td>
                    <td>&nbsp;</td>
                </tr>

                <tr class="jive-special">
                    <td class="jive-first">
                        Anyone *
                    </td>
                    <%  hadAnyPermsSet = false;
                        for (int i=0; i<permGroupDef.length; i++) {
                            String cbName = "cb_update_anon_" + permGroupDef[i];
                            boolean hasPerm = permManager.anonymousUserHasPermission(permGroupDef[i]);
                            hadAnyPermsSet |= hasPerm;
                    %>
                        <td class="jive-perm-cell">
                            <input type="hidden" name="was<%= cbName %>" value="<%= permGroupDef[i] %>">
                            <input type="checkbox" name="<%= cbName %>" value="<%= permGroupDef[i] %>"
                             onclick="alertButtons(this.form,'update,cancel');"
                             <%= ((hasPerm) ? "checked" : "") %>>
                        </td>

                    <%  } %>

                    <td width="1%" align="center" bgcolor="#ffffff">
                        <%  if (hadAnyPermsSet) { %>

                            <a href="perms.jsp?remove=true&removetype=anon&cat=<%= categoryID %>&forum=<%= forumID %>&permGroup=<%= permGroup %>"
                             title="Click to clear all permissions for guests."
                             onclick="return confirm('Are you sure you want to remove all permissions for guests?');"
                             ><img src="images/button_delete.gif" width="17" height="17" border="0"></a>

                        <%  } else { %>

                            <img src="images/button_delete_inact.gif" width="17" height="17" border="0"
                             title="No permissons to remove.">

                        <%  } %>
                    </td>
                </tr>
                <tr class="jive-special">
                    <td class="jive-first">
                        Registered Users *
                    </td>
                    <%  hadAnyPermsSet = false;
                        for (int i=0; i<permGroupDef.length; i++) {
                            String cbName = "cb_update_reg_" + permGroupDef[i];
                            boolean hasPerm = permManager.registeredUserHasPermission(permGroupDef[i]);
                            hadAnyPermsSet |= hasPerm;
                    %>
                        <td class="jive-perm-cell">
                            <input type="hidden" name="was<%= cbName %>" value="<%= permGroupDef[i] %>">
                            <input type="checkbox" name="<%= cbName %>" value="<%= permGroupDef[i] %>"
                             onclick="alertButtons(this.form,'update,cancel');"
                             <%= ((hasPerm) ? "checked" : "") %>>
                        </td>

                    <%  } %>

                    <td width="1%" align="center" bgcolor="#ffffff">
                        <%  if (hadAnyPermsSet) { %>

                            <a href="perms.jsp?remove=true&removetype=reg&cat=<%= categoryID %>&forum=<%= forumID %>&permGroup=<%= permGroup %>"
                             title="Click to clear all permissions for all registered users."
                             onclick="return confirm('Are you sure you want to remove all permissions for all registered users?');"
                             ><img src="images/button_delete.gif" width="17" height="17" border="0"></a>

                        <%  } else { %>

                            <img src="images/button_delete_inact.gif" width="17" height="17" border="0"
                             title="No permissons to remove.">

                        <%  } %>
                    </td>
                </tr>
                <tr>
                    <td colspan="<%= (permGroupDef.length+2) %>">&nbsp;</td>
                </tr>

            <%  } %>

            <tr>
                <td colspan="<%= (permGroupDef.length+1) %>">
                    <div class="jive-perm-headerrow">
                    Users
                    </div>
                </td>
                <td>&nbsp;</td>
            </tr>

            <%  // Get the list of users
                SortedMap userPerms = getUserPermMap(permManager, permGroupDef);
                // Only show the list if there are users to show
                if (userPerms.size() == 0) {
            %>
                <tr>
                    <td colspan="<%= (permGroupDef.length+2) %>" style="padding-left:3px;">
                        &nbsp;
                        No user permissions.
                    </td>
                </tr>

            <%
                }
                if (userPerms.size() > 0) {
            %>

                <%  int row = 0;
                    for (Iterator iter=userPerms.keySet().iterator(); iter.hasNext(); ) {
                        User user = (User)iter.next();
                        Permissions perms = (Permissions)userPerms.get(user);
                        boolean userIsSystemAdmin = perms.hasPermission(Permissions.SYSTEM_ADMIN);
                %>

                    <tr class="jive-<%= ((row++%2==0) ? "odd" : "even") %>">
                        <td class="jive-first">
                            <a href="editUser.jsp?user=<%= user.getID() %>"
                             ><%= user.getUsername() %></a>
                        </td>
                        <%  for (int i=0; i<permGroupDef.length; i++) {
                                String cbName = "cb_update_u_" + user.getID() + "_" + permGroupDef[i];
                                boolean isSystemAdminPerm = perms.hasPermission(permGroupDef[i])
                                        && permGroupDef[i] == Permissions.SYSTEM_ADMIN;
                        %>
                            <td class="jive-perm-cell<%= ((isSystemAdminPerm) ? "-admin" : "") %>">
                                <input type="hidden" name="was<%= cbName %>" value="<%= permGroupDef[i] %>">
                                <input type="checkbox" name="<%= cbName %>" value="<%= permGroupDef[i] %>"
                                 <%= ((perms.hasPermission(permGroupDef[i])) ? " checked" : "") %>
                                 onclick="alertButtons(this.form,'update,cancel');">
                            </td>

                        <%  } %>

                        <td align="center" bgcolor="#ffffff">
                            <a href="perms.jsp?remove=true&removetype=user&user=<%= user.getID() %>&cat=<%= categoryID %>&forum=<%= forumID %>&permGroup=<%= permGroup %>"
                             title="Click to remove all permissions for this user."
                             <% if (userIsSystemAdmin) { %>

                                onclick="return confirm('WARNING:\n\nYou are about to remove permissions for a system administrator. Are you sure you want to do this?');"

                             <% } else { %>

                                onclick="return confirm('Are you sure you want to remove all permissions for this user?');"

                             <% } %>
                             ><img src="images/button_delete.gif" width="17" height="17" border="0"></a>
                        </td>
                    </tr>

            <%
                    }
                }
            %>

            <tr>
                <td colspan="<%= (permGroupDef.length+1) %>">
                    <br>
                    <div class="jive-perm-headerrow">
                    Groups
                    </div>
                </td>
                <td>&nbsp;</td>
            </tr>

            <%  // Get the list of users
                SortedMap groupPerms = getGroupPermMap(permManager, permGroupDef);
                // Only show the list if there are users to show
                if (groupPerms.size() == 0) {
            %>

                <tr>
                    <td colspan="<%= (permGroupDef.length+2) %>" style="padding-left:3px;">
                        &nbsp;
                        No group permissions. <br><br>
                    </td>
                </tr>

            <%
                }
                else {
            %>
                <%  int row = 0;
                    for (Iterator iter=groupPerms.keySet().iterator(); iter.hasNext(); ) {
                        Group group = (Group)iter.next();
                        Permissions perms = (Permissions)groupPerms.get(group);
                %>

                    <tr class="jive-<%= ((row++%2==0) ? "odd" : "even") %>">
                        <td class="jive-first">
                            <a href="editGroup.jsp?group=<%= group.getID() %>"
                             ><%= group.getName() %></a>
                            </label>
                        </td>
                        <%  for (int i=0; i<permGroupDef.length; i++) {
                                String cbName = "cb_update_g_" + group.getID() + "_" + permGroupDef[i];
                        %>
                            <td class="jive-perm-cell">
                                <input type="hidden" name="was<%= cbName %>" value="<%= permGroupDef[i] %>">
                                <input type="checkbox" name="<%= cbName %>" value="<%= permGroupDef[i] %>"
                                 <%= ((perms.hasPermission(permGroupDef[i])) ? " checked" : "") %>
                                 onclick="alertButtons(this.form,'update,cancel');">
                            </td>

                        <%  } %>

                        <td align="center" bgcolor="#ffffff">
                            <a href="perms.jsp?remove=true&removetype=group&group=<%= group.getID() %>&cat=<%= categoryID %>&forum=<%= forumID %>&permGroup=<%= permGroup %>"
                             title="Click to remove all permissions for this group."
                             onclick="return confirm('Are you sure you want to remove all permissions for this group?');"
                             ><img src="images/button_delete.gif" width="17" height="17" border="0"></a>
                        </td>
                    </tr>

            <%
                    }
                }
            %>

            <tr>
                <td>&nbsp;
                    
                </td>
                <td colspan="<%= permGroupDef.length %>">
                    <br>
                    <center style="padding:2px 0px 2px 0px;">
                    <input type="submit" name="update" value="Save Changes" disabled>
                    <input type="submit" name="cancel" value="Cancel" disabled>
                    </center>
                </td>
                <td>
                    
                <td>
            </tr>

            </table>
            </div>

        </td>
    </tr>

<%  } else { %>

    <tr>
        <td>

            <script language="JavaScript" type="text/javascript">
            function selectAll(el) {
                var items = el.elements;
                for (var i=0; i<items.length; i++) {
                    if (items[i].type == 'checkbox' && items[i].name == 'newperm') {
                        items[i].checked = true;
                    }
                }
            }
            </script>

            <div class="jive-userlist">
            <table class="jive-perm-box" cellpadding="5" cellspacing="0" border="0" width="100%">
            <tr>
                <td>
                    <p>
                    Follow the steps below to grant new user or group permissions: (Note, it is not
                    possible to set permissions for "Anyone" or "Registered Users" here. To do this,
                    use the Permissions Summary page.)
                    </p>

                    <table cellpadding="2" cellspacing="1" border="0" width="100%">
                    <tr valign="top">
                        <td width="1%" nowrap>
                            <b>1</b>&nbsp;
                        </td>
                        <td width="99%">
                            Choose the permission(s):
                            [<a href="#" onclick="selectAll(document.permform);return false;">select all</a>]
                        </td>
                    </tr>
                    <%   if (noPermSelected) { %>

                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                <span class="jive-error-text">
                                Please choose a permission type.
                                </span>
                            </td>
                        </tr>

                    <%  } %>
                    <tr>
                        <td>&nbsp;</td>
                        <td>
                            <table cellpadding="3" cellspacing="0" border="0" width="100%">

                            <%  for (int i=0; i<permGroupDef.length; i++) {
                                    String permGroupName = (String)permNames.get(new Long(permGroupDef[i]));
                            %>
                                <tr>
                                    <td width="1%">
                                        <input type="checkbox" name="newperm" value="<%= permGroupDef[i] %>" id="pgn<%= i %>"
                                         <%= ((contains(newPerms, permGroupDef[i])) ? "checked" : "") %>>
                                    </td>
                                    <td width="99%">
                                        <label for="pgn<%= i %>"><%= permGroupName %></label>
                                    </td>
                                </tr>

                            <%  } %>

                            </table>
                        </td>
                    </tr>
                    <tr valign="top">
                        <td width="1%" nowrap>
                            <b>2</b>&nbsp;
                        </td>
                        <td width="99%">
                            Choose a user or group to grant the permission(s) to:
                        </td>
                    </tr>
                    <%   if (noPermTargetSelected) { %>

                        <tr valign="top">
                            <td width="1%">&nbsp;</td>
                            <td width="99%">
                                <span class="jive-error-text">
                                Please apply the specified permission to a user or group.
                                </span>
                            </td>
                        </tr>

                    <%   }%>
                    <tr>
                        <td>&nbsp;</td>
                        <td>
                            <table cellpadding="3" cellspacing="0" border="0" width="100%">
                            <tr>
                                <td width="1%">
                                    <input type="checkbox" name="userlistcb" name="spefuser"
                                     onchange="this.form.userlist.focus();" id="spefusercb"
                                     <%= ((userlist != null) ? "checked" : "") %>>
                                </td>
                                <td width="99%">
                                    <label for="spefusercb">
                                    A Specific User: (enter username - separate multiple usernames
                                    with commas)
                                    </label>
                                </td>
                            </tr>
                            <%  if (userErrors.size() > 0) {
                                    String errorMsg = "";
                                    String list = "";
                                    String sep = ", ";
                                    for (int i=0; i<userErrors.size(); i++) {
                                        list += (String)userErrors.get(i);
                                        if ((i+1) < userErrors.size()) {
                                            list += sep;
                                        }
                                    }
                                    if (userErrors.size() == 1) {
                                        errorMsg = "The user " + list + " was not found.";
                                    }
                                    else {
                                        errorMsg = "The users " + list + " were not found.";
                                    }
                            %>
                                <tr>
                                    <td width="1%">&nbsp; </td>
                                    <td width="99%">
                                        <span class="jive-error-text">
                                        <%= errorMsg %>
                                        </span>
                                    </td>
                                </tr>

                            <%  } %>
                            <tr>
                                <td width="1%">&nbsp;
                                    
                                </td>
                                <td width="99%">
                                    <input type="text" size="30" name="userlist"
                                     value="<%= ((userlist != null) ? userlist : "") %>"
                                     onclick="this.form.userlistcb.checked=true;"
                                     onblur="if(this.value==''){this.form.userlistcb.checked=false;}else{this.form.userlistcb.checked=true;}">
                                </td>
                            </tr>
                            <tr>
                                <td width="1%">
                                    <input type="checkbox" name="grouplistcb" name="spefgroup"
                                     onchange="this.form.grouplist.focus();" id="spefgroupcb"
                                     <%= ((grouplist != null) ? "checked" : "") %>>
                                </td>
                                <td width="99%">
                                    <label for="spefgroupcb">
                                    A Specific Group: (enter group name - separate multiple
                                    group names with commas)
                                    </label>
                                </td>
                            </tr>
                            <%  if (groupErrors.size() > 0) {
                                    String errorMsg = "";
                                    String list = "";
                                    String sep = ", ";
                                    for (int i=0; i<groupErrors.size(); i++) {
                                        list += (String)groupErrors.get(i);
                                        if ((i+1) < groupErrors.size()) {
                                            list += sep;
                                        }
                                    }
                                    if (groupErrors.size() == 1) {
                                        errorMsg = "The group " + list + " was not found.";
                                    }
                                    else {
                                        errorMsg = "The groups " + list + " were not found.";
                                    }
                            %>
                                <tr>
                                    <td width="1%">&nbsp; </td>
                                    <td width="99%">
                                        <span class="jive-error-text">
                                        <%= errorMsg %>
                                        </span>
                                    </td>
                                </tr>

                            <%  } %>
                            <tr>
                                <td width="1%">&nbsp;
                                    
                                </td>
                                <td width="99%">
                                    <input type="text" size="30" name="grouplist"
                                     value="<%= ((grouplist != null) ? grouplist : "") %>"
                                     onclick="this.form.grouplistcb.checked=true;"
                                     onblur="if(this.value==''){this.form.grouplistcb.checked=false;}else{this.form.grouplistcb.checked=true;}">
                                </td>
                            </tr>
                            </table>
                        </td>
                    </tr>
                    <tr valign="top">
                        <td width="1%" rowspan="2" nowrap>
                            <b>3</b>&nbsp;
                        </td>
                        <td width="99%">
                            Done:
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="submit" name="doAdd" value="Grant New Permission">
                            <input type="submit" name="cancel" value="Cancel">
                        </td>
                    </tr>
                    </table>

                </td>
            </tr>
            </table>
            </div>

        </td>
    </tr>

<%  } %>

</table>
</div>

<%  if ("perms".equals(show)) { %>

    <br>

    <p><b>Legend</b></p>

    <table cellpadding="3" cellspacing="0" border="0" width="100%">
    <tr>
        <td align="center" width="1%">*</td>
        <td align="center" width="1%">-</td>
        <td width="98%">
            Special permission type - Anyone and Registered Users can not be removed, only
            cleared.
        </td>
    </tr>
    <tr>
        <td width="1%" align="center">
            <table bgcolor="#999999" cellpadding="1" cellspacing="0" border="0">
            <tr>
                <td>
                    <table cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td bgcolor="#ffcccc"><img src="images/blank.gif" width="10" height="10" border="0"></td>
                    </tr>
                    </table>
                </td>
            </tr>
            </table>
        </td>
        <td align="center" width="1%">-</td>
        <td width="98%">
            System admin - do not delete all system admin users. You need at least one to login to
            this tool.
        </td>
    </tr>
    <tr>
        <td align="center" width="1%"><input type="checkbox" name="" value="" onfocus="blur();return false;" onclick="blur();return false;" checked></td>
        <td align="center" width="1%">-</td>
        <td width="98%">
            Indicates a permission is <b>set</b>.
        </td>
    </tr>
    <tr>
        <td align="center" width="1%"><input type="checkbox" name="" value="" onfocus="blur();return false;" onclick="blur();return false;"></td>
        <td align="center" width="1%">-</td>
        <td width="98%">
            Indicates a permission is <b>not set</b>.
        </td>
    </tr>
    </table>
    <br>

<%  } %>

<!-- call the setCBState methods -->
<script language="JavaScript" type="text/javascript">
setInitialState(document.permform);
</script>

</form>

<%@ include file="footer.jsp" %>




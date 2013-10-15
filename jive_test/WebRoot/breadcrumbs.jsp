<%--
  - $RCSfile: breadcrumbs.jsp,v $
  - $Revision: 1.21.2.3 $
  - $Date: 2003/07/25 16:01:05 $
  -
  - Copyright (C) 1999-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software.  Use is subject to license terms.
--%>

<%@ page import="com.jivesoftware.base.*,
                 com.jivesoftware.forum.*,
                 com.jivesoftware.util.*,
                 java.util.ResourceBundle,
                 java.util.MissingResourceException"
%>

<%  // Set the content type
    response.setContentType("text/html; charset=" + JiveGlobals.getCharacterEncoding());

    // Load the resource bundle used for this skin.
    String bundleName = "jive_forums_i18n";
    try {
        ResourceBundle bundle = ResourceBundle.getBundle(bundleName, JiveGlobals.getLocale());
        // Put the bundle in the request as an attribute:
        request.setAttribute("jive.i18n.bundle", bundle);
    }
    catch (MissingResourceException mre) {
        Log.error("Unable to load bundle, basename '" + bundleName + "'");
    }
%>

<%@ taglib uri="jivetags" prefix="jive" %>

<%  // Get parameters
    long categoryID = ParamUtils.getLongParameter(request,"categoryID",-1L);
    long forumID = ParamUtils.getLongParameter(request,"forumID",-1L);
    long threadID = ParamUtils.getLongParameter(request,"threadID",-1L);
    long messageID = ParamUtils.getLongParameter(request,"messageID",-1L);
    long userID = ParamUtils.getLongParameter(request,"userID",-1L);

    // Create an auth token
    AuthToken authToken = null;
    try {
        authToken = AuthFactory.getAuthToken(request,response);
    }
    catch (Exception ignored) {}

    // Get an anonymous (guest) auth token if the other one failed to load.
    if (authToken == null) {
        authToken = AuthFactory.getAnonymousAuthToken();
    }

    // Create a forum factory and blank other forum objects
    ForumFactory forumFactory = ForumFactory.getInstance(authToken);
    ForumCategory category = null;
    Forum forum = null;
    User user = null;

    if (categoryID > 1L) {
        try {
            category = forumFactory.getForumCategory(categoryID);
        }
        catch (Exception ignored) {}
    }
    if (forumID > 0L) {
        try {
            forum = forumFactory.getForum(forumID);
        }
        catch (Exception ignored) {}
    }
    if (userID > 0L) {
        try {
            user = forumFactory.getUserManager().getUser(userID);
        }
        catch (Exception ignored) {}
    }
    if (threadID > 0L) {
        try {
            forum = forumFactory.getForumThread(threadID).getForum();
        }
        catch (Exception ignored) {}
    }
    if (messageID > 0L) {
        try {
            forum = forumFactory.getMessage(messageID).getForumThread().getForum();
        }
        catch (Exception ignored) {}
    }

    // if the category is null, use the one from the forum
    if (category == null && forum != null) {
        if (forum.getForumCategory().getID() != forumFactory.getRootForumCategory().getID()) {
            category = forum.getForumCategory();
        }
    }
%>

<span class="jive-breadcrumbs">
<%  String _homeURL = JiveGlobals.getJiveProperty("skin.default.homeURL");
    if (_homeURL != null && !"".equals(_homeURL)) {
%>

    <%-- Home --%>
    <a href="<%= JiveGlobals.getJiveProperty("skin.default.homeURL") %>"
     ><jive:i18n key="global.home" /></a>
    &raquo;

<%  } %>

<%-- Forum Home --%>

<%  // Determine if we need to use the default community name:
    boolean useDefaultName = "true".equals(JiveGlobals.getJiveProperty("skin.default.useDefaultCommunityName"));
    String communityName = LocaleUtils.getLocalizedString("global.forum_home");
    if (!useDefaultName) {
        communityName = JiveGlobals.getJiveProperty("skin.default.communityName");
        if (communityName == null) {
            communityName = LocaleUtils.getLocalizedString("global.forum_home");
        }
    }
%>

<a href="index.jspa?categoryID=1"><%= communityName %></a>

<%  if (user != null) { %>

    &raquo;
    <a href="profile.jspa?userID=<%= user.getID() %>&start=0"><%= user.getUsername() %></a>

<%  } else { %>

    <%  if (category != null) { %>
        &raquo;
        <a href="category.jspa?categoryID=<%= category.getID() %>"><%= category.getName() %></a>
    <%  } %>

    <%  if (forum != null) { %>
        &raquo;
        <a href="forum.jspa?forumID=<%= forum.getID() %>&start=0"><%= forum.getName() %></a>

<%      }
    }
%>
</span>
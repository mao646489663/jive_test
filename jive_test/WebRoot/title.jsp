<%--
  -
  - $RCSfile: title.jsp,v $
  - $Revision: 1.6.2.1 $
  - $Date: 2003/06/17 04:07:51 $
  -
--%>
<%@ page import="com.jivesoftware.base.*,
                 com.jivesoftware.forum.*,
                 com.jivesoftware.util.*,
                 java.util.*"
%>

<%  // This page creates a "title" variable which can be used as a local variable
    // on the page that statically includes this one. All other variables are
    // prefixed here with a "_" to avoid naming collisions in the including page.
%>

<%  // Get parameters

    long _catID = ParamUtils.getLongParameter(request,"categoryID",-1L);
    long _forumID = ParamUtils.getLongParameter(request,"forumID",-1L);
    long _threadID = ParamUtils.getLongParameter(request,"threadID",-1L);
    long _messageID = ParamUtils.getLongParameter(request,"messageID",-1L);
    long _userID = ParamUtils.getLongParameter(request,"userID",-1L);

    // Get the user's auth token:
    AuthToken _authToken = null;
    ForumFactory _forumFactory = null;
    try {
        _authToken = AuthFactory.getAuthToken(request, response);
    }
    catch (UnauthorizedException ue) {
        _authToken = AuthFactory.getAnonymousAuthToken();
    }
    try {
        _forumFactory = ForumFactory.getInstance(_authToken);
    }
    catch (Exception ignored) {}

    // Load requested objects, but do it carefully:

    ForumCategory _cat = null;
    Forum _forum = null;
    ForumThread _thread = null;
    ForumMessage _message = null;
    User _user = null;

    if (_forumFactory != null) {
        if (_catID != -1L && _catID != _forumFactory.getRootForumCategory().getID()) {
            try {
                _cat = _forumFactory.getForumCategory(_catID);
            }
            catch (ForumCategoryNotFoundException ignored) {}
        }
        if (_forumID != -1L) {
            try {
                _forum = _forumFactory.getForum(_forumID);
            }
            catch (ForumNotFoundException e) {
                Log.error(e);
            }
            catch (UnauthorizedException e) { /* ignore */ }
        }
        if (_forum != null && _threadID != -1L) {
            try {
                _thread = _forum.getThread(_threadID);
            }
            catch (ForumThreadNotFoundException ignored) {}
        }
        if (_thread != null && _messageID != -1L) {
            try {
                _message = _thread.getMessage(_messageID);
            }
            catch (ForumMessageNotFoundException ignored) {}
        }
        if (_userID != -1L) {
            try {
                _user = _forumFactory.getUserManager().getUser(_userID);
            }
            catch (UserNotFoundException ignored) {}
        }
    }

    // Set the title based on what objects were loaded.
    String title = null;

    // Get the name of the forums (if it exists)
    String _communityName = null;
    if ("true".equals(JiveGlobals.getJiveProperty("skin.default.useDefaultCommunityName"))) {
        _communityName = LocaleUtils.getLocalizedString("global.community_forums");
    }
    else {
        _communityName = JiveGlobals.getJiveProperty("skin.default.communityName");
    }
    // Do one more check to make sure it was set - if not, use the localized string again:
    if (_communityName == null) {
        _communityName = LocaleUtils.getLocalizedString("global.community_forums");
    }

    if (_user != null) {
        // User Profile for: {username}
        ArrayList args = new ArrayList(1);
        args.add(_user.getUsername());
        title = LocaleUtils.getLocalizedString("profile.user_profile_for", JiveGlobals.getLocale(), args);
    }
    else {
        // Community Forums: {object name (ie, message subject or forum name)}
        StringBuffer buf = new StringBuffer(_communityName);

        if (_cat != null || _forum != null || _thread != null || _message != null) {
            buf.append(LocaleUtils.getLocalizedString("global.colon")).append(" ");
        }

        if (_message != null) {
            buf.append(_message.getSubject());
        }
        else if (_thread != null) {
            buf.append(_thread.getName());
        }
        else if (_forum != null) {
            buf.append(_forum.getName());
        }
        else if (_cat != null) {
            buf.append(_cat.getName());
        }

        title = buf.toString();
    }
%>
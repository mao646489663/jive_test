<% response.setContentType("text/xml"); %><?xml version="1.0" encoding="<%= JiveGlobals.getCharacterEncoding() %>"?>
<%@ page import="java.util.*,
                 com.jivesoftware.base.*,
                 com.jivesoftware.forum.*,
                 java.text.DateFormat,
                 com.jivesoftware.util.ParamUtils,
                 com.jivesoftware.forum.util.SkinUtils,
                 com.jivesoftware.util.StringUtils"
%>
<%!
    /**
     * RSS feed for a list of forums. For each forum, the following information is available:
     *       name
     *       description
     *       creation date
     *       modification date
     *       thread count
     *       message count
     *
     * If no parameters are passed in, the full list of forums will be returned. Otherwise,
     * comma-delimitted lists of forums or categories should be passed in. For example:
     *
     *      rssforums.jsp?forumIDs=1,2
     *      rssforums.jsp?categoryIDs=1,2
     *      forumIDs=1&categoryIDs=2
     *
     * Also optionally a username and password can be passed in - these credentials will be used
     * when the authToken is created.
     */
%>
<%  // Set the content type
    response.setContentType("text/xml");

    String title = JiveGlobals.getJiveProperty("skin.default.communityName");
    if (title == null || title.equals("")) {
        title = "Jive Forums";
    }
    String link = JiveGlobals.getJiveProperty("mail.jiveURL");

    // Determine if rss feeds are enabled:
    boolean rssFeedsEnabled = "true".equals(JiveGlobals.getJiveProperty("rssFeeds.enabled"));
%>

<%  if (!rssFeedsEnabled) { %>

<rss version="2.0" xmlns:jf="http://www.jivesoftware.com/xmlns/jiveforums/rss">
    <!-- RSS feeds disabled -->
</rss>

<%  } else { %>

<rss version="2.0" xmlns:jf="http://www.jivesoftware.com/xmlns/jiveforums/rss">
  <channel>
    <title><%= StringUtils.escapeForXML(title) %></title>
    <link><%= link %></link>
    <description>List of discussion forums</description>
    <language><%= JiveGlobals.getLocale().getLanguage() %></language>

<%  String username = ParamUtils.getParameter(request,"username");
    String password = ParamUtils.getParameter(request,"password");

    AuthToken authToken = null;
    if (username != null && password != null) {
        try {
            authToken = AuthFactory.getAuthToken(username,password);
        }
        catch (UnauthorizedException ignored) {}
    }
    if (authToken == null) {
        authToken = AuthFactory.getAnonymousAuthToken();
    }
    ForumFactory forumFactory = ForumFactory.getInstance(authToken);
    Forum [] forums = null;
    ArrayList forumList = new ArrayList();
    // Figure out what content should be shown. If no parameters, all forums will be show.
    // If list of forumID's passed in, those forums will be displayed. If list of categoryID's
    // passed in, those will be displayed.
    String forumIDs = request.getParameter("forumIDs");
    if (forumIDs != null) {
        StringTokenizer tokens = new StringTokenizer(forumIDs, ",");
        while(tokens.hasMoreTokens()) {
            try {
                long forumID = Long.parseLong(tokens.nextToken());
                Forum forum = forumFactory.getForum(forumID);
                if (!forumList.contains(forum)) {
                    forumList.add(forum);
                }
            }
            catch (Exception e) { }
        }
    }

    String categoryIDs = request.getParameter("categoryIDs");
    if (categoryIDs != null) {
        StringTokenizer tokens = new StringTokenizer(categoryIDs, ",");
        while(tokens.hasMoreTokens()) {
            try {
                long categoryID = Long.parseLong(tokens.nextToken());
                ForumCategory category = forumFactory.getForumCategory(categoryID);
                Iterator iter = category.getRecursiveForums();
                while (iter.hasNext()) {
                    Forum forum = (Forum)iter.next();
                    if (!forumList.contains(forum)) {
                        forumList.add(forum);
                    }
                }
            }
            catch (Exception e) { }
        }
    }

    // No forums or categories specified.
    if (forumIDs == null && categoryIDs == null) {
        Iterator iter = forumFactory.getRootForumCategory().getRecursiveForums();
        while (iter.hasNext()) {
            forumList.add(iter.next());
        }
    }
    forums = (Forum[])forumList.toArray(new Forum[forumList.size()]);

    // Date formatter for dates:
    DateFormat formatter = DateFormat.getDateTimeInstance(DateFormat.MEDIUM, DateFormat.SHORT);

    for (int i=0; i<forums.length; i++) {
        Forum forum = forums[i];
%>
    <item>
      <title><%= StringUtils.escapeForXML(forum.getName()) %></title>
      <%
        String forumLink = link;
        if (!forumLink.endsWith("/")) {
            forumLink += "/";
        }
        forumLink += "forum.jspa?forumID=" + forum.getID();
      %>
      <link><%= forumLink %></link>
      <description><%= StringUtils.escapeForXML(forum.getDescription()) %></description>
      <jf:creationDate><%= formatter.format(forum.getCreationDate()) %></jf:creationDate>
      <jf:modificationDate><%= formatter.format(forum.getModificationDate()) %></jf:modificationDate>
      <jf:threadCount><%= forum.getThreadCount() %></jf:threadCount>
      <jf:messageCount><%= forum.getMessageCount() %></jf:messageCount>
      <jf:dateToText><%= SkinUtils.dateToText(request, null, forum.getModificationDate()) %></jf:dateToText>
    </item>
  <%  } %>
  </channel>
</rss>

<%  } %>
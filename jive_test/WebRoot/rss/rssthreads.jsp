<% response.setContentType("text/xml"); %><?xml version="1.0" encoding="<%= JiveGlobals.getCharacterEncoding() %>"?>
<%@ page import="java.util.*,
                 com.jivesoftware.base.*,
                 com.jivesoftware.forum.*,
                 com.jivesoftware.util.ParamUtils,
                 com.jivesoftware.util.StringUtils,
                 java.text.BreakIterator"
%>
<%!
    /**
     * RSS feed for a list of threads in a forum (in modification date order). For each thread,
     * the following information is available:
     *       name (subject)
     *       author
     *       creation date
     *       modification date
     *       message count
     *       message body (if "full=true" is passed in)
     *
     * The forumID must always be passed-in. Optionally, the number of threads can be specified
     * (default is 10). For example:
     *
     *      rssthreads.jsp?forumID=1
     *      rssthreads.jsp?forumID=5&threadCount=25
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
    <description>List of forum topics</description>
    <language><%= JiveGlobals.getLocale().getLanguage() %></language>

<%
    String username = ParamUtils.getParameter(request,"username");
    String password = ParamUtils.getParameter(request,"password");
    boolean full = ParamUtils.getBooleanParameter(request,"full");

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
    Forum forum = null;
    int count = 10;
    try {
        String forumID = request.getParameter("forumID");
        forum = forumFactory.getForum(Long.parseLong(forumID));
        count = Integer.parseInt(request.getParameter("threadCount"));
    }
    catch (Exception e) { }

    if (forum != null) {
        ResultFilter filter = ResultFilter.createDefaultThreadFilter();
        filter.setNumResults(count);
        Iterator threads = forum.getThreads(filter);
        while (threads.hasNext()) {
            ForumThread thread = (ForumThread)threads.next();
%>
    <item>
        <title><%= StringUtils.escapeForXML(thread.getName()) %></title>
        <%
            String threadLink = link;
            if (!threadLink.endsWith("/")) {
                threadLink += "/";
            }
            threadLink += "thread.jspa?threadID=" + thread.getID();
            String author = "";
            ForumMessage rootMsg = thread.getRootMessage();
            if (rootMsg.isAnonymous()) {
                String name = rootMsg.getProperty("name");
                if (name != null) {
                    author = name;
                }
            }
            else {
                author = rootMsg.getUser().getUsername();
            }
        %>
        <link><%= threadLink %></link>
        <description><![CDATA[<%= StringUtils.chopAtWord(rootMsg.getBody(), 100) %>]]></description>
        <jf:creationDate><%= JiveGlobals.formatDateTime(thread.getCreationDate()) %></jf:creationDate>
        <jf:modificationDate><%= JiveGlobals.formatDateTime(thread.getModificationDate()) %></jf:modificationDate>
        <jf:messageCount><%= thread.getMessageCount() %></jf:messageCount>
        <jf:author><%= author %></jf:author>
        <jf:replyCount><%= (thread.getMessageCount()-1) %></jf:replyCount>
        <%  if (full) { %>
            <jf:body><![CDATA[<%= rootMsg.getBody() %>]]></jf:body>
        <%  } %>
    </item>
  <%    }
    }
  %>
  </channel>
</rss>

<%  } %>
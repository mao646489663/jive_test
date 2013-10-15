<%--
  - $RCSfile: postform-success.jsp,v $
  - $Revision: 1.14 $
  - $Date: 2003/05/14 16:31:16 $
  -
  - Copyright (C) 2002-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software. Use is subject to license terms.
--%>

<%@ taglib uri="webwork" prefix="ww" %>
<%@ taglib uri="jivetags" prefix="jive" %>

<%@ include file="global.jsp" %>

<jsp:include page="header.jsp" flush="true" />

<div style="width:960px; margin:0px auto;">

<script language="JavaScript" type="text/javascript" src="utils.js"></script>

<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr valign="top">
    <td width="98%">

        <%-- Breadcrumbs (customizable via the admin tool) --%>

        <jsp:include page="breadcrumbs.jsp" flush="true" />

        <%-- Page title --%>

        <p class="jive-page-title">
        <ww:if test="reply == true">

            <%-- Post Message: Reply --%>
            <jive:i18n key="post.title_reply" />

        </ww:if>
        <ww:else>

            <%-- Post Message: New Topic --%>
            <jive:i18n key="post.title_new" />

        </ww:else>
        </p>

    </td>
    <td width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>
    <td width="1%">

        <%@ include file="accountbox.jsp" %>

    </td>
</tr>
</table>

<br>

<ww:if test="threadModerationOn(forum) == true && reply != true">

    <%--
        Your message has been placed in a moderation queue and will be posted
        when it is approved by a moderator.
    --%>
    <jive:i18n key="post.new_moderate" />

</ww:if>
<ww:elseIf test="messageModerationOn(forum) == true && reply == true">

    <%--
        Your message has been placed in a moderation queue and will be posted
        when it is approved by a moderator.
    --%>
    <jive:i18n key="post.new_moderate" />

</ww:elseIf>
<ww:elseIf test="newMessageIsModerated == true">

    <%--
        Your message has been placed in a moderation queue and will be posted
        when it is approved by a moderator.
    --%>
    <jive:i18n key="post.new_moderate" />

</ww:elseIf>
<ww:else>

    <%-- Your message was posted successfully. --%>
    <jive:i18n key="post.success" />

</ww:else>

<ul>
    <ww:if test="reply == true">

        <ww:if test="messageModerationOn(forum) == true">

            <ww:if test="newMessageIsModerated == false">

                <li><%-- Go to: the topic you posted in --%>
                    <jive:i18n key="global.go_to" /><jive:i18n key="global.colon" />
                    <a href="thread.jspa?threadID=<ww:property value="thread/ID" />"
                     ><jive:i18n key="global.the_topic_you_posted_in" /></a>
                </li>

            </ww:if>

            <li><%-- Go to: the main forum page --%>
                <jive:i18n key="global.go_to" /><jive:i18n key="global.colon" />
                <a href="index.jspa"><jive:i18n key="global.the_main_forums_page" /></a>
            </li>

        </ww:if>
        <ww:else>

            <ww:if test="newMessageIsModerated == false">

                <li><%-- Go to: the message you created --%>
                    <jive:i18n key="global.go_to" /><jive:i18n key="global.colon" />
                    <a href="thread.jspa?threadID=<ww:property value="thread/ID" />&messageID=<ww:property value="newMessage/ID" />#<ww:property value="newMessage/ID" />"
                     ><jive:i18n key="global.the_message_you_created" /></a>
                </li>

            </ww:if>

            <li><%-- Go to: the forum you posted in --%>
                <jive:i18n key="global.go_to" /><jive:i18n key="global.colon" />
                <a href="forum.jspa?forumID=<ww:property value="$forumID" />&start=0"
                ><jive:i18n key="global.the_forum_you_posted_in" /></a>
            </li>

        </ww:else>

    </ww:if>
    <ww:else>

        <ww:if test="threadModerationOn(forum) == true">

            <li><%-- Go to: the forum you posted in --%>
                <jive:i18n key="global.go_to" /><jive:i18n key="global.colon" />
                <a href="forum.jspa?forumID=<ww:property value="$forumID" />&start=0"
                ><jive:i18n key="global.the_forum_you_posted_in" /></a>
            </li>

            <li><%-- Go to: the main forum page --%>
                <jive:i18n key="global.go_to" /><jive:i18n key="global.colon" />
                <a href="index.jspa"><jive:i18n key="global.the_main_forums_page" /></a>
            </li>

        </ww:if>
        <ww:else>

            <ww:if test="newMessageIsModerated == false">

                <li><%-- go to: the topic you just created --%>
                    <jive:i18n key="global.go_to" /><jive:i18n key="global.colon" />
                    <a href="thread.jspa?threadID=<ww:property value="thread/ID" />"
                     ><jive:i18n key="global.the_topic_you_created" /></a>
                </li>

            </ww:if>

            <li><%-- Go to: the forum you posted in --%>
                <jive:i18n key="global.go_to" /><jive:i18n key="global.colon" />
                <a href="forum.jspa?forumID=<ww:property value="$forumID" />&start=0"
                ><jive:i18n key="global.the_forum_you_posted_in" /></a>
            </li>

        </ww:else>

    </ww:else>

</ul>

</div>

<jsp:include page="footer.jsp" flush="true" />

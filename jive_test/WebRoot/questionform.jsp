<%--
  -
  - $RCSfile: questionform.jsp,v $
  - $Revision: 1.5 $
  - $Date: 2003/05/26 15:36:35 $
  -
--%>

<%@ page import="com.jivesoftware.forum.action.QuestionAction,
                 com.jivesoftware.forum.ForumThread" %>

<%@ include file="global.jsp" %>

<%@ taglib uri="webwork" prefix="ww" %>
<%@ taglib uri="jivetags" prefix="jive" %>

<%  // Get the action associated with this view:
    QuestionAction action = (QuestionAction)getAction(request);
    // The thread in question
    ForumThread thread = action.getThread();
%>

<jsp:include page="header.jsp" flush="true" />

<div style="width:960px; margin:0px auto;">

<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr valign="top">
    <td width="98%">

        <%-- Breadcrumbs (customizable via the admin tool) --%>

        <jsp:include page="breadcrumbs.jsp" flush="true" />

        <%-- Forum name and brief info about the forum --%>

        <p>
        <span class="jive-page-title">
        <%-- Topic Marked as Question --%>
        <jive:i18n key="question.topic_marked_as_question" />
        </span>

    </td>
    <td width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>
    <td width="1%">

        <%@ include file="accountbox.jsp" %>

    </td>
</tr>
</table>

<%  if (QuestionAction.ASSUMED_ANSWERED.equals(action.getResolution())) { %>

    <p>
    <%--
    If you feel the topic author's question was answered (but for some reason
    they didn't indicate so) you can mark this topic as "assumed answered".
    Use the form below to this and return to the topic.
    --%>
    <jive:i18n key="question.assumed_answered_explanation" />
    </p>

    <form action="question!execute.jspa">

    <input type="hidden" name="threadID" value="<%= thread.getID() %>">
    <input type="hidden" name="resolution" value="<%= QuestionAction.ASSUMED_ANSWERED %>">

    <%-- Mark as Assumed Answered --%>
    <input type="submit" name="" value="<jive:i18n key="question.mark_as_assumed_answered" />">
    <%-- Cancel --%>
    <input type="submit" name="doCancel" value="<jive:i18n key="global.cancel" />">

    </form>

<%  } else { %>

    <p>
    <%--
    Use the form below to indicate if your question was answered or remains
    unanswered. To go back to the topic, just click "Cancel".
    --%>
    <jive:i18n key="question.use_form_to_mark" />
    </p>

    <form action="question!execute.jspa">

    <input type="hidden" name="threadID" value="<%= thread.getID() %>">

    <p>
    <%--
    Has your question been answered in the topic: "<%= thread.getName() %>"?
    --%>
    <jive:i18n key="question.has_your_question_been_answered_in_topic">
        <jive:arg>
            <%= thread.getName() %>
        </jive:arg>
    </jive:i18n>
    </p>

    <table cellpadding="3" cellspacing="0" border="0">
    <tr>
        <td>
            <input type="radio" name="resolution" value="<%= QuestionAction.ANSWERED %>" id="r01"
             <%= ((QuestionAction.ANSWERED.equals(action.getResolution())) ? "checked" : "") %>>
        </td>
        <td>
            <%-- Yes, my question has been answered --%>
            <label for="r01"><jive:i18n key="question.yes_has_been_answered" /></label>
        </td>
    </tr>
    <tr>
        <td>
            <input type="radio" name="resolution" value="<%= QuestionAction.UNANSWERED %>" id="r02"
             <%= ((QuestionAction.UNANSWERED.equals(action.getResolution())) ? "checked" : "") %>>
        </td>
        <td>
            <%-- No, my question has not been answered yet. --%>
            <label for="r02"><jive:i18n key="question.no_has_not_been_answered" /></label>
        </td>
    </tr>
    </table>

    <br>

    <%-- Update and Return --%>
    <input type="submit" name="" value="<jive:i18n key="global.update_and_return" />">
    <%-- Cancel --%>
    <input type="submit" name="doCancel" value="<jive:i18n key="global.cancel" />">

    </form>

<%  } %>

</div>

<jsp:include page="footer.jsp" flush="true" />
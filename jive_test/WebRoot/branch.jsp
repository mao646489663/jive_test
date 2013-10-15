<%--
  - $RCSfile: branch.jsp,v $
  - $Revision: 1.10.2.1 $
  - $Date: 2003/06/06 18:57:31 $
  -
  - Copyright (C) 1999-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software.  Use is subject to license terms.
--%>

<%@ include file="global.jsp" %>

<%@ taglib uri="webwork" prefix="ww" %>
<%@ taglib uri="jivetags" prefix="jive" %>

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
        <%-- Branch Message --%>
        <jive:i18n key="branch.title" />
        </span>
        </p>

        <%-- Branching messages into a new topic allows you to... --%>
        <jive:i18n key="branch.description" />

    </td>
    <td width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>
    <td width="1%">

        <%@ include file="accountbox.jsp" %>

    </td>
</tr>
</table>

<br>

<form action="branch!execute.jspa" name="branchform" method="post">
<input type="hidden" name="messageID" value="<ww:property value="messageID" />">

<div class="jive-branch-table">

<table cellpadding="3" cellspacing="0" border="0" width="100%">
<tr>
    <td width="1%" nowrap align="right">
        <%-- Subject: --%>
        <jive:i18n key="global.subject" /><jive:i18n key="global.colon" />
    </td>
    <td width="99%">
        <input type="text" name="subject" size="50" maxlength="150"
         value="<ww:if test="subject"><ww:property value="subject" /></ww:if><ww:else><ww:property value="message/unfilteredSubject" /></ww:else>">
    </td>
</tr>
<tr>
    <td width="1%" align="right">
        <%-- Message: --%>
        <jive:i18n key="global.message" /><jive:i18n key="global.colon" />
    </td>
    <td width="99%" style="border: 1px #ccc solid;">
        <ww:property value="message/body" />
    </td>
</tr>
</table>

</div>

<br><br>

<%-- Branch to New Topic --%>
<input type="submit" name="doBranch" value="<jive:i18n key="branch.branch_to_new_topic" />">

<%-- Cancel --%>
<input type="submit" name="doCancel" value="<jive:i18n key="global.cancel" />">

</form>

<script language="JavaScript" type="text/javascript">
<!--
document.branchform.doBranch.focus();
//-->
</script>
</div>
<jsp:include page="footer.jsp" flush="true" />
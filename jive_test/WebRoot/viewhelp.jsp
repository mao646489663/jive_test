<%--
  -
  - $RCSfile: viewhelp.jsp,v $
  - $Revision: 1.9 $
  - $Date: 2003/05/27 21:20:31 $
  -
--%>

<%@ include file="global.jsp" %>

<%@ taglib uri="webwork" prefix="ww" %>
<%@ taglib uri="jivetags" prefix="jive" %>

<%  // Get the file to display. By default, it is "help/help-text.html"
    String file = request.getParameter("file");
    if (file == null) {
        file = "help/help-text.html";
    }
%>

<jsp:include page="header.jsp" flush="true" />
<div style="width:960px; margin:0px auto;">
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr valign="top">
    <td width="98%">

        <%-- Breadcrumbs (customizable via the admin tool) --%>

        <jsp:include page="breadcrumbs.jsp" flush="true" />

        <%-- Forum name and brief info about the forum --%>

        <p class="jive-page-title">
        <%-- Help --%>
        <jive:i18n key="global.help" />
        </p>

        <%@ include file="back-link.jsp" %>

    </td>
    <td width="1%"><img src="images/blank.gif" width="10" height="1" border="0"></td>
    <td width="1%">

        <%@ include file="accountbox.jsp" %>

    </td>
</tr>
</table>

<br>

<jsp:include page="<%= file %>" flush="true" />

<br><br>
</div>
<jsp:include page="footer.jsp" flush="true" />
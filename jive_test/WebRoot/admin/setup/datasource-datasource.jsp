<%
/**
 * $RCSfile: datasource-datasource.jsp,v $
 * $Revision: 1.6 $
 * $Date: 2003/01/23 06:48:50 $
 *
 * Copyright (C) 1999-2002 Jive Software. All rights reserved.
 *
 * This software is the proprietary information of Jive Software. Use is subject to license terms.
 */
%>

<%@ page import="com.jivesoftware.forum.Version,
                 com.jivesoftware.forum.action.setup.DatasourceSetupAction,
                 javax.naming.NamingEnumeration,
                 javax.naming.InitialContext,
                 javax.naming.Context,
                 javax.naming.Binding"%>

<%@ taglib uri="webwork" prefix="ww" %>

<%@ include file="global.jsp" %>

<%@ include file="header.jsp" %>

<p class="jive-setup-page-header">
Datasource Settings
</p>

<p>
Choose a JNDI datasource below to connect to the Jive Forums database.
The name varies between application servers, but it is generally of the form:
<tt>java:comp/env/jdbc/[DataSourceName]</tt>. Please consult your application server's
documentation for more information.
</p>

<ww:if test="hasErrorMessages == true">

    <p class="jive-error-text">
    <ww:iterator value="errorMessages">
        <ww:property />
    </ww:iterator>
    </p>

</ww:if>

<form action="setup.datasource!jndi.jspa" name="jndiform">
<input type="hidden" name="mode" value="datasource">

<%  boolean isLookupNames = false;
    Context context = null;
    NamingEnumeration ne = null;
    try {
        context = new InitialContext();
        ne = context.listBindings("java:comp/env/jdbc");
        isLookupNames = ne.hasMore();
    }
    catch (Exception e) {}
%>

<%  if (!isLookupNames) { %>

    JNDI Datasource Name:
    <input type="text" name="jndiName" size="30" maxlength="100"
     value="<ww:if test="jndiName"><ww:property value="jndiName" /></ww:if>">

<%  } else { %>

<table cellpadding="3" cellspacing="3" border="0">
<tr>
    <td><input type="radio" name="jndiNameMode" value="custom"></td>
    <td>
        <span onclick="document.jndiform.jndiName.focus();"
        >Custom:</span>
        &nbsp;
        <input type="text" name="jndiName" size="30" maxlength="100"
         value="<ww:if test="jndiName"><ww:property value="jndiName" /></ww:if>"
         onfocus="this.form.jndiNameMode[0].checked=true;">
    </td>
</tr>
    <%  int i = 0;
        while (ne != null && ne.hasMore()) {
            i++;
            Binding binding = (Binding)ne.next();
            String name = "java:comp/env/jdbc/" + binding.getName();
            String display = "java:comp/env/jdbc/<b>" + binding.getName() + "</b>";
    %>
        <tr>
            <td><input type="radio" name="jndiNameMode" value="<%= name %>" id="rb<%= i %>"></td>
            <td>
                <label for="rb<%= i %>" style="font-weight:normal"
                 ><%= display %></label>
            </td>
        </tr>

    <%  } %>
</table>

<%  } %>

<br><br>

<hr size="0">

<div align="right">
    <input type="submit" value=" Continue ">
    <br>
    Note, it might take between 30-60 seconds to connect to your database.
</div>

</form>

<script language="JavaScript" type="text/javascript">
<!--
document.jndiform.jndiName.focus();
//-->
</script>

<%@ include file="footer.jsp" %>
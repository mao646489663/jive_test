<%
/**
 * $RCSfile: datasource-thirdparty.jsp,v $
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
                 java.util.*"%>

<%@ taglib uri="webwork" prefix="ww" %>

<%@ include file="global.jsp" %>

<%@ include file="header.jsp" %>

<p class="jive-setup-page-header">
Standard Database Connection
</p>

<p>
Specify a JDBC driver and connection properties to connect to your database. If you need more
information about this process please see the database documentation distributed with Jive Forums.
</p>

<ww:if test="hasErrorMessages == true">

    <span class="jive-error-text">
    Error:
    <ul>
        <ww:iterator value="errorMessages">
        <li><ww:property />
        </ww:iterator>
    </ul>
    </span>

</ww:if>

<%  // DB preset data
    List presets = new ArrayList();
    presets.add(new String[]{"MySQL","com.mysql.jdbc.Driver","jdbc:mysql://[host-name]:3306/[database-name]"});
    presets.add(new String[]{"Oracle","oracle.jdbc.driver.OracleDriver","jdbc:oracle:thin:@[host-name]:1521:[SID]"});
    presets.add(new String[]{"MSSQL","com.microsoft.jdbc.sqlserver.SQLServerDriver","jdbc:microsoft:sqlserver://[host-name]:1433"});
    presets.add(new String[]{"PostgreSQL","org.postgresql.Driver","jdbc:postgresql://[host-name]:5432/[database-name]"});
    presets.add(new String[]{"IBM DB2","COM.ibm.db2.jdbc.app.DB2Driver","jdbc:db2:[database-name]"});
%>
<script language="JavaScript" type="text/javascript">
var data = new Array();
<%  for (int i=0; i<presets.size(); i++) {
        String[] data = (String[])presets.get(i);
%>
    data[<%= i %>] = new Array('<%= data[0] %>','<%= data[1] %>','<%= data[2] %>');
<%  } %>
function populate(i) {
    document.dbform.driver.value=data[i][1];
    document.dbform.serverURL.value=data[i][2];
}
var submitted = false;
function checkSubmit() {
    if (!submitted) {
        submitted = true;
        return true;
    }
    return false;
}
</script>

<form action="setup.datasource!driver.jspa" method="post" name="dbform"
 onsubmit="return checkSubmit();">

<table cellpadding="3" cellspacing="2" border="0">
<tr>
    <td colspan="2">
        Database Driver Presets:
        <select size="1" name="presets" onchange="populate(this.options[this.selectedIndex].value)">
            <option value="">Pick Database...
            <%  for (int i=0; i<presets.size(); i++) {
                    String[] data = (String[])presets.get(i);
            %>
                <option value="<%= i %>"> &#149; <%= data[0] %>
            <%  } %>
        </select>
        <br><br>
    </td>
</tr>
<tr valign="top">
    <td class="jive-label">
        JDBC Driver Class:
    </td>
    <td>
        <input type="text" name="driver" size="50" maxlength="150"
         value="<ww:if test="driver"><ww:property value="driver" /></ww:if>">
        <span class="jive-description">
        <br>
        The valid classname of your JDBC driver, ie: com.mydatabase.driver.MyDriver.
        </span>
        <ww:if test="errors['driver']">
            <span class="jive-error-text">
            <br><ww:property value="errors['driver']" />
            </span>
        </ww:if>
    </td>
</tr>
<tr><td colspan="2">&nbsp;</td></tr>
<tr valign="top">
    <td class="jive-label">
        Database URL:
    </td>
    <td>
        <input type="text" name="serverURL" size="50" maxlength="250"
         value="<ww:if test="serverURL"><ww:property value="serverURL" /></ww:if>">
        <span class="jive-description">
        <br>
        The valid URL used to connect to your database, ie: jdbc:mysql://host:port/database
        </span>
        <ww:if test="errors['serverURL']">
            <span class="jive-error-text">
            <br><ww:property value="errors['serverURL']" />
            </span>
        </ww:if>
    </td>
</tr>
<tr><td colspan="2">&nbsp;</td></tr>
<tr valign="top">
    <td class="jive-label">
        Username:
    </td>
    <td>
        <input type="text" name="username" size="20" maxlength="50"
         value="<ww:if test="username"><ww:property value="username" /></ww:if>">
        <span class="jive-description">
        <br>
        The user used to connect to your database - note, this may not be required and can be left
        blank.
        </span>
        <ww:if test="errors['username']">
            <span class="jive-error-text">
            <br><ww:property value="errors['username']" />
            </span>
        </ww:if>
    </td>
</tr>
<tr><td colspan="2">&nbsp;</td></tr>
<tr valign="top">
    <td class="jive-label">
        Password:
    </td>
    <td>
        <input type="password" name="password" size="20" maxlength="50"
         value="<ww:if test="password"><ww:property value="password" /></ww:if>">
        <span class="jive-description">
        <br>
        The password for the user account used for this database - note, this may not be required
        and can be left blank.
        </span>
        <ww:if test="errors['password']">
            <span class="jive-error-text">
            <br><ww:property value="errors['password']" />
            </span>
        </ww:if>
    </td>
</tr>
<tr><td colspan="2">&nbsp;</td></tr>
<tr valign="top">
    <td class="jive-label">
        Connections:
    </td>
    <td>
        Minimum: <input type="text" name="minConnections" size="5" maxlength="5"
         value="<ww:if test="minConnections"><ww:property value="minConnections" /></ww:if>">
        &nbsp;
        Maximum: <input type="text" name="maxConnections" size="5" maxlength="5"
         value="<ww:if test="maxConnections"><ww:property value="maxConnections" /></ww:if>">
        <span class="jive-description">
        <br>
        The minimum and maximum number of database connections the connection pool should maintain.
        </span>
        <ww:if test="errors['minConnections']">
            <span class="jive-error-text">
            <br><ww:property value="errors['minConnections']" />
            </span>
        </ww:if>
        <ww:if test="eerrors['maxConnections']">
            <span class="jive-error-text">
            <br><ww:property value="errors['maxConnections']" />
            </span>
        </ww:if>
    </td>
</tr>
<tr><td colspan="2">&nbsp;</td></tr>
<tr valign="top">
    <td class="jive-label">
        Connection Timeout:
    </td>
    <td>
        <input type="text" name="connectionTimeout" size="5" maxlength="5"
         value="<ww:if test="connectionTimeout"><ww:property value="connectionTimeout" /></ww:if>">
        <span class="jive-description">
        <br>
        The time (in days) before connections in the connection pool are recycled.
        </span>
        <ww:if test="errors['connectionTimeout']">
            <span class="jive-error-text">
            <br><ww:property value="errors['connectionTimeout']" />
            </span>
        </ww:if>
    </td>
</tr>
</table>

<br><br>

<hr size="0">

<div align="right">
    <input type="submit" value=" Continue ">
    <br>
    Note, it might take between 30-60 seconds to connect to your database.
</div>

</form>

<%@ include file="footer.jsp" %>
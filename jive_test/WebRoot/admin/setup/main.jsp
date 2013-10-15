<%
/**
 * $RCSfile: main.jsp,v $
 * $Revision: 1.6 $
 * $Date: 2003/01/23 06:48:50 $
 *
 * Copyright (C) 1999-2002 Jive Software. All rights reserved.
 *
 * This software is the proprietary information of Jive Software. Use is subject to license terms.
 */
%>

<%@ page import="com.jivesoftware.forum.Version" %>

<%@ taglib uri="webwork" prefix="ww" %>

<%@ include file="global.jsp" %>

<%@ include file="header.jsp" %>

<p class="jive-setup-page-header">
Installation Checklist
</p>

<p>
Welcome to Jive Forums Setup. This tool will lead you through the initial configuration process
of the application. Before continuing, verify that your environment meets all the requirements
below.
</p>

<ww:if test="hasErrorMessages == true || hasErrors == true">
    <p class="jive-setup-error-text">
    <ww:iterator value="errorMessages">
        <ww:property />
    </ww:iterator>
    </p>
</ww:if>

<table cellpadding="3" cellspacing="2" border="0" width="100%">
<tr>
    <th width="98%">&nbsp;</th>
    <th width="1%" nowrap class="jive-setup-checklist-box">Success</th>
    <th width="1%" nowrap class="jive-setup-checklist-box">Error</th>
</tr>
<tr>
    <td colspan="3" class="jive-setup-category-header">
        JVM &amp; Server-side Java Support
    </td>
</tr>
<tr>
    <td class="jive-setup-category">
        At least JDK 1.3
        <br>
        <span class="jive-info">
        Found: JVM <%= System.getProperty("java.version") %> - <%= System.getProperty("java.vendor") %>
        </span>
    </td>
    <td align="center" class="jive-setup-checklist-box"><img src="images/check.gif" width="13" height="13" border="0"></td>
    <td align="center" class="jive-setup-checklist-box"><img src="images/blank.gif" width="13" height="13" border="0"></td>
</tr>
<tr>
    <td class="jive-setup-category">
        At least Servlet 2.3 API
        <br>
        <span class="jive-info">
        Appserver: <%= application.getServerInfo() %>,
        Supports Servlet 2.3 API and JSP 1.2.
        </span>
    </td>
    <td align="center" class="jive-setup-checklist-box"><img src="images/check.gif" width="13" height="13" border="0"></td>
    <td align="center" class="jive-setup-checklist-box"><img src="images/blank.gif" width="13" height="13" border="0"></td>
</tr>
<tr>
    <td colspan="3" class="jive-setup-category-header">
        Jive Forums <%= Version.getEdition().getName() %> Classes
    </td>
</tr>
<tr>
    <td class="jive-setup-category">
        jiveforums.jar / jivebase.jar
        <br>
        <span class="jive-info">
        Found Jive Forums <%= Version.getEdition() %> <%= Version.getVersionNumber() %>
        </span>
    </td>
    <td align="center" class="jive-setup-checklist-box"><img src="images/check.gif" width="13" height="13" border="0"></td>
    <td align="center" class="jive-setup-checklist-box"><img src="images/blank.gif" width="13" height="13" border="0"></td>
</tr>
<tr>
    <td colspan="3" class="jive-setup-category-header">
        Jive Forums Dependency Classes
    </td>
</tr>
<tr>
    <td class="jive-setup-category">
        <ww:if test="errors('jive_dependency')">

            The following JAR files are missing from your appserver's classpath, or your appserver
            failed to load them, possibly because of a class-loading security exception.

            <ul>

            <ww:iterator value="errors('jive_dependency')">

                &#149; <span class="jive-setup-error-text"><ww:property value="." /></span> <br>

            </ww:iterator>

            </ul>

            Please make sure you've copied all the JARs from the Jive Forums distribution to your
            appserver's classpath or your web application's classpath. Note, you might need to
            restart your appserver before it detects new classes.
            <br>
            <%  if (application.getServerInfo().toLowerCase().indexOf("tomcat") > -1) { %>
                <b>Tomcat Users:</b> Tomcat may be unable to load the specified jar files from your
                web-app. Please upgrade to the 4.0.4 release or later or copy the jars listed above
                to the root "lib" directory: tomcat/common/lib/, restart your appserver and reload
                this page.
            <%  } %>

        </ww:if>
        <ww:else>

            All Jive Forums dependency classes were found and loaded successfully.

        </ww:else>
    </td>
    <ww:if test="errors('jive_dependency')">
        <td align="center" class="jive-setup-checklist-box"><img src="images/blank.gif" width="13" height="13" border="0"></td>
        <td align="center" class="jive-setup-checklist-box"><img src="images/x.gif" width="13" height="13" border="0"></td>
    </ww:if>
    <ww:else>
        <td align="center" class="jive-setup-checklist-box"><img src="images/check.gif" width="13" height="13" border="0"></td>
        <td align="center" class="jive-setup-checklist-box"><img src="images/blank.gif" width="13" height="13" border="0"></td>
    </ww:else>
</tr>
<tr>
    <td colspan="3" class="jive-setup-category-header">
        The jiveHome directory
    </td>
</tr>
<tr>
    <td class="jive-setup-category">
        <ww:if test="errors('jive_config_file') || errors('jive_home')">

            <span class="jive-setup-error-text">
            <ul>

                <ww:iterator value="errors('jive_home')">
                    <li><ww:property value="." /> <br>
                </ww:iterator>
                <ww:iterator value="errors('jive_config_file')">
                    <li><ww:property value="." /> <br>
                </ww:iterator>

            </ul>
            </setup>

        </ww:if>
        <ww:else>

            The jiveHome directory exists and is properly configured.

        </ww:else>
    </td>
    <ww:if test="errors('jive_config_file') || errors('jive_home')">
        <td align="center" class="jive-setup-checklist-box"><img src="images/blank.gif" width="13" height="13" border="0"></td>
        <td align="center" class="jive-setup-checklist-box"><img src="images/x.gif" width="13" height="13" border="0"></td>
    </ww:if>
    <ww:else>
        <td align="center" class="jive-setup-checklist-box"><img src="images/check.gif" width="13" height="13" border="0"></td>
        <td align="center" class="jive-setup-checklist-box"><img src="images/blank.gif" width="13" height="13" border="0"></td>
    </ww:else>
</tr>
<tr>
    <td colspan="3" class="jive-setup-category-header">
        Valid jive.license File
    </td>
</tr>
<tr>
    <td class="jive-setup-category">
        <ww:if test="errors('jive_license_file')">

            Error loading Jive Forums <%= Version.getEdition().getName() %> license file.

            <ul>

            <span class="jive-setup-error-text">
            <ww:iterator value="errors('jive_license_file')">

                <li><ww:property value="." /> <br>

            </ww:iterator>
            </span>

            </ul>

            <p>
            You can enter new license text in the field below and hit save to test the
            license.
            </p>

            <span class="jive-setup-error-text">
            <ww:iterator value="errors('jive_license_text')">
                <li><ww:property /> <br>
            </ww:iterator>
            </span>

            <form action="<ww:url value="setup.index.jspa" />" method="post">
            <textarea name="licenseText" cols="45" rows="8" wrap="virtual"></textarea>
            <br>
            <input type="submit" value="Save License">
            </form>

        </ww:if>
        <ww:else>

            A valid Jive Forums <%= Version.getEdition().getName() %> jive.license file exists.

        </ww:else>
    </td>
    <ww:if test="errors('jive_license_file')">
        <td align="center" class="jive-setup-checklist-box"><img src="images/blank.gif" width="13" height="13" border="0"></td>
        <td align="center" class="jive-setup-checklist-box"><img src="images/x.gif" width="13" height="13" border="0"></td>
    </ww:if>
    <ww:else>
        <td align="center" class="jive-setup-checklist-box"><img src="images/check.gif" width="13" height="13" border="0"></td>
        <td align="center" class="jive-setup-checklist-box"><img src="images/blank.gif" width="13" height="13" border="0"></td>
    </ww:else>
</tr>
</table>

<br><br>

<hr size="0">

<form action="setup.usersystem!default.jspa">
<div align="right">
<ww:if test="hasErrorMessages == true">
    <input type="submit" value=" Continue " disabled onclick="return false;">
</ww:if>
<ww:else>
    <input type="submit" value=" Continue ">
</ww:else>
</div>
</form>

<%@ include file="footer.jsp" %>
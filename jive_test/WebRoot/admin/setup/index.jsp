<%
/**
 * $RCSfile: index.jsp,v $
 * $Revision: 1.5 $
 * $Date: 2003/01/23 06:48:50 $
 *
 * Copyright (C) 1999-2002 Jive Software. All rights reserved.
 *
 * This software is the proprietary information of Jive Software. Use is subject to license terms.
 */
%>

<%@ page import="java.lang.reflect.*,
                 java.io.File" %>

<%@ include file="global.jsp" %>

<%! // Trys to load a class 3 different ways.
    private Class loadClass(String className) throws ClassNotFoundException {
        Class theClass = null;
        try {
            theClass = Class.forName(className);
        }
        catch (ClassNotFoundException e1) {
            try {
                theClass = Thread.currentThread().getContextClassLoader().loadClass(className);
            }
            catch (ClassNotFoundException e2) {
                theClass = getClass().getClassLoader().loadClass(className);
            }
        }
        return theClass;
    }
%>

<%  // Check for required libraries

    boolean jdk13Installed = false;
    boolean servlet23Installed = false;
    boolean jsp11Installed = false;
    boolean jiveJarsInstalled = false;
    boolean jiveHomeExists = false;
    File jiveHome = null;

    // Check for JDK 1.3
    try {
        loadClass("java.util.TimerTask");
        jdk13Installed = true;
    }
    catch (ClassNotFoundException cnfe) {}
    // Check for Servlet 2.3:
    try {
        loadClass("javax.servlet.Filter");
        servlet23Installed = true;
    }
    catch (ClassNotFoundException cnfe) {}
    // Check for JSP 1.1:
    try {
        loadClass("javax.servlet.jsp.tagext.Tag");
        jsp11Installed = true;
    }
    catch (ClassNotFoundException cnfe) {}
    // Check that the Jive 3 jars are installed:
    try {
        loadClass("com.jivesoftware.base.AuthToken");
        loadClass("com.jivesoftware.forum.Forum");
        jiveJarsInstalled = true;
    }
    catch (ClassNotFoundException cnfe) {}

    // Try to determine what the jiveHome directory is:
    try {
        Class jiveGlobalsClass = Thread.currentThread().getContextClassLoader()
                    .loadClass("com.jivesoftware.base.JiveGlobals");
        Method getJiveHomeMethod = jiveGlobalsClass.getMethod("getJiveHome", null);
        String jiveHomeProp = (String)getJiveHomeMethod.invoke(jiveGlobalsClass, null);
        if (jiveHomeProp != null) {
            jiveHome = new File(jiveHomeProp);
            if (jiveHome.exists()) {
                jiveHomeExists = true;
            }
        }
    }
    catch (Exception e) {
        e.printStackTrace();
    }

    // If there were no errors, redirect to the main setup page
    if (jdk13Installed && servlet23Installed && jsp11Installed && jiveJarsInstalled && jiveHomeExists)
    {
        // Compute the correct redirect for the setup tool.
        String servletPath = request.getServletPath();
        servletPath = servletPath.substring(0, servletPath.lastIndexOf("/") + 1);
        String path = request.getContextPath() + servletPath + "setup.index!default.jspa";
        response.sendRedirect(path);
        return;
    }
%>

<html>
<head>
    <title>Jive Forums 3 Setup</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>

<p class="jive-setup-page-header">
Jive Forums 3 Setup
</p>

<p class="jive-setup-error-text">
Error: Can not proceed with Jive Forums setup.
</p>

<p>
Your current installation fails to meet minimum Jive Forums requirements - please see
the checklist below:
</p>

<ul>
<table cellpadding="3" cellspacing="2" border="0">
<%  if (jdk13Installed) { %>

    <tr>
        <td><img src="images/check.gif" width="13" height="13" border="0"></td>
        <td>
            At least JDK 1.3
        </td>
    </tr>

<%  } else { %>

    <tr>
        <td><img src="images/x.gif" width="13" height="13" border="0"></td>
        <td>
            <span class="jive-setup-error-text">
            At least JDK 1.3
            </span>
        </td>
    </tr>

<%  }
    if (servlet23Installed) {
%>
    <tr>
        <td><img src="images/check.gif" width="13" height="13" border="0"></td>
        <td>
            Servlet 2.3 Support
        </td>
    </tr>

<%  } else { %>

    <tr>
        <td><img src="images/x.gif" width="13" height="13" border="0"></td>
        <td>
            <span class="jive-setup-error-text">
            Servlet 2.3 Support
            </span>
        </td>
    </tr>

<%  }
    if (jsp11Installed) {
%>
    <tr>
        <td><img src="images/check.gif" width="13" height="13" border="0"></td>
        <td>
            JSP 1.1 Support
        </td>
    </tr>

<%  } else { %>

    <tr>
        <td><img src="images/x.gif" width="13" height="13" border="0"></td>
        <td>
            <span class="jive-setup-error-text">
            JSP 1.1 Support
            </span>
        </td>
    </tr>

<%  }
    if (jiveJarsInstalled) {
%>
    <tr>
        <td><img src="images/check.gif" width="13" height="13" border="0"></td>
        <td>
            Jive Forums 3 Classes
        </td>
    </tr>

<%  } else { %>

    <tr>
        <td><img src="images/x.gif" width="13" height="13" border="0"></td>
        <td>
            <span class="jive-setup-error-text">
            Jive Forums 3 Classes
            </span>
        </td>
    </tr>

<%  }
    if (jiveHomeExists) {
%>
    <tr>
        <td><img src="images/x.gif" width="13" height="13" border="0"></td>
        <td>
            <span class="jive-setup-error-text">
            Jive Home Directory (<%= jiveHome.toString() %>)
            </span>
        </td>
    </tr>

<%  } else { %>

    <tr>
        <td><img src="images/x.gif" width="13" height="13" border="0"></td>
        <td>
            <span class="jive-setup-error-text">
            Jive Home Directory - Not Set
            </span>
        </td>
    </tr>

<%  } %>
</table>
</ul>

<p>
Please read the installation documentation and try setting up your environment again. After making
changes, restart your appserver and load this page again.
</p>

</body>
</html>
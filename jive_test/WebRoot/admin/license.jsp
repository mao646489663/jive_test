<%
/**
 *	$RCSfile: license.jsp,v $
 *	$Revision: 1.8.4.2 $
 *	$Date: 2003/07/25 03:29:45 $
 */
%>

<%@ page import="java.io.*,
                 java.util.*,
                 com.jivesoftware.forum.*,
                 com.jivesoftware.forum.util.*"
    errorPage="error.jsp"
%>

<%@ include file="global.jsp" %>

<%  // Additional security check - only sys admins should be able to see this page:
    if (!isSystemAdmin) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }
%>

<%@ include file="header.jsp" %>

<%  String jiveEdition = null;
    if (Version.getEdition() == Version.Edition.LITE) {
        jiveEdition = "Jive Forums Lite";
    }
    else if (Version.getEdition() == Version.Edition.PROFESSIONAL) {
        jiveEdition = "Jive Forums Professional";
    }
    else if (Version.getEdition() == Version.Edition.ENTERPRISE) {
        jiveEdition = "Jive Forums Enterprise";
    }
%>

<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr><td>
    <b><%= jiveEdition %> - Admin</b>
    </td>
</tr>
<tr><td>
    <hr size="0" width="100%">
    </td>
</tr>
</table>

<font size="-1">
Below are the details of your Jive Forums license.
<%  if (isSystemAdmin) { %>
It is installed at:
<tt><%= JiveGlobals.getJiveHome() %><%= File.separator %>jive.license</tt>
<%  } %>
</font><p>

<font size="-1"><b>License Details</b>
<ul>
    <font size="-1">
<%  boolean validLicense = false;
    Exception le = null;
    try {
        LicenseManager.validateLicense(jiveEdition, "3.0");
        validLicense = true;
    }
    catch (LicenseException e) {
        le = e;
    }

    LicenseWrapper license = null;
    if (validLicense) {
        // find the correct license
        Iterator licenses = LicenseManager.getLicenses();
        while (licenses.hasNext()) {
            LicenseWrapper wrapper = (LicenseWrapper) licenses.next();
            if (jiveEdition.equals(wrapper.getProduct())) {
                license = wrapper;
                break;
            }
        }
        if (license == null && Version.getEdition() == Version.Edition.LITE) {
            // look for a license for a better product
            licenses = LicenseManager.getLicenses();
            while (licenses.hasNext()) {
                LicenseWrapper wrapper = (LicenseWrapper) licenses.next();
                if ("Jive Forums Professional".equals(wrapper.getProduct())) {
                    license = wrapper;
                    break;
                }
            }

            if (license == null) {
                licenses = LicenseManager.getLicenses();
                while (licenses.hasNext()) {
                    LicenseWrapper wrapper = (LicenseWrapper) licenses.next();
                    if ("Jive Forums Enterprise".equals(wrapper.getProduct())) {
                        license = wrapper;
                        break;
                    }
                }
            }
        }
        else if (license == null && Version.getEdition() == Version.Edition.PROFESSIONAL) {
            licenses = LicenseManager.getLicenses();
            while (licenses.hasNext()) {
                LicenseWrapper wrapper = (LicenseWrapper) licenses.next();
                if ("Jive Forums Enterprise".equals(wrapper.getProduct())) {
                    license = wrapper;
                    break;
                }
            }
        }
        License.LicenseType licenseType = license.getLicenseType();
        boolean isCommercial = (licenseType == License.LicenseType.COMMERCIAL);
        boolean isNonCommercial = (licenseType == License.LicenseType.NON_COMMERCIAL);
        boolean isEvaluation = (!isCommercial && !isNonCommercial);
%>
    <%  if (isCommercial) { %>

    This copy of <%= jiveEdition %> is licensed for commercial deployment.

    <%  } else if (isNonCommercial) { %>

    This copy of <%= jiveEdition %> is licensed for non-commercial deployment. To
    purchase a commercial license, please visit
    <a href="http://www.jivesoftware.com/store/" target="_blank">http://www.jivesoftware.com/store/</a>.

    <%  }
        // is evaluation
        else {  %>

    This is an evaluation copy of <%= jiveEdition %> and is not licensed for deployment.
    Before deploying for commercial or non-commercial use,
    you must obtain a license at
    <a href="http://www.jivesoftware.com/store/" target="_blank">http://www.jivesoftware.com/store/</a>.
    <p>
    <%      Date exprDate = license.getExpiresDate();
            if (exprDate != null) {
                long expires = exprDate.getTime() - System.currentTimeMillis();
                int daysFromNow = (int)Math.ceil((double)(expires/JiveConstants.DAY))+1;
    %>
    <font color="#ff0000">
    This evaluation license expires on
    <%= JiveGlobals.formatDate(exprDate) %>, <%= daysFromNow %> day<%= (daysFromNow==1)?"":"s" %> from now.
    </font>
    <%      } %>

    <%  } %>
    </font>

    <p>
	<table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0">
	<td>
	<table cellpadding="4" cellspacing="1" border="0" width="100%">
    <%  if (!isEvaluation) { %>
    <tr bgcolor="#ffffff">
        <td><font size="-1">License ID:</font></td>
        <td><font size="-1"><%= license.getLicenseID() %></font></td>
    </tr>
    <%  } %>
    <tr bgcolor="#ffffff">
        <td><font size="-1">Product:</font></td>
        <td><font size="-1"><%= license.getProduct() %></font></td>
    </tr>
    <tr bgcolor="#ffffff">
        <td><font size="-1">Version:</font></td>
        <td><font size="-1"><%= license.getVersion() %></font></td>
    </tr>
    <tr bgcolor="#ffffff">
        <td><font size="-1">License Type:</font></td>
        <td><font size="-1"><%= license.getLicenseType() %></font></td>
    </tr>
    <%  if (!isEvaluation) { %>
    <tr bgcolor="#ffffff">
        <td><font size="-1">Copies:</font></td>
        <td><font size="-1"><%= license.getNumCopies() %></font></td>
    </tr>
    <%  } %>
    <tr bgcolor="#ffffff">
        <td><font size="-1">License Created:</font></td>
        <td><font size="-1"><%= SkinUtils.formatDate(request,pageUser,license.getCreationDate()) %></font></td>
    </tr>
<%  if (!isEvaluation) {
        Date exprDate = license.getExpiresDate();
        if (exprDate != null) { %>
    <tr bgcolor="#ffffff">
        <td><font size="-1">License Expires:</font></td>
        <td><font size="-1" color="#ff0000"><%= JiveGlobals.formatDate(exprDate) %></font></td>
    </tr>
<%      } %>
    <tr bgcolor="#ffffff">
        <td><font size="-1">Licensed To:</font></td>
<%      String name = license.getName();
        if (name == null) {
            name = "&nbsp;";
        }
%>      <td><font size="-1"><%= name %></font></td>
    </tr>
<%      String company = license.getCompany();
        if (company != null && "".equals(company)) {
%>
    <tr bgcolor="#ffffff">
        <td><font size="-1">Company/Organization:</font></td>
        <td><font size="-1"><%= company %></font></td>
    </tr>
<%  } %>
    <tr bgcolor="#ffffff">
        <td><font size="-1">URL:</font></td>
<%      String url = license.getURL();
        if (url == null || "".equals(url)) {
            url = "<i>Unspecified or Internal Use</i>";
        }
%>      <td><font size="-1"><%= url %></font></td>
    </tr>
<%  } // end !isEvaluation %>

<%  int clusterMembers = LicenseManager.getNumClusterMembers();
    if (clusterMembers > 0) {
%>
    <tr bgcolor="#ffffff">
        <td><font size="-1">Cluster Members Allowed:</font></td>
        <td><font size="-1"><%= clusterMembers %></font></td>
    </tr>
<%  } %>

    </table>
    </td></tr>
    </table>

<%  } else { %>

<font color="#ff0000">
License not valid: <%= le.getMessage() %>
</font>

<%  } %>

</ul>
</font>

<center>
<form action="main.jsp">
    <input type="submit" value="Go Back">
</form>
</center>

<%@ include file="footer.jsp" %>

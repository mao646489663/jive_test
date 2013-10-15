<%--
  -
  - $RCSfile: prop-viewer.jsp,v $
  - $Revision: 1.1.2.1 $
  - $Date: 2003/07/24 19:03:15 $
  -
--%>

<%@ page import="com.jivesoftware.util.StringUtils,
                 java.io.File"
    errorPage="error.jsp"
%>

<%@ include file="global.jsp" %>

<%  // Only allow system admins to see this page
    if (!isSystemAdmin) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }
%>

<%@ include file="header.jsp" %>

<%  // Title of this page and breadcrumbs
    String title = "System Properties";
    String[][] breadcrumbs = {
        {"Main", "main.jsp"},
        {title, "prop-viewer.jsp"}
    };
%>
<%@ include file="title.jsp" %>

Below is a list of properties in the jive_config.xml file. Values for password sensitive
fields are hidden.

<p>
<tt><b><%= ((new File(JiveGlobals.getJiveHome())).getPath() + File.separator) %>jive_config.xml</b></tt>
</p>

<div class="jive-table">
<table cellpadding="3" cellspacing="2" border="0">

<%  // Get the list of property names
    List propNames = JiveGlobals.getJivePropertyNames();
    // Sort the list
    Collections.sort(propNames, new Comparator() {
        public int compare(Object obj1, Object obj2) {
            return (((String)obj1).toLowerCase()).compareTo(((String)obj2).toLowerCase());
        }
    });
    for (int i=0; i<propNames.size(); i++) {
        String propName = (String)propNames.get(i);
        String propValue = JiveGlobals.getJiveProperty(propName);
%>
    <tr>
        <td class="jive-label">
            <%= propName %>
        </td>
        <td>
            <%  if (propName.endsWith("password") || propName.endsWith("passwd")
                        || propName.equals("password") || propName.equals("passwd"))
                {
            %>
                <span style="color:#999;">
                <i>hidden</i>
                </span>

            <%  } else { %>

                <%  if (propValue == null || "".equals(propValue)) { %>

                    &nbsp;

                <%  } else { %>

                    <%= StringUtils.escapeHTMLTags(propValue) %>

                <%  } %>

            <%  } %>
        </td>
    </tr>

<%  } %>
</table>
</div>

<br><br>

<%@ include file="footer.jsp" %>
<%--
  -
  - $RCSfile: skin.jsp,v $
  - $Revision: 1.21.2.3 $
  - $Date: 2003/07/25 04:19:30 $
  -
  - Copyright (C) 1999-2002 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software.  Use is subject to license terms.
  -
--%>

<%@ page import="java.util.*,
                 com.jivesoftware.forum.*,
                 com.jivesoftware.util.*,
				 com.jivesoftware.forum.util.*"
    errorPage="error.jsp"
%>

<%! // global methods, vars, etc

    // Default properties values. (Maintenance note: this list is duplicated in upgrade.jsp)
    static Map properties = new HashMap();
    static {
        properties.put("fontFace", "tahoma,arial,helvetica,sans-serif");
        properties.put("descrFontFace", "verdana,arial,sans-serif");
        properties.put("fontSize", "0.8em");
        properties.put("descrFontSize", "0.8em");

        properties.put("homeURL", "");
        properties.put("bgColor", "#ffffff");
        properties.put("textColor", "#000000");
        properties.put("linkColor", "#003399");
        properties.put("vLinkColor", "#003399");
        properties.put("aLinkColor", "#99ccff");

        properties.put("borderColor", "#cccccc");
        properties.put("evenColor", "#ffffff");
        properties.put("oddColor", "#eeeeee");
        properties.put("activeColor", "#ffffcc");
        properties.put("tableHeaderColor", "#ffffff");
        properties.put("tableHeaderBgColor", "#336699");
        properties.put("breadcrumbColor", "#660000");
        properties.put("breadcrumbColorHover", "#660000");

        properties.put("communityName", "Community Forums");
        properties.put("communityDescription", "Welcome to our online community. Please choose from one of the forums below or log-in to your user account to start using this service.");
        properties.put("headerLogo", "<img src=\"images/logo.gif\" width=\"300\" height=\"45\" alt=\"Jive Community Forums\" border=\"0\">");
        properties.put("headerBorderColor", "#003366");
        properties.put("headerBgColor", "#336699");

        properties.put("threadMode", "flat"); // other values are "threaded" or "tree"
        properties.put("trackIP", "true");
        properties.put("newAccountCreationEnabled", "true");
        properties.put("showLastPostLink", "true");
        properties.put("usersChooseLocale", "false");
        properties.put("useDefaultCommunityName", "true");
        properties.put("useDefaultWelcomeText", "true");
        properties.put("useDefaultHeaderImage", "true");
        properties.put("readTracker.enabled", "true");
        properties.put("questions.enabled", "true");
        properties.put("rssFeeds.enabled", "false");
        properties.put("changePasswordEnabled", "true");

        properties.put("usersChooseThreadMode", "false");
    }
%>

<%@ include file="global.jsp" %>

<%	// Get parameters
    boolean save = "save".equals(request.getParameter("formAction"));
    boolean cancel = "cancel".equals(request.getParameter("formAction"));
    boolean restoreDefaults = "defaults".equals(request.getParameter("formAction"));
    String mode = ParamUtils.getParameter(request,"mode");

    // Cancel if requested
    if (cancel) {
        response.sendRedirect("skin.jsp");
        return;
    }

    // Get the current theme. The current theme will be "default" if no
    // current theme is detected.
    String theme = "default";

    // Save properties to current theme
    if (save) {
        // Loop through the list of properties, save whatever is not null
        for (Iterator iter=properties.keySet().iterator(); iter.hasNext();) {
            String propName = (String)iter.next();
            String propValue = ParamUtils.getParameter(request, propName, true);
            if (propValue != null) {
                if (propName.indexOf(".") > -1) {
                    JiveGlobals.setJiveProperty(propName, propValue);
                }
                else {
                    JiveGlobals.setJiveProperty("skin." + theme + "." + propName, propValue);
                }
            }
        }
    }

    // Restore the current theme to use the default
    if (restoreDefaults) {
        // Loop through the defaults, set jive properties accordingly
        for (Iterator iter=properties.keySet().iterator(); iter.hasNext();) {
            String key = (String)iter.next();
            String value = (String)properties.get(key);
            if (key.indexOf(".") > -1) {
                JiveGlobals.setJiveProperty(key,value);
            }
            else {
                JiveGlobals.setJiveProperty("skin.default."+key, value);
            }
        }
    }

    // List o' properties
    String skinTheme = "skin." + theme + ".";
    String fontFace = JiveGlobals.getJiveProperty(skinTheme + "fontFace");
    String descrFontFace = JiveGlobals.getJiveProperty(skinTheme + "descrFontFace");
    String fontSize = JiveGlobals.getJiveProperty(skinTheme + "fontSize");
    String descrFontSize = JiveGlobals.getJiveProperty(skinTheme + "descrFontSize");

    String homeURL = JiveGlobals.getJiveProperty(skinTheme + "homeURL");
    String bgColor = JiveGlobals.getJiveProperty(skinTheme + "bgColor");
    String textColor = JiveGlobals.getJiveProperty(skinTheme + "textColor");
    String linkColor = JiveGlobals.getJiveProperty(skinTheme + "linkColor");
    String vLinkColor = JiveGlobals.getJiveProperty(skinTheme + "vLinkColor");
    String aLinkColor = JiveGlobals.getJiveProperty(skinTheme + "aLinkColor");

    String borderColor = JiveGlobals.getJiveProperty(skinTheme + "borderColor");
    String evenColor = JiveGlobals.getJiveProperty(skinTheme + "evenColor");
    String oddColor = JiveGlobals.getJiveProperty(skinTheme + "oddColor");
    String activeColor = JiveGlobals.getJiveProperty(skinTheme + "activeColor");
    String tableHeaderColor = JiveGlobals.getJiveProperty(skinTheme + "tableHeaderColor");
    String tableHeaderBgColor = JiveGlobals.getJiveProperty(skinTheme + "tableHeaderBgColor");
    String breadcrumbColor = JiveGlobals.getJiveProperty(skinTheme + "breadcrumbColor");
    String breadcrumbColorHover = JiveGlobals.getJiveProperty(skinTheme + "breadcrumbColorHover");

    String communityName = JiveGlobals.getJiveProperty(skinTheme + "communityName");
    String communityDescription = JiveGlobals.getJiveProperty(skinTheme + "communityDescription");
    String headerLogo = JiveGlobals.getJiveProperty(skinTheme + "headerLogo");
    String headerBorderColor = JiveGlobals.getJiveProperty(skinTheme + "headerBorderColor");
    String headerBgColor = JiveGlobals.getJiveProperty(skinTheme + "headerBgColor");

    String threadMode = JiveGlobals.getJiveProperty(skinTheme + "threadMode");
    if (threadMode == null || "".equals(threadMode)) {
        // set "flat" mode as the default thread view
        threadMode = "flat";
    }

    boolean trackIP = !"false".equals(JiveGlobals.getJiveProperty(skinTheme + "trackIP")); // enabled by default
    boolean newAccountCreationEnabled = !"false".equals(JiveGlobals.getJiveProperty(skinTheme + "newAccountCreationEnabled")); // enabled by default
    boolean changePasswordEnabled = !"false".equals(JiveGlobals.getJiveProperty(skinTheme + "changePasswordEnabled")); // enabled by default
    boolean showLastPostLink = !"false".equals(JiveGlobals.getJiveProperty(skinTheme + "showLastPostLink")); // enabled by default
    boolean usersChooseLocale = "true".equals(JiveGlobals.getJiveProperty(skinTheme + "usersChooseLocale")); // disabled by default
    boolean useDefaultWelcomeText = !"false".equals(JiveGlobals.getJiveProperty(skinTheme + "useDefaultWelcomeText")); // enabled by default
    boolean useDefaultCommunityName = !"false".equals(JiveGlobals.getJiveProperty(skinTheme + "useDefaultCommunityName")); // enabled by default
    boolean useDefaultHeaderImage = !"false".equals(JiveGlobals.getJiveProperty(skinTheme + "useDefaultHeaderImage")); // enabled by default
    boolean usersChooseThreadMode = !"false".equals(JiveGlobals.getJiveProperty(skinTheme + "usersChooseThreadMode")); // enabled by default

    boolean readTrackerEnabled = !"false".equals(JiveGlobals.getJiveProperty("readTracker.enabled")); // enabled by default
    boolean questionsEnabled = !"false".equals(JiveGlobals.getJiveProperty("questions.enabled")); // enabled by default
    boolean rssFeedsEnabled = "true".equals(JiveGlobals.getJiveProperty("rssFeeds.enabled")); // disabled by default

    if (activeColor == null) {
        activeColor = "#ffcccc";
        JiveGlobals.setJiveProperty("skin.default.activeColor", activeColor);
    }

    // escape the < and > and quotes from necessary fields
    communityName = StringUtils.escapeHTMLTags(communityName);
    communityName = StringUtils.replace(communityName, "\"", "&quot;");
    communityDescription = StringUtils.escapeHTMLTags(communityDescription);
    communityDescription = StringUtils.replace(communityDescription, "\"", "&quot;");
    headerLogo = StringUtils.escapeHTMLTags(headerLogo);
    headerLogo = StringUtils.replace(headerLogo, "\"", "&quot;");
%>


<%@ include file="header.jsp" %>

<%  // Title of this page and breadcrumbs
    String title = "Skin Settings";
    String[][] breadcrumbs = null;
    if ("fonts".equals(mode)) {
        breadcrumbs = new String[][] {
            {"Main", "main.jsp"},
            {title, "skin.jsp"},
            {"Fonts", "skin.jsp?mode=fonts"}
        };
    }
    else if ("colors".equals(mode)) {
        breadcrumbs = new String[][] {
            {"Main", "main.jsp"},
            {title, "skin.jsp"},
            {"Colors", "skin.jsp?mode=colors"}
        };
    }
    else if ("forumtext".equals(mode)) {
        breadcrumbs = new String[][] {
            {"Main", "main.jsp"},
            {title, "skin.jsp"},
            {"Forum Text", "skin.jsp?mode=forumtext"}
        };
    }
    else if ("headerandfooter".equals(mode)) {
        breadcrumbs = new String[][] {
            {"Main", "main.jsp"},
            {title, "skin.jsp"},
            {"Header &amp; Footer", "skin.jsp?mode=headerandfooter"}
        };
    }
    else if ("features".equals(mode)) {
        breadcrumbs = new String[][] {
            {"Main", "main.jsp"},
            {title, "skin.jsp"},
            {"Features", "skin.jsp?mode=features"}
        };
    }
    else if ("threadmode".equals(mode)) {
        breadcrumbs = new String[][] {
            {"Main", "main.jsp"},
            {title, "skin.jsp"},
            {"Thread Mode", "skin.jsp?mode=threadmode"}
        };
    }
    else {
        breadcrumbs = new String[][] {
            {"Main", "main.jsp"},
            {title, "skin.jsp"}
        };
    }
%>
<%@ include file="title.jsp" %>

<script language="JavaScript" type="text/javascript">
<!--
var theEl;
function colorPicker(el) {
    var val = el.value.substr(1,6);
    var win = window.open("colorPicker.jsp?element="+el.name+"&defaultColor="+val,"","menubar=yes,location=no,personalbar=no,scrollbar=yes,width=580,height=300,resizable");
}
//-->
</script>
<style type="text/css">
.demo {
    text-decoration : underline;
    color : <%= linkColor %>;
}
.demo:hover {
    text-decoration : underline;
    color : <%= aLinkColor %>;
}
</style>

<form action="skin.jsp" name="skinForm" method="post">
<input type="hidden" name="formAction" value="">
<%  if (mode != null) { %>
<input type="hidden" name="mode" value="<%= mode %>">
<%  } %>

<%  // Depending on the "mode", we'll print out a different page. The default
    // mode (when mode == null) is to print out the list of editable skin
    // categories.
    if (mode == null) {
%>
    You can edit the attributes of the default Jive Forums skin by choosing one
    of the options below:

    <ul><li><a href="skin.jsp?mode=fonts">Fonts</a>
            - Adjust the list of fonts and their sizes.

        <li><a href="skin.jsp?mode=colors">Colors</a>
            - Adjust colors of backgrounds, fonts, links, and borders.

        <li><a href="skin.jsp?mode=forumtext">Forum Text</a>
            - Edit the welcome text for your community.

        <li><a href="skin.jsp?mode=headerandfooter">Header &amp; Footer</a>
            - Edit the image and colors of the header and footer as well as
              the text and links for the breadcrumbs.

        <li><a href="skin.jsp?mode=features">Features</a>
            - Turn on or off various features in the default skin.
    </ul>

<%  } else if ("fonts".equals(mode)) { %>

    <b>Font Settings</b>

    <ul>
    <table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0">
    <tr><td>
    <table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
    <tr bgcolor="#ffffff">
        <td rowspan="2">Global Font:</td>
        <td nowrap>Font List:</td><td><input type="text" size="25" name="fontFace" maxlength="100" value="<%= (fontFace!=null)?fontFace:"" %>"></td>
        <td rowspan="2" style="font-size:<%= fontSize %>;font-family:<%= fontFace %>;">
            This is an example of this font
        </td>
    </tr>
    <tr bgcolor="#ffffff">
        <td nowrap>Font Size:</td>
        <td><input type="text" size="25" name="fontSize" maxlength="100" value="<%= (fontSize!=null)?fontSize:"" %>"></td>
    </tr>
    <tr bgcolor="#ffffff">
        <td rowspan="2">
            Description Font:
            <font size="-2">
            <br>(Size is relative to the global font.)
            </font>
        </td>
        <td>Font List:</td>
        <td><input type="text" size="25" name="descrFontFace" maxlength="100" value="<%= (descrFontFace!=null)?descrFontFace:"" %>"></td>
        <td rowspan="2" style="font-size:<%= fontSize %>">
            <span style="font-size:<%= descrFontSize %>;font-family:<%= descrFontFace %>;">
            This would be a forum or category description.
            </span>
        </td>
    </tr>
    <tr bgcolor="#ffffff">
        <td nowrap>Font Size:</td>
        <td><input type="text" size="25" name="descrFontSize" maxlength="100" value="<%= (descrFontSize!=null)?descrFontSize:"" %>"></td>
    </tr>
    </table>
    </td></tr>
    </table>
    </ul>

<%  }
    else if ("colors".equals(mode)) { %>

    <b>Global Color Settings</b>

    <ul>
    <table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0">
    <tr><td>
    <table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
    <tr bgcolor="#ffffff">
    <td>Background Color:</td>
    <td><table border="0" cellpadding="2" cellspacing="0">
        <tr>
            <td><table cellpadding="0" cellspacing="1" border="1"
                ><td bgcolor="<%= (bgColor!=null)?bgColor:"" %>"
                ><a href="#" onclick="colorPicker(document.skinForm.bgColor);"
                ><img src="images/blank.gif" width="15" height="15" border="0"></a></td></table>
            </td>
            <td><input type="text" name="bgColor" size="10" maxlength="20" value="<%= (bgColor!=null)?bgColor:"" %>"></td>
        </tr>
        </table>
    </td>
    <td rowspan="5" align="center" bgcolor="<%= bgColor %>">

        <table cellpadding="5" cellspacing="0" border="0" width="200">
        <tr><td>
                <font size="-1" color="<%= textColor %>"
                 face="<%= JiveGlobals.getJiveProperty(skinTheme + "fontFace") %>">
                This is how the text looks on your page.
                </font>
                <br>
                <a href="#" onclick="return false;" class="demo">
                This is what a link
                looks like on your page.</a>
            </td>
        </tr>
        </table>
    </td>
    </tr>
    <tr bgcolor="#ffffff">
    <td>Text Color:</td>
    <td><table border="0" cellpadding="2" cellspacing="0">
        <tr>
            <td><table cellpadding="0" cellspacing="1" border="1"
                ><td bgcolor="<%= (textColor!=null)?textColor:"" %>"
                ><a href="#" onclick="colorPicker(document.skinForm.textColor);"
                ><img src="images/blank.gif" width="15" height="15" border="0"></a></td></table>
            </td>
            <td><input type="text" name="textColor" size="10" maxlength="20" value="<%= (textColor!=null)?textColor:"" %>"></td>
        </tr>
        </table>
    </td>
    </tr>
    <tr bgcolor="#ffffff">
    <td>Link Color:</td>
    <td><table border="0" cellpadding="2" cellspacing="0">
        <tr>
            <td><table cellpadding="0" cellspacing="1" border="1"
                ><td bgcolor="<%= (linkColor!=null)?linkColor:"" %>"
                ><a href="#" onclick="colorPicker(document.skinForm.linkColor);"
                ><img src="images/blank.gif" width="15" height="15" border="0"></a></td></table>
            </td>
            <td><input type="text" name="linkColor" size="10" maxlength="20" value="<%= (linkColor!=null)?linkColor:"" %>"></td>
        </tr>
        </table>
    </td>
    </tr>
    <tr bgcolor="#ffffff">
    <td>Visited Link Color:</td>
    <td><table border="0" cellpadding="2" cellspacing="0">
        <tr>
            <td><table cellpadding="0" cellspacing="1" border="1"
                ><td bgcolor="<%= (vLinkColor!=null)?vLinkColor:"" %>"
                ><a href="#" onclick="colorPicker(document.skinForm.vLinkColor);"
                ><img src="images/blank.gif" width="15" height="15" border="0"></a></td></table>
            </td>
            <td><input type="text" name="vLinkColor" size="10" maxlength="20" value="<%= (vLinkColor!=null)?vLinkColor:"" %>"></td>
        </tr>
        </table>
    </td>
    </tr>
    <tr bgcolor="#ffffff">
    <td>Active Link Color:
        <font size="-2">
        <br>
        (Also hover color)
        </font>
    </td>
    <td><table border="0" cellpadding="2" cellspacing="0">
        <tr>
            <td><table cellpadding="0" cellspacing="1" border="1"
                ><td bgcolor="<%= (aLinkColor!=null)?aLinkColor:"" %>"
                ><a href="#" onclick="colorPicker(document.skinForm.aLinkColor);"
                ><img src="images/blank.gif" width="15" height="15" border="0"></a></td></table>
            </td>
            <td><input type="text" name="aLinkColor" size="10" maxlength="20" value="<%= (aLinkColor!=null)?aLinkColor:"" %>"></td>
        </tr>
        </table>
    </td>
    </tr>

    <tr bgcolor="#ffffff">
    <td>Breadcrumb Color:</td>
    <td><table border="0" cellpadding="2" cellspacing="0">
        <tr>
            <td><table cellpadding="0" cellspacing="1" border="1"
                ><td bgcolor="<%= (breadcrumbColor!=null)?breadcrumbColor:"" %>"
                ><a href="#" onclick="colorPicker(document.skinForm.breadcrumbColor);"
                ><img src="images/blank.gif" width="15" height="15" border="0"></a></td></table>
            </td>
            <td><input type="text" name="breadcrumbColor" size="10" maxlength="20" value="<%= (breadcrumbColor!=null)?breadcrumbColor:"" %>"></td></td>
        </tr>
        </table>
    </td>
        <td rowspan="2" style="font-size:<%= fontSize %>;font-family:<%= fontFace %>;">
            <span style="color:<%= breadcrumbColor %>;">
            <a href="" style="color:<%= breadcrumbColor %> !important;" onclick="return false;"
             ><b>Home</b></a>
            &raquo;
            <a href="" style="color:<%= breadcrumbColor %> !important;" onclick="return false;"
             ><b>Forums</b></a>
            </span>
        </td>
    </tr>
    <tr bgcolor="#ffffff">
    <td>Breadcrumb Hover Color:</td>
    <td><table border="0" cellpadding="2" cellspacing="0">
        <tr>
            <td><table cellpadding="0" cellspacing="1" border="1"
                ><td bgcolor="<%= (breadcrumbColorHover!=null)?breadcrumbColorHover:"" %>"
                ><a href="#" onclick="colorPicker(document.skinForm.breadcrumbColorHover);"
                ><img src="images/blank.gif" width="15" height="15" border="0"></a></td></table>
            </td>
            <td><input type="text" name="breadcrumbColorHover" size="10" maxlength="20" value="<%= (breadcrumbColorHover!=null)?breadcrumbColorHover:"" %>"></td></td>
        </tr>
        </table>
    </td>
    </tr>

    <tr bgcolor="#ffffff">
    <td>Global Border Color:</td>
    <td><table border="0" cellpadding="2" cellspacing="0">
        <tr>
            <td><table cellpadding="0" cellspacing="1" border="1"
                ><td bgcolor="<%= (borderColor!=null)?borderColor:"" %>"
                ><a href="#" onclick="colorPicker(document.skinForm.borderColor);"
                ><img src="images/blank.gif" width="15" height="15" border="0"></a></td></table>
            </td>
            <td><input type="text" name="borderColor" size="10" maxlength="20" value="<%= (borderColor!=null)?borderColor:"" %>"></td></td>
        </tr>
        </table>
    </td>
    <td rowspan="99">&nbsp;</td>
    </tr>
    <tr bgcolor="#ffffff">
    <td>Even Row Color:</td>
    <td><table border="0" cellpadding="2" cellspacing="0">
        <tr>
            <td><table cellpadding="0" cellspacing="1" border="1"
                ><td bgcolor="<%= (evenColor!=null)?evenColor:"" %>"
                ><a href="#" onclick="colorPicker(document.skinForm.evenColor);"
                ><img src="images/blank.gif" width="15" height="15" border="0"></a></td></table>
            </td>
            <td><input type="text" name="evenColor" size="10" maxlength="20" value="<%= (evenColor!=null)?evenColor:"" %>"></td></td>
        </tr>
        </table>
    </td>
    </tr>
    <tr bgcolor="#ffffff">
    <td>Odd Row Color:</td>
    <td><table border="0" cellpadding="2" cellspacing="0">
        <tr>
            <td><table cellpadding="0" cellspacing="1" border="1"
                ><td bgcolor="<%= (oddColor!=null)?oddColor:"" %>"
                ><a href="#" onclick="colorPicker(document.skinForm.oddColor);"
                ><img src="images/blank.gif" width="15" height="15" border="0"></a></td></table>
            </td>
            <td><input type="text" name="oddColor" size="10" maxlength="20" value="<%= (oddColor!=null)?oddColor:"" %>"></td></td>
        </tr>
        </table>
    </td>
    </tr>
    <tr bgcolor="#ffffff">
    <td>Active Row Color:</td>
    <td><table border="0" cellpadding="2" cellspacing="0">
        <tr>
            <td><table cellpadding="0" cellspacing="1" border="1"
                ><td bgcolor="<%= (activeColor!=null)?activeColor:"" %>"
                ><a href="#" onclick="colorPicker(document.skinForm.activeColor);"
                ><img src="images/blank.gif" width="15" height="15" border="0"></a></td></table>
            </td>
            <td><input type="text" name="activeColor" size="10" maxlength="20" value="<%= (activeColor!=null)?activeColor:"" %>"></td></td>
        </tr>
        </table>
    </td>
    </tr>
    <tr bgcolor="#ffffff">
    <td>Table Header Font Color:</td>
    <td><table border="0" cellpadding="2" cellspacing="0">
        <tr>
            <td><table cellpadding="0" cellspacing="1" border="1"
                ><td bgcolor="<%= (tableHeaderColor!=null)?tableHeaderColor:"" %>"
                ><a href="#" onclick="colorPicker(document.skinForm.tableHeaderColor);"
                ><img src="images/blank.gif" width="15" height="15" border="0"></a></td></table>
            </td>
            <td><input type="text" name="tableHeaderColor" size="10" maxlength="20" value="<%= (tableHeaderColor!=null)?tableHeaderColor:"" %>"></td></td>
        </tr>
        </table>
    </td>
    </tr>
    <tr bgcolor="#ffffff">
    <td>Table Header Background Color:</td>
    <td><table border="0" cellpadding="2" cellspacing="0">
        <tr>
            <td><table cellpadding="0" cellspacing="1" border="1"
                ><td bgcolor="<%= (tableHeaderBgColor!=null)?tableHeaderBgColor:"" %>"
                ><a href="#" onclick="colorPicker(document.skinForm.tableHeaderBgColor);"
                ><img src="images/blank.gif" width="15" height="15" border="0"></a></td></table>
            </td>
            <td><input type="text" name="tableHeaderBgColor" size="10" maxlength="20" value="<%= (tableHeaderBgColor!=null)?tableHeaderBgColor:"" %>"></td></td>
        </tr>
        </table>
    </td>
    </tr>
    </table>
    </td></tr>
    </table>
    </ul>

<%  }
    else if ("forumtext".equals(mode)) { %>

    <b>Community Name</b>

    <ul>
    <table cellpadding="3" cellspacing="0" border="0">
    <tr><td>
        <input type="radio" name="useDefaultCommunityName" value="true"<%= (useDefaultCommunityName) ? " checked":"" %> id="rb011">
        </td>
        <td>
            <label for="rb011">Use default community name (internationalized):</label>
        </td>
    </tr>
    <tr><td>&nbsp;</td>
        <td>
            <%= LocaleUtils.getLocalizedString("global.community_forums", JiveGlobals.getLocale()) %>
        </td>
    </tr>
    <tr><td>
        <input type="radio" name="useDefaultCommunityName" value="false"<%= (!useDefaultCommunityName) ? " checked":"" %> id="rb021">
        </td>
        <td>
            <label for="rb021">Enter a custom community name:</label>
        </td>
    </tr>
    <tr><td>&nbsp;</td>
        <td>
            <input type="text" name="communityName" size="35" maxlength="100"
             value="<%= (communityName!=null)?communityName:"" %>"
             onfocus="this.form.useDefaultCommunityName[1].checked=true;">
        </td>
    </tr>
    </table>
    </ul>

    <b>Community Description</b>

    <ul>
    <table cellpadding="3" cellspacing="0" border="0">
    <tr><td>
        <input type="radio" name="useDefaultWelcomeText" value="true"<%= (useDefaultWelcomeText) ? " checked":"" %> id="rb01">
        </td>
        <td>
            <label for="rb01">Use default welcome message (internationalized):</label>
        </td>
    </tr>
    <tr><td>&nbsp;</td>
        <td>
            <table bgcolor="<%= tblBorderColor %>" cellpadding="1" cellspacing="0" border="0" width="400">
            <tr><td>
            <table bgcolor="#ffffff" cellpadding="3" cellspacing="0" border="0" width="100%">
            <tr>
                <td>
                    <%= LocaleUtils.getLocalizedString("global.community_text", JiveGlobals.getLocale()) %>
                </td>
            </tr>
            </table>
            </td></tr>
            </table>
        </td>
    </tr>
    <tr><td>
        <input type="radio" name="useDefaultWelcomeText" value="false"<%= (!useDefaultWelcomeText) ? " checked":"" %> id="rb02">
        </td>
        <td>
            <label for="rb02">Enter a custom welcome message:</label>
        </td>
    </tr>
    <tr><td>&nbsp;</td>
        <td>
            <textarea rows="5" cols="35" name="communityDescription" wrap="virtual"
             onfocus="this.form.useDefaultWelcomeText[1].checked=true;"
             ><%= (communityDescription!=null)?communityDescription:"" %></textarea>
        </td>
    </tr>
    </table>
    </ul>

<%  }
    else if ("headerandfooter".equals(mode)) { %>

    <b>Global header</b>

    <ul>
    <table bgcolor="<%= tblBorderColor %>" cellpadding="0" cellspacing="0" border="0">
    <tr><td>
    <table bgcolor="<%= tblBorderColor %>" cellpadding="3" cellspacing="1" border="0" width="100%">
    <tr bgcolor="#ffffff">
    <td>Header Border Color:</td>
    <td><table border="0" cellpadding="2" cellspacing="0">
        <tr>
            <td><table cellpadding="0" cellspacing="1" border="1"
                ><td bgcolor="<%= (headerBorderColor!=null)?headerBorderColor:"" %>"
                ><a href="#" onclick="colorPicker(document.skinForm.headerBorderColor);"
                ><img src="images/blank.gif" width="15" height="15" border="0"></a></td></table>
            </td>
            <td><input type="text" name="headerBorderColor" size="10" maxlength="20" value="<%= (headerBorderColor!=null)?headerBorderColor:"" %>"></td>
        </tr>
        </table>
    </td>
    </tr>
    <tr bgcolor="#ffffff">
    <td>Header Background Color:</td>
    <td><table border="0" cellpadding="2" cellspacing="0">
        <tr>
            <td><table cellpadding="0" cellspacing="1" border="1"
                ><td bgcolor="<%= (headerBgColor!=null)?headerBgColor:"" %>"
                ><a href="#" onclick="colorPicker(document.skinForm.headerBgColor);"
                ><img src="images/blank.gif" width="15" height="15" border="0"></a></td></table>
            </td>
            <td><input type="text" name="headerBgColor" size="10" maxlength="20" value="<%= (headerBgColor!=null)?headerBgColor:"" %>"></td>
        </tr>
        </table>
    </td>
    </tr>
    <tr bgcolor="#ffffff">
        <td valign="top">Header Logo:</td>
        <td valign="top">
            <table cellpadding="3" cellspacing="0" border="0" width="400">
            <tr><td>
                <input type="radio" name="useDefaultHeaderImage" value="true"<%= (useDefaultHeaderImage ? " checked":"") %> id="rb01">
                </td>
                <td>
                    <label for="rb01">Use default header image (internationalized):</label>
                </td>
            </tr>
            <tr><td>&nbsp;</td>
                <td>

                    <%  Locale locale = JiveGlobals.getLocale();
                        if ("en".equals(locale.getLanguage())) {
                    %>
                        <b>&lt;img src="images/logo.gif" width="242" height="38" border="0"&gt;</b>
                    <%  }
                        else {
                            // Display the locale-specific image URL:
                            String localeCode = locale.toString();
                    %>
                        <b>&lt;img src="images/logo_<%= localeCode %>.gif" width="242" height="38" border="0"&gt;</b>
                    <%
                        }
                    %>

                </td>
            </tr>
            <tr><td>
                <input type="radio" name="useDefaultHeaderImage" value="false"<%= (!useDefaultHeaderImage) ? " checked":"" %> id="rb02">
                </td>
                <td>

                    <label for="rb02">Use custom header image:</label>

                </td>
            </tr>
            <tr><td>&nbsp;</td>
                <td>
                    <input type="text" size="50" name="headerLogo" maxlength="150" value="<%= (headerLogo!=null)?headerLogo:"" %>"
                     onfocus="this.form.useDefaultHeaderImage[1].checked=true;">
                </td>
            </tr>
            </table>
        </td>
    </tr>
    <tr bgcolor="#ffffff">
        <td>Home URL:</td>
        <td><input type="text" size="35" name="homeURL" maxlength="150" value="<%= (homeURL!=null)?homeURL:"" %>">
            <font size="-2">
            <br>
            Note, if this is left blank, the "Home" part of the breadcrumbs will not appear.
            This URL can be relative or absolute.
            </font>
        </td>
    </tr>
    </table>
    </td></tr>
    </table>
    </ul>

<%  }
    else if ("features".equals(mode)) { %>

    <b>Features</b>

    <p><b>Thread Mode:</b>
        <a href="#" onclick="helpwin('skin','thread_mode');return false;"
         title="Click for help"
         ><img src="images/help-16x16.gif" width="16" height="16" border="0" hspace="8"></a>

        <ul>
        <table cellpadding="3" cellspacing="0" border="0">
        <tr valign="top">
             <td>
                <input type="radio" name="threadMode" value="flat"<%= ("flat".equals(threadMode))?" checked":"" %> id="rb1">
             </td>
             <td>
                 <label for="rb1">Flat - Messages appear in a list.</label>
             </td>
        </tr>
        <tr valign="top">
            <td>
                <input type="radio" name="threadMode" value="threaded"<%= ("threaded".equals(threadMode))?" checked":"" %> id="rb2">
            </td>
            <td>
                <label for="rb2">Threaded - Messages are indented.</label>
            </td>
        </tr>
        <tr>
            <td>
                <input type="radio" name="threadMode" value="tree"<%= ("tree".equals(threadMode))?" checked":"" %> id="rb22">
            </td>
            <td>
                <label for="rb22">Tree - One message per page with the thread tree below it.</label>
            </td>
        </tr>
        </table>
        </ul>

    <p><b>Show "Last Post" Link:</b>
        <a href="#" onclick="helpwin('skin','last_post');return false;"
        title="Click for help"
        ><img src="images/help-16x16.gif" width="16" height="16" border="0" hspace="8"></a>

        <ul>
        <table cellpadding="3" cellspacing="0" border="0">
        <tr valign="top">
             <td>
                 <input type="radio" name="showLastPostLink" value="true"<%= (showLastPostLink) ? " checked":"" %> id="rb10">
             </td>
             <td>
                  <label for="rb10">Enabled - The last posted message will appear as a link in the index and forum views.</label>
             </td>
        </tr>
        <tr valign="top">
            <td>
                <input type="radio" name="showLastPostLink" value="false"<%= (!showLastPostLink) ? " checked":"" %> id="rb20">
            </td>
            <td>
                <label for="rb20">Disabled - The last posted message will <b>not</b> appear as a link in the forum and thread views. This
                might be better for smaller UIs.</label>
            </td>
        </tr>
        </table>
        </ul>

    <p><b>New Account Creation Enabled:</b>
        <a href="#" onclick="helpwin('skin','new_account');return false;"
        title="Click for help"
        ><img src="images/help-16x16.gif" width="16" height="16" border="0" hspace="8"></a>

        <ul>
        <table cellpadding="3" cellspacing="0" border="0">
        <tr valign="top">
             <td>
                 <input type="radio" name="newAccountCreationEnabled" value="true"<%= (newAccountCreationEnabled) ? " checked":"" %> id="rb7">
             </td>
             <td>
                  <label for="rb7">Enabled - Users can create new accounts through the default skin (recommended).</label>
             </td>
        </tr>
        <tr valign="top">
            <td>
                <input type="radio" name="newAccountCreationEnabled" value="false"<%= (!newAccountCreationEnabled) ? " checked":"" %> id="rb8">
            </td>
            <td>
                <label for="rb8">Disabled - Users can not create new accounts through the default skin. This might be useful when using custom user systems.</label>
            </td>
        </tr>
        </table>
        </ul>

    <p><b>Change Password Enabled:</b>
        <a href="#" onclick="helpwin('skin','change_password');return false;"
        title="Click for help"
        ><img src="images/help-16x16.gif" width="16" height="16" border="0" hspace="8"></a>

        <ul>
        <table cellpadding="3" cellspacing="0" border="0">
        <tr valign="top">
             <td>
                 <input type="radio" name="changePasswordEnabled" value="true"<%= (changePasswordEnabled) ? " checked":"" %> id="rb7">
             </td>
             <td>
                  <label for="rb7">Enabled - Users can change their password through the default skin (recommended).</label>
             </td>
        </tr>
        <tr valign="top">
            <td>
                <input type="radio" name="changePasswordEnabled" value="false"<%= (!changePasswordEnabled) ? " checked":"" %> id="rb8">
            </td>
            <td>
                <label for="rb8">Disabled - Users can not change their password through the default skin. This might be useful when using custom user systems.</label>
            </td>
        </tr>
        </table>
        </ul>

    <p><b>Track IPs:</b>
        <a href="#" onclick="helpwin('skin','track_ip');return false;"
        title="Click for help"
        ><img src="images/help-16x16.gif" width="16" height="16" border="0" hspace="8"></a>

        <ul>
        <table cellpadding="3" cellspacing="0" border="0">
        <tr valign="top">
             <td>
                 <input type="radio" name="trackIP" value="true"<%= (trackIP) ? " checked":"" %> id="rb3">
             </td>
             <td>
                  <label for="rb3">On - User's IP is saved when they post a message.</label>
             </td>
        </tr>
        <tr valign="top">
            <td>
                <input type="radio" name="trackIP" value="false"<%= (!trackIP) ? " checked":"" %> id="rb4">
            </td>
            <td>
                <label for="rb4">Off - User's IP is not saved.</label>
            </td>
        </tr>
        </table>
        </ul>

    <p><b>Allow Users To Choose Locale:</b>
        <a href="#" onclick="helpwin('skin','choose_locale');return false;"
        title="Click for help"
        ><img src="images/help-16x16.gif" width="16" height="16" border="0" hspace="8"></a>

        <ul>
        <table cellpadding="3" cellspacing="0" border="0">
        <tr valign="top">
             <td>
                 <input type="radio" name="usersChooseLocale" value="true"<%= (usersChooseLocale) ? " checked":"" %> id="rb30">
             </td>
             <td>
                  <label for="rb30">On - Users can change their locale via their settings page. This will
                  override the default <a href="locale.jsp">Jive locale</a>.</label>
             </td>
        </tr>
        <tr valign="top">
            <td>
                <input type="radio" name="usersChooseLocale" value="false"<%= (!usersChooseLocale) ? " checked":"" %> id="rb40">
            </td>
            <td>
                <label for="rb40">Off - The user locale will be the default
            <a href="locale.jsp">Jive locale</a>.</label>
            </td>
        </tr>
        </table>
        </ul>


        <%--

    <p><b>Allow Users To Choose their Thread Mode:</b>
        <a href="#" onclick="helpwin('skin','choose_threading');return false;"
        title="Click for help"
        ><img src="images/help-16x16.gif" width="16" height="16" border="0" hspace="8"></a>

        <ul>
        <table cellpadding="3" cellspacing="0" border="0">
        <tr valign="top">
             <td>
                 <input type="radio" name="usersChooseThreadMode" value="true"<%= ("true".equals(usersChooseThreadMode))?" checked":"" %> id="rb303">
             </td>
             <td>
                  <label for="rb303">On - Users are allowed to specify what thread interface they'd like to use.</label>
             </td>
        </tr>
        <tr valign="top">
            <td>
                <input type="radio" name="usersChooseThreadMode" value="false"<%= ("false".equals(usersChooseThreadMode))?" checked":"" %> id="rb404">
            </td>
            <td>
                <label for="rb404">Off - Users are not allowed to pick a thread interface - the system
        default is used (set above).</label>
            </td>
        </tr>
        </table>
        </ul>

        --%>

        <%  if (Version.getEdition() != Version.Edition.LITE) { %>

            <p><b>Read Tracking:</b>
                <a href="#" onclick="helpwin('skin','read_tracking');return false;"
                title="Click for help"
                ><img src="images/help-16x16.gif" width="16" height="16" border="0" hspace="8"></a>

                <ul>
                <table cellpadding="3" cellspacing="0" border="0">
                <tr valign="top">
                     <td>
                         <input type="radio" name="readTracker.enabled" value="true"<%= (readTrackerEnabled) ? " checked":"" %> id="rb511">
                     </td>
                     <td>
                          <label for="rb511">Enabled - Registered users can track unread messages.</label>
                     </td>
                </tr>
                <tr valign="top">
                    <td>
                        <input type="radio" name="readTracker.enabled" value="false"<%= (!readTrackerEnabled) ? " checked":"" %> id="rb611">
                    </td>
                    <td>
                        <label for="rb611">Disabled - New messages are determined by the time the user last visited the site.</label>
                    </td>
                </tr>
                </table>
                </ul>

            <%  if (Version.getEdition() == Version.Edition.ENTERPRISE) { %>

                <p><b>Mark Topics as Questions:</b>
                    <a href="#" onclick="helpwin('skin','questions');return false;"
                    title="Click for help"
                    ><img src="images/help-16x16.gif" width="16" height="16" border="0" hspace="8"></a>

                    <ul>
                    <table cellpadding="3" cellspacing="0" border="0">
                    <tr valign="top">
                         <td>
                             <input type="radio" name="questions.enabled" value="true"<%= (questionsEnabled) ? " checked":"" %> id="rb515">
                         </td>
                         <td>
                              <label for="rb515">Enabled - Topic authors can mark new topics as questions which require resolution.</label>
                         </td>
                    </tr>
                    <tr valign="top">
                        <td>
                            <input type="radio" name="questions.enabled" value="false"<%= (!questionsEnabled) ? " checked":"" %> id="rb615">
                        </td>
                        <td>
                            <label for="rb615">Disabled - Topics are not designated in any special way.</label>
                        </td>
                    </tr>
                    </table>
                    </ul>

            <%  } %>

        <%  } %>

    <p><b>Content Syndication (RSS feeds):</b>
        <a href="#" onclick="helpwin('skin','rss_feeds');return false;"
        title="Click for help"
        ><img src="images/help-16x16.gif" width="16" height="16" border="0" hspace="8"></a>

        <ul>
        <table cellpadding="3" cellspacing="0" border="0">
        <tr valign="top">
             <td>
                 <input type="radio" name="rssFeeds.enabled" value="true"<%= (rssFeedsEnabled) ? " checked":"" %> id="rb5111">
             </td>
             <td>
                  <label for="rb5111">Enabled - Forum and topic listings can be retrieved via RSS feeds.</label>
             </td>
        </tr>
        <tr valign="top">
            <td>
                <input type="radio" name="rssFeeds.enabled" value="false"<%= (!rssFeedsEnabled) ? " checked":"" %> id="rb6111">
            </td>
            <td>
                <label for="rb6111">Disabled - No content is exposed via RSS feeds.</label>
            </td>
        </tr>
        </table>
        </ul>

<%  } %>

<center>
<%  if (mode != null) { %>
<input type="submit" name="save" value="Save Settings" onclick="this.form.formAction.value='save';">
<input type="submit" name="cancel" value="Cancel" onclick="this.form.formAction.value='cancel';">
<%  } %>

<input type="submit" value="Restore All Defaults" onclick="if (confirm('Warning, this restores ALL properties. Are you sure you want to proceed?')){this.form.formAction.value='defaults';}">

</center>

</form>

<%@ include file="footer.jsp" %>




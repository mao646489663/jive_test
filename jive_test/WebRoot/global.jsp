<%--
  -
  - $RCSfile: global.jsp,v $
  - $Revision: 1.21.2.1 $
  - $Date: 2003/06/17 16:36:32 $
  -
--%>


<%@ page import="com.jivesoftware.webwork.util.ValueStack,
                 java.util.*,
                 com.jivesoftware.base.*,
                 com.jivesoftware.forum.action.*"
%>

<%! /**
     * Returns a Jive property from the jive_config.xml file. The property will first
     * be loaded as "skin.default." + name -- if that fails, just the name is used.
     *
     * @param name the name of the property to look up.
     * @return a Jive property from the jive_config.xml file.
     */
    private static String getProp(String name) {
        String value = JiveGlobals.getJiveProperty("skin.default." + name);
        if (value != null) {
            return value;
        }
        else {
            return JiveGlobals.getJiveProperty(name);
        }
    }

    private Object getAction(HttpServletRequest request) {
        ValueStack vs = ValueStack.getStack(request);
        Object obj = vs.popValue();
        vs.pushValue(obj);
        return obj;
    }
%>

<%  // Set the content type
    response.setContentType("text/html; charset=" + JiveGlobals.getCharacterEncoding());

    // Load the resource bundle used for this skin.
    String bundleName = "jive_forums_i18n";
    try {
        ResourceBundle bundle = ResourceBundle.getBundle(bundleName, JiveGlobals.getLocale());
        // Put the bundle in the request as an attribute:
        request.setAttribute("jive.i18n.bundle", bundle);
    }
    catch (MissingResourceException mre) {
        Log.error("Unable to load bundle, basename '" + bundleName + "'");
    }
%>
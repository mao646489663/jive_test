<%@ page import="java.lang.reflect.Method"%>

<%  // check for <setup>true</setup> in the jive config file. If setup does
    // equal true, inactivate this setup tool

    boolean showSidebar = true;

	boolean doSetup = false;
    // Try loading a Jive class:
    try {
        Class jiveGlobals = Class.forName("com.jivesoftware.base.JiveGlobals");
        // authorization class used below
        Class authorization = Class.forName("com.jivesoftware.base.AuthToken");
        Class[] params = new Class[1];
        params[0] = "".getClass();
        Method getJiveProperty = jiveGlobals.getMethod("getJiveProperty", params);
        if (getJiveProperty == null) {
            doSetup = true;
        }
        else {
            // Call JiveGlobals.getJiveProperty("setup")
            String[] args = {"setup"};
            Object setupVal = getJiveProperty.invoke(null, args);
            if (setupVal == null) {
                doSetup = true;
            }
            else {
                String setup = (String)setupVal;
                if (!"true".equals(setup)) {
                    doSetup = true;
                }
            }
        }
    }
    catch (Exception e) {
        doSetup = true;
    }
    
    if (!doSetup) {
        response.sendRedirect("completed.jsp");
        return;
    }
%>
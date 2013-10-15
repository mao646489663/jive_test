<%--
  -
  - $RCSfile: edit-policy.jsp,v $
  - $Revision: 1.1 $
  - $Date: 2003/05/22 21:05:43 $
  -
--%>

<%@ page import="com.jivesoftware.util.ParamUtils"
    errorPage="error.jsp"
%>

<%@ include file="global.jsp" %>

<%! // global vars, methods, etc

    // Edit policy definitions
    static final String EDIT_ALWAYS = "always";
    static final String EDIT_WHEN_NO_REPLIES = "noreplies";
    static final String EDIT_TIME_WINDOW = "timewindow";
    static final String EDIT_NEVER = "never";

    // Default edit policy
    static final String DEFAULT_EDIT_POLICY = EDIT_ALWAYS;

    // Name of the jive property that saves the edit policy
    static final String EDIT_POLICY_PROP_NAME = "messageEdit.policy";

    // Name of the jive property that saves the edit time window value
    static final String TIME_WINDOW_PROP_NAME = "messageEdit.timeWindow";
%>

<%  // Permissions check
    if (!isSystemAdmin) {
        throw new UnauthorizedException("You don't have admin privileges to perform this operation.");
    }

    // Get parameters
    boolean update = request.getParameter("update") != null;
    String policy = ParamUtils.getParameter(request,"policy");
    int timeWindow = ParamUtils.getIntParameter(request,"timeWindow",0);

    // Update the edit policy if necessary:
    Map errors = new HashMap();
    if (update) {
        // Validate
        if (policy == null) {
            errors.put("general","");
        }
        else {
            if (!EDIT_ALWAYS.equals(policy) && !EDIT_WHEN_NO_REPLIES.equals(policy)
                    && !EDIT_TIME_WINDOW.equals(policy) && !EDIT_NEVER.equals(policy))
            {
                errors.put("general","");
            }
            else if (EDIT_TIME_WINDOW.equals(policy) && timeWindow <= 0) {
                errors.put("timeWindow","");
            }
        }
        // If no errors, continue:
        if (errors.size() == 0) {
            JiveGlobals.setJiveProperty(EDIT_POLICY_PROP_NAME,policy);
            if (EDIT_TIME_WINDOW.equals(policy)) {
                JiveGlobals.setJiveProperty(TIME_WINDOW_PROP_NAME, ""+timeWindow);
            }
            // DOne, so redirect
            response.sendRedirect("edit-policy.jsp?success=true");
            return;
        }
    }

    // Set default policy if policy isn't picked
    if (policy == null) {
        policy = JiveGlobals.getJiveProperty(EDIT_POLICY_PROP_NAME);
        if (policy == null) {
            policy = DEFAULT_EDIT_POLICY;
        }
    }
    if (EDIT_TIME_WINDOW.equals(policy)) {
        try {
            timeWindow = Integer.parseInt(JiveGlobals.getJiveProperty(TIME_WINDOW_PROP_NAME));
        }
        catch (Exception ignored) {}
    }
%>

<%@ include file="header.jsp" %>

<p>

<%  // Title of this page and breadcrumbs
    String title = "Message Edit Policy";
    String[][] breadcrumbs = {
        {"Main", "main.jsp"},
        {title, "edit-policy.jsp"}
    };
%>
<%@ include file="title.jsp" %>

Use the form below to update the policy for editing messages.

<p>
<b>Change Edit Policy</b>
</p>

<%  if ("true".equals(request.getParameter("success"))) { %>

    <p class="jive-success-text">
    Settings updated.
    </p>

<%  } %>

<%  if (errors.get("general") != null) { %>

    <p class="jive-error-text">
    Please choose a valid edit policy.
    </p>

<%  } %>

<form action="edit-policy.jsp" name="f">

<ul>
    <table cellpadding="3" cellspacing="0" border="0">
    <tr>
        <td>
            <input type="radio" name="policy" value="<%= EDIT_ALWAYS %>" id="rb01"
             <%= ((EDIT_ALWAYS.equals(policy)) ? "checked" : "") %>>
        </td>
        <td>
            <label for="rb01">Users can always edit their messages.</label>
        </td>
    </tr>
    <tr>
        <td>
            <input type="radio" name="policy" value="<%= EDIT_WHEN_NO_REPLIES %>" id="rb03"
             <%= ((EDIT_WHEN_NO_REPLIES.equals(policy)) ? "checked" : "") %>>
        </td>
        <td>
            <label for="rb03">Users can edit their message as long as their are no replies to it.</label>
        </td>
    </tr>
    <tr>
        <td>
            <input type="radio" name="policy" value="<%= EDIT_TIME_WINDOW %>" id="rb02"
             onfocus="this.form.timeWindow.focus();"
             <%= ((EDIT_TIME_WINDOW.equals(policy)) ? "checked" : "") %>>
        </td>
        <td>
            <label for="rb02">
            Users may edit their posts but only for a specific amount of time
            after posting a message.
            </label>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td>
            <%  if (errors.get("timeWindow") != null) { %>

                <span class="jive-error-text">
                Please enter at least 1 minute.
                </span><br>

            <%  } %>

            <input type="text" name="timeWindow" size="5" maxlength="10"
             value="<%= ((EDIT_TIME_WINDOW.equals(policy) && timeWindow > 0) ? ""+timeWindow : "") %>"
             onclick="this.form.policy[2].checked=true;"
             > (in minutes)
        </td>
    </tr>
    <tr>
        <td>
            <input type="radio" name="policy" value="<%= EDIT_NEVER %>" id="rb04"
             <%= ((EDIT_NEVER.equals(policy)) ? "checked" : "") %>>
        </td>
        <td>
            <label for="rb04">Users are never allowed to edit their messages.</label>
        </td>
    </tr>
    </table>

    <br>
    <input type="submit" name="update" value="Update">
</ul>

</form>

<%@ include file="footer.jsp" %>
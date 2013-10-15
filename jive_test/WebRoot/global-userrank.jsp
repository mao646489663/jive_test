<%--
  - $RCSfile: global-userrank.jsp,v $
  - $Revision: 1.3 $
  - $Date: 2003/05/27 21:28:20 $
  -
  - Copyright (C) 1999-2003 Jive Software. All rights reserved.
  -
  - This software is the proprietary information of Jive Software.  Use is subject to license terms.
--%>

<%@ page import="com.jivesoftware.base.User,
                 com.jivesoftware.forum.ForumFactory,
                 com.jivesoftware.forum.action.QuestionAction" %>

<%! // Variables and methods for user ranks

    // Definition of the ranks
    int numRanks = 10;

    int[] rankMins = {
        100, 200, 300, 400
    };

    String _path = "/images/resources/";
    String[] rankImages = {
        _path + "propeller-32x32.gif",
        _path + "jester-32x32.gif",
        _path + "graduation-32x32.gif",
        _path + "crown-32x32.gif"
        /*
        _path + "propeller-32x32.gif",
        _path + "jester-32x32.gif",
        _path + "baseball-32x32.gif",
        _path + "graduation-32x32.gif",
        _path + "beret-32x32.gif",
        _path + "tophat-32x32.gif",
        _path + "crown-32x32.gif",
        _path + "wizard-32x32.gif",
        _path + "brain-32x32.gif",
        _path + "key-32x32.gif"
        */
    };

    String[] rankNames = {
        "Enthusiast", "Aficionado", "Scholar", "Master"
        /*
        "Enthusiast", "Aficionado", "Connoisseur", "Scholar", "Expert",
        "Virtuoso", "Master", "Merlin", "Savant", "Honorary Citrite"
        */
    };

    // Number of questions asked, number of posts made and number of points earned
    int getUserScore(ForumFactory forumFactory, User user) {
        // Number of user message posts:
        int posts = forumFactory.getUserMessageCount(user);
        // Number of reward points *earned*
        int pointsEarned = forumFactory.getRewardManager().getPointsEarned(user);
        // Number of questions asked:
        int questionCount = 0;
        try {
            questionCount = Integer.parseInt(user.getProperty(QuestionAction.USER_QUESTION_COUNT));
        }
        catch (Exception ignored) {}
        // Return the score as the sum of all of these numbers:
        return (posts + pointsEarned + questionCount);
    }

    String getRankName(int index) {
        if (index > -1 && index < numRanks) {
            return rankNames[index];
        }
        return null;
    }

    String getRankImage(int index) {
        if (index > -1 && index < numRanks) {
            return rankImages[index];
        }
        return null;
    }

    // Returns the index in the rank arrays that correspond to the user score
    int getRankIndex(int score) {
        int index = -1;
        for (int i=0; i<rankMins.length; i++) {
            if (score >= rankMins[i]) {
                index = i;
            }
            else {
                break;
            }
        }
        return index;
    }
%>
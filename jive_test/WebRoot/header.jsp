<%--
  -
  - $RCSfile: header.jsp,v $
  - $Revision: 1.21.2.1 $
  - $Date: 2003/06/17 16:36:32 $
  -
--%>

<%@ page import="com.jivesoftware.base.JiveGlobals,
                 java.util.*"
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

<%@ taglib uri="jivetags" prefix="jive" %>

<%@ include file="title.jsp" %>

<html>
<head>
    <%-- The "title" variable below comes from the title.jsp page --%>
    <title><%= title %></title>
    <meta http-equiv="content-type" content="text/html; charset=<%= JiveGlobals.getCharacterEncoding() %>">
    <link rel="stylesheet" type="text/css" href="style.jsp" />
    <link rel="stylesheet" href="layout/style.css" type="text/css" />
<link href="http://fonts.googleapis.com/css?family=PT+Sans:400,700" rel="stylesheet" type="text/css" />
<link href="http://fonts.googleapis.com/css?family=PT+Sans+Narrow:400,700" rel="stylesheet" type="text/css" />
<link href="http://fonts.googleapis.com/css?family=Droid+Serif:400,400italic" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="layout/js/jquery.js"></script>

<!-- PrettyPhoto start -->
<link rel="stylesheet" href="layout/plugins/prettyphoto/css/prettyPhoto.css" type="text/css" />
<script type="text/javascript" src="layout/plugins/prettyphoto/jquery.prettyPhoto.js"></script>
<!-- PrettyPhoto end -->

<!-- jQuery tools start -->
<script type="text/javascript" src="layout/plugins/tools/jquery.tools.min.js"></script>
<!-- jQuery tools end -->

<!-- Calendar start -->
<link rel="stylesheet" href="layout/plugins/calendar/calendar.css" type="text/css" />
<script type="text/javascript" src="layout/plugins/calendar/calendar.js"></script>
<!-- Calendar end -->

<!-- ScrollTo start -->
<script type="text/javascript" src="layout/plugins/scrollto/jquery.scroll.to.min.js"></script>
<!-- ScrollTo end -->

<!-- MediaElements start -->
<link rel="stylesheet" href="layout/plugins/video-audio/mediaelementplayer.css" />
<script src="layout/plugins/video-audio/mediaelement-and-player.js"></script>
<!-- MediaElements end -->

<!-- FlexSlider start -->
<link rel="stylesheet" href="layout/plugins/flexslider/flexslider.css" type="text/css" />
<script type="text/javascript" src="layout/plugins/flexslider/jquery.flexslider-min.js"></script>
<!-- FlexSlider end -->

<!-- iButtons start -->
<link rel="stylesheet" href="layout/plugins/ibuttons/css/jquery.ibutton.css" type="text/css" />
<script type="text/javascript" src="layout/plugins/ibuttons/lib/jquery.ibutton.min.js"></script>
<!-- iButtons end -->

<!-- jQuery Form Plugin start -->
<script type="text/javascript" src="layout/plugins/ajaxform/jquery.form.js"></script>
<!-- jQuery Form Plugin end -->

<script type="text/javascript" src="layout/js/main.js"></script>

<script type="text/javascript">
	jQuery(function () {
	});
</script>
</head>

<body>

<div class="jive-header">
	
		<header>
            <div id="header">
            	<section class="top">
                	<div class="inner">
                    	<div class="fl">
                        	<div class="block_top_menu">
                            	<ul>
                                	<li class="current"><a href="index.html">Home</a></li>
                                    <li><a href="#">Site Map</a></li>
                                    <li><a href="typography.html">Typography</a></li>
                                    <li><a href="contact.html">Contact</a></li>
                                </ul>
                            </div>
                        </div>
                        
                        <div class="fr">
                        	<div class="block_top_menu">
                            	<ul>
                                	<li class="current"><a href="#login" class="open_popup">Login</a></li>
                                    <li><a href="registration.html">Registration</a></li>
                                    <li><a href="#">Subscribe</a></li>
                                </ul>
                            </div>
                            
                            <div class="block_social_top">
                            	<ul>
                                	<li><a href="#" class="fb">Facebook</a></li>
                                    <li><a href="#" class="tw">Twitter</a></li>
                                    <li><a href="#" class="rss">RSS</a></li>
                                </ul>
                            </div>
                        </div>
                        
                    	<div class="clearboth"></div>
                    </div>
                </section>
                
            	<section class="bottom">
                	<div class="inner">
                    	<div id="logo_top"><a href="index.html"><img src="images/logo_top.png" alt="BusinessNews" title="BusinessNews" /></a></div>
                        
                        <div class="block_today_date">
                        	<div class="num"><p id="num_top" /></div>
                            <div class="other">
                            	<p class="month_year"><span id="month_top"></span>, <span id="year_top"></span></p>
                                <p id="day_top" class="day" />
                            </div>
                        </div>
                        
                        <div class="fr">
                        	<div class="block_languages">
                            	<div class="text"><p>Language:</p></div>
                                <ul>
                                	<li class="current"><a href="#" class="eng">English</a></li>
                                    <li><a href="#" class="french">French</a></li>
                                    <li><a href="#" class="ger">German</a></li>
                                </ul>
                                
                                <div class="clearboth"></div>
                            </div>
                            
                            <div class="block_search_top">
                            	<form action="#" />
                                	<div class="field"><input type="text" class="w_def_text" title="Enter Your Email Addres" /></div>
                                    <input type="submit" class="button" value="Search" />
                                    
                                    <div class="clearboth"></div>
                                </form>
                            </div>
                        </div>
                        
                        <div class="clearboth"></div>
                    </div>
                </section>
                
                <section class="section_main_menu">
                	<div class="inner">
                    	<nav class="main_menu">
                        	<ul>
								<li class="current_page_item"><a href="index.html">Home</a>
                                	
                                    <ul>
                                    	<li><a href="index.html">Home Page Style 1</a></li>
                                        <li><a href="home_style_2.html">Home Page Style 2</a></li>
                                    </ul>
                                </li>
							  	<li class="big_dropdown" data-content="business"><a href="business.html">Business</a></li>
							  	<li class="big_dropdown" data-content="technology"><a href="technology.html">Technology</a></li>
							  	<li class="big_dropdown" data-content="education"><a href="education.html">Education</a></li>
							  	<li><a href="media.html">Media</a>
                                	
                                    <ul>
                                    	<li><a href="media.html">Media</a></li>
                                        <li><a href="media_item.html">Media Item Page</a></li>
                                    </ul>
                                </li>
							  	<li><a href="#">Pages</a>
                                	
                                    <ul>
                                    	<li><a href="about.html">About Us</a></li>
                                        <li><a href="about_author.html">About Author Page</a></li>
                                        <li><a href="contact.html">Contact Us</a></li>
                                        <li><a href="registration.html">Registration Page</a></li>
                                        <li><a href="main_news.html">Main News Page</a></li>
                                        <li><a href="news_post_w_slider.html">News Post With Slider</a></li>
                                        <li><a href="news_post_w_video.html">News Post With Video</a></li>
                                    </ul>
                                </li>
							  	<li><a href="blog.html">Blog</a>
                                	
                                    <ul>
                                    	<li><a href="blog.html">Our Blog Style 1</a></li>
                                        <li><a href="blog_style_2.html">Our Blog Style 2</a></li>
                                        <li><a href="blog_post.html">Blog Post Page</a></li>
                                        <li><a href="blog_post_w_slider.html">Post With Slider</a></li>
                                        <li><a href="blog_post_w_video.html">Post With Video</a></li>
                                    </ul>
                                </li>
		  		  		  		<li><a href="typography.html">Shortcodes</a>
                                	
                                    <ul>
                                    	<li><a href="accordion.html">Accordeon</a></li>
                                        <li><a href="blockquote.html">Blockquote</a></li>
                                        <li><a href="table.html">Table</a></li>
                                        <li><a href="columns.html">Columns</a></li>
                                        <li><a href="pricing_table.html">Pricing Table</a></li>
                                        <li><a href="testimonials.html">Testimonials</a></li>
                                        <li><a href="boxes.html">Info Boxes</a></li>
                                        <li><a href="dropcaps.html">Dropcaps</a></li>
                                        <li><a href="tabs.html">Tabs</a></li>
                                        <li><a href="lists.html">List Slyle</a></li>
                                        <li><a href="buttons.html">Buttons</a></li>
                                        <li><a href="video.html">Video</a></li>
                                        <li><a href="typography.html">Typography</a></li>
                                    </ul>
								</li>
						  </ul>
						</nav>
                    </div>
                </section>
                
                <section class="section_big_dropdown">
                	<div class="inner">
                    	<div class="block_big_dropdown" data-menu="business">
                        	<div class="content">
                            	<div class="image">
                                	<a href="blog_post.html" class="pic"><img src="images/pic_big_drop_3.jpg" alt="" /></a>
                                    <p><a href="blog_post.html">Embarrassing hidden in the middleany thing</a></p>
                                </div>
                                <div class="line"></div>
                                
                                <div class="image">
                                	<a href="blog_post.html" class="pic"><img src="images/pic_big_drop_4.jpg" alt="" /></a>
                                    <p><a href="blog_post.html">Content of a page when looking.</a></p>
                                </div>
                                <div class="line"></div>
                                
                                <div class="popular_posts">
                                	<div class="title"><p>Popular Posts</p></div>
                                    <ul>
                                    	<li><a href="blog_post.html"><span>11 July, 2012</span>Established fact that a reader.</a></li>
                                        <li><a href="blog_post_w_slider.html"><span>08 July, 2012</span>Editors now use as their default model text.</a></li>
                                        <li><a href="blog_post_w_video.html"><span>05 July, 2012</span>Embarrassing hidden in the middle.</a></li>
                                        <li><a href="blog_post.html"><span>01 July, 2012</span>Anything embarrassing hidden in the middl.</a></li>
                                    </ul>
                                </div>
                                <div class="line"></div>
                                
                                <div class="more">
                                	<div class="title"><p>More In Business</p></div>
                                    <ul>
                                    	<li><a href="#">Business</a></li>
                                        <li><a href="#">Money</a></li>
                                        <li><a href="#">Isnvestor Programs</a></li>
                                        <li><a href="#">Banks</a></li>
                                    </ul>
                                </div>
                                
                                <div class="clearboth"></div>
                            </div>
                        </div>
                        
                        <div class="block_big_dropdown" data-menu="technology">
                        	<div class="content">
                            	<div class="image">
                                	<a href="blog_post.html" class="pic"><img src="images/pic_big_drop_5.jpg" alt="" /></a>
                                    <p><a href="blog_post.html">Simply dummy text of the printing.</a></p>
                                </div>
                                <div class="line"></div>
                                
                                <div class="image">
                                	<a href="blog_post.html" class="pic"><img src="images/pic_big_drop_6.jpg" alt="" /></a>
                                    <p><a href="blog_post.html">Internet tend to repeat predefined chunks.</a></p>
                                </div>
                                <div class="line"></div>
                                
                                <div class="popular_posts">
                                	<div class="title"><p>Popular Posts</p></div>
                                    <ul>
                                    	<li><a href="blog_post.html"><span>11 July, 2012</span>Publishing packages and web page</a></li>
                                        <li><a href="blog_post_w_slider.html"><span>08 July, 2012</span>Generators on the Internet tend to repeat.</a></li>
                                        <li><a href="blog_post_w_video.html"><span>05 July, 2012</span>Anything embarrassing hidden in the middle.</a></li>
                                        <li><a href="blog_post.html"><span>01 July, 2012</span>Words which don't look even slightly.</a></li>
                                    </ul>
                                </div>
                                <div class="line"></div>
                                
                                <div class="more">
                                	<div class="title"><p>More In Tech</p></div>
                                    <ul>
                                    	<li><a href="#">Web Development</a></li>
                                        <li><a href="#">Programming</a></li>
                                        <li><a href="#">Techique</a></li>
                                        <li><a href="#">Cars</a></li>
                                    </ul>
                                </div>
                                
                                <div class="clearboth"></div>
                            </div>
                        </div>
                        
                    	<div class="block_big_dropdown" data-menu="education">
                        	<div class="content">
                            	<div class="image">
                                	<a href="blog_post.html" class="pic"><img src="images/pic_big_drop_1.jpg" alt="" /></a>
                                    <p><a href="blog_post.html">Many desktop packages and web page editors.</a></p>
                                </div>
                                <div class="line"></div>
                                
                                <div class="image">
                                	<a href="blog_post.html" class="pic"><img src="images/pic_big_drop_2.jpg" alt="" /></a>
                                    <p><a href="blog_post.html">There are many variations passages</a></p>
                                </div>
                                <div class="line"></div>
                                
                                <div class="popular_posts">
                                	<div class="title"><p>Popular Posts</p></div>
                                    <ul>
                                    	<li><a href="blog_post.html"><span>11 July, 2012</span>Many desktop publishing packages and web page</a></li>
                                        <li><a href="blog_post_w_slider.html"><span>08 July, 2012</span>Randomised words which don't look even.</a></li>
                                        <li><a href="blog_post_w_video.html"><span>05 July, 2012</span>Anything embarrassing hidden in the middle.</a></li>
                                        <li><a href="blog_post.html"><span>01 July, 2012</span>Established fact that a reader.</a></li>
                                    </ul>
                                </div>
                                <div class="line"></div>
                                
                                <div class="more">
                                	<div class="title"><p>More In Education</p></div>
                                    <ul>
                                    	<li><a href="#">High school</a></li>
                                        <li><a href="#">Univercity</a></li>
                                        <li><a href="#">College</a></li>
                                        <li><a href="#">Students</a></li>
                                    </ul>
                                </div>
                                
                                <div class="clearboth"></div>
                            </div>
                        </div>
                    </div>
              	</section>
                
                <section class="section_secondary_menu">
                	<div class="inner">
                    	<nav class="secondary_menu">
                        	<ul>
                            	<li><a href="main_news_europe.html">Europe</a></li>
                                <li><a href="main_news_usa.html">USA</a></li>
                                <li><a href="main_news_m_east.html">Middle East</a></li>
                                <li><a href="main_news_money.html">Money</a></li>
                                <li><a href="main_news_science.html">Science and IT</a></li>
                                <li><a href="main_news_culture.html">Culture</a></li>
                                <li><a href="main_news_top.html">Top News</a></li>
                          	</ul>
                        </nav>
                        
                        <div class="block_clock">
                        	<p>Time: <span id="time"></span></p>
                        </div>
                    </div>
                </section>
            </div>
        </header>
    	<!-- HEADER END -->
    	
</div>

<br>
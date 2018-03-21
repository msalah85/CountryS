<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="sys_Default"
    EnableTheming="false" EnableViewState="false" ViewStateMode="Disabled" EnableSessionState="ReadOnly" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login - Basher Systems</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta charset="utf-8" />
    <meta name="description" content="Country Sea login" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
    <link rel="stylesheet" href="/Content/sys/assets/css/bootstrap.css" />
    <link rel="stylesheet" href="/Content/sys/assets/css/font-awesome.css" />
    <link rel="stylesheet" href="/Content/sys/assets/css/ace-fonts.css" />
    <link rel="stylesheet" href="/Content/sys/assets/css/ace.css" />
    <link rel="stylesheet" href="/Content/sys/assets/css/jquery.gritter.css" />
    <link href="/Scripts/smoke/css/smoke.min.css" rel="stylesheet" />
    <!--[if lte IE 9]>
			<link rel="stylesheet" href="/Content/sys/assets/css/ace-part2.css" />
		<![endif]-->
    <!--[if lte IE 9]>
		  <link rel="stylesheet" href="/Content/sys/assets/css/ace-ie.css" />
		<![endif]-->
    <!--[if lt IE 9]>
		<script src="/Content/sys/assets/js/html5shiv.js"></script>
		<script src="/Content/sys/assets/js/respond.js"></script>
	<![endif]-->
</head>
<body class="login-layout blur-login">
    <div class="main-container">
        <div class="main-content">
            <div class="row">
                <div class="col-sm-10 col-sm-offset-1">
                    <div class="login-container">
                        <div class="center">
                            <h1>
                                <i class="ace-icon fa fa-th green"></i>
                                <span class="red">Basher</span>
                                <span class="white" id="id-text2">Systems</span>
                            </h1>
                            <h4 class="light-blue" id="id-company-text">&copy; Country Sea</h4>
                        </div>
                        <div class="space-6"></div>
                        <div class="position-relative">
                            <div id="login-box" class="login-box visible widget-box no-border">
                                <div class="widget-body">
                                    <div class="widget-main">
                                        <h4 class="header blue lighter bigger">
                                            <i class="ace-icon fa fa-coffee green"></i>
                                            Please Enter Your Information
                                        </h4>
                                        <div class="space-6"></div>
                                        <form>
                                            <fieldset>
                                                <label class="block clearfix">
                                                    <span class="block input-icon input-icon-right">
                                                        <input type="text" class="form-control" placeholder="Username" value="admin" id="userName" />
                                                        <i class="ace-icon fa fa-user"></i>
                                                    </span>
                                                </label>

                                                <label class="block clearfix">
                                                    <span class="block input-icon input-icon-right">
                                                        <input type="password" class="form-control" placeholder="Password" value="admin" id="passWord" />
                                                        <i class="ace-icon fa fa-lock"></i>
                                                    </span>
                                                </label>
                                                <div class="space"></div>
                                                <div class="clearfix">
                                                    <label class="inline">
                                                        <input type="checkbox" class="ace" />
                                                        <span class="lbl">Remember Me</span>
                                                    </label>
                                                    <button type="button" class="width-35 pull-right btn btn-sm btn-primary" id="loginBtn">
                                                        <i class="ace-icon fa fa-key"></i>
                                                        <span class="bigger-110">Login</span>
                                                    </button>
                                                </div>
                                                <div class="space-4"></div>
                                            </fieldset>
                                        </form>
                                    </div>
                                    <!-- /.widget-main -->
                                    <div class="toolbar clearfix">
                                    </div>
                                </div>
                                <!-- /.widget-body -->
                            </div>
                            <!-- /.login-box -->

                            <div id="forgot-box" class="forgot-box widget-box no-border">
                                <div class="widget-body">
                                    <div class="widget-main">
                                        <h4 class="header red lighter bigger">
                                            <i class="ace-icon fa fa-key"></i>
                                            Retrieve Password
                                        </h4>
                                        <div class="space-6"></div>
                                        <p>
                                            Enter your email and to receive instructions
                                        </p>
                                        <form>
                                            <fieldset>
                                                <label class="block clearfix">
                                                    <span class="block input-icon input-icon-right">
                                                        <input type="email" class="form-control" placeholder="Email" />
                                                        <i class="ace-icon fa fa-envelope"></i>
                                                    </span>
                                                </label>

                                                <div class="clearfix">
                                                    <button type="button" class="width-35 pull-right btn btn-sm btn-danger" id="SendMebtn">
                                                        <i class="ace-icon fa fa-lightbulb-o"></i>
                                                        <span class="bigger-110">Send Me!</span>
                                                    </button>
                                                </div>
                                            </fieldset>
                                        </form>
                                    </div>
                                    <!-- /.widget-main -->
                                    <div class="toolbar center">
                                        <a href="#" data-target="#login-box" class="back-to-login-link">Back to login
												<i class="ace-icon fa fa-arrow-right"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="navbar-fixed-top align-right">
                            <br />
                            &nbsp;
								<a id="btn-login-dark" href="#">Dark</a>
                            &nbsp;
								<span class="blue">/</span>
                            &nbsp;
								<a id="btn-login-blur" href="#">Blur</a>
                            &nbsp;
								<span class="blue">/</span>
                            &nbsp;
								<a id="btn-login-light" href="#">Light</a>
                            &nbsp; &nbsp; &nbsp;
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--[if !IE]> -->
    <script src="/Content/sys/assets/js/jquery.js"></script>
    <!-- <![endif]-->
    <!--[if IE]>
    <script src="/Content/sys/assets/js/jquery1x.js"></script>
    <![endif]-->
    <script type="text/javascript">
        if ('ontouchstart' in document.documentElement) document.write("<script src='/Content/assets/js/jquery.mobile.custom.js'>" + "<" + "/script>");
    </script>
    <script src="/Scripts/smoke/js/smoke.min.js"></script>
    <script src="/Scripts/sys/login.min.js"></script>
    <script src="/Content/sys/assets/js/ace/ace.js"></script>
    <script src="/Content/sys/assets/js/ace-extra.js"></script>
    <script src="/Content/sys/assets/js/jquery.gritter.js"></script>
    <script src="/Scripts/sys/DataService.min.js?v=1.30"></script>
    <script src="/Scripts/sys/Common.min.js?v=1.30"></script>
    <script src="/Scripts/sys/defaultPage.min.js"></script>
</body>
</html>

<%@ Page Title="Country Sea System" Language="C#" MasterPageFile="master.master" AutoEventWireup="true" CodeFile="home.aspx.cs" Inherits="sys_home"
    EnableTheming="false" EnableViewState="false" ViewStateMode="Disabled" EnableSessionState="ReadOnly" %>

<%@ Register Src="UserControls/PageSettings.ascx" TagPrefix="uc1" TagName="PageSettings" %>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="breadcrumbs ace-save-state" id="breadcrumbs">
        <ul class="breadcrumb">
            <li>
                <i class="ace-icon fa fa-home home-icon"></i>
                <a>Home</a>
            </li>
            <li class="active">Dashboard</li>
        </ul>
    </div>
    <div class="page-content">
        <uc1:PageSettings runat="server" ID="PageSettings" />
        <div class="page-header">
            <h1>Dashboard</h1>
        </div>
        <div class="row">
            <div class="col-xs-12">
                <div class="alert alert-block alert-success">
                    <strong>Welcome</strong> To Country Sea MANAGEMENT SYSTEM
                   <button type="button" class="close" data-dismiss="alert"><i class="ace-icon fa fa-times"></i></button>
                </div>
            </div>
        </div>
        <div class="" id="main-widget-container">
            <div class="row">
                <div class="col-xs-12 col-sm-6 widget-container-col" id="widget-container-col-2">
                    <div class="widget-box widget-color-pink" id="widget-box-2">
                        <div class="widget-header">
                            <h5 class="widget-title bigger lighter">
                                <i class="ace-icon fa fa-search"></i>
                                Search Invoices
                            </h5>
                            <div class="widget-toolbar widget-toolbar-light no-border">
                                <select class="hide colorpicker">
                                    <option data-class="blue" value="#307ECC">#307ECC</option>
                                    <option data-class="blue2" value="#5090C1">#5090C1</option>
                                    <option data-class="blue3" value="#6379AA">#6379AA</option>
                                    <option data-class="green" value="#82AF6F">#82AF6F</option>
                                    <option data-class="green2" value="#2E8965">#2E8965</option>
                                    <option data-class="green3" value="#5FBC47">#5FBC47</option>
                                    <option data-class="red" value="#E2755F">#E2755F</option>
                                    <option data-class="red2" value="#E04141">#E04141</option>
                                    <option data-class="red3" value="#D15B47">#D15B47</option>
                                    <option data-class="orange" value="#FFC657">#FFC657</option>
                                    <option data-class="purple" value="#7E6EB0">#7E6EB0</option>
                                    <option selected="" data-class="pink" value="#CE6F9E">#CE6F9E</option>
                                    <option data-class="dark" value="#404040">#404040</option>
                                    <option data-class="grey" value="#848484">#848484</option>
                                    <option data-class="default" value="#EEE">#EEE</option>
                                </select>
                            </div>
                        </div>
                        <div class="widget-body">
                            <div class="widget-main">
                                <form action="InvoicePrint.aspx">
                                    <div>
                                        <label for="key">Search By</label>
                                        <select class="form-control" id="key" name="key">
                                            <option value="InvoiceID">Invoice No</option>
                                            <option value="DeclarationNo">Declaration No</option>
                                            <option value="ContainerNo">Container No</option>
                                        </select>
                                    </div>
                                    <hr />
                                    <div>
                                        <label for="no">Enter No.</label>
                                        <div class="input-group">
                                            <input type="text" required class="form-control required" id="no" name="no" />
                                            <div class="input-group-btn">
                                                <button type="submit" class="btn btn-pink btn-sm">
                                                    <span class="ace-icon fa fa-search icon-on-right bigger-110"></span>
                                                    Search
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xs-12 col-sm-6 widget-container-col">
                    <div class="widget-box widget-color-purple">
                        <div class="widget-header">
                            <h5 class="widget-title bigger lighter">
                                <i class="ace-icon fa fa-user"></i>
                                Search Clients Balances
                            </h5>
                            <div class="widget-toolbar widget-toolbar-light no-border">
                                <select class="hide colorpicker">
                                    <option data-class="blue" value="#307ECC">#307ECC</option>
                                    <option data-class="blue2" value="#5090C1">#5090C1</option>
                                    <option data-class="blue3" value="#6379AA">#6379AA</option>
                                    <option data-class="green" value="#82AF6F">#82AF6F</option>
                                    <option data-class="green2" value="#2E8965">#2E8965</option>
                                    <option data-class="green3" value="#5FBC47">#5FBC47</option>
                                    <option data-class="red" value="#E2755F">#E2755F</option>
                                    <option data-class="red2" value="#E04141">#E04141</option>
                                    <option data-class="red3" value="#D15B47">#D15B47</option>
                                    <option data-class="orange" value="#FFC657">#FFC657</option>
                                    <option selected="" data-class="purple" value="#7E6EB0">#7E6EB0</option>
                                    <option data-class="pink" value="#CE6F9E">#CE6F9E</option>
                                    <option data-class="dark" value="#404040">#404040</option>
                                    <option data-class="grey" value="#848484">#848484</option>
                                    <option data-class="default" value="#EEE">#EEE</option>
                                </select>
                            </div>
                        </div>
                        <div class="widget-body">
                            <div class="widget-main">
                                <form action="ClientSummary.aspx">
                                    <div>
                                        <label for="id">Select a client:</label>
                                        <select class="select2 col-lg-12 col-xs-12 col-sm-12 select-client-id" required name="clientid" data-fn-name="Clients_GetNames" data-placeholder="Select a client" data-allow-clear="true"></select>
                                    </div>
                                    <hr class="space-30" />
                                    <div class="center">
                                        <button type="button" class="btn btn-white btn-pink btn-xlg btn-client-details">
                                            <span class="ace-icon fa fa-search icon-on-right bigger-110"></span>
                                            Details
                                        </button>
                                        <button type="submit" class="btn btn-white btn-purple btn-xlg">
                                            <span class="ace-icon fa fa-search icon-on-right bigger-110 btn-client-summary"></span>
                                            Summary
                                        </button>
                                        <button type="button" class="btn btn-white btn-green btn-xlg btn-client-statement">
                                            <span class="ace-icon fa fa-search icon-on-right bigger-110"></span>
                                            Statement
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
    <link href="/Scripts/select2/select2.min.css" rel="stylesheet" />
    <link href="/Scripts/select2/select2-optional.min.css" rel="stylesheet" />
    <script src="/Scripts/select2/select2.min.js"></script>
    <script src="/Scripts/lz-string/lz-string.min.js"></script>
    <script src="/Scripts/sys/jquery.xml2json.min.js"></script>
    <script src="/Scripts/sys/DataService.min.js?v=1.30"></script>
    <script src="/Scripts/sys/Common.min.js?v=1.30"></script>
    <script src="/Scripts/select2/select2-optinal.min.js"></script>
    <script src="/Scripts/sys/home-manager.min.js"></script>
</asp:Content>

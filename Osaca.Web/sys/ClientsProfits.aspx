<%@ Page Title="Customers Profit" Language="C#" MasterPageFile="~/sys/master.master" AutoEventWireup="true" EnableTheming="false" EnableViewState="false" ViewStateMode="Disabled" EnableSessionState="ReadOnly" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="/Scripts/sys/jquery-dateFormat.min.js"></script>
    <script src="/Scripts/sys/Common.min.js?v=1.2"></script>
    <script src="/Scripts/sys/DataService.min.js?v=1.30"></script>
    <script src="/Scripts/sys/DefaultGridVariables.min.js?v=1.30"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="breadcrumbs ace-save-state hidden-print" id="breadcrumbs">
        <ul class="breadcrumb">
            <li>
                <i class="ace-icon fa fa-home home-icon"></i>
                <a href="home">Home</a>
            </li>
            <li class="active">Customers profits</li>
        </ul>
    </div>
    <div class="page-content">
        <div class="page-header">
            <h1>Customers Profits</h1>
        </div>
        <div class="space-6"></div>
        <div class="row hidden-print">
            <div class="col-sm-10 col-sm-offset-1">
                <form role="form" class="form-horizontal">
                    <div class="col-xs-10">
                        <div class="form-group">
                            <label class="col-sm-3 control-label no-padding-right" for="From">Date from-to</label><div class="col-sm-9">
                                <input type="text" id="From" class="required date-picker col-sm-4" data-date-format="dd-mm-yyyy" placeholder="dd-mm-yyyy" />
                                <input type="text" id="To" class="required date-picker col-sm-4" data-date-format="dd-mm-yyyy" placeholder="dd-mm-yyyy" />
                                <button id="btnSearch" class="btn btn-info btn-sm" type="button"><i class="ace-icon fa fa-search bigger-110"></i>Search </button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        <div class="row" id="masterForm">
            <div class="col-sm-10 col-sm-offset-1">
                <div class="widget-box transparent">
                    <div class="widget-header widget-header-large">
                        <h3 class="widget-title grey lighter">
                            <i class="ace-icon fa fa-th green"></i>
                            Customers Profits
                        </h3>
                        <div class="widget-toolbar no-border invoice-info">
                            <span class="invoice-info-label">Date:</span>
                            <span class="blue" id="AddDate"></span>
                        </div>
                        <div class="widget-toolbar hidden-480 hidden-print">
                            <a href="javascript:void(0);" id="printMe">
                                <i class="ace-icon fa fa-print fa-2x"></i>
                            </a>
                        </div>
                    </div>
                    <div class="widget-body">
                        <div class="widget-main padding-24">
                            <div>
                                <table class="table table-striped table-bordered listItems">
                                    <thead>
                                        <tr>
                                            <th class="center">#</th>
                                            <th>Customer</th>                                            
                                            <th>Profit <sub>AED</sub></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td colspan="5">There is no data for this client</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="hr hr8 hr-double hr-dotted"></div>
                            <div class="row">
                                <div class="col-sm-6 pull-left hidden-print"></div>
                                <div class="col-sm-6 pull-right">
                                    <h4>Total profit : <span class="red FinalBalance">0</span> <sub>AED</sub></h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="/Scripts/sys/jquery.xml2json.min.js"></script>
    <script src="/Scripts/sys/numeral.min.js"></script>
    <script src="/Scripts/sys/clientsProfits.js?v=1.30"></script>
    <script>pageManager.Init();</script>
</asp:Content>

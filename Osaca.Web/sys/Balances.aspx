<%@ Page Title="Company Balances" Language="C#" MasterPageFile="master.master" AutoEventWireup="true" CodeFile="Balances.aspx.cs" Inherits="sys_Balances" %>

<%@ Register Src="UserControls/PageSettings.ascx" TagPrefix="uc1" TagName="PageSettings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="/Scripts/sys/jquery-dateFormat.min.js"></script>
    <script src="/Scripts/sys/Common.min.js?v=1.30"></script>
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
            <li class="active">Company Balances</li>
        </ul>
    </div>
    <div class="page-content">
        <div class="page-header">
            <h1>Country Sea Balance</h1>
        </div>
        <div class="space-6"></div>
        <div class="row" id="masterForm">
            <div class="col-sm-10 col-sm-offset-1">
                <div class="widget-box transparent">
                    <div class="widget-header widget-header-large">
                        <h3 class="widget-title grey lighter">
                            <i class="ace-icon fa fa-th green"></i>
                            Balance
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
                                            <th>Type</th>
                                            <th>Value <sub>AED</sub></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td class="center">1</td>
                                            <td>Total invoices</td>
                                            <td id="TotalInvoices">0</td>
                                        </tr>
                                        <tr>
                                            <td class="center">2</td>
                                            <td>Total payments</td>
                                            <td id="TotalPayments">0</td>
                                        </tr>
                                        <tr>
                                            <td class="center">3</td>
                                            <td>Trans/Driver fees</td>
                                            <td id="TransFees">0</td>
                                        </tr>
                                        <tr>
                                            <td class="center">4</td>
                                            <td>Trans/Driver payments</td>
                                            <td id="TransPayments">0</td>
                                        </tr>
                                        <tr class="info">
                                            <td class="center">5</td>
                                            <td>Total profit</td>
                                            <td id="Profit">0</td>
                                        </tr>
                                        <tr class="warning" title="Company expenses">
                                            <td class="center">6</td>
                                            <td>Outgoings</td>
                                            <td id="Outgoings">0</td>
                                        </tr>
                                        <tr class="success">
                                            <td class="center">7</td>
                                            <td>Net profit</td>
                                            <td id="NetProfit">0</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="hr hr8 hr-double hr-dotted"></div>
                            <div class="row">
                                <div class="col-sm-6 pull-right">
                                    <h4 title="Balance = Total Payments - Total Invoices">Clients due amount : <span class="red" id="TotalBalances">0</span> <sub>AED</sub>
                                    </h4>
                                </div>
                                <div class="col-sm-6 pull-left">
                                    <h4 title="Trans. fees = Total Trans. fees - Total Trans. payments">Transportation fees amount : <span class="red" id="TransTotalFees">0</span> <sub>AED</sub>
                                    </h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="/Scripts/sys/jquery.xml2json.min.js?v=1.30"></script>
    <script src="/Scripts/sys/numeral.min.js?v=1.30"></script>
    <script src="/Scripts/sys/balances.min.js?v=1.30"></script>
    <script>pageManager.Init();</script>
</asp:Content>

<%@ Page Title="Print Invoice" Language="C#" MasterPageFile="master.master" AutoEventWireup="true" CodeFile="InvoicePrint.aspx.cs" Inherits="sys_InvoicePrint" EnableTheming="false" EnableViewState="false" ViewStateMode="Disabled" EnableSessionState="ReadOnly" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="/Scripts/sys/jquery-dateFormat.min.js"></script>
    <script src="/Scripts/sys/Common.min.js?v=1.30"></script>
    <script src="/Scripts/sys/DataService.min.js?v=1.30"></script>
    <script src="/Scripts/sys/DefaultGridVariables.min.js?v=1.30"></script>
    <style>
        body .page-content::before {
            content: url(/Content/sys/assets/images/CargoLogo.png);
            display: none;
        }

        @media print {
            .arrowed-right.arrowed-in {
                padding: 10px 0;
                height: auto !important;
                width: 100%;
            }

            b {
                font-family: sans-serif;
            }

            .action-buttons, .page-header {
                display: none;
            }

            body .page-content::before {
                display: block;
                height: 90px;
            }

            #water-mark img {
                margin-left: 1em !important;
            }

            ul.list-unstyled {
                columns: 2;
                -webkit-columns: 2;
                -moz-columns: 2;
            }
        }

         ul.list-unstyled {
                columns: 2;
                -webkit-columns: 2;
                -moz-columns: 2;
            }

        #water-mark {
            position: absolute;
            z-index: 0;
            display: block;
            opacity: 0.15;
        }

            #water-mark img {
                min-height: 300px;
                min-width: 600px;
                margin-left: 15em;
            }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="breadcrumbs ace-save-state hidden-print" id="breadcrumbs">
        <ul class="breadcrumb">
            <li>
                <i class="ace-icon fa fa-home home-icon"></i>
                <a href="home">Home</a>
            </li>
            <li class="active">Print Invoice</li>
        </ul>
    </div>
    <div class="page-content">
        <div class="page-header">
            <h1>Country Sea Clearing & Forwarding L.L.C</h1>
        </div>
        <div class="space-6"></div>
        <div class="row" id="masterForm">
            <div class="col-sm-10 col-sm-offset-1">
                <div class="widget-box transparent">
                    <div class="widget-header widget-header-large">
                        <h3 class="widget-title grey lighter">
                            <i class="ace-icon fa fa-th green"></i>
                            Tax Invoice
                        </h3>
                        <div class="widget-toolbar no-border invoice-info">
                            <span class="invoice-info-label">Invoice:</span>
                            #<span id="InvoiceID" class="red"></span>
                            <br />
                            <span class="invoice-info-label">Date:</span>
                            <span class="blue date" id="AddDate"></span>
                        </div>
                        <div class="widget-toolbar hidden-480 hidden-print">
                            <a href="javascript:void(0);" id="printMe" title="Print">
                                <i class="ace-icon fa fa-print fa-2x"></i>
                            </a>
                        </div>
                    </div>
                    <div class="widget-body">
                        <div class="widget-main padding-24">
                            <div class="row">
                                <div class="col-sm-6">
                                    <div class="row">
                                        <div class="col-xs-11 label label-lg label-info arrowed-in arrowed-right">
                                            <b>Country Sea Clearing & Forwarding L.L.C</b>
                                        </div>
                                    </div>
                                    <div>
                                        <ul class="list-unstyled">
                                            <li>
                                                <i class="ace-icon fa fa-caret-right blue"></i>
                                                Dubai, United Arab Emirates
                                            </li>
                                            <li>
                                                <i class="ace-icon fa fa-caret-right blue"></i>
                                                Mobile: <b class="red">+971 4 385 7012, +971 55 713 6363</b>
                                            </li>
                                            <li>
                                                <i class="ace-icon fa fa-caret-right blue"></i>
                                                Email: <b class="blue">HANGUWAL@YAHOO.COM</b>
                                            </li>
                                            <li>
                                                <i class="ace-icon fa fa-caret-right blue"></i>
                                                TRN: <b class="blue" id="Val"></b>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="row">
                                        <div class="col-xs-11 label label-lg label-success arrowed-in arrowed-right">
                                            <b>Customer:  <span id="ClientName"></span></b>
                                        </div>
                                    </div>
                                    <div>
                                        <ul class="list-unstyled">
                                            <li>
                                                <i class="ace-icon fa fa-caret-right green"></i>
                                                Container no: <span class="bolder" id="ContainerNo"></span>
                                            </li>
                                            <li>
                                                <i class="ace-icon fa fa-caret-right green"></i>
                                                Declaration no: <span class="bolder" id="DeclarationNo"></span>
                                            </li>
                                            <li>
                                                <i class="ace-icon fa fa-caret-right green"></i>
                                                Bill of entry date: <span class="bolder date" id="BillOfEntryDate"></span>
                                            </li>
                                            <li>
                                                <i class="ace-icon fa fa-caret-right green"></i>
                                                Customer TRN: <span class="bolder" id="ClientTRN"></span>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div id="water-mark">
                                <img src="/content/sys/assets/images/CargoLogo.png" />
                            </div>
                            <div class="space"></div>
                            <h4>Paymant Info</h4>
                            <table class="table table-striped table-bordered listItems">
                                <thead>
                                    <tr>
                                        <th class="center">#</th>
                                        <th>Expense name</th>
                                        <th>Amount</th>
                                        <th>VAT Amount</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                                <tfoot>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td style="background-color: #e7f2f8" id="tdTotalAmount"></td>
                                        <td style="background-color: #e7f2f8" id="tdVatAmount"></td>
                                    </tr>
                                </tfoot>
                            </table>
                            <div class="hr hr8 hr-double hr-dotted"></div>
                            <div class="row">
                                <div class="col-sm-5 pull-right">
                                    <h4 class="pull-right">Total amount : <span class="red" id="TotalAmount">0</span>
                                    </h4>
                                </div>
                                <div class="col-sm-7 pull-left"></div>
                            </div>
                            <div class="space-6"></div>
                            <div class="well">Thank you for choosing Country Sea. We believe you will be satisfied by our services.</div>
                            <p id="Notes"></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="/Scripts/sys/jquery.xml2json.min.js"></script>
    <script src="/Scripts/sys/numeral.min.js"></script>
    <%--<script src="/Scripts/sys/InvoicesPrint.min.js?v=1.30"></script>--%>
    <script src="/Scripts/sys/InvoicesPrint.js"></script>
    <script>pageManager.Init();</script>
</asp:Content>

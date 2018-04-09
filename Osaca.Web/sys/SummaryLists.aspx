<%@ Page Title="Summary" Language="C#" MasterPageFile="master.master" AutoEventWireup="true"
    EnableTheming="false" EnableViewState="false" ViewStateMode="Disabled" EnableSessionState="ReadOnly" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/Scripts/select2/select2.css" rel="stylesheet" />
    <link href="/Scripts/select2/select2-optional.css" rel="stylesheet" />
    <script src="/Scripts/sys/Common.min.js?v=1.30"></script>
    <script src="/Scripts/sys/DataService.min.js?v=1.30"></script>
    <script src="/Scripts/sys/DefaultGridVariables.min.js?v=1.30"></script>
    <script src="/content/sys/assets/js/jquery.validate.js"></script>
    <script src="/content/sys/assets/js/additional-methods.min.js"></script>
    <script src="../Content/sys/assets/js/jquery-ui.js"></script>
    <link href="../Content/sys/assets/css/jquery-ui.min.css" rel="stylesheet" />

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style>
        #ui-id-2 {
            height: 500px;
        }
        @media print {
            .arrowed-right.arrowed-in {
                padding: 10px 0;
                height: auto !important;
                width: 100%;
            }
        }
    </style>
    <div class="breadcrumbs ace-save-state" id="breadcrumbs">
        <ul class="breadcrumb">
            <li>
                <i class="ace-icon fa fa-home home-icon"></i>
                <a href="home">Home</a>
            </li>
            <li class="active">Finance</li>
        </ul>
    </div>
    <div class="page-content">
        <div class="page-header">
            <%--<h1>Vat Reports</h1>--%>
        </div>
        <!-- search box -->
        <div class="row">
            <form class="form-horizontal" role="form" id="masterForm">
                <div class="col-xs-12 col-md-12">
                    <div class="form-group">
                        <label class="col-sm-4 control-label no-padding-right" for="AddDate">Date from-to</label>
                        <div class="col-sm-6">
                            <input type="text" id="DateFrom" class="required col-md-4 col-xs-10 date-picker inline" data-date-format="dd-mm-yyyy" placeholder="dd-mm-yyyy" />
                            <input type="text" id="DateTo" class="required col-md-4 col-xs-10 date-picker inline" data-date-format="dd-mm-yyyy" placeholder="dd-mm-yyyy" />
                            <button id="btnSearch" class="btn btn-info btn-sm" type="button">
                                <i class="ace-icon fa fa-search bigger-110"></i>
                                Search
                            </button>
                        </div>
                        <div class="widget-toolbar hidden-480 hidden-print">
                            <a href="javascript:void(0);" id="printMe" title="Print">
                                <i class="ace-icon fa fa-print fa-2x"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </form>
        </div>
         <div class="hr hr-24"></div>
        <div class="row">

            <table class="table table-bordered table-condensed center">
                <tr class="table-header">
                    <td>Total Invoices</td>
                    <td>Total Payments</td>
                    <td>Profit</td>
                    <td>Outgoings</td>
                    <td>Transformers Fees</td>
                    <td>Transformers Payments</td>
                    <td>Cran Fees</td>
                    <td>Can Payments</td>
                </tr>
                <tr>
                    <td id="SpTotalInvoices"></td>
                    <td id="SpTotalPayments"></td>
                    <td id="SPProfit"></td>
                    <td id="SPOutgoings"></td>
                    <td id="SpTransFees"></td>
                    <td id="SpTransPayments"></td>
                    <td id="SPCranFees"></td>
                    <td id="SPCranPayments"></td>
                </tr>
            </table>

        </div>



        <div class="hr hr-24"></div>


        <div id="accordion">
            <h3>Clients Summary</h3>
            <div>

                <div class="row">
                    <div class="col-xs-12 widget-container-col">
                        <div class="widget-box widget-color-blue" id="widget-box-2">
                            <div class="widget-header">
                                <h5 class="widget-title bigger lighter">
                                    <i class="ace-icon fa fa-table"></i>
                                    Clients Summary
                                </h5>
                                <div class="widget-toolbar">
                                    <a href="#" data-action="fullscreen" class="white">
                                        <i class="1 ace-icon fa fa-expand bigger-125"></i>
                                    </a>
                                </div>
                            </div>
                            <div class="widget-body">
                                <div class="widget-main no-padding">
                                    <table id="ClientsGrid" class="table table-striped table-bordered table-hover">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Name</th>
                                                <th>Total Invoices</th>
                                                <th>Total Payments</th>
                                                <th>Due Amount</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                        <tfoot>
                                            <tr style="background-color:#dff0d8;color:#3c763d">
                                                <td></td>
                                                <td></td>
                                                <td id="ClientSumInvoices"></td>
                                                <td id="ClientSumPayments"></td>
                                                <td id="ClientSumAmountDue"></td>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>


            </div>
            <h3>Transporters Summary</h3>
            <div>
                <div class="row">
                    <div class="col-xs-12 widget-container-col">
                        <div class="widget-box widget-color-blue">
                            <div class="widget-header">
                                <h5 class="widget-title bigger lighter">
                                    <i class="ace-icon fa fa-table"></i>
                                    Transporters Summary
                                </h5>
                                <div class="widget-toolbar">
                                    <a href="#" data-action="fullscreen" class="white">
                                        <i class="1 ace-icon fa fa-expand bigger-125"></i>
                                    </a>
                                </div>
                            </div>
                            <div class="widget-body">
                                <div class="widget-main no-padding">
                                    <table id="TransportersGrid" class="table table-striped table-bordered table-hover">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Full Name</th>
                                                <th>Total Amount</th>
                                                <th>Total Payments</th>
                                                <th>Due Amount</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                         <tfoot>
                                            <tr style="background-color:#dff0d8;color:#3c763d">
                                                <td></td>
                                                <td></td>
                                                <td id="TransSumInvoices"></td>
                                                <td id="TransSumPayments"></td>
                                                <td id="TransSumAmountDue"></td>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
            <h3>Crange/Charge</h3>
            <div>

                <div class="row">
                    <div class="col-xs-12 widget-container-col">
                        <div class="widget-box widget-color-blue">
                            <div class="widget-header">
                                <h5 class="widget-title bigger lighter">
                                    <i class="ace-icon fa fa-table"></i>
                                    Crange/Charge
                                </h5>
                                <div class="widget-toolbar">
                                    <a href="#" data-action="fullscreen" class="white">
                                        <i class="1 ace-icon fa fa-expand bigger-125"></i>
                                    </a>
                                </div>
                            </div>
                            <div class="widget-body">
                                <div class="widget-main no-padding">
                                    <table id="CrangeGrid" class="table table-striped table-bordered table-hover">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Full Name</th>
                                                <th>Total Amount</th>
                                                <th>Total Payments</th>
                                                <th>Due Amount</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                        
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>


            </div>
            <h3>Outgoings</h3>
            <div>

                <div class="row">
                    <div class="col-xs-12 widget-container-col">
                        <div class="widget-box widget-color-blue">
                            <div class="widget-header">
                                <h5 class="widget-title bigger lighter">
                                    <i class="ace-icon fa fa-table"></i>
                                    Outgoings
                                </h5>
                                <div class="widget-toolbar">
                                    <a href="#" data-action="fullscreen" class="white">
                                        <i class="1 ace-icon fa fa-expand bigger-125"></i>
                                    </a>
                                </div>
                            </div>
                            <div class="widget-body">
                                <div class="widget-main no-padding">
                                    <table id="OutgoingsGrid" class="table table-striped table-bordered table-hover">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Expenses Type Name</th>
                                                <th>Total Amount</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                        <tfoot>
                                            <tr style="background-color:#dff0d8;color:#3c763d">
                                                <td></td>
                                                <td></td>
                                                <td id="OutSumAmount"></td>
                                            </tr>
                                        </tfoot>
                                    </table>
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
     <script src="../Scripts/lodash.core.js?v=1.50"></script>
    <script src="/Scripts/lz-string/lz-string.min.js"></script>
    <script src="/Scripts/sys/DataGridFilter.js"></script>
    <script src="/Scripts/sys/SummaryList.js?v=1.50"></script>
    <script src="/Scripts/select2/select2.min.js"></script>
    <script src="/Scripts/select2/select2-optinal.min.js"></script>
    <style>
        #masterForm .form-group {
            margin-bottom: 5px;
        }

        .hr-24 {
            margin-top: 7px;
        }
    </style>
</asp:Content>

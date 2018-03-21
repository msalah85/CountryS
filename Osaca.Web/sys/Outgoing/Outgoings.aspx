<%@ Page Title="Outgoings" Language="C#" MasterPageFile="../master.master" AutoEventWireup="true"
    EnableTheming="false" EnableViewState="false" ViewStateMode="Disabled" EnableSessionState="ReadOnly" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/Scripts/select2/select2.css" rel="stylesheet" />
    <link href="/Scripts/select2/select2-optional.css" rel="stylesheet" />
    <script src="/Scripts/sys/Common.min.js?v=1.30"></script>
    <script src="/Scripts/sys/DataService.min.js?v=1.30"></script>
    <script src="/Scripts/sys/DefaultGridVariables.min.js?v=1.30"></script>
    <script src="/content/sys/assets/js/jquery.validate.js"></script>
    <script src="/content/sys/assets/js/additional-methods.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="breadcrumbs ace-save-state" id="breadcrumbs">
        <ul class="breadcrumb">
            <li>
                <i class="ace-icon fa fa-home home-icon"></i>
                <a href="home">Home</a>
            </li>
            <li class="active">Outgoings</li>
        </ul>
    </div>
    <div class="page-content">
        <div class="page-header">
            <h1>Outgoings Manager</h1>
        </div>


                <!-- search box -->
                <div class="row">
                    <form class="form-horizontal" role="form" id="masterForm">
                        <div class="col-xs-12 col-md-4">
                            <div class="form-group">
                                <label class="col-sm-3 control-label no-padding-right" for="ExpenseTypeID">Search by Type</label>
                                <div class="col-sm-9">
                                    <select id="ExpenseTypeID" name="ExpenseTypeID" class="form-control required col-xs-12 col-sm-10 select2"
                                        data-placeholder="Choose type..." data-allow-clear="true" data-fn-name="ExpenseTypes_Select2">
                                        <option></option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-12 col-md-6">
                            <div class="form-group">
                                <label class="col-sm-3 control-label no-padding-right" for="AddDate">Date from-to</label>
                                <div class="col-sm-9">
                                    <input type="text" id="DateFrom" class="required col-md-4 col-xs-10 date-picker inline" data-date-format="dd-mm-yyyy" placeholder="dd-mm-yyyy" />
                                    <input type="text" id="DateTo" class="required col-md-4 col-xs-10 date-picker inline" data-date-format="dd-mm-yyyy" placeholder="dd-mm-yyyy" />
                                    <button id="btnSearch" class="btn btn-info btn-sm" type="button">
                                        <i class="ace-icon fa fa-search bigger-110"></i>
                                        Search
                                    </button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="hr hr-24"></div>
                <div class="row">
                    <div class="col-xs-12 widget-container-col">
                        <div class="clearfix">
                            <a role="button" href="outgoing/outgoingsaddedit.aspx" class="btn btn-white btn-warning btn-bold"
                                tabindex="0" title="Add new"><i class="fa fa-plus bigger-110"></i>Add new</a>
                            <div class="pull-right tableTools-container"></div>
                        </div>
                        <div class="widget-box widget-color-blue" id="widget-box-2">
                            <div class="widget-header">
                                <h5 class="widget-title bigger lighter">
                                    <i class="ace-icon fa fa-table"></i>
                                    Outgoings List
                                </h5>
                                <div class="widget-toolbar">
                                    <a href="#" data-action="fullscreen" class="white">
                                        <i class="1 ace-icon fa fa-expand bigger-125"></i>
                                    </a>
                                </div>
                            </div>
                            <div class="widget-body">
                                <div class="widget-main no-padding">
                                    <table id="listItems" class="table table-striped table-bordered table-hover">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Date</th>
                                                <th>Expense Type</th>
                                                <th>Ref. No.</th>
                                                <th>Notes</th>
                                                <th>VAT(5%)</th>
                                                <th>Amount</th>
                                                <th width="99px" class="hidden-print"></th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                        <tfoot>
                                            <tr>
                                                <td colspan="5"><span class="pull-right">Total</span></td>
                                                <td class="totalVat bolder"></td>
                                                <td class="totalCharge bolder"></td>
                                                <td></td>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div id="deleteModal" class="modal fade" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header no-padding">
                                        <div class="table-header">
                                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                                                <span class="white">&times;</span>
                                            </button>
                                            Delete item
                                        </div>
                                    </div>
                                    <div class="modal-body">
                                        <div class="row">
                                            <div class="col-xs-12 col-sm-12">
                                                <form action="#" class="form-horizontal" id="removeForm">
                                                    <label id="Label2">Are you sure to delete the selected item (<label class="removeField"></label>)?</label>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer no-margin-top">
                                        <button class="btn btn-sm btn-primary btn-delete" id="btnDelete">
                                            <i class="ace-icon fa fa-check"></i>
                                            Delete
                                        </button>
                                        <button class="btn btn-sm btn-danger" data-dismiss="modal">
                                            <i class="ace-icon fa fa-times"></i>
                                            Cancel
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>



    </div>
    <script src="/Scripts/sys/jquery.xml2json.min.js"></script>
    <script src="/Scripts/sys/numeral.min.js"></script>
    <script src="/Scripts/lz-string/lz-string.min.js"></script>
    <script src="/Scripts/sys/DefaultGridFilterManager.js?v=1.4"></script>
    <%--<script src="/Scripts/sys/Outgoing/Outgoings.min.js?v=1.31"></script>--%>
    <script src="/Scripts/sys/Outgoing/Outgoings.js"></script>
    <script src="/Scripts/select2/select2.min.js"></script>
    <script src="/Scripts/select2/select2-optinal.min.js"></script>
    <style>
        #masterForm .form-group {
            margin-bottom: 5px;
        }

        .hr-24 {
            margin-top: 7px
        }
    </style>
</asp:Content>

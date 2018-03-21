<%@ Page Title="Client Payments" Language="C#" MasterPageFile="master.master" AutoEventWireup="true" CodeFile="ClientPayments.aspx.cs" Inherits="sys_ClientPayments" EnableTheming="false" EnableViewState="false" ViewStateMode="Disabled" EnableSessionState="ReadOnly" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="/Scripts/sys/DataService.min.js?v=1.30"></script>
    <script src="/Scripts/sys/moment.min.js"></script>
    <script src="/Scripts/sys/Common.min.js?v=1.1"></script>
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
            <li class="active">Client Payments</li>
        </ul>
    </div>
    <div class="page-content">
        <div class="page-header">
            <h1>Client Payments Manager</h1>
        </div>
        <!-- search box -->
        <div class="row">
            <form class="form-horizontal" role="form" id="masterForm">
                <div class="col-xs-12 col-md-6">
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="ClientID">Search by Customer</label>
                        <div class="col-sm-9">
                            <select class="select2 form-control txtSearch" name="clientid" data-fn-name="Clients_GetNames" data-placeholder="Select a customer" data-allow-clear="true"></select>
                        </div>
                    </div>
                </div>
                <div class="col-xs-12 col-md-6">
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="AddDate">Date from-to</label>
                        <div class="col-sm-9">
                            <input type="text" id="DateFrom" class="required col-md-4 col-xs-10 date-picker inline" data-date-format="dd-mm-yyyy" placeholder="dd-mm-yyyy" />
                            <input type="text" id="DateTo" class="required col-md-4 col-xs-10 date-picker inline" data-date-format="dd-mm-yyyy" placeholder="dd-mm-yyyy" />
                            <button type="submit" id="btnSearch" class="btn btn-info btn-sm btnSearch">
                                <i class="ace-icon fa fa-search bigger-110"></i>
                                Search
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
        <!--END SEARCH BOX -->

        <div class="row">
            <div class="col-xs-12 widget-container-col">
                <div class="clearfix">
                    <div class="col-xs-2">
                        <a role="button" href="#addModal" data-toggle="modal" class="btn btn-white btn-warning btn-bold"
                            tabindex="0" title="Add new"><i class="fa fa-plus bigger-110"></i>Add new</a>
                    </div>
                    <%--                    <div class="col-xs-4">
                        <form role="form">
                            <div class="input-group">
                                <span class="input-group-addon info">Client</span>
                                <select class="select2 form-control txtSearch" name="clientid" data-fn-name="Clients_GetNames" data-placeholder="Select a client" data-allow-clear="true"></select>
                                <div class="input-group-btn">
                                    <button type="submit" class="btn btn-sm btn-info2 btnSearch">Search</button>
                                </div>
                            </div>
                        </form>
                    </div>--%>
                    <div class="pull-right tableTools-container"></div>
                </div>
                <div class="widget-box widget-color-blue" id="widget-box-2">
                    <div class="widget-header">
                        <h5 class="widget-title bigger lighter">
                            <i class="ace-icon fa fa-table"></i>
                            Client Payments List
                        </h5>
                        <div class="widget-toolbar">
                            <a href="#fullscreen" data-action="fullscreen" class="white">
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
                                        <th>Client</th>
                                        <th>Date</th>
                                        <th class="hidden-480">Amount <sub>AED</sub></th>
                                        <th>Check No</th>
                                        <th>Bank</th>
                                        <th width="77px"></th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                            <div class="add-print">
                                <table class="table">
                                    <tbody>
                                        <tr class="info">
                                            <td width="40%"><strong class="pull-right">Total:</strong></td>
                                            <td><strong class="totalPayments blue">0</strong>
                                                AED</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="addModal" class="modal fade" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header no-padding">
                                <div class="table-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                                        <span class="white">&times;</span>
                                    </button>
                                    Add/Edit Client Payment
                                </div>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-xs-12 col-sm-12">
                                        <form class="form-horizontal" role="form" id="aspnetForm">
                                            <div>
                                                <input type="hidden" id="PaymentID" value="0" />
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label no-padding-right" for="ClientID">Client name <span class="text-danger">*</span></label>
                                                <div class="col-sm-9">
                                                    <select class="col-sm-10 required" required id="ClientID" name="ClientID">
                                                        <option></option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label no-padding-right" for="AddDate">Date <span class="text-danger">*</span></label>
                                                <div class="col-sm-9">
                                                    <input type="text" class="col-sm-10 date-picker" data-date-format="dd-mm-yyyy" required id="AddDate" name="AddDate" placeholder="dd-mm-yyyy" />
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label no-padding-right" for="PaymentAmount">Amount <span class="text-danger">*</span></label>
                                                <div class="col-sm-9">
                                                    <input type="text" class="col-sm-10 money" id="PaymentAmount" name="PaymentAmount" required placeholder="00.00" />
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label no-padding-right" for="BankID">Bank <span class="text-info">(optional)</span></label>
                                                <div class="col-sm-9">
                                                    <select class="col-sm-10" id="BankID" name="BankID">
                                                        <option></option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label no-padding-right" for="CheckNo">Check No. <span class="text-info">(optional)</span></label>
                                                <div class="col-sm-9">
                                                    <input type="text" class="col-sm-10" id="CheckNo" name="CheckNo" />
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer no-margin-top">
                                <button class="btn btn-sm btn-primary" id="btnSave">
                                    <i class="ace-icon fa fa-check"></i>
                                    Save
                                </button>
                                <button class="btn btn-sm btn-danger" data-dismiss="modal">
                                    <i class="ace-icon fa fa-times"></i>
                                    Close
                                </button>
                            </div>
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
    <script src="/Scripts/sys/DefaultGridFilterManager.min.js?v=1.30"></script>
    <link href="/Scripts/select2/select2.min.css" rel="stylesheet" />
    <link href="/Scripts/select2/select2-optional.min.css" rel="stylesheet" />
    <script src="/Scripts/select2/select2.min.js"></script>
    <script src="/Scripts/lz-string/lz-string.min.js"></script>
    <script src="/Scripts/select2/select2-optinal.min.js"></script>
    <script src="/Scripts/sys/client-payments.min.js?v=1.28"></script>
    <style>
        #aspnetForm .select2, #aspnetForm .select2-container {
            width: 83% !important;
        }
    </style>
</asp:Content>

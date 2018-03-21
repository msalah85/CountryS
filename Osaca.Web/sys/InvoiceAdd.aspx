<%@ Page Title="Add/Edit Invoice" Language="C#" MasterPageFile="master.master" AutoEventWireup="true" CodeFile="InvoiceAdd.aspx.cs" Inherits="sys_InvoiceAdd" EnableTheming="false" EnableViewState="false" ViewStateMode="Disabled" EnableSessionState="ReadOnly" %>

<%@ Register Src="UserControls/PageSettings.ascx" TagPrefix="uc1" TagName="PageSettings" %>
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
            <li class="active">Add Invoice</li>
        </ul>
    </div>
    <div class="page-content">
        <div class="page-header">
            <h1>Add Invoice</h1>
        </div>
        <form class="form-horizontal" role="form" id="masterForm">
            <div class="col-xs-12 col-md-6">
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="ClientID">Customer <span class="text-danger">*</span></label>
                    <div class="col-sm-9">
                        <input type="hidden" id="InvoiceID" value="0" />
                        <select id="ClientID" class="form-control required col-xs-10 col-sm-10" required data-placeholder="Choose a customer...">
                            <option></option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="AddDate">Date <span class="text-danger">*</span></label>
                    <div class="col-sm-9">
                        <input type="text" id="AddDate" required class="form-control required today date-picker col-xs-10 col-sm-10" data-date-format="dd-mm-yyyy" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="BillOfEntryDate">Bill of entry date <span class="text-danger">*</span></label>
                    <div class="col-sm-9">
                        <input type="text" id="BillOfEntryDate" name="BillOfEntryDate" required class="form-control required today date-picker col-xs-10 col-sm-10" data-date-format="dd-mm-yyyy" />
                    </div>
                </div>
            </div>
            <div class="col-xs-12 col-md-6">
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="ContainerNo">Container no <span class="text-danger">*</span></label>
                    <div class="col-sm-9">
                        <input type="text" id="ContainerNo" required class="form-control required col-xs-10 col-sm-10" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="DeclarationNo">Declaration no <span class="text-danger">*</span></label>
                    <div class="col-sm-9">
                        <input type="text" id="DeclarationNo" required class="form-control required col-xs-10 col-sm-10" data-date-format="dd-mm-yyyy" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="Notes">Notes <span class="text-danger">*</span></label>
                    <div class="col-sm-9">
                        <textarea cols="12" rows="3" id="Notes" class="form-control" placeholder="Remarks..."></textarea>
                    </div>
                </div>
            </div>
        </form>
        <div class="row">
            <div class="hr hr-24 sp-hr"></div>
        </div>
        <div class="row">
            <div class="col-xs-12 widget-container-col">
                <div class="clearfix">
                    <a role="button" href="#addModal" data-toggle="modal" class="btn btn-white btn-warning btn-bold"
                        tabindex="0" title="Add new"><i class="fa fa-plus bigger-110"></i>Add expense</a>
                    <div class="pull-right tableTools-container"></div>
                </div>
                <div class="widget-box widget-color-blue" id="widget-box-2">
                    <div class="widget-header">
                        <h5 class="widget-title bigger lighter">
                            <i class="ace-icon fa fa-table"></i>
                            Expenses list
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
                                        <th class="center">#</th>
                                        <th>Expense name</th>
                                        <th>Cost</th>
                                        <th>Amount/Customer</th>
                                        <th>VAT Amount</th>
                                        <th width="97px"></th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="hr hr-18 dotted hr-double"></div>
                <div class="row">
                    <div class="col-sm-6">
                        <div class="form-group">
                            <label class="col-sm-3 control-label no-padding-right" for="TransporterID">Transporter name</label>
                            <div class="col-sm-9">
                                <select id="TransporterID" name="TransporterID" class="col-xs-10 col-sm-10 select2" data-fn-name="Users_Select2"
                                    data-placeholder="Choose a transporter name" data-allow-clear="true">
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label no-padding-right" for="TransporterID">Crane/Driver name</label>
                            <div class="col-sm-9">
                                <select id="CraneDriverID" name="CraneDriverID" class="col-xs-10 col-sm-10 select2" data-fn-name="Users_Select2"
                                    data-placeholder="Choose a crane/driver name" data-allow-clear="true">
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6 pull-right">
                        <h4 class="pull-right">Total amount : <span class="red" id="TotalAmount">0</span> AED,
                            Profit : <span class="red" id="TotalProfit">0</span> AED
                        </h4>
                    </div>
                    <div class="col-sm-7 pull-left"></div>
                </div>
                <button class="btn btn-sm pull-right btn-success hidden" id="SaveAll">
                    <i class="ace-icon fa fa-save"></i>
                    Save Invoice
                </button>
                <div id="addModal" class="modal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h4 class="blue bigger">Please fill the following expense fields</h4>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-xs-12 col-sm-12">
                                        <form class="form-horizontal" role="form" id="aspnetForm">
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label no-padding-right">Expense name <span class="text-danger">*</span></label>
                                                <div class="col-sm-9">
                                                    <select class="col-sm-10 required" required id="ExpenseID" name="ExpenseID">
                                                        <option></option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label no-padding-right" for="Amount">Cost <span class="text-danger">*</span></label>
                                                <div class="col-sm-9">
                                                    <input type="text" class="col-sm-10" id="Cost" placeholder="0.0" />
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label no-padding-right" for="Amount">Amount/Customer <span class="text-danger">*</span></label>
                                                <div class="col-sm-9">
                                                    <input type="text" class="col-sm-10" id="Amount" placeholder="0.0" />
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button class="btn btn-sm btn-primary" id="btnAddAmount">
                                    <i class="ace-icon fa fa-plus"></i>
                                    Add to list
                                </button>
                                <button class="btn btn-sm" data-dismiss="modal">
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
    <script src="/Scripts/select2/select2.min.js"></script>
    <script src="/Scripts/lz-string/lz-string.min.js"></script>
    <script src="/Scripts/select2/select2-optinal.min.js"></script>
    <script src="/Scripts/sys/InvoicesAdd.js?v=1.4"></script>
    <script>pageManager.Init();</script>
</asp:Content>

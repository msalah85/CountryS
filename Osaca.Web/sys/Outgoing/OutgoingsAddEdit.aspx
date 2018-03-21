<%@ Page Title="Add/Edit Outgoing" Language="C#" MasterPageFile="~/sys/master.master" AutoEventWireup="true" CodeFile="OutgoingsAddEdit.aspx.cs" Inherits="sys_Outgoing_OutgoingsAddEdit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/Scripts/select2/select2.min.css" rel="stylesheet" />
    <link href="/Scripts/select2/select2-optional.min.css" rel="stylesheet" />
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
            <li><a href="Outgoing/Outgoings.aspx">Outgoings</a></li>
            <li class="active"><%: Page.Title %></li>
        </ul>
    </div>
    <div class="page-content">
        <div class="page-header">
            <h1><%: Page.Title %></h1>
        </div>
        <form class="form-horizontal" role="form" id="masterForm">
            <div class="col-xs-12 col-md-6">
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="Amount">Amount <span class="text-danger">*</span></label>
                    <div class="col-sm-9 col-xs-12">
                        <input type="hidden" id="OutgoingID" value="0" />
                        <input type="number" name="Amount" id="Amount" placeholder="00.00" class="form-control required col-xs-12 col-md-10 money" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="ClientID">Outgoing type <span class="text-danger">*</span></label>
                    <div class="col-sm-9 col-xs-12">
                        <select id="ExpenseTypeID" name="ExpenseTypeID" class="form-control required col-xs-12 col-sm-10 select2"
                            required data-placeholder="Choose type..." data-allow-clear="true" data-fn-name="ExpenseTypes_Select2">
                            <option></option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="AddDate">Date <span class="text-danger">*</span></label>
                    <div class="col-sm-9 col-xs-12">
                        <input type="text" id="AddDate" name="AddDate" required class="form-control required today date-picker col-xs-12 col-md-10" data-date-format="dd-mm-yyyy" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="VAT">VAT(5%) <span class="text-danger">*</span></label>
                    <div class="col-sm-9 col-xs-12">
                        <input type="text" id="VAT" name="VAT" required class="form-control money required col-xs-12 col-md-10" placeholder="0.05" />
                    </div>
                </div>
            </div>
            <div class="col-sm-12 col-md-6">
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="ContainerNo">Ref. No.</label>
                    <div class="col-sm-9 col-xs-12">
                        <input type="text" id="RefID" class="form-control col-xs-12 col-md-10" placeholder="Reference number like 123" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="DeclarationNo">Notes</label>
                    <div class="col-sm-9 col-xs-12">
                        <textarea cols="6" rows="6" id="Notes" class="form-control col-xs-12 col-md-10" placeholder="Remarks.."></textarea>
                    </div>
                </div>
            </div>
            <div class="row hidden">
                <div class="col-md-11 col-lg-offset-1">
                    <div class="">
                        Choose receipt image:
                            <input multiple="" type="file" accept="image/*" capture class="form-control" />
                    </div>
                </div>
            </div>
        </form>
        <div class="row">
            <div class="hr hr-24 sp-hr"></div>
        </div>
        <div class="row">
            <div class="col-xs-9 widget-container-col">
                <a class="btn btn-app btn-light pull-right" href="Outgoing/Outgoings.aspx">
                    <i class="ace-icon fa fa-undo"></i>
                    Cancel
                </a>
                <button class="btn btn-app btn-success pull-right" id="SaveAll">
                    <i class="ace-icon fa fa-save"></i>
                    Save
                </button>
            </div>
        </div>
    </div>
    <script src="/Scripts/sys/jquery.xml2json.min.js"></script>
    <script src="/Scripts/sys/numeral.min.js"></script>
    <script src="/Scripts/lz-string/lz-string.min.js"></script>
    <script src="/Scripts/select2/select2.min.js"></script>
    <script src="/Scripts/select2/select2-optinal.min.js"></script>
    <script src="/Scripts/sys/Outgoing/OutgoingsAdd.min.js?v=1.26"></script>
    <script>pageManager.Init();</script>
</asp:Content>


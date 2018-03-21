<%@ Page Title="Transportation" Language="C#" MasterPageFile="master.master" AutoEventWireup="true" EnableTheming="false" EnableViewState="false" ViewStateMode="Disabled" EnableSessionState="ReadOnly" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="/Scripts/select2/select2.css" rel="stylesheet" />
    <link href="/Scripts/select2/select2-optional.css" rel="stylesheet" />
    <script src="/Scripts/sys/Common.min.js?v=1.30"></script>
    <script src="/Scripts/sys/DataService.min.js?v=1.30"></script>
    <script src="/Scripts/sys/DefaultGridVariables.min.js?v=1.30"></script>
    <script src="/content/sys/assets/js/jquery.validate.js"></script>
    <script src="/content/sys/assets/js/additional-methods.min.js"></script>
    <style>
        #masterForm .form-group {
            margin-bottom: 5px;
        }

        .hr-24 {
            margin-top: 7px
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="breadcrumbs ace-save-state" id="breadcrumbs">
        <ul class="breadcrumb">
            <li>
                <i class="ace-icon fa fa-home home-icon"></i>
                <a href="home">Home</a>
            </li>
            <li class="active head-title">Transportation Fees</li>
        </ul>
    </div>
    <div class="page-content">
        <div class="page-header">
            <h1 class="head-title">Transportation Fees</h1>
        </div>
        <!-- search box -->
        <div class="row">
            <form class="form-horizontal" role="form" id="masterForm">
                <div class="col-xs-6">
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="ClientID">Search by Consignee</label>
                        <div class="col-sm-9">
                            <input type="hidden" id="InvoiceID" value="0" />
                            <select id="Client" class="required col-xs-10 col-sm-10 select2-filter" data-placeholder="Choose one..." data-allow-clear="true">
                                <option></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="ContainerNo">Search by <span class="el-title">Transporter</span></label>
                        <div class="col-sm-9">
                            <select id="User" class="required col-xs-10 col-sm-10 select2-filter" data-placeholder="Choose one..." data-allow-clear="true">
                                <option></option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col-xs-4">
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="AddDate">Date from</label>
                        <div class="col-sm-9">
                            <input type="text" id="DateFrom" class="required date-picker col-xs-8 col-sm-8" data-date-format="dd-mm-yyyy" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label no-padding-right" for="DeclarationNo">Date to</label>
                        <div class="col-sm-9">
                            <input type="text" id="DateTo" class="required date-picker col-xs-8 col-sm-8" data-date-format="dd-mm-yyyy" />
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
        <!-- end search box -->
        <div class="row">
            <div class="col-xs-12 widget-container-col">
                <div class="clearfix">
                    <a role="button" href="#addModal" data-toggle="modal" class="btn btn-white btn-warning btn-bold"
                        tabindex="0" title="Add new"><i class="fa fa-plus bigger-110"></i>Add new</a>
                    <div class="pull-right tableTools-container"></div>
                </div>
                <div class="widget-box widget-color-blue" id="widget-box-2">
                    <div class="widget-header">
                        <h5 class="widget-title bigger lighter">
                            <i class="ace-icon fa fa-table"></i>
                            <span class="head-title">Transportation Fees</span> List
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
                                        <th>Consignee</th>
                                        <th class="el-title">Transporter</th>
                                        <th>Date</th>
                                        <th class="hidden-480">Container No</th>
                                        <th>Amount<sub>AED</sub></th>
                                        <th width="77px" class="hidden-print"></th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                                <tfoot>
                                    <tr>
                                        <td colspan="5"></td>
                                        <td class="tranCharge bolder"></td>
                                        <td></td>
                                    </tr>
                                </tfoot>
                            </table>
                            <div class="add-print">
                                <table class="table">
                                    <tr class="info">
                                        <td width="80%"><strong class="pull-right">Total fees:</strong></td>
                                        <td><span class="TotalFees">0</span> AED</td>
                                    </tr>
                                    <tr class="success">
                                        <td><strong class="pull-right">Total payments:</strong></td>
                                        <td><span class="TotalPayments">0</span> AED</td>
                                    </tr>
                                    <tr class="danger">
                                        <td><strong class="pull-right">Due amount to transporers:</strong></td>
                                        <td><span class="DueAmount">0</span> AED</td>
                                    </tr>
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
                                    Add/Edit <span class="el-title">Transporter</span> fee
                                </div>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-xs-12 col-sm-12">
                                        <form class="form-horizontal" role="form" id="aspnetForm">
                                            <div>
                                                <input type="hidden" id="TransportID" value="0" />
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label no-padding-right" for="TypeID">Type <span class="text-danger">*</span></label>
                                                <div class="col-sm-9">
                                                    <select class="col-sm-10 required" required id="TypeID" name="TypeID">
                                                        <option value="2">Transportation</option>
                                                        <option value="3">Crane fee</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label no-padding-right" for="ClientID">Consignee name <span class="text-danger">*</span></label>
                                                <div class="col-sm-9">
                                                    <select class="col-sm-10 required" required id="ConsigneeID" name="ConsigneeID">
                                                        <option></option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label no-padding-right" for="ClientID"><span class="el-title">Transporter</span> name <span class="text-danger">*</span></label>
                                                <div class="col-sm-9">
                                                    <select class="col-sm-10 required" required id="TransporterID" name="TransporterID">
                                                        <option></option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label no-padding-right" for="TransportDate">Date <span class="text-danger">*</span></label>
                                                <div class="col-sm-9">
                                                    <input type="text" class="col-sm-10 date-picker" data-date-format="dd-mm-yyyy" required id="TransportDate" name="TransportDate" placeholder="dd-mm-yyyy" />
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label no-padding-right" for="ContainerNo">Container No. <span class="text-danger">*</span></label>
                                                <div class="col-sm-9">
                                                    <input type="text" class="col-sm-10" required id="ContainerNo" name="ContainerNo" placeholder="MSKU00000" />
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-sm-3 control-label no-padding-right" for="TransportCharge">Amount <span class="text-danger">*</span></label>
                                                <div class="col-sm-9">
                                                    <input type="text" class="col-sm-10 money" id="TransportCharge" name="TransportCharge" required placeholder="00.00" />
                                                    AED
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
    <script src="/Scripts/lz-string/lz-string.min.js"></script>
    <script src="/Scripts/sys/DefaultGridFilterManager.js?v=1.4"></script>
    <script src="/Scripts/select2/select2.min.js"></script>
    <script src="/Scripts/sys/transportations.min.js?v=1.32"></script>
</asp:Content>

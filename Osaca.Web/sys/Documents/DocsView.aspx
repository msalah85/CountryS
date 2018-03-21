<%@ Page Title="Documents List" Language="C#" MasterPageFile="../master.master" AutoEventWireup="true"
    CodeFile="DocsView.aspx.cs" Inherits="sys_DocsView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
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
            <li class="active">Documents List</li>
        </ul>
    </div>
    <div class="page-content">
        <div class="page-header">
            <h1>Documents List</h1>
        </div>

        <form class="form-horizontal" role="form" id="searchForm">
            <div class="col-xs-12 col-md-6">
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="ClientID">Search By Customer</label>
                    <div class="col-sm-9">
                        <select class="select2 form-control txtSearch inline" id="ClientID" data-fn-name="Clients_GetNames" data-placeholder="Choose a customer" data-allow-clear="true"></select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="SubmissionStatus">Document status</label>
                    <div class="col-sm-9">
                        <select id="SubmissionStatus" class="inline form-control">
                            <option value="0">Documents submission pending</option>
                            <option value="1">Documents verified</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="col-xs-12 col-md-6">
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="DateFrom">Bill of date</label>
                    <div class="col-sm-9">
                        <input type="text" id="DateFrom" class="inline date-picker col-xs-3" data-date-format="dd-mm-yyyy" placeholder="dd-mm-yyyy" />
                        <input type="text" id="DateTo" class="inline date-picker col-xs-3" data-date-format="dd-mm-yyyy" placeholder="dd-mm-yyyy" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label no-padding-right" for="DateTo"></label>
                    <div class="col-sm-9">
                        <button type="submit" class="btn btn-info btn-sm btnSearch">
                            <i class="ace-icon fa fa-search bigger-110"></i>
                            Search</button>
                    </div>
                </div>
            </div>
        </form>
        <div class="row">
            <div class="col-xs-12 widget-container-col">
                <div class="clearfix">
                    <div class="col-xs-2">
                        <a role="button" href="InvoiceAdd.aspx" class="btn btn-white btn-warning btn-bold"
                            tabindex="0" title="Add new"><i class="fa fa-plus bigger-110"></i>Add new</a>
                    </div>
                    <div class="pull-right tableTools-container"></div>
                </div>
                <div class="widget-box widget-color-blue" id="widget-box-2">
                    <div class="widget-header">
                        <h5 class="widget-title bigger lighter">
                            <i class="ace-icon fa fa-table"></i>
                            Documents List
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
                                        <th>Declaration no</th>
                                        <th>Bill of entry date</th>
                                        <th>Container no</th>
                                        <th width="110px">Verify</th>
                                    </tr>
                                </thead>
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
                                    Verifying Document Submission
                                </div>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-xs-12 col-sm-12">
                                        <form action="#" class="form-horizontal" id="removeForm">
                                            <label id="Label2">Are you sure to submitted the selected document (<label class="removeField"></label>)?</label>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer no-margin-top">
                                <button class="btn btn-sm btn-primary btn-delete" id="btnDelete">
                                    <i class="ace-icon fa fa-check"></i>
                                    Verify
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
    <script src="/Scripts/Documents/Documents-list.min.js?v=1.30"></script>
</asp:Content>

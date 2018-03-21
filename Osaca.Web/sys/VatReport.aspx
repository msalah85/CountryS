<%@ Page Title="Outgoings" Language="C#" MasterPageFile="master.master" AutoEventWireup="true"
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
            <li class="active">VAT Reports</li>
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
                    </div>
                </div>
            </form>
        </div>
        <div class="row">

            <div class="col-sm-12 infobox-container">

                <div class="infobox infobox-green">
                    <div class="infobox-icon">
                        <i class="ace-icon fa fa-money"></i>
                    </div>

                    <div class="infobox-data">
                        <span class="infobox-data-number" id="TotalVatIn"></span>
                        <div class="infobox-content">Total vat in</div>
                    </div>
                </div>

                <div class="infobox infobox-blue">
                    <div class="infobox-icon">
                        <i class="ace-icon fa fa-outdent"></i>
                    </div>

                    <div class="infobox-data">
                        <span class="infobox-data-number" id="TotalVatOut"></span>
                        <div class="infobox-content">Total vat out</div>
                    </div>
                </div>

                <div class="infobox infobox-pink">
                    <div class="infobox-icon">
                        <i class="ace-icon fa fa-send-o"></i>
                    </div>

                    <div class="infobox-data">
                        <span class="infobox-data-number" id="DueVatAmount"></span>
                        <div class="infobox-content">Due vat amount</div>
                    </div>
                </div>

            </div>
        </div>

        <div class="hr hr-24"></div>

        <ul class="nav nav-tabs">
            <li class="active"><a data-toggle="tab" href="#VatIn">Vat In </a></li>
            <li><a data-toggle="tab" href="#VatOut">Vat Out</a></li>
        </ul>

        <div class="tab-content">
            <div id="VatIn" class="tab-pane fade in active">
                <div class="row">
                    <div class="col-xs-12 widget-container-col">
                        <div class="widget-box widget-color-blue" id="widget-box-2">
                            <div class="widget-header">
                                <h5 class="widget-title bigger lighter">
                                    <i class="ace-icon fa fa-table"></i>
                                    Vat In List
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
                                                <th>VAT</th>
                                                <th>Client</th>
                                                <th>TRN</th>
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
            <div id="VatOut" class="tab-pane fade">

                <div class="row">
                    <div class="col-xs-12 widget-container-col">
                        <div class="widget-box widget-color-blue" id="widget-box-VatOut">
                            <div class="widget-header">
                                <h5 class="widget-title bigger lighter">
                                    <i class="ace-icon fa fa-table"></i>
                                    Vat Out List
                                </h5>
                                <div class="widget-toolbar">
                                    <a href="#" data-action="fullscreen" class="white">
                                        <i class="1 ace-icon fa fa-expand bigger-125"></i>
                                    </a>
                                </div>
                            </div>
                            <div class="widget-body">
                                <div class="widget-main no-padding">
                                    <table id="listItemsVatOut" class="table table-striped table-bordered table-hover">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Date</th>
                                                <th>VAT</th>
                                                <th>TRN</th>
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
        </div>

    </div>
    <script src="/Scripts/sys/jquery.xml2json.min.js"></script>
    <script src="/Scripts/sys/numeral.min.js"></script>
    <script src="/Scripts/lz-string/lz-string.min.js"></script>
    <%--<script src="/Scripts/sys/dataTableCustome.js"></script>--%>
    <%--<script src="/Scripts/sys/dataTableCustome2.js"></script>--%>
     <script src="/Scripts/sys/DataGridFilter.js"></script>
    <script src="/Scripts/sys/VatReport.js"></script>
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

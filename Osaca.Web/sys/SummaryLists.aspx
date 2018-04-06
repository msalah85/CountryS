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
                    </div>
                </div>
            </form>
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
                                                <th>Date</th>
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
            <h3>Section 2</h3>
            <div>
                <p>
                    Sed non urna. Donec et ante. Phasellus eu ligula. Vestibulum sit amet
    purus. Vivamus hendrerit, dolor at aliquet laoreet, mauris turpis porttitor
    velit, faucibus interdum tellus libero ac justo. Vivamus non quam. In
    suscipit faucibus urna.
                </p>
            </div>
            <h3>Section 3</h3>
            <div>
                <p>
                    Nam enim risus, molestie et, porta ac, aliquam ac, risus. Quisque lobortis.
    Phasellus pellentesque purus in massa. Aenean in pede. Phasellus ac libero
    ac tellus pellentesque semper. Sed ac felis. Sed commodo, magna quis
    lacinia ornare, quam ante aliquam nisi, eu iaculis leo purus venenatis dui.
                </p>
                <ul>
                    <li>List item one</li>
                    <li>List item two</li>
                    <li>List item three</li>
                </ul>
            </div>
            <h3>Section 4</h3>
            <div>
                <p>
                    Cras dictum. Pellentesque habitant morbi tristique senectus et netus
    et malesuada fames ac turpis egestas. Vestibulum ante ipsum primis in
    faucibus orci luctus et ultrices posuere cubilia Curae; Aenean lacinia
    mauris vel est.
                </p>
                <p>
                    Suspendisse eu nisl. Nullam ut libero. Integer dignissim consequat lectus.
    Class aptent taciti sociosqu ad litora torquent per conubia nostra, per
    inceptos himenaeos.
                </p>
            </div>
        </div>

    </div>
    <script src="/Scripts/sys/jquery.xml2json.min.js"></script>
    <script src="/Scripts/sys/numeral.min.js"></script>
    <script src="/Scripts/lz-string/lz-string.min.js"></script>
    <script src="/Scripts/sys/DataGridFilter.js"></script>
    <script src="/Scripts/sys/SummaryList.js"></script>
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

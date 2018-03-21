var VatReportManager;
$(function () {
    pageManager.Init();
});
window.onload = function () {
    setTimeout(function () {
        var DueTototal = VatReportManager.TotalVatIn - VatReportManager.TotalVatOut;
        $("#DueVatAmount").html(numeral(DueTototal).format('0,0.00'));
    }, 500);
}
var pageManager = function () {
    VatReportManager = this;
    "use strict";
    this.TotalVatIn;
    this.TotalVatOut;
    this.VatIngridColumns = [];
    this.VatOutgridColumns = [];
    this.searchObj = { from: "", to: "" };
    this.filterNames = '';
    this.filterValues = '';

    var
        searchPrm = {
            from: '',
            to: ''
        },
        Init = function () {

            pageEvents();
            // init start and end date range
            var begin = moment().format("01-MM-YYYY"),
                end = moment().daysInMonth() + moment().format("-MM-YYYY");

            $('#DateFrom').val(begin);
            $('#DateTo').val(end);

            VatReportManager.searchObj.from = commonManger.dateFormat($('#DateFrom').val());
            VatReportManager.searchObj.to = commonManger.dateFormat($('#DateTo').val());

            VatReportManager.filterNames = 'From~To';
            VatReportManager.filterValues = $.map(VatReportManager.searchObj, function (el) { return el || '' }).join('~');

            HandelBindWithPageingvatIn();
            HandelBindWithPageingvatOut();

        },
        UpdateTotalSummary = function () {
            var DueTototal = VatReportManager.TotalVatIn - VatReportManager.TotalVatOut;
            $("#DueVatAmount").html(numeral(DueTototal).format('0,0.00'));
        },
        pageEvents = function () {
            $('#btnSearch').click(function (e) {
                e.preventDefault();

                VatReportManager.searchObj.from = commonManger.dateFormat($('#DateFrom').val());
                VatReportManager.searchObj.to = commonManger.dateFormat($('#DateTo').val());

                VatReportManager.filterNames = 'From~To';
                VatReportManager.filterValues = $.map(VatReportManager.searchObj, function (el) { return el || '' }).join('~');
                // Update VatIn Grid with new Search Model.
                DefaultGridfilterManager.updateGrid('listItems', VatReportManager.filterNames, VatReportManager.filterValues);
                // Update VatOut Grid with new Search Model.
                DefaultGridfilterManager.updateGrid('listItemsVatOut', VatReportManager.filterNames, VatReportManager.filterValues);
            });
        },
        HandelClientTRN = function (TRN) {
            if (TRN == undefined || TRN == null) { return ""; } else { return TRN }
        },
        handelVAtAmount = function (VATAmount) {
            if (VATAmount == undefined || VATAmount == null) { return "0.00"; } else { return VATAmount }
        },
        UpdateAmountDue = function () {
            var DueTototal = VatReportManager.TotalVatIn - VatReportManager.TotalVatOut;
            $("#DueVatAmount").html(numeral(DueTototal).format('0,0.00'));
        },
        HandelBindWithPageingvatIn = function () {
            VatReportManager.VatIngridColumns.push(
                {
                    "mDataProp": "InvoiceID",
                    "bSortable": true,
                    "mData": function (d) {
                        return '<a target="_blank" title="View Details" href="InvoicePrint.aspx?id=' + d.InvoiceID + '"> ' + d.InvoiceID + ' </a>';
                    }
                },
                {
                    "mDataProp": "AddDate",
                    "bSortable": true,
                    "mData": function (d) {
                        return commonManger.formatJSONDateCal(d.AddDate);
                    }
                },
                {
                    "mData": function (d) { return numeral(d.VATAmount).format('0,0.00') },
                    "bSortable": false
                }
                ,
                {
                    "mDataProp": "ClientName",
                    "bSortable": true
                }
                ,
                {
                    "mData": "ClientTRN",
                    "bSortable": false,
                    "mData": function (d) {
                        return '<td>' + HandelClientTRN(d.ClientTRN) + '</td>';
                    }
                }
            );
            DefaultGridfilterManager.Init('VatIn_SelectList', 'listItems',
                VatReportManager.VatIngridColumns, 'InvoiceID', VatReportManager.filterNames, VatReportManager.filterValues, CallBackVatInFunction);
        },
        HandelBindWithPageingvatOut = function () {
            VatReportManager.VatOutgridColumns.push({
                "mDataProp": "OutgoingID",
                "bSortable": true
            },
                {
                    "mDataProp": "AddDate",
                    "bSortable": true,
                    "mData": function (d) {
                        return commonManger.formatJSONDateCal(d.AddDate);
                    }
                },
                {
                    "mData": function (d) { return numeral(d.VAT).format('0,0.00') },
                    "bSortable": false
                },
                {
                    "mData": function (d) { return "100241525300003" },
                    "bSortable": false
                });
            DefaultGridfilterManager.Init('VatOut_SelectList', 'listItemsVatOut', VatReportManager.VatOutgridColumns, 'OutgoingID',
                VatReportManager.filterNames, VatReportManager.filterValues, CallBackVatOutFunction);
        },
        CallBackVatInFunction = function (data) {
            try {
                var data = commonManger.comp2json(data.d);
                var VatIn = data.list1.TotalVATAmount;
                if (VatIn == null || VatIn == undefined) {
                    $("#TotalVatIn").html("0.00");
                    VatReportManager.TotalVatIn = 0;
                    UpdateAmountDue();
                   
                }
                else {
                    $("#TotalVatIn").html(numeral(VatIn).format('0,0.00'));
                    VatReportManager.TotalVatIn = VatIn;
                    UpdateAmountDue();
                }
            } catch (e) {

            }
        },
        CallBackVatOutFunction = function (data) {
            try {
                var data = commonManger.comp2json(data.d);
                var VatOut = data.list1.TotalVATAmount;
                if (VatOut == null || VatOut == undefined) {
                    $("#TotalVatOut").html("0.00");
                    VatReportManager.TotalVatOut = 0;
                    UpdateAmountDue();
                }
                else {
                    $("#TotalVatOut").html(numeral(VatOut).format('0,0.00'));
                    VatReportManager.TotalVatOut = VatOut;
                    UpdateAmountDue();
                }
            } catch (e) {

            }
        }
    return {
        Init: Init
    };
}();
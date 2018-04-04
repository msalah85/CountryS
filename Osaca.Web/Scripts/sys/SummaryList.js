var SummaryListManager;
$(function () {
    SummaryManager.Init();
});

var SummaryManager = function () {
   
    SummaryListManager = this;
    "use strict";
    this.ClientGridColumns = [];
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

            SummaryListManager.searchObj.from = commonManger.dateFormat($('#DateFrom').val());
            SummaryListManager.searchObj.to = commonManger.dateFormat($('#DateTo').val());

            SummaryListManager.filterNames = 'From~To';
            SummaryListManager.filterValues = $.map(SummaryListManager.searchObj, function (el) { return el || '' }).join('~');

             BindClientsSummaryGrid();
            // HandelBindWithPageingvatOut();

        },
        UpdateTotalSummary = function () {
            var DueTototal = SummaryListManager.TotalVatIn - SummaryListManager.TotalVatOut;
            $("#DueVatAmount").html(numeral(DueTototal).format('0,0.00'));
        },
        pageEvents = function () {
            $('#btnSearch').click(function (e) {
                e.preventDefault();

                SummaryListManager.searchObj.from = commonManger.dateFormat($('#DateFrom').val());
                SummaryListManager.searchObj.to = commonManger.dateFormat($('#DateTo').val());

                SummaryListManager.filterNames = 'From~To';
                SummaryListManager.filterValues = $.map(SummaryListManager.searchObj, function (el) { return el || '' }).join('~');
                // Update Summary Grid with new Search Model.
                DefaultGridfilterManager.updateGrid('ClientsGrid', SummaryListManager.filterNames, SummaryListManager.filterValues);
                // Update VatOut Grid with new Search Model.
                //  DefaultGridfilterManager.updateGrid('listItemsVatOut', SummaryListManager.filterNames, SummaryListManager.filterValues);
            });
        },
        BindClientsSummaryGrid = function () {
            SummaryListManager.ClientGridColumns.push(
                 {
                     "mDataProp": "ClientID",
                     "bSortable": true
                 },
                {
                    "mDataProp": "ClientName",
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
                    "mData": function (d) { return numeral(d.TotalInvoices).format('0,0.00') },
                    "bSortable": false
                }
            );
            DefaultGridfilterManager.Init('ClientsSummarySelectList',
                'ClientsGrid',
                SummaryListManager.ClientGridColumns,
                'ClientID',
                SummaryListManager.filterNames,
                SummaryListManager.filterValues,
                CallBackVatInFunction);
        },
        HandelBindWithPageingvatOut = function () {
            SummaryListManager.VatOutgridColumns.push({
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
            DefaultGridfilterManager.Init('VatOut_SelectList', 'listItemsVatOut', SummaryListManager.VatOutgridColumns, 'OutgoingID',
                SummaryListManager.filterNames, SummaryListManager.filterValues, CallBackVatOutFunction);
        },
        CallBackVatInFunction = function (data) {
            try {
                var data = commonManger.comp2json(data.d);
            } catch (e) {

            }
        },
        CallBackVatOutFunction = function (data) {
            try {
                var data = commonManger.comp2json(data.d);
                var VatOut = data.list1.TotalVATAmount;
                if (VatOut == null || VatOut == undefined) {
                    $("#TotalVatOut").html("0.00");
                    SummaryListManager.TotalVatOut = 0;
                    UpdateAmountDue();
                }
                else {
                    $("#TotalVatOut").html(numeral(VatOut).format('0,0.00'));
                    SummaryListManager.TotalVatOut = VatOut;
                    UpdateAmountDue();
                }
            } catch (e) {

            }
        }
    return {
        Init: Init
    };
}();
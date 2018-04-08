var SummaryListManager;
$(function () {
    SummaryManager.Init();
});

var SummaryManager = function () {
    //"use strict";
    SummaryListManager = this;

    this.ClientGridColumns = [];

    this.TransportrsGridColumns = [];

    this.searchObj = { from: "", to: "" };
    this.filterNames = '';
    this.filterValues = '';

    var
        searchPrm = {
            from: '',
            to: ''
        },
        Init = function () {
            debugger;
            $("#ClientsGrid_wrapper").find("div").hide();
            $("#accordion").accordion({
                autoHeight: false,
                heightStyle: "content"
            });

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
            // BindTransportersSummaryGrid();

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
        CalcAmountDue = function (TotalInvoices,TotalPayments) {
            return TotalInvoices - TotalPayments;
        },
        BindClientsSummaryGrid = function () {
            SummaryListManager.ClientGridColumns.push(
                 {
                     "mDataProp": "ClientID",
                     "bSortable": false
                 },
                {
                    "mDataProp": "ClientName",
                    "bSortable": false
                },
                {
                    "mData": function (d) { return numeral(d.TotalInvoices).format('0,0.00') },
                    "bSortable": false
                },
                {
                    "mData": function (d) { return numeral(d.TotalPayments).format('0,0.00') },
                    "bSortable": false
                }
                ,
                {
                    "mData": function (d) { return numeral(CalcAmountDue(d.TotalInvoices,d.TotalPayments)).format('0,0.00') },
                    "bSortable": false
                }
            );
            DefaultGridfilterManager.Init('Summary_List',
                'ClientsGrid',
                SummaryListManager.ClientGridColumns,
                'ClientID',
                SummaryListManager.filterNames,
                SummaryListManager.filterValues,
                CallbackFunction);
        },
        CallbackFunction = function (data) {
            $("#ClientsGrid_wrapper").find("div").hide();
            try {

                var data = commonManger.comp2json(data.d);

                var rows = $(data.list1).map(function (i, v) {
                    return $('<tr><td>' + v.UserID + '</td>\
                             <td>' + v.UserFullName + '</td>\
                             <td>' + numeral(v.TotalAmount).format('0,0.00') + '</td>\
                             <td>' + numeral(v.TotalPayments).format('0,0.00') + '</td>\
                              <td>' + numeral(CalcAmountDue(v.TotalAmount , v.TotalPayments)).format('0,0.00') + '</td>\
                             </tr>');
                }).get();

                $('#TransportersGrid tbody').append(rows);


                ///
                var rows_Crange = $(data.list2).map(function (i, v) {
                    return $('<tr><td>' + v.UserID + '</td>\
                             <td>' + v.UserFullName + '</td>\
                             <td>' + numeral(v.TotalAmount).format('0,0.00') + '</td>\
                             <td>' + numeral(v.TotalPayments).format('0,0.00') + '</td>\
                             <td>' + numeral(CalcAmountDue(v.TotalAmount, v.TotalPayments)).format('0,0.00') + '</td>\
                             </tr>');
                }).get();
                $('#CrangeGrid tbody').append(rows_Crange);

                ///
                var rows_Outgoings = $(data.list3).map(function (i, v) {
                    return $('<tr><td>' + v.ExpenseTypeID + '</td>\
                             <td>' + v.ExpenseTypeName + '</td>\
                             <td>' + numeral(v.TotalAmount).format('0,0.00') + '</td>\
                             </tr>');
                }).get();
                $('#OutgoingsGrid tbody').append(rows_Outgoings);

                // bind lables.
                $("#SpTotalInvoices").html(numeral(data.list4.TotalInvoices).format('0,0.00'));
                $("#SpTotalPayments").html(numeral(data.list4.TotalPayments).format('0,0.00'));
                $("#SPProfit").html(numeral(data.list4.Profit).format('0,0.00'));


                $("#SPOutgoings").html(numeral(data.list4.Outgoings).format('0,0.00'));
                $("#SpTransFees").html(numeral(data.list4.TransFees).format('0,0.00'));
                $("#SpTransPayments").html(numeral(data.list4.TransPayments).format('0,0.00'));

                $("#SPCranFees").html(numeral(data.list4.CanFees).format('0,0.00'));
                $("#SPCranPayments").html(numeral(data.list4.CranPayments).format('0,0.00'));

            } catch (e) {

            }
        }

    return {
        Init: Init
    };
}();
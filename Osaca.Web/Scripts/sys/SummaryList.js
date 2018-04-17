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
            $("div[class='widget-header']").hide();
            $("#accordion").accordion({
                autoHeight: false,
                heightStyle: "content"
            });

            $('#printMe').click(function (e) {
                e.preventDefault();
                $("#ui-id-2").css("height", "unset");
                $("#DivDates").show();
                $("#lblPrintFrom").html($("#DateFrom").val());
                $("#lblPrintTo").html($("#DateTo").val());

                $('#sidebar').addClass('menu-min');

                $('.ui-accordion-content').show();
                $('.ui-state-active').addClass('ui-state-default').removeClass('ui-state-active');

                window.print();

                $('.ui-accordion-content').hide();
                $("#DivDates").hide();
                $("#ui-id-2").css("height", "500px;");
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
        CalcAmountDue = function (TotalInvoices, TotalPayments) {
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
                    "mData": function (d) { return numeral(CalcAmountDue(d.TotalInvoices, d.TotalPayments)).format('0,0.00') },
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
                debugger;
                var data = commonManger.comp2json(data.d);
                console.log(data);
                var rows = $(data.list1).map(function (i, v) {
                    return $('<tr><td>' + v.UserID + '</td>\
                             <td>' + v.UserFullName + '</td>\
                             <td>' + numeral(v.TotalAmount).format('0,0.00') + '</td>\
                             <td>' + numeral(v.TotalPayments).format('0,0.00') + '</td>\
                              <td>' + numeral(CalcAmountDue(v.TotalAmount, v.TotalPayments)).format('0,0.00') + '</td>\
                             </tr>');
                }).get();

                $('#TransportersGrid tbody tr').empty();
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
                $('#CrangeGrid tbody tr').empty();
                $('#CrangeGrid tbody').append(rows_Crange);

                ///
                var rows_Outgoings = $(data.list3).map(function (i, v) {
                    return $('<tr><td>' + v.ExpenseTypeID + '</td>\
                             <td>' + v.ExpenseTypeName + '</td>\
                             <td>' + numeral(v.TotalAmount).format('0,0.00') + '</td>\
                             </tr>');
                }).get();
                $('#OutgoingsGrid tbody tr').empty();
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

                // update Footers.
                UpdateClientSummaryFooter(data);
                UpdateTransSummaryFooter(data);
                UpdateCrangeSummaryFooter(data);
                UpdateOutgoingsSummaryFooter(data);

            } catch (e) {

            }
        },

        UpdateClientSummaryFooter = function (data) {
            // Update Clients Summary Footer
            var _Client_TotalInvoices = _.filter(_.map(data.list, "TotalInvoices"));
            var _Client_Payments = _.filter(_.map(data.list, "TotalPayments"));

            var FormatedAr_TotalInvoices = [];
            var FormatedAr_Payments = [];
            for (var i = 0; i < _Client_TotalInvoices.length; i++) {
                FormatedAr_TotalInvoices.push(numeral().unformat(_Client_TotalInvoices[i]) * 1);
            }
            for (var i = 0; i < _Client_Payments.length; i++) {
                FormatedAr_Payments.push(numeral().unformat(_Client_Payments[i]) * 1);
            }
            var sumTotalInvoices = _.reduce(FormatedAr_TotalInvoices, function (sum, n) {
                return sum + n;
            }, 0);
            var sumPayments = _.reduce(FormatedAr_Payments, function (sum, n) {
                return sum + n;
            }, 0);
            if (_Client_TotalInvoices.length == 1) {
                sumTotalInvoices = data.list.TotalInvoices;
                sumPayments = data.list.TotalPayments;
            }
            $("#ClientSumAmountDue").html(numeral(sumTotalInvoices - sumPayments).format('0,0.00'));
            $("#ClientSumInvoices").html(numeral(sumTotalInvoices).format('0,0.00'));
            $("#ClientSumPayments").html(numeral(sumPayments).format('0,0.00'));
        },

        UpdateTransSummaryFooter = function (data) {
            if (data.list1) {
                var _Trans_TotalInvoices = _.filter(_.map(data.list1, "TotalAmount"));
                var _Trans_Payments = _.filter(_.map(data.list1, "TotalPayments"));
                var FormatedAr_TotalInvoices = [];
                var FormatedAr_Payments = [];
                for (var i = 0; i < _Trans_TotalInvoices.length; i++) {
                    FormatedAr_TotalInvoices.push(numeral().unformat(_Trans_TotalInvoices[i]) * 1);
                }
                for (var i = 0; i < _Trans_Payments.length; i++) {
                    FormatedAr_Payments.push(numeral().unformat(_Trans_Payments[i]) * 1);
                }
                var sumTotalInvoices = _.reduce(FormatedAr_TotalInvoices, function (sum, n) {
                    return sum + n;
                }, 0);
                var sumPayments = _.reduce(FormatedAr_Payments, function (sum, n) {
                    return sum + n;
                }, 0);

                if (_Trans_TotalInvoices.length == 0) {
                    sumTotalInvoices = data.list1.TotalInvoices;
                    sumPayments = data.list1.TotalPayments;
                }

                $("#TransSumAmountDue").html(numeral(sumTotalInvoices - sumPayments).format('0,0.00'));
                $("#TransSumInvoices").html(numeral(sumTotalInvoices).format('0,0.00'));
                $("#TransSumPayments").html(numeral(sumPayments).format('0,0.00'));
            }

        },

        UpdateCrangeSummaryFooter = function (data) {
            if (data.list2) {
                var _Crane_TotalInvoices = _.filter(_.map(data.list2, "TotalAmount"));
                var _Crane_Payments = _.filter(_.map(data.list2, "TotalPayments"));
                var FormatedAr_TotalInvoices = [];
                var FormatedAr_Payments = [];
                for (var i = 0; i < _Crane_TotalInvoices.length; i++) {
                    FormatedAr_TotalInvoices.push(numeral().unformat(_Crane_TotalInvoices[i]) * 1);
                }
                for (var i = 0; i < _Crane_Payments.length; i++) {
                    FormatedAr_Payments.push(numeral().unformat(_Crane_Payments[i]) * 1);
                }
                var sumTotalInvoices = _.reduce(FormatedAr_TotalInvoices, function (sum, n) {
                    return sum + n;
                }, 0);
                var sumPayments = _.reduce(FormatedAr_Payments, function (sum, n) {
                    return sum + n;
                }, 0);

                if (_Crane_TotalInvoices.length == 0) {
                    sumTotalInvoices = data.list2.TotalAmount;
                    sumPayments = data.list2.TotalPayments;
                }

                $("#CrangeSumAmountDue").html(numeral(sumTotalInvoices - sumPayments).format('0,0.00'));
                $("#CrangeumInvoices").html(numeral(sumTotalInvoices).format('0,0.00'));
                $("#CrangeSumPayments").html(numeral(sumPayments).format('0,0.00'));
            }

        }, UpdateOutgoingsSummaryFooter = function (data) {
            if (data.list3) {
                var _Out_Payments = _.filter(_.map(data.list3, "TotalAmount"));
                var FormatedAr_TotalAmount = [];
                for (var i = 0; i < _Out_Payments.length; i++) {
                    FormatedAr_TotalAmount.push(numeral().unformat(_Out_Payments[i]) * 1);
                }
                var sumTotalInvoices = _.reduce(FormatedAr_TotalAmount, function (sum, n) {
                    return sum + n;
                }, 0);

                if (_Out_Payments.length == 0) {
                    sumTotalInvoices = data.list3.TotalAmount;
                }

                $("#OutSumAmount").html(numeral(sumTotalInvoices).format('0,0.00'));
            }
        }
    return {
        Init: Init
    };
}();
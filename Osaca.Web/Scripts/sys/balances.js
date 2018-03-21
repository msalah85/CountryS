//=======================================
// Developer: M. Salah (09-02-2016)
// Email: eng.msalah.abdullah@gmail.com
//=======================================

var
    pageManager = function () {
        "use strict";
        var Init = function () {
            getReport();

            // print report
            $('#printMe').click(function (e) {
                e.preventDefault();
                window.print();
            });
        },
            BindReportControls = function (d) {
                var xml = $.parseXML(d.d), jsn = $.xml2json(xml).list;

                if (jsn) {
                    $.each(jsn, function (k, v) {
                        $('#' + k).text(numeral(v).format('0,0.00'));
                    });

                    var
                        balanceObj = {
                            totalBillAmount: parseFloat(jsn.TotalInvoices),
                            totalPayments: parseFloat(jsn.TotalPayments),

                            transFees: parseFloat(jsn.TransFees),
                            transPayments: parseFloat(jsn.TransPayments),

                            totalOutgoings: parseFloat(jsn.Outgoings),
                            companyProfit: parseFloat(jsn.Profit)
                        },
                        balanceTotal = balanceObj.totalBillAmount - balanceObj.totalPayments,
                        transFeesTotal = balanceObj.transFees - balanceObj.transPayments,
                        netProfit = balanceObj.companyProfit - balanceObj.totalOutgoings;

                    // balance
                    $('#TotalBalances').text(function () {
                        if (balanceTotal > 0) { $(this).removeClass('red').addClass('green'); } // profit case
                        return numeral(balanceTotal).format('0,0.00');
                    });

                    // transportation total fees
                    $('#TransTotalFees').text(function () {
                        if (transFeesTotal < 0) { $(this).removeClass('red').addClass('green'); } // profit case
                        return numeral(transFeesTotal).format('0,0.00');
                    });

                    // net profit
                    $('#NetProfit').text(function () {
                        if (netProfit < 0) { $(this).closest('tr').removeClass('success').addClass('danger').attr('title', 'Please check your total profit and outgoings amounts'); } // profit case
                        return numeral(netProfit).format('0,0.00');
                    });

                    // date format
                    $('#AddDate').text(function () {
                        return commonManger.formatJSONDateCal(new Date(), 'dd-MM-yyyy');
                    });
                }
            },
            getReport = function () {
                var functionName = "Balances_Select", DTO = { 'actionName': functionName };
                dataService.callAjax('Post', JSON.stringify(DTO), sUrl + 'GetDataDirect', BindReportControls, commonManger.errorException);
            },
            showPaymentsTotal = function () {
                var _total = 0;
                $('#listItems tbody tr').each(function (i, item) {
                    _total += numeral($(this).children('td:eq(2)').text()) * 1;
                });

                // show final save button.
                if (_total > 0) {
                    $('#SaveAll').removeClass('hidden');
                } else {
                    $('#SaveAll').addClass('hidden');
                }

                // show total amount.
                $('#AmountDhs').val(numeral(_total).format('0,0'));
                _total = numeral(_total).format('0,0.0');
                $('#TotalAmountDhs').text(_total);
            };

        return {
            Init: Init
        };
    }();
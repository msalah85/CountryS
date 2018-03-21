//=======================================
// Developer: M. Salah (7-1-2017)
// Email: eng.msalah.abdullah@gmail.com
//=======================================

var
    pageManager = function () {
        "use strict";
        var Init = function () {
            getReport();
            pageEvents();
        },
        pageEvents = function () {
            // print report
            $('#printMe').click(function (e) {
                e.preventDefault();
                commonManger.printPage();
            });
        },
        getReport = function () {
            var _id = commonManger.getQueryStrs().clientid,
                no = _id || 0,
                DTO = { 'actionName': 'Client_GetSummary', value: no },
                BindReportControls = function (d) {
                    var xml = $.parseXML(d.d), jsn = $.xml2json(xml).list;

                    if (jsn) {
                        $.each(jsn, function (k, v) {
                            $('#' + k).text(numeral(v).format('0,0.00'));
                        });


                        var _name = jsn.ClientName.split(' ').join('+');


                        $('.ClientName').text(jsn.ClientName);
                        $('.payments').attr('href', 'ClientPayments.aspx?id=' + _id + '&name=' + _name);
                        $('.invoices').attr('href', 'InvoicesView.aspx?id=' + _id + '&name=' + _name);
                        $('.clientStatements').attr('href', 'Statement.aspx?id=' + _id );


                        // balance
                        $('#TotalBalances').text(function () {
                            var balance = parseFloat(jsn.TotalInvoices || 0) - parseFloat(jsn.TotalPayments || 0);

                            if (balance > 0) { $(this).removeClass('red').addClass('green'); } // profit case

                            return numeral(balance).format('0,0.00');
                        });

                        //// date format
                        $('#AddDate').text(function () {
                            return commonManger.formatJSONDateCal(new Date(), 'dd-MM-yyyy');
                        });
                    }
                };


            dataService.callAjax('Post', JSON.stringify(DTO), sUrl + 'GetData', BindReportControls, commonManger.errorException);
        };

        return {
            Init: Init
        };

    }();
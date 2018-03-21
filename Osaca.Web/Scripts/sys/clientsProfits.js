//=======================================
// Developer: M. Salah (16-5-2017)
// Email: eng.msalah.abdullah@gmail.com
//=======================================

var
    pageManager = function () {
        "use strict";
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

                $('#From').val(begin);
                $('#To').val(end);
                $('#btnSearch').trigger('click');
                //getReport();
            },
            pageEvents = function () {
                // print report
                $('#printMe').click(function (e) {
                    e.preventDefault();
                    commonManger.printPage();
                });

                $('#btnSearch').click(function (e) {
                    e.preventDefault();


                    searchPrm.from = commonManger.dateFormat($('#From').val());
                    searchPrm.to = commonManger.dateFormat($('#To').val());


                    getReport();
                });

            },
            getReport = function () {
                var _id = commonManger.getQueryStrs().id || 0,
                    DTO = {
                        actionName: 'Clients_Profit',
                        names: ['From', 'To'],
                        values: [searchPrm.from, searchPrm.to]
                    },
                    BindReportControls = function (d) {
                        var data = commonManger.xml2Json(d.d),
                            jsn = data.list,
                            latestBalance = 0;


                        // header details
                        $('#AddDate').text(commonManger.formatJSONDateCal(new Date(), 'dd-MM-yyyy'));

                        // statement details
                        var
                            rows = $(jsn).map(function (i, v) {
                                latestBalance += v.Profit * 1;
                                return `<tr><td class="center">${i + 1}</td><td>${v.ClientName}</td><td>${numeral(v.Profit).format('0,0.00')}</td></tr>`;
                            }).get().join(),
                            $stet = $('.listItems tbody');


                        $stet.html(rows);


                        // show final balance.
                        $('.FinalBalance').text(numeral(latestBalance).format('0,0.00'));

                    };


                dataService.callAjax('Post', JSON.stringify(DTO), sUrl + 'GetDataList',
                    BindReportControls, commonManger.errorException);
            };

        return {
            Init: Init
        };

    }();
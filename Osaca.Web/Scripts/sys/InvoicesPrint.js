//=======================================
// Developer: M. Salah (07-01-2017)
// Email: eng.msalah.abdullah@gmail.com
//=======================================
//window.onload = function () {
//    debugger;
//    var _total = 0;
//    var _totalVat = 0;

//    setTimeout(function () {

//        $('.listItems tbody tr').each(function (i, item) {
//            _total += numeral().unformat($(this).children('td:eq(2)').text()) * 1;
//            _totalVat += numeral().unformat($(this).children('td:eq(3)').text()) * 1;
//        });

//        $("#tdTotalAmount").html(numeral(_total).format('0,0.0'));
//        $("#tdVatAmount").html(numeral(_totalVat).format('0,0.0'));

//        var AmountAndVat = numeral(_total + _totalVat).format('0,0.0');
//        $("#TotalAmount").text(AmountAndVat);

//    }, 500);

//}
var
    pageManager = function () {
        "use strict";
        var Init = function () {
            // get report id            
            getAllReport();
            pageEvents();
        },
            pageEvents = function () {
                // print report
                $('#printMe').click(function (e) {
                    e.preventDefault();
                    $('#sidebar').addClass('menu-min');
                    window.print();
                });
            },
            successSaved = function (data) {
                data = data.d;
                if (data.Status)
                    window.location.href = 'InvoicesView.aspx';
            },

            getAllReport = function () {
                var qs = commonManger.getQueryStrs(),
                    _id = (qs.id ? qs.id : ''),
                    _key = (qs.key ? qs.key : ''),
                    _no = (qs.no ? qs.no : '');


                var
                    dto = {
                        actionName: "Invoices_SelectRow",
                        names: ['id', 'key', 'no'],
                        values: [_id, _key, _no]
                    },
                    bindReportControls = function (d) {
                        var xml = $.parseXML(d.d), jsn = $.xml2json(xml).list, jsn1 = $.xml2json(xml).list1;

                        if (jsn) {
                            // set all data
                            $.each(jsn, function (k, v) {
                                $('#' + k).text(v);
                            });

                            // money format
                            $('#TotalAmount').text(function () {
                                return numeral($(this).text()).format('0,0');
                            });

                            //date format
                            $('.date').text(function () {
                                return commonManger.formatJSONDateCal($(this).text(), 'DD-MM-YYYY');
                            });
                        }

                        // expenses list
                        if (jsn1) {
                            var rows = $(jsn1).map(function (i, v) {
                                return '<tr><td>' + (i + 1) + '</td><td>' + v.ExpenseName + '</td><td>' + numeral(v.Amount).format('0,0.00') + '</td><td>' + numeral(v.VAT).format('0,0.00') + '</td></tr>';
                            }).get();

                            $('.listItems tbody').append(rows);
                            showPaymentsTotal(); // Invoice total
                        }
                    };

                dataService.callAjax('Post', JSON.stringify(dto), sUrl + 'GetDataList', bindReportControls,
                    commonManger.errorException);
            },
            showPaymentsTotal = function () {
                var _total = 0,
                    _totalVat = 0;

                $('.listItems tbody tr').each(function (i, item) {
                    _total += numeral().unformat($(this).children('td:eq(2)').text()) * 1;
                    _totalVat += numeral().unformat($(this).children('td:eq(3)').text()) * 1;
                });

                $("#tdTotalAmount").html(numeral(_total).format('0,0.0'));
                $("#tdVatAmount").html(numeral(_totalVat).format('0,0.0'));

                var AmountAndVat = numeral(_total + _totalVat).format('0,0.0');
                $("#TotalAmount").text(AmountAndVat);



                //var _total = 0;
                //$('#listItems tbody tr').each(function (i, item) {
                //    _total += numeral($(this).children('td:eq(2)').text()) * 1;

                //});

                //// show final save button.
                //if (_total > 0) {
                //    $('#SaveAll').removeClass('hidden');
                //} else {
                //    $('#SaveAll').addClass('hidden');
                //}

                //// show total amount.
                //$('#AmountDhs').val(numeral(_total).format('0,0'));
                //_total = numeral(_total).format('0,0.0');


                //$('#TotalAmountDhs').text(_total);
            };
        return {
            Init: Init
        };
    }();
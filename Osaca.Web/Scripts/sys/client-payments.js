var
    targetdata,
    deleteModalDialog = 'deleteModal',
    modalDialog = "addModal",
    formName = 'aspnetForm',
    tableName = "ClientPayments",
    pKey = "PaymentID",
    clientID = '',
    gridId = "listItems",
    filterNames = '',
    filterValues = '',
    $clientID = $('.txtSearch'),

    pageManager = function () {
        var
            init = function () {
                pageEvent();
                initProperties();
                setDataToSearch();
            },
            pageEvent = function () {
                // search
                $('.btnSearch').click(function (e) {
                    e.preventDefault();

                    var searchObj = {
                        client: $clientID.val() * 1 > 0 ? $clientID.val() : '',
                        from: commonManger.dateFormat($('#DateFrom').val()),
                        to: commonManger.dateFormat($('#DateTo').val()),
                    };

                    filterNames = 'ID~From~To';
                    filterValues = $.map(searchObj, function (el) { return el || '' }).join('~');

                    // update result
                    DefaultGridManager.updateGrid();
                });

                //validation
                $('#aspnetForm').validate({
                    errorElement: 'div',
                    errorClass: 'help-block',
                    focusInvalid: false,
                    ignore: "",
                    highlight: function (e) {
                        $(e).closest('.form-group').removeClass('has-info').addClass('has-error');
                    },
                    success: function (e) {
                        $(e).closest('.form-group').removeClass('has-error');//.addClass('has-info');
                        $(e).remove();
                    },
                    errorPlacement: function (error, element) {
                        if (element.is('input[type=checkbox]') || element.is('input[type=radio]')) {
                            var controls = element.closest('div[class*="col-"]');
                            if (controls.find(':checkbox,:radio').length > 1) controls.append(error);
                            else error.insertAfter(element.nextAll('.lbl:eq(0)').eq(0));
                        }
                        else if (element.is('.select2')) {
                            error.insertAfter(element.siblings('[class*="select2-container"]:eq(0)'));
                        }
                        else if (element.is('.chosen-select')) {
                            error.insertAfter(element.siblings('[class*="chosen-container"]:eq(0)'));
                        }
                        else error.insertAfter(element.parent());
                    },
                    submitHandler: function (form) {
                    },
                    invalidHandler: function (form) {
                    }
                });

                $('#btnSave').click(function (e) {
                    e.preventDefault();
                    $('#aspnetForm').submit();
                });
            },
            BindListSearch = function (d) {
                var xml = $.parseXML(d.d), jsn = $.xml2json(xml).list, jsn1 = $.xml2json(xml).list1;
                // clients
                if (jsn) {
                    var options = $(jsn).map(function (i, v) { return $('<option />').val(v.ClientID).text(v.ClientName); }).get();
                    $('#ClientID').append(options).trigger('chosen:updated').trigger("liszt:updated");
                }

                // banks
                if (jsn1) {
                    var options = $(jsn1).map(function (i, v) { return $('<option />').val(v.BankID).text(v.BankName); }).get();
                    $('#BankID').append(options).trigger('chosen:updated').trigger("liszt:updated");
                }
            },
            setDataToSearch = function () {
                var dto = { actionName: "ClientPayments_Properties" };
                dataService.callAjax('Post', JSON.stringify(dto), sUrl + 'GetDataDirect',
                    BindListSearch, commonManger.errorException);
            },
            initProperties = function () {

                ////////////////////////// //////////////////////////
                // check filter id.
                var qs = commonManger.getQueryStrs();
                if (qs.id) {

                    filterNames = 'ID';
                    filterValues = qs.id;


                    // set selected client
                    $clientID.select2("trigger", "select", {
                        data: { id: qs.id, text: (qs.name.split('+').join(' ')) }
                    });
                }
                ////////////////////////// //////////////////////////


                gridColumns.push({
                    "mDataProp": "PaymentID",
                    "bSortable": true
                },
                    {
                        "mDataProp": "ClientName",
                        "bSortable": true
                    },
                    {
                        "mDataProp": "AddDate",
                        "bSortable": false,
                        "mData": function (d) {
                            return commonManger.formatJSONDateCal(d.AddDate);
                        }
                    },
                    {
                        "mDataProp": "PaymentAmount",
                        "bSortable": false,
                        "sClass": "hidden-480",
                        'mData': function (d) {
                            return numeral(d.PaymentAmount).format('0,0.0');
                        }
                    },
                    {
                        "mDataProp": "CheckNo",
                        "bSortable": false,
                        "sClass": "hidden-480",
                        'mData': function (d) {
                            return d.CheckNo ? d.CheckNo : '';
                        }
                    },
                    {
                        "mDataProp": "BankName",
                        "bSortable": false,
                        "sClass": "hidden-480",
                        'mData': function (d) {
                            return d.BankName ? d.BankName : '';
                        }
                    },
                    {
                        "mDataProp": null,
                        "bSortable": false,
                        "mData": function () {
                            return '<button class="btn btn-primary btn-mini edit" title="Edit"><i class="fa fa-pencil"></i></button> \
                            <button class="btn btn-danger btn-mini remove" title="Delete"><i class="fa fa-trash"></i></button>';
                        }
                    });

                // footer call to show total payments, invoices and calculate client balance.
                var footerCallBack = function (data) {
                    var dAll = commonManger.comp2json(data.d), // get decompress data
                        jsn1 = dAll.list1; // get footer totals


                    if (jsn1) {
                        var payments = jsn1.TotalPayments ? jsn1.TotalPayments * 1 : 0;
                        $('.totalPayments').text(numeral(payments).format('0,0.00'));

                    }

                };

                DefaultGridManager.Init(footerCallBack);
            };


        return {
            Init: init
        };

    }();

///////////////////
pageManager.Init();
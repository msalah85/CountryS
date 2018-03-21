var
    targetdata,
    deleteModalDialog = 'deleteModal',
    modalDialog = "addModal",
    formName = 'aspnetForm',
    tableName = "TransporterPayments",
    pKey = "PaymentID",
    TransporterID = '',
    gridId = "listItems",
    filterNames = '',
    filterValues = '',
    $TransporterID = $('.txtSearch'),

    pageManager = function () {
        var
            qs = commonManger.getQueryStrs(),
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
                        Transporter: $TransporterID.val() * 1 > 0 ? $TransporterID.val() : '',
                        from: commonManger.dateFormat($('#DateFrom').val()),
                        to: commonManger.dateFormat($('#DateTo').val()),
                    };

                    filterNames = 'ID~From~To';
                    filterValues = $.map(searchObj, function (el) { return el || '' }).join('~');


                    if (qs.type) {
                        filterNames += "~TypeID";
                        filterValues += "~" + qs.type;
                    }

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
                // Transporters
                if (jsn) {
                    var options = $(jsn).map(function (i, v) { return $('<option />').val(v.TransporterID).text(v.TransporterName); }).get();
                    $('#TransporterID').append(options).trigger('chosen:updated').trigger("liszt:updated");
                }

                // banks
                if (jsn1) {
                    var options = $(jsn1).map(function (i, v) { return $('<option />').val(v.BankID).text(v.BankName); }).get();
                    $('#BankID').append(options).trigger('chosen:updated').trigger("liszt:updated");
                }
            },
            setDataToSearch = function () {
                var dto = { actionName: "TransporterPayments_Properties" };
                dataService.callAjax('Post', JSON.stringify(dto), sUrl + 'GetDataDirect',
                    BindListSearch, commonManger.errorException);
            },
            UpdatePageTypeTitle = function (typeId) {
                var headTitle = 'Transportation Payments',
                    elementTitle = 'Transporter';

                switch (typeId) {
                    case "3": {
                        headTitle = 'Crane/Driver Payments';
                        elementTitle = 'Crane/Driver';
                        break;
                    };
                }


                document.title = headTitle;
                $('.head-title').text(headTitle);
                $('.el-title').text(elementTitle);
            },
            initProperties = function () {

                ////////////////////////// //////////////////////////
                // check filter transporter id.                
                if (qs.id) {

                    filterNames = 'ID';
                    filterValues = qs.id;


                    // set selected Transporter
                    $TransporterID.select2("trigger", "select", {
                        data: { id: qs.id, text: (qs.name.split('+').join(' ')) }
                    });
                }

                if (qs.type) {
                    $('#TypeID').val(qs.type);

                    filterNames = 'TypeID';
                    filterValues = qs.type;

                    // update page name/title
                    UpdatePageTypeTitle(qs.type);
                }

                ////////////////////////// //////////////////////////


                gridColumns.push({
                    "mDataProp": "Serial",
                    "bSortable": true
                },
                    {
                        "mDataProp": "TransporterName",
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

                // footer call to show total payments, invoices and calculate Transporter balance.
                var footerCallBack = function (data) {
                    var dAll = commonManger.comp2json(data.d), // get decompress data
                        jsn1 = dAll.list1; // get footer totals


                    if (jsn1) {

                        var summaryData = {
                            fees: jsn1.TotalFees ? jsn1.TotalFees * 1 : 0,
                            payments: jsn1.TotalPayments ? jsn1.TotalPayments * 1 : 0
                        };

                        $('.TotalFees').text(numeral(summaryData.fees).format('0,0.00'));
                        $('.TotalPayments').text(numeral(summaryData.payments).format('0,0.00'));

                        // balance
                        var dueAmount = (summaryData.fees) - (summaryData.payments);
                        $('.DueAmount').text(numeral(dueAmount).format('0,0.00'));
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
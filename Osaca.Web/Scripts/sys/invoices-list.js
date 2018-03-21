var targetdata;
formName = 'aspnetForm';
deleteModalDialog = 'deleteModal';
tableName = "Invoices";
pKey = "InvoiceID";
gridId = "listItems";
gridColumns = [],
    $clientID = $('.txtSearch'),
    filterNames = '',
    filterValues = '';



var
    pageManager = function () {
        var
            init = function () {
                pageEvent();
                initProperties();
            },
            pageEvent = function () {
                // search
                $('.btnSearch').click(function (e) {
                    e.preventDefault();

                    //if ($clientID.val() !== null && $clientID.val() !== '') {
                    //    window.location.href = 'InvoicesView.aspx?id=' + $clientID.val() + '&name=' + $clientID.find('option:selected').text().split(' ').join('+');
                    //}


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
            },
            setDataToSearch = function () {
                var dto = { actionName: "ClientPayments_Properties" };
                dataService.callAjax('Post', JSON.stringify(dto), sUrl + 'GetDataDirect', BindListSearch, commonManger.errorException);
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


                gridColumns.push({
                    "mDataProp": "InvoiceID",
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
                        "mDataProp": "ClientName",
                        "bSortable": true
                    },
                    {
                        "mData": function (d) { return d.ContainerNo ? d.ContainerNo : '' },
                        "bSortable": false
                    },
                    {
                        "mData": function (d) { return d.DeclarationNo ? d.DeclarationNo : '' },
                        "bSortable": false
                    },
                    {
                        "mData": function (d) { return numeral(d.TotalAmount).format('0,0.00') },
                        "bSortable": false
                    },
                    {
                        "mData": function (d) { return numeral(d.ServiceChargeAmount).format('0,0.00') },
                        "bSortable": false
                    },
                    { // vat tax applied only on service charge amount.
                        "mData": function (d) { return numeral(d.VATAmount).format('0,0.00') },
                        "bSortable": false
                    },
                    {
                        "mDataProp": null,
                        "bSortable": false,
                        "mData": function (d) {
                            var
                                editDelete = ' <a class="btn btn-info btn-mini" title="Edit" href="InvoiceAdd.aspx?id=' + d.InvoiceID + '"><i class="fa fa-pencil"></i></a> <button class="btn btn-danger btn-mini remove" title="Delete"><i class="fa fa-trash"></i></button>'

                            return '<a class="btn btn-grey btn-mini" title="Print" href="InvoicePrint.aspx?id=' + d.InvoiceID + '"><i class="fa fa-print"></i></a>' + (editDelete);
                        }
                    });


                // footer call to show total payments, invoices and calculate client balance.
                var footerCallBack = function (data) {
                    var dAll = commonManger.comp2json(data.d), // get decompress data
                        jsn1 = dAll.list1; // get footer totals


                    if (jsn1) {

                        var clientObj = {
                            invoices: jsn1.TotalInvoices ? jsn1.TotalInvoices * 1 : 0,
                            payments: jsn1.TotalPayments ? jsn1.TotalPayments * 1 : 0
                        };

                        $('.TotalInvoices').text(numeral(clientObj.invoices).format('0,0.00'));
                        $('.TotalPayments').text(numeral(clientObj.payments).format('0,0.00'));

                        // balance
                        var duAmount = (clientObj.invoices) - (clientObj.payments);
                        $('.clientBalance').text(numeral(duAmount).format('0,0.00'));
                    }

                };

                // init grid
                DefaultGridManager.Init(footerCallBack);
            };


        return {
            Init: init
        };

    }();

///////////////////
pageManager.Init();
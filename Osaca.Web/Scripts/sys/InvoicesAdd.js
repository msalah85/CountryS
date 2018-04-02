//=======================================
// Developer: M. Salah (09-02-2016)
// Email: eng.msalah.abdullah@gmail.com
//=======================================

var selfInviceAddManager;

function onAmountChanged(e) {
    // read values of this current Row.
    var _isvatable = $(e).attr('data-isvatable'),
        _value = $(e).val();

    if ((_isvatable == "true")) {
        // applay changes on Vat Amount based on _isvatable.
        var nextTXT = parseFloat($(e).closest('tr').find('input')[0].value);
        var newVAT = _value * selfInviceAddManager.VAT;

        $(e).closest('tr').find('input')[2].value = newVAT.toFixed(2); // set new value to Vat textbox in this row.
    }
    else {
        $(e).closest('tr').find('input')[2].value = numeral("0").format('0.0');
    }
}

var pageManager = function () {
    debugger;
    selfInviceAddManager = this;
    "use strict";
    this.IsVatable = false;
    this.VAT;
    var
        _id = commonManger.getUrlVars().id,

        Init = function () {
            // set buyers and shippers lists for binding.            


            pageEvents();
            try {
                ReadFromSettings();
            } catch (e) {

            }

        },
        pageEvents = function () {

            $('#ExpenseID').change(function (e) {
                getDefaultValue($(this).val());
            });

            // add client Expense to grid.
            $('#btnAddAmount').click(function (e) {

                e.preventDefault();
                var expenseID = $('#ExpenseID').val();
                if (expenseID !== '') {
                    BindGrid();
                } else {
                    commonManger.showMessage('Required fields', 'Please enter all required fields.');
                }
            });

            // save all data
            $('#SaveAll').click(function (e) {
                e.preventDefault();
                SaveAllData();
            });

            // reset form on open
            $('#addModal').on('shown.bs.modal', function () {
                $("#ExpenseID").val('');
                $("#Cost,#Amount").val('0.0');
            });

            // grid events
            var $gridTable = $('#listItems tbody');
            // remove row from grid.
            $gridTable.delegate('tr button.remove', 'click', function (e) {
                e.preventDefault();
                var el = $(this).closest('tr');
                if (el) {
                    el.css({ 'transition': 'background-color 1s', 'background-color': 'red' }).fadeOut('slow').promise().done(function () {
                        el.remove();

                        reArrangGridIndexs(); // reorder indexes.

                        showPaymentsTotal();

                    });
                }
            });

            // update total
            $gridTable.delegate('tr input[data-isvatable="true"]', 'keyup change', function (e) {
                // update vat expense by changing service charge expense value.
                var _this = $(this),
                    expId = _this.attr('data-expid'),
                    expValue = _this.val(),
                    IsVatable = _this.attr('data-IsVatable'),
                    updateVatInGrid = function (parentID, parentValue) {
                        // find/update all children VAT value = parentValue * 0.05.
                        //$gridTable.find('tr input[data-parent-expid="' + parentID + '"]').val((parentValue * (selfInviceAddManager.VAT || 0.05)).toFixed(2));
                    };

                onAmountChanged(_this);
                //if (expId && expValue)
                //    updateVatInGrid(expId, expValue);

                showPaymentsTotal(); // recalculate total.
            });

        },
        // start Save data.
        SaveAllData = function () {
            var isValid = validateMayData();

            if (isValid) {

                var
                    valuesDetails = $('#listItems tbody tr').map(function (i, v) {
                        var detailsId = $(v).find('td:eq(0)').attr('data-inv-details-id');
                        return (detailsId ? detailsId : 0) + ',0,'
                            + $(v).find('td:eq(0)').attr('data-expenseid') + ',' +
                            numeral().unformat($(v).find('td:eq(2) input').val()) + ',' +
                            numeral().unformat($(v).find('td:eq(3) input').val()) + ',' +
                            numeral().unformat($(v).find('td:eq(4) input').val());
                    }).get(),
                    TransporterID = $('#TransporterID').val() * 1 > 0 ? $('#TransporterID').val() : '',
                    CraneDriverID = $('#CraneDriverID').val() * 1 > 0 ? $('#CraneDriverID').val() : '',

                    namesMaster = ['InvoiceID', 'ClientID', 'AddDate', 'TotalAmount', 'Profit', 'ContainerNo', 'DeclarationNo',
                        'Notes', 'BillOfEntryDate', 'TransporterID', 'CraneDriverID'],

                    valuesMaster = [$('#InvoiceID').val(), $('#ClientID').val(), commonManger.dateFormat($('#AddDate').val()),

                    numeral().unformat($('#TotalAmount').text()), numeral().unformat($('#TotalProfit').text()), $('#ContainerNo').val(),
                    $('#DeclarationNo').val(), $('#Notes').val(), commonManger.dateFormat($('#BillOfEntryDate').val()),
                        TransporterID, CraneDriverID],

                    namesDetails = ['InvoiceDetailsID', 'InvoiceID', 'ExpenseID', 'Cost', 'Amount', 'VAT'],

                    _valid = true;






                // Validate trasporter/Crane-Driver name 
                $('#listItems tbody tr').each(function () {
                    var transporterCraneExpenseName = $(this).find("td:eq(1)").text().toLowerCase(),
                        transporterCraneExpenseCost = $(this).find("td:eq(2) input").val() * 1,
                        transporterCraneExpenseCustVal = $(this).find("td:eq(3) input").val() * 1;


                    // validate transporter name
                    // should be selected when there is transportation charge added up
                    if (transporterCraneExpenseName === 'transport charges' && TransporterID === '' &&
                        (transporterCraneExpenseCost > 0 || transporterCraneExpenseCustVal > 0)) {
                        _valid = false;
                        commonManger.showMessage('Required fields', 'Please select transporter name.');
                        return false;
                    }

                    // validate crane/driver name
                    // should be selected when there is Carage charge value up.
                    if (transporterCraneExpenseName === 'crane charges' && CraneDriverID === '' &&
                        (transporterCraneExpenseCost > 0 || transporterCraneExpenseCustVal > 0)) {
                        _valid = false;
                        commonManger.showMessage('Required fields', 'Please select crane/driver name.');
                        return false;
                    }

                }).promise().done(function () {
                    // start save invoice.
                    if (_valid)
                        SaveDataMasterDetails(namesMaster, valuesMaster, namesDetails, valuesDetails);
                });


            } else {
                commonManger.showMessage('Data required', 'Please enter all mandatory fields.');
            }
        },
        SaveDataMasterDetails = function (fieldsMaster, valuesMaster, fieldsDetails, valuesDetails) {
            var DTO = {
                'fieldsMaster': fieldsMaster, 'valuesMaster': valuesMaster,
                'fieldsDetails': fieldsDetails, 'valuesDetails': valuesDetails
            };

            dataService.callAjax('Post', JSON.stringify(DTO), 'InvoiceAdd.aspx/SaveDataMasterDetails',
                successSaved, commonManger.errorException);
        },
        validateMayData = function () {
            // validate all data before SaveAllData.
            var _valid = true,
                requiredFields = {
                    client: $('#ClientID').val(),
                    gridLength: $('#listItems tbody').length,
                    date: commonManger.dateFormat($('#AddDate').val()),
                    container: $('#ContainerNo').val(),
                    declaration: $('#DeclarationNo').val(),
                    transporter: $('#TransporterID').val() * 1 > 0 ? $('#TransporterID').val() : '',
                    craneDriver: $('#CraneDriverID').val() * 1 > 0 ? $('#CraneDriverID').val() : ''
                };

            if (requiredFields.client === '' || requiredFields.gridLength <= 0 || requiredFields.date === '' ||
                requiredFields.container === '' || requiredFields.declaration === '')
                _valid = false;

            return _valid;
        },
        successSaved = function (data) {
            data = data.d;
            if (data.Status) {
                window.location.href = 'InvoicePrint.aspx?id=' + data.ID; //InvoicesView
            } else {
                commonManger.showMessage('Error!', 'Error occured!:' + data.message);
            }
        },
        bindFormControls = function (d) {

            var xml = $.parseXML(d.d),
                jsn = $.xml2json(xml).list,
                jsn1 = $.xml2json(xml).list1,
                jsn2 = $.xml2json(xml).list2,
                jsn3 = $.xml2json(xml).list3;

            // expenses
            if (jsn) {
                var _options = $(jsn).map(function (i, v) { return $('<option data-IsVatable=' + v.IsVatable + ' />').val(v.ExpenseID).text(v.ExpenseName); }).get();
                $('#ExpenseID').append(_options).trigger('chosen:updated').trigger("liszt:updated");

                // fill grid with default expenses   
                // for edit bill or new bill.
                var detailData = (_id) ? jsn3 : jsn,
                    rows = $(detailData).map(function (i, v) {
                        debugger;
                        return $('<tr><td data-expenseid="' + v.ExpenseID + '" data-inv-details-id="' + (v.InvoiceDetailsID ? v.InvoiceDetailsID : 0) + '" class="center">' + (i + 1) + '</td><td>' + v.ExpenseName + '</td>\
                             <td><input data-expid="'+ v.ExpenseID + '" ' + (v.ParentExpenseID ? (' data-parent-expid="' + v.ParentExpenseID + '"') : '') + ' type="number" value="' + numeral(v.Cost ? v.Cost : v.DefaultValue).format('0.0') + '" /></td>\
                             <td><input data-IsVatable="' + v.IsVatable + '" data-expid="' + v.ExpenseID + '" type="number" value="' + numeral(v.Amount ? v.Amount : v.DefaultValue).format('0.0') + '" /></td>\
                             <td><input readonly data-vatColmun data-expid="' + v.ExpenseID + '" ' + (v.ParentExpenseID ? (' data-parent-expid="' + v.ParentExpenseID + '"') : '') + ' type="number" value="' + (_id ? numeral(v.VAT).format('0.0') : (v.IsVatable == "true" ? numeral((v.Amount ? v.Amount : v.DefaultValue) * selfInviceAddManager.VAT).format('0.0') : numeral(0).format('0.0'))) + '" /></td>\
                             <td><button class="btn btn-minier btn-danger remove" data-rel="tooltip" data-placement="top" data-original-title="Delete" title="Delete"><i class="fa fa-remove icon-only"></i></button></td></tr>');
                    }).get();

                $('#listItems tbody').append(rows);

                // show payments total amount.
                showPaymentsTotal();
            }

            // clients
            if (jsn1) {
                var options = $(jsn1).map(function (i, v) { return $('<option />').val(v.ClientID).text(v.ClientName); }).get();
                $('#ClientID').append(options).trigger('chosen:updated').trigger("liszt:updated");
            }

            // master invoice for edit
            if (jsn2) {
                $.each(jsn2, function (k, v) {
                    $('#masterForm #' + k).val(v);
                });

                $('.date-picker').text(function () {
                    return commonManger.formatJSONDateCal($(this).text());
                });


                // bind down select2(transfer/crane)
                if (jsn2.TransporterID)
                    $('#TransporterID').select2("trigger", "select", {
                        data: { id: jsn2.TransporterID, text: jsn2.TransporterName }
                    });

                if (jsn2.CraneDriverID)
                    $('#CraneDriverID').select2("trigger", "select", {
                        data: { id: jsn2.CraneDriverID, text: jsn2.CraneDriverName }
                    });
            }

        },
        setFormProperties = function () {
            // Edit invoice
            var
                acName = 'Invoices_Properties', // function name
                DTO = _id ? { actionName: acName, value: _id } : { actionName: acName }; // set paramers for edit only.

            dataService.callAjax('Post', JSON.stringify(DTO), sUrl + 'GetData' + (_id ? '' : 'Direct'),
                bindFormControls, commonManger.errorException);
        },
        BindGrid = function () {
            var VATAmountParam = $('#Amount').val();
            if (selfInviceAddManager.IsVatable == "true") {
                VATAmountParam = VATAmountParam * selfInviceAddManager.VAT;
            }
            else {
                VATAmountParam = "0.00";
            }
            var jsn = {
                ExpenseID: $('#ExpenseID').val(),
                ExpenseName: $('#ExpenseID option:selected').text(),
                Cost: $('#Cost').val(),
                Amount: $('#Amount').val(),
                VATAmount: VATAmountParam
            };

            if (jsn) {
                // collect table rows
                var rows = $(jsn).map(function (i, v) {
                    return $('<tr><td data-expenseid="' + v.ExpenseID + '" data-inv-details-id="' + (v.InvoiceDetailsID ? v.InvoiceDetailsID : 0) + '" class="center">' + (i + 1) + '</td><td>' + v.ExpenseName + '</td>\
                             <td><input type="number" value="' + numeral(v.Cost).format('0.0') + '" /></td>\
                             <td><input type="number" value="' + numeral(v.Amount).format('0.0') + '" /></td>\
                             <td><input type="number" readonly value="' + numeral(v.VATAmount).format('0.0') + '" /></td>\
                             <td><button class="btn btn-minier btn-danger remove" data-rel="tooltip" data-placement="top" data-original-title="Delete" title="Delete"><i class="fa fa-remove icon-only"></i></button></td></tr>');
                }).get(), isExist = false;


                $('#listItems tbody tr').each(function (i, item) {
                    if ($(this).children('td:eq(0)').attr('data-expenseid') === jsn.ExpenseID)
                        isExist = true;
                });


                if (!isExist) {
                    // populate to payments table
                    $('#listItems tbody').append(rows);
                    // show payments total amount.
                    showPaymentsTotal();
                    // re order rows indexs
                    reArrangGridIndexs();

                } else {
                    commonManger.showMessage('Data Exists:', 'Data already exists before.');
                }
            }

            $('.modal').modal('hide');
        },
        showPaymentsTotal = function () {
            var _totalCost = 0,
                _total4Cust = 0,
                _totalVat = 0;

            $('#listItems tbody tr').each(function (i, item) {
                try {
                    var cstVal = $(this).find('td:eq(2) input').val() * 1,
                        custVal = $(this).find('td:eq(3) input').val() * 1,
                        totalVat = $(this).find('td:eq(4) input').val() * 1;


                    _totalCost += numeral().unformat(cstVal && !isNaN(cstVal) ? cstVal : 0) * 1; // cost
                    _total4Cust += numeral().unformat(custVal && !isNaN(custVal) > 0 ? custVal : 0) * 1; // amount/customer
                    _totalVat += numeral().unformat(totalVat && !isNaN(totalVat) > 0 ? totalVat : 0) * 1; // vat

                } catch (err) { console.log(err); }
            });

            _total4Cust = _total4Cust + _totalVat;

            // show total amount and profit.
            $('#TotalAmount').text(numeral(_total4Cust).format('0,0.0')); // show invoice total
            $('#TotalProfit').text(numeral(_total4Cust - _totalCost).format('0,0.0')); // show invoice total


            // show final save button.
            if (_total4Cust > 0) {
                $('#SaveAll').removeClass('hidden');
            } else {
                $('#SaveAll').addClass('hidden');
            }

        },
        resetMyForm = function () {
            $('#aspnetForm')[0].reset();
            $('#listItems tbody').html('');
            $('#TotalAmountDhs').text('0');
        },
        getDefaultValue = function (no) {

            var functionName = "Expenses_SelectRow",
                prm = {
                    actionName: functionName,
                    value: no
                },
                bindData = function (data) {
                    var xml = $.parseXML(data.d),
                        jsn = $.xml2json(xml).list;

                    if (jsn) {
                        $('#Cost').val(numeral(jsn.DefaultValue).format('0.00'));
                        $('#Amount').val(numeral((jsn.DefaultValue)).format('0.00'));
                        selfInviceAddManager.IsVatable = jsn.IsVatable;
                    }
                };


            dataService.callAjax('Post', JSON.stringify(prm), sUrl + 'GetData', bindData, commonManger.errorException);
        },

        ReadFromSettings = function () {
            var functionName = "Settings_Select",
                prm = {
                    actionName: functionName,
                    value: 'VAT'
                },
                bindData = function (data) {
                    var xml = $.parseXML(data.d),
                        jsn = $.xml2json(xml).list;

                    selfInviceAddManager.VAT = parseFloat(jsn.Val);
                    setFormProperties();
                };

            dataService.callAjax('Post', JSON.stringify(prm), sUrl + 'GetData', bindData, commonManger.errorException);
        },

        reArrangGridIndexs = function () {
            $('#listItems tbody tr').each(function (i, n) {
                $(this).find('td:eq(0)').text(i + 1);
            });
        };


    return {
        Init: Init
    };

}();

//=======================================
// Developer: M. Salah (5-1-2018)
// Email: eng.msalah.abdullah@gmail.com
//=======================================

tableName = 'Outgoings';
formName = 'masterForm';

var
    pageManager = function () {
        "use strict";
        var
            _id = commonManger.getUrlVars().id,

            Init = function () {
                if (_id)
                    setFormProperties();

                pageEvents();
            },
            pageEvents = function () {

                var objs = {
                    amount: $('#Amount'),
                    vat: $('#VAT'),
                    save: $('#SaveAll')
                };

                //validation
                $('#' + formName).validate({
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

                // save all data
                objs.save.click(function (e) {
                    e.preventDefault();
                    SaveAllData();
                });


                // vat change

                objs.amount.on('keyup', function () {
                    var _this = $(this);
                    objs.vat.val(0);

                    if ($.isNumeric(_this.val())) {
                        objs.vat.val(_this.val() * 0.05);
                    }

                });
            },

            // start Save data.
            SaveAllData = function () {
                if (validateMayData()) {
                    var
                        fnName = tableName + '_Save',
                        allKeys = commonManger.Returncontrolsval(formName),
                        namesMaster = allKeys[0],
                        valuesMaster = allKeys[1];

                    commonManger.saveDefaultData(formName, formName, successSaved, null);

                } else {
                    commonManger.showMessage('Data required', 'Please enter all mandatory fields.')
                }
            },
            validateMayData = function () {
                // validate all data.
                var isValid = $('#masterForm').valid();
                return isValid;
            },
            successSaved = function (data) {
                data = data.d;
                if (data.Status) {
                    window.location.href = 'Outgoing/Outgoings.aspx?id=' + data.ID;
                } else {
                    commonManger.showMessage('Error!', 'Error occured!:' + data.message);
                }
            },
            bindFormControls = function (d) {
                var xml = $.parseXML(d.d),
                    jsn = $.xml2json(xml).list;

                // expenses
                if (jsn) {
                    $.each(jsn, function (k, v) {
                        $('#masterForm #' + k).val(v);
                    });

                    $('.date-picker').val(moment(jsn.AddDate).format('DD-MM-YYYY'));

                    $('.money').val(function () {
                        return numeral($(this).val()).format('0.00');
                    });

                    var newOption = new Option(jsn.ExpenseTypeName, jsn.ExpenseTypeID, true, true);
                    $("select.select2").append(newOption).trigger('change');
                }
            },
            setFormProperties = function () {
                var
                    acName = tableName + '_One', // function name
                    DTO = _id ? { 'actionName': acName, value: _id } : { actionName: acName }; // set paramers for edit only.

                dataService.callAjax('Post', JSON.stringify(DTO), sUrl + 'GetData' + (_id ? '' : 'Direct'),
                    bindFormControls, commonManger.errorException);
            };

        return {
            Init: Init
        };

    }();
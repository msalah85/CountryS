var
    filterNames = '',
    filterValues = '',
    targetdata;

deleteModalDialog = 'deleteModal';
modalDialog = "addModal";
formName = 'aspnetForm';
tableName = "Outgoings";
pKey = "OutgoingID";
gridId = "listItems";
gridColumns = [];


gridColumns.push(
    {
        "mDataProp": "OutgoingID",
        "bSortable": true
    },
    {
        "mDataProp": "AddDate",
        "bSortable": true,
        "mData": function (d) {
            return commonManger.formatJSONDateCal(d.AddDate);
        }
    },
    {
        "mDataProp": "ExpenseTypeName",
        "bSortable": true
    },
    {
        "mData": function (d) { return d.RefID ? d.RefID : '' },
        "bSortable": true
    },
    {
        "mData": function (d) { return d.Notes ? d.Notes : '' },
        "bSortable": false,
        "sClass": "hidden-480"
    },
    {
        "mDataProp": "VAT",
        "bSortable": false,
        "sClass": "hidden-480",
        "mData": function (row) {
            return numeral((row.VAT || 0) * 1).format('0,0.00');
        }
    },
    {
        "mDataProp": "Amount",
        "bSortable": false,
        "sClass": "hidden-480",
        "mData": function (row) {
            return numeral(row.Amount * 1).format('0,0.00');
        }
    },
    {
        "mDataProp": null,
        "bSortable": false,
        sClass: 'hidden-print',
        "mData": function (d) {
            return '<a href="images.aspx?id=' + d.OutgoingID + '" class="btn btn-warning btn-mini" title="Upload receipt"><i class="fa fa-image"></i></a>' +
                '<a href="outgoing/outgoingsaddedit.aspx?id=' + d.OutgoingID + '" class="btn btn-primary btn-mini" title="Edit"><i class="fa fa-pencil"></i></a>' +
                '<button class="btn btn-danger btn-mini remove" title="Delete"><i class="fa fa-trash"></i></button>';
        }
    });

$.extend(true, $.fn.dataTable.defaults, {
    "footerCallback": function (tfoot, data, start, end, display) {
        var api = this.api();
        $('.totalCharge').text(
            numeral(
                api.column(6).data().reduce(function (a, b) {
                    return (a * 1) + (numeral().unformat(b) * 1);
                }, 0)
            ).format('0,0.00')
        );

        // total vat
        $('.totalVat').text(
            numeral(
                api.column(5).data().reduce(function (a, b) {
                    return (a * 1) + (numeral().unformat(b) * 1);
                }, 0)
            ).format('0,0.00')
        );
    }
});

DefaultGridManager.Init();

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

// serach
$('#btnSearch').click(function (e) {
    e.preventDefault();
    var searchObj = {
        ExpenseTypeID: $('#ExpenseTypeID').val(),
        from: commonManger.dateFormat($('#DateFrom').val()),
        to: commonManger.dateFormat($('#DateTo').val()),
    };

    filterNames = 'ExpenseTypeID~From~To';
    filterValues = $.map(searchObj, function (el) { return el || '' }).join('~');

    // update result
    DefaultGridManager.updateGrid();
});
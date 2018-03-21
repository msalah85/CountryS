modalDialog = "addModal";
formName = 'aspnetForm';
deleteModalDialog = 'deleteModal';
tableName = "ExpenseTypes";
pKey = "ExpenseTypeID";
gridId = "listItems";
gridColumns = [];

gridColumns.push(
    {
        "mDataProp": "ExpenseTypeID",
        "bSortable": true
    },
    {
        "mDataProp": "ExpenseTypeName",
        "bSortable": true
    },
    {
        "mDataProp": null,
        "bSortable": false,
        "mData": function () {
            return '<button class="btn btn-primary btn-mini edit" title="تعديل"><i class="fa fa-pencil"></i></button> ' +
                '<button class="btn btn-danger btn-mini remove" title="حذف"><i class="fa fa-trash"></i></button>'
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
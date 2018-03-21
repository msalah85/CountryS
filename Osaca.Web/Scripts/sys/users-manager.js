var targetdata; modalDialog = "addModal"; formName = 'aspnetForm'; deleteModalDialog = 'deleteModal';
tableName = "Users";
pKey = "UserID";
gridId = "listItems";
gridColumns = [];
gridColumns.push(
    {
        "mDataProp": "UserID",
        "bSortable": true
    }, {
        "mDataProp": "TypeName",
        "bSortable": true
    }, {
        "mDataProp": "UserFullName",
        "bSortable": true
    }, {
        "mDataProp": "Phone",
        "bSortable": false
    }, {
        "mDataProp": "Username",
        "bSortable": false
    }, {
        "mDataProp": null,
        "bSortable": false,
        "mData": function () {
            return '<button class="btn btn-primary btn-mini edit" title="Edit"><i class="fa fa-pencil"></i></button> ' +
                '<button class="btn btn-danger btn-mini remove" title="Delete"><i class="fa fa-trash"></i></button>'
        }
    });
DefaultGridManager.Init();

// password in words
$.fn.afterLoadDatawithdata = function (ArrayData) {
    if (ArrayData['Password'])
        dataService.callAjax('Post',
            JSON.stringify({ 'value': ArrayData['Password'] }),
            sUrl + 'decryptPassword',
            function (data) { $('#Password').val(data.d); },
            commonManger.errorException);
}

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
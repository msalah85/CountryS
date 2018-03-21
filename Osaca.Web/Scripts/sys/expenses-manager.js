var targetdata;
modalDialog = "addModal";
formName = 'aspnetForm';
deleteModalDialog = 'deleteModal';
tableName = "Expenses";
pKey = "ExpenseID";
gridId = "listItems";
gridColumns = [];


gridColumns.push(
    {
        "mDataProp": "ExpenseID",
        "bSortable": true
    },
    {
        "mDataProp": "ExpenseName",
        "bSortable": true
    },
    {
        "mDataProp": "DefaultValue",
        "bSortable": false
    },
    {
        "mDataProp": "Priority",
        "bSortable": true
    },
    {
        "mData": function (row) {
            return row.Active === true ? '<i class="fa fa-check green"></i>' : '<i class="fa fa-remove red"></i>';
        },
        "bSortable": false
    },
    {
        "mData": function (row) {
            return row.IsVatable === true ? '<i class="fa fa-check green"></i>' : '<i class="fa fa-remove red"></i>';
        },
        "bSortable": false
    },
    {
        "mDataProp": null,
        "bSortable": false,
        "mData": function () {
            return '<button class="btn btn-primary btn-mini edit" title="تعديل"><i class="fa fa-pencil"></i></button> ' +
                '<button class="btn btn-danger btn-mini remove" title="حذف"><i class="fa fa-trash"></i></button>'
        }
    });

$.extend(true, $.fn.dataTable.defaults, {
    "order": [[3, "asc"]]
});

DefaultGridManager.Init();


//$.fn.beforeSave = function () {
//    if ($('#RouteURL').val().trim() == "") {
//        var news_title = $('#news_title').val();
//        news_title = news_title.replace(/\s+/g, '-').toLowerCase();
//        $('#RouteURL').val(news_title);
//        return true;
//    }
//    else { return true }
//}
//$.fn.afterLoadData = function (ArrayData) {
//    targetdata = ArrayData;
//}

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
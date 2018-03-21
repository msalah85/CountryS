
var
    filterNames = '',
    filterValues = '',
    qs = commonManger.getQueryStrs(),
    initMe = function () {
        if (qs.type) {
            $('#TypeID').val(qs.type);

            filterNames = 'TypeID';
            filterValues = qs.type;

            // update page name/title
            UpdatePageTypeTitle(qs.type);
        }

        setDataToSearch();

    },
    UpdatePageTypeTitle = function (typeId) {
        var headTitle = 'Transportation Fees',
            elementTitle = 'Transporter';

        switch (typeId) {
            case "3": {
                headTitle = 'Crane/Driver Fees';
                elementTitle = 'Crane/Driver';
                break;
            };
        }

        document.title = headTitle;
        $('.head-title').text(headTitle);
        $('.el-title').text(elementTitle);
    },
    BindListSearch = function (d) {
        var xml = $.parseXML(d.d), jsn = $.xml2json(xml).list, jsn1 = $.xml2json(xml).list1;

        // clients
        if (jsn) {
            var options = $(jsn).map(function (i, v) { return $('<option />').val(v.ClientID).text(v.ClientName); }).get();
            $('#ConsigneeID, #Client').append(options);
        }
        // users
        if (jsn1) {
            var options = $(jsn1).map(function (i, v) { return $('<option />').val(v.UserID).text(v.UserFullName); }).get();
            $('#TransporterID, #User').append(options);
        }

        $('select').trigger('chosen:updated').trigger("liszt:updated");


        $(".select2-filter").select2({ allowClear: true });

    },
    setDataToSearch = function () {
        var functionName = "Transportation_Properties",
            DTO = {
                actionName: functionName,
                names: ['ID'],
                values: [qs.type ? qs.type : '2']
            };


        dataService.callAjax('Post', JSON.stringify(DTO), sUrl + 'GetDataList',
            BindListSearch, commonManger.errorException);
    };

initMe();

////////////////////////////////////


deleteModalDialog = 'deleteModal';
modalDialog = "addModal";
formName = 'aspnetForm';
tableName = "Transportation";
pKey = "TransportID";
gridId = "listItems";
gridColumns = [];

gridColumns.push(
    {
        "mDataProp": "Serial",
        "bSortable": true
    },
    {
        "mDataProp": "ClientName",
        "bSortable": true
    },
    {
        "mDataProp": "UserFullName",
        "bSortable": true
    },
    {
        "mDataProp": "TransportDate",
        "bSortable": true,
        "mData": function (d) {
            return commonManger.formatJSONDateCal(d.TransportDate);
        }
    },
    {
        "mDataProp": "ContainerNo",
        "bSortable": false,
        "sClass": "hidden-480"
    },
    {
        "mDataProp": "TransportCharge",
        "bSortable": false,
        "sClass": "hidden-480",
        "mData": function (row) {
            return numeral(row.TransportCharge).format('0,0.00');
        }
    },
    {
        "mDataProp": null,
        "bSortable": false,
        sClass: 'hidden-print',
        "mData": function () {
            return '<button class="btn btn-primary btn-mini edit" title="Edit"><i class="fa fa-pencil"></i></button> ' +
                '<button class="btn btn-danger btn-mini remove" title="Delete"><i class="fa fa-trash"></i></button>';
        }
    });

// calculate every page total
$.extend(true, $.fn.dataTable.defaults, {
    "footerCallback": function (tfoot, data, start, end, display) {
        var api = this.api();
        $('.tranCharge').html(
            numeral(
                api.column(5).data().reduce(function (a, b) {
                    return (a * 1) + (b * 1);
                }, 0)
            ).format('0,0.00')
        );
    }
});


// footer call to show total payments, invoices and calculate client due amount for this result.
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

// init grid
DefaultGridManager.Init(footerCallBack);


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
        client: $('#Client').val(),
        user: $('#User').val(),
        from: commonManger.dateFormat($('#DateFrom').val()),
        to: commonManger.dateFormat($('#DateTo').val()),
    };
    filterNames = 'Client~User~From~To';
    filterValues = $.map(searchObj, function (el) { return el }).join('~');

    if (qs.type) {
        filterNames += "~TypeID";
        filterValues += "~" + qs.type;
    }

    // update result
    DefaultGridManager.updateGrid();
});
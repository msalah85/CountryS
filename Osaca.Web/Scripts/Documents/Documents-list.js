
formName = 'aspnetForm';
deleteModalDialog = 'deleteModal';
tableName = "Docs";
pKey = "InvoiceID";
gridId = "listItems";
gridColumns = [];
filterNames = '';
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

                    var formName = 'searchForm',
                        allKeys = commonManger.Returncontrolsval(formName);

                    filterNames = allKeys[0].join('~');
                    filterValues = allKeys[1].join('~');

                    // update list
                    DefaultGridManager.updateGrid();
                });
            },
            initProperties = function () {

                gridColumns.push(
                    {
                        "mData": function (d) {
                            return '<a title="Details" href="InvoicePrint.aspx?id=' + d.InvoiceID + '">' + (d.DeclarationNo ? d.DeclarationNo : '') + '</a>';
                        },
                        "bSortable": false
                    },
                    {
                        "bSortable": false,
                        "mData": function (d) {
                            if (d.BillOfEntryDate)
                                return commonManger.formatJSONDateCal(d.BillOfEntryDate);
                            else
                                return '---';
                        }
                    },
                    {
                        "mData": function (d) { return d.ContainerNo ? d.ContainerNo : '' },
                        "bSortable": false
                    },
                    {
                        "bSortable": false,
                        "mData": function (d) {
                            if (d.DocVerified === 'false')
                                return '<button class="btn btn-success btn-mini remove" title="Verify"><i class="fa fa-check"></i></button>';
                            else
                                return 'Delivered';
                        }
                    });
                
                // init grid
                DefaultGridManager.Init();
            };


        return {
            Init: init
        };

    }();

///////////////////
pageManager.Init();
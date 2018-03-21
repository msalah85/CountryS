//<reference path="../DefaultGridVariables.min.js" />
var DefaultMasterDetailsManager = function () {
    var Init = function () {
        $('#btnAddNew').on('click', function () {
            var title = "Add " + TitlePage, operation = "save";
            commonManger.ResetControls(formName);
            commonManger.showPopUpDialog(title, operation, modalDialog);
        });

        // initialize default properties        
        commonManger.fillLists();

        // fill grid after default paramters filled.
        $(document).bind('properties_complete', fillitemsDataTable);

        // fire delete and reset delegates
        workPerform();
    },
    workPerform = function () {
        $('#' + modalDialog + ' .modal-body .btn-primary').on('click', function (e) {
            e.preventDefault();
            commonManger.saveData(modalDialog, formName, successCallback, errorCallBack);
        });
        // reset form after closing modal from x close button.
        $('.modal-body button.clse, .modal-header .close').on('click', function (e) {
            commonManger.ResetControls(formName);
            e.preventDefault();
        });
        $('#' + deleteModalDialog + ' .modal-footer .btn-delete').on('click', function (e) {
            e.preventDefault();
            commonManger.deleteData(deleteModalDialog, formName, successCallback, errorCallBack);
        });
    },
    successCallback = function (data) {
        data = data.d;
        $('#' + modalDialog).modal('hide');
        commonManger.showMessage('Data has been saved:', data.message);
        if (data.Status) {
            $('#' + gridId).DataTable().draw(true); //.fnDraw({stateSave: true});
        }
    },
    errorCallBack = function (jqXhr, textStatus, errorThrown) {
        title = textStatus + ": " + errorThrown;
        message = JSON.parse(jqXhr.responseText).Message;
        commonManger.showMessage('danger', title, message);
    },
   fillitemsDataTable = function () {
       var oTable = $('#' + gridId).DataTable({
           bAutoWidth: false,
           "bServerSide": true,
           "sAjaxSource": sUrl + "LoadDataTables?funName=" + tableName + '_SelectList',
           "fnServerData": function (sSource, aoData, fnCallback) {
               dataService.callAjax('GET', aoData, sSource, function (data) { fnCallback(data.d); }, commonManger.errorException);
           },
           "iDisplayLength": 50,
           "aaSorting": [], // default none sorting none.
           "aoColumns": gridColumns
       });

       $.fn.dataTable.Buttons.swfPath = "/Content/sys/assets/js/dataTables/extensions/Buttons/swf/flashExport.swf"; //in Ace demo ../assets will be replaced by correct assets path
       $.fn.dataTable.Buttons.defaults.dom.container.className = 'dt-buttons btn-overlap btn-group btn-overlap';

       new $.fn.dataTable.Buttons(oTable, {
           buttons: [
             {
                 "extend": "colvis",
                 "text": "<i class='fa fa-search bigger-110 blue'></i> <span class='hidden'>Show/hide columns</span>",
                 "className": "btn btn-white btn-primary btn-bold",
                 columns: ':not(:first):not(:last)'
             },
             {
                 "extend": "copy",
                 "text": "<i class='fa fa-copy bigger-110 pink'></i> <span class='hidden'>Copy to clipboard</span>",
                 "className": "btn btn-white btn-primary btn-bold"
             },
             {
                 "extend": "csv",
                 "text": "<i class='fa fa-database bigger-110 orange'></i> <span class='hidden'>Export to CSV</span>",
                 "className": "btn btn-white btn-primary btn-bold"
             },
             {
                 "extend": "excel",
                 "text": "<i class='fa fa-file-excel-o bigger-110 green'></i> <span class='hidden'>Export to Excel</span>",
                 "className": "btn btn-white btn-primary btn-bold"
             },
             {
                 "extend": "pdf",
                 "text": "<i class='fa fa-file-pdf-o bigger-110 red'></i> <span class='hidden'>Export to PDF</span>",
                 "className": "btn btn-white btn-primary btn-bold"
             },
             {
                 "extend": "print",
                 "text": "<i class='fa fa-print bigger-110 grey'></i> <span class='hidden'>Print</span>",
                 "className": "btn btn-white btn-primary btn-bold",
                 autoPrint: true,
                 message: 'Country Sea'
             }
           ]
       });

       oTable.buttons().container().appendTo($('.tableTools-container'));

       //style the message box
       var defaultCopyAction = oTable.button(1).action();
       oTable.button(1).action(function (e, dt, button, config) {
           defaultCopyAction(e, dt, button, config);
           $('.dt-button-info').addClass('gritter-item-wrapper gritter-info gritter-center white');
       });


       var defaultColvisAction = oTable.button(0).action();
       oTable.button(0).action(function (e, dt, button, config) {

           defaultColvisAction(e, dt, button, config);

           if ($('.dt-button-collection > .dropdown-menu').length == 0) {
               $('.dt-button-collection')
               .wrapInner('<ul class="dropdown-menu dropdown-light dropdown-caret dropdown-caret" />')
               .find('a').attr('href', '#').wrap("<li />")
           }
           $('.dt-button-collection').appendTo('.tableTools-container .dt-buttons')
       });

       $("#" + gridId + " tbody").delegate("tr button", "click", function (event) {
           event.preventDefault();
           var self = $(this), pos = self.closest('tr'), aData;
           if (pos !== null) {
               if (self.hasClass('edit')) {
                   var titleedit = "Edit " + TitlePage, operation = 'save';
                   aData = oTable.row(pos).data(); // get data of the clicked row
                   commonManger.ResetControls(formName);
                   commonManger.getDataForUpdate(aData, formName);
                   commonManger.showPopUpDialog(titleedit, operation, modalDialog);
               }
               else if (self.hasClass('remove')) {
                   aData = oTable.row(pos).data();
                   var title = " Delete " + TitlePage, peration = 'delete', ParamNames = [], _id = "";
                   if (pKey.toLowerCase().indexOf(",") >= 0) {
                       ParamNames = pKey.split(",");
                       for (var i = 0; i < ParamNames.length - 1; i++) {
                           _id += aData[ParamNames[i]] + ",";
                       }
                       _id += aData[ParamNames[ParamNames.length - 1]];
                   }
                   else { _id = aData[pKey]; }
                   $('#' + deleteModalDialog).find('.removeField').text(_id);
                   commonManger.showPopUpDialog(title, operation, deleteModalDialog);
               }
           }
       });
   };
    return {
        Init: Init,
    };
}();
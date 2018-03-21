var commonMasterDetails = function () {
    var
          returnFiledsNames = function (targetForm) {
              var valuesids = [];
              $("#" + targetForm + "").find('input,select,textarea')
                  .each(function () {
                      if ($(this).attr('id')) {
                          if (!$(this).hasClass("notneed")) {
                              if (!$(this).hasClass("notshow")) {
                                  valuesids.push($(this).attr('id'));
                              }
                              else { valuesids.push('hide' + $(this).attr('id')); }
                          }
                      }
                  });
              return valuesids;
          },
          returnFiledsNamesToSave = function (targetForm) {
              var valuesids = [];
              $("#" + targetForm + "").find('input,select,textarea')
                  .each(function () {
                      if ($(this).attr('id')) {
                          if (!$(this).hasClass("notneed") && !$(this).hasClass("notsave")) {



                              valuesids.push($(this).attr('id'));




                          }
                      }

                  });

              return valuesids;
          },
          DataToControls = function (targetForm, pkvalue) {
              //  commonManger.ResetControls(formName);
              var functionName = $("#" + targetForm).attr('name');
              DTO = { 'actionName': functionName, 'value': pkvalue };
              dataService.callAjax('Post', JSON.stringify(DTO), mainServiceUrl + 'GetData',
                  function (data) {
                      var selectList = JSON.parse(data.d);
                      projects = selectList;
                      $.each(selectList, function (index, Basicdata) {
                          if (Basicdata.tblName == "0") {
                              commonManger.getDataForUpdate(Basicdata, targetForm);
                          }
                      });
                  }, function (jqXhr, textStatus, errorThrown) {
                      error(jqXhr, textStatus, errorThrown);
                  });
          };
    return {
        returnFiledsNames: returnFiledsNames,
        DataToControls: DataToControls,
        returnFiledsNamesToSave: returnFiledsNamesToSave
    };
}();
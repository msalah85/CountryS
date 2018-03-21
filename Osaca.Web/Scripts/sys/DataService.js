var dataService = function () {
    var
        callAjax = function (reqestType, postedData, url, successCallback, errorCallback) {
            jqueryAjax(reqestType, postedData, url, successCallback, errorCallback);
        },
        startProgress = function () {
            $.smkProgressBar({
                element: 'body',
                status: 'start',
                bgColor: '#ffab00',
                barColor: '#69c305',
                content: 'Progress...'
            });
        },
        endProgress = function () {
            $.smkProgressBar({
                status: 'end'
            });
        },
        jqueryAjax = function (reqestType, postedData, url, successCallback, errorCallback) {
            $.ajax({
                type: reqestType,
                data: postedData,
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                url: url,
                success: function (data) {
                    successCallback(data);
                },
                beforeSend: function () {
                    //$(".sinpper").html("<i class='icon-spinner icon-spin orange bigger-125'></i>");
                    //$('div[id$=UpdateProgress1]').css('display', 'block');
                    startProgress();
                },
                complete: function () {
                    //$(".sinpper").html(""); $('div[id$=UpdateProgress1]').css('display', 'none');
                    endProgress();
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    endProgress();
                    errorCallback(jqXHR, textStatus, errorThrown);
                }
            });
        };
    return {
        callAjax: callAjax
    };
}();



var $btnDetails = $('.btn-client-details'),
    $btnSatetment = $('.btn-client-statement'),
    openPage = function (pageType) {
        var clientID = $('.select-client-id').val(),
            clientName = $('.select-client-id').next().find('.select2-selection__rendered').attr('title'),
            _url = pageType + '.aspx?id=' + clientID + '&name=' + (clientName ? clientName.split(' ').join('+') : '');
        if (clientName && clientID) {
            window.location.href = _url;
        } else {
            alert('Please select the customer first.');
        }
    };
$btnDetails.click(function () {
    openPage('InvoicesView');
});
$btnSatetment.click(function () {
    openPage('Statement');
});
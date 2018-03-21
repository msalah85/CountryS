jQuery(function ($) {
    $('[data-rel="tooltip"]').tooltip();
    $('.show-details-btn').on('click', function (e) {
        e.preventDefault();
        $(this).closest('tr').next().toggleClass('open');
        $(this).find(ace.vars['.icon']).toggleClass('fa-angle-double-down').toggleClass('fa-angle-double-up');
    });
    $('.date-picker').datepicker({
        autoclose: true,
        todayHighlight: true
    });
    $('.today').datepicker('setDate', new Date());
    $('select.colorpicker').ace_colorpicker({ pull_right: true }).on('change', function () {
        var color_class = $(this).find('option:selected').data('class');
        var new_class = 'widget-box';
        if (color_class != 'default') new_class += ' widget-color-' + color_class;
        $(this).closest('.widget-box').attr('class', new_class);
    });
});

function setNavigation() {
    var path = location.href.toLowerCase().replace(/\/$/, ""); path = decodeURIComponent(path); $('.nav-list li.active').removeClass('active'); $("#sidebar ul.nav-list a").each(function () { var href = $(this).attr('href').toLowerCase(); if (path.indexOf(href) > -1) { $(this).closest('li').addClass('active').parent().parent().addClass("active open"); } });
}
setNavigation();
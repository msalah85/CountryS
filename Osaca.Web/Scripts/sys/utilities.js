/// <M.Salah> eng.msalah.abdullah@gmail.com
/// www.share-web-design.com
/// 20-4-2017

var
    uti = uti || {},
    uti = function () {

        var
            init = function () {

            },
            mobileNumberFormat = function (mobNumber) {

                // not a number
                if (!mobNumber || mobNumber == NaN || mobNumber == '')
                    return '';


                // multi mobile number in string separated by comma [,]
                var mobArr = mobNumber.split(','), allMobilesStr = [];

                // loop on mobiles numbers in array
                for (var i = 0; i < mobArr.length; i++) {
                    // get one by one.
                    var numberFormat = mobArr[i];

                    if (!numberFormat || numberFormat == NaN || numberFormat.trim() == '')
                        continue;

                    // extract numbers only from string 
                    // if contains text or special characters
                    if (! /^[0-9]+$/.test(numberFormat)) {
                        numberFormat = numberFormat.replace(/[^0-9]/gi, ''); //.replace(/\D/g, '');
                    }

                    // remove prefix first double zero from 00971
                    if (numberFormat.match("^00")) {
                        // do this if begins with 00
                        numberFormat = numberFormat.substring(2, numberFormat.length);
                    }
                    // add prefix 971 if number begins with 05.
                    else if (numberFormat.match("^05")) {
                        // do this if begins with 00
                        numberFormat = '971' + numberFormat.substring(1, numberFormat.length);
                    }
                    // add prefix 971 if number begins with 5.
                    else if (numberFormat.match("^5")) {
                        numberFormat = '971' + numberFormat;
                    }
                    // remove prefix + from +971.
                    else if (numberFormat.match("^[+]+971")) {
                        numberFormat = numberFormat.substring(1, numberFormat.length);
                    }

                    // put one by one in to a returned array.
                    allMobilesStr.push(numberFormat);
                }

                // return a series numbers as a string.
                return allMobilesStr.join(',');
            };

        return {
            Init: init,
            mobieFormat: mobileNumberFormat
        };

    }();
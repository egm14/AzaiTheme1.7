/**
 * roja45quotationspro_order.js.
 *
 * @author    Roja45
 * @copyright 2016 Roja45
 * @license   license.txt
 *
 * 2016 ROJA45 - All rights reserved.
 *
 * DISCLAIMER
 * Changing this file will render any support provided by us null and void.
 */

$(document).ready(function () {
    $(".quote_quantity").TouchSpin({
        verticalbuttons: true,
        verticalupclass: 'fa fa-angle-up',
        verticaldownclass: 'fa fa-angle-down',
        mousewheel:true, 
        buttondown_class: "btn btn-link",        
        buttonup_class: "btn btn-link",
        min: 1,
        max: 1000000

    });

    


    $(document.body).on('click', '.request-quotation', function (e) {
        e.preventDefault();
        if ($(this).hasClass('disabled')) {
            return;
        }
        if (roja45quotationspro_summary.processSend()) {
            $('.btn.btn-default.request-quotation').prop('disabled', 'disabled').addClass('disabled');
            if(parseInt(roja45quotationspro_enable_captcha) && roja45quotationspro_enable_captchatype==1) {
                grecaptcha.execute();
            } else {
                roja45quotationspro_summary.submitForm();
            }
        }
    });

    if(roja45quotationspro_enable_captcha) {
        if (roja45quotationspro_enable_captchatype==0) {
            onloadRecaptchaCallback = function() {
                if (typeof roja45_recaptcha_widgets !== "undefined") {
                    $.each(roja45_recaptcha_widgets, function (index, value) {
                        grecaptcha.render(value, {
                            'sitekey': roja45quotationspro_recaptcha_site_key,
                            'callback' : onRecaptchaSubmitCallback}
                        );
                    });
                }
            }
            onRecaptchaSubmitCallback = function(token) {
                $('.quote_navigation .request-quotation').removeClass("disabled");
            }
            var url = '//www.google.com/recaptcha/api.js?onload=onloadRecaptchaCallback&render=explicit';
            var element = document.createElement("script");
            element.src = url;
            document.body.appendChild(element);
        } else if (roja45quotationspro_enable_captchatype==1) {
            onRecaptchaInvisibleSubmitCallback = function(response) {
                roja45quotationspro_summary.submitForm();
            };
            onRecaptchaInvisibleSubmitCallbackError = function(response) {
                $('.btn.btn-default.request-quotation').prop('disabled', 'disabled').addClass('disabled');
            };
            var url = '//www.google.com/recaptcha/api.js';
            var element = document.createElement("script");
            element.src = url;
            document.body.appendChild(element);
        }
    }

    $(document).on('change', 'input[name=quote_quantity]', function(e) {
        e.preventDefault();
        roja45quotationspro_summary.updateQty($(this));

    });
});

roja45quotationspro_summary = {
    processSend : function() {
        var url = $('#quotationspro_request_form').attr('action')
        var errors = 0;
        $('#quotationspro_request_form').find('input.validate', 'textarea.validate').each(function (index, value) {
            if ($(this).hasClass('is_required')) {
                if ($(this).val().length > 0 && $(this).attr('data-validate') != 'none') {
                    if ($(this).attr('name') == 'postcode' && typeof(countriesNeedZipCode[$('#id_country option:selected').val()]) != 'undefined') {
                        var result = window['validate_' + $(this).attr('data-validate')]($(this).val(), countriesNeedZipCode[$('#id_country option:selected').val()]);
                    } else if ($(this).data('validate') == 'isCustom') {
                        var result = validate_isCustom($(this).val(), new RegExp(decodeURIComponent($(this).data('custom-regex')), "i"));
                    } else {
                        var result = window['validate_' + $(this).attr('data-validate')]($(this).val());
                    }
                    if (result) {
                        invalid = false;
                    } else {
                        invalid = true;
                    }
                }

                if (!invalid && $(this).hasClass('is_required')) {
                    var invalid = false;
                    if ($(this).val().length == 0) {
                        invalid = true;
                    }
                }

                if (invalid) {
                    $(this).parent().addClass('form-error').removeClass('form-ok');
                    errors++;
                } else {
                    $(this).parent().removeClass('form-error').addClass('form-ok');
                }
            }
        });

        if (errors == 0) {
            //roja45quotationspro_summary.submitForm(source);
            return true;
        } else {
            //source.preventDefault();
            return false;
        }
    },

    submitForm: function () {
        var request = {};
        request.columns = [];
        $('#quotationspro_request_form .quotationspro_request.column').each(function (i) {
            var column = {};
            var heading = $(this).find('.page-subheading').html();
            column.heading = heading;
            // column id
            var col = $(this).data('column');
            column.num = col;
            column.fields = [];

            $(this).find('.form-field').each(function (j) {
                var label = $(this).closest('.form-group').find('.control-label').html();
                var field = {};
                field.pos = j;
                field.name = $(this).attr('name');
                field.type = $(this).attr('data-field-type');
                field.label = label.trim();
                if (field.type == 'SWITCH') {
                    field.value = $('input[name='+field.name+']:checked').val();
                } else {
                    field.value = $(this).val();
                }
                column.fields[j] = field;
            });
            request.columns[i] = column;
        });
        var json = JSON.stringify(request);
        $('input[name=ROJA45QUOTATIONSPRO_FORMDATA]').val(json);
        $('#submitRequest').attr('disabled', 'disabled');
        $('#quotationspro_request_form').submit();
    },

    updateButtons: function (id_product) {
        var url = $('.request-quote').attr('href');
        $.ajax({
            url: url + '?submitUpdateSummaryButtons=1&id_product='+id_product+'&ajax=1',
            type: 'post',
            dataType: 'json',
            success: function (data) {
                if (data.result == 'success') {
                    roja45quotationspro.displaySuccessMsg(data.response);
                    if (data.enable == 0) {
                        $('.standard-checkout').show();
                        $('.request-quote').hide();
                    }
                } else if (data.result == 'error') {
                    $.each(data.errors, function (index, value) {
                        roja45quotationspro.displayErrorMsg(value);
                    });
                }
            },
            error: function (data) {
                roja45quotationspro.displayErrorMsg(roja45quotationspro_sent_failed);
            },
            complete: function (data) {
            }
        });
    },

    updateQty: function (ele, mode) {
        var qty = $(ele).closest('td.quote_quantity').find('input[name=quote_quantity]').val();
        $('#submitRequest').attr('disabled', 'disabled');
        $.ajax({
            url: roja45_quoationspro_controller,
            type: 'post',
            dataType: 'json',
            data : {
                'ajax' : 1,
                'action' : 'submitQuantity',
                'id_product' : $(ele).closest('td.quote_quantity').attr('data-id-product'),
                'id_product_attribute' : $(ele).closest('td.quote_quantity').attr('data-id-product-attribute'),
                'quantity' : qty
            },
            success: function (data) {
                if (data.result == 'success') {
                    //roja45quotationspro.displaySuccessMsg(data.response);
                } else if (data.result == 'error') {
                    roja45quotationspro.displayErrorMsg(value);
                }
            },
            error: function (data) {
                roja45quotationspro.displayErrorMsg(roja45quotationspro_sent_failed);
            },
            complete: function (data) {
                $('#submitRequest').removeAttr('disabled');
            }
        });
    },
}



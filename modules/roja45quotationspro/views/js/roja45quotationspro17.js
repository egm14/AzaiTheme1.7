/**
 * roja45quotationspro.js.
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
    if (typeof prestashop !== 'undefined' && prestashop.page.page_name=='product') {
        if ($.inArray(roja45quotationspro_id_product, roja45quotationspro_enabled)>-1) {
            $('body').addClass('roja45-quotable-product');
            if (roja45_hide_add_to_cart) {
                $(roja45quotationspro_productselector_addtocart).hide();
                $(roja45quotationspro_productselector_addtocart).addClass('roja45_hidden');
            }
            if (roja45_hide_price) {
                $(roja45quotationspro_productselector_price).hide();
                $(roja45quotationspro_productselector_price).addClass('roja45_hidden');
            }
            $('html').find('#quote_quantity_wanted').TouchSpin({
                step:9,
                min: 9,
                max: 50,
                maxboostedstep: false,
                mousewheel:true, 
                buttondown_class: "btn btn-link",
                buttonup_class: "btn btn-link",
                console.log(this.min.value);
            });
              
            /*
            if ($('.product-add-to-cart .product-quantity .add').length) {
                $('#roja45quotationspro_buttons_block').appendTo('.product-add-to-cart .product-quantity .add');
            }*/
        }
    }

    prestashop.on(
        'updateProduct',
        function (event) {
            if ($.inArray(roja45quotationspro_id_product, roja45quotationspro_enabled)>-1) {
                $('a.btn.add-to-quote').addClass('disabled');
            }
        }
    );

    prestashop.on(
        'updatedProduct',
        function (event) {
            if ($.inArray(roja45quotationspro_id_product, roja45quotationspro_enabled)>-1) {
                if (roja45_hide_add_to_cart) {
                    $(roja45quotationspro_productselector_addtocart).hide();
                    $(roja45quotationspro_productselector_addtocart).addClass('roja45_hidden');
                }
                if (roja45_hide_price) {
                    $(roja45quotationspro_productselector_price).hide();
                    $(roja45quotationspro_productselector_price).addClass('roja45_hidden');
                }
                /*if ($('.product-add-to-cart .product-quantity .add').length) {
                    $('#roja45quotationspro_buttons_block').appendTo('.product-add-to-cart .product-quantity .add');
                }*/
                $('a.btn.add-to-quote').removeClass('disabled');
            }
        }
    );

    prestashop.on(
        'updateProductList',
        function (event) {
            $(roja45quotationspro_productlistitemselector + ' .roja45quotationspro.product.enabled').each(function (index, element) {
                if (!$(this).closest('article').find('.product-flag.quote').length && (roja45quotationspro_show_label == 1)) {
                    var ele = $(this).closest('article');
                    ele.find('ul.product-flags').append('<li class="product-flag quote">' + roja45quotationspro_quote_link_text + '</li>');
                }
                if (roja45_hide_price) {
                    $(this).closest(roja45quotationspro_productlistitemselector).find(roja45quotationspro_productlistselector_price).hide();
                }
            });
        }
    );

    $(roja45quotationspro_productlistitemselector + ' .roja45quotationspro.product.enabled').each(function (index, element) {
        if (!$(this).closest(roja45quotationspro_productlistitemselector).find('.product-flag.quote').length && (roja45quotationspro_show_label == 1)) {
            var ele = $(this).closest(roja45quotationspro_productlistitemselector);
            ele.find('ul.product-flags').append('<li class="product-flag quote">' + roja45quotationspro_quote_link_text + '</li>');
        }
        if (roja45_hide_price) {
            $(this).closest(roja45quotationspro_productlistitemselector).find(roja45quotationspro_productlistselector_price).hide();
        }
    });

    $('.datepicker').each(function() {
        var format = $(this).attr('data-format');
        $(this).datepicker({
            prevText: '',
            nextText: '',
            dateFormat: format
        });
    });
});

roja45quotationspro = {
    quotationpro_addlabel: function (ele, id_product) {
        if (id_product && (roja45quotationspro_show_label == 1)) {
            var url = ele.closest('.ajax_block_product').find('.product_img_link').attr('href');
            ele.closest('.ajax_block_product').find('.product-image-container').append('<a class="quote-box ' + roja45quotationspro_label_position + '" href="' + url + '"><span class="quote-label">' + roja45quotationspro_quote_link_text + '</span></a>');
        }
    },

    displaySuccessMsg : function ( msgs ) {
        $.each(msgs, function(index, value) {
            $.growl({
                title: roja45quotationspro_success_title,
                message: value,
                duration: 3000,
                style: 'notice'
            });
        });
    },

    displayWarningMsg : function ( msgs ) {
        $.each(msgs, function(index, value) {
            $.growl({
                title: roja45quotationspro_warning_title,
                message: value,
                duration: 5000,
                style: 'warning'
            });
        });
    },

    displayErrorMsg : function ( msgs ) {
        $.each(msgs, function(index, value) {
            $.growl({
                title: roja45quotationspro_error_title,
                message: value,
                duration: 10000,
                style: 'error'
            });
        });
    }
}

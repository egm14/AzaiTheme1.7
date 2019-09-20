/**
 * PrestaShop module created by VEKIA, a guy from official PrestaShop community ;-)
 *
 * @author    VEKIA https://www.prestashop.com/forums/user/132608-vekia/
 * @copyright 2010-2017 VEKIA
 * @license   This program is not free software and you can't resell and redistribute it
 *
 * CONTACT WITH DEVELOPER
 * support@mypresta.eu
 


$(document).ready(function () {
    if (typeof disableCheckout !== 'undefined') {
        if (disableCheckout == 1) {
            $('.checkout.cart-detailed-actions a').addClass('disabled');
            $('.cart-summary .cart-detailed-actions a').addClass('disabled');
        }else{
        	$('.checkout.cart-detailed-actions a').removeClass('disabled');
            $('.cart-summary .cart-detailed-actions a').removeClass('disabled');
        }
    }
});*/
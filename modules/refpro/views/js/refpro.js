/**
 * 2007-2017 PrestaShop
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License (AFL 3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/afl-3.0.php
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@prestashop.com so we can send you a copy immediately.
 *
 * DISCLAIMER
 *
 * Do not edit or add to this file if you wish to upgrade PrestaShop to newer
 * versions in the future. If you wish to customize PrestaShop for your
 * needs please refer to http://www.prestashop.com for more information.
 *
 * @author    PrestaShop SA    <contact@prestashop.com>
 * @copyright 2007-2017 PrestaShop SA
 * @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
 * International Registered Trademark & Property of PrestaShop SA
 */

$(document).ready(function(){
	var options = {
		beforeSubmit: function(){
		},
        success: function(responseText, statusText, xhr, $form){
	        showDialog("<div class='ajsmall'>" + phrases['saved'] + "</div>");
        }
    };
	if($("#settings")[0]) $("#settings").ajaxForm(options);
	
	$("#getPaid").click(function(e){
		e.preventDefault();
		$.ajax({
			data: {
				ajax: true,
				action: "GetPaid"
			},
			type: "POST",
			error: function(){showDialog("<div class='ajsmall'>" + phrases['error'] + "</div>")},
			success: function(data, textStatus, jqXHR){
				if(data.indexOf("ok_flag") != -1){
					$("#getPaid").replaceWith('<span class="ordered">' + phrases['ordered'] + '</span>');
				}
				showDialog("<div class='ajsmall'>"+extractAjax(data)+"</div>");
			}
		})
	});
	$("#goref_a").click(function(e){
		e.preventDefault();
		if($("input[name='ref_agree']").attr("checked") || $("#ref_agree_alt")[0]){
			
			window.location.href = $(this).attr("href");
		} else {
			alert(phrases['alert_text']);
		}
	});

	$("#ref_agree").each(function(e){
		var href = $(this).attr("href");
		console.log("Esto va abrir");
		if(href.indexOf('?') != -1){
			href = href + "&content_only=1";
		} else {
			href = href + "?content_only=1";
		}
		$(this).attr("href", href);
	});
	var loader = $(".loader-page");
	$('#ref_agree').fancybox({
		width			: 920,
		height			: 557,
		autoScale			: true, 
		autoDimensions	: true,
		type			: 'iframe',
		scrolling		: 'auto',
		preload		: false,
		spinnerTpl: '<div class="fancybox-loading"></div>',
		afterShow : function(instance, current) {
			loader.show();
			console.info("fancbybox show");
			},
		afterShow : function(instance, current) {
			loader.hide();
			console.info("fancbybox hide");
			}
		
	}).trigger('click');

	var tab_container = new TabContainer('.tab_container');
	tab_container.init();
});

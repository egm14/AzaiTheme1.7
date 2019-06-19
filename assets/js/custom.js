
/*=========== Fancy spinner - Windows ==========*/

$(document).ready(function(){
		//Close loader
		setTimeout(function () {
		    //$(".loader-page").css({visibility:"hidden",opacity:"0"})
		    $(".loader-page").hide();
		  }, 300);
		  console.log("Spinner fuera luego del documento estar ready");


		var loader = $(".loader-page");

     	/*setTimeout(function () {openLoader() }, 300);
			      console.log("Spinner a mostrar");*/
		var wtCategory = $('#wt_cat_carousel').on('click tap', function(){
			loader.show();
		});
     	 function openLoader(e){
			//loader.css({visibility:"visibe",opacity:"100"});
			loader.show();
			console.log("Estoy abriendo loader");
    	 }
	     function closeLoader(e){
			//loader.css({visibility:"hidden",opacity:"0"});
			loader.hide();
			console.log("Estoy cerrando loader");
	     }
	/*==================== FIX COLOR RULE FILTER - COLUMN LEFT  =======================*/
	 	
	 	var filterColor = $('#search_filters');
	 	//verificando si existe el div #serach_filters
	 	if(filterColor){
	 		/*console.log("EStán los filtros activados");*/
	 		//Buscando div sesion con clase facet
	 		var filt = filterColor.find('section.facet');
	 		filt.each(function(){
	 			//Recorriendo la lista de div section
	 			var titleFilter = this.firstElementChild.innerText;
	 			/*console.log(titleFilter);*/
	 			//filtrando el section que posea el title Color
	 			if(titleFilter == "Color" || titleFilter == "color"){ 
	 				/*console.log("color encontrado");
	 				console.log(this);
	 				console.log(this.childNodes);
	 				console.log(this.childNodes[2]);*/
	 				var list = this.childNodes;
	 				var sum = 0;
	 				/*console.log("número de hijos" + this.childNodes.length);*/
	 					
	 					for(var num in list){
	 						sum += list[num];
	 						/*console.log("buscando UL");
	 						console.log("numeros: " + num);*/

	 						var ul = this.childNodes[num];
	 						/*console.log(ul);*/
	 						//verificando si fue encontrado el ul
	 						if(ul.localName == "ul"){
	 							/*console.log("Encontrado: " + ul.localName);
	 							console.log(ul.attributes.id.nodeValue);*/
	 							var add = "#"+ul.attributes.id.nodeValue;
	 							//console.log(add);
	 							$(add).addClass("variant-links");
	 						}
	 					}
	 			}
	 			/*console.log("Node no encontrado");*/
	 				});
	 	}
     /*==================== SIZE CHART  =======================*/
	  
     /*sSIZE-CHART-CONTENT*/
     	$('div.container-woman-size-chart').find('ul.tabs li').click(function(e){
		      e.preventDefault();

		    var tab_id = $(this).find("a").attr("href");;

		    $('ul.tabs li').removeClass('current');
		    $('.tab-content').removeClass('current');

		    $(this).addClass('current');
		    $(tab_id).addClass('current');
		  });
	   
  /*========= END SIZE CHART ==============*/


	  /*==================== MENU LOGIN SESIÓN - MOBILE =======================*/

	  $('#jx-header-account-link').on('click tap', function(){
	  	$('.jx-header-account').find('.dropdown-menu-right').removeClass('active-dropdown-login')
	  });
	
/*==================== SECTION CHECKOUT - FORM SLIDEDOWN =======================*/
	// LOGIN FORM
	var newAccountForm = $('#new_account_form');

	
    $(document).on('click', '#openLoginFormBlock', function(e) {
      e.preventDefault();
      newAccountForm.slideDown('slow');
    });

    /* Esta sección se quedará oculta ---*/
    newAccountForm.on('click', '#opc_createAccount', scrollForm);
    newAccountForm.on('click', '#opc_guestCheckout', scrollForm);

    function scrollForm(e){
    	//console.log(newAccountForm.scrollTop() + " px");
    	//console.log("hola");
    	setTimeout(window.scrollTo(0,600), 600);
    }


	/*==================== CHANGE COLOR ADD TO BAG =======================*/

	$('[data-link-action="sign-in"]').on('click', function(e){
		var ele = $('[data-link-action="sign-in"]');
		addGradient(ele);
	});
	/*Estos código dañan el proceso de checkout
	$('[data-link-action="register-new-customer"').on('click', function(){
		var ele = $('[data-link-action="register-new-customer"');
		addGradient(ele);
	});
	$('[type="submit"').on('click', function(){
		var ele = $('[type="submit"');
		addGradient(ele);
	});
	*/
	$('#box-cart-btn').on('click', function(e){
		var ele = $('#box-cart-btn');
		addGradient(ele);
	});
	$('#tocheckout').on('click', function(e){
		var ele = $('#tocheckout');
		//console.log(this);
		addGradient(ele);
	});
	$('#cartAction').on('click', function(e){
		var ele = $('#cartAction');
		//console.log(this);
		addGradient(ele);
	});
	$('#product').on('click tap', 'a.btn.btn-primary.add-to-quote.ajax_add_quote_button',function(){
		var ele = $('#product').find('a.btn.btn-primary.add-to-quote.ajax_add_quote_button');
		addGradient(ele);
	});
	/*$('#continue-1').on('click', function(e){
		var ele = $('#continue-1');
		//console.log(this);
		addGradient(ele);
	});
	$('#continue-2').on('click', function(e){
		var ele = $('#continue-2');
		//console.log(this);
		addGradient(ele);
	});*/
		
	function addGradient(vb){
		console.log("agregando clase gradiend-border");
		//console.log(vb);
		vb.addClass("gradient-border");	
		var add = vb;
		setTimeout(function(){
			vb.removeClass("gradient-border")
			console.log("Removiendo clase gradiend-border");
			}, 6000);	
	}


	 /*==================== SHOW ORDEN RESUMEN BEHAVIOR =======================*/
	$('#show-orden').on('click', ".span.btn-order-summary", function(){
		 $(this).toggleClass("active");
		 $('#show-orden').find('#order-summary-content').toggle(100, 'swing');
		 $('#show-orden').find('i.fa-shopping-bag').toggleClass("active");
	});

	 /*==================== CHANGE BEHAVIOR CUENTO =======================*/
	 $('#checkout-payment-step').on('click', ".paypal-option-payment", function(){
	 		$('#payment-confirmation').find(".btn-primary").addClass("button-jittery");
	 		console.log("Cambiando buttons pago debido a Paypal");
	 });


	 /*==================== SCROLL BEHAVIOR - HADER MENU STICKY =======================*/

	 	$(window).scroll(scrollElement);

	 	function scrollElement(){
	 		var wHeight = $(window).scrollTop();
	 		var mHeader = $('#header');
	 			//console.log("Distancia del scroll: " + wHeight);
	 		if($(window).width()<= 400){
		 		if(wHeight < 44){
		 			//console.log("Position: Block");
		 			mHeader.css('position', 'inherit');

		 		}else{
		 			//console.log("Position: Fixed");
		 			mHeader.css('position', 'Fixed');
	 			}
	 		}


	 	};

	 /*==================== CALCULADORA AJAX =======================*/
	 	setTimeout(tableColor,2000);

	 	$(document).on('change', 'input[name=quote_quantity]', function(evt) {
        //console.log("TTTTouchSpin .quote_quantity: ");
        //console.log(evt.target);
        obtenerCalculo(evt);

    	});

		 $('#quantity_wanted').on('change mousewheel touchspin', function(evt){
		 	obtenerCalculo(evt);
		 });	
		 
		 //Change color table on product
		 prestashop.on("updatedProduct",function(){
		 	tableColor();
		 	//$('#quantity_wanted').val(qty);
		 	closeLoader();
		 });
		 prestashop.on("handleError",function(){
		 	closeLoader();
		 });
		 $("ul.variant-links.list-inline").on('click', function(dt){
	 		openLoader();
	 		console.log("click sobre color");
	 		//console.log(dt);
		 });

	 	/*change color table auto or selected */
	 	function tableColor(){
	 		var formColor = $('#add-to-cart-or-refresh').find('.product-variants-item');
	 		var backColorDom = $('#backColor');
	 		//console.log(formColor);
		 		formColor.each(function(key, value){
		 			//console.log( "Probando each: " + key + " : " + value.innerText);
		 			//console.log(formColor[key]);
		 			 if(formColor[key].children[0].innerText == "COLOR"){
		 			 	//console.log("product-variant color encontrado");
		 			 	//console.log("Esto es el key: " + key);
		 			 	var liColor = formColor[key].children[1].children;
		 			 	//console.log(liColor);
		 				var sumKey = 0;
		 				/*console.log("número de hijos" + this.childNodes.length);*/
		 					for(var numb in liColor){
		 						sumKey += liColor[numb];
		 						//console.log(numb);
		 						while(liColor[numb].localName == "li"){
		 							var colorAttributes = liColor[numb].children[0].children[0].attributes;
		 								//console.log(liColor[numb]);
		 								//console.log(colorAttributes[0]);
		 								if(colorAttributes[0].nodeValue == "custom-control-label active"){
		 									//console.log(colorAttributes[1].value);
		 									var backcolor = colorAttributes[1].value.split(" ")[1];
		 										//console.log(backcolor);
		 										backColorDom.css("background-color", backcolor);
		 										//console.log(backColorDom);
		 								}else{
		 									//console.log(colorAttributes[1] + ": No activo");
		 								}
		 								break;
			 			 		//console.log(this.children[0].class);
			 			 		}
			 			 	}
			 			
			 		}
		 			 return (value.innerText == "Color");
	 		});

		 }
	 	/*Change color end*/
	 

	 function obtenerCalculo(evt){
	 	//obteniendo id de form - elemento tagged

	 	var target = $(evt.target.form).attr('id');
	 	//console.log(target);
	 	if(target == 'quotationspro_request_form'){
	 		//console.log("estoy en resumen quotatino");
	 		var targetRow = evt.target.parentElement.parentElement.parentElement;
	 		var targetRowId = $(targetRow).attr('id');
	 		//console.log(targetRow);
	 		//console.log(targetRowId);
	 		//console.log($('#'+targetRow));
	 		var price = $(targetRow).find('#product-price-quantity').data('price');
	 		//console.log(price);
	 		var priceLocation = $(targetRow).find('#product-price-quantity');
	 		var qty = $(targetRow).find('#quantity_wanted').val();
	 	}else{
	 		var priceLocation = $('#product-price-quantity');
	 		var price = $('#product-price-quantity').data('price');
	 		var qty = $('#quantity_wanted').val();
	 	}	
	 		var datapack = $('#quantity_wanted').data('pack');
		 	//console.log('obteniendo variables');
		 	//console.log('Esto es datapack: ' + datapack);

	 	calculadoraQTY(qty, price, datapack, priceLocation);

	 }
	 
	 function calculadoraQTY(qty,price, pack, priceLocation){
	 	var parametros ={
	 		"prodqty" :  qty,
	 		"prodprice" : price,
	 		"proddata" : pack,
	 		"async"	: true,
	 		"QtyxData" : qty * pack
	 	}
	 		var uriPhp;
		 	if(window.location.hostname =="localhost"){
		 		uriPhp = '/azai19b/themes/AzaiShop/assets/php2/';
		 	}else{
		 		uriPhp = '/themes/AzaiShop/assets/php2/';
		 		//console.log(window.location.origin + uriPhp+'calculadora.php');
		 	}
	 	$.ajax({
	 		data: parametros,
	 		url: window.location.origin + uriPhp+'calculadora.php',
	 		type: 'post',
	 		beforeSend: function(){
	 			//console.log("Enviando datos a la calculadora.");
	 			console.log("qty: " + parametros.prodqty + " price: " + parametros.prodprice + " Data-pack: " + parametros.QtyxData);
	 			//console.log(url.value);
	 		},
	 		success: function(resultado, text){
	 			priceLocation.find('.product-amount').html(" " + resultado);//value tag price html
	 				
	 			$('#table_qty_qty').html(parametros.QtyxData);
	 			console.log("Resultado obtenido");
	 			console.log(resultado);
	 		},
	 		 error: function (request, status, error) {
	 		 	console.log("Hay un error: " + error);

	 		}
	 	});
	 }


});
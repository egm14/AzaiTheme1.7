/*=========== Fancy spinner - Windows ==========*/

$(document).ready(function(){
	//console.log("esto es la variable disableCheckout: " + disableCheckout);
		//Close loader
		setTimeout(function () {
		    $(".loader-page").hide();
		  }, 300);
		  console.log("Spinner fuera luego del documento estar ready");


		var loader = $(".loader-page");

		var wtCategory = $('#wt_cat_carousel').on('click tap', function(){
			loader.show();
		});
		$('a.product-thumbnail-link').on('click tap',function(){
			openLoader();
		});
		$('#js-product-list .product-title').on('click tap', function(){
			openLoader();
		});
		$('.jxml-logo').on('click tap', function(){
			openLoader();
		});

		$('.closeSlidebar.shopping').on('click tap', function(){
			openLoader();
		});
		$('.btn-product.shopping').on('click tap', function(){

		});

		$('.dropdown-item').on('click tap', function(){
			openLoader();
		});
		$('button#submitRequest').on('click tap', function(){
			if($(this).hasClass("disabled")){
				console.log("La cotización no alcanza el minimo de compra.");
			}else{
				openLoaderSubmit();
			}
		});
     	 function openLoader(e){
			loader.show();
			console.log("Estoy abriendo loader");
    	 }
	     function closeLoader(e){
			loader.hide();
			console.log("Estoy cerrando loader");
	     }
	     function openLoaderSubmit(e){
	     	var loaderSubmit = $('.loader-submit-page');
	     	loaderSubmit.show();
	     }

	     /*==================== Reload to home when page Checkout don´t have product =======================*/
	     		
	     		var websiteCart = $.trim($('#cart-subtotal-products').find('.value')[0].innerText.replace("$", "").replace(prestashop.currency.iso_code, "")).toLocaleString('en-US');
				var websiteCartPre = prestashop.cart.totals.total.amount.toLocaleString('en-US');
				var minimal = cgma_minimal_order.toLocaleString('en-US');
				var checkoutPage = prestashop.page.page_name;
				console.log("websiteCArt: "+ websiteCart);
				
		     		if((minimal > websiteCart)&&(checkoutPage == "checkout")){
		     			openLoader();
		     			$('#cgma_errors').show();
		     			//window.location.href = prestashop.urls.base_url;
		     			console.log("Checkout -> "+"minial:"+minimal + "vs" + "cart: "+websiteCart);
		     		
		     		}else if((minimal < websiteCart)&&(checkoutPage == "checkout")){
		     			$('#cgma_errors').hide();
		     			console.log("Checkout -> "+"minial:"+minimal + "vs" + "cart: "+websiteCart);
		     		
		     		}else{

		     			if(minimal < websiteCartPre){
		     				$('#cgma_errors').show();
		     				$('.checkout.cart-detailed-actions a').addClass('disabled');
		            		$('.cart-summary .cart-detailed-actions a').addClass('disabled');
		            		console.log("Checkout -> "+"minial:"+minimal + "vs" + "cart: "+websiteCartPre);
		     			}else{
		     				$('#cgma_errors').hide();
		     				$('.checkout.cart-detailed-actions a').removeClass('disabled');
		            		$('.cart-summary .cart-detailed-actions a').removeClass('disabled');
		            		console.log("Checkout -> "+"minial:"+minimal + "vs" + "cart: "+websiteCartPre);
		     			}
		     			
		     		
		     		}
	     		

	     /*==================== Reload to home when page Checkout don´t have product  =======================*/
	

	/*==================== FIX COLOR RULE FILTER - COLUMN LEFT  =======================*/
	 	
	 	prestashop.on("updateProductList",filterColors);
	 	filterColors();

	 	function filterColors(){
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

	
	$(document).on('click tap', 'button[type="submit"]',function(e){
		var timerA = 10000;
		var button = $(this);
		//console.log("operación para los submit");
		//console.log(button);
		var formbutton = button.closest('form');

		if(button.attr('id') == 'submit-login' || button.attr('name') == 'HeaderSubmitLogin'){
			console.log(formbutton);
			var formulario = {
				email: formbutton.find('[name=email]').val(),
     			password: formbutton.find('[name=password]').val()
     		}
     		if((formulario.email && formulario.password)){
     			console.log("Inputs llenos correctamentes.");
     			addGradient(button,timerA);
				setTimeout(function(){
					button.find('.fa-spinner').remove();
					console.log("Removew elemente dom....");
				}, timerA);
     		}
			
		}else{
			console.log("Button submit: Enviado datos...");
     			addGradient(button,timerA);
		}
	});

	/*$('#box-cart-btn').on('click', function(e){
		var ele = $('#box-cart-btn');
		addGradient(ele);
	});*/
	$('#tocheckout').on('click', function(e){
		var ele = $('#tocheckout');
		//console.log(this);
		addGradient(ele);
	});
	$(document).on('click', '#cartAction',function(e){
		var ele = $('#cartAction');
		//console.log(this);
		addGradient(ele);
	});
	$('#product').on('click tap', 'a.btn.btn-primary.add-to-quote.ajax_add_quote_button',function(){
		var ele = $('#product').find('a.btn.btn-primary.add-to-quote.ajax_add_quote_button');
		addGradient(ele);
	});
	$('#_mobile_quotecart .quotation_cart.active').find('i').on('click', function(e){
		console.log("click cuento");
		openLoader();
	});
	
	
	function addGradient(vb, time){
		var timer = 10000;
		if (time){
			 timer = time;
		}
		console.log("agregando clase gradiend-border " + timer);
		//console.log(vb);
		vb.removeClass("gradient-border");
		vb.addClass("gradient-border");	
		addPingButton(vb);
		
		setTimeout(function(){
			vb.removeClass("gradient-border");
			removePingButton(vb);
			console.log("Removiendo clase gradiend-border");
			}, timer);	
	}

	function addPingButton(ping){
		ping.append('<i class="fa fa-spinner fa-spin"></i>');
	}

	function removePingButton(ping){
		ping.find('.fa-spinner').remove();
		console.log("borrando -fa-spinner");
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
	 		//console.log("Cambiando buttons pago debido a Paypal");
	 });


	 /*==================== SCROLL BEHAVIOR - HADER MENU STICKY =======================*/

	 	$(window).scroll(scrollElement);

	 	function scrollElement(){
	 		var wHeight = $(window).scrollTop();
	 		var mHeader = $('#header');
	 			//console.log("Distancia del scroll: " + wHeight);
	 		if($(window).width()<= 100){
		 		if(wHeight < 44){
		 			//console.log("Position: Block");
		 			mHeader.css('position', 'inherit');

		 		}else{
		 			//console.log("Position: Fixed");
		 			mHeader.css('position', 'Fixed');
	 			}
	 		}


	 	};

	/*==================== DISABLE OR HIDDEN INPUT FIELD ON IDENTY PAGE FOR USER LOGGED =======================*/
		
		var pageName = prestashop.page.page_name;
		console.log(pageName);
		if(pageName == 'identity'){
			$('#customer-form').find('select[name="seller_code_profile"]').closest("div.form-group").hide();
			$('#customer-form').find('input[name="seller_code"]').closest("div.form-group").hide();
		}

	  /*==================== APPEND CLONE TO NOTIFICATION PRIVATE SHOP =======================*/

	 setTimeout(function(){
	 	$('#alertprivate').clone().append('#customer-form');
	 },3000); 

	 /*==================== CALCULADORA AJAX =======================*/
	 	setTimeout(tableColor,2000);

	 	$(document).on('change', 'input[name=quote_quantity]', function(evt) {
        //console.log(evt.target);
        obtenerCalculo(evt);
        	//Spinner to change on product list
        	var father = $(this).closest('tr.quote_item').find('.quote_product a');
		 	var imgSon = father.find('img');
		 	chargingElement(father, imgSon);
		 	setTimeout(function(){unChargingElement(father, imgSon)},800);
    	});
    	//Spinner to change on product list
    	$(document).on('click tap', '.quote_quantity_delete i', function(evt){
    		var father = $(this).closest('tr.quote_item').find('.quote_product a');
		 	var imgSon = father.find('img');
		 	chargingElement(father, imgSon);
    	});
		 $('#quantity_wanted').on('change mousewheel touchspin', function(evt){
		 	obtenerCalculo(evt);
		 	
		 		
		 });	
		 //Change color table on product
		 prestashop.on("updatedProduct",function(){
		 	tableColor();
		 	//$('#quantity_wanted').val(qty);
		 	closeLoader();
		 	hiddenSize();

		 });
		 prestashop.on("handleError",function(){
		 	closeLoader();
		 });
		 
		 $("ul.variant-links.list-inline").on('click', function(dt){
	 		openLoader();
	 		//console.log("click sobre color");
	 		//console.log(dt);
		 });
		 $("#_mobile_quotecart").find('.quotation_cart .header i').on('click', function(dt){
	 		console.log($('#_mobile_quotecart').find('a.quote-summary').length);
	 		if($('#_mobile_quotecart').find('a.quote-summary').length > 0){
	 		openLoader();
	 		//console.log("click sobre color");
			}
		 });
		 //Spinner to change on product list
		 $(document).on('click','.remove-from-cart.close',function(){
		 	//console.log("hello");
		 	var father = $(this).closest('div.product-line-grid').find('.product-line-grid-left .product-thumbnail');
		 	var imgSon = father.find('img');
		 		chargingElement(father, imgSon);
		 });
		 $(document).on('change','.js-cart-line-product-quantity.form-control',function(){
		 	console.log("Change quantity -> s-cart-line-product-quantity");
		 	//console.log("esto es la variable disableCheckout: " + disableCheckout);
		 	var father = $(this).closest('div.product-line-grid').find('.product-line-grid-left .product-thumbnail');
		 	var imgSon = father.find('img');
		 		chargingElement(father, imgSon);
		 });
		 

		 function chargingElement(cl, cl2){
		 	if(cl && cl2){
		 			cl.find('.fa-spinner.list').remove();
			 		cl.append('<i class="fa fa-spinner fa-spin list" ></i>');
			 		cl2.css("opacity", "0.25");
			 }else if(cl){
			 	cl.find('.fa-spinner.list').remove();
			 	cl.append('<i class="fa fa-spinner fa-spin"></i>');
			 }else{}	 	
		 }

		 function unChargingElement(cl, cl2){
		 	if(cl && cl2){
			 	cl.find('.fa-spinner.list').remove();
			 	cl2.css("opacity", "1");
			 }else if(cl){
			 	cl.find('.fa-spinner.list').remove();
			 }else{}	 	
		 }

		 

	 	/*change color table auto or selected */
	 	function tableColor(){
	 		var formColor = $('#add-to-cart-or-refresh').find('.product-variants-item');
	 		var backColorDom = $('#backColor');
	 		//console.log(formColor);
		 		formColor.each(function(key, value){
		 			//console.log( "Probando each: " + key + " : " + value.innerText);
		 			//console.log(formColor[key]);
		 			 if(formColor[key].children[0].innerText.toUpperCase() == "COLOR"){
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
	 	//console.log("ESto es target: " +target);
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
	 			//console.log("qty: " + parametros.prodqty + " price: " + parametros.prodprice + " Data-pack: " + parametros.QtyxData);
	 			//console.log(url.value);
	 		},
	 		success: function(resultado, text){
	 			priceLocation.find('.product-amount').html(" " + resultado);//value tag price html
	 				
	 			$('#table_qty_qty').html(parametros.QtyxData);
	 			//console.log("Resultado obtenido");
	 			//console.log(resultado);
	 			//console.log('------------------------------');
	 			giveTotalQuote(parametros.proddata);
	 			//console.log("Esto es un; " + parametros.proddata);
	 		},
	 		 error: function (request, status, error) {
	 		 	//console.log("Hay un error: " + error);
	 		}
	 	});
	 }

	 function giveTotalQuote(PackaValue){
	 	var formQuote = $('#quote_summary').find('tbody tr.quote_item');
	 	//console.log(formQuote);
	 	var conteoTotalQuote = 0;
	 	var conteoTotalQuantity = 0;
	 	var conteoTotalQuantityUnid = 0;
		 	formQuote.each(function(key, value){
		 		//console.log(value);
		 		var priceRow = parseFloat($(value).find('span.product-amount')[0].innerText.replace(",", ""));
		 		//console.log(priceRow);
		 		var qtyRow = parseInt($(value).find('#quantity_wanted').val());
		 		//console.log("Esto es el valor quantity: " + qtyRow);

		 		conteoTotalQuote = conteoTotalQuote+priceRow;
		 		conteoTotalQuantity = conteoTotalQuantity+qtyRow;
		 		conteoTotalQuantityUnid = PackaValue*conteoTotalQuantity;
		 	});
		 	
		 	//console.log('------------------------------');
		 	$('#quote_summary').find('.product-amount-quote').html(conteoTotalQuote.toLocaleString('en-US'));
		 	$('#quote_summary').find('.product-amount-quote-qty').html(conteoTotalQuantity);
		 	$('#quote_summary').find('.product-amount-quote-qty-und').html(conteoTotalQuantityUnid);
	 }

	 function hiddenSize(){
	 	/*-------------- DISPLAY NONE SIZE ----------*/
	 	//var shopName = $.trim($('title#page-titles').prevObject.context.title.split("|")[0].toLowerCase());
          var shopName = prestashop.shop.name;
          var idGroupCustomer = prestashop.customer.id_default_group;
          //console.log(shopName)
          if(shopName == "azaimayoreo" && idGroupCustomer != 12){
	 			var formSize = $('#add-to-cart-or-refresh').find('.product-variants-item');
	 				formSize.each(function(key, value){
	 					//console.log(value);
	 					if(formSize[key].children[0].innerText.toUpperCase() == "SIZE"){
			 			//	console.log("encontrado size");
			 				$(formSize[key]).css("display","none");
			 			}
	 			});
	 		}
	}
/*==================== Validation email form input  =======================*/
	$('input[name$="email"]').on('change', emailvalidation);


	function emailvalidation() {
		//console.log("Validando email");
		//console.log(this);

		var request;
		try {
			request= new XMLHttpRequest();
		}
		catch (tryMicrosoft) {
			try {
				request= new ActiveXObject("Msxml2.XMLHTTP");
			}
			catch (otherMicrosoft) 
			{
				try {
				request= new ActiveXObject("Microsoft.XMLHTTP");
				}
				catch (failed) {
					request= null;
				}
			}
		}
		var uriPhp;
		 	if(window.location.hostname =="localhost"){
		 		uriPhp = '/azai19b/themes/AzaiShop/assets/php2/';
		 	}else{
		 		uriPhp = '/themes/AzaiShop/assets/php2/';
		 		//console.log(window.location.origin + uriPhp+'calculadora.php');
		 	}

		var url= uriPhp+ "/emailvalidation.php";
		var emailaddress= $(this);
		var emailaddressval= emailaddress.val();
		//console.log(emailaddressval);
		var vars= "email="+emailaddressval;
		request.open("POST", url, true);

		request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

		request.onreadystatechange= function() {
			if (request.readyState == 4 && request.status == 200) {
				var return_data=  request.responseText;
				var textvalidation = "Invalid email address ";

					$('.emailvalidationNotification').remove();
					if(request.responseText.trim() == textvalidation.trim()){
						$(emailaddress).after("<p style='color:red;' class='emailvalidationNotification'>"+return_data+"</p>");
					}
				//console.log(return_data);
				//console.log(this);
			}
		}
		request.send(vars);
	}

	/*==================== Seller_code_Profile  =======================*/
	//console.log(prestashop);
	if(prestashop.page.page_name == "authentication"){
		console.log("Pagina de autentificación");
		seller_code();
	}

	function seller_code(){
		var clientType = getQueryVariable("client");
		var codeSeller = getQueryVariable("code");

			console.log(clientType);
			console.log(codeSeller);
			
			//Select type client
			if(clientType == "t" || clientType == "tienda" || clientType == "w" || clientType == "shop" || clientType == "ref"){
				clientType = "Tienda";
			}else if(clientType == "c" || clientType == "cliente" || clientType == "vip" || clientType == "customer"){
				clientType = "Customer";
			}else{
				console.log("No hay tipo de cliente en la url");
			}
				console.log("Esto es el client: "+ clientType );
	
		//Selected the seller_code_profile
		if(clientType){
			var client_tag_form = $('select[name=seller_code_profile]').find('option[value='+clientType+']');
				client_tag_form.attr("selected", "selected");
				//console.log(client_tag_form);
		}else{
			console.log("Var perfil no establecida en URL");
		}

		//Input the seller_code
		if(codeSeller){
			var client_code_seller = $('input[name=seller_code]');
				client_code_seller.val(codeSeller);
				//console.log(cliente_code_seller);
		}else{
			console.log("No hay código en la URL.");
		}
	}

	function getQueryVariable(variable)
	{
       var query = window.location.search.substring(1);
       var vars = query.split("&");
       for (var i=0;i<vars.length;i++) {
               var pair = vars[i].split("=");
               if(pair[0] == variable){return pair[1];}
       }
	       return(false);
	}
});

/************************************************************/
/*************** Code using on core.js **********************/
/*************************************************************/


 	/***** Action then updating cart and retriview minOrder *****/
	    /*  var prestashopCart = $.trim($('#cart-subtotal-products').find('.value')[0].innerText.replace("$", ""));
			 console.log("updating cart : "+ prestashopCart + " <=> " + cgma_minimal_order);

			 cgmaMinialOrder(cgma_minimal_order, prestashopCart);

			 function cgmaMinialOrder(minOrder, amountCart){
		 		if(minOrder){
		 			var boxCartS = $('.cart-summary');
		 			var minOrderError = $('#cgma_errors');
		 			var btnCartBox = $('#cartAction');

		 			var cartSummary = $('.cart-summary');
		 			if(cartSummary.hasClass("open-slidebar")){
				 			if(minOrder > amountCart){
				 			
				 					console.log("Aún no alcanzas el mínimo de order: " + minOrder);
				 					minOrderError.show();
				 					btnCartBox.addClass("disabled");
				 				
				 			}else{
				 				console.log("Pasando al carrito");
				 				minOrderError.hide();
				 				btnCartBox.removeClass("disabled");
				 			}
				 	}
		 		}
		 	} */
	/***** Action then updating cart and retriview minOrder *****/	
 
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


	/*==================== LOGIN-CONTENT DISPLAY WHEN PRESS MENU =======================*/
	// VARIABLE AND ACTION TO OPEN MOBILE MENU COMPLETE
	var mobilmenu = $('.top_menu').find('.menu-title');
	var menulogin = $('#header-login');
	
	mobilmenu.on("touchstart", OpenMobilMenuIcon);
	$('.icon-menu-login').on("touchstart", OpenMobilMenu);

	//OPEN MOBILE MENU FROM FOOTER -> CATEGORY MENU
	$('#footer').find('section.blockcategories_footer.footer-block h4').on("touchstart", function(e){
		e.preventDefault();
		OpenMobilMenuIcon();
		$('ul.top-level-menu').show().animate({ scrollTop: '0px'});
		console.log("Hiciste click en category footer");
	});

		//FUNCTION TO OPEN ICON UPSET TO MOBILE MENU
		function OpenMobilMenuIcon(e){
			$('.top_menu').find('.iconos-menu-mobile').toggleClass('active-imb');
			console.log('click creado para abrir iconos mobile menu');
		}
		//FUNCTION TO SHOW MOBILE MENU
	 	function OpenMobilMenu(e){
			var menuloginul = menulogin.find('ul.header-login-content');
			menulogin.find('ul.header-login-content').toggleClass("active-b");
			menulogin.find('.tm_header_user_info').toggleClass("active");
			menulogin.find(".menu-myaccount").toggleClass("active-b");
			
			/*---------- SCROLL TO BOTTOM WHEN OPEN DE LOGIN MENU-----------*/
			setTimeout($('ul.top-level-menu').animate({ scrollTop: $(document).height() }, 'slow'), 600);
	      	console.log('slow down icon menu');
      	
      }

	//
    /*==================== MENU LOGIN SESIÓN - MOBILE =======================*/
	
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
    
/*==================== HAVE A CODE BEHAVIOR TITLE =======================*/
$('#checkout-payment-step').on('click', '.promo-code-title-btn', function(){
	console.log("encontrado");
	$('#cart-voucher-promo').find('#promo-code').addClass('show');
	
});

/*==================== CHANGE COLOR ADD TO BAG =======================*/

$('#box-cart-btn').on('click', function(e){
	console.log("agregando clase gradiend-border");
	console.log(e);
	$('#box-cart-btn').addClass("gradient-border");	
	setTimeout(butNormal, 5000);
});
function butNormal(){
	$('#box-cart-btn').removeClass("gradient-border");
	console.log("Removiendo clase gradiend-border");

}



 /*==================== SHOW ORDEN RESUMEN BEHAVIOR =======================
$('#order-summary-content')..on('click', ".btn-order-summary", function(){
	 //$('#show-orden').find('#order-detail-content').toggleClass("active");
	 $('#order-summary-content').toggleClass("active");
	 $('#order-summary-content').find('final-resumen-div').toggle(300, 'swing');
	 });

	$('#show-orden').find('.close-resumen').on('click', function(e){
		 $('#show-orden').find('#order-detail-content').hide();
		 $('#show-orden').toggleClass("active");
		 e.preventDefault();
});*/




 /*==================== SECTION REGISTER - FORM =======================*/
 	//FUNCTION UTILIZED ON CUSTOMER_ACCOUNT_FORM.TPL DELUXES
 	// $('input:radio[name="id_customertype"]').change(function(){
  //               console.log($(this).val());

  //               if($(this).val() === 'wholesale'){
  //                  	$('div#js_wholesale_form').show();
  //                   $('p#js_wholesale_msg').show();
  //                   $('input#uploadBtn').attr("required", true);
  //                   console.log("Seleccion: wholesale");
  //               }else{
  //                   $('div#js_wholesale_form').hide();
  //                   $('p#js_wholesale_msg').hide();
  //                   $('input#uploadBtn').attr("required", false);
  //                   console.log("Selección:Retail");
  //               }
  //           });
});
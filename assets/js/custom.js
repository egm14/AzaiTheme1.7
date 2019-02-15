 
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
    
/*==================== HAVE A CODE BEHAVIOR TITLE =======================*/
/*$('#checkout-payment-step').on('click', '.promo-code-title-btn', function(){
	console.log("encontrado");
	$('#cart-voucher-promo').find('#promo-code').addClass('show');
	
});*/

/*==================== CHANGE COLOR ADD TO BAG =======================*/

/*$('#box-cart-btn').on('click', function(e){
	console.log("agregando clase gradiend-border");
	console.log(e);
	$('#box-cart-btn').addClass("gradient-border");	
	setTimeout(butNormal, 5000);
});
function butNormal(){
	$('#box-cart-btn').removeClass("gradient-border");
	console.log("Removiendo clase gradiend-border");
}*/

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
	console.log(vb);
	vb.addClass("gradient-border");	
	var add = vb;
	setTimeout(function(){
		vb.removeClass("gradient-border")
		console.log("Removiendo clase gradiend-border");
		}, 6000);	
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
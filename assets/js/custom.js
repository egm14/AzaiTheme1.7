 
/*=========== Fancy spinner - Windows ==========*/
$(window).on('ready', function () {
	      setTimeout(function () {
		    //$(".loader-page").css({visibility:"hidden",opacity:"0"})
		    $(".loader-page").hide();
		  }, 300);
		  console.log("Spinner fuera luego del documento estar ready");
		});

$(document).ready(function(){
	/*==================== SECTION PRODUCT - AJAX BLOCK CART =======================*/

	/*for product page 'add' button...
     $('#add_to_cart').on("click", function(ee){
     	ee.preventDefault();
     	$('#header .cart_block')
            .stop(true, true)
            .slideDown(450)
            .prev()
           .addClass('active');
    	setTimeout(function(){
          $('#header .cart_block')
            .stop(true, true)
            .slideUp(450)
            .prev()
            .removeClass('active');
    	},3000);
     });*/

     
    
     var loader = $(".loader-page");
     /*==================== SPINNER ELEMENT LINK A TO MOBILE  =======================
		

		var aElem = $('body');
		
     	Hammer(aElem[0]).on("tap", function(event){
     		var aL = event.target;
     		//console.log("Se ha hecho: "+ event.type);
     		//console.log(aL.localName);
     		//console.log("padre : "+ aL.offsetParent.localName);
     		//console.log(event);

     		if((aL.localName == "a") || (aL.offsetParent.localName == "a")){
     			console.log("es un elemnto aA -AAAAAA");
     		 
     		 /*-------- Depurando variables --------------
     	
		     	//var alName = event.handleObj.selector || "undefine";
		     	var aParentClass = aL.parentNode.className;	
		     	var aBaseUri = aL.baseURI;
		     	var BaseUriD = aBaseUri + "#";

		     	if(aL.href){
		     		var aLink = aL.href;
		     		console.log("Elemento href: " + aLink);
		     		var aLinksplit = aLink.split(":")[0];
		     		/*--------- REcorriendo URL SPLIT - comprobando query ----------
		     		if(aLink.indexOf('?') != -1){
					aLinksplit = aLink.split("?")[1].split("=")[0];
					console.log("Delete link:" + aLinksplit);
					//console.log("Simbolo de: ?");
					}

					/*--------Recorriendo URL SPLIT - comprobar si contiene pagination --------
				var aLinksplit2 = aLink.split("/");
				var abSplit = aLinksplit2.length - 1;
				var aLinksplit2b = aLinksplit2[abSplit].split("-")[0];
				//console.log(aLinksplit2);
				console.log(aLinksplit2b);
		     }
		     	
		     	//console.log("Selector " + alName);	
		     	//console.log("data-image: " + aL.dataset.zoomId);
		     	//console.log("aBaseUri: " + aBaseUri);
		     	//console.log("location.href: " + location.href);
		     	//console.log("Split element: " + aLinksplit);
		     	console.log(aParentClass);
		     	//console.log(event);

		     	if(aL.parentElement.localName == "a"){
		     		if(aL.parentElement.href.split(".")[1] == "html"){
		     		setTimeout(function () {openLoader() }, 300);
			      			console.log("Spinner a mostrar padre.");
		     	}else{
		     		console.log("No se puede mostrar Spinner padre.");
		     	}
		     }

				/*-------- Condiciones para aplicar spinner loader -------------
				if((aL.localName = "a") && (aLinksplit == "http" || aLinksplit == "https")){
				  	if((aLinksplit !="delete" || aLinksplit != "add") && (aL.href.split(".")[1] != "html#") && (aL.dataset.zoomId != "MagicZoomPlusImageMainImage") && (aParentClass != "shopping_cart") && ("remove_link") && (aLink != aBaseUri) && (aLink !== null) && (aLink != "javascript:;") && (aLink != BaseUriD) && (aL.classList[0] !== "add_to_compare") && (aL.offsetParent.localName !== "h4")){
			      			setTimeout(function () {openLoader() }, 300);
			      			console.log("Spinner a mostrar");

					      	if((aLinksplit2b == "page")){
					      		setTimeout(function () {closeLoader() }, 300);
					      		console.log("spinner loader out 2");
				     		}else{}
			     	}else{
				     	console.log("No se puede mostrar spinner")}
				  }
				  console.log("Spinner in/out");
			}
		});*/
  

     setTimeout(function () {openLoader() }, 300);
			      			console.log("Spinner a mostrar");

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
     /*==================== SIZE CHART  =======================*/

     /* SIZE - CHART- FANCYBOX*/
	  $('.sizes-chart').on("click", function(e){
	  	e.preventDefault();
	  	console.log("Size-chart: me hicieron click");

	  	if (window.innerWidth > 768) {
	  		var wid = 500;
	  		var hei = 750;
	  	}else if(window.innerWidth < 768){
	  		var wid = 500;
	  		var hei = 500;
	  	}else if(window.innerWidth > 400){
	  		var wid = 320;
	  		var hei = 500;
	  	}

	  /*$('.sizes-chart').fancybox({
	  	 'type': 'iframe',
		 'width': wid,
		 'max-height': hei,
		 'fitToView' : true,
		 'scrolling' : 'auto',
		 //'autoScale': true,
		 'autoSize' : true
	  	});*/
	  });
	  

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
    

 /*==================== SHOW ORDEN RESUMEN BEHAVIOR =======================*/
$('#show-orden').on('click', ".span", function(){
	 //$('#show-orden').find('#order-detail-content').toggleClass("active");
	 $('#show-orden').toggleClass("active");
	 $('#show-orden').find('#order-detail-content').toggle(300, 'swing');
	 });

	$('#show-orden').find('.close-resumen').on('click', function(e){
		 $('#show-orden').find('#order-detail-content').hide();
		 $('#show-orden').toggleClass("active");
		 e.preventDefault();
});



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
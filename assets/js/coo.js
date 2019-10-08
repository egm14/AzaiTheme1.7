$(document).ready(function(){

	//document.cookie = "language=true; expires=Thu, 31 Dec 2019 12:00:00 UTC; path=/";

	var cookieLangue = readCookie("cookLanguage");
	var modalLangue = $(document).find('#languagemodal');
	var cookieTimer = 365;

	if(!cookieLangue){
		modalLangue.modal();

		modalLangue.on("click tap", function(e){
			//console.log($(e.target));
			modalLangue.find('a').removeClass("active");
			$(e.target).closest('a').addClass("active");
			//console.log($(e.target).closest('a'));
			//console.log($(this));
			if($(e.target).attr('id') != modalLangue.attr('id')){
				createCookie("cookLanguage", $(e.target).closest('a').data('language'), cookieTimer);
				//console.log("cookLanguage btn: " + $(e.target).closest('a').data('language'));

				if($(e.target).closest('a').data('language') == prestashop.language.iso_code){
					//console.log("Son el mismo lenguaje: " + prestashop.language.iso_code); 
					modalLangue.modal("hide");
				}else{

						var menuLangues = $(document).find('.language-selector .dropdown-menu a');
						
						menuLangues.each(function(key, value){
							console.log(value);	
							if($(value).data("language") === $(e.target).closest('a').data('language')){
								console.log("este el nuevo link: " + $(value).attr('href'));
								location.href = $(value).attr('href');
							}
						});
	
						//location.href = prestashop.urls.base_url + $(e.target).closest('a').data('language');
						//console.log("cookLanguage Relink: " + $(e.target).closest('a').data('language'));
				}
			}else{
				//createCookie("cookLanguage", prestashop.language.iso_code, 365);
				//console.log("No será creada la cookLanguage: " + prestashop.language.iso_code);
			}
		});
	}

	$(document).on("click tap", ".language-selector .dropdown-menu a", function(e){
		//console.log("select language: " +$(this).data("language"));
		createCookie("cookLanguage", $(this).data("language"), cookieTimer);

	});

	/*==================== Seller_code_Profile  =======================*/
	//console.log(prestashop);
	if(getQueryVariable("cl")){
		createCookie("client", getQueryVariable("cl"), cookieTimer);
	}
	if(getQueryVariable("ref")){
		createCookie("referent", getQueryVariable("ref"), cookieTimer);
	}

	if(prestashop.page.page_name == "authentication"){
		//console.log("Pagina de autentificación");
		seller_code();
	}

		function seller_code(){
			var clientType = readCookie("client");//client
			var codeSeller = readCookie("referent");//code

				//console.log(clientType);
				//console.log(codeSeller);
				
				//Select type client
				if(clientType == "t" || clientType == "tienda" || clientType == "w" || clientType == "shop" || clientType == "ref"){
					clientType = "Tienda";
				}else if(clientType == "c" || clientType == "cliente" || clientType == "vip" || clientType == "customer"){
					clientType = "Customer";
				}else{
					console.log("No hay tipo de cliente en la url");
				}
					//console.log("Esto es el client: "+ clientType );
		
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
	/*==================== Seller_code_Profile  =======================*/

	function createCookie(name,value,days) {
		if (days) {
			var date = new Date();
			date.setTime(date.getTime()+(days*24*60*60*1000));
			var expires = "; expires="+date.toGMTString();
		}
		else var expires = "";
		document.cookie = name+"="+value+expires+"; path=/";
	}

	function readCookie(name) {
		var nameEQ = name + "=";
		var ca = document.cookie.split(';');
		for(var i=0;i < ca.length;i++) {
			var c = ca[i];
			while (c.charAt(0)==' ') c = c.substring(1,c.length);
			if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
		}
		return null;
	}

	function eraseCookie(name) {
		createCookie(name,"",-1);
	}

});
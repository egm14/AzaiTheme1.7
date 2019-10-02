$(document).ready(function(){


	//document.cookie = "language=true; expires=Thu, 31 Dec 2019 12:00:00 UTC; path=/";

	var cookieLangue = readCookie("cookLanguage");
	var modalLangue = $(document).find('#languagemodal');

	if(!cookieLangue){
		modalLangue.modal();

		modalLangue.on("click tap", function(e){
			//console.log($(e.target));
			//console.log($(e.target).closest('a'));
			//console.log($(this));
			if($(e.target).attr('id') != modalLangue.attr('id')){
				createCookie("cookLanguage", $(e.target).closest('a').data('language'), 365);
				//console.log("cookLanguage btn: " + $(e.target).closest('a').data('language'));

				if($(e.target).closest('a').data('language') == prestashop.language.iso_code){
					//console.log("Son el mismo lenguaje: " + prestashop.language.iso_code); 
					modalLangue.modal("hide");
				}else{
					location.href = prestashop.urls.base_url + $(e.target).closest('a').data('language')
					//console.log("cookLanguage Relink: " + $(e.target).closest('a').data('language'));
				}
			}else{
				//createCookie("cookLanguage", prestashop.language.iso_code, 365);
				//console.log("No será creada la cookLanguage: " + prestashop.language.iso_code);
			}
		});
	}

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
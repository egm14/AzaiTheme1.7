/*
 * 2002-2017 Jetimpex
 *
 * JX Header Account
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the General Public License (GPL 2.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/GPL-2.0

 * @author     Jetimpex
 * @copyright  2002-2017 Jetimpex
 * @license    http://opensource.org/licenses/GPL-2.0 General Public License (GPL 2.0)
 */

function in_array(value, array) {
  for (var i in array)
    if ((array[i] + '') === (value + ''))
      return true;
  return false;
}

jxha = {
  getQueryParameters: function (query) {
    var post = new Array();
    for (var i = 0; i < query.length; i++) {
      post[query[i]['name']] = query[i]['value'];
    }
    return post;
  },
  ajax: function () {
    this.init = function (options) {
      this.options = $.extend(this.options, options);
      this.request();

      return this;
    };

    this.error = function (XMLHttpRequest, textStatus, errorThrown) {
      var error = "TECHNICAL ERROR: unable to load form.\n\nDetails:\nError thrown: " + XMLHttpRequest + "\n" + 'Text status: ' + textStatus;
      $('body').append('<div id="jxha-modal-error" class="modal fade" tabindex="-1" role="dialog"><div class="modal-dialog" role="document"><div class="modal-content"><div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button></div><div class="modal-body">' + error + '</div></div></div></div>');
      $('#jxha-modal-error').modal();
    };

    this.options = {
      type: 'POST',
      url: prestashop.urls.base_url,
      cache: false,
      async: true,
      //dataType: "json",
      success: function () {
      },
      error: this.error
    };

    this.request = function () {
      $.ajax(this.options);
    };
  },
  init: function (type) {
    if (type == 'popup' || type == 'leftside' || type == 'rightside') {
      $(document).on('click', '#jx-header-account-link', function () {
        $('#jxha-modal').modal();
      })
    }
    return this;
  }
};

$(document).ready(function () {
  var jxheaderaccount = new jxha.init(JXHEADERACCOUNT_DISPLAY_TYPE);

  $(document).on('submit', '[id*="login-content-"] form', function (e) {
    e.preventDefault();
    submitLoginFunction($(this).closest('.login-content'));
  });
  $(document).on('submit', '[id*="create-account-content-"] form', function (e) {
    e.preventDefault();
    submitCreate($(this).closest('.create-account-content'));
  });
  $(document).on('submit', '[id*="create-account-form"] form', function (e) {
    e.preventDefault();
    submitCreate($(this).closest('.register-form'), e);
  });
  $(document).on('submit', '[id*="forgot-password-content-"] form', function (e) {
    e.preventDefault();
    submitRetrieve($(this).closest('.forgot-password-content'));
  });

  $('.header-login-content a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    $(e.target).removeClass('active');
  })
});

function submitLoginFunction(elem) {
  var options = {
    data: {
      fc: 'module',
      module: 'jxheaderaccount',
      controller: 'auth',
      submitLogin: 1,
      ajax: false,
      email: elem.find('[name=email]').val(),
      password: elem.find('[name=password]').val(),
      token: prestashop.token
    },
    success: function (jsonData) {
      if (jsonData.hasError) {
         console.log("Está iniciando sesión :: success");
        var errors = '';
        for (error in jsonData.errors) {
          if (error != 'indexOf' && error != '' && error != 'back') {
            if (jsonData.errors[error] == '') {
              elem.find('[name=' + error + ']').parents('.form-group').removeClass('has-error');
              elem.find('[name=' + error + ']').parents('.form-group').find('.help-block').remove();
            } else {
              elem.find('[name=' + error + ']').parents('.form-group').addClass('has-error');
              elem.find('[name=' + error + ']').parents('.form-group').find('.help-block').remove();
              elem.find('[name=' + error + ']').parent().append('<div class="help-block"><ul><li class="alert alert-danger">' + jsonData.errors[error] + '</li></ul></div>');
            }
          } else if (error == '') {
            if (jsonData.errors[error] == '') {
              elem.find('.main-help-block ul').html('')
            } else {
              elem.find('.main-help-block ul').html('<li class="alert alert-danger">' + jsonData.errors[error] + '</li>');
            }
          }
        }
      } else {
        document.location.reload();
      }
    }
  };
  var ajax = new jxha.ajax();
  ajax.init(options);
}

function submitCreate(elem){
  //console.log(elem)
  var element = jxha.getQueryParameters(elem.find('form').serializeArray())
  var datos = $.extend({}, element,{
  //var datos = JSON.stringify(jxha.getQueryParameters(elem.find('form').serializeArray()), { 
      submitCreate: 1,
      fc: 'module',
      module: 'jxheaderaccount',
      controller: 'auth',
      ajax: true,
      contenType: "application/json; charset=utf-8"
    })
  
  var options = {
    data: JSON.parse(JSON.stringify(datos)),
    beforeSend: function(jsonData){
      var userAlert = $('#alerts-n')
      userAlert.find('.alerts.create-acount.alert-processing').addClass('active')
      console.log(element)
      console.log("Clic creando cuenta")
    },
    error: function (jsonData, textStatus, errorThrown) {
      console.log(jsonData)
      console.log("TextSatus: " +textStatus)
      console.log("errorThrown: "+errorThrown)

      var userAlert = $('#alerts-n')
      userAlert.find('.alerts.create-acount.alert-processing').removeClass('active')
      userAlert.find('.alerts.create-acount.alert-error').addClass('active')

      elem.find('[name=email]').parents('.form-group').addClass('has-error');
      elem.find('[name=email]').parents('.form-group').find('.help-block').remove();
      elem.find('[name=email]').parent().append('<div class="help-block"><ul><li class="alert alert-danger">' +/* error.message */ "ERRORES" + '</li></ul></div>');
    },
    dataFilter: function(xhrdata, type){
      //console.log(xhrdata)
      JSON.parse(JSON.stringify(xhrdata))
      return xhrdata
    },
    success: function (datab, textStatus, jqXHR) {
      //console.log(datab)
      //console.log("Uusario registrado con request adquirido")
      var userAlert = $('#alerts-n')
      if (datab.hasError) {
         userAlert.find('.alerts.create-acount.alert-processing').removeClass('active')
         userAlert.find('.alerts.create-acount.alert-error').addClass('active')
        var errors = '';
        for (error in datab.errors) {
          if (error != 'indexOf' && error != '' && error != 'back') {
            if (datab.errors[error] == '') {
              elem.find('[name=' + error + ']').parents('.form-group').removeClass('has-error');
              elem.find('[name=' + error + ']').parents('.form-group').find('.help-block').remove();
            } else {
              elem.find('[name=' + error + ']').parents('.form-group').addClass('has-error');
              elem.find('[name=' + error + ']').parents('.form-group').find('.help-block').remove();
              elem.find('[name=' + error + ']').parent().append('<div class="help-block"><ul><li class="alert alert-danger">' + datab.errors[error] + '</li></ul></div>');
            }
          } else if (error == '') {
           
            userAlert.find('.alerts.create-acount.alert-processing').removeClass('active')
            userAlert.find('.alerts.create-acount.alert-error').addClass('active')
            if (datab.errors[error] == '') {
              elem.find('.main-help-block ul').html('')
            } else {
              elem.find('.main-help-block ul').html('<li class="alert alert-danger">' + datab.errors[error] + '</li>');
            }
          }
        }
      } else {
        userAlert.find('.alerts.create-acount.alert-processing').removeClass('active')
        userAlert.find('.alerts.create-acount.alert-success').addClass('active')
        var menuUser = $('#_mobile_user_info').find('.dropdown-menu.dropdown-menu-right')
        var menuUser2 = $('#_desktop_user_info').find('.dropdown-menu.dropdown-menu-right')
       //console.log("cuenta creada exitosamente I")
          if(menuUser){
             menuUser.removeClass('show')
             menuUser.css("display", "none")
          }
          if(menuUser2){
             menuUser2.removeClass('show')
             menuUser2.css("display", "none")
          }
          console.log("Esto fue un éxito....")
          //Making redirection to modulo page preference at site
          var shopName = $.trim($('title#page-titles').prevObject.context.title.split("|")[0].toLowerCase());
          console.log(shopName)
          if(shopName == "azaimayoreo"){
            var uriPhp;
              if(window.location.hostname =="localhost"){
                      urihref = window.location.pathname.split("/");
                      uripage = "/"+urihref[1]+"/"+urihref[2]
                      console.log("/"+uripage+"/module/idxvalidatinguser/deluxevalidatinguser")
                      setTimeout(function(){
                        window.location.href = uripage+"/module/idxvalidatinguser/deluxevalidatinguser"
                      },3000)
              }else{
                      urihref = window.location.pathname.split("/");
                      uripage = "/"+urihref[1] 
                      setTimeout(function(){
                      window.location.assign(uripage +"/module/idxvalidatinguser/deluxevalidatinguser")
                      },3000)
              } 
          }else{
              var loginUrl = $('footer#footer').find('.footer-column div .block_myaccount_infoso h3 a').context.referrer
               //console.log(loginUrl)
              setTimeout(function(){
              document.location.assign(loginUrl)
              }, 2000)

          }
      }
    } 
  }
    var ajax = new jxha.ajax();
    ajax.init(options).responseJSON;
    console.log(ajax.options);
}

function submitRetrieve(elem) {
  var options = {
    data: {
      retrievePassword: 1,
      fc: 'module',
      module: 'jxheaderaccount',
      controller: 'password',
      ajax: true,
      email: elem.find('[name=email]').val()
    },
    success: function(jsonData)
    {
      if (jsonData.hasError)
      {
        var errors = '';
        for(error in jsonData.errors)
          if(error != 'indexOf')
            errors += '<li class="alert alert-danger">' + jsonData.errors[error] + '</li>';
        elem.find('.main-help-block ul').html(errors);
      } else {
        elem.find('.main-help-block ul').html('<li class="alert alert-success">' + jsonData.confirm + '</li>');
      }
    }
  };
  var ajax = new jxha.ajax();
  ajax.init(options);
}

/**** ADdin new for to parsejSON***/
var parseJSON = function (data) {
    if (window.JSON){
        return window.JSON.parse(data);
    }else {
        var jsoner = {};
        data = data.replace(/^\s+/,"").replace(/\s+$/,""); // Trim the string
        json = (function (jsstring) {
            // Borrowed from jquery 1.7.1
            var rvalidchars = /^[\],:{}\s]*$/,
            rvalidescape = /\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,
            rvalidtokens = /"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,
            rvalidbraces = /(?:^|:|,)(?:\s*\[)+/g;
            if (rvalidchars.test(data.replace( rvalidescape, "@" )
                    .replace( rvalidtokens, "]" )
                    .replace( rvalidbraces, ""))){
                return ( new Function( "return " + data ) )();
            }
        })();
        if (!json){
            throw new Error("Invalid JSON string");
        }
        return json;
    }
}


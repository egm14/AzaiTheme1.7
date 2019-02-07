! function(e) {
    var r = {};

    function a(n) {
        if (r[n]) return r[n].exports;
        var o = r[n] = {
            i: n,
            l: !1,
            exports: {}
        };
        return e[n].call(o.exports, o, o.exports, a), o.l = !0, o.exports
    }
    a.m = e, a.c = r, a.d = function(e, r, n) {
        a.o(e, r) || Object.defineProperty(e, r, {
            configurable: !1,
            enumerable: !0,
            get: n
        })
    }, a.n = function(e) {
        var r = e && e.__esModule ? function() {
            return e.default
        } : function() {
            return e
        };
        return a.d(r, "a", r), r
    }, a.o = function(e, r) {
        return Object.prototype.hasOwnProperty.call(e, r)
    }, a.p = "", a(a.s = 32)
}({
        32: function(e, r, a) {
                "use strict";

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
 




 var n = {
    getQueryParameters: function(e) {
        for (var r = new Array, a = 0; a < e.length; a++) r[e[a].name] = e[a].value;
        return r
    },
    ajax: function() {
        this.init = function(e) {
            return this.options = $.extend(this.options, e), this.request(), this
        }, this.error = function(e, r, a) {
            var n = "TECHNICAL ERROR: unable to load form.\n\nDetails:\nError thrown: " + e + "\nText status: " + r;
            $("body").append('<div id="jxha-modal-error" class="modal fade" tabindex="-1" role="dialog"><div class="modal-dialog" role="document"><div class="modal-content"><div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button></div><div class="modal-body">' + n + "</div></div></div></div>"), $("#jxha-modal-error").modal()
        }, this.options = {
            type: "POST",
            url: prestashop.urls.base_url,
            cache: !1,
            dataType: "json",
            success: function() {},
            error: this.error
        }, this.request = function() {
            $.ajax(this.options)
        }
    },
    init: function(e) {
        return "popup" != e && "leftside" != e && "rightside" != e || $(document).on("click", "#jx-header-account-link", function() {
            $("#jxha-modal").modal()
        }), this
    }
};
$(document).ready(function() {
new n.init(JXHEADERACCOUNT_DISPLAY_TYPE);
$(document).on("submit", '[id*="login-content-"] form', function(e) {
    var r, a;
    e.preventDefault(), r = $(this).closest(".login-content"), a = {
        data: {
            fc: "module",
            module: "jxheaderaccount",
            controller: "auth",
            submitLogin: 1,
            ajax: !0,
            email: r.find("[name=email]").val(),
            password: r.find("[name=password]").val(),
            token: prestashop.token
        },
        success: function(e) {
            if (e.hasError) {
                var a;
                for (a in e.errors) "indexOf" != a && "" != a && "back" != a ? "" == e.errors[a] ? (r.find("[name=" + a + "]").parents(".form-group").removeClass("has-error"), r.find("[name=" + a + "]").parents(".form-group").find(".help-block").remove()) : (r.find("[name=" + a + "]").parents(".form-group").addClass("has-error"), r.find("[name=" + a + "]").parents(".form-group").find(".help-block").remove(), r.find("[name=" + a + "]").parent().append('<div class="help-block"><ul><li class="alert alert-danger">' + e.errors[a] + "</li></ul></div>")) : "" == a && ("" == e.errors[a] ? r.find(".main-help-block ul").html("") : r.find(".main-help-block ul").html('<li class="alert alert-danger">' + e.errors[a] + "</li>"))
            } else document.location.reload()
        }
    }, (new n.ajax).init(a)
}), $(document).on("submit", '[id*="create-account-content-"] form', function(e) {
    //this.preventDefault();
        var userAlert = $('#alerts-n')
        userAlert.find('.alerts.create-acount.alert-processing').addClass('active')
        console.log("Clic creando cuenta");
    var r, a;
    if(document.body.id != "checkout"){
    e.preventDefault()} r = $(this).closest(".create-account-content"), a = {
        data: $.extend({}, n.getQueryParameters(r.find("form").serializeArray()), {
            submitCreate: 1,
            fc: "module",
            module: "jxheaderaccount",
            controller: "auth",
            ajax: !0
        }),
        success: function(e, textstatus, xhr) {
            //console.log(textstatus)
            //console.log(xhr.status)
            if (e.hasError) {
                var a;
                for (a in e.errors) "indexOf" != a && "" != a && "back" != a ? "" == e.errors[a] ? (r.find("[name=" + a + "]").parents(".form-group").removeClass("has-error"), r.find("[name=" + a + "]").parents(".form-group").find(".help-block").remove()) : (r.find("[name=" + a + "]").parents(".form-group").addClass("has-error"), r.find("[name=" + a + "]").parents(".form-group").find(".help-block").remove(), r.find("[name=" + a + "]").parent().append('<div class="help-block"><ul><li class="alert alert-danger">' + e.errors[a] + "</li></ul></div>")) : "" == a && ("" == e.errors[a] ? r.find(".main-help-block ul").html("") : r.find(".main-help-block ul").html('<li class="alert alert-danger">' + e.errors[a] + "</li>"))
                userAlert.find('.alerts.create-acount.alert-processing').removeClass('active')
                userAlert.find('.alerts.create-acount.alert-error').addClass('active')
                //console.log("ha ocurrido un error al crear la cuenta I")
            } else if (xhr.status == 200){
                    userAlert.find('.alerts.create-acount.alert-processing').removeClass('active')
                    userAlert.find('.alerts.create-acount.alert-success').addClass('active')
                    var menuUser = $('#_mobile_user_info').find('.dropdown-menu.dropdown-menu-right');
                    var menuUser2 = $('#_desktop_user_info').find('.dropdown-menu.dropdown-menu-right');
                    //console.log("cuenta creada exitosamente I")
                    if(menuUser){
                    menuUser.removeClass('show')
                    menuUser.css("display", "none")
                    }
                    if(menuUser2){
                    menuUser2.removeClass('show')
                    menuUser2.css("display", "none")
                    }
                    setTimeout(function(){document.location.reload()}, 3500)
                }
        },
        error: function(e) {
            r.find("[name=email]").parents(".form-group").addClass("has-error"), r.find("[name=email]").parents(".form-group").find(".help-block").remove(), r.find("[name=email]").parent().append('<div class="help-block"><ul><li class="alert alert-danger">' + e.responseText + "</li></ul></div>")
            
        }
    }, (new n.ajax).init(a)
}), //Create action to notifiación content form page
    $(document).on("submit", 'form#customer-form', function(e) {
        //this.preventDefault();
        var userAlert = $('#alerts-n')
        userAlert.find('.alerts.create-acount.alert-processing').addClass('active')
        console.log("Clic creando cuenta");
    var r, a;
    if(document.body.id != "checkout"){
    e.preventDefault()}
        r = $(this).closest(".register-form"), a = {
        data: $.extend({}, n.getQueryParameters(r.find("form").serializeArray()), {
            submitCreate: 1,
            fc: "module",
            module: "jxheaderaccount",
            controller: "auth",
            ajax: !0
        }),
        success: function(e, textstatus, xhr) {
            //console.log(textstatus)
            //console.log(xhr.status)
            if (e.hasError) {
                var a;
                for (a in e.errors) "indexOf" != a && "" != a && "back" != a ? "" == e.errors[a] ? (r.find("[name=" + a + "]").parents(".form-group").removeClass("has-error"), r.find("[name=" + a + "]").parents(".form-group").find(".help-block").remove()) : (r.find("[name=" + a + "]").parents(".form-group").addClass("has-error"), r.find("[name=" + a + "]").parents(".form-group").find(".help-block").remove(), r.find("[name=" + a + "]").parent().append('<div class="help-block"><ul><li class="alert alert-danger">' + e.errors[a] + "</li></ul></div>")) : "" == a && ("" == e.errors[a] ? r.find(".main-help-block ul").html("") : r.find(".main-help-block ul").html('<li class="alert alert-danger">' + e.errors[a] + "</li>"))
                userAlert.find('.alerts.create-acount.alert-processing').removeClass('active')
                userAlert.find('.alerts.create-acount.alert-error').addClass('active')
                //console.log("ha ocurrido un error al crear la cuenta II")
                
            } else if(xhr.status == 200) {

                    userAlert.find('.alerts.create-acount.alert-processing').removeClass('active')
                    userAlert.find('.alerts.create-acount.alert-success').addClass('active')
                    var menuUser = $('#_mobile_user_info').find('.dropdown-menu.dropdown-menu-right');
                    var menuUser2 = $('#_desktop_user_info').find('.dropdown-menu.dropdown-menu-right');
                    //console.log("cuenta creada exitosamente II")
                    if(menuUser){
                    menuUser.removeClass('show')
                    menuUser.css("display", "none")
                    }
                    if(menuUser2){
                    menuUser2.removeClass('show')
                    menuUser2.css("display", "none")
                    }
                    setTimeout(function(){document.location.reload()}, 3500)
                }
        },
        error: function(e) {
            r.find("[name=email]").parents(".form-group").addClass("has-error"), r.find("[name=email]").parents(".form-group").find(".help-block").remove(), r.find("[name=email]").parent().append('<div class="help-block"><ul><li class="alert alert-danger">' + e.responseText + "</li></ul></div>")
        }
    }, (new n.ajax).init(a)
}), $(document).on("submit", '[id*="forgot-password-content-"] form', function(e) {
    var r, a;
    e.preventDefault(), r = $(this).closest(".forgot-password-content"), a = {
        data: {
            retrievePassword: 1,
            fc: "module",
            module: "jxheaderaccount",
            controller: "password",
            ajax: !0,
            email: r.find("[name=email]").val()
        },
        success: function(e) {
            if (e.hasError) {
                var a, n = "";
                for (a in e.errors) "indexOf" != a && (n += '<li class="alert alert-danger">' + e.errors[a] + "</li>");
                r.find(".main-help-block ul").html(n)
            } else r.find(".main-help-block ul").html('<li class="alert alert-success">' + e.confirm + "</li>")
        }
    }, (new n.ajax).init(a)
}), $('.header-login-content a[data-toggle="tab"]').on("shown.bs.tab", function(e) {
    $(e.target).removeClass("active")
})
})
}
});               
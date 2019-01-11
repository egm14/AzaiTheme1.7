<?php
/**
 * 2007-2018 PrestaShop
 *
 * DISCLAIMER
 ** Do not edit or add to this file if you wish to upgrade PrestaShop to newer
 * versions in the future. If you wish to customize PrestaShop for your
 * needs please refer to http://www.prestashop.com for more information.
 *
 * @author    PrestaShop SA <contact@prestashop.com>
 * @copyright 2007-2018 PrestaShop SA
 * @license   http://addons.prestashop.com/en/content/12-terms-and-conditions-of-use
 * International Registered Trademark & Property of PrestaShop SA
 */

if (!defined('_PS_VERSION_'))
    exit;

use PrestaShop\PrestaShop\Core\Payment\PaymentOption;
   
class StripeJs extends PaymentModule
{    
    public function __construct()
    {
        $this->name = 'stripejs';
        $this->tab = 'payments_gateways';
        $this->version = '3.9.1';
        $this->author = 'NTS';
        $this->ps_versions_compliancy = array('min' => '1.7', 'max' => _PS_VERSION_);
        $this->bootstrap = true;
        $this->module_key = 'df64f54a4d1bec8b516d34ab302fa648';
		$this->author_address = '0xE0Bf1489DE32d19cAe5da5ecF411937D52118D3a';

        parent::__construct();

        $this->displayName = $this->l('Stripe Payment Pro');
        $this->description = $this->l('Accept payments with Google/ Apple Pay/ Microsoft Pay/ WeChat Pay/ 3D-Secure/ Credit Cards/ Bitcoins/ Alipay / IDEAL / SOFORT / BANCONTACT/ GIROPAY/ P24/ EPS/ Multibanco/ SEPA Direct Debit with one Stripe account');
        $this->confirmUninstall = $this->l('Warning: all the Stripe customers credit cards token and transaction details saved in your database will be deleted. Are you sure you want uninstall this module?');
        
    }

    /**
     * Stripe's module installation
     *
     * @return boolean Install result
     */
    public function install()
    {
        if (Shop::isFeatureActive())
           Shop::setContext(Shop::CONTEXT_ALL);
           
        $ret = parent::install() 
        && $this->registerHook('header') 
        && $this->registerHook('backOfficeHeader') 
        && $this->registerHook('paymentOptions')
        && $this->registerHook('orderConfirmation') 
        && $this->installDb()
        && $this->createOS();
        
        Configuration::updateValue('STRIPE_ALLOW_CARDS', 1);
        Configuration::updateValue('STRIPE_ALLOW_USEDCARD', 1);
        Configuration::updateValue('STRIPE_CAPTURE_TYPE', 1);
        Configuration::updateValue('STRIPE_MODE', 0);
        Configuration::updateValue('STRIPE_PENDING_ORDER_STATUS', (int)Configuration::get('PS_OS_PAYMENT'));
        Configuration::updateValue('STRIPE_PAYMENT_ORDER_STATUS', (int)Configuration::get('PS_OS_PAYMENT'));
        Configuration::updateValue('STRIPE_CHARGEBACKS_ORDER_STATUS', (int)Configuration::get('PS_OS_ERROR'));
        Configuration::updateValue('STRIPE_POPUP_TITLE', (int)Configuration::get('PS_SHOP_NAME'));
        Configuration::updateValue('STRIPE_CHKOUT_POPUP', 0);
        Configuration::updateValue('STRIPE_POPUP_DESC', 'Complete your transaction');
        Configuration::updateValue('STRIPE_POPUP_LOCALE', 'auto');
        Configuration::updateValue('STRIPE_WEBHOOK_TOKEN', md5(Tools::passwdGen()));

        return $ret;
    }

    /**
     * Stripe's module database tables installation
     *
     * @return boolean Database tables installation result
     */
    public function installDb()
    {
        return Db::getInstance()->Execute('CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'stripejs_transaction` (`id_stripe_transaction` int(11) NOT NULL AUTO_INCREMENT,
            `type` enum(\'payment\',\'refund\') NOT NULL,`source` varchar(32) NOT NULL,`source_type` varchar(16) NOT NULL DEFAULT \'card\',
            `btc_address` VARCHAR(100) NOT NULL, `btc_amount` decimal(12,2) NOT NULL, `id_customer` int(10) unsigned NOT NULL,
            `id_order` int(10) unsigned NOT NULL, `id_transaction` varchar(32) NOT NULL, `amount` decimal(10,2) NOT NULL, 
            `status` enum(\'paid\',\'unpaid\',\'uncaptured\',\'failed\',\'canceled\') NOT NULL, `currency` varchar(3) NOT NULL, `cc_type` varchar(16) NOT NULL, 
            `cc_exp` varchar(8) NOT NULL, `cc_last_digits` varchar(4) NOT NULL, `cvc_check` tinyint(1) NOT NULL DEFAULT \'0\', 
            `fee` decimal(10,2) NOT NULL, `mode` enum(\'live\',\'test\') NOT NULL, `date_add` datetime NOT NULL, 
            PRIMARY KEY (`id_stripe_transaction`)) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8 AUTO_INCREMENT=1');
    }

    /**
     * Stripe's module uninstallation (Configuration values, database tables...)
     *
     * @return boolean Uninstall result
     */
    public function uninstall()
    {
        @Db::getInstance()->Execute("DROP TABLE IF EXISTS `"._DB_PREFIX_."stripejs_transaction`");
        
        Configuration::deleteByName('STRIPE_PUBLIC_KEY_TEST');
        Configuration::deleteByName('STRIPE_CAPTURE_TYPE');
        Configuration::deleteByName('STRIPE_PUBLIC_KEY_LIVE');
        Configuration::deleteByName('STRIPE_MODE');
        Configuration::deleteByName('STRIPE_PRIVATE_KEY_TEST');
        Configuration::deleteByName('STRIPE_PRIVATE_KEY_LIVE');
        Configuration::deleteByName('STRIPE_PENDING_ORDER_STATUS');
        Configuration::deleteByName('STRIPE_PAYMENT_ORDER_STATUS');
        Configuration::deleteByName('STRIPE_CHARGEBACKS_ORDER_STATUS');
        Configuration::deleteByName('STRIPE_ALLOW_CARDS');
        Configuration::deleteByName('STRIPE_ALLOW_USEDCARD');
        Configuration::deleteByName('STRIPE_POPUP_TITLE');
        Configuration::deleteByName('STRIPE_CHKOUT_POPUP');
        Configuration::deleteByName('STRIPE_POPUP_DESC');
        Configuration::deleteByName('STRIPE_POPUP_LOCALE');
        Configuration::deleteByName('STRIPE_ALLOW_PRBUTTON');
        Configuration::deleteByName('STRIPE_ALLOW_ALIPAY');
        Configuration::deleteByName('STRIPE_ALLOW_SEPA');
        Configuration::deleteByName('STRIPE_ALLOW_IDEAL');
        Configuration::deleteByName('STRIPE_ALLOW_GIROPAY');
        Configuration::deleteByName('STRIPE_ALLOW_BANCONTACT');
        Configuration::deleteByName('STRIPE_ALLOW_SOFORT');
        Configuration::deleteByName('STRIPE_ALLOW_P24');
        Configuration::deleteByName('STRIPE_ALLOW_EPS');
        Configuration::deleteByName('STRIPE_ALLOW_MULTIBANCO');
        Configuration::deleteByName('STRIPE_SOFORT_WAITING_OS');
        Configuration::deleteByName('STRIPE_SEPA_WAITING_OS');
        Configuration::deleteByName('STRIPE_MB_WAITING_OS');
        Configuration::deleteByName('STRIPE_CHARGE_ORDERID');
        
        return parent::uninstall();        
    }
    
    public function createOS()
    {
        if (!Configuration::get('STRIPE_SOFORT_WAITING_OS')
            || !Validate::isLoadedObject(new OrderState(Configuration::get('STRIPE_SOFORT_WAITING_OS')))) {
            $order_state = new OrderState();
            $order_state->name = array();
            foreach (Language::getLanguages() as $language) {
                if (Tools::strtolower($language['iso_code']) == 'fr') {
                    $order_state->name[$language['id_lang']] = 'En attente de paiement Sofort';
                } else {
                    $order_state->name[$language['id_lang']] = 'Awaiting for Sofort payment';
                }
            }
            $order_state->send_email = false;
            $order_state->color = '#4169E1';
            $order_state->hidden = false;
            $order_state->delivery = false;
            $order_state->logable = false;
            $order_state->invoice = false;
            if ($order_state->add()) {
                $source = _PS_MODULE_DIR_.'stripejs/views/img/cc-sofort.png';
                $destination = _PS_ROOT_DIR_.'/img/os/'.(int) $order_state->id.'.gif';
                copy($source, $destination);
            }
            Configuration::updateValue('STRIPE_SOFORT_WAITING_OS', (int) $order_state->id);
        }
        
        if (!Configuration::get('STRIPE_MB_WAITING_OS')
            || !Validate::isLoadedObject(new OrderState(Configuration::get('STRIPE_MB_WAITING_OS')))) {
            $order_state = new OrderState();
            $order_state->name = array();
            foreach (Language::getLanguages() as $language) {
                if (Tools::strtolower($language['iso_code']) == 'fr') {
                    $order_state->name[$language['id_lang']] = 'En attente de paiement MULTIBANCO';
                } else {
                    $order_state->name[$language['id_lang']] = 'Awaiting for MULTIBANCO payment';
                }
            }
            $order_state->send_email = false;
            $order_state->color = '#2160E1';
            $order_state->hidden = false;
            $order_state->delivery = false;
            $order_state->logable = false;
            $order_state->invoice = false;
            if ($order_state->add()) {
                $source = _PS_MODULE_DIR_.'stripejs/views/img/cc-multibanco.png';
                $destination = _PS_ROOT_DIR_.'/img/os/'.(int) $order_state->id.'.gif';
                copy($source, $destination);
            }
            Configuration::updateValue('STRIPE_MB_WAITING_OS', (int) $order_state->id);
        }
        
        if (!Configuration::get('STRIPE_SEPA_WAITING_OS')
            || !Validate::isLoadedObject(new OrderState(Configuration::get('STRIPE_SEPA_WAITING_OS')))) {
            $order_state = new OrderState();
            $order_state->name = array();
            foreach (Language::getLanguages() as $language) {
                if (Tools::strtolower($language['iso_code']) == 'fr') {
                    $order_state->name[$language['id_lang']] = 'En attente de paiement SEPA';
                } else {
                    $order_state->name[$language['id_lang']] = 'Awaiting for SEPA payment';
                }
            }
            $order_state->send_email = false;
            $order_state->color = '#4199E1';
            $order_state->hidden = false;
            $order_state->delivery = false;
            $order_state->logable = false;
            $order_state->invoice = false;
            if ($order_state->add()) {
                $source = _PS_MODULE_DIR_.'stripejs/views/img/cc-sepa.png';
                $destination = _PS_ROOT_DIR_.'/img/os/'.(int) $order_state->id.'.gif';
                copy($source, $destination);
            }
            Configuration::updateValue('STRIPE_SEPA_WAITING_OS', (int) $order_state->id);
        }
        return true;
    }

    
    /**
     * Load Javascripts and CSS related to the Stripe's module
     * Only loaded during the checkout process
     *
     * @return string HTML/JS Content
     */
    public function hookHeader()
    {
      $controller = Tools::getValue('controller');
        if ($controller == "order" || $controller == 'paymentcard' || $controller == 'validation') {
            $this->context->controller->registerStylesheet($this->name.'-frontcss', '/modules/'.$this->name.'/views/css/stripe-prestashop.css');
            if(Configuration::get('STRIPE_ALLOW_CARDS') || Configuration::get('STRIPE_ALLOW_PRBUTTON') || Configuration::get('STRIPE_ALLOW_ALIPAY') || Configuration::get('STRIPE_ALLOW_SEPA') || Configuration::get('STRIPE_ALLOW_IDEAL') || Configuration::get('STRIPE_ALLOW_SOFORT') || Configuration::get('STRIPE_ALLOW_BANCONTACT') || Configuration::get('STRIPE_ALLOW_GIROPAY') || Configuration::get('STRIPE_ALLOW_P24') || Configuration::get('STRIPE_ALLOW_EPS') || Configuration::get('STRIPE_ALLOW_MULTIBANCO') || Configuration::get('STRIPE_ALLOW_WECHAT')){
              $this->context->controller->registerJavascript($this->name.'-stipeV2', 'https://js.stripe.com/v2/', array('server'=>'remote'));
              $this->context->controller->registerJavascript($this->name.'-stipeV3', 'https://js.stripe.com/v3/', array('server'=>'remote'));
              if($controller != 'validation')
              $this->context->controller->registerJavascript($this->name.'-paymentjs', '/modules/'.$this->name.'/views/js/stripe-prestashop.js');
            }
            if((Configuration::get('STRIPE_CHKOUT_POPUP') || Configuration::get('STRIPE_ALLOW_BTC')) && $controller != 'validation'){
              $this->context->controller->registerJavascript($this->name.'-stipeCheckout', 'https://checkout.stripe.com/checkout.js', array('server'=>'remote'));
              $this->context->controller->registerJavascript($this->name.'-checkoutjs', '/modules/'.$this->name.'/views/js/stripe-checkout.js');
            }
            
            $card = Db::getInstance()->executeS('SELECT btc_address,cc_type,cc_last_digits FROM '._DB_PREFIX_.'stripejs_transaction WHERE `type`="payment" && `source_type` IN ("card","applepay") && `cc_last_digits` !="" && `btc_address` !="" && id_customer = '.(int)$this->context->cookie->id_customer.' group by `source`');
            if (count($card)>0 && Configuration::get('STRIPE_ALLOW_USEDCARD') && $controller != 'validation')
               $this->context->controller->registerJavascript($this->name.'-savedcardjs', '/modules/'.$this->name.'/views/js/stripe-savedcard.js');
            
               $this->context->controller->registerJavascript($this->name.'-modaljs', '/modules/'.$this->name.'/views/js/jquery.the-modal.js');
        }               
    }
    
    public function checkCurrency($cart)
    {
        $currency_order = new Currency($cart->id_currency);
        $currencies_module = $this->getCurrency($cart->id_currency);

        if (is_array($currencies_module)) {
            foreach ($currencies_module as $currency_module) {
                if ($currency_order->id == $currency_module['id_currency']) {
                    return true;
                }
            }
        }
        return false;
    }

    public function hookPaymentOptions($params)
    {
        if (!$this->active) {
            return;
        }
        if (!$this->checkCurrency($params['cart'])) {
            return;
        }
        
        $this->smarty->assign(
            $this->getTemplateVars()
        );
        
        /* MODIFIED BY PRESTEAMSHOP */
        $controller     = Tools::getValue('controller');
        $is_opc_module  = false;

        if (Module::isInstalled('onepagecheckoutps')) {
            $module = Module::getInstanceByName('onepagecheckoutps');
            if (Validate::isLoadedObject($module) && $module->active) {
                $sql = new DbQuery();
                $sql->from('module_shop', 'm');
                $sql->where('m.id_module = '.(int)$module->id);
                $sql->where('m.enable_device & '.(int)Context::getContext()->getDevice());
                $sql->where('m.id_shop = '.(int)Context::getContext()->shop->id);

                $active_device = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($sql);

                if ($active_device && $module->core->isVisible()) {
                    $is_opc_module = true;
                }
            }
        }
        
        if (Module::isInstalled('onepagecheckout')) {
            $module = Module::getInstanceByName('onepagecheckout');
            if (Validate::isLoadedObject($module) && $module->active) {
                $sql = new DbQuery();
                $sql->from('module_shop', 'm');
                $sql->where('m.id_module = '.(int)$module->id);
                $sql->where('m.enable_device & '.(int)Context::getContext()->getDevice());
                $sql->where('m.id_shop = '.(int)Context::getContext()->shop->id);

                $active_device = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($sql);

                if ($active_device && $module->core->isVisible()) {
                    $is_opc_module = true;
                }
            }
        }
        
        if (Module::isInstalled('thecheckout')) {
            $module = Module::getInstanceByName('thecheckout');
            if (Validate::isLoadedObject($module) && $module->active) {
                $sql = new DbQuery();
                $sql->from('module_shop', 'm');
                $sql->where('m.id_module = '.(int)$module->id);
                $sql->where('m.enable_device & '.(int)Context::getContext()->getDevice());
                $sql->where('m.id_shop = '.(int)Context::getContext()->shop->id);

                $active_device = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($sql);

                if ($active_device && $module->core->isVisible()) {
                    $is_opc_module = true;
                }
            }
        }
        
        if (Module::isInstalled('supercheckout')) {
            $module = Module::getInstanceByName('supercheckout');
            if (Validate::isLoadedObject($module) && $module->active) {
                $sql = new DbQuery();
                $sql->from('module_shop', 'm');
                $sql->where('m.id_module = '.(int)$module->id);
                $sql->where('m.enable_device & '.(int)Context::getContext()->getDevice());
                $sql->where('m.id_shop = '.(int)Context::getContext()->shop->id);

                $active_device = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($sql);

                if ($active_device && $module->core->isVisible()) {
                    $is_opc_module = true;
                }
            }
        }
        
        /* MODIFIED BY PRESTEAMSHOP */
 
        $payment_options = array();
        
        if ($controller === 'order' && $is_opc_module) {
                $embeddedOption = new PaymentOption();
                $stripe_opc_txt = $this->l('Pay with Credit / Debit Card').(Configuration::get('STRIPE_ALLOW_WECHAT')?$this->l('/ WeChat Pay'):'').(Configuration::get('STRIPE_ALLOW_SEPA')?$this->l('/ SEPA Direct debit'):'').(Configuration::get('STRIPE_ALLOW_PRBUTTON')?$this->l('/ Google Pay/ Apple Pay/ Microsoft Pay'):'').(Configuration::get('STRIPE_ALLOW_ALIPAY')?$this->l('/ Alipay'):'').(Configuration::get('STRIPE_ALLOW_GIROPAY')?$this->l('/ Giropay'):'').(Configuration::get('STRIPE_ALLOW_IDEAL')?$this->l('/ iDeal'):'').(Configuration::get('STRIPE_ALLOW_BANCONTACT')?$this->l('/ BANCONTACT'):'').(Configuration::get('STRIPE_ALLOW_SOFORT')?$this->l('/ Sofort'):'').(Configuration::get('STRIPE_ALLOW_P24')?$this->l('/ Przelewy24'):'').(Configuration::get('STRIPE_ALLOW_EPS')?$this->l('/ EPS'):'').(Configuration::get('STRIPE_ALLOW_MULTIBANCO')?$this->l('/ MULTIBANCO'):'').(Configuration::get('STRIPE_ALLOW_BTC')?$this->l('/ Bitcoins'):'');
                $embeddedOption = new PaymentOption();
                $embeddedOption->setModuleName($this->name)
                 ->setCallToActionText($stripe_opc_txt)
                 ->setAction($this->context->link->getModuleLink('stripejs', 'paymentcard'))
                 ->setLogo(Media::getMediaPath(_PS_MODULE_DIR_.$this->name.'/views/img/powered_by_stripe.png'));
                $payment_options[]=$embeddedOption;
                return $payment_options;
          }
        
        if(Configuration::get('STRIPE_ALLOW_CARDS')){
          
        $embeddedOption = new PaymentOption();
        $embeddedOption->setModuleName($this->name)
                       ->setCallToActionText($this->l('Pay with Credit / Debit Card'))
                       ->setForm($this->display(__FILE__,'views/templates/hook/card-pay.tpl'))
                       ->setLogo(Media::getMediaPath(_PS_MODULE_DIR_.$this->name.'/views/img/powered_by_stripe.png'));
        $payment_options[] = $embeddedOption;
        }
                
        $card = Db::getInstance()->executeS('SELECT btc_address,cc_type,cc_last_digits FROM '._DB_PREFIX_.'stripejs_transaction WHERE `type`="payment" && `source_type` IN ("card","applepay") && `cc_last_digits` !="" && `btc_address` !="" && id_customer = '.(int)$this->context->cookie->id_customer.' group by `source`');
       if(count($card)>0 && Configuration::get('STRIPE_ALLOW_USEDCARD')){
        $embeddedOption = new PaymentOption();
        $embeddedOption->setModuleName('savedstripejs')->setCallToActionText($this->l('Quick Pay with existing card'))
                       ->setForm($this->display(__FILE__,'views/templates/hook/savedcard-pay.tpl'))
                       ->setLogo(Media::getMediaPath(_PS_MODULE_DIR_.$this->name.'/views/img/powered_by_stripe.png'));
        $payment_options[] = $embeddedOption;
         }
         
       if(Configuration::get('STRIPE_CHKOUT_POPUP') || Configuration::get('STRIPE_ALLOW_BTC')){
           
        $embeddedOption = new PaymentOption();
        $embeddedOption->setModuleName('stripeCheckout')->setCallToActionText($this->l('Pay with Credit / Debit Card').(Configuration::get('STRIPE_ALLOW_BTC')?$this->l(' / Bitcoins'):''))
                       ->setAdditionalInformation($this->display(__FILE__,'views/templates/hook/checkout.tpl'))
                       ->setLogo(Media::getMediaPath(_PS_MODULE_DIR_.$this->name.'/views/img/powered_by_stripe.png'));
        $payment_options[] = $embeddedOption;
         }
        
        $address_delivery = new Address($this->context->cart->id_address_invoice);
        $country = Country::getIsoById($address_delivery->id_country);
        $pr_countries = array('AT', 'AU', 'BE', 'BR', 'CA', 'CH', 'DE', 'DK', 'EE', 'ES', 'FI', 'FR', 'GB', 'HK', 'IE', 'IN', 'IT', 'JP', 'LT', 'LU', 'LV', 'MX', 'NL', 'NZ', 'NO', 'PH', 'PL', 'PT', 'RO', 'SE', 'SG', 'SK', 'US');
         
         
         if(Configuration::get('STRIPE_ALLOW_SEPA') && $this->context->currency->iso_code == "EUR"){
            $payment_option = new PaymentOption();
            $payment_option->setModuleName('sepa')->setCallToActionText($this->l('Pay by SEPA Direct Debit'))
                           ->setForm($this->display(__FILE__,'views/templates/hook/sepa.tpl'))
                           ->setLogo(Media::getMediaPath(_PS_MODULE_DIR_.$this->name.'/views/img/cc-sepa.png'));
            $payment_options[] = $payment_option;
         }
         
          $address_invoice = new Address($this->context->cart->id_address_invoice);
          $iso_country = Country::getIsoById($address_invoice->id_country);
          $methods = array('alipay', 'giropay', 'ideal', 'bancontact', 'sofort', 'p24', 'eps', 'multibanco');
          foreach ($methods as $method) {
              if (Configuration::get('STRIPE_ALLOW_'.Tools::strtoupper($method))) {
                  if ($method == 'sofort' && ($this->context->currency->iso_code != "EUR" || !in_array($iso_country, array('AT', 'BE', 'DE', 'NL', 'ES', 'IT')))) {
                      continue;
                  }elseif ($method == 'alipay' && !in_array($this->context->currency->iso_code, array('AUD', 'CAD', 'EUR', 'GBP', 'HKD', 'JPY', 'NZD', 'SGD', 'USD'))) {
                      continue;
                  }elseif ($method == 'p24' && (!in_array($this->context->currency->iso_code, array('EUR','PLN')))) {
                      continue;
                  }elseif ($method == 'giropay' && ($this->context->currency->iso_code != "EUR")) {
                      continue;
                  }elseif ($method == 'ideal' && ($this->context->currency->iso_code != "EUR")) {
                      continue;
                  }elseif ($method == 'bancontact' && ($this->context->currency->iso_code != "EUR")) {
                      continue;
                  }elseif ($method == 'eps' && ($this->context->currency->iso_code != "EUR")) {
                      continue;
                  }elseif ($method == 'multibanco' && ($this->context->currency->iso_code != "EUR")) {
                      continue;
                  }
                  $payment_option = new PaymentOption();
                  $payment_option->setModuleName($method)->setCallToActionText($this->l('Pay by '.Tools::strtoupper($method).($method=='p24'?' (Przelewy24)':'')))
                      ->setLogo(Media::getMediaPath(_PS_MODULE_DIR_.$this->name.'/views/img/cc-'.$method.'.png'));
                  $payment_options[] = $payment_option;
              }
          }
          
          if(Configuration::get('STRIPE_ALLOW_WECHAT') && in_array($this->context->currency->iso_code, array('AUD','CAD','EUR','GBP','HKD','JPY','SGD','USD'))){
            $embeddedOption = new PaymentOption();
            $embeddedOption->setModuleName('stripeWechat')->setCallToActionText($this->l('WeChat Pay'))
                           ->setAdditionalInformation($this->display(__FILE__,'views/templates/hook/wechat-pay.tpl'))
                           ->setLogo(Media::getMediaPath(_PS_MODULE_DIR_.$this->name.'/views/img/wechat.png'));
            $payment_options[] = $embeddedOption;
         }
          
          if(Configuration::get('STRIPE_ALLOW_PRBUTTON') && in_array($country,$pr_countries)){
            $embeddedOption = new PaymentOption();
            $embeddedOption->setModuleName('stripePRButton')->setCallToActionText($this->l('Pay with Google/ Apple Pay/ Microsoft Pay'))
                           ->setAdditionalInformation($this->display(__FILE__,'views/templates/hook/pr-button.tpl'))
                           ->setLogo(Media::getMediaPath(_PS_MODULE_DIR_.$this->name.'/views/img/prbutton.png'));
            $payment_options[] = $embeddedOption;
         }

        return $payment_options;
    }
    
    public function getTemplateVars()
    {
        $amount = $this->context->cart->getOrderTotal();
        $currency = $this->context->currency->iso_code;
        $secure_mode_all = Configuration::get('STRIPE_3DSECURE');
        if ($secure_mode_all==1 || ($secure_mode_all==2 && $amount >= 50))
            $secure_mode_all = 1;
        else
            $secure_mode_all = 0;

        $amount = $this->isZeroDecimalCurrency($currency) ? round($amount) : $amount * 100;
        $address_delivery = new Address($this->context->cart->id_address_invoice);

        $billing_address = array(
            'line1' => $address_delivery->address1,
            'line2' => $address_delivery->address2,
            'city' => $address_delivery->city,
            'zip_code' => $address_delivery->postcode,
            'country' => $address_delivery->country,
            'phone' => $address_delivery->phone ? $address_delivery->phone : $address_delivery->phone_mobile,
            'email' => $this->context->customer->email,
        );

        if (Configuration::get('PS_SSL_ENABLED')) {
            $domain = Tools::getShopDomainSsl(true);
        } else {
            $domain = Tools::getShopDomain(true);
        }
        
        $stripeTokens = Db::getInstance()->executeS('SELECT btc_address,cc_type,cc_last_digits FROM '._DB_PREFIX_.'stripejs_transaction WHERE `type`="payment" && `source_type` IN ("card","applepay") && `cc_last_digits` !="" && `btc_address` !="" && id_customer = '.(int)$this->context->cookie->id_customer.' group by `source`');
        $country = Country::getIsoById($address_delivery->id_country);
        $logo_url = (Configuration::get('STRIPE_POPUP_LOGO')=='' ? __PS_BASE_URI__.'img/'.Configuration::get('PS_LOGO'):Configuration::get('STRIPE_POPUP_LOGO'));
        $iso_countries = array('AT', 'BE', 'DE', 'NL', 'ES', 'IT');
        $sofort_countries = array();
        foreach ($iso_countries as $iso) {
            $id_country = Country::getByIso($iso);
            $sofort_countries[$iso] = Country::getNameById($this->context->language->id, $id_country);
        }
        
        $STRIPE_ALLOW_PRBUTTON = 0;
        $pr_countries = array('AT', 'AU', 'BE', 'BR', 'CA', 'CH', 'DE', 'DK', 'EE', 'ES', 'FI', 'FR', 'GB', 'HK', 'IE', 'IN', 'IT', 'JP', 'LT', 'LU', 'LV', 'MX', 'NL', 'NZ', 'NO', 'PH', 'PL', 'PT', 'RO', 'SE', 'SG', 'SK', 'US');
        
        if (Configuration::get('STRIPE_ALLOW_PRBUTTON') && in_array($country,$pr_countries))
           $STRIPE_ALLOW_PRBUTTON = 1;
                   
        return array(
           'publishableKey' => Configuration::get('STRIPE_MODE') ? Configuration::get('STRIPE_PUBLIC_KEY_LIVE') : Configuration::get('STRIPE_PUBLIC_KEY_TEST'),
           'customer_name' => $this->context->customer->firstname.' '.$this->context->customer->lastname,
           'cu_name' => $this->context->customer->firstname.' '.$this->context->customer->lastname,
           'currency' => $currency,
           'amount_ttl' => $amount,
           'ps_cart_id' => $this->context->cart->id,
           'baseDir' => $domain.__PS_BASE_URI__,
           'secure_mode' => $secure_mode_all,
           'stripe_mode' => Configuration::get('STRIPE_MODE'),
           'stripe_token' => Configuration::get('STRIPE_WEBHOOK_TOKEN'),
           'module_dir' => $this->_path,
           'stripeTokens' => $stripeTokens,
           'billing_address' => Tools::jsonEncode($billing_address,JSON_HEX_QUOT),
           'stripe_cc' => $this->_path."views/img/stripe-cc.png",
           'stripe_btc' => $this->_path."views/img/stripe-btc.png",
           'stripe_alipay' => $this->_path."views/img/alipay.png",
           'stripe_ps_version' => _PS_VERSION_,
           'stripe_allow_zip'  => Configuration::get('STRIPE_ALLOW_ZIP'),
           'stripe_allow_btc'  => Configuration::get('STRIPE_ALLOW_BTC'),
           'stripe_allow_alipay'  => Configuration::get('STRIPE_ALLOW_ALIPAY'),
           'stripe_allow_prbutton'  => $STRIPE_ALLOW_PRBUTTON,
           'cu_email' => $this->context->customer->email,
           'popup_title' => (!Configuration::get('STRIPE_POPUP_TITLE')?Configuration::get('PS_SHOP_NAME'):Configuration::get('STRIPE_POPUP_TITLE')),
           'popup_desc' => Configuration::get('STRIPE_POPUP_DESC',$this->context->language->id),
           'country_iso_code' => $country,
           'logo_url' =>  $logo_url,
           'stripe_error' => Tools::getValue('stripe_error'),
           'popup_locale' => (Configuration::get('STRIPE_POPUP_LOCALE')=='auto'?$this->context->language->iso_code:Configuration::get('STRIPE_POPUP_LOCALE')),
           'order_validation_url' => $this->context->link->getModuleLink($this->name, 'validation', array('content_only'=>1), true),
           'sofort_countries' => $sofort_countries,
           'lang_iso_code' => $this->context->language->iso_code,
        );
    }
    
    /*
     ** Hook Order Confirmation
     */
    public function hookOrderConfirmation($params)
    {
      
        if (!isset($params['order']) || ($params['order']->module != $this->name))
            return false;
        
        $pendingOrderStatus = (int)Configuration::get('STRIPE_PENDING_ORDER_STATUS');
        $currentOrderStatus = (int)$params['order']->getCurrentState();
            
        if(!Configuration::get('STRIPE_CAPTURE_TYPE') || $currentOrderStatus==9 || $currentOrderStatus==Configuration::get('STRIPE_SOFORT_WAITING_OS') || $currentOrderStatus==Configuration::get('STRIPE_SEPA_WAITING_OS') || $currentOrderStatus==Configuration::get('STRIPE_MB_WAITING_OS'))
        $valid = 1;
        else
        $valid = $params['order']->valid;
        
        $pending = 0;$pending_arr = array();
        if($currentOrderStatus==Configuration::get('STRIPE_MB_WAITING_OS')){
            
            $pending = 1;
            $pending_arr = Db::getInstance()->getRow('SELECT * FROM '._DB_PREFIX_.'stripejs_transaction WHERE id_order = '.(int)$params['order']->id.' AND type = \'payment\' AND status = \'unpaid\'');
            }
        
        if ($params['order'] && Validate::isLoadedObject($params['order']) && isset($params['order']->valid))
            $this->smarty->assign('stripe_order', array('reference' => isset($params['order']->reference) ? $params['order']->reference : '#'.sprintf('%06d', $params['objOrder']->id), 'valid' => $valid, 'pending' => $pending, 'pending_arr' => $pending_arr));

        if ($pendingOrderStatus==$currentOrderStatus)
            $this->smarty->assign('order_pending', true);
        else
            $this->smarty->assign('order_pending', false);

        return $this->display(__FILE__, 'views/templates/front/order-confirmation.tpl');
    }
    
    /**
     * Process a payment
     *
     * @param string $token Stripe Transaction ID (token)
     */
    public function processPayment(array $params)
    {   
        @ini_set('display_errors', 'off');
        
        $token = $params['token'];
        
        if (!$this->context->cart->checkQuantities())
        {
               die(Tools::jsonEncode(array(
                    'code' => '0',
                    'msg' => $this->l('An item in your cart is no longer available, you cannot proceed with your order'),
                )));
        }
        
        if ($params['source_type']=='multibanco' && isset($params['multibanco']['status']) && $params['multibanco']['status']=='pending') {
            
            $amt_paid = $this->isZeroDecimalCurrency($params['currency']) ? $params['amount'] : $params['amount'] / 100;
            parent::validateOrder(
                (int)$this->context->cart->id,
                (int)Configuration::get('STRIPE_MB_WAITING_OS'),
                (float)$amt_paid,
                $this->displayName,
                null,
                array(),
                null,
                false,
                $this->context->cart->secure_key
            );
            $id_order = Order::getOrderByCartId($this->context->cart->id);
                          
            $insertSQL = 'INSERT INTO '._DB_PREFIX_.'stripejs_transaction (type,source,source_type,btc_address, id_customer, id_order, id_transaction, amount, status, currency, cc_type, cc_exp, cc_last_digits, cvc_check, fee, mode, date_add) 
            VALUES ("payment","'.pSQL($params['token']).'","'.pSQL($params['source_type']).'","'.pSQL($params['multibanco']['entity']).'", '.(int)$this->context->cookie->id_customer.', '.(int)$id_order.', "","'.(float)$amt_paid.'", "unpaid", "'.pSQL($params['currency']).'","'.pSQL($params['multibanco']['reference']).'", "", "",0, "", "'.(Configuration::get('STRIPE_MODE') ? 'live' : 'test').'", NOW())';
                          
            @Db::getInstance()->Execute($insertSQL);    
            
            if (Configuration::get('PS_SSL_ENABLED')) {
                $domain = Tools::getShopDomainSsl(true);
            } else {
                $domain = Tools::getShopDomain(true);
            }
            /* Ajax redirection Order Confirmation */
            die(Tools::jsonEncode(array(
                'code' => '1',
                'url' => $domain.__PS_BASE_URI__.'/index.php?controller=order-confirmation&id_cart='.(int)$this->context->cart->id.'&id_module='.(int)$this->id.'&id_order='.(int)$id_order.'&key='.$this->context->customer->secure_key,
            )));  
            
        }
        
        include dirname(__FILE__).'/lib/Stripe.php';
        \Stripe\Stripe::setApiKey(Configuration::get('STRIPE_MODE') ? Configuration::get('STRIPE_PRIVATE_KEY_LIVE') : Configuration::get('STRIPE_PRIVATE_KEY_TEST'));
        
        if(Tools::substr($token,0,4)=='tok_')
        $source_result = \Stripe\Source::create(array("type" => "card","token" => $params['token']));
        if(isset($source_result->id))
        $token = $source_result->id;
        
        $customer_stripe_id='';
        if(Tools::substr($token,0,4)=='cus_')
        $customer_stripe_id=$token;
        if (Configuration::get('STRIPE_ALLOW_USEDCARD') && $params['source_type']=='card') {
           try {
               $customer_stripe = \Stripe\Customer::create(array('description' => $this->l('PrestaShop Customer ID:').' '.(int)$this->context->cookie->id_customer,
                    'source' => $token, 'email' => $this->context->customer->email));
            } catch (Exception $e) {
                 die(Tools::jsonEncode(array('code' => '0','msg' => $e->getMessage())));
            }
           if(isset($customer_stripe->id))
           $customer_stripe_id = $customer_stripe->id;
        }
        
        try
        {   
            if ($customer_stripe_id!='') {
            $result_json = \Stripe\Charge::create(array('customer' => $customer_stripe_id, 'amount' => $params['amount'], 'currency' => $this->context->currency->iso_code, 'description' => $this->l('PrestaShop Customer ID:').' '.(int)$this->context->cookie->id_customer.' - '.$this->l('PrestaShop Cart ID:').' '.(int)$this->context->cart->id, 'capture' => (!Configuration::get('STRIPE_CAPTURE_TYPE') && !in_array($params['source_type'],array('card','prbutton'))?false:true),"receipt_email" => $this->context->customer->email,"expand" =>array("balance_transaction")));
            } else {
            $result_json = \Stripe\Charge::create(array('source' => $token, 'amount' => $params['amount'], 'currency' => $this->context->currency->iso_code, 'description' => $this->l('PrestaShop Customer ID:').' '.(int)$this->context->cookie->id_customer.' - '.$this->l('PrestaShop Cart ID:').' '.(int)$this->context->cart->id, 'capture' => (!Configuration::get('STRIPE_CAPTURE_TYPE') && !in_array($params['source_type'],array('card','prbutton'))?false:true),"receipt_email" => $this->context->customer->email,"expand" =>array("balance_transaction")));
            }
            
        } catch (Exception $e) {
                die(Tools::jsonEncode(array(
                    'code' => '0',
                    'msg' => $e->getMessage(),
                )));
        }
        

        /* Log Transaction details */
        if ($result_json->status == 'succeeded' || (($params['source_type']=="sofort" || $params['source_type']=="sepa_debit") && $result_json->status == 'pending'))
        {
            if(($params['source_type']=="sofort" || $params['source_type']=="sepa_debit") && $result_json->status == 'pending') {
              if($params['source_type']=="sepa_debit")
              $order_status = (int)Configuration::get('STRIPE_SEPA_WAITING_OS');
              else
              $order_status = (int)Configuration::get('STRIPE_SOFORT_WAITING_OS');
            } else
            $order_status = (int)Configuration::get('STRIPE_PAYMENT_ORDER_STATUS');

            if ($result_json->source->address_zip_check == 'fail' || $result_json->source->cvc_check == 'fail')
                $order_status = (int)Configuration::get('STRIPE_PENDING_ORDER_STATUS');
                
            $charge_id = '';
            if (isset($result_json->id))
               $charge_id = $result_json->id;
               
               $customer = new Customer($this->context->cart->id_customer);

              $amt_paid = $this->isZeroDecimalCurrency($params['currency']) ? $params['amount'] : $params['amount'] / 100;
              parent::validateOrder(
                  (int)$this->context->cart->id,
                  (int)$order_status,
                  (float)$amt_paid,
                  $this->displayName,
                  null,
                  array('transaction_id' => $charge_id),
                  null,
                  false,
                  $this->context->cart->secure_key
              );
              $id_order = Order::getOrderByCartId($this->context->cart->id);
               
              if (Configuration::get('STRIPE_CHARGE_ORDERID')) {   
                $ch = \Stripe\Charge::retrieve($result_json->id);
                $ch->description = $this->l("PS ORDER ID: ").$id_order." - ".$this->context->customer->email;
                $ch->save();
              }
                            
              $insertSQL = 'INSERT INTO '._DB_PREFIX_.'stripejs_transaction (type,source,source_type,btc_address,btc_amount, id_customer, id_order,
              id_transaction, amount, status, currency, cc_type, cc_exp, cc_last_digits, cvc_check, fee, mode, date_add)
              VALUES ("payment","'.pSQL($token).'","'.pSQL($params['source_type']).'","'.($params['source_type']=='bitcoin'?pSQL($result_json->source->bitcoin->address):(isset($customer_stripe->id) && $customer_stripe->id!=''?pSQL($customer_stripe->id):pSQL($result_json->source->client_secret))).'","'.($params['source_type']=='bitcoin'?pSQL($result_json->source['amount']):0).'", '.(int)$this->context->cookie->id_customer.', '.(int)$id_order.', "'.pSQL($result_json->id).'","'.(float)$amt_paid.'", "'.($result_json->paid == 'true' ? ($result_json->captured ? 'paid' : 'uncaptured'): 'unpaid').'", "'.pSQL($result_json->currency).'","'.($params['source_type']=='sepa_debit'?pSQL($result_json->source->sepa_debit->fingerprint):pSQL($result_json->source->card->brand)).'", "'.(int)$result_json->source->card->exp_month.'/'.(int)$result_json->source->card->exp_year.'", "'.($params['source_type']=='sepa_debit'?pSQL($result_json->source->sepa_debit->last4):pSQL($result_json->source->card->last4)).'",'.($result_json->source->card->cvc_check == 'pass' ? 1 : 0).', "'.(float)($result_json->balance_transaction->fee * 0.01).'", "'.($result_json->livemode == 'true' ? 'live' : 'test').'", NOW())';
              
              //Logger::addLog($insertSQL, 2, null, 'Order', (int)$id_order, true);
              
              @Db::getInstance()->Execute($insertSQL);    
              
              if (Configuration::get('PS_SSL_ENABLED')) {
                $domain = Tools::getShopDomainSsl(true);
            } else {
                $domain = Tools::getShopDomain(true);
            }

            /* Ajax redirection Order Confirmation */
            die(Tools::jsonEncode(array(
                'chargeObject' => $result_json,
                'code' => '1',
                'url' => $domain.__PS_BASE_URI__.'/index.php?controller=order-confirmation&id_cart='.(int)$this->context->cart->id.'&id_module='.(int)$this->id.'&id_order='.(int)$id_order.'&key='.$customer->secure_key,
            )));      
              
        } else
        die(Tools::jsonEncode(array(
                'code' => '0',
                'msg' => $this->l('Payment declined. Unknown error, please use another card or contact us.'),
            )));

    }

    public function processCapture($id_transaction_stripe, $amount)
    {
        include dirname(__FILE__).'/lib/Stripe.php';
        \Stripe\Stripe::setApiKey(Configuration::get('STRIPE_MODE') ? Configuration::get('STRIPE_PRIVATE_KEY_LIVE') : Configuration::get('STRIPE_PRIVATE_KEY_TEST'));

        /* Try to process the capture and catch any error message */
        try
        {
            $charge = \Stripe\Charge::retrieve($id_transaction_stripe);
            if (!$this->isZeroDecimalCurrency(Tools::strtoupper($charge->currency))) {
                $amount *= 100;
            }
            $result_json = $charge->capture(array('amount' => $amount));
            
        }
        catch (Exception $e)
        {
            $this->_errors['stripe_capture_error'] = $e->getMessage();
            if (class_exists('Logger'))
                Logger::addLog($this->l('Stripe - Capture transaction failed').' '.$e->getMessage(), 1, null, 'Order', (int)Tools::getValue('id_order'), true);
        }
        
        if (!$this->isZeroDecimalCurrency(Tools::strtoupper($charge->currency))) {
                $amount *= .01;
            }
        
        if(!isset($this->_errors['stripe_capture_error']) && $result_json->captured==true){
            $query = 'UPDATE ' . _DB_PREFIX_ . 'stripejs_transaction SET `status` = \'paid\', `amount` = ' . pSQL($amount) . ' WHERE `id_transaction` = \''. pSQL($id_transaction_stripe).'\'';
            if(!Db::getInstance()->Execute($query))
            return false;
           }
        
        return true;
    }
    
    public function processRefund($id_transaction_stripe, $amount, $original_transaction)
    {
        include dirname(__FILE__).'/lib/Stripe.php';
        \Stripe\Stripe::setApiKey(Configuration::get('STRIPE_MODE') ? Configuration::get('STRIPE_PRIVATE_KEY_LIVE') : Configuration::get('STRIPE_PRIVATE_KEY_TEST'));

        /* Try to process the refund and catch any error message */
        try
        {
            $charge = \Stripe\Charge::retrieve($id_transaction_stripe);
            
            if (!$this->isZeroDecimalCurrency(Tools::strtoupper($charge->currency))) {
                $amount *= 100;
            }
            if($original_transaction['source_type']!="bitcoin")
            $result_json = $charge->refund(array('amount' => $amount));
            else
            $result_json = $charge->refunds->create(array('amount' => $amount,"refund_address" => $original_transaction['btc_address']));
        }
        catch (Exception $e)
        {
            $this->_errors['stripe_refund_error'] = $e->getMessage();
            if (class_exists('Logger'))
                Logger::addLog($this->l('Stripe - Refund transaction failed').' '.$e->getMessage(), 2, null, 'Order', (int)Tools::getValue('id_order'), true);
        }
        
        if (!$this->isZeroDecimalCurrency(Tools::strtoupper($charge->currency))) {
                $amount *= .01;
            }
        
        if(!isset($this->_errors['stripe_refund_error']))
        Db::getInstance()->Execute('
        INSERT INTO '._DB_PREFIX_.'stripejs_transaction (type, source, source_type, id_customer, id_order,
        id_transaction, amount, status, currency, cc_type, cc_exp, cc_last_digits, fee, mode, date_add)
        VALUES ("refund","'.pSQL($original_transaction['source']).'","'.pSQL($original_transaction['source_type']).'", '.(int)$original_transaction['id_customer'].', '.
        (int)$original_transaction['id_order'].', \''.pSQL($id_transaction_stripe).'\',
        \''.(float)$amount.'\', \''.(!isset($this->_errors['stripe_refund_error']) ? 'paid' : 'unpaid').'\', \''.pSQL($result_json->currency).'\',
        \'\', \'\', 0, 0, \''.(Configuration::get('STRIPE_MODE') ? 'live' : 'test').'\', NOW())');
    }
    

    public function isZeroDecimalCurrency($currency)
    {
        $zeroDecimalCurrencies = array('BIF','CLP','DJF','GNF','JPY','KMF','KRW','MGA','PYG','RWF','VND','VUV','XAF','XOF','XPF');
        return in_array($currency, $zeroDecimalCurrencies);
    }
  
    /**
     * Check settings requirements to make sure the Stripe's module will work properly
     *
     * @return boolean Check result
     */
    public function checkSettings()
    {
        if (Configuration::get('STRIPE_MODE'))
            return Configuration::get('STRIPE_PUBLIC_KEY_LIVE') != '' && Configuration::get('STRIPE_PRIVATE_KEY_LIVE') != '';
        else
            return Configuration::get('STRIPE_PUBLIC_KEY_TEST') != '' && Configuration::get('STRIPE_PRIVATE_KEY_TEST') != '';
    }

    /**
     * Check technical requirements to make sure the Stripe's module will work properly
     *
     * @return array Requirements tests results
     */
    public function checkRequirements()
    {
        $tests = array('result' => true);
        $tests['curl'] = array('name' => $this->l('PHP cURL extension must be enabled on your server'), 'result' => extension_loaded('curl'));
        $tests['mbstring'] = array('name' => $this->l('PHP Multibyte String extension must be enabled on your server'), 'result' => extension_loaded('mbstring'));
        if (Configuration::get('STRIPE_MODE'))
            $tests['ssl'] = array('name' => $this->l('SSL must be enabled on your store (before entering Live mode)'), 'result' => Configuration::get('PS_SSL_ENABLED') || (!empty($_SERVER['HTTPS']) && Tools::strtolower($_SERVER['HTTPS']) != 'off'));
        $tests['php52'] = array('name' => $this->l('Your server must run PHP 5.4 or greater'), 'result' => version_compare(PHP_VERSION, '5.4', '>='));
        $tests['configuration'] = array('name' => $this->l('You must sign-up for Stripe and configure your account settings in the module (publishable key, secret key...etc.)'), 'result' => $this->checkSettings());


        foreach ($tests as $k => $test)
            if ($k != 'result' && !$test['result'])
                $tests['result'] = false;

        return $tests;
    }
    
   /*
     ** @Method: getContent
     ** @description: render main content
     **
     ** @arg:
     ** @return: (none)
     */
    public function getContent()
    {                
        $errors = array();
        /* Update Configuration Values when settings are updated */
        if (Tools::isSubmit('SubmitStripe'))
        {    
            if (strpos(Tools::getValue('stripe_public_key_test'), "sk_") !== false || strpos(Tools::getValue('stripe_public_key_live'), "sk_") !== false ) {
                $errors[] = "You've entered your private key in the public key field!";
            }
            if (empty($errors)) {
                $configuration_values = array(
                    'STRIPE_MODE' => Tools::getValue('stripe_mode'),
                    'STRIPE_ALLOW_CARDS' => Tools::getValue('STRIPE_ALLOW_CARDS'),
                    'STRIPE_ALLOW_USEDCARD' => Tools::getValue('STRIPE_ALLOW_USEDCARD'),
                    'STRIPE_CAPTURE_TYPE' => Tools::getValue('STRIPE_CAPTURE_TYPE'),
                    'STRIPE_ALLOW_ZIP' => Tools::getValue('STRIPE_ALLOW_ZIP'),
                    'STRIPE_ALLOW_ALIPAY' => Tools::getValue('STRIPE_ALLOW_ALIPAY'),
                    'STRIPE_STMNT_DESC' => Tools::getValue('STRIPE_STMNT_DESC'),
                    'STRIPE_ALLOW_SEPA' => Tools::getValue('STRIPE_ALLOW_SEPA'),
                    'STRIPE_ALLOW_PRBUTTON' => Tools::getValue('STRIPE_ALLOW_PRBUTTON'),
                    'STRIPE_ALLOW_IDEAL' => Tools::getValue('STRIPE_ALLOW_IDEAL'),
                    'STRIPE_ALLOW_GIROPAY' => Tools::getValue('STRIPE_ALLOW_GIROPAY'),
                    'STRIPE_ALLOW_SOFORT' => Tools::getValue('STRIPE_ALLOW_SOFORT'),
                    'STRIPE_ALLOW_BANCONTACT' => Tools::getValue('STRIPE_ALLOW_BANCONTACT'),
                    'STRIPE_ALLOW_P24' => Tools::getValue('STRIPE_ALLOW_P24'),
                    'STRIPE_ALLOW_EPS' => Tools::getValue('STRIPE_ALLOW_EPS'),
                    'STRIPE_ALLOW_MULTIBANCO' => Tools::getValue('STRIPE_ALLOW_MULTIBANCO'),
                    'STRIPE_ALLOW_WECHAT' => Tools::getValue('STRIPE_ALLOW_WECHAT'),
                    'STRIPE_CHARGE_ORDERID' => Tools::getValue('STRIPE_CHARGE_ORDERID'),
                    'STRIPE_3DSECURE' => Tools::getValue('STRIPE_3DSECURE'),
                    'STRIPE_PUBLIC_KEY_TEST' => trim(Tools::getValue('stripe_public_key_test')),
                    'STRIPE_PUBLIC_KEY_LIVE' => trim(Tools::getValue('stripe_public_key_live')), 
                    'STRIPE_PRIVATE_KEY_TEST' => trim(Tools::getValue('stripe_private_key_test')),
                    'STRIPE_PRIVATE_KEY_LIVE' => trim(Tools::getValue('stripe_private_key_live')), 
                );

                foreach ($configuration_values as $configuration_key => $configuration_value)
                    Configuration::updateValue($configuration_key, $configuration_value);
            }
        }
        if (Tools::isSubmit('SubmitOrderStatuses'))
        {    
                $configuration_values = array(
                    'STRIPE_PENDING_ORDER_STATUS' => (int)Tools::getValue('stripe_pending_status'),
                    'STRIPE_PAYMENT_ORDER_STATUS' => (int)Tools::getValue('stripe_payment_status'), 
                    'STRIPE_SOFORT_WAITING_OS' => (int)Tools::getValue('STRIPE_SOFORT_WAITING_OS'),
                    'STRIPE_SEPA_WAITING_OS' => (int)Tools::getValue('STRIPE_SEPA_WAITING_OS'),
                    'STRIPE_MB_WAITING_OS' => (int)Tools::getValue('STRIPE_MB_WAITING_OS'),
                    'STRIPE_CHARGEBACKS_ORDER_STATUS' => (int)Tools::getValue('stripe_chargebacks_status'),
                );

                foreach ($configuration_values as $configuration_key => $configuration_value)
                    Configuration::updateValue($configuration_key, $configuration_value);
        }
        if (Tools::isSubmit('SubmitStripeCheckout'))
        {    
                $configuration_values = array(
                    'STRIPE_POPUP_LOGO' => Tools::getValue('STRIPE_POPUP_LOGO'),
                    'STRIPE_CHKOUT_POPUP' =>(Tools::getValue('STRIPE_ALLOW_BTC')?Tools::getValue('STRIPE_ALLOW_BTC'):Tools::getValue('STRIPE_CHKOUT_POPUP')),
                    'STRIPE_ALLOW_BTC' => Tools::getValue('STRIPE_ALLOW_BTC'),
                    'STRIPE_POPUP_TITLE' =>Tools::getValue('STRIPE_POPUP_TITLE'),
                    'STRIPE_POPUP_DESC' =>Tools::getValue('STRIPE_POPUP_DESC'),
                    'STRIPE_POPUP_LOCALE' => Tools::getValue('STRIPE_POPUP_LOCALE')
                );

                foreach ($configuration_values as $configuration_key => $configuration_value)
                    Configuration::updateValue($configuration_key, $configuration_value);
        }
        
        
        $requirements = $this->checkRequirements();
        $langs = Language::getLanguages();
        $shopDomainSsl = Tools::getShopDomainSsl(true, true);
        $stripeBOCssUrl = $shopDomainSsl.__PS_BASE_URI__.'modules/'.$this->name.'/views/css/stripe-prestashop-admin.css';
        $logo_url = (Configuration::get('STRIPE_POPUP_LOGO')=='' ? __PS_BASE_URI__.'img/'.Configuration::get('PS_LOGO'):Configuration::get('STRIPE_POPUP_LOGO'));
        $statuses = OrderState::getOrderStates((int)$this->context->cookie->id_lang);
        $statuses_options = array(array('name' => 'stripe_payment_status', 'label' => $this->l('Order status in case of sucessfull payment:'), 'current_value' => Configuration::get('STRIPE_PAYMENT_ORDER_STATUS')),array('name' => 'stripe_pending_status', 'label' => $this->l('Order status in case of unsucessfull address/zip-code check:'), 'current_value' => Configuration::get('STRIPE_PENDING_ORDER_STATUS')),array('name' => 'STRIPE_SEPA_WAITING_OS', 'label' => $this->l('Order status for pending SEPA Direct Debit payment:'), 'current_value' => Configuration::get('STRIPE_SEPA_WAITING_OS')),array('name' => 'STRIPE_SOFORT_WAITING_OS', 'label' => $this->l('Order status for pending SOFORT payment:'), 'current_value' => Configuration::get('STRIPE_SOFORT_WAITING_OS')),array('name' => 'STRIPE_MB_WAITING_OS', 'label' => $this->l('Order status for pending MULTIBANCO payment:'), 'current_value' => Configuration::get('STRIPE_MB_WAITING_OS')),array('name' => 'stripe_chargebacks_status', 'label' => $this->l('Order status in case of a Failed/ Canceled payment:'), 'current_value' => Configuration::get('STRIPE_CHARGEBACKS_ORDER_STATUS')));
                    
         $tplVars = array(
            'errors' => $errors,
            'langs' => $langs,
            'logo_url' => $logo_url,
            'statuses' => $statuses,
            'statuses_options' => $statuses_options,
            'this_path' => $this->_path,
            'requirements' => $requirements,
            'checkSettings' => $this->checkSettings(),
            'stripeBOCssUrl' => $stripeBOCssUrl,
            'ps_version' => $this->version,
            'webhook_url' => $this->context->link->getModuleLink($this->name, 'webhook', array('token'=>Configuration::get('STRIPE_WEBHOOK_TOKEN'),'ajax'=>true), true),
        );
        
        if (Tools::isSubmit('SubmitStripe') || Tools::isSubmit('SubmitStripeCheckout') || Tools::isSubmit('SubmitOrderStatuses'))
            $tplVars['success'] = true;
        else
            $tplVars['success'] = false;

        $this->context->smarty->assign($tplVars);
        return $this->display(__FILE__, 'views/templates/admin/settings.tpl');
    }
    
     /**
     * Display Stripe's transactions details
     * Visible on the Order's detail page in the Back-office only
     *
     * @return string HTML/JS Content
     */
    public function hookBackOfficeHeader()
    {        
        /* Continue if we are on the order's details page (Back-office) */
        
        if(Tools::getIsset('vieworder') && Tools::getIsset('id_order'))
        {            
            $order = new Order((int)Tools::getValue('id_order'));

        /* If the "Refund" button has been clicked, check if we can perform a partial or full refund on this order */
        if (Tools::isSubmit('SubmitStripeRefund') && Tools::getIsset('stripe_amount_to_refund') && Tools::getIsset('id_transaction_stripe'))
        {
            /* Get transaction details and make sure the token is valid */
            $stripejs_transaction_details = Db::getInstance()->getRow('SELECT * FROM '._DB_PREFIX_.'stripejs_transaction WHERE id_order = '.(int)Tools::getValue('id_order').' AND type = \'payment\' AND status = \'paid\'');
            if (isset($stripejs_transaction_details['id_transaction']) && $stripejs_transaction_details['id_transaction'] === Tools::getValue('id_transaction_stripe'))
            {
                /* Check how much has been refunded already on this order */
                $stripe_refunded = Db::getInstance()->getValue('SELECT SUM(amount) FROM '._DB_PREFIX_.'stripejs_transaction WHERE id_order = '.(int)Tools::getValue('id_order').' AND type = \'refund\' AND status = \'paid\'');
                if (Tools::getValue('stripe_amount_to_refund') <= number_format($stripejs_transaction_details['amount'] - $stripe_refunded, 2, '.', ''))
                    $this->processRefund(Tools::getValue('id_transaction_stripe'), (float)Tools::getValue('stripe_amount_to_refund'), $stripejs_transaction_details);
                else
                    $this->_errors['stripe_refund_error'] = $this->l('You cannot refund more than').' '.Tools::displayPrice($stripejs_transaction_details['amount'] - $stripe_refunded).' '.$this->l('on this order');
            }
        }
        
        /* If the "Capture" button has been clicked, check if we can perform a partial or full capture on this order */
        if (Tools::isSubmit('SubmitStripeCapture') && Tools::getIsset('stripe_amount_to_capture') && Tools::getIsset('id_transaction_stripe'))
        {
            /* Get transaction details and make sure the token is valid */
            $stripejs_transaction_details = Db::getInstance()->getRow('SELECT * FROM '._DB_PREFIX_.'stripejs_transaction WHERE id_order = '.(int)Tools::getValue('id_order').' AND type = \'payment\' AND status = \'uncaptured\'');
            if (isset($stripejs_transaction_details['id_transaction']) && $stripejs_transaction_details['id_transaction'] === Tools::getValue('id_transaction_stripe'))
            {
                if (Tools::getValue('stripe_amount_to_capture') <= number_format($stripejs_transaction_details['amount'], 2, '.', '')){
                    $this->processCapture(Tools::getValue('id_transaction_stripe'), (float)Tools::getValue('stripe_amount_to_capture'));
                    //$processCapture = $this->processCapture(Tools::getValue('id_transaction_stripe'), (float)Tools::getValue('stripe_amount_to_capture'));
                    //if ($processCapture && $order->getCurrentState() != 2)
                        //$order->setCurrentState(2);
                }else
                    $this->_errors['stripe_capture_error'] = $this->l('You cannot capture more than').' '.Tools::displayPrice($stripejs_transaction_details['amount'] - $stripe_refunded).' '.$this->l('on this order');
                
            }
        }

        /* Check if the order was paid with Stripe and display the transaction details */
        if (Db::getInstance()->getValue('SELECT module FROM '._DB_PREFIX_.'orders WHERE id_order = '.(int)Tools::getValue('id_order')) == $this->name)
        {
            /* Get the transaction details */
            $stripejs_transaction_details = Db::getInstance()->getRow('SELECT * FROM '._DB_PREFIX_.'stripejs_transaction WHERE id_order = '.(int)Tools::getValue('id_order').' AND type = \'payment\'');

            /* Get all the refunds previously made (to build a list and determine if another refund is still possible) */
            $stripe_refunded = 0;
            $output_refund = '';
            $stripe_refund_details = Db::getInstance()->ExecuteS('SELECT amount, status, date_add FROM '._DB_PREFIX_.'stripejs_transaction
            WHERE id_order = '.(int)Tools::getValue('id_order').' AND type = \'refund\' ORDER BY date_add DESC');
            foreach ($stripe_refund_details as $stripe_refund_detail)
            {
                $stripe_refunded += ($stripe_refund_detail['status'] == 'paid' ? $stripe_refund_detail['amount'] : 0);
                $output_refund .= '<tr'.($stripe_refund_detail['status'] != 'paid' ? ' style="background: #FFBBAA;"': '').'><td>'.
                Tools::safeOutput($stripe_refund_detail['date_add']).'</td><td style="">'.Tools::displayPrice($stripe_refund_detail['amount'], (int)$order->id_currency).
                '</td><td>'.($stripe_refund_detail['status'] == 'paid' ? $this->l('Processed') : $this->l('Error')).'</td></tr>';
            }
            $currency = new Currency((int)$order->id_currency);
            $c_char = $currency->sign;
            $output = '
            <script type="text/javascript">
                $(document).ready(function() {
                    var appendEl;
                    if ($(\'select[name=id_order_state]\').is(":visible")) {
                        appendEl = $(\'select[name=id_order_state]\').parents(\'form\').after($(\'<div/>\'));
                    } else {
                        appendEl = $("#status");
                    }
                    $(\'<div class="panel panel-highlighted" style="padding: 5px 10px;"><fieldset><legend><img src="../img/admin/money.gif" alt="" />&nbsp;'.$this->l('Stripe Payment Details').'</legend>';

            if (!empty($stripejs_transaction_details['source'])){
                if($stripejs_transaction_details['status'] == 'unpaid' && $stripejs_transaction_details['source_type']=='multibanco')
                $output .= $this->l('Stripe Source ID:').' <b>'.Tools::safeOutput($stripejs_transaction_details['source']).'</b><br />';
                else
                $output .= $this->l('Stripe Transaction ID:').' <b>'.Tools::safeOutput($stripejs_transaction_details['id_transaction']).'</b><br />';
                
                $output .= $this->l('Payment Source:').' <b> '.($stripejs_transaction_details['source_type'] == 'bitcoin' ? 'Bitcoins':($stripejs_transaction_details['source_type'] == 'alipay' ? 'Alipay':($stripejs_transaction_details['source_type'] == 'prbutton' ? 'Apple Pay/ Google Pay/ Microsoft Pay':($stripejs_transaction_details['source_type'] == 'three_d_secure' ? '3D-Secure authentication':($stripejs_transaction_details['source_type'] == 'card' ? 'Credit Card':($stripejs_transaction_details['source_type'] == 'customer' ? $this->l('Quick Pay with saved Card'):Tools::strtoupper($stripejs_transaction_details['source_type']))))))).'</b><br /><br />';
                
                if($stripejs_transaction_details['status'] == 'unpaid' && $stripejs_transaction_details['source_type']=='multibanco')
                $output .= $this->l('Multibanco Entity:').' <b>'.Tools::safeOutput($stripejs_transaction_details['btc_address']).'</b><br />'.$this->l('Multibanco Reference:').' <b>'.Tools::safeOutput($stripejs_transaction_details['cc_type']).'</b><br /><br />';
                
                $output .= $this->l('Status:').' <span style="font-weight: bold; color: '.($stripejs_transaction_details['status'] == 'paid' ? 'green;">'.$this->l('Paid') : '#CC0000;">'.$this->l('Unpaid')).'</span><br />'.
                $this->l('Amount:').' <b>'.Tools::displayPrice($stripejs_transaction_details['amount'], (int)$order->id_currency).'</b><br />'.
                $this->l('Processed on:').' <b>'.Tools::safeOutput($stripejs_transaction_details['date_add']).'</b><br />';
                
                if($stripejs_transaction_details['source_type']=='card' || $stripejs_transaction_details['source_type']=='prbutton'){
                $output .= $this->l('Credit card:').' <b>'.Tools::safeOutput($stripejs_transaction_details['cc_type']).' ('.$this->l('Exp.:').' '.Tools::safeOutput($stripejs_transaction_details['cc_exp']).')</b><br />'.$this->l('Last 4 digits:').' <b>xxxx xxxx xxxx '.sprintf('%04d', $stripejs_transaction_details['cc_last_digits']).' </b><br />'.$this->l('CVC Check:').' <b>'.($stripejs_transaction_details['cvc_check'] || $stripejs_transaction_details['source_type'] == 'prbutton'? $this->l('OK') : '<span style="color: #CC0000;">'.$this->l('FAILED').'</span>').'</b><br />';
                }elseif($stripejs_transaction_details['source_type']=='bitcoin'){
                  $output .= $this->l('Address:').' <b>'.Tools::safeOutput($stripejs_transaction_details['btc_address']).'</b><br />'.
                  $this->l('Bitcoin:').' <b>B⃦'.sprintf('%.8f',$stripejs_transaction_details['btc_amount']*.00000001).' BTC</b><br />';
                }elseif($stripejs_transaction_details['source_type']=='sepa_debit'){
                    $output .= $this->l('Fingerprint:').' <b>'.Tools::safeOutput($stripejs_transaction_details['cc_type']).'</b><br />'.$this->l('IBAN Last 4 digits:').' <b>xxxxxxxxxxxx'.sprintf('%04d', $stripejs_transaction_details['cc_last_digits']).'</b><br />'.$this->l('Mandate Url:').' <a target="_blank" href="https://hooks.stripe.com/adapter/sepa_debit/file/'.$stripejs_transaction_details['source'].'/'.$stripejs_transaction_details['btc_address'].'">https://hooks.stripe.com/adapter/sepa_debit/file/'.$stripejs_transaction_details['source'].'/'.$stripejs_transaction_details['btc_address'].'</a></b><br />';
                    }elseif($stripejs_transaction_details['source_type']=='alipay'){
                  $output .= $this->l('Client secret:').' <b>'.Tools::safeOutput($stripejs_transaction_details['btc_address']).'</b><br />';
                  }elseif($stripejs_transaction_details['source_type']=='customer'){                                    
                  $output .= $this->l('Stripe customer ID:').' <b>'.Tools::safeOutput($stripejs_transaction_details['source']).'</b><br />'.$this->l('Credit card:').' <b>'.Tools::safeOutput($stripejs_transaction_details['cc_type']).' ('.$this->l('Exp.:').' '.Tools::safeOutput($stripejs_transaction_details['cc_exp']).')</b><br />'.$this->l('Last 4 digits:').' <b>xxxx xxxx xxxx '.sprintf('%04d', $stripejs_transaction_details['cc_last_digits']).' </b><br />';
                  }
                
                $output .= $this->l('Processing Fee:').' <b>'.Tools::displayPrice($stripejs_transaction_details['fee'], (int)$order->id_currency).'</b><br /><br />'.
                $this->l('Payment mode:').' <span style="font-weight: bold; color: '.($stripejs_transaction_details['mode'] == 'live' ? 'green;">'.$this->l('Live') : '#CC0000;">'.$this->l('Test')).'</span>';
            }
            if (empty($stripejs_transaction_details['source']))
                $output .= '<b style="color: #CC0000;">'.$this->l('Warning:').'</b> '.$this->l('The customer paid using Stripe and an error occured while saving the transaction.');
                
                 $output .= '</fieldset><br />';
                 if(Tools::getIsset('SubmitStripeCapture')){
                 $output .= '<div  class="bootstrap">'.((empty($this->_errors['stripe_capture_error']) && Tools::getIsset('id_transaction_stripe') && Tools::getIsset('SubmitStripeCapture')) ? '<div class="conf confirmation alert alert-success">'.$this->l('Your capture was successfully processed').'</div>' : '').
            (!empty($this->_errors['stripe_capture_error']) ? '<div style="color: #CC0000; font-weight: bold;" class="alert alert-danger">'.$this->l('Error:').' '.Tools::safeOutput($this->_errors['stripe_capture_error']).'</div>' : '').'</div>';
                 }
            
           if($stripejs_transaction_details['status'] == 'uncaptured'){
               
               $date2 = $stripejs_transaction_details['date_add']; 
               $diff = strtotime($date2 ."+7 days") - strtotime('now');
               
               $secondsInAMinute = 60;
               $secondsInAnHour  = 60 * $secondsInAMinute;
               $secondsInADay    = 24 * $secondsInAnHour;

              // extract days
              $days = floor($diff / $secondsInADay);
              // extract hours
              $hourSeconds = $diff % $secondsInADay;
              $hours = floor($hourSeconds / $secondsInAnHour);

              $timeleft = $days ." days & ". $hours." hrs";
       
            $output .= '<fieldset><legend><img src="../img/admin/money.gif" alt="" />&nbsp;'.$this->l('Proceed to a full or partial capture via Stripe').'</legend>';
            if($diff>0){
            $output .= '<form action="" method="post">'.$this->l('Capture:').' $ <input type="text" value="'.($this->isZeroDecimalCurrency($currency->iso_code) ? round($stripejs_transaction_details['amount']) : $stripejs_transaction_details['amount']).'" name="stripe_amount_to_capture" style="display: inline-block; width: 60px;" /> <input type="hidden" name="id_transaction_stripe" value="'.Tools::safeOutput($stripejs_transaction_details['id_transaction']).'" /><input type="submit" class="button" onclick="return confirm(\\\''.addslashes($this->l('Do you want to proceed to this capture?')).'\\\');" name="SubmitStripeCapture" value="'.$this->l('Process Capture').'" /></form><font style="color:red;font-size:13px;"> <br>'.$this->l('NOTE: Time left to Capture payment:').' <b>'.$timeleft.'</b> '.$this->l('otherwise payment will be automatically refunded.').'</font>';}else
            $output .= '<font style="color:red;"> <b>'.$this->l('7 days has been passed so the payment has been refunded.')."</font></b>";
            
            $output .= '</fieldset><br /></div>\').appendTo(appendEl);
                });
            </script>';
                }else{

            $output .= '</fieldset><fieldset class="bootstrap'.(empty($stripejs_transaction_details['id_transaction'])||$stripejs_transaction_details['status'] == 'unpaid'?' hidden':'').'"><legend><img src="../img/admin/money.gif" alt="" />&nbsp;'.$this->l('Proceed to a full or partial refund via Stripe').'</legend>';
            if(Tools::getIsset('SubmitStripeRefund')){
            $output .= ((empty($this->_errors['stripe_refund_error']) &&  Tools::getIsset('id_transaction_stripe')) ? '<div class="conf confirmation alert alert-success">'.$this->l('Your refund was successfully processed').'</div>' : '').
            (!empty($this->_errors['stripe_refund_error']) ? '<div style="color: #CC0000; font-weight: bold;" class="alert alert-danger">'.$this->l('Error:').' '.Tools::safeOutput($this->_errors['stripe_refund_error']).'</div>' : '');
            }
            $output .= $this->l('Already refunded:').' <b>'.Tools::displayPrice($stripe_refunded, (int)$order->id_currency).'</b><br /><br />'.($stripe_refunded ? '<table class="table" cellpadding="0" cellspacing="0" style="font-size: 12px;"><tr><th>'.$this->l('Date').'</th><th>'.$this->l('Amount refunded').'</th><th>'.$this->l('Status').'</th></tr>'.$output_refund.'</table><br />' : '').
            ($stripejs_transaction_details['amount'] > $stripe_refunded ? '<form action="" method="post">'.$this->l('Refund:'). ' ' . $c_char .' <input type="text" value="'.($this->isZeroDecimalCurrency($currency->iso_code) ? round($stripejs_transaction_details['amount']-$stripe_refunded) : $stripejs_transaction_details['amount']-$stripe_refunded).
            '" name="stripe_amount_to_refund" style="display: inline-block; width: 60px;" /> <input type="hidden" name="id_transaction_stripe" value="'.
            Tools::safeOutput($stripejs_transaction_details['id_transaction']).'" /><input type="submit" class="button" onclick="return confirm(\\\''.addslashes($this->l('Do you want to proceed to this refund?')).'\\\');" name="SubmitStripeRefund" value="'.
            $this->l('Process Refund').'" /></form>' : '').'<br /></fieldset></div>\').appendTo(appendEl);
                });
            </script>';
        }

            return $output;
       }
        
      }     
}
}
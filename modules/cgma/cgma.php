<?php

/**
 * PrestaShop module created by VEKIA, a guy from official PrestaShop community ;-)
 *
 * @author    VEKIA https://www.prestashop.com/forums/user/132608-vekia/
 * @copyright 2010-2016 VEKIA
 * @license   This program is not free software and you can't resell and redistribute it
 *
 * CONTACT WITH DEVELOPER http://mypresta.eu
 * support@mypresta.eu
 */
class cgma extends Module
{
    function __construct()
    {
        ini_set("display_errors", 0);
        error_reporting(0);
        $this->name = 'cgma';
        $this->tab = 'advertising_marketing';
        $this->author = 'MyPresta.eu';
        $this->mypresta_link = 'https://mypresta.eu/modules/ordering-process/minimum-order-value-by-customer-group.html';
        $this->version = '1.6.6';
        $this->bootstrap = 1;
        parent::__construct();
        $this->checkforupdates();
        $this->displayName = $this->l('Minimal order amount by customer groups');
        $this->description = $this->l('Define minimal order amount based on groups from your store.');
    }

    public function inconsistency($ret)
    {
        return true;
    }

    public function checkforupdates($display_msg = 0, $form = 0)
    {
        // ---------- //
        // ---------- //
        // VERSION 12 //
        // ---------- //
        // ---------- //
        $this->mkey = "nlc";
        if (@file_exists('../modules/' . $this->name . '/key.php'))
        {
            @require_once('../modules/' . $this->name . '/key.php');
        }
        else
        {
            if (@file_exists(dirname(__FILE__) . $this->name . '/key.php'))
            {
                @require_once(dirname(__FILE__) . $this->name . '/key.php');
            }
            else
            {
                if (@file_exists('modules/' . $this->name . '/key.php'))
                {
                    @require_once('modules/' . $this->name . '/key.php');
                }
            }
        }
        if ($form == 1)
        {
            return '
            <div class="panel" id="fieldset_myprestaupdates" style="margin-top:20px;">
            ' . ($this->psversion() == 6 || $this->psversion() == 7 ? '<div class="panel-heading"><i class="icon-wrench"></i> ' . $this->l('MyPresta updates') . '</div>' : '') . '
			<div class="form-wrapper" style="padding:0px!important;">
            <div id="module_block_settings">
                    <fieldset id="fieldset_module_block_settings">
                         ' . ($this->psversion() == 5 ? '<legend style="">' . $this->l('MyPresta updates') . '</legend>' : '') . '
                        <form action="' . $_SERVER['REQUEST_URI'] . '" method="post">
                            <label>' . $this->l('Check updates') . '</label>
                            <div class="margin-form">' . (Tools::isSubmit('submit_settings_updates_now') ? ($this->inconsistency(0) ? '' : '') . $this->checkforupdates(1) : '') . '
                                <button style="margin: 0px; top: -3px; position: relative;" type="submit" name="submit_settings_updates_now" class="button btn btn-default" />
                                <i class="process-icon-update"></i>
                                ' . $this->l('Check now') . '
                                </button>
                            </div>
                            <label>' . $this->l('Updates notifications') . '</label>
                            <div class="margin-form">
                                <select name="mypresta_updates">
                                    <option value="-">' . $this->l('-- select --') . '</option>
                                    <option value="1" ' . ((int)(Configuration::get('mypresta_updates') == 1) ? 'selected="selected"' : '') . '>' . $this->l('Enable') . '</option>
                                    <option value="0" ' . ((int)(Configuration::get('mypresta_updates') == 0) ? 'selected="selected"' : '') . '>' . $this->l('Disable') . '</option>
                                </select>
                                <p class="clear">' . $this->l('Turn this option on if you want to check MyPresta.eu for module updates automatically. This option will display notification about new versions of this addon.') . '</p>
                            </div>
                            <label>' . $this->l('Module page') . '</label>
                            <div class="margin-form">
                                <a style="font-size:14px;" href="' . $this->mypresta_link . '" target="_blank">' . $this->displayName . '</a>
                                <p class="clear">' . $this->l('This is direct link to official addon page, where you can read about changes in the module (changelog)') . '</p>
                            </div>
                            <div class="panel-footer">
                                <button type="submit" name="submit_settings_updates"class="button btn btn-default pull-right" />
                                <i class="process-icon-save"></i>
                                ' . $this->l('Save') . '
                                </button>
                            </div>
                        </form>
                    </fieldset>
                    <style>
                    #fieldset_myprestaupdates {
                        display:block;clear:both;
                        float:inherit!important;
                    }
                    </style>
                </div>
            </div>
            </div>';
        }
        else
        {
            if (defined('_PS_ADMIN_DIR_'))
            {
                if (Tools::isSubmit('submit_settings_updates'))
                {
                    Configuration::updateValue('mypresta_updates', Tools::getValue('mypresta_updates'));
                }
                if (Configuration::get('mypresta_updates') != 0 || (bool)Configuration::get('mypresta_updates') == false)
                {
                    if (Configuration::get('update_' . $this->name) < (date("U") - 259200))
                    {
                        $actual_version = cgmaUpdate::verify($this->name, (isset($this->mkey) ? $this->mkey : 'nokey'), $this->version);
                    }
                    if (cgmaUpdate::version($this->version) < cgmaUpdate::version(Configuration::get('updatev_' . $this->name)))
                    {
                        $this->warning = $this->l('New version available, check http://MyPresta.eu for more informations');
                    }
                }
                if ($display_msg == 1)
                {
                    if (cgmaUpdate::version($this->version) < cgmaUpdate::version(cgmaUpdate::verify($this->name, (isset($this->mkey) ? $this->mkey : 'nokey'), $this->version)))
                    {
                        return "<span style='color:red; font-weight:bold; font-size:16px; margin-right:10px;'>" . $this->l('New version available!') . "</span>";
                    }
                    else
                    {
                        return "<span style='color:green; font-weight:bold; font-size:16px; margin-right:10px;'>" . $this->l('Module is up to date!') . "</span>";
                    }
                }
            }
        }
    }

    public static function psversion($part = 1)
    {
        $version = _PS_VERSION_;
        $exp = $explode = explode(".", $version);
        if ($part == 1)
        {
            return $exp[1];
        }
        if ($part == 2)
        {
            return $exp[2];
        }
        if ($part == 3)
        {
            return $exp[3];
        }
    }

    function install()
    {
        if (!parent::install() OR !$this->registerHook('displayPaymentTop') OR !$this->registerHook('displayShoppingCart') OR !$this->registerHook('displayHeader') OR !$this->installdb())
        {
        }
        return true;
    }

    private function installdb()
    {
        return true;
    }

    public static function getGroupValue($id = null)
    {
        if ($id == null)
        {
            return false;
        }

        return Configuration::get('cgma' . $id);
    }

    public function getContent()
    {
        if (Tools::isSubmit('actionsavecgma'))
        {
            foreach ($_POST['CustomerGroup'] AS $key => $value)
            {
                Configuration::updateValue('cgma' . $key, $value);
            }
            Configuration::updateValue('cgma_tax', Tools::getValue('cgma_tax'));
            Configuration::updateValue('cgma_free', Tools::getValue('cgma_free'));
        }
        $currency = Currency::getDefaultCurrency();
        $this->context->smarty->assign(array('currency' => $currency));
        return $this->display(__FILE__, 'admin.tpl');
    }

    public function hookdisplayPaymentTop($params)
    {
        $ssl = (Configuration::get('PS_SSL_ENABLED') && Configuration::get('PS_SSL_ENABLED_EVERYWHERE'));
        $base = $ssl ? 'https:' : 'http:';

        // Check minimal amount
        $currency = Currency::getCurrency((int)$this->context->cart->id_currency);

        $orderTotal = $this->context->cart->getOrderTotal();
        $minimal_purchase = Tools::convertPrice((float)self::returnCustomerGroupMinimum(), $currency);

        if (Configuration::get('cgma_free') == 1)
        {
            if ($this->context->cart->getOrderTotal((Configuration::get('cgma_tax') == 1 ? true : false), Cart::ONLY_PRODUCTS) != 0)
            {
                if ($this->context->cart->getOrderTotal((Configuration::get('cgma_tax') == 1 ? true : false), Cart::ONLY_PRODUCTS) < $minimal_purchase)
                {
                    $this->context->smarty->assign('cgma_error', sprintf($this->l('A minimum purchase total of %1s is required to validate your order, current purchase total is %2s.'), Tools::displayPrice($minimal_purchase, $currency), Tools::displayPrice($this->context->cart->getOrderTotal((Configuration::get('cgma_tax') == 1 ? true : false), Cart::ONLY_PRODUCTS), $currency)));
                    Tools::redirect($base . $this->getCartSummaryURL());
                }
            }
        }
        else
        {
            if ($this->context->cart->getOrderTotal((Configuration::get('cgma_tax') == 1 ? true : false), Cart::ONLY_PRODUCTS) < $minimal_purchase)
            {
                $this->context->smarty->assign('cgma_error', sprintf($this->l('A minimum purchase total of %1s is required to validate your order, current purchase total is %2s.'), Tools::displayPrice($minimal_purchase, $currency), Tools::displayPrice($this->context->cart->getOrderTotal((Configuration::get('cgma_tax') == 1 ? true : false), Cart::ONLY_PRODUCTS), $currency)));
                Tools::redirect($base . $this->getCartSummaryURL());
            }
        }

    }

    private function getCartSummaryURL()
    {
        return $this->context->link->getPageLink('cart', null, $this->context->language->id, array(
            'action' => 'show',
            'cgma' => 'show'
        ), false, null, true);
    }

    public function hookdisplayShoppingCart($params)
    {
        // Check minimal amount
        $currency = Currency::getCurrency((int)$this->context->cart->id_currency);

        $orderTotal = $this->context->cart->getOrderTotal();
        $minimal_purchase = Tools::convertPrice((float)self::returnCustomerGroupMinimum(), $currency);

            //echo '<span class="minimal_order_conver">';
            echo '<script> var cgma_minimal_order='.$minimal_purchase.'</script>';
             //echo '</span>';
            

        if (Configuration::get('cgma_free') == 1)
        {
            if ($this->context->cart->getOrderTotal((Configuration::get('cgma_tax') == 1 ? true : false), Cart::ONLY_PRODUCTS) != 0)
            {

                $this->context->smarty->assign('cgma_error', sprintf($this->l('A minimum purchase total of %1s is required to validate your order, current purchase total is %2s. HOLA I'), Tools::displayPrice($minimal_purchase, $currency), Tools::displayPrice($this->context->cart->getOrderTotal((Configuration::get('cgma_tax') == 1 ? true : false), Cart::ONLY_PRODUCTS), $currency)));
                    return $this->display(__FILE__, 'views/templates/front/displayShoppingCart.tpl');

               if ($this->context->cart->getOrderTotal((Configuration::get('cgma_tax') == 1 ? true : false), Cart::ONLY_PRODUCTS) < $minimal_purchase)
                {
                    $this->context->smarty->assign('cgma_error', sprintf($this->l('A minimum purchase total of %1s is required to validate your order, current purchase total is %2s.'), Tools::displayPrice($minimal_purchase, $currency), Tools::displayPrice($this->context->cart->getOrderTotal((Configuration::get('cgma_tax') == 1 ? true : false), Cart::ONLY_PRODUCTS), $currency)));
                    return $this->display(__FILE__, 'views/templates/front/displayShoppingCart.tpl');
                }
            }
        }
        else
        {
           if ($this->context->cart->getOrderTotal((Configuration::get('cgma_tax') == 1 ? true : false), Cart::ONLY_PRODUCTS) < $minimal_purchase)
            {
                $this->context->smarty->assign('cgma_error', sprintf($this->l('A minimum purchase total of %1s is required to validate your order, current purchase total is %2s. HOLA II'), Tools::displayPrice($minimal_purchase, $currency), Tools::displayPrice($this->context->cart->getOrderTotal((Configuration::get('cgma_tax') == 1 ? true : false), Cart::ONLY_PRODUCTS), $currency)));
                return $this->display(__FILE__, 'views/templates/front/displayShoppingCart.tpl');
            }
        }
    }

    public function hookdisplayHeader($params)
    {
        $this->context->controller->addCSS(($this->_path) . 'views/css/cgma.css', 'all');
        $this->context->controller->addJS(($this->_path) . 'views/js/cgma.js', 'all');
    }

    public static function returnCustomerGroupMinimum() {
        $return = 0;
        $context = new Context();
        $context = $context->getContext();

        foreach (self::getCustomerGroups() AS $group => $yes)
        {
            if((float)Configuration::get('cgma'.$group) > $return)
            {
                $return = (float)Configuration::get('cgma'.$group);
            }
        }
        return $return;
    }

    public static function getCustomerGroups()
    {
        $customer_groups = array();
        if (isset(Context::getContext()->cart->id_customer))
        {
            if (Context::getContext()->cart->id_customer == 0)
            {
                $customer_groups[1] = 1;
            }
            else
            {
                foreach (Customer::getGroupsStatic(Context::getContext()->cart->id_customer) as $group)
                {
                    $customer_groups[$group] = 1;
                }
            }
        }
        elseif (Context::getContext()->customer->is_guest == 1)
        {
            $customer_groups[1] = 2;
        }
        else
        {
            $customer_groups[1] = 1;
        }
        if (count($customer_groups) > 0)
        {
            return $customer_groups;
        }
        else
        {
            return 1;
        }
    }

}

class cgmaUpdate extends cgma
{
    public static function version($version)
    {
        $version = (int)str_replace(".", "", $version);
        if (strlen($version) == 3)
        {
            $version = (int)$version . "0";
        }
        if (strlen($version) == 2)
        {
            $version = (int)$version . "00";
        }
        if (strlen($version) == 1)
        {
            $version = (int)$version . "000";
        }
        if (strlen($version) == 0)
        {
            $version = (int)$version . "0000";
        }
        return (int)$version;
    }

    public static function encrypt($string)
    {
        return base64_encode($string);
    }

    public static function verify($module, $key, $version)
    {
        if (ini_get("allow_url_fopen"))
        {
            if (function_exists("file_get_contents"))
            {
                $actual_version = @file_get_contents('http://dev.mypresta.eu/update/get.php?module=' . $module . "&version=" . self::encrypt($version) . "&lic=$key&u=" . self::encrypt(_PS_BASE_URL_ . __PS_BASE_URI__));
            }
        }
        Configuration::updateValue("update_" . $module, date("U"));
        Configuration::updateValue("updatev_" . $module, $actual_version);
        return $actual_version;
    }
}

?>
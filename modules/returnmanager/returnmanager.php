<?php
/**
 * DISCLAIMER
 *
 * Do not edit or add to this file if you wish to upgrade PrestaShop to newer
 * versions in the future. If you wish to customize PrestaShop for your
 * needs please refer to http://www.prestashop.com for more information.
 * We offer the best and most useful modules PrestaShop and modifications for your online store.
 *
 * @author    knowband.com <support@knowband.com>
 * @copyright 2017 Knowband
 * @license   see file: LICENSE.txt
 * @category  PrestaShop Module
 *
 *
 * Description
 *
 * Updates quantity in the cart
 */

//include_once(_PS_MODULE_DIR_ . 'returnmanager/libraries/dompdf/dompdf_config.inc.php');
include_once(_PS_MODULE_DIR_ . 'returnmanager/libraries/barcodes.php');

if (!defined('_PS_VERSION_')) {
    exit;
}

include_once dirname(__FILE__) . '/classes/common.php';

/**
 * The parent class is extending the "Module" core class.
 * So no need to extend "Module" core class here in this class.
 */
class ReturnManager extends Common
{

    private $data_form = array();
    protected $product_data;
    protected $json = array();

    public function __construct()
    {
        parent::__construct();

        $this->name = 'returnmanager';
        $this->tab = 'front_office_features';
        $this->version = '2.0.6';
        $this->author = 'Knowband';
        //$this->need_instance = 0;
        $this->module_key = '2a2e51296e66453d802ff6b2714aedcf';
        $this->author_address = '0x2C366b113bd378672D4Ee91B75dC727E857A54A6';
        $this->ps_versions_compliancy = array('min' => '1.4', 'max' => _PS_VERSION_);
        //$this->bootstrap = true;

        $this->displayName = $this->l('Returns Manager');
        $this->description = $this->l('It allows customers to return products by using a user friendly interface.');

        $this->confirmUninstall = $this->l('Are you sure you want to uninstall?');

        if (!Configuration::get('VELSOF_RETURNMANAGER')) {
            $this->warning = $this->l('No name provided');
        }
    }

    public function install()
    {
        if (Shop::isFeatureActive()) {
            Shop::setContext(Shop::CONTEXT_ALL);
        }

        if (!parent::install() ||
            !$this->registerHook('displayCustomerAccount') ||
            !$this->registerHook('displayAdminProductsExtra') ||
            !$this->registerHook('actionProductSave') ||
            !$this->registerHook('actionExportGDPRData') ||
            !$this->registerHook('actionDeleteGDPRCustomer') ||
            !$this->registerHook('displayNav1')) {
            return false;
        }
        // Create module Tables
        $query = 'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'velsof_return_data` (
			  `return_data_id` int(11) NOT NULL AUTO_INCREMENT,
			  `reason` enum("1","0") NOT NULL,
			  `status` enum("1","0") NOT NULL,
			  `policy` enum("1","0") NOT NULL,
			  `whopayshipping` enum("c","so") NOT NULL,
			  `refund_days` int(4) NOT NULL DEFAULT 0,
			  `credit_days` int(4) NOT NULL DEFAULT 0,
			  `replacement_days` int(4) NOT NULL DEFAULT 0,
			  `active` enum("1","0") NOT NULL DEFAULT 1,
                          `editable` enum("1","0") NOT NULL DEFAULT 1,
			  `date_added` datetime NOT NULL,
			  `date_updated` datetime NOT NULL,
			  PRIMARY KEY (`return_data_id`)
			) CHARACTER SET utf8 COLLATE utf8_general_ci';
        Db::getInstance()->execute($query);

        $query = 'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'velsof_return_data_lang` (
            `return_data_id` int(11) NOT NULL,
            `id_shop` int(11) unsigned NOT NULL DEFAULT 1,
            `id_lang` int(10) unsigned NOT NULL,
            `value` text NOT NULL,
            `terms` text NOT NULL,
            `credit_message` text NOT NULL,
            `refund_message` text NOT NULL,
            `replacement_message` text NOT NULL
              ) CHARACTER SET utf8 COLLATE utf8_general_ci';
        Db::getInstance()->execute($query);

        $query = 'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'velsof_return_policy_product` (
			`return_data_id` int(11) NOT NULL,
			`id_product` int(11) NOT NULL,
			`id_categories` int(11) NOT NULL,
			INDEX (`return_data_id`), INDEX (`id_product`), INDEX (`id_categories`))';
        Db::getInstance()->execute($query);

        $query = 'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'velsof_rm_order` (
            `id_rm_order` int(11) NOT NULL AUTO_INCREMENT,
            `id_order_return` int(11) NOT NULL DEFAULT 0,
            `id_customer` int(11) NOT NULL,
            `id_order` int(11) NOT NULL,
            `id_shop` int(11) NOT NULL,
            `id_lang` int(11) NOT NULL,
            `id_rm_policy` int(11) NOT NULL,
            `return_type` varchar(50) NOT NULL,
            `days_applicable` int(4) NOT NULL,
            `id_rm_reason` int(11) NOT NULL,
            `whopayshipping` enum("c","so") NOT NULL,
            `comment` text NOT NULL,
            `id_order_detail` int(11) NOT NULL,
            `quantity` int(4) NOT NULL,
            `active` enum("1","2","3","4") NOT NULL DEFAULT 1,
            `date_add` datetime NOT NULL,
            `date_update` datetime NOT NULL,
             PRIMARY KEY (`id_rm_order`)
            ) CHARACTER SET utf8 COLLATE utf8_general_ci';
        Db::getInstance()->execute($query);

        $query = 'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'velsof_rm_status` (
				`id_rm_order` int(11) NOT NULL,
				`id_rm_status` int(11) NOT NULL,
				`date_add` datetime NOT NULL
				)';
        Db::getInstance()->execute($query);
        /* changes aded by rishabh on 10th july 2018 to add 1 more table to store multiple return address */
        
        $query = 'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'velsof_rm_address` (
            `id_address` int(10) NOT NULL AUTO_INCREMENT,
            `id_country` int(10) NOT NULL,
            `id_state` int(10) DEFAULT NULL,
            `title` varchar(128) NOT NULL,
            `address1` varchar(128) NOT NULL,
            `address2` varchar(128) DEFAULT NULL,
            `postcode` varchar(12) NOT NULL,
            `city` varchar(64) NOT NULL,
            `active` tinyint(4) NOT NULL,
            `date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id_address`)
          ) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8';
        Db::getInstance()->execute($query);
        
        $query = 'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'velsof_rm_return_address` (
            `id_return` int(12) NOT NULL,
            `id_address` int(12) NOT NULL,
             PRIMARY KEY (`id_return`)
          ) ENGINE=INNODB DEFAULT CHARSET=utf8';
        Db::getInstance()->execute($query);

        /* changes over */

        //Create Email templates table
        $query = 'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'velsof_rm_email` (
			`id_template` int(10) NOT NULL auto_increment,
			`id_lang` int(10) NOT NULL,
			`id_shop` INT(11) NOT NULL DEFAULT  "0",
			`iso_code` char(4) NOT NULL,
			`template_name` varchar(255) NOT NULL,
			`text_content` text NOT NULL,
			`subject` varchar(255) NOT NULL,
			`body` text NOT NULL,
			`date_add` DATETIME NOT NULL,
			`date_upd` DATETIME NOT NULL,
			PRIMARY KEY (`id_template`),
			INDEX (  `id_lang` )
			) CHARACTER SET utf8 COLLATE utf8_general_ci';
        Db::getInstance()->execute($query);

        $query = 'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'velsof_return_slip_data` (
			`id_slip_data` int(10) NOT NULL auto_increment,
			`id_lang` int(10) NOT NULL,
			`id_shop` INT(11) NOT NULL DEFAULT  "0",
			`iso_code` char(4) NOT NULL,
			`address` enum("1","0") NOT NULL,
			`guideline` enum("1","0") NOT NULL,
			`html_content` text NOT NULL,
			`date_add` DATETIME NOT NULL,
			`date_upd` DATETIME NOT NULL,
			PRIMARY KEY (`id_slip_data`),
			INDEX (  `id_lang` )
			) CHARACTER SET utf8 COLLATE utf8_general_ci';
        Db::getInstance()->execute($query);

        //Create Success Messages table
        $query = 'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'velsof_rm_success_messages` (
			`id_message` int(10) NOT NULL auto_increment,
			`id_lang` int(10) NOT NULL,
			`id_shop` INT(11) NOT NULL DEFAULT  "0",
			`iso_code` char(4) NOT NULL,
			`message_name` varchar(255) NOT NULL,
			`content` text NOT NULL,
			`date_add` DATETIME NOT NULL,
			`date_upd` DATETIME NOT NULL,
			PRIMARY KEY (`id_message`),
			INDEX (  `id_lang` )
			) CHARACTER SET utf8 COLLATE utf8_general_ci';
        Db::getInstance()->execute($query);

        $check_col_sql = 'SELECT count(*) FROM information_schema.COLUMNS
                              WHERE COLUMN_NAME = "image_path"
                              AND TABLE_NAME = "' . _DB_PREFIX_ . 'velsof_rm_order"
                              AND TABLE_SCHEMA = "' . _DB_NAME_ . '"';
        $check_col = Db::getInstance(_PS_USE_SQL_SLAVE_)->getValue($check_col_sql);
        if ((int) $check_col == 0) {
            $query = 'ALTER TABLE `' . _DB_PREFIX_ . 'velsof_rm_order` ADD `image_path` TEXT NULL AFTER `quantity`';
            Db::getInstance()->execute($query);
        }
        if (!Configuration::get('VELSOF_RETURN_MANAGER_DEFAULT_VALUES_CHECK')) {
            $reason_arr = array(
                array(
                    'Wrong Product',
                    'so'),
                array(
                    'Wrong Attribute',
                    'so'),
                array(
                    'Size Issue',
                    'c'),
                array(
                    'Damaged Product',
                    'c'),
                array(
                    'Change Product',
                    'c')
            );
            foreach ($reason_arr as $reason) {
                $inserting_reason = 'insert into ' . _DB_PREFIX_ . 'velsof_return_data values("","1","0","0","' .
                    pSQL($reason[1]) . '","","","","1","0",now(),now())';
                Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($inserting_reason);
                $reason_id = Db::getInstance()->Insert_ID();
                foreach (Language::getLanguages(true) as $lang) {
                    foreach (Shop::getCompleteListOfShopsID() as $shop_id) {
                        $inserting_reason_lang = 'insert into ' . _DB_PREFIX_ . 'velsof_return_data_lang
							values(' . (int) $reason_id . ',' . (int) $shop_id . ',' . (int) $lang['id_lang'] .
                            ',"' . pSQL($reason[0]) . '","","","","")';
                        Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($inserting_reason_lang);
                    }
                }
            }

            $status_arr = array(
                'In Progress',
                'Processing',
                'Returned',
                'Rejected',
                'Awaiting Delivery');
            foreach ($status_arr as $status) {
                $qry = 'insert into ' . _DB_PREFIX_ .
                    'velsof_return_data values("","0","1","0","","","","","1","0",now(),now())';
                Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($qry);
                $id = Db::getInstance()->Insert_ID();
                foreach (Language::getLanguages(true) as $lang) {
                    foreach (Shop::getCompleteListOfShopsID() as $shop_id) {
                        $qry = 'insert into ' . _DB_PREFIX_ . 'velsof_return_data_lang
							values(' . (int) $id . ',' . (int) $shop_id . ',' . (int) $lang['id_lang'] . ',"' .
                            pSQL($status) . '","","","","")';
                        Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($qry);
                    }
                }
            }
            Configuration::updateGlobalValue('VELSOF_RETURN_MANAGER_DEFAULT_VALUES_CHECK', 1);
        }

        if (!Configuration::get('VELSOF_RETURN_MANAGER_MAIL_CHECK')) {
            $mail_dir = dirname(__FILE__) . '/mails/en';

            if (Context::getContext()->language->iso_code != 'en') {
                $new_dir = dirname(__FILE__) . '/mails/' . Context::getContext()->language->iso_code;
                $this->copyfolder($mail_dir, $new_dir);
            }

            Configuration::updateGlobalValue('VELSOF_RETURN_MANAGER_MAIL_CHECK', 1);
            Configuration::updateGlobalValue(
                'VELSOF_RETURN_MANAGER_DEFAULT_TEMPLATE_LANG',
                Context::getContext()->language->iso_code
            );
        }

        $this->returndata_form = $this->getDefaultSettings();
        Configuration::updateGlobalValue('VELSOF_RETURNMANAGER', serialize($this->returndata_form));
        return true;
    }

    public function uninstall()
    {
        if (!parent::uninstall() ||
            !Configuration::deleteByName('VELSOF_RETURNMANAGER') ||
            !$this->unregisterHook('displayNav1') ||
            !$this->unregisterHook('displayAdminProductsExtra') ||
            !$this->unregisterHook('actionProductSave') ||
            !$this->unregisterHook('actionExportGDPRData') ||
            !$this->unregisterHook('actionDeleteGDPRCustomer') ||
            !$this->unregisterHook('displayCustomerAccount')) {
            return false;
        }

        return true;
    }

    public function copyfolder($source, $destination)
    {
        $directory = opendir($source);
        mkdir($destination);
        while (($file = readdir($directory)) != false) {
            Tools::copy($source . '/' . $file, $destination . '/' . $file);
        }
        closedir($directory);
    }

    public function downloadSimplifiedFiles($file_name)
    {
        $files_dir = $this->getCommonFilesPath();
        $file = $files_dir . $file_name;
        $file_rename = basename($file);
        header('Content-Type: application/octet-stream');
        header('Content-Disposition: attachment; filename="' . $file_rename . '"');
        header('Content-Length: ' . filesize($file));
        readfile($file);
        exit;
    }

    private function getCommonFilesPath()
    {
        return _PS_IMG_DIR_ . 'velsof_return/';
    }

    public function hookActionDeleteGDPRCustomer($customer)
    {
        if (!empty($customer['email']) && Validate::isEmail($customer['email'])) {
            if (Module::isInstalled('returnmanager')) {
                $config = Tools::unserialize(Configuration::get('VELSOF_RETURNMANAGER'));
                if (($config['enable'] == 1) && ($config['enable_gdpr_delete'] == 1)) {
                    $customerFound = false;
                    $sqlCustomer = "SELECT id_customer FROM "._DB_PREFIX_."customer WHERE email = '".pSQL($customer['email'])."'";
                    $customerData = Db::getInstance()->getRow($sqlCustomer);
                    if (!Tools::isEmpty($customerData) && $customerData) {
                        $sqlSelectReturn = "SELECT * FROM "._DB_PREFIX_."velsof_rm_order WHERE id_customer = '".(int)$customerData['id_customer']."'";
                        $res = Db::getInstance()->ExecuteS($sqlSelectReturn);
                        if (count($res)) {
                            $sqlDeleteStatus = "DELETE FROM "._DB_PREFIX_."velsof_rm_status WHERE id_rm_order IN ( Select distinct id_rm_order from "._DB_PREFIX_."velsof_rm_order where id_customer = '".(int)$customerData['id_customer']."')";
                            Db::getInstance()->execute($sqlDeleteStatus);
                            $sqlDeleteOrder = "DELETE FROM "._DB_PREFIX_."velsof_rm_order WHERE id_customer = '".(int)$customerData['id_customer']."'";
                            Db::getInstance()->execute($sqlDeleteOrder);
                            $customerFound = true;
                        }
                    }
                    if ($customerFound) {
                        return Tools::jsonEncode(true);
                    } else {
                        return Tools::jsonEncode($this->l('Return Manager: No user found with this email.', 'abandonedcart_core'));
                    }
                }
            }
        }
    }

    public function hookActionExportGDPRData($customer)
    {
        if (!empty($customer['email']) && Validate::isEmail($customer['email'])) {
            if (Module::isInstalled('returnmanager')) {
                $config = Tools::unserialize(Configuration::get('VELSOF_RETURNMANAGER'));
                if ($config['enable'] == 1) {
                    $export_data = array();
                    $sqlCustomer = "SELECT id_customer FROM "._DB_PREFIX_."customer WHERE email = '".pSQL($customer['email'])."'";
                    $customer_data = Db::getInstance()->getRow($sqlCustomer);
                    if (count($customer_data) && $customer_data) {
                        $getCustomerReturnOrderSql = "SELECT * from "._DB_PREFIX_."velsof_rm_order where id_customer = '".(int)$customer_data['id_customer']."'";
                        $getCustomerReturnOrderList = Db::getInstance()->executeS($getCustomerReturnOrderSql);
                        if (count($getCustomerReturnOrderList)) {
                            foreach ($getCustomerReturnOrderList as $key => $return_details) {
                                $return_data = $this->getReturnData($return_details['id_rm_order']);
                                if (count($return_data)) {
                                    $current = current($return_data[0]);
                                    $end = end($return_data[0]);
                                    $export_data[] = array(
                                        $this->l('Return ID') => $return_data[1]['return_id'],
                                        $this->l('Cutomer Name') => $return_data[1]['cust_name'],
                                        $this->l('Email') => $return_data[1]['email'],
                                        $this->l('Product Name') => $return_data[1]['product_name'],
                                        $this->l('Product Attribute') => $return_data[1]['product_attr'],
                                        $this->l('Quantity') => $return_data[1]['quantity'],
                                        $this->l('Unit Price(Inc Tax)') => $return_data[1]['unit_price_tax_incl'],
                                        $this->l('Return Reason') => $return_data[1]['reason'],
                                        $this->l('Order Reference') => $return_data[1]['order_reference'],
                                        $this->l('Order Shipping Charge') => $return_data[1]['order_shipping'],
                                        $this->l('Order Total') => $return_data[1]['order_total'],
                                        $this->l('Order Date') => $return_data[1]['order_date'],
                                        $this->l('Current Status') => $current['status'],
                                        $this->l('Return Date') => $end['date'],
                                    );
                                }
                            }
                        }
                    }
                    if (count($export_data)) {
                        return Tools::jsonEncode($export_data);
                    } else {
                        return Tools::jsonEncode($this->l('Return Manager : No User found with this email.'));
                    }
                }
            }
        }
    }
    
    public function getContent()
    {
        if (Tools::isSubmit('ajax')) {
            $this->ajaxProcess(Tools::getValue('method'));
        }

        if (Tools::isSubmit('getDownloadFile')) {
            $fileName = Tools::getValue('file');
            $this->downloadSimplifiedFiles($fileName);
        }

        $this->addBackOfficeMedia();
        $output = null;

        if (Tools::isSubmit('submit_form')) {
            $post_data = Tools::getValue('velsof_return');
            $custom_data = Tools::getValue('velsof_return_custom');
            $custom_data['js'] = urlencode($custom_data['js']);
            $msg_data = Tools::getValue('velsof_return_msg');
            $slip_data = Tools::getValue('velsof_return_slip');
            Configuration::updateValue('VELSOF_RETURNMANAGER', serialize($post_data));
            Configuration::updateValue('VELSOF_RETURNMANAGER_CUSTOM', serialize($custom_data));

            $msg_arr = array(
                'credit' => $msg_data['credit_post_message'],
                'refund' => $msg_data['refund_post_message'],
                'replace' => $msg_data['replacement_post_message']
            );

            $this->saveMessagesData($msg_arr, Language::getIsoById((int) $post_data['success_messages_lang']));
            $this->saveReturnSlipData($slip_data, Language::getIsoById((int) $post_data['return_slip_lang']));
            $output .= $this->displayConfirmation($this->l('Settings has been updated successfully'));
        }

        if (!is_writable($this->getTemplateDir())) {
            $output .= $this->displayError(
                $this->l('Please give read/write permission to ') . $this->getTemplateDir() . $this->l(' directory.')
            );
        }
        if (!is_writable(_PS_IMG_DIR_)) {
            $output .= $this->displayError(
                $this->l('Please give read/write permission to ') . _PS_IMG_DIR_ . $this->l(' directory.')
            );
        } else {
            if (!file_exists(_PS_IMG_DIR_ . 'velsof_return')) {
                mkdir(_PS_IMG_DIR_ . 'velsof_return', 0777, true);
            }
        }

        if (!$this->getPolicy()) {
            $output .= $this->displayError(
                $this->l('Please create atleast one Return Policy and map category to it (Go to Return Policy Tab)')
            );
        }

        $store_languages = Language::getLanguages(true);
//		$this->smarty->assign('languages', $store_languages);
        $custom_ssl_var = 0;
        if (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') {
            $custom_ssl_var = 1;
        }

        if ((bool) Configuration::get('PS_SSL_ENABLED') && $custom_ssl_var == 1) {
            $ps_base_url = _PS_BASE_URL_SSL_;
        } else {
            $ps_base_url = _PS_BASE_URL_;
        }
        $this->smarty->assign('img_lang_dir', $ps_base_url . __PS_BASE_URI__ .
            str_replace(_PS_ROOT_DIR_ . '/', '', _PS_LANG_IMG_DIR_));

        $settings = Configuration::get('VELSOF_RETURNMANAGER');
        $this->data_form = Tools::unSerialize($settings);

        $this->data_form['credit_post_message'] = $this->getMessageByName('credit', $store_languages[0]['iso_code']);
        $this->data_form['refund_post_message'] = $this->getMessageByName('refund', $store_languages[0]['iso_code']);
        $this->data_form['replacement_post_message'] = $this->getMessageByName(
            'replace',
            $store_languages[0]['iso_code']
        );
        if ($this->getReturnSlipDataByLanguage('address', $store_languages[0]['iso_code'])) {
            $this->data_form['return_slip_address'] = $this->getReturnSlipDataByLanguage(
                'address',
                $store_languages[0]['iso_code']
            );
        }
        if ($this->getReturnSlipDataByLanguage('guide', $store_languages[0]['iso_code'])) {
            $this->data_form['return_slip_guidelines'] = $this->getReturnSlipDataByLanguage(
                'guide',
                $store_languages[0]['iso_code']
            );
        }

        $this->data_form['custom_data'] = Tools::unSerialize(Configuration::get('VELSOF_RETURNMANAGER_CUSTOM'));
        $this->data_form['custom_data']['js'] = urldecode($this->data_form['custom_data']['js']);
        $shop_id = $this->context->shop->id;
        $cat_qry = 'SELECT c.id_category AS id_category, cl1.name AS name, c.id_parent FROM ' .
            _DB_PREFIX_ . 'category c
            LEFT JOIN ' . _DB_PREFIX_ . 'category_lang cl1 ON (c.id_category = cl1.id_category)
            WHERE cl1.id_lang = ' . (int) $this->context->language->id . ' AND cl1.id_shop = ' .
            (int) $this->context->shop->id . '
            and c.id_category > 1 GROUP BY c.id_category ORDER BY id_category';
        $category_data = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($cat_qry);
        $categories = array();
        foreach ($category_data as $cat) {
            if ($cat['id_parent'] == 0) {
                $categories[] = $cat;
            } else {
                $cat_path = $this->createCatLevel(array(
                    $cat['name']), $cat['id_parent'], $category_data);
                $path = implode(' >> ', array_reverse($cat_path));
                $categories[] = array(
                    'id_category' => $cat['id_category'],
                    'name' => $path);
            }
        }
        $shop_id = Context::getContext()->shop->id;
        $select_all_status_lang = 'select data.return_data_id, lang.value, lang.id_lang from ' .
            _DB_PREFIX_ . 'velsof_return_data
            data, ' . _DB_PREFIX_ . 'velsof_return_data_lang lang where active="1" and id_shop=' . (int) $shop_id . '
            and data.status = "1" and data.return_data_id= lang.return_data_id';
        $all_status_lang = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($select_all_status_lang);

        $reason_detail = $this->select('reason');
        $status_detail = $this->select('status');
        $policy_detail = $this->select('policy');
        $address_detail = $this->select('address');
        
        $return_pending = $this->getReturns();
        if (isset($return_pending['data']) && $return_pending['data'] != null) {
            $i = 0;
            foreach ($return_pending['data'] as $return_pen) {
                $return_pending['data'][$i]['comment'] = nl2br($return_pen['comment']);
                $i++;
            }
        }
        // added address form by rishabh
        // Generate countries list
        $countries = Country::getCountries($this->context->language->id, true);
        $list = '';
        $id_country = (int)Configuration::get('PS_COUNTRY_DEFAULT');
        foreach ($countries as $country) {
            $selected = ((int)$country['id_country'] === $id_country) ? ' selected="selected"' : '';
            $list .= '<option value="'.(int)$country['id_country'].'"'.$selected.'>'.htmlentities($country['name'], ENT_COMPAT, 'UTF-8').'</option>';
        }
        $state_query = 'Select id_state,name from '. _DB_PREFIX_ . 'state where id_country = '.$id_country;
        $state_list = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($state_query);
        // Assign vars
        $this->context->smarty->assign(array(
            'countries_list' => $list,
            'countries' => $countries,
            'sl_country' => (int)$id_country,
        ));
        $this->context->smarty->assign('state_list', $state_list);
        $this->context->smarty->assign('number_state', count($state_list));
    
        // end
        /* Start Added by Anshul Mittal on "24-08-2017" to add a functionality of email editing before sending it to customer */
        $this->context->smarty->assign('send_email_lang', $this->context->language->id);
        /* End Added by Anshul Mittal on "24-08-2017" to add a functionality of email editing before sending it to customer */
        $return_active = $this->getReturns(2);
        $archive_returns = $this->getReturns(4);
        $order_controller = $this->context->link->getAdminLink('AdminOrders');
        $this->context->smarty->assign('return_history', $return_active);
        $this->context->smarty->assign('return_pending', $return_pending);
        $this->context->smarty->assign('archive_returns', $archive_returns);
        $this->context->smarty->assign('customer_controller', $this->context->link->getAdminLink('AdminCustomers'));
        $this->context->smarty->assign('order_controller', $order_controller);

        $base_path = ($ps_base_url . __PS_BASE_URI__ . str_replace(_PS_ROOT_DIR_ . '/', '', _PS_MODULE_DIR_));
        $this->smarty->assign(array(
            'velsof_return' => $this->data_form,
            'action' => AdminController::$currentIndex . '&token=' . Tools::getAdminTokenLite('AdminModules') .
            '&configure=' . $this->name,
            'cancel_action' => AdminController::$currentIndex . '&token=' . Tools::getAdminTokenLite('AdminModules'),
            'reasons' => $reason_detail,
            'status' => $status_detail,
            'address' => $address_detail,
            'status_lang_detail' => $all_status_lang,
            'policy' => $policy_detail,
            'category' => $categories,
            'path' => $base_path,
            'ad' => __PS_BASE_URI__ . basename(_PS_ADMIN_DIR_),
            'iso' => $this->context->language->iso_code,
            'languages' => Language::getLanguages(true),
            'count_languages' => count(Language::getLanguages(true)),
            'templates_list' => $this->getTemplatesListArray()
        ));
        $output .= $this->display(__FILE__, 'views/templates/admin/admin_returnmanager.tpl');
        return $output;
    }

    private function createCatLevel($cat_name, $id_parent, $categories)
    {
        foreach ($categories as $cat) {
            if ($cat['id_category'] == $id_parent) {
                $cat_name[] = $cat['name'];
                if ($cat['id_parent'] == 0) {
                    return $cat_name;
                } else {
                    $cat_name = $this->createCatLevel($cat_name, $cat['id_parent'], $categories);
                }
            }
        }
        return $cat_name;
    }

    private function getTemplatesListArray()
    {
        return array(
            'new_ret_cust' => $this->l('New Return Request Notice (Customer)'),
            'new_ret_adm' => $this->l('New Return Request Notice (Admin)'),
            'ret_app' => $this->l('Return Request Approved'),
            'ret_den' => $this->l('Return Request Denied'),
            'ret_stat' => $this->l('Return Request Status Change'),
            'ret_comp' => $this->l('Return Request Completed')
        );
    }

    private function ajaxProcess($method)
    {
        $this->json = array();
        switch ($method) {
            case 'policy_to_product_mapping':
                $this->json = $this->productPolicyMapping();
                break;
            case 'get_mapped_product':
                $this->json = $this->getMappedProduct();
                break;
            case 'getCategoryProduct':
                $this->json = $this->getCategoryProduct();
                break;
            case 'changeAddressStatus':
                $this->changeAddressStatus();
                die();
            case 'AddData':
                $this->addData();
                die;
            case 'getData':
                $this->json = $this->getData();
                break;
            case 'getStateList':
                $this->json = $this->getStateList();
                die();
            case 'delete':
                $this->delete();
                die;

            case 'approveReturn':
                $return_id = Tools::getValue('ret');
                /* Start Added by Anshul Mittal on 25-08-2017 to add a functionality of email editing before sending it to customer */
                $temp_allow = array();
                $temp_allow['subject'] = Tools::getValue('subject_email_allow');
                $temp_allow['body'] = Tools::getValue('body_email_allow');
                $temp_allow['body'] = str_replace("&amp;", "#####@@@@@@", $temp_allow['body']);
                $temp_allow['body'] = str_replace("#####@@@@@@", "&;", $temp_allow['body']);
                $temp_allow['body'] = str_replace("@@@@@@@@@@@@", "&", $temp_allow['body']);
                /* End Added by Anshul Mittal on 25-08-2017 to add a functionality of email editing before sending it to customer */
                $update_return = 'update ' . _DB_PREFIX_ .
                    'velsof_rm_order set active=2, date_update=now() where id_rm_order=' . (int) $return_id . ' and
                    id_shop=' . (int) $this->context->shop->id;
                Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($update_return);
                $get_return_data = 'select id_order, id_customer, id_rm_order as return_id from ' .
                    _DB_PREFIX_ . 'velsof_rm_order
                    where id_rm_order = ' . (int) $return_id;
                $return_data = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($get_return_data);
                $settings = Tools::unSerialize(Configuration::get('VELSOF_RETURNMANAGER'));
                if (isset($settings['enable_return_slip']) && $settings['enable_return_slip'] == 1) {
                    $this->generateReturnSlip((int) $return_id);
                }
                /* Edited by Anshul Mittal On 25-08-2017 to add a functionality of email editing before sending it to customer */
                $this->json['mail_sent'] = $this->sendNotificationEmail('ret_app', $return_data, $temp_allow);
                unset($settings);
                break;
            case 'denyReturn':
                $return_id = Tools::getValue('ret');
                /* Start Added by Anshul Mittal on 25-08-2017 to add a functionality of email editing before sending it to customer */
                $temp_deny = array();
                $temp_deny['subject'] = Tools::getValue('subject_email_deny');
                $temp_deny['body'] = Tools::getValue('body_email_deny');
                $temp_deny['body'] = str_replace("&amp;", "#####@@@@@@", $temp_deny['body']);
                $temp_deny['body'] = str_replace("#####@@@@@@", "&;", $temp_deny['body']);
                $temp_deny['body'] = str_replace("@@@@@@@@@@@@", "&", $temp_deny['body']);
                /* End Added by Anshul Mittal on 25-08-2017 to add a functionality of email editing before sending it to customer */
                $update_return = 'update ' . _DB_PREFIX_ .
                    'velsof_rm_order set active=3, date_update=now() where id_rm_order=' . (int) $return_id . ' and
                    id_shop=' . (int) $this->context->shop->id;
                $get_return_data = 'select id_order, id_order_return, id_customer, id_rm_order as return_id from ' .
                    _DB_PREFIX_ . 'velsof_rm_order
                    where id_rm_order = ' . (int) $return_id;
                $return_data = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($get_return_data);
                /* Edited by Anshul Mittal On 25-08-2017 to add a functionality of email editing before sending it to customer */
                $this->json['mail_sent'] = $this->sendNotificationEmail('ret_den', $return_data, $temp_deny);
                $this->updateRMATables('return_denied', $return_data);
                Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($update_return);
                break;
            case 'completeReturn':
                $return_id = Tools::getValue('ret');
                /* Start Added by Anshul Mittal on 25-08-2017 to add a functionality of email editing before sending it to customer */
                $temp_comp = array();
                $temp_comp['subject'] = Tools::getValue('subject_email_comp');
                $temp_comp['body'] = Tools::getValue('body_email_comp');
                $temp_comp['body'] = str_replace("&amp;", "#####@@@@@@", $temp_comp['body']);
                $temp_comp['body'] = str_replace("#####@@@@@@", "&;", $temp_comp['body']);
                $temp_comp['body'] = str_replace("@@@@@@@@@@@@", "&", $temp_comp['body']);
                /* End Added by Anshul Mittal on 25-08-2017 to add a functionality of email editing before sending it to customer */
                $update_return = 'update ' . _DB_PREFIX_ .
                    'velsof_rm_order set active=4, date_update=now() where id_rm_order=' . (int) $return_id . ' and
                    id_shop=' . (int) $this->context->shop->id;
                Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($update_return);
                $get_return_data = 'select id_order, id_order_return, id_customer, id_rm_order as return_id from ' .
                    _DB_PREFIX_ . 'velsof_rm_order
                    where id_rm_order = ' . (int) $return_id;
                $return_data = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($get_return_data);
                /* Edited by Anshul Mittal On 25-08-2017 to add a functionality of email editing before sending it to customer */
                $this->json['mail_sent'] = $this->sendNotificationEmail('ret_comp', $return_data, $temp_comp);
                $this->updateRMATables('return_completed', $return_data);
                break;
            case 'getReturnData':
                $return_id = Tools::getValue('ret');
                $order_controller = $this->context->link->getAdminLink('AdminOrders');
                $this->context->smarty->assign('order_controller', $order_controller);
                $this->context->smarty->assign('return_detail', $this->getReturnData($return_id));
                echo $this->display(__FILE__, 'views/templates/admin/return_detail.tpl');
                die;
            case 'changeReturnStatus':
                $return_id = Tools::getValue('ret');
                $status_id = Tools::getValue('stat');
                /* Start Added by Anshul Mittal on 25-08-2017 to add a functionality of email editing before sending it to customer */
                $temp_status = array();
                $temp_status['subject'] = Tools::getValue('subject_email_status');
                $temp_status['body'] = Tools::getValue('body_email_status');
                $temp_status['body'] = str_replace("&amp;", "#####@@@@@@", $temp_status['body']);
                $temp_status['body'] = str_replace("#####@@@@@@", "&;", $temp_status['body']);
                $temp_status['body'] = str_replace("@@@@@@@@@@@@", "&", $temp_status['body']);
                /* End Added by Anshul Mittal on 25-08-2017 to add a functionality of email editing before sending it to customer */
                $get_return_data = 'select id_order, id_customer, id_rm_order as return_id from ' .
                    _DB_PREFIX_ . 'velsof_rm_order
                    where id_rm_order = ' . (int) $return_id;
                $return_data = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($get_return_data);
                $check_query = 'select * from ' . _DB_PREFIX_ . 'velsof_rm_status where id_rm_order=' .
                    (int) $return_id . ' and id_rm_status=' . (int) $status_id;
                $result = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($check_query);
                if ($result && is_array($result)) {
                    $update_status = 'update ' . _DB_PREFIX_ . 'velsof_rm_status set date_add=now() where
                                            id_rm_order=' . (int) $return_id . ' and id_rm_status=' . (int) $status_id;
                    Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($update_status);
                    $status = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow('SELECT value from
                    ' . _DB_PREFIX_ . 'velsof_return_data_lang where return_data_id = ' . (int) $result['id_rm_status'] .
                        ' and
                    id_lang=' . (int) $this->context->language->id . ' and id_shop=' . (int) $this->context->shop->id);
                    $return_data['previous_status'] = $status['value'];
                } else {
                    $get_previous_status = 'select id_rm_status from ' . _DB_PREFIX_ . 'velsof_rm_status where
                        id_rm_order = ' . (int) $return_id . ' order by date_add desc';
                    $previous_status_id = $result = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($get_previous_status);
                    $status = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow('SELECT value from
                        ' . _DB_PREFIX_ . 'velsof_return_data_lang where return_data_id = ' .
                        (int) $previous_status_id['id_rm_status'] . ' and
                        id_lang=' . (int) $this->context->language->id . ' and id_shop=' .
                        (int) $this->context->shop->id);
                    $return_data['previous_status'] = $status['value'];
                    $add_status = 'insert into ' . _DB_PREFIX_ .
                        'velsof_rm_status (`id_rm_order`,`id_rm_status`,`date_add`)
                        values (' . (int) $return_id . ',' . (int) $status_id . ',now())';
                    Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($add_status);
                }
                $result = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow('SELECT value from
                    ' . _DB_PREFIX_ . 'velsof_return_data_lang where return_data_id = ' . (int) $status_id . ' and
                    id_lang=' . (int) $this->context->language->id . ' and id_shop=' .
                    (int) $this->context->shop->id);
                $return_data['current_status'] = $result['value'];
                /* Edited by Anshul Mittal On 25-08-2017 to add a functionality of email editing before sending it to customer */
                $result['mail_sent'] = $this->sendNotificationEmail('ret_stat', $return_data, $temp_status);
                echo Tools::jsonEncode($result);
                die;
            case 'getArchives':
                $from = Tools::getValue('from_date');
                $to = Tools::getValue('to_date');
                $this->json = $this->getReturns(4, $from, $to);
                break;
            case 'writeArchiveExcel':
                $from = Tools::getValue('from_date');
                $to = Tools::getValue('to_date');
                echo $this->writeExcel($from, $to);
                die;
            case 'getOrder':
                $this->json = $this->getOrderAdmin(
                    trim(Tools::getValue('rm_reference_id')),
                    trim(Tools::getValue('rm_customer_email'))
                );
                break;
            case 'getRequestForm':
                $this->json = $this->getRequestForm();
                break;
            case 'submitReturnRequest':
                $this->json = $this->submitReturnRequest();
                $this->json['return_data'] = $this->getPendingReturnData($this->json['return_id']);
                break;
            case 'loadEmailTemplate':
                $selected_lang = Tools::getValue('selected_lang');
                $selected_temp = Tools::getValue('selected_temp');
                $this->json = $this->loadEmailTemplate($selected_lang, $selected_temp);
                break;
            case 'saveEmailTemplate':
                $this->json = $this->saveEmailTemplate();
                break;
            case 'getNextReturnsListingPage':
                $this->json = $this->getReturns(Tools::getValue('active_status'));
                break;
            case 'getMessagesData':
                $this->json = $this->getMessagesData((int) Tools::getValue('selected_lang'));
                break;
            case 'getReturnSlipData':
                $lang_iso = Language::getIsoById((int) Tools::getValue('selected_lang'));
                $this->json['address'] = $this->getReturnSlipDataByLanguage('address', $lang_iso);
                $this->json['guidelines'] = $this->getReturnSlipDataByLanguage('guide', $lang_iso);
                break;
        }
        header('Content-Type: application/json', true);
        echo Tools::jsonEncode($this->json);
        die;
    }

    public function saveEmailTemplate()
    {
        $template_data = Tools::getValue('rm_email');
        $json = array();
        $template_data['text_content'] = Tools::getValue('text_content');
        if ($template_data['subject'] == '') {
            $json['success'] = false;
            $json['error'] = $this->l('Template subject can not be left blank.');
        } elseif ($template_data['content'] == '') {
            $json['success'] = false;
            $json['error'] = $this->l('Template content can not be left blank.');
        }
        if (isset($json['error'])) {
            return $json;
        }
        $qry = '';
        if ($template_data['template_id'] > 0) {
            $qry = 'UPDATE ' . _DB_PREFIX_ . 'velsof_rm_email set
				text_content = "' . Tools::htmlentitiesUTF8($template_data['text_content'])
                . '", subject = "' . Tools::htmlentitiesUTF8($template_data['subject']) . '",
				body="' . Tools::htmlentitiesUTF8($template_data['content']) . '", date_upd=now() where
				id_template = ' . (int) $template_data['template_id'];
        } else {
            $qry = 'INSERT into ' . _DB_PREFIX_ . 'velsof_rm_email values ("", ' .
                (int) $template_data['template_lang'] . ',
				' . (int) $this->context->shop->id . ', "' .
                pSQL(Language::getIsoById((int) $template_data['template_lang'])) . '",
				"' . pSQL($template_data['template_name']) . '", "' .
                Tools::htmlentitiesUTF8($template_data['text_content']) . '",
				"' . Tools::htmlentitiesUTF8($template_data['subject']) . '", "' .
                Tools::htmlentitiesUTF8($template_data['content']) . '",
				now(), now())';
        }
        if (Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($qry)) {
            $json['success'] = true;
            $json['msg'] = $this->l('Email template updated successfully.');
        } else {
            $json['success'] = false;
            $json['error'] = $this->l('Unable to update email template.');
        }
        return $json;
    }

    public function writeExcel($from_date, $to_date)
    {
        if ($from_date == null) {
            $to = date('Y-m-d', time());
            $from = date('Y-m-d', strtotime('last month'));
        } else {
            $to = date('Y-m-d', strtotime($to_date));
            $from = date('Y-m-d', strtotime($from_date));
        }
        $get_returns = 'select * from ' . _DB_PREFIX_ . 'velsof_rm_order od where od.active=4 and
            od.id_shop=' . (int) $this->context->shop->id . ' and
            (date(od.date_update) between "' . pSQL($from) . '" and "' . pSQL($to) . '") order by date_update desc';
        $return_data = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($get_returns);
        $directory = _PS_MODULE_DIR_ . 'returnmanager/reports/';
        if (!is_writable($directory)) {
            return '1';
        }
        $currency = (string)$this->context->currency->iso_code;
        $f = fopen($directory . 'Archives_List.csv', 'w+');
        $header = array(
            $this->l('Order'),
            $this->l('Customer Name'),
            $this->l('Customer Email'),
            $this->l('Product'),
            $this->l('Price').'('.$currency.')',
            $this->l('Quantity'),
            $this->l('Shipping Paid By'),
            $this->l('Return Type'),
            $this->l('Return Reason'),
            $this->l('Request Date'),
            $this->l('Customer Notes'),
            $this->l('Current Status')
        );
        fputcsv($f, $header);

        foreach ($return_data as $return) {
            $data_to_write = array();
            $odr_obj = new Order($return['id_order']);
            $data_to_write[] = $odr_obj->reference;
            $cust_obj = new Customer($return['id_customer']);
            $data_to_write[] = $cust_obj->firstname . ' ' . $cust_obj->lastname;
            $data_to_write[] = $cust_obj->email;

            $get_name = 'select product_name,unit_price_tax_incl from ' . _DB_PREFIX_ . 'order_detail
				where id_order_detail=' . (int) $return['id_order_detail'] . ' and id_shop=' .
                (int) $this->context->shop->id;
            $pro_name = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($get_name);
            $data_to_write[] = $pro_name['product_name'];
            $data_to_write[] = Tools::displayNumber($pro_name['unit_price_tax_incl']);
            $data_to_write[] = $return['quantity'];
            if ($return['whopayshipping'] == 'c') {
                $data_to_write[] = $this->l('Customer');
            } else {
                $data_to_write[] = $this->l('Store Owner');
            }

            $data_to_write[] = $this->l(Tools::ucfirst($return['return_type']));

            $get_stat_name = 'select l.value from ' . _DB_PREFIX_ . 'velsof_return_data_lang l,' .
                _DB_PREFIX_ . 'velsof_return_data
				d where l.id_lang=' . (int) $this->context->language->id . '
                and l.id_shop=' . (int) $this->context->shop->id . ' and d.return_data_id=' .
                (int) $return['id_rm_reason'] . ' and
				l.return_data_id=d.return_data_id';
            $status_name = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($get_stat_name);
            $data_to_write[] = $status_name['value'];
//            $data_to_write[] = date('d-M-Y', strtotime($return['date_add']));
            $data_to_write[] = Tools::displayDate($return['date_add'], $this->context->language->id);
            $data_to_write[] = $return['comment'];
            $get_status = 'select * from ' . _DB_PREFIX_ . 'velsof_rm_status where id_rm_order=' .
                (int) $return['id_rm_order'] . ' order by date_add desc';
            $return_status = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($get_status);

            $get_stat_name = 'select value from ' . _DB_PREFIX_ . 'velsof_return_data_lang where id_lang=' .
                (int) $this->context->language->id . '
                and id_shop=' . (int) $this->context->shop->id . ' and return_data_id=' .
                (int) $return_status['id_rm_status'];
            $status_name = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($get_stat_name);
            $data_to_write[] = $status_name['value'];
            fputcsv($f, $data_to_write);
        }
        unset($cust_obj);
        unset($odr_obj);
        fclose($f);
        return 'returnmanager/reports/Archives_List.csv';
    }

    public function getActiveReturnData($return_id)
    {
        $get_returns = 'select * from ' . _DB_PREFIX_ . 'velsof_rm_order od where od.active=2 and od.id_rm_order=' .
            (int) $return_id . '
            and od.id_shop=' . (int) $this->context->shop->id;
        $return_data = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($get_returns);
        $return_history = array();
        $return_history['return_id'] = $return_id;
        $get_name = 'select product_name,product_attribute_id,product_id,unit_price_tax_incl
            from ' . _DB_PREFIX_ . 'order_detail where id_order_detail=' . (int) $return_data['id_order_detail'] .
            ' and id_shop=' . (int) $this->context->shop->id;
        $pro_name = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($get_name);

        if ($pro_name['product_attribute_id'] != 0) {
            $name_attr = explode(' - ', $pro_name['product_name']);
            $return_history['product_name'] = $name_attr[0];
            $return_history['product_attr'] = $name_attr[1];
        } else {
            $return_history['product_name'] = $pro_name['product_name'];
            $return_history['product_attr'] = '';
        }
        $cust_obj = new Customer($return_data['id_customer']);
        $return_history['cust_email'] = $cust_obj->email;
        $return_history['return_type'] = $this->l(Tools::ucfirst($return_data['return_type']));
        $return_history['comment'] = $return_data['comment'];
        $return_history['quantity'] = $return_data['quantity'];
//        $return_history['request_date'] = date('d-M-Y', strtotime($return_data['date_add']));
        $return_history['request_date'] = Tools::displayDate($return_data['date_add'], $this->context->language->id);
        $return_history['order_id'] = $return_data['id_order'];
        $return_history['customer_id'] = $return_data['id_customer'];
        $return_history['unit_price_tax_incl'] = Tools::displayPrice($pro_name['unit_price_tax_incl']);
        $get_status = 'select * from ' . _DB_PREFIX_ . 'velsof_rm_status where id_rm_order=' .
            (int) $return_data['id_rm_order'] . ' order by date_add desc';
        $return_status = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($get_status);

        $get_stat_name = 'select value from ' . _DB_PREFIX_ . 'velsof_return_data_lang where id_lang=' .
            (int) $this->context->language->id . '
            and id_shop=' . (int) $this->context->shop->id . ' and return_data_id=' .
            (int) $return_status['id_rm_status'];
        $status_name = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($get_stat_name);
        $return_history['status'] = $status_name['value'];
        $return_history['status_id'] = $return_status['id_rm_status'];
        $return_history['customer_controller'] = $this->context->link->getAdminLink('AdminCustomers');
        return $return_history;
    }

    public function getPendingReturnData($return_id)
    {
        $get_return = 'select * from ' . _DB_PREFIX_ . 'velsof_rm_order od where id_rm_order=' . $return_id . ' and
            od.id_shop=' . (int) $this->context->shop->id . ' and od.id_lang=' .
            (int) $this->context->language->id;
        $return = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($get_return);

        $get_reason_name = 'select l.value from ' . _DB_PREFIX_ . 'velsof_return_data_lang l,' .
            _DB_PREFIX_ . 'velsof_return_data d where
            l.id_lang=' . (int) $this->context->language->id . '
            and l.id_shop=' . (int) $this->context->shop->id . ' and d.return_data_id=' .
            (int) $return['id_rm_reason'] . ' and
            l.return_data_id=d.return_data_id';
        $status_name = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($get_reason_name);
        $return_data = array();
        $return_data['reason'] = $status_name['value'];
        $return_data['return_id'] = $return['id_rm_order'];
        $get_name = 'select product_name,product_attribute_id,product_id,unit_price_tax_incl
            from ' . _DB_PREFIX_ . 'order_detail where id_order_detail=' . (int) $return['id_order_detail'] .
            ' and id_shop=' . (int) $this->context->shop->id;
        $pro_name = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($get_name);
        $product_image = Image::getImages(
            $this->context->language->id,
            $pro_name['product_id'],
            $pro_name['product_attribute_id']
        );
        $image = new Image($product_image[0]['id_image']);
        $custom_ssl_var = 0;
        if (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') {
            $custom_ssl_var = 1;
        }

        if ((bool) Configuration::get('PS_SSL_ENABLED') && $custom_ssl_var == 1) {
            $ps_base_url = _PS_BASE_URL_SSL_;
        } else {
            $ps_base_url = _PS_BASE_URL_;
        }
        $return_data['pro_img'] = $ps_base_url . _THEME_PROD_DIR_ . $image->getExistingImgPath() . '.jpg';
        if ($pro_name['product_attribute_id'] != 0) {
            $name_attr = explode(' - ', $pro_name['product_name']);
            $return_data['product_name'] = $name_attr[0];
            $return_data['product_attr'] = $name_attr[1];
        } else {
            $return_data['product_name'] = $pro_name['product_name'];
            $return_data['product_attr'] = '';
        }

        if ($return['whopayshipping'] == 'c') {
            $shipp = 'Customer';
        } else {
            $shipp = 'Store Owner';
        }
        $cust_obj = new Customer($return['id_customer']);
        $odr_obj = new Order($return['id_order']);
        $return_data['cust_name'] = $cust_obj->firstname . ' ' . $cust_obj->lastname;
        $return_data['product_link'] = $this->context->link->getProductLink($pro_name['product_id']);
        $return_data['order_reference'] = $odr_obj->reference;
        $return_data['id_order'] = $return['id_order'];
        $return_data['id_customer'] = $return['id_customer'];
        $return_data['quantity'] = $return['quantity'];
        $return_data['comment'] = $return['comment'];
        $return_data['unit_price_tax_incl'] = Tools::displayPrice($pro_name['unit_price_tax_incl']);
        $return_data['return_type'] = $this->l(Tools::ucfirst($return['return_type']));
        $return_data['whopayshipping'] = $shipp;
        $return_data['order_controller'] = $this->context->link->getAdminLink('AdminOrders');
        $return_data['customer_controller'] = $this->context->link->getAdminLink('AdminCustomers');
        unset($cust_obj);
        unset($odr_obj);
        return $return_data;
    }

    public function getReturns($active = 0, $from_date = null, $to_date = null)
    {
        $page_number = 1;
        if (Tools::getValue('inc_page_number') && Tools::getValue('inc_page_number') > 1) {
            $page_number = (int) Tools::getValue('inc_page_number');
        }
        if ($active == 2) {
            $get_returns = 'select {COLUMNS} from ' . _DB_PREFIX_ . 'velsof_rm_order od where od.active=2 and
                od.id_shop=' . (int) $this->context->shop->id .
                ' order by date_update desc';
        } elseif ($active == 4) {
            if ($from_date == null) {
                $today = date('Y-m-d', time());
                $last_month = date('Y-m-d', strtotime('last month'));
            } else {
                $today = date('Y-m-d', strtotime($to_date));
                $last_month = date('Y-m-d', strtotime($from_date));
            }
            $get_returns = 'select {COLUMNS} from ' . _DB_PREFIX_ . 'velsof_rm_order od where od.active=4 and
                od.id_shop=' . (int) $this->context->shop->id . ' and
                (date(od.date_update) between "' . pSQL($last_month) . '" and "' . pSQL($today) . '")
				 order by date_update desc';
        } else {
            $get_returns = 'select {COLUMNS} from ' . _DB_PREFIX_ . 'velsof_rm_order od where od.active=1 and
                od.id_shop=' . (int) $this->context->shop->id .
                ' order by date_update desc';
        }
        $total_records = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow(
            str_replace('{COLUMNS}', 'count(*) as total', $get_returns)
        );
        if ($total_records['total'] <= 0) {
            return array(
                'flag' => false,
                'pagination' => '');
        }

        if ($page_number < 1) {
            $page_number = 1;
        }

        $total_pages = ceil((int) $total_records['total'] / self::ITEM_PER_PAGE);

        $page_position = (($page_number - 1) * self::ITEM_PER_PAGE);

        $get_returns .= ' LIMIT ' . $page_position . ', ' . self::ITEM_PER_PAGE;
        $return_data = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS(str_replace('{COLUMNS}', '*', $get_returns));
//		$return_data = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($get_returns);
        $return_history = array();
        $flag = 0;
        if ($return_data && count($return_data) > 0) {
            foreach ($return_data as $return) {
                $get_stat_name = 'select l.value from ' . _DB_PREFIX_ . 'velsof_return_data_lang l,' .
                    _DB_PREFIX_ . 'velsof_return_data d
					where l.id_shop=' . (int) $this->context->shop->id . ' and d.return_data_id=' .
                    (int) $return['id_rm_reason'] . ' and
					l.return_data_id=d.return_data_id';
                $status_name = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($get_stat_name);
                $return_history[$flag]['reason'] = $status_name['value'];
                $return_history[$flag]['return_id'] = $return['id_rm_order'];
                $get_name = 'select product_name,product_attribute_id,product_id,unit_price_tax_incl
				from ' . _DB_PREFIX_ . 'order_detail where id_order_detail=' . (int) $return['id_order_detail'] .
                    ' and id_shop=' . (int) $this->context->shop->id;
                $pro_name = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($get_name);

                if ($pro_name['product_attribute_id'] != 0) {
                    $name_attr = explode(' - ', $pro_name['product_name']);
                    $return_history[$flag]['product_name'] = $name_attr[0];
                    $return_history[$flag]['product_attr'] = $name_attr[1];
                } else {
                    $return_history[$flag]['product_name'] = $pro_name['product_name'];
                    $return_history[$flag]['product_attr'] = '';
                }
                $cust_obj = new Customer($return['id_customer']);
                $odr_obj = new Order($return['id_order']);

                $return_history[$flag]['cust_name'] = $cust_obj->firstname . ' ' . $cust_obj->lastname;
                $return_history[$flag]['cust_email'] = $cust_obj->email;
                if (isset($pro_name['product_id'])) {
                    $return_history[$flag]['product_link'] = $this->context->link->getProductLink(
                        $pro_name['product_id']
                    );
                } else {
                    $return_history[$flag]['product_link'] = 'javascript:void(0)';
                }
                $return_history[$flag]['return_id'] = $return['id_rm_order'];
                $return_history[$flag]['return_type'] = $this->l(Tools::ucfirst($return['return_type']));
                $return_history[$flag]['comment'] = $return['comment'];
                $imageurl = '';
                if (!Tools::isEmpty($return['image_path'])) {
                    $imageurl = $return['image_path'];
                }
                $return_history[$flag]['image_path'] = $imageurl;
                $return_history[$flag]['quantity'] = $return['quantity'];
                $return_history[$flag]['whopayshipping'] = $return['whopayshipping'];
//                $return_history[$flag]['request_date'] = date('d-M-Y', strtotime($return['date_add']));
                $return_history[$flag]['request_date'] = Tools::displayDate($return['date_add'], $this->context->language->id);
                if (!Validate::isLoadedObject($odr_obj)) {
                    $return_history[$flag]['order_reference'] = 'XXXXXXXXX';
                } else {
                    $return_history[$flag]['order_reference'] = $odr_obj->reference;
                }
                $return_history[$flag]['order_id'] = $return['id_order'];
                $return_history[$flag]['customer_id'] = $return['id_customer'];
                $return_history[$flag]['unit_price_tax_incl'] = Tools::displayPrice($pro_name['unit_price_tax_incl']);
                $get_status = 'select * from ' . _DB_PREFIX_ . 'velsof_rm_status where id_rm_order=' .
                    (int) $return['id_rm_order'] . ' order by date_add desc';
                $return_status = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($get_status);
                /* Edited by Anshul Mittal on 26-08-2017 to fix the issue of sent email language according to customer */
                $get_stat_name = 'select value, id_lang from ' . _DB_PREFIX_ . 'velsof_return_data_lang where id_shop=' . (int) $this->context->shop->id . ' and return_data_id=' .
                    (int) $return_status['id_rm_status'];

                $get_email_lang = 'select id_lang from ' . _DB_PREFIX_ . 'velsof_rm_order where id_shop=' . (int) $this->context->shop->id . ' and id_rm_order=' .
                    (int) $return['id_rm_order'];
                $get_email_lang = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($get_email_lang);

                $status_name = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($get_stat_name);
                $return_history[$flag]['status'] = $status_name['value'];
                $return_history[$flag]['status_id'] = $return_status['id_rm_status'];
                /* Added by Anshul Mittal on 26-08-2017 to fix the issue of sent email language according to customer */
                $return_history[$flag]['id_lang'] = $get_email_lang['id_lang'];
                $flag++;
            }
            unset($cust_obj);
            unset($odr_obj);
            if ($return_history && count($return_history) > 0) {
                $paging = $this->customPaginator(
                    $total_records['total'],
                    $total_pages,
                    'getNextReturnsListingPage',
                    $active,
                    $page_number
                );
                return array(
                    'flag' => true,
                    'data' => $return_history,
                    'pagination' => $paging['paging'],
                    'start_serial' => $paging['serial']
                );
            } else {
                return array(
                    'flag' => false,
                    'pagination' => '');
            }
        } else {
            return array(
                'flag' => false,
                'pagination' => '');
        }
    }

    public function hookDisplayCustomerAccount()
    {
        $hook_data = Tools::unSerialize(Configuration::get('VELSOF_RETURNMANAGER'));
        if (isset($hook_data['enable']) && $hook_data['enable'] == 1) {
            $r_link = $this->context->link->getModuleLink(
                $this->name,
                'manager',
                array(),
                (bool) Configuration::get('PS_SSL_ENABLED')
            );

           return '<li class="ma-link-item col-lg-2 col-md-3 col-sm-4 col-6">'.'<a href="' . $r_link . '"
                title="' . $this->l('Returns Manager') . '" >
                <span class="link-item">
                        <i class="fa fa-reply" aria-hidden="true"></i>
                    ' . $this->l('Returns Manager') . '
                </span>
                </a></li>';
        }
    }

    public function hookDisplayNav1()
    {
        if (Configuration::get('VELSOF_RETURNMANAGER') !== false) {
            $rm_config = Tools::unSerialize(Configuration::get('VELSOF_RETURNMANAGER'));
            $rm_displaynav1_links = array();
            if (isset($rm_config['enable']) && ($rm_config['enable'] == 1)) {
                $front_rm_link = $this->context->link->getModuleLink(
                    $this->name,
                    'manager',
                    array(),
                    (bool) Configuration::get('PS_SSL_ENABLED')
                );
                $rm_displaynav1_links[] = array(
                    'href' => $front_rm_link,
                    'label' => $this->l('Return'),
                    'title' => $this->l('Click here to apply for returns')
                );
                $this->context->smarty->assign('rm_displaynav1_links', $rm_displaynav1_links);
                if ($this->context->smarty->tpl_vars['page']->value['page_name'] == 'module-returnmanager-manager') {
                    $custom_data = Tools::unSerialize(Configuration::get('VELSOF_RETURNMANAGER_CUSTOM'));
                    $custom_data['js'] = urldecode($custom_data['js']);
                    $this->smarty->assign('velsof_return_custom_data', $custom_data);
                }
                return $this->display(__FILE__, 'return_link.tpl');
            }
        }
    }

    /*
     * Add css and javascript
     */

    protected function addBackOfficeMedia()
    {
        //CSS files
        $this->context->controller->addCSS($this->_path . 'views/css/returnmanager.css');
        $this->context->controller->addCSS($this->_path . 'views/css/bootstrap/bootstrap.css');
        $this->context->controller->addCSS($this->_path . 'views/css/bootstrap/responsive.css');
        $this->context->controller->addCSS($this->_path . 'views/css/theme/fonts/glyphicons/css/glyphicons_regular.css');
        $this->context->controller->addCSS($this->_path . 'views/css/theme/fonts/font-awesome/css/font-awesome.min.css');
        $this->context->controller->addCSS(
            $this->_path . 'views/css/bootstrap/extend/bootstrap-switch/static/stylesheets/bootstrap-switch.css'
        );
        $this->context->controller->addCSS($this->_path . 'views/css/theme/style-light.css');
        $this->context->controller->addCSS($this->_path . 'views/css/multiple-select.css');
        $this->context->controller->addCSS($this->_path . 'views/css/popup.css');
//                $this->context->controller->addCSS($this->_path.'views/css/velsof_rm_front.css');
        $this->context->controller->addJs($this->_path . 'views/js/velovalidation.js');
        $this->context->controller->addJs($this->_path . 'views/js/theme/demo/common.js');
        $this->context->controller->addJs($this->_path . 'views/js/tooltip.js');
        $this->context->controller->addJs(
            $this->_path . 'views/js/bootstrap/extend/bootstrap-switch/static/js/bootstrap-switch.js'
        );
        $this->context->controller->addJs($this->_path . 'views/js/jquery.multiple.select.js');
        $this->context->controller->addJs($this->_path . 'views/js/returnmanager.js');
//		$this->context->controller->addJs($this->_path.'js/jquery.multiple.select.js');
        $this->context->controller->addJs($this->_path . 'views/js/tinymce.inc.js');
        $this->context->controller->addJs($this->_path . 'views/js/tiny_mce.js');
    }

    /*
     * Return default settings of the Social Loginizer page
     */

    protected function getDefaultSettings()
    {
        $settings = array(
            'enable' => 0,
            'enable_image_upload' => 0,
            'enable_return_slip' => 0,
            'credit' => 1,
            'refund' => 1,
            /* changes done by rishabh on 10th july 2018 to add multiple address tab */
            'enable_address' => 1,
            /* changes end by rishabh */
            'replacement' => 1,
            'status' => array(
                'default' => 0
            )
        );
        return $settings;
    }

    public function select($name)
    {
        switch ($name) {
            case 'reason':
                $qry = 'select rd.return_data_id, rd.whopayshipping, rdl.value, rd.editable from '
                    . _DB_PREFIX_ . 'velsof_return_data as rd
                    INNER JOIN ' . _DB_PREFIX_ .
                    'velsof_return_data_lang as rdl on (rd.return_data_id = rdl.return_data_id)
                    where rd.reason = "1" AND rd.active="1"
                    AND rdl.id_shop=' . (int) $this->context->shop->id . ' and rdl.id_lang=' .
                    (int) $this->context->language->id;
                return Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($qry);
            case 'policy':
                $qry = 'select data.return_data_id, data.refund_days, data.credit_days,
                    data.replacement_days, rdl.value, rdl.terms from ' . _DB_PREFIX_ . 'velsof_return_data as data
                    INNER JOIN ' . _DB_PREFIX_ . 'velsof_return_data_lang as rdl on
                    (data.return_data_id = rdl.return_data_id)
                    where data.policy = "1" AND data.active="1"
                    AND rdl.id_shop=' . (int) $this->context->shop->id . ' and rdl.id_lang=' .
                    (int) $this->context->language->id;
                return Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($qry);
            case 'status':
                $qry = 'select data.return_data_id, rdl.value, rdl.terms, data.editable from '
                    . _DB_PREFIX_ . 'velsof_return_data as data
                    INNER JOIN ' . _DB_PREFIX_ . 'velsof_return_data_lang as rdl on
                    (data.return_data_id = rdl.return_data_id)
                    where data.status = "1" AND data.active="1"
                    AND rdl.id_shop=' . (int) $this->context->shop->id . ' and rdl.id_lang=' .
                    (int) $this->context->language->id;
                return Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($qry);
            case 'address':
                $qry = 'select id_address,id_country, id_state, title, address1,address2,postcode,city,active from ' . _DB_PREFIX_ . 'velsof_rm_address';
                return Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($qry);
        }
    }

    public function getMappedProduct()
    {
//		$cat_arr = array();
        $category_product = array();
//		$mapped_category_qry = 'select DISTINCT(id_categories) from '._DB_PREFIX_.'velsof_return_policy_product where
//			return_data_id='.(int)Tools::getValue('policy_id');
//		$category_list = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($mapped_category_qry);
        $policy_id = Tools::getValue('policy_id');
        $category_list = array();
        $mapped_category = array();

        if (Configuration::get('VELSOF_RETURNMANAGER_CATEGORY')) {
            $cat_data = Tools::unSerialize(Configuration::get('VELSOF_RETURNMANAGER_CATEGORY'));
            if (isset($cat_data[$policy_id])) {
                $category_list = $cat_data[$policy_id];
            }
            unset($cat_data[$policy_id]);
        }


        $query = 'select id_categories from  ' . _DB_PREFIX_ . 'velsof_return_policy_product where return_data_id != ' . $policy_id;
        $mapped_categories = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($query);
        if (count($mapped_categories) > 0) {
            foreach ($mapped_categories as $key => $value) {
                $mapped_category[] = $value['id_categories'];
            }
        }
        if (is_null($mapped_category) || empty($mapped_category)) {
            $mapped_category = array();
        }

        if ($category_list && count($category_list) > 0) {
//			foreach ($category_list as $id_cat)
//				$cat_arr[] = $id_cat['id_categories'];

            $qry = 'select DISTINCT(cat.id_product) as id_product, pro.name from ' . _DB_PREFIX_ .
                'category_product as cat
				INNER JOIN ' . _DB_PREFIX_ . 'category_lang as cl on (cl.id_category = cat.id_category)
				INNER JOIN ' . _DB_PREFIX_ . 'product_lang as pro on (cat.id_product = pro.id_product)
				where cat.id_category IN (\'' . pSQL(implode(',', $category_list)) . '\') AND
				pro.id_lang=' . (int) $this->context->language->id . ' AND pro.id_shop=' .
                (int) $this->context->shop->id
                . ' AND cl.id_lang = ' . (int) $this->context->language->id . ' AND cl.id_shop = ' .
                (int) $this->context->shop->id . ' group by pro.name';
            $category_product = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($qry);
        }
        $pro_id_arr = array();
        $mapped_product_qry = 'select DISTINCT(id_product) from ' . _DB_PREFIX_ . 'velsof_return_policy_product where
			return_data_id=' . (int) Tools::getValue('policy_id');
        $product_id_list = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($mapped_product_qry);
        if ($product_id_list && count($product_id_list) > 0) {
            foreach ($product_id_list as $product) {
                $pro_id_arr[] = $product['id_product'];
            }
        }
        return array(
            'category' => $category_list,
            'product_ids' => $pro_id_arr,
            'category_product' => $category_product,
            'mapped_category' => $mapped_category
        );
    }

    public function getCategoryProduct()
    {
        $mapped_product = array();
        $category_products = array();
        if (Tools::getValue('category') != '' && count(explode(',', Tools::getValue('category'))) > 0) {
            $qry = 'select DISTINCT(cat.id_product) as id_product, pro.name from ' . _DB_PREFIX_ .
                'category_product as cat
				INNER JOIN ' . _DB_PREFIX_ . 'category_lang as cl on (cl.id_category = cat.id_category)
				INNER JOIN ' . _DB_PREFIX_ . 'product_lang as pro on (cat.id_product = pro.id_product)
				where cat.id_category IN (' . pSQL(Tools::getValue('category')) . ') AND
				pro.id_lang=' . (int) $this->context->language->id . ' AND pro.id_shop=' .
                (int) $this->context->shop->id
                . ' AND cl.id_lang = ' . (int) $this->context->language->id . ' AND cl.id_shop = ' .
                (int) $this->context->shop->id;

            $category_products = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($qry);

            $qry = 'Select DISTINCT(id_product) as id_product from ' . _DB_PREFIX_ . 'velsof_return_policy_product
				WHERE id_categories IN (\'' . pSQL(Tools::getValue('category')) . '\') AND return_data_id = ' .
                (int) Tools::getValue('policy_id');
            $mapped_product = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($qry);
        }
        return array(
            'category_product' => $category_products,
            'mapped_products' => $mapped_product);
    }

    public function productPolicyMapping()
    {
        $category_array = array();
        $category_array = explode(',', Tools::getValue('category'));
        $policy_id = Tools::getValue('policy_id');

        $already_mapped = array();
        $already_mapped_category_id = array();

        if (count($category_array) > 0) {
            foreach ($category_array as $id_category) {
                $qry = 'select pl.* from ' . _DB_PREFIX_ . 'velsof_return_policy_product as rpp
                                        INNER JOIN ' . _DB_PREFIX_ .
                    'category_lang as pl on(rpp.id_categories = pl.id_category AND pl.id_lang = ' .
                    (int) $this->context->language->id . ')
                                        where rpp.id_categories = ' . (int) $id_category . ' AND rpp.return_data_id != ' .
                    (int) Tools::getValue('policy_id');
                $is_mapped_with_other = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($qry);
                if ($is_mapped_with_other && count($is_mapped_with_other) > 0) {
                    $already_mapped[] = $is_mapped_with_other[0]['name'];
                    $already_mapped_category_id[] = $is_mapped_with_other[0]['id_category'];
                }
            }

            $delete_old_setting = 'delete from ' . _DB_PREFIX_ .
                'velsof_return_policy_product where return_data_id=' . (int) Tools::getValue('policy_id');
            Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($delete_old_setting);
            foreach ($category_array as $id_category) {
                if (!in_array($id_category, $already_mapped_category_id) && $id_category != 0) {
                    $id_product = 0;
                    $mapping = 'insert into ' . _DB_PREFIX_ . 'velsof_return_policy_product
                                                    values(' . (int) Tools::getValue('policy_id') . ',' . (int) $id_product . ',' .
                        (int) $id_category . ')';
                    Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($mapping);
                }
            }
        }

        $qry_mapped_category = 'select id_categories from ' . _DB_PREFIX_ . 'velsof_return_policy_product '
            . 'where return_data_id ="' . (int) $policy_id . '"';

        $get_mapped_category = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($qry_mapped_category);
        $persist_category = array();
        if ($get_mapped_category != null) {
            foreach ($get_mapped_category as $category) {
                $persist_category[] = $category['id_categories'];
            }
        }
        if (Configuration::get('VELSOF_RETURNMANAGER_CATEGORY')) {
            $cat_data = Tools::unSerialize(Configuration::get('VELSOF_RETURNMANAGER_CATEGORY'));
            $cat_data[$policy_id] = $persist_category;
            Configuration::updateValue('VELSOF_RETURNMANAGER_CATEGORY', serialize($cat_data));
        } else {
            $data = array();
            $data[$policy_id] = $persist_category;
            Configuration::updateValue('VELSOF_RETURNMANAGER_CATEGORY', serialize($data));
        }
        return $already_mapped;
    }

    public function addData()
    {
        $json = array();
        switch (Tools::getValue('type')) {
            case 'policy':
                if (Tools::isSubmit('credit_check')) {
                    $credit_days = Tools::getValue('credit');
                } else {
                    $credit_days = 0;
                }

                if (Tools::isSubmit('refund_check')) {
                    $refund_days = Tools::getValue('refund');
                } else {
                    $refund_days = 0;
                }

                if (Tools::isSubmit('replacement_check')) {
                    $replacement_days = Tools::getValue('replacement');
                } else {
                    $replacement_days = 0;
                }

                if (Tools::isSubmit('policy_action_type') && Tools::getValue('policy_action_type') == 0) {
                    $qry = 'insert into ' . _DB_PREFIX_ . 'velsof_return_data
                        values("","0","0","1","",' . (int) $refund_days . ',' . (int) $credit_days . ',' .
                        (int) $replacement_days . ',"1","1",now(),now())';
                    Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($qry);
                    $id = Db::getInstance()->Insert_ID();
                    foreach (Language::getLanguages(true) as $lang) {
                        $qry = 'insert into ' . _DB_PREFIX_ . 'velsof_return_data_lang values(' . (int) $id . ',' .
                            (int) $this->context->shop->id . ',' . (int) $lang['id_lang'] . ',"'
                            . pSQL(Tools::getValue('policy_new_' . $lang['id_lang'])) . '","' .
                            pSQL(Tools::getValue('policy_new_term_' . $lang['id_lang'])) . '",
                            "' . pSQL(Tools::getValue('rm_credit_text_' . $lang['id_lang'])) . '", "' .
                            pSQL(Tools::getValue('rm_refund_text_' . $lang['id_lang'])) . '",
                            "' . pSQL(Tools::getValue('rm_replacement_text_' . $lang['id_lang'])) . '")';
                        Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($qry);
                    }
                } else {
                    $qry = 'update ' . _DB_PREFIX_ . 'velsof_return_data set date_updated = now(),
                        refund_days=' . (int) $refund_days . ', credit_days=' . (int) $credit_days . ',
                        replacement_days=' . (int) $replacement_days . ' where
                        return_data_id=' . (int) Tools::getValue('policy_action_type');
                    Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($qry);
                    foreach (Language::getLanguages(true) as $lang) {
                        $check_qry = 'select * from ' . _DB_PREFIX_ . 'velsof_return_data_lang
                            where return_data_id=' . (int) Tools::getValue('policy_action_type') . ' and
                            id_lang=' . (int) $lang['id_lang'] . ' and id_shop=' . (int) $this->context->shop->id;

                        if (Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($check_qry)) {
                            $qry = 'update ' . _DB_PREFIX_ . 'velsof_return_data_lang set
                                value="' . pSQL(Tools::getValue('policy_new_' . $lang['id_lang'])) . '",
                                terms="' . pSQL(Tools::getValue('policy_new_term_' . $lang['id_lang'])) . '",
                                credit_message = "' . pSQL(Tools::getValue('rm_credit_text_' . $lang['id_lang'])) . '",
                                refund_message = "' . pSQL(Tools::getValue('rm_refund_text_' . $lang['id_lang'])) . '",
                                replacement_message = "' . pSQL(Tools::getValue('rm_replacement_text_' .
                                        $lang['id_lang'])) . '"
                                where return_data_id=' . (int) Tools::getValue('policy_action_type') . ' and
                                id_lang=' . (int) $lang['id_lang'] . ' and id_shop=' . (int) $this->context->shop->id;
                        } else {
                            $qry = 'insert into ' . _DB_PREFIX_ . 'velsof_return_data_lang values(' .
                                (int) Tools::getValue('policy_action_type') . ','
                                . (int) $this->context->shop->id . ',' . (int) $lang['id_lang'] . ',"'
                                . pSQL(Tools::getValue('policy_new_' . $lang['id_lang'])) . '","' .
                                pSQL(Tools::getValue('policy_new_term_' . $lang['id_lang'])) . '",
                                    "' . pSQL(Tools::getValue('rm_credit_text_' . $lang['id_lang'])) . '", "' .
                                pSQL(Tools::getValue('rm_refund_text_' . $lang['id_lang'])) . '",
                                    "' . pSQL(Tools::getValue('rm_replacement_text_' . $lang['id_lang'])) . '")';
                            Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($qry);
                        }
                        Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($qry);
                    }
                }

                $policy_detail = $this->select(Tools::getValue('type'));
                $this->smarty->assign('policy', $policy_detail);
                $json['html'] = $this->display(__FILE__, 'views/templates/admin/refresh_policy.tpl');
                $json['policy_data'] = $policy_detail;
                $velsof_data = Tools::unSerialize(Configuration::get('VELSOF_RETURNMANAGER'));
                if (isset($velsof_data['policy']['default'])) {
                    $json['default_policy'] = $velsof_data['policy']['default'];
                } else {
                    $json['default_policy'] = 0;
                }
                echo Tools::jsonEncode($json);
                break;
            case 'reason':
                if (Tools::isSubmit('reason_action_type') && Tools::getValue('reason_action_type') == 0) {
                    $inserting_reason = 'insert into ' . _DB_PREFIX_ . 'velsof_return_data
                        values("","1","0","0","' . pSQL(Tools::getValue('charges')) . '","","","","1","1",now(),now())';
                    Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($inserting_reason);
                    $reason_id = Db::getInstance()->Insert_ID();
                    foreach (Language::getLanguages(true) as $lang) {
                        $inserting_reason_lang = 'insert into ' . _DB_PREFIX_ . 'velsof_return_data_lang
                                values(' . (int) $reason_id . ',' . (int) $this->context->shop->id . ','
                            . (int) $lang['id_lang'] . ',"' . pSQL(Tools::getValue('reason_new_' .
                                    $lang['id_lang'])) . '","","","","")';
                        Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($inserting_reason_lang);
                    }
                } else {
                    $qry = 'update ' . _DB_PREFIX_ . 'velsof_return_data set whopayshipping="' .
                        pSQL(Tools::getValue('charges')) . '", date_updated = now()
                        where return_data_id=' . (int) Tools::getValue('reason_action_type');
                    Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($qry);
                    foreach (Language::getLanguages(true) as $lang) {
                        $check_qry = 'select * from ' . _DB_PREFIX_ . 'velsof_return_data_lang
                            where return_data_id=' . (int) Tools::getValue('reason_action_type') . ' and
                            id_lang=' . (int) $lang['id_lang'] . ' and id_shop=' . (int) $this->context->shop->id;

                        if (Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($check_qry)) {
                            $qry = 'update ' . _DB_PREFIX_ . 'velsof_return_data_lang set
                                value="' . pSQL(Tools::getValue('reason_new_' . $lang['id_lang'])) . '" where
                                return_data_id=' . (int) Tools::getValue('reason_action_type') . ' and
                                id_lang=' . (int) $lang['id_lang'] . ' and id_shop=' . (int) $this->context->shop->id;
                        } else {
                            $qry = 'insert into ' . _DB_PREFIX_ . 'velsof_return_data_lang
                                values(' . (int) Tools::getValue('reason_action_type') . ',' .
                                (int) $this->context->shop->id . ','
                                . (int) $lang['id_lang'] . ',"' .
                                pSQL(Tools::getValue('reason_new_' . $lang['id_lang'])) . '","","","","")';
                        }
                        Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($qry);
                    }
                }

                $reason_detail = $this->select(Tools::getValue('type'));
                $this->smarty->assign('reasons', $reason_detail);
                echo $this->display(__FILE__, 'views/templates/admin/refresh_reason.tpl');
                break;
            case 'status':
                if (Tools::isSubmit('status_action_type') && Tools::getValue('status_action_type') == 0) {
                    $qry = 'insert into ' . _DB_PREFIX_ .
                        'velsof_return_data values("","0","1","0","","","","","1","1",now(),now())';
                    Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($qry);
                    $id = Db::getInstance()->Insert_ID();
                    foreach (Language::getLanguages(true) as $lang) {
                        $qry = 'insert into ' . _DB_PREFIX_ . 'velsof_return_data_lang
                            values(' . (int) $id . ',' . (int) $this->context->shop->id . ',' . (int) $lang['id_lang'] .
                            ',
                            "' . pSQL(Tools::getValue('status_new_' . $lang['id_lang'])) . '","","","","")';
                        Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($qry);
                    }
                } else {
                    $qry = 'update ' . _DB_PREFIX_ . 'velsof_return_data set date_updated = now()  where
                        return_data_id=' . (int) Tools::getValue('status_action_type');
                    Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($qry);
                    foreach (Language::getLanguages(true) as $lang) {
                        $check_qry = 'select * from ' . _DB_PREFIX_ . 'velsof_return_data_lang
                            where return_data_id=' . (int) Tools::getValue('status_action_type') . ' and
                            id_lang=' . (int) $lang['id_lang'] . ' and id_shop=' . (int) $this->context->shop->id;

                        if (Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($check_qry)) {
                            $qry = 'update ' . _DB_PREFIX_ . 'velsof_return_data_lang set
                                value="' . pSQL(Tools::getValue('status_new_' . $lang['id_lang'])) . '" where
                                return_data_id=' . (int) Tools::getValue('status_action_type') . ' and
                                id_lang=' . (int) $lang['id_lang'] . ' and id_shop=' . (int) $this->context->shop->id;
                        } else {
                            $qry = 'insert into ' . _DB_PREFIX_ . 'velsof_return_data_lang
                            values(' . (int) Tools::getValue('status_action_type') . ',' .
                                (int) $this->context->shop->id . ',' . (int) $lang['id_lang'] . ',
                            "' . pSQL(Tools::getValue('status_new_' . $lang['id_lang'])) . '","","","","")';
                        }
                        Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($qry);
                    }
                }
                $status_detail = $this->select(Tools::getValue('type'));
                $this->smarty->assign('status', $status_detail);
                echo $this->display(__FILE__, 'views/templates/admin/refresh_status.tpl');
                break;
            case 'address':
                if (Tools::isSubmit('address_action_type') && Tools::getValue('address_action_type') == 0) {
                    $qry = 'insert into ' . _DB_PREFIX_ . 'velsof_rm_address(id_country,id_state,title,address1,address2,postcode,city,active) values (' . (int) Tools::getValue('address_new_country') . ',' . (int) Tools::getValue('address_new_state') . ',"' . pSQL(Tools::getValue('address_new_title')). '","' . pSQL(Tools::getValue('address_new_line1')). '","' .pSQL(Tools::getValue('address_new_line2')) .'","' . pSQL(Tools::getValue('address_new_zipcode')). '","' .pSQL(Tools::getValue('address_new_city')).'",1)';
                    Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($qry);
                } else {
                    $qry = 'update ' . _DB_PREFIX_ . 'velsof_rm_address set id_country = '.(int) Tools::getValue('address_new_country').', id_state='.(int) Tools::getValue('address_new_state').',title="'.pSQL(Tools::getValue('address_new_title')).'",address1 ="'.pSQL(Tools::getValue('address_new_line1')).'",address2 = "'.pSQL(Tools::getValue('address_new_line2')).'",postcode = "'.pSQL(Tools::getValue('address_new_zipcode')).'", city = "'.(Tools::getValue('address_new_city')).'" where id_address=' . (int) Tools::getValue('address_new_id');
                    Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($qry);
                }
                $address_detail = $this->select(Tools::getValue('type'));
                
                $this->smarty->assign('address', $address_detail);
                echo $this->display(__FILE__, 'views/templates/admin/refresh_address.tpl');
                break;
        }
    }

    public function getData()
    {
       
        switch (Tools::getValue('type')) {
            case 'policy':
                $arr = array();
                $qry = 'select rdl.value, rdl.terms, rdl.credit_message, rdl.refund_message,
                    rdl.replacement_message, rdl.id_lang,
                    rd.refund_days, rd.credit_days, rd.replacement_days from ' . _DB_PREFIX_
                    . 'velsof_return_data_lang as rdl
                    INNER JOIN ' . _DB_PREFIX_ . 'velsof_return_data as rd on (rd.return_data_id = rdl.return_data_id)
                    WHERE rd.return_data_id = ' . (int) Tools::getValue('policy_id');

                $result = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($qry);

                if ($result && count($result) > 0) {
                    foreach ($result as $rs) {
                        $arr['policy_title'][] = array(
                            'id_lang' => $rs['id_lang'],
                            'text' => $rs['value']);
                        $arr['policy_terms'][] = array(
                            'id_lang' => $rs['id_lang'],
                            'text' => $rs['terms']);
                        $arr['credit_texts'][] = array(
                            'id_lang' => $rs['id_lang'],
                            'text' => $rs['credit_message']);
                        $arr['refund_texts'][] = array(
                            'id_lang' => $rs['id_lang'],
                            'text' => $rs['refund_message']);
                        $arr['replacement_texts'][] = array(
                            'id_lang' => $rs['id_lang'],
                            'text' => $rs['replacement_message']
                        );
                    }
                    $arr['credit_days'] = $rs['credit_days'];
                    $arr['refund_days'] = $rs['refund_days'];
                    $arr['replacement_days'] = $rs['replacement_days'];
                }
                return $arr;
            case 'reason':
                $arr = array();
                $qry = 'select rdl.value, rdl.id_lang, rd.whopayshipping from ' . _DB_PREFIX_ .
                    'velsof_return_data_lang as rdl
                    INNER JOIN ' . _DB_PREFIX_ .
                    'velsof_return_data as rd on (rd.return_data_id = rdl.return_data_id)
                    WHERE rd.return_data_id = ' . (int) Tools::getValue('return_id');

                $select_all_reason = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($qry);
                if ($select_all_reason && count($select_all_reason) > 0) {
                    foreach ($select_all_reason as $reason) {
                        $arr['reason_text'][] = array(
                            'id_lang' => $reason['id_lang'],
                            'text' => $reason['value']);
                        $arr['charges'] = $reason['whopayshipping'];
                    }
                }
                return $arr;
            case 'status':
                $arr = array();
                $select_status = 'select value,id_lang from ' . _DB_PREFIX_ .
                    'velsof_return_data_lang where return_data_id=' . (int) Tools::getValue('status_id');
                $select_all_status = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($select_status);

                if ($select_all_status && count($select_all_status) > 0) {
                    foreach ($select_all_status as $stat) {
                        $arr['status_text'][] = array(
                            'id_lang' => $stat['id_lang'],
                            'text' => $stat['value']);
                    }
                }
                return $arr;
            case 'address':
                $arr = array();
                $select_address = 'select * from ' . _DB_PREFIX_ .
                    'velsof_rm_address where id_address=' . (int) Tools::getValue('address_id');
                $select_all_address = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($select_address);
                if ($select_all_address && count($select_all_address) > 0) {
                    foreach ($select_all_address as $stat) {
                        $arr['address_text'][] = array(
                            'state' => $stat['id_state'],
                            'title' => $stat['title'],
                            'id_address' => $stat['id_address'],
                            'id' =>$stat['id_address'],
                            'line1' => $stat['address1'],
                            'line2' => $stat['address2'],
                            'city' => $stat['city'],
                            'country' =>$stat['id_country'],
                            'zipcode' => $stat['postcode']
                            );
                    }
                }
                return $arr;
        }
    }

    public function delete()
    {
        $delete = 'update ' . _DB_PREFIX_ .
            "velsof_return_data set active='0' where return_data_id=" . (int) Tools::getValue('id');
        Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($delete);
        $remove_mapping = 'delete from ' . _DB_PREFIX_ .
            'velsof_return_policy_product where return_data_id = ' . (int) Tools::getValue('id');
        Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($remove_mapping);
        $json = array();
        switch (Tools::getValue('type')) {
            case 'policy':
                $policy_detail = $this->select(Tools::getValue('type'));
                $this->smarty->assign('policy', $policy_detail);
                $json['html'] = $this->display(__FILE__, 'views/templates/admin/refresh_policy.tpl');
                $json['policy_data'] = $policy_detail;

                $cat_data = Tools::unSerialize(Configuration::get('VELSOF_RETURNMANAGER_CATEGORY'));
                unset($cat_data[(int) Tools::getValue('id')]);
                Configuration::updateValue('VELSOF_RETURNMANAGER_CATEGORY', serialize($cat_data));

                $velsof_data = Tools::unSerialize(Configuration::get('VELSOF_RETURNMANAGER'));
                if (isset($velsof_data['policy']['default'])) {
                    $json['default_policy'] = $velsof_data['policy']['default'];
                } else {
                    $json['default_policy'] = 0;
                }
                echo Tools::jsonEncode($json);
                break;
            case 'reason':
                $reason_detail = $this->select(Tools::getValue('type'));
                $this->smarty->assign('reasons', $reason_detail);
                $json['html'] = $this->display(__FILE__, 'views/templates/admin/refresh_reason.tpl');
                echo Tools::jsonEncode($json);
                break;
            case 'status':
                $status_detail = $this->select(Tools::getValue('type'));
                $this->smarty->assign('status', $status_detail);
                $json['html'] = $this->display(__FILE__, 'views/templates/admin/refresh_status.tpl');
                echo Tools::jsonEncode($json);
                break;
        }
    }
    public function changeAddressStatus()
    {
        $json=array();
        $status = 0;
        $status = 1- (int)Tools::getValue('status');
        $delete = 'update ' . _DB_PREFIX_ .
        'velsof_rm_address SET active='.(int)$status.' where id_address=' . (int) Tools::getValue('id');
        Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($delete);
        $address_detail = $this->select('address');
        $this->smarty->assign('address', $address_detail);
        $json['html'] = $this->display(__FILE__, 'views/templates/admin/refresh_address.tpl');
        echo Tools::jsonEncode($json);
    }
    public function getStateList()
    {
        $option='';
        $state_query = 'Select id_state,name from '. _DB_PREFIX_ . 'state where id_country = '.(int) Tools::getValue('country_id');
        $state_list = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($state_query);
        if (count($state_list) > 0) {
            foreach ($state_list as $state) {
                $option .= '<option value = "'.$state['id_state'].'">'.htmlentities($state['name'], ENT_COMPAT, 'UTF-8').'</option>';
            }
        }
        echo $option;
    }

    public function getPolicy()
    {
        $get_policy_qry = 'select return_data_id from ' . _DB_PREFIX_ .
            'velsof_return_data where policy="1" and active="1"';
        $policy_data = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($get_policy_qry);
        if ($policy_data) {
            return true;
        } else {
            return false;
        }
    }

    /*
     * This function is used just to include all the menu texts to translations files.
     */

    private function menuTranslationsIncludeFunction()
    {
        $this->l('Credit');
        $this->l('Refund');
        $this->l('Replacement');
        $this->l('credit');
        $this->l('refund');
        $this->l('replacement');
    }

    public function hookDisplayAdminProductsExtra($params)
    {
        unset($params);
        $velsof_data = Tools::unSerialize(Configuration::get('VELSOF_RETURNMANAGER'));
        if (isset($velsof_data['enable']) && $velsof_data['enable'] == 1) {
            if (Tools::getValue('id_product')) {
                $id_product = Tools::getValue('id_product');
                $get_policy_qry = 'select distinct(return_data_id) from ' . _DB_PREFIX_ . 'velsof_return_policy_product
					where id_product="' . (int) $id_product . '"';
                $policy_data = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($get_policy_qry);
                if ($policy_data) {
                    $policy = $policy_data[0]['return_data_id'];
                    $this->context->smarty->assign('velsof_return_policy', $policy);
                }
            }
            $velsof_data = Tools::unSerialize(Configuration::get('VELSOF_RETURNMANAGER'));
            if (isset($velsof_data['policy']['default']) && ($velsof_data['policy']['default'] != 0)) {
                $this->context->smarty->assign('velsof_default_return_policy', $velsof_data['policy']['default']);
            }

            $policy_detail = $this->select('policy');
            $this->context->smarty->assign('policy', $policy_detail);
            return $this->display(__FILE__, 'views/templates/admin/admin_product_returnmanager.tpl');
        } else {
            return $this->displayError($this->l('Please enable Returns Manager first.'));
        }
    }

    public function hookActionProductSave($params)
    {
        $velsof_data = Tools::unSerialize(Configuration::get('VELSOF_RETURNMANAGER'));
        if (isset($velsof_data['enable']) && $velsof_data['enable'] == 1) {
            $id_product = $params['id_product'];
            $cat_id = Tools::getValue('id_category_default');
            $policy_id = Tools::getValue('velsof_return_policy');
            $get_policy_qry = 'select distinct(return_data_id) from ' . _DB_PREFIX_ . 'velsof_return_policy_product
				where id_product="' . (int) $id_product . '"';
            $policy_data = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($get_policy_qry);
            if ($policy_data) {
                $update_policy = 'update ' . _DB_PREFIX_ . 'velsof_return_policy_product set
					return_data_id="' . (int) $policy_id . '" where id_product="' . (int) $id_product . '"';
                Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($update_policy);
            } else {
                $mapping = 'insert into ' . _DB_PREFIX_ . 'velsof_return_policy_product
				values(' . (int) $policy_id . ',' . (int) $id_product . ',' . (int) $cat_id . ')';
                Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($mapping);
            }
        }
    }
}

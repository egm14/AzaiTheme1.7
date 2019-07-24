<?php
/**
 * AdminQuotationsProController.
 *
 * @author    Roja45
 * @copyright 2016 Roja45
 * @license   license.txt
 * @category  AdminQuotationsProController
 *
 *
 * 2016 ROJA45 - All rights reserved.
 *
 * DISCLAIMER
 * Changing this file will render any support provided by us null and void.
 */

/**
 * AdminQuotationsProController.
 *
 * @author    Roja45
 * @copyright 2016 Roja45
 * @license   license.txt
 * @category  Class
 *
 *
 * 2016 ROJA45 - All rights reserved.
 *
 * DISCLAIMER
 * Changing this file will render any support provided by us null and void.
 */

class AdminQuotationsProController extends ModuleAdminController
{
    /**
     * Constructor
     */
    public function __construct()
    {
        parent::__construct();
        $this->context = Context::getContext();
        $this->override_folder = 'roja45quotationspro/';
        $this->bootstrap = true;
        $this->table = 'roja45_quotationspro';
        $this->identifier = 'id_roja45_quotation';
        $this->submit_action = 'submitAdd'.$this->table;
        $this->show_cancel_button = true;
        $this->className = 'RojaQuotation';
        $this->deleted = false;
        $this->colorOnBackground = false;
        $this->allow_export = true;
        $this->bulk_actions = array(
            'delete' => array(
                'text' => $this->l('Delete selected'),
                'confirm' => $this->l('Delete selected items?')
            ),
            'delete_permanently' => array(
                'text' => $this->l('Delete permanently'),
                'confirm' => $this->l('Delete selected items permanently?')
            )
        );
        //$this->multishop_context = Shop::CONTEXT_ALL;

        $status = QuotationStatus::getQuotationStates($this->context->language->id);
        $states_array = array();
        foreach ($status as $row) {
            $states_array[$row['id_roja45_quotation_status']] = $row['status'];
        }

        $this->_defaultOrderBy = $this->identifier = 'id_roja45_quotation';
        $this->list_id = 'id_roja45_quotation';
        $this->deleted = false;
        $this->_orderBy = 'date_add';
        $this->_orderWay = 'DESC';

        //$id_shop = Shop::isFeatureActive() && Shop::getContext() == Shop::CONTEXT_SHOP ?
        //    (int)$this->context->shop->id : Configuration::get('PS_SHOP_DEFAULT');
        //$this->_select .= 'shop.`name` AS `shop_name`, a.`id_shop_default`, ';
        //$this->_join = ' LEFT JOIN `'._DB_PREFIX_.'shop` shop ON (shop.id_shop = '.$id_shop.')';
        $this->_select .= 'employee.`email` as owner';
        $this->_join = ' LEFT JOIN `'._DB_PREFIX_.'employee` employee ON (employee.id_employee = a.id_employee)';
        $this->_where = 'AND a.is_template=0';

        $this->addRowAction('edit');
        $this->addRowAction('delete');

        $this->shopLinkType = 'shop';

        $this->fields_list = array(
            'code' => array(
                'title' => $this->l('Status'),
                'width' => 'auto',
                'color' => 'color',
                'type' => 'select',
                'list' => $states_array,
                'filter_key' => 'a!id_roja45_quotation_status',
                'filter_type' => 'int',
                'order_key' => 'id_roja45_quotation_status',
            ),
            'reference' => array(
                'title' => $this->l('Reference #'),
                'width' => 'auto',
            ),
            'firstname' => array(
                'title' => $this->l('Name'),
                'width' => 'auto',
            ),
            'lastname' => array(
                'title' => $this->l('Surname'),
                'width' => 'auto',
            ),
            'email' => array(
                'title' => $this->l('Email'),
                'width' => 'auto',
                'filter_key' => 'a!email',
                'filter_type' => 'string',
            ),
            'total' => array(
                'title' => $this->l('Total'),
                'width' => 'auto',
                'type' => 'price',
            ),
            'date_add' => array(
                'title' => $this->l('Received'),
                'width' => 'auto',
                'orderby' => true,
                'havingFilter' => true,
                'type' => 'datetime',
            ),
            'date_upd' => array(
                'title' => $this->l('Last Update'),
                'width' => 'auto',
                'orderby' => true,
                'havingFilter' => true,
                'type' => 'datetime',
            ),
            'lang' => array(
                'title' => $this->l('Language'),
                'width' => 'auto',
                'havingFilter' => false,
                'orderby' => false,
                'search' => false,
            ),
            'owner' => array(
                'title' => $this->l('Owner'),
                'width' => 'auto',
                'filter_key' => 'employee!email',
                'filter_type' => 'string',
            ),
            'quotesent_text' => array(
                'title' => $this->l('Quote Sent'),
                'width' => 'auto',
                'color' => 'color_sent',
                'tmpTableFilter' => true,
                'orderby' => false,
                'class' => 'fixed-width-xs',
                'havingFilter' => false,
                'orderby' => false,
                'search' => false,
            ),
            'hasorder_text' => array(
                'title' => $this->l('Order Completed'),
                'width' => 'auto',
                'color' => 'color_order',
                'tmpTableFilter' => true,
                'orderby' => false,
                'class' => 'fixed-width-xs',
                'havingFilter' => false,
                'orderby' => false,
                'search' => false,
            ),
        );

        $this->tabAccess = Profile::getProfileAccess(
            $this->context->employee->id_profile,
            Tab::getIdFromClassName('AdminQuotationsPro')
        );
    }

    /**
     * Initialise
     */
    public function init()
    {
        if (Tools::isSubmit('addroja45_quotationspro')) {
            $this->display = 'add';
        } elseif (Tools::isSubmit('submiteditroja45_quotationspro')) {
            $this->display = 'edit';
        } elseif (Tools::isSubmit('viewroja45_quotationspro')) {
            $this->display = 'view';
        } elseif (Tools::isSubmit('deleteroja45_quotationspro')) {
            $this->display = 'delete';
        } elseif (Tools::isSubmit('action')=='submitNewCustomerOrder') {
            $this->display = 'view';
        }
        return parent::init();
    }

    public function setMedia($isNewTheme = false)
    {
        parent::setMedia($isNewTheme);

        if ($this->display!=null && $this->tabAccess[$this->display]) {
            $this->addJqueryPlugin('autocomplete');
            $this->context->controller->addJS(
                _PS_MODULE_DIR_ . $this->module->name . '/views/js/roja45quotationsadmin.js'
            );
            $this->context->controller->addJS(__PS_BASE_URI__ . 'js/tiny_mce/tiny_mce.js');
            $this->context->controller->addJS(__PS_BASE_URI__ . 'js/admin/tinymce.inc.js');
            $this->context->controller->addCss(
                _PS_MODULE_DIR_ . $this->module->name . '/vendor/jquery-confirm/jquery-confirm.min.css'
            );
            $this->context->controller->addJS(
                _PS_MODULE_DIR_ . $this->module->name . '/vendor/jquery-confirm/jquery-confirm.min.js'
            );
            $this->context->controller->addJqueryUI('ui.dialog');
            $this->context->controller->addCSS(
                _PS_MODULE_DIR_ . $this->module->name .  '/views/css/roja45quotationsproadmin.css'
            );
        }
    }

    public function postProcess()
    {
        if (Tools::isSubmit('submitedit' . $this->table)) {
            $quotation = $this->processSubmitEditQuotation($this->loadObject(true));
            $link = 'index.php?controller=AdminQuotationsPro&viewroja45_quotationspro&id_roja45_quotation=' .
                $quotation->id .
                '&token=' .
                $this->token;
            Tools::redirectAdmin($link);
        } elseif (Tools::isSubmit('delete' . $this->table)) {
            $this->markDeleted(Tools::getValue('id_roja45_quotation'));
            Tools::redirectAdmin(Context::getContext()->link->getAdminLink(
                'AdminQuotationsPro',
                true
            ));
        } elseif (Tools::isSubmit('submitBulkdelete' . $this->table)) {
            foreach (Tools::getValue($this->identifier . 'Box') as $selection) {
                $this->markDeleted((int)$selection);
            }
            Tools::redirectAdmin(Context::getContext()->link->getAdminLink(
                'AdminQuotationsPro',
                true
            ));
        } elseif (Tools::isSubmit('submitBulkdelete_permanently' . $this->table)) {
            foreach (Tools::getValue($this->identifier . 'Box') as $selection) {
                $quotation = new RojaQuotation((int) $selection);
                if (Validate::isLoadedObject($quotation)) {
                    $quotation->delete();
                }
            }
            Tools::redirectAdmin(Context::getContext()->link->getAdminLink(
                'AdminQuotationsPro',
                true
            ));
        } elseif (Tools::isSubmit('sendMessageToCustomer')) {
            $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));
            if (!Validate::isLoadedObject($quotation)) {
                $this->errors[] = $this->l('The quotation could not be loaded.');
            }

            $message_content = trim(Tools::getValue('response_content'));
            if (!Tools::strlen($message_content) > 0) {
                $this->errors[] = $this->l('You must provide a message to send.');
            }

            if (!count($this->errors)) {
                $validationErrors = array();
                try {
                    $contacts = Contact::getContacts($this->context->language->id);
                    foreach ($contacts as $contact) {
                        if (strpos(Configuration::get('ROJA45_QUOTATIONSPRO_EMAIL'), $contact['email']) !== false) {
                            $id_contact = $contact['id_contact'];
                        }
                    }

                    if (!isset($id_contact)) { // if not use the default contact category
                        $id_contact = $contacts[0]['id_contact'];
                    }

                    if ($quotation_message = $quotation->getQuotationMessageList()) {
                        $ct = new CustomerThread($quotation_message[0]['id_customer_thread']);
                    }

                    if (!$ct->id) {
                        $ct = new CustomerThread();
                        if (isset($quotation->id_customer)) { //if mail is owned by a customer assign to him
                            $ct->id_customer = $quotation->id_customer;
                        }
                        $ct->email = $quotation->email;
                        $ct->id_contact = $id_contact;
                        $ct->id_lang = (int)$quotation->id_lang;
                        $ct->id_shop = $this->context->shop->id;
                        $ct->status = 'open';
                        $ct->token = $quotation->reference;
                        $ct->add();

                        $quotation_message = new QuotationMessage();
                        $quotation_message->id_roja45_quotation = (int)$quotation->id_roja45_quotation;
                        $quotation_message->id_customer_thread = (int)$ct->id;
                        if (!($quotation_message->add())) {
                            $validationErrors[] = $this->l('Unable to create quotation message entry.');
                            die(Tools::jsonEncode(array(
                                'result' => false,
                                'errors' => $validationErrors,
                            )));
                        }
                    }

                    $cm = new CustomerMessage();
                    $cm->id_customer_thread = $ct->id;
                    $cm->message = $message_content;
                    $cm->add();

                    $params = array(
                        '{content}' => $message_content,
                    );
                    $sent = Mail::Send(
                        (int)$this->context->language->id,
                        'roja45quotationresponse',
                        sprintf(
                            Mail::l(
                                'Your quotation [%1$s] : [#ct%2$s] : [#tc%3$s]',
                                (int)$this->context->language->id
                            ),
                            $this->reference,
                            $ct->id,
                            $this->reference
                        ),
                        $params,
                        $quotation->email,
                        $quotation->firstname . ' ' . $quotation->lastname,
                        Configuration::get('ROJA45_QUOTATIONSPRO_EMAIL'),
                        Configuration::get('ROJA45_QUOTATIONSPRO_CONTACT_NAME'),
                        null,
                        null,
                        _PS_MODULE_DIR_ . 'roja45quotationspro/mails/',
                        false,
                        null,
                        Configuration::get('ROJA45_QUOTATIONSPRO_CONTACT_BCC')
                    );

                    if ($sent) {
                        //$quotation->quote_sent = true;
                        //$quotation->setStatus(QuotationStatus::$SENT);
                        //$res = $quotation->update();
                    } else {
                        $cm->delete();
                        $this->errors[] = $this->l(
                            'Unable to send email to customer, please try again.  ' .
                            'If the problem persists, please contact your system administrator.'
                        );
                    }
                } catch (Exception $e) {
                    $this->errors[] = $this->l(
                        'A fatal error has occurred.  ' .
                        'If the problem persists, please contact your system administrator.'
                    );
                    $this->errors[] = $e->getMessage();
                }
            }

            if (!count($this->errors)) {
                $link = 'index.php?controller=AdminQuotationsPro&viewroja45_quotationspro&id_roja45_quotation=' .
                    $quotation->id .
                    '&token=' .
                    $this->token;
                Tools::redirectAdmin($link);
            }
        } elseif (Tools::isSubmit('raiseOrder')) {
            Tools::redirectAdmin($this->context->link->getAdminLink('AdminOrders') . '&addorder');
        } else {
            return parent::postProcess();
        }
    }

    public function getList(
        $id_lang,
        $orderBy = null,
        $orderWay = null,
        $start = 0,
        $limit = null,
        $id_lang_shop = null
    ) {
        parent::getList($id_lang, $orderBy, $orderWay, $start, $limit, $id_lang_shop);

        foreach ($this->_list as &$list_item) {
            $quotation = new RojaQuotation($list_item['id_roja45_quotation']);
            $currency = new Currency($quotation->id_currency);
            $list_item['currency'] = $currency->iso_code;

            $display_tax = 0;
            if (!empty($quotation->id_customer)) {
                $customer = new Customer($quotation->id_customer);
                if (Validate::isLoadedObject($customer)) {
                    $priceDisplay = Product::getTaxCalculationMethod($quotation->id_customer);
                    if (!$priceDisplay || $priceDisplay == 2) {
                        $display_tax = 1;
                    }
                }
            }
            //$list_item['email'] = $list_item['email'];
            $list_item['total'] = Tools::displayPrice($quotation->getQuotationTotal((int)$display_tax));
            if ($list_item['id_employee'] > 0) {
                $employee = new Employee($list_item['id_employee']);
                //$list_item['owner'] = $employee->firstname . ' ' . $employee->lastname;
                $list_item['owner'] = $employee->email;
            }

            if ($list_item['id_lang'] > 0) {
                $language = new Language($list_item['id_lang'], $id_lang);
                $list_item['lang'] = $language->name;
            }

            $id_status = $list_item['id_roja45_quotation_status'];
            $status = new QuotationStatus($id_status, $this->context->language->id);

            if ($status->id == (int) Configuration::get('ROJA45_QUOTATIONSPRO_STATUS_DLTD')) {
                $list_item['class'] = 'deleted';
            }

            $list_item['color'] = $status->color;
            $list_item['code'] = $status->code;

            if ($list_item['quote_sent'] > 0) {
                $list_item['quotesent_text'] = 'YES';
                $list_item['color_sent'] = '#32CD32';
            } else {
                $list_item['quotesent_text'] = 'NO';
                $list_item['color_sent'] = '#FF0000';
            }

            if ($list_item['id_cart'] > 0) {
                $list_item['incart_text'] = 'YES';
                $list_item['color_cart'] = '#32CD32';
            } else {
                $list_item['incart_text'] = 'NO';
                $list_item['color_cart'] = '#FF0000';
            }

            if ($list_item['id_order'] > 0) {
                $list_item['hasorder_text'] = 'YES';
                $list_item['color_order'] = '#32CD32';
            } else {
                $list_item['hasorder_text'] = 'NO';
                $list_item['color_order'] = '#FF0000';
            }
        }
    }

    public function renderView()
    {
        if (!($quotation = $this->loadObject(true))) {
            return;
        }
        return $this->buildForm($quotation);
    }

    public function renderForm()
    {
        $quotation = $this->loadObject(true);
        if (!Validate::isLoadedObject($quotation)) {
            $id_country = (int) $this->context->country->id;
            $quotation = new RojaQuotation();
            $quotation->id_lang = (int) $this->context->language->id;
            $quotation->id_shop = (int) $this->context->shop->id;
            $quotation->id_currency = (int) $this->context->currency->id;
            $quotation->id_country = $id_country;
            $quotation->id_employee = $this->context->employee->id;
            $quotation->id_customer = 0;
            $quotation->valid_days = Configuration::get('ROJA45_QUOTATIONSPRO_QUOTE_VALID_DAYS');
            $quotation->form_data = '';

            $priceDisplay = Product::getTaxCalculationMethod((int)$quotation->id_customer);
            $quotation->calculate_taxes = 0;
            if (!$priceDisplay || $priceDisplay == 2) {
                $quotation->calculate_taxes = 1;
            }
            if (!$quotation->reference) {
                $quotation->reference = Tools::strtoupper(Tools::passwdGen(9, 'NO_NUMERIC'));
            }
            $quotation->add();
            $quotation->setStatus(QuotationStatus::$NWQT);
        }

        return $this->buildForm($quotation);
    }

    public function initPageHeaderToolbar()
    {
        parent::initPageHeaderToolbar();
        if (empty($this->display)) {
            $this->page_header_toolbar_btn['new_quotation'] = array(
                'href' => self::$currentIndex.'&add'.$this->table.'&token='.$this->token,
                'desc' => $this->l('New Quotation', null, null, false),
                'icon' => 'process-icon-new'
            );
        }
    }

    public function initToolbarTitle()
    {
        $this->toolbar_title = is_array($this->breadcrumbs) ?
            array_unique($this->breadcrumbs) : array($this->breadcrumbs);
        /** @var RojaQuotation $quotation */
        $quotation = $this->loadObject(true);

        switch ($this->display) {
            case 'edit':
                $this->toolbar_title[] = $this->l('Edit Quotation: ') . $quotation->reference;
                break;
            case 'add':
                $this->toolbar_title[] = $this->l('Add new quote', null, null, false);
                break;
            case 'view':
                $this->toolbar_title[] = $this->l('View Quotation: ') . $quotation->reference;
                break;
            default:
                $this->toolbar_title[] = $this->l('Quotations');
        }

        if ($filter = $this->addFiltersToBreadcrumbs()) {
            $this->toolbar_title[] = $filter;
        }
    }

    public function initTabModuleList()
    {
        parent::initTabModuleList();
    }

    public function addToolBarModulesListButton()
    {
        parent::addToolBarModulesListButton();
    }

    protected function renderNewQuotationForm()
    {
        if (!($this->loadObject(true))) {
            return;
        }

        $form_config = $this->module->getForm();
        $form = $this->buildFormComponents($form_config);
        // TODO only do this in screen where there is an add to cart button.
        //$this->id_country = (int)Tools::getCountry();

        $this->smarty->assign(
            array(
                'id_language' => $this->context->language->id,
                'form' => $form,
                'columns' => $form_config['cols'],
                'enable_captcha' => 0,
                'col_width' => 12 / $form_config['cols'],
                // 'sl_country' => (int)$this->id_country,
                'enabled_products' => 0,
            )
        );
        $html = parent::renderForm();
        $html .= $this->display(__FILE__, 'displayFooter.tpl', 'roja45quotationspro-footer');

        return $html;
    }

    protected function renderQuotationForm()
    {
        if (!($this->loadObject(true))) {
            return;
        }

        return parent::renderForm();
    }

    protected function filterToField($key, $filter)
    {
        if ($this->table == 'roja45_quotation') {
            $this->initList();
        }

        return parent::filterToField($key, $filter);
    }

    protected function getFieldsValues()
    {
        return array (
            'ROJA45_QUOTATIONSPRO_USE_CS' => Tools::getValue(
                'ROJA45_QUOTATIONSPRO_USE_CS',
                Configuration::get('ROJA45_QUOTATIONSPRO_USE_CS')
            ),
        );
    }

    public function processDownloadPDFQuotation()
    {
        $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));
        $quotation->generateQuotationPDF(true, $quotation->calculate_taxes);
        exit;
    }

    public function processSubmitEditQuotation($quotation)
    {
        $mysql_date_now = date('Y-m-d H:i:s');
        $id_country = (int) Tools::getValue('tax_country');
        if (!$id_status = Tools::getValue('quotation_status')) {
            $sql = '
            SELECT qs.`id_roja45_quotation_status`
            FROM `'._DB_PREFIX_.'roja45_quotationspro_status` qs
            WHERE qs.`code` = "'.pSQL(QuotationStatus::$NWQT).'"';
            $id_status = Db::getInstance(_PS_USE_SQL_SLAVE_)->getvalue($sql);
        }

        $quotation->id_lang = (int) Tools::getValue('quote_language');
        $quotation->id_shop = (int) $this->context->shop->id;
        $quotation->id_currency = (int) Tools::getValue('quote_currency');
        $quotation->id_country = $id_country;
        $quotation->id_state = (int) Tools::getValue('tax_state');
        $quotation->id_employee = $this->context->employee->id;
        $quotation->last_update = $mysql_date_now;

        if ($valid_for = Tools::getValue('valid_for')) {
            $valid_for_period = Tools::getValue('valid_for_period');
            $date = new DateTime($quotation->date_add);
            switch ($valid_for_period) {
                case 1:
                    $date->add(new DateInterval('PT'.$valid_for.'H'));
                    break;
                case 2:
                    $date->add(new DateInterval('P'.$valid_for.'D'));
                    break;
                case 3:
                    $date->add(new DateInterval('P'.$valid_for.'M'));
                    break;
            }
            $quotation->expiry_date = $date->format('Y-m-d H:i:s');
        }

        $customer = new Customer();
        if ($customer_email=Tools::getValue('email')) {
            $customer->getByEmail($customer_email);
            if (!Validate::isLoadedObject($customer)) {
                $customer->firstname = Tools::getValue('firstname');
                $customer->lastname = Tools::getValue('lastname');
                $customer->email = $customer_email;
                $password = Tools::passwdGen();
                $quotation->tmp_password = $password;
                $customer->passwd =Tools::encrypt($password);
                $customer->save();
            }
            $quotation->id_customer = $customer->id;
            $quotation->firstname = $customer->firstname ;
            $quotation->lastname = $customer->lastname;
            $quotation->email = $customer->email;
        }
        $quotation->quote_name = Tools::getValue('quote_name');
        if (!$quotation->reference) {
            $quotation->reference = Tools::strtoupper(Tools::passwdGen(9, 'NO_NUMERIC'));
        }

        $quotation->calculate_taxes = Tools::getValue('ROJA45_QUOTATIONSPRO_ENABLE_TAXES');

        if (!$quotation->save()) {
            throw new Exception(Db::getInstance()->getMsgError());
        }
        if ($quotation->id_roja45_quotation_status != $id_status) {
            $status = new QuotationStatus($id_status);
            $quotation->setStatus($status->code);
        }

        return $quotation;
    }

    public function processSubmitNewCustomerOrder()
    {
        $validationErrors = array();
        try {
            $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));
            if (!Validate::isLoadedObject($quotation)) {
                $this->errors[] = $this->l('The quotation could not be loaded.');
                die(Tools::jsonEncode(
                    array(
                        'result' => 'error',
                        'errors' => $validationErrors,
                    )
                ));
            }

            $payment_method = Tools::getValue('payment_method');
            if (!Tools::strlen($payment_method) > 0) {
                $this->errors[] = $this->l('You must provide a payment method.');
            }

            $id_order_state = Tools::getValue('order_state');
            if (!Tools::strlen($payment_method) > 0) {
                $this->errors[] = $this->l('You must provide an order status.');
            }

            if (!count($this->errors)) {
                if ($quotation->id_cart && !QuotationOrder::hasOrders($quotation->id_roja45_quotation)) {
                    $this->context->cart = new Cart($quotation->id_cart);
                    $return = 1;
                } else {
                    $return = $this->preProcessCart($quotation);
                }
                Context::getContext()->currency = new Currency((int)$quotation->id_currency);
                Context::getContext()->customer = new Customer((int)$quotation->id_customer);

                RojaFortyFiveQuotationsProCoreFile::saveCustomerRequirement(
                    'ROJA45QUOTATIONSPRO_ID_QUOTATION',
                    $quotation->id_roja45_quotation
                );

                if ($return && $quotation->populateCart()) {
                    if ($quotation->id_carrier) {
                        $delivery_option = $quotation->id_carrier.',';
                        if ($delivery_option !== false) {
                            $this->context->cart->setDeliveryOption(
                                array(
                                    $this->context->cart->id_address_delivery => $delivery_option
                                )
                            );
                        }
                        $this->context->cart->save();

                        if (!Configuration::get('PS_CATALOG_MODE')) {
                            $payment_module = Module::getInstanceByName($payment_method);
                        } else {
                            $payment_module = new BoOrder();
                        }
                        $bad_delivery = (bool)!Address::isCountryActiveById(
                            (int)$this->context->cart->id_address_delivery
                        );
                        if ($bad_delivery
                            || !Address::isCountryActiveById((int)$this->context->cart->id_address_invoice)) {
                            if ($bad_delivery) {
                                $this->errors[] = $this->l('This delivery address country is not active.');
                            } else {
                                $this->errors[] = $this->l('This invoice address country is not active.');
                            }
                        } else {
                            if ($quotation->id_employee) {
                                $employee = new Employee($quotation->id_employee);
                            } else {
                                $employee = new Employee((int)Context::getContext()->cookie->id_employee);
                                $quotation->id_employee = $employee->id;
                                $quotation->save();
                            }

                            $subject = $this->l(
                                'Manual Order - Quotation'
                            ) .'['.$quotation->reference.'] :'.' '. Tools::substr(
                                $employee->firstname,
                                0,
                                1
                            ).'. '.$employee->lastname;
                            $payment_module->validateOrder(
                                (int)$this->context->cart->id,
                                (int)$id_order_state,
                                $this->context->cart->getOrderTotal(true, Cart::BOTH),
                                $payment_module->displayName,
                                $subject,
                                array(),
                                null,
                                false,
                                $this->context->cart->secure_key
                            );
                            if ($payment_module->currentOrder) {
                                RojaFortyFiveQuotationsProCoreFile::clearCustomerRequirement(
                                    'ROJA45QUOTATIONSPRO_ID_QUOTATION'
                                );
                                $quotation_order = new QuotationOrder();
                                $quotation_order->id_roja45_quotation = $quotation->id;
                                $quotation_order->id_order = $payment_module->currentOrder;
                                $quotation_order->add();

                                $link = $this->context->link->getAdminLink(
                                    'AdminQuotationsPro',
                                    true
                                ) . '&viewroja45_quotationspro&id_roja45_quotation=' . $quotation->id;
                                Tools::redirectAdmin($link);
                            }
                        }
                    } else {
                        $this->errors[] = $this->l(
                            'No carrier asssigned to this quotation. ' .
                            'You need to add a shipping charge to the quotation.'
                        );
                    }
                }
                $this->errors[] = $this->l('Unable to create order.');
            }
            $this->display = 'view';
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $this->display = 'view';
        }
    }

    /**
     * ajaxProcessSaveAsTemplate - Create an account for this customer
     *
     * @return json
     *
     */
    public function processSaveAsTemplate()
    {
        $validationErrors = array();
        try {
            $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));
            if (!Validate::isLoadedObject($quotation)) {
                $validationErrors[] = $this->l('The quotation could not be loaded.');
            }

            if (!count($validationErrors)) {
                if (!empty($quotation->email)) {
                    $template = new RojaQuotation();
                    $template->id_lang = $quotation->id_lang;
                    $template->id_shop = $quotation->id_shop;
                    $template->id_currency = $quotation->id_currency;
                    $template->id_country = $quotation->id_country;
                    $template->id_employee = 0;
                    $template->id_customer = 0;
                    $template->id_roja45_quotation_status = 0;
                    $template->valid_days = $quotation->valid_days;
                    $template->calculate_taxes = $quotation->calculate_taxes;
                    $template->is_template = 1;
                    $template->template_name = Tools::getValue('template_name');
                    if (!$template->add()) {
                        throw new Exception($this->l('Unable to save quotation.'));
                    }

                    foreach ($quotation->getProducts() as $quotation_product) {
                        $quotation_product = new QuotationProduct($quotation_product['id_roja45_quotation_product']);
                        $quotation_product->duplicateObject();
                        $quotation_product->id_roja45_quotation = $template->id;
                        $quotation_product->save();
                    }

                    foreach ($quotation->getQuotationAllCharges() as $charge) {
                        $charge = new QuotationCharge($charge['id_roja45_quotation_charge']);
                        $charge->duplicateObject();
                        $charge->id_roja45_quotation = $template->id;
                        $charge->save();
                    }
                    foreach ($quotation->getQuotationAllDiscounts() as $discount) {
                        $discount = new QuotationCharge($discount['id_roja45_quotation_charge']);
                        $discount->duplicateObject();
                        $discount->id_roja45_quotation = $template->id;
                        $discount->save();
                    }
                } else {
                    $quotation->id_employee = 0;
                    $quotation->id_customer = 0;
                    $quotation->template_name = Tools::getValue('template_name');
                    $quotation->is_template = true;
                }

                if (!$quotation->save()) {
                    throw new Exception($this->l('Unable to save quotation.'));
                }

                Tools::redirectAdmin($this->context->link->getAdminLink('AdminQuotationsPro', true));
            } else {
                throw new Exception($this->l('Quotation could not be loaded.'));
            }
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
        }
    }
    /**
     * ajaxProcessSaveAsTemplate - Create an account for this customer
     *
     * @return json
     *
     */
    public function ajaxProcessUpdateTemplate()
    {
        $validationErrors = array();
        try {
            $template = new RojaQuotation((int)Tools::getValue('id_roja45_template'));
            if (!Validate::isLoadedObject($template)) {
                $validationErrors[] = $this->l('The quotation could not be loaded.');
            }

            if (!count($validationErrors)) {
                $template->valid_days = Tools::getValue('valid_for');
                $template->id_country = Tools::getValue('tax_country');
                $template->id_state = Tools::getValue('tax_state');
                $template->calculate_taxes = Tools::getValue('ROJA45_QUOTATIONSPRO_ENABLE_TAXES');

                if (!$template->save()) {
                    throw new Exception($this->l('Unable to save quotation.'));
                }

                die(Tools::jsonEncode(array(
                    'redirect' => $this->context->link->getAdminLink(
                        'AdminQuotationTemplates',
                        true
                    ).'&id_roja45_quotation='.$template->id_roja45_quotation.'&viewroja45_quotationspro',
                    'result' => 1,
                    'response' => $this->l('Updated'),
                )));
            } else {
                throw new Exception($this->l('Quotation could not be loaded.'));
            }
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
        }
    }

    /**
     * ajaxProcessCreateCustomerAccount - Create an account for this customer
     *
     * @return json
     *
     */
    public function ajaxProcessCreateCustomerAccount()
    {
        $validationErrors = array();
        try {
            $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));
            if (!Validate::isLoadedObject($quotation)) {
                die(Tools::jsonEncode(
                    array(
                        'result' => false,
                        'error' => Tools::displayError('The quotation could not be loaded.'),
                    )
                ));
            }
            if (!count($validationErrors)) {
                $quotation->id_customer = $this->createCustomerAccount($quotation);
                if (!$quotation->save()) {
                    $validationErrors[] = $this->l('Unable to save quotation.');
                    die(Tools::jsonEncode(
                        array(
                            'result' => 0,
                            'errors' => $validationErrors,
                        )
                    ));
                }

                die(Tools::jsonEncode(
                    array(
                        'redirect' => $this->context->link->getAdminLink(
                            'AdminQuotationsPro',
                            true
                        ).'&id_roja45_quotation='.$quotation->id.'&viewroja45_quotationspro',
                        'result' => 1,
                        'response' => $this->l('Account created.'),
                    )
                ));
            } else {
                die(Tools::jsonEncode(
                    array(
                        'result' => 0,
                        'errors' => $validationErrors,
                    )
                ));
            }
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(
                array(
                    'result' => 0,
                    'errors' => $validationErrors,
                    'msg' => 'Caught exception: ' . $e->getMessage() . "\n",
                    'exception' => $e,
                )
            );
            die($json);
        }
    }

    /**
     * ajaxProcessCreateQuote - Create an account for this customer
     *
     * @return json
     *
     */
    public function ajaxProcessCreateQuote()
    {
        $validationErrors = array();
        try {
            $template = new RojaQuotation((int)Tools::getValue('id_roja45_template'));
            if (!Validate::isLoadedObject($template)) {
                die(Tools::jsonEncode(
                    array(
                        'result' => false,
                        'error' => Tools::displayError('The quotation could not be loaded.'),
                    )
                ));
            }
            if (!count($validationErrors)) {
                $quotation = new RojaQuotation();
                $quotation->id_lang = (int) $template->id_lang;
                $quotation->id_shop = (int) $this->context->shop->id;
                $quotation->id_currency = (int) $template->id_currency;
                $quotation->id_country = (int) $template->id_country;
                $quotation->id_employee = $this->context->employee->id;
                $quotation->id_customer = 0;
                $quotation->valid_days = (int) $template->valid_days;
                $quotation->form_data = '';
                $quotation->calculate_taxes = (int) $template->calculate_taxes;
                if (!$quotation->add()) {
                    throw new Exception($this->l('Unable to save quotation.'));
                }

                foreach ($template->getProducts() as $template_product) {
                    $template_product = new QuotationProduct($template_product['id_roja45_quotation_product']);
                    $template_product->duplicateObject();
                    $template_product->id_roja45_quotation = $quotation->id;
                    $template_product->save();
                }

                foreach ($template->getQuotationAllCharges() as $charge) {
                    $charge = new QuotationCharge($charge['id_roja45_quotation_charge']);
                    $charge->duplicateObject();
                    $charge->id_roja45_quotation = $quotation->id;
                    $charge->save();
                }

                foreach ($template->getQuotationAllDiscounts() as $discount) {
                    $discount = new QuotationCharge($discount['id_roja45_quotation_charge']);
                    $discount->duplicateObject();
                    $discount->id_roja45_quotation = $quotation->id;
                    $discount->save();
                }
                $quotation->setStatus(QuotationStatus::$NWQT);
                die(Tools::jsonEncode(array(
                    'redirect' => $this->context->link->getAdminLink(
                        'AdminQuotationsPro',
                        true
                    ).'&id_roja45_quotation='.$quotation->id.'&viewroja45_quotationspro',
                    'result' => 1,
                    'response' => $this->l('Deleted'),
                )));
            } else {
                die(Tools::jsonEncode(
                    array(
                        'result' => 0,
                        'errors' => $validationErrors,
                    )
                ));
            }
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(
                array(
                    'result' => 0,
                    'errors' => $validationErrors,
                    'msg' => 'Caught exception: ' . $e->getMessage() . "\n",
                    'exception' => $e,
                )
            );
            die($json);
        }
    }
    /**
     * ajaxProcessDeleteQuotation - Create an account for this customer
     *
     * @return json
     *
     */
    public function ajaxProcessDeleteQuotation()
    {
        $validationErrors = array();
        try {
            $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));
            if (!Validate::isLoadedObject($quotation)) {
                die(Tools::jsonEncode(
                    array(
                        'result' => false,
                        'error' => Tools::displayError('The quotation could not be loaded.'),
                    )
                ));
            }
            if (!count($validationErrors)) {
                if (!$quotation->delete()) {
                    $validationErrors[] = $this->l('Unable to save quotation.');
                    die(Tools::jsonEncode(
                        array(
                            'result' => 0,
                            'errors' => $validationErrors,
                        )
                    ));
                }

                die(Tools::jsonEncode(array(
                    'redirect' => $this->context->link->getAdminLink('AdminQuotationsPro', true),
                    'result' => 1,
                    'response' => $this->l('Deleted'),
                )));
            } else {
                die(Tools::jsonEncode(
                    array(
                        'result' => 0,
                        'errors' => $validationErrors,
                    )
                ));
            }
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(
                array(
                    'result' => 0,
                    'errors' => $validationErrors,
                    'msg' => 'Caught exception: ' . $e->getMessage() . "\n",
                    'exception' => $e,
                )
            );
            die($json);
        }
    }

    /**
     * ajaxProcessCreateCustomerAccount - Create an account for this customer
     *
     * @return json
     *
     */
    public function ajaxProcessSubmitSetCustomerAddress()
    {
        $validationErrors = array();
        try {
            $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));
            if (!Validate::isLoadedObject($quotation)) {
                die(Tools::jsonEncode(
                    array(
                        'result' => false,
                        'error' => Tools::displayError('The quotation could not be loaded.'),
                    )
                ));
            }
            if (!count($validationErrors)) {
                $quotation->id_address = (int)Tools::getValue('id_address');
                if (!$quotation->save()) {
                    $validationErrors[] = $this->l('Unable to save quotation.');
                    die(Tools::jsonEncode(
                        array(
                            'result' => 'error',
                            'errors' => $validationErrors,
                        )
                    ));
                }

                die(Tools::jsonEncode(
                    array(
                        'result' => 'success',
                        'message' => $this->l('Customer address saved.'),
                    )
                ));
            } else {
                die(Tools::jsonEncode(
                    array(
                        'result' => 'error',
                        'errors' => $validationErrors,
                    )
                ));
            }
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(
                array(
                    'result' => 'error',
                    'errors' => $validationErrors,
                    'msg' => 'Caught exception: ' . $e->getMessage() . "\n",
                    'exception' => $e,
                )
            );
            die($json);
        }
    }

    /**
     * ajaxProcessLoadCustomerQuotation - Retrieve a customer's request
     *
     * @return json
     *
     */
    public function ajaxProcessLoadCustomerQuotation()
    {
        $validationErrors = array();
        try {
            $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));
            if (!Validate::isLoadedObject($quotation)) {
                die(Tools::jsonEncode(
                    array(
                        'result' => 'error',
                        'error' => Tools::displayError('The quotation could not be loaded.'),
                    )
                ));
            }

            $customer = new Customer($quotation->id_customer);
            if (!Validate::isLoadedObject($customer)) {
                $quotation->id_customer = $this->createCustomerAccount($quotation);
                if (!$quotation->save()) {
                    $validationErrors[] = $this->l('Unable to save quotation.');
                    die(Tools::jsonEncode(
                        array(
                            'result' => 0,
                            'errors' => $validationErrors,
                        )
                    ));
                }
                $customer = new Customer($quotation->id_customer);
            }

            $template_vars = array();
            if (Validate::isLoadedObject($customer)) {
                if ($quotation->tmp_password) {
                    $tmp_vars = array(
                        'include_account' => 1,
                        'username' => $quotation->email,
                        'password' => $quotation->tmp_password,
                        'my_account_link' => $this->context->link->getPageLink('my-account', true),
                    );
                    $template_vars = array_merge($template_vars, $tmp_vars);
                }
            }

            if (Configuration::get('PS_MAIL_TYPE') == Mail::TYPE_BOTH ||
                Configuration::get('PS_MAIL_TYPE') == Mail::TYPE_HTML) {
                $tpl = $this->createModuleTemplate(
                    'send_quote.tpl'
                );
            } else {
                $tpl = $this->createModuleTemplate(
                    'send_quote_txt.tpl'
                );
            }

            $smarty_vars = $quotation->getSmartyVars();
            $template_vars = array_merge($template_vars, $smarty_vars);
            $tpl->assign($template_vars);

            $message_subject = $this->l('Quotation [%1$s] : [#ct%2$s] : [#tc%3$s]');

            $language = new Language($quotation->id_lang);
            $iso = Context::getContext()->language->iso_code;
            Context::getContext()->language->iso_code = $language->iso_code;
            $content = $tpl->fetch();
            Context::getContext()->language->iso_code = $iso;
            die(Tools::jsonEncode(
                array(
                    'result' => 'success',
                    'message_subject' => $message_subject,
                    'content' => $content,
                )
            ));
        } catch (Exception $e) {
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(
                array(
                    'result' => 'error',
                    'errors' => $validationErrors,
                    'exception' => $e,
                )
            );
            die($json);
        }
    }

    /**
     * ajaxProcessLoadMessageTemplate - Load a message template
     *
     * @return json
     *
     */
    public function ajaxProcessLoadMessageTemplate()
    {
        $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));
        if (!Validate::isLoadedObject($quotation)) {
            die(Tools::jsonEncode(
                array(
                    'result' => 0,
                    'error' => Tools::displayError('The quotation could not be loaded.'),
                )
            ));
        }

        try {
            $template = Tools::getValue('template');
            $template_path = $this->getEmailTemplatePath($template, (int)$quotation->id_lang);
            if (!$template_path) {
                die(Tools::jsonEncode(
                    array(
                        'result' => 0,
                    )
                ));
            }

            $template_vars = $quotation->getTemplateVars();
            $result = $this->populateTemplate($template_vars, $template_path);

            if (!$result) {
                die(Tools::jsonEncode(
                    array(
                        'result' => 0,
                    )
                ));
            }

            $message_subject = $this->l('New Message for Quotation [%1$s] : [#ct%2$s] : [#tc%3$s]');

            die(Tools::jsonEncode(
                array(
                    'result' => 1,
                    'message_subject' => $message_subject,
                    'content' => $result,
                )
            ));
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(
                array(
                    'result' => 0,
                    'errors' => $validationErrors,
                    'exception' => $e,
                )
            );
            die($json);
        }
    }

    public function ajaxProcessSearchProducts()
    {
        try {
            $currency = new Currency((int)Tools::getValue('id_currency'));
            if ($products = Product::searchByName(
                (int)$this->context->language->id,
                pSQL(Tools::getValue('product_search'))
            )) {
                foreach ($products as &$product) {
                    $product['formatted_price'] = Tools::displayPrice(
                        Tools::convertPrice($product['price_tax_incl'], $currency),
                        $currency
                    );
                    $product['price_tax_incl'] = Tools::ps_round(
                        Tools::convertPrice($product['price_tax_incl'], $currency),
                        Roja45QuotationsPro::DEFAULT_PRECISION
                    );
                    $product['price_tax_excl'] = Tools::ps_round(
                        Tools::convertPrice($product['price_tax_excl'], $currency),
                        Roja45QuotationsPro::DEFAULT_PRECISION
                    );
                    $productObj = new Product(
                        (int)$product['id_product'],
                        false,
                        (int)$this->context->language->id
                    );
                    $supplier = new Supplier($productObj->id_supplier, (int) $this->context->language->id);
                    $product['supplier'] = $supplier->name;
                    $product['wholesale_price'] = Tools::displayPrice(
                        Tools::convertPrice($productObj->wholesale_price, $currency),
                        $currency
                    );
                    $combinations = array();
                    $attributes = $productObj->getAttributesGroups((int)$this->context->language->id);
                    if (Tools::isSubmit('id_address')) {
                        $product['tax_rate'] = $productObj->getTaxesRate(new Address(Tools::getValue('id_address')));
                    }

                    $product['warehouse_list'] = array();

                    foreach ($attributes as $attribute) {
                        $combination = new Combination($attribute['id_product_attribute']);
                        if (!isset($combinations[$attribute['id_product_attribute']]['attributes'])) {
                            $combinations[$attribute['id_product_attribute']]['attributes'] = '';
                        }
                        $combinations[$attribute['id_product_attribute']]['attributes'] .=
                            $attribute['attribute_name'] . ' - ';
                        $combinations[$attribute['id_product_attribute']]['id_product_attribute'] =
                            $attribute['id_product_attribute'];
                        $combinations[$attribute['id_product_attribute']]['default_on'] =
                            $attribute['default_on'];
                        $combinations[$attribute['id_product_attribute']]
                            ['wholesale_price'] = $combination->wholesale_price;
                        $combinations[$attribute['id_product_attribute']]
                        ['wholesale_price_formatted'] = Tools::ps_round(
                            Tools::convertPrice($combination->wholesale_price, $currency),
                            Roja45QuotationsPro::DEFAULT_PRECISION
                        );
                        if (!isset($combinations[$attribute['id_product_attribute']]['price'])) {
                            $price_tax_incl = Product::getPriceStatic(
                                (int)$product['id_product'],
                                true,
                                $attribute['id_product_attribute'],
                                Roja45QuotationsPro::DEFAULT_PRECISION
                            );
                            $price_tax_excl = Product::getPriceStatic(
                                (int)$product['id_product'],
                                false,
                                $attribute['id_product_attribute'],
                                Roja45QuotationsPro::DEFAULT_PRECISION
                            );
                            $combinations[$attribute['id_product_attribute']]
                            ['price_tax_incl'] = Tools::ps_round(
                                Tools::convertPrice($price_tax_incl, $currency),
                                Roja45QuotationsPro::DEFAULT_PRECISION
                            );
                            $combinations[$attribute['id_product_attribute']]
                            ['price_tax_incl_formatted'] = Tools::displayPrice(
                                Tools::convertPrice($price_tax_incl, $currency),
                                $currency
                            );
                            $combinations[$attribute['id_product_attribute']]
                            ['price_tax_excl'] = Tools::ps_round(
                                Tools::convertPrice($price_tax_excl, $currency),
                                Roja45QuotationsPro::DEFAULT_PRECISION
                            );
                            $combinations[$attribute['id_product_attribute']]
                            ['price_tax_excl_formatted'] = Tools::displayPrice(
                                Tools::convertPrice($price_tax_excl, $currency),
                                $currency
                            );
                            $combinations[$attribute['id_product_attribute']]['formatted_price'] = Tools::displayPrice(
                                Tools::convertPrice($price_tax_excl, $currency),
                                $currency
                            );
                        }
                        if (!isset($combinations[$attribute['id_product_attribute']]['qty_in_stock'])) {
                            $combinations[
                                $attribute['id_product_attribute']
                            ]['qty_in_stock'] = StockAvailable::getQuantityAvailableByProduct(
                                (int)$product['id_product'],
                                $attribute['id_product_attribute'],
                                (int)$this->context->shop->id
                            );
                        }

                        if (Configuration::get('PS_ADVANCED_STOCK_MANAGEMENT') &&
                            (int)$product['advanced_stock_management'] == 1) {
                            $product['warehouse_list'][
                                $attribute['id_product_attribute']
                            ] = Warehouse::getProductWarehouseList(
                                $product['id_product'],
                                $attribute['id_product_attribute']
                            );
                        } else {
                            $product['warehouse_list'][$attribute['id_product_attribute']] = array();
                        }

                        $product['stock'][$attribute['id_product_attribute']] = Product::getRealQuantity(
                            $product['id_product'],
                            $attribute['id_product_attribute']
                        );
                    }

                    if (Configuration::get('PS_ADVANCED_STOCK_MANAGEMENT') &&
                        (int)$product['advanced_stock_management'] == 1) {
                        $product['warehouse_list'][0] = Warehouse::getProductWarehouseList($product['id_product']);
                    } else {
                        $product['warehouse_list'][0] = array();
                    }

                    $product['stock'][0] = StockAvailable::getQuantityAvailableByProduct(
                        (int)$product['id_product'],
                        0,
                        (int)$this->context->shop->id
                    );

                    foreach ($combinations as &$combination) {
                        $combination['attributes'] = rtrim($combination['attributes'], ' - ');
                    }
                    $product['combinations'] = $combinations;

                    if ($product['customizable']) {
                        $product_instance = new Product((int)$product['id_product']);
                        $product['customization_fields'] = $product_instance->getCustomizationFields(
                            $this->context->language->id
                        );
                    }
                }
                die(Tools::jsonEncode(array(
                    'result' => true,
                    'products' => $products,
                )));
            } else {
                die(Tools::jsonEncode(array(
                    'result' => true,
                    'products' => array(),
                )));
            }
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(
                array(
                    'result' => false,
                    'errors' => $validationErrors,
                    'exception' => $e,
                )
            );
            die($json);
        }
    }

    public function ajaxProcessAddProductToQuotation()
    {
        try {
            $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));
            if (!Validate::isLoadedObject($quotation)) {
                die(Tools::jsonEncode(array(
                    'result' => 0,
                    'error' => Tools::displayError('The quotation could not be loaded.'),
                )));
            }
            $retail_price = Tools::getValue('retail_price');

            $id_currency = Tools::getValue('id_currency');
            if ($id_currency != Configuration::get('PS_CURRENCY_DEFAULT')) {
                $retail_price = Tools::convertPrice(
                    $retail_price,
                    $id_currency,
                    false
                );
            }
            $id_product = Tools::getValue('id_product');
            $product = new Product($id_product, false, $quotation->id_lang);
            if (!Validate::isLoadedObject($product)) {
                die(Tools::jsonEncode(array(
                    'result' => 0,
                    'error' => Tools::displayError('The product object cannot be loaded.'),
                )));
            }
            $id_product_attribute = Tools::getValue('id_product_attribute');
            $combination = null;
            if (isset($id_product_attribute) && $id_product_attribute) {
                $combination = new Combination($id_product_attribute);
                if (!Validate::isLoadedObject($combination)) {
                    die(Tools::jsonEncode(array(
                        'result' => 0,
                        'error' => Tools::displayError('The combination object cannot be loaded.'),
                    )));
                }
            }

            if (isset($this->id_customer) && $this->id_customer) {
                $id_group = (int) Customer::getDefaultGroupId($this->id_customer);
            } else {
                $id_group = (int) Configuration::get('PS_UNIDENTIFIED_GROUP');
            }

            $qty = Tools::getValue('product_quantity');
            $comment = Tools::getValue('product_comment');
            if (!$quotation->addProduct(
                $id_product,
                $id_product_attribute,
                $retail_price,
                $qty,
                $comment,
                $id_group
            )) {
                die(Tools::jsonEncode(
                    array(
                        'result' => 0,
                        'view' => $this->_getQuotationHTML($quotation),
                        'error' => Tools::displayError('Unable to add product to quotation'),
                    )
                ));
            }

            if (!$quotation->save()) {
                die(Tools::jsonEncode(
                    array(
                        'result' => 0,
                        'view' => $this->_getQuotationHTML($quotation),
                        'error' => Tools::displayError('Unable to save quotation'),
                    )
                ));
            }
            die(Tools::jsonEncode(array(
                'redirect' => $this->context->link->getAdminLink('AdminQuotationsPro', true).
                    '&id_roja45_quotation='.$quotation->id_roja45_quotation.'&viewroja45_quotationspro',
                'result' => 1,
                'response' => $this->l('Product Line Added'),
            )));
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(
                array(
                    'result' => 0,
                    'errors' => $validationErrors,
                    'exception' => $e,
                )
            );
            die($json);
        }
    }

    /**
     * ajaxProcessDeleteProductOnQuotation - Delete a product line on a quotation.
     *
     * @return json
     *
     */
    public function ajaxProcessDeleteProductOnQuotation()
    {
        $validationErrors = array();
        try {
            if (!Tools::strlen(trim(Tools::getValue('id_roja45_quotation'))) > 0) {
                $validationErrors[] = $this->l('No quotation id.');
            }
            if (!Tools::strlen(trim(Tools::getValue('id_roja45_quotation_product'))) > 0) {
                $validationErrors[] = $this->l('No quotation product id.');
            }

            $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));
            $quotation_product = new QuotationProduct((int)Tools::getValue('id_roja45_quotation_product'));
            if (!Validate::isLoadedObject($quotation_product)) {
                die(Tools::jsonEncode(
                    array(
                        'result' => 'error',
                        'error' => $this->l('The quotation could not be loaded.')
                    )
                ));
            }

            if (!$quotation->deleteProduct($quotation_product)) {
                die(Tools::jsonEncode(
                    array(
                        'result' => false,
                        'view' => $this->_getQuotationHTML($quotation),
                        'error' => Tools::displayError('Unable to delete product from quotation'),
                    )
                ));
            }

            if (!$quotation->save()) {
                die(Tools::jsonEncode(
                    array(
                        'result' => false,
                        'view' => $this->_getQuotationHTML($quotation),
                        'error' => Tools::displayError('Unable to save quotation'),
                    )
                ));
            }

            die(Tools::jsonEncode(array(
                'redirect' => $this->context->link->getAdminLink(
                    'AdminQuotationsPro',
                    true
                ).'&id_roja45_quotation='.$quotation->id_roja45_quotation.'&viewroja45_quotationspro',
                'result' => 'success',
                'response' => $this->l('Success'),
            )));
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(
                array(
                    'result' => 'error',
                    'errors' => $validationErrors,
                    'exception' => $e,
                )
            );
            die($json);
        }
    }

    /**
     * ajaxProcessLoadQuotationProduct - Retrieve a product line on a quotation.
     *
     * @return json
     *
     */
    public function ajaxProcessLoadQuotationProduct()
    {
        $quotation_product = new QuotationProduct(Tools::getValue('id_roja45_quotation_product'));
        if (!Validate::isLoadedObject($quotation_product)) {
            die(Tools::jsonEncode(
                array(
                    'result' => 'error',
                    'error' => $this->l('The quotation product object could not be loaded.')
                )
            ));
        }

        $product = new Product($quotation_product->id_product);
        if (!Validate::isLoadedObject($product)) {
            die(Tools::jsonEncode(
                array(
                    'result' => 'error',
                    'error' => $this->l('The product object cannot be loaded.')
                )
            ));
        }

        die(Tools::jsonEncode(
            array(
                'result' => 'success',
                'product' => $product,
                'price_tax_incl' => Product::getPriceStatic(
                    $product->id,
                    true,
                    $quotation_product->id_product_attribute,
                    Roja45QuotationsPro::DEFAULT_PRECISION
                ),
                'price_tax_excl' => Product::getPriceStatic(
                    $product->id,
                    false,
                    $quotation_product->id_product_attribute,
                    Roja45QuotationsPro::DEFAULT_PRECISION
                )
            )
        ));
    }

    /**
     * ajaxProcessEditProductOnQuotation - Update a product line on a quotation.
     *
     * @return json
     *
     */
    public function ajaxProcessEditProductOnQuotation()
    {
        // Return value
        $validationErrors = array();
        try {
            if (!Tools::strlen(trim(Tools::getValue('id_roja45_quotation'))) > 0) {
                $validationErrors[] = $this->l('No quotation id.');
            }
            if (!Tools::strlen(trim(Tools::getValue('id_roja45_quotation_product'))) > 0) {
                $validationErrors[] = $this->l('No quotation product id.');
            }

            if (!count($validationErrors) > 0) {
                $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));
                $quotation_product = new QuotationProduct((int)Tools::getValue('id_roja45_quotation_product'));

                // If multiple product_quantity, the order details concern a product customized
                $product_quantity = 0;
                if (is_array(Tools::getValue('product_quotation_quantity'))) {
                    foreach (Tools::getValue('product_quotation_quantity') as $id_customization => $qty) {
                        // Update quantity of each customization
                        Db::getInstance()->update(
                            'customization',
                            array('quantity' => (int)$qty),
                            'id_customization = ' . (int)$id_customization
                        );
                        $product_quantity += $qty;
                    }
                } else {
                    $product_quantity = Tools::getValue('product_quotation_quantity');
                }

                $new_price = Tools::convertPrice(Tools::getValue('product_price'), $quotation->id_currency, false);
                $price_inc = $quotation->getPriceWithTax(
                    $quotation_product->id_product,
                    $new_price,
                    $this->context
                );
                if ($new_price != (float)$quotation_product->unit_price_tax_excl) {
                    $quotation_product->custom_price = true;
                }
                $quotation_product->unit_price_tax_excl = Tools::ps_round($new_price, 6);
                $quotation_product->unit_price_tax_incl = Tools::ps_round($price_inc, 6);
                $quotation_product->deposit_amount = Tools::getValue('product_quotation_deposit_amount');
            } else {
                die(Tools::jsonEncode(
                    array(
                        'result' => 0,
                        'errors' => $validationErrors,
                    )
                ));
            }

            $comment = Tools::getValue('product_comment');
            $quotation_product->comment = $comment;
            $quotation_product->qty = $product_quantity;
            if ($quotation_product->save()) {
                die(Tools::jsonEncode(
                    array(
                        'redirect' => $this->context->link->getAdminLink(
                            'AdminQuotationsPro',
                            true
                        ).'&id_roja45_quotation='.$quotation->id_roja45_quotation.'&viewroja45_quotationspro',
                        'result' => 1,
                        'response' => $this->l('Success'),
                    )
                ));
            } else {
                $validationErrors = array();
                $validationErrors[] = $this->l('An error occurred updating this quote.');
                die(Tools::jsonEncode(
                    array(
                        'result' => 0,
                        'errors' => $validationErrors
                    )
                ));
            }
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(
                array(
                    'result' => 0,
                    'errors' => $validationErrors,
                    'exception' => $e,
                )
            );
            die($json);
        }
    }

    public function ajaxProcessSubmitResetProductPrice()
    {
        // Return value
        $res = true;
        $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));
        //$quotation_product = new QuotationProduct((int)Tools::getValue('id_roja45_quotation_product'));

        $quotation->resetPrice((int)Tools::getValue('id_roja45_quotation_product'));
        $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));

        // Assign to smarty informations in order to show the new product line
        $this->context->smarty->assign(
            array(
                'quotation' => $quotation,
                'currency' => new Currency($quotation->id_currency),
                'current_id_lang' => Context::getContext()->language->id,
                'link' => Context::getContext()->link,
                'current_index' => self::$currentIndex,
                'display_warehouse' => (int)Configuration::get('PS_ADVANCED_STOCK_MANAGEMENT'),
            )
        );

        $view = $this->_getQuotationHTML($quotation);

        die(Tools::jsonEncode(
            array(
                'result' => $res,
                'view' => $view,
                'quotation' => $quotation,
            )
        ));
    }

    /**
     * ajaxProcessSubmitClaimQuotation - Employee claim a quote request
     *
     * @return json
     *
     */
    public function ajaxProcessSubmitClaimQuotation()
    {
        $quotation = new RojaQuotation(Tools::getValue('id_roja45_quotation'));
        if (!Validate::isLoadedObject($quotation)) {
            die(Tools::jsonEncode(
                array(
                    'result' => false,
                    'error' => Tools::displayError('The quotation could not be loaded.'),
                )
            ));
        }
        try {
            $context = Context::getContext();
            $quotation->id_employee = $context->employee->id;
            if ($quotation->update()) {
                $hasAccount = 0;
                $customer = new Customer($quotation->id_customer);
                if (Validate::isLoadedObject($customer)) {
                    $hasAccount = 1;
                }
                $tpl = $this->context->smarty->createTemplate(
                    $this->getTemplatePath('quotationview_buttons.tpl') . 'quotationview_buttons.tpl'
                );
                $tpl->assign(
                    array(
                        'languages' => $this->context->controller->getLanguages(),
                        'link' => $this->context->link,
                        'quotation' => $quotation,
                        'has_account' => $hasAccount,
                        'employee' => '',
                        'deleted' => 0,
                    )
                );
                $buttons = $tpl->fetch();

                die(Tools::jsonEncode(
                    array(
                        'result' => 'success',
                        'buttons' => $buttons,
                        'employee_name' => $context->employee->firstname . ' ' . $context->employee->lastname,
                    )
                ));
            } else {
                $validationErrors = array();
                $validationErrors[] = $this->l('An error occurred claiming the request.');
                $json = Tools::jsonEncode(
                    array(
                        'result' => false,
                        'errors' => $validationErrors
                    )
                );
                die($json);
            }
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(
                array(
                    'result' => false,
                    'errors' => $validationErrors,
                    'exception' => $e,
                )
            );
            die($json);
        }
    }

    /**
     * ajaxProcessSubmitReleaseQuotation - Release a claimed quote request
     *
     * @return json
     *
     */
    public function ajaxProcessSubmitReleaseQuotation()
    {
        $quotation = new RojaQuotation(Tools::getValue('id_roja45_quotation'));
        if (!Validate::isLoadedObject($quotation)) {
            die(Tools::jsonEncode(
                array(
                    'result' => 0,
                    'error' => Tools::displayError('The quotation could not be loaded.'),
                )
            ));
        }
        try {
            $quotation->id_employee = '';
            $result = $quotation->save();
            if ($result) {
                $hasAccount = 0;
                $customer = new Customer($quotation->id_customer);
                if (Validate::isLoadedObject($customer)) {
                    $hasAccount = 1;
                }
                $tpl = $this->context->smarty->createTemplate(
                    $this->getTemplatePath('quotationview_buttons.tpl') . 'quotationview_buttons.tpl'
                );
                $tpl->assign(
                    array(
                        'languages' => $this->context->controller->getLanguages(),
                        'link' => $this->context->link,
                        'quotation' => $quotation,
                        'has_account' => $hasAccount,
                        'deleted' => 0,
                    )
                );
                $buttons = $tpl->fetch();

                die(Tools::jsonEncode(
                    array(
                        'result' => 1,
                        'buttons' => $buttons,
                        'unassigned' => $this->l('UNASSIGNED')
                    )
                ));
            } else {
                $validationErrors = array();
                $validationErrors[] = $this->l('An error occurred releasing the request.');
                $json = Tools::jsonEncode(
                    array(
                        'result' => 0,
                        'errors' => $validationErrors
                    )
                );
                die($json);
            }
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(
                array(
                    'result' => 0,
                    'errors' => $validationErrors,
                    'exception' => $e,
                )
            );
            die($json);
        }
    }

    /**
     * ajaxProcessSubmitResetCart - Release a claimed quote request
     *
     * @return json
     *
     */
    public function ajaxProcessSubmitResetCart()
    {
        $quotation = new RojaQuotation(Tools::getValue('id_roja45_quotation'));
        if (!Validate::isLoadedObject($quotation)) {
            die(Tools::jsonEncode(
                array(
                    'result' => 0,
                    'error' => Tools::displayError('The quotation could not be loaded.'),
                )
            ));
        }
        try {
            $quotation->id_cart = 0;
            $result = $quotation->save();
            if ($result) {
                die(Tools::jsonEncode(
                    array(
                        'result' => 1
                    )
                ));
            } else {
                $validationErrors = array();
                $validationErrors[] = $this->l('An error occurred releasing the request.');
                $json = Tools::jsonEncode(
                    array(
                        'result' => 0,
                        'errors' => $validationErrors
                    )
                );
                die($json);
            }
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(
                array(
                    'result' => 0,
                    'errors' => $validationErrors,
                    'exception' => $e,
                )
            );
            die($json);
        }
    }

    /**
     * ajaxProcessSetCurrency - Sets the currency on the request
     *
     * @return json
     *
     */
    public function ajaxProcessSetCurrency()
    {
        $validationErrors = array();
        try {
            if (!Tools::strlen(trim(Tools::getValue('id_currency'))) > 0) {
                $validationErrors[] = $this->l('You must provide a currency in order to calculate the quote.');
            }
            $quotation = new RojaQuotation(Tools::getValue('id_roja45_quotation'));
            if (!Validate::isLoadedObject($quotation)) {
                die(Tools::jsonEncode(
                    array(
                        'result' => 0,
                        'error' => Tools::displayError('The quotation could not be loaded.'),
                    )
                ));
            }

            if (!count($validationErrors)) {
                $quotation->id_currency = Tools::getValue('id_currency');
                if (!$quotation->save()) {
                    $validationErrors[] = $this->l('Unable to save quotation.');
                    $json = Tools::jsonEncode(
                        array(
                            'result' => 0,
                            'errors' => $validationErrors
                        )
                    );
                    die($json);
                }

                $view = $this->_getQuotationHTML($quotation);
                die(Tools::jsonEncode(
                    array(
                        'result' => 1,
                        'view' => $view,
                    )
                ));
            } else {
                die(Tools::jsonEncode(
                    array(
                        'result' => 0,
                        'errors' => $validationErrors,
                    )
                ));
            }
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(
                array(
                    'result' => 'error',
                    'errors' => $validationErrors,
                    'exception' => $e,
                )
            );
            die($json);
        }
    }

    /**
     * ajaxProcessSubmitSearchAccount - Sets the quotation status
     *
     * @return json
     *
     */
    public function ajaxProcessSubmitSearchAccount()
    {
        $validationErrors = array();
        try {
            $customer_email = Tools::getValue('customer_email');
            if (!Tools::strlen(trim($customer_email)) > 0) {
                $validationErrors[] = $this->l('You must provide an email address');
            }
            $quotation = new RojaQuotation(Tools::getValue('id_roja45_quotation'));
            if (!Validate::isLoadedObject($quotation)) {
                die(Tools::jsonEncode(
                    array(
                        'result' => false,
                        'error' => Tools::displayError('The quotation could not be loaded.'),
                    )
                ));
            }

            if (!count($validationErrors)) {
                $customers = Customer::getCustomersByEmail($customer_email);
                if (!$customers) {
                    $json = Tools::jsonEncode(
                        array(
                            'result' => 1,
                            'email' => false,
                            'response' => $this->l('No account found')
                        )
                    );
                    die($json);
                } elseif ($customers > 1) {
                }
                $customer = new Customer($customers[0]['id_customer']);
                $quotation->id_customer = $customer->id;
                $quotation->firstname = $customer->firstname;
                $quotation->lastname = $customer->lastname;
                $quotation->email = $customer->email;
                $quotation->save();
                $json = Tools::jsonEncode(
                    array(
                        'result' => 1,
                        'response' => $this->l('Success'),
                        'redirect' => $this->context->link->getAdminLink(
                            'AdminQuotationsPro',
                            true
                        ).'&id_roja45_quotation='.$quotation->id_roja45_quotation.'&viewroja45_quotationspro',
                        'email' => $customer->email,
                        'firstname' => $customer->firstname,
                        'lastname' => $customer->lastname,
                    )
                );
                die($json);
            } else {
                die(Tools::jsonEncode(
                    array(
                        'result' => 'error',
                        'errors' => $validationErrors,
                    )
                ));
            }
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(
                array(
                    'result' => 'error',
                    'errors' => $validationErrors,
                    'exception' => $e,
                )
            );
            die($json);
        }
    }

    /**
     * ajaxProcessSubmitSetQuotationStatus - Sets the quotation status
     *
     * @return json
     *
     */
    public function ajaxProcessSubmitSetQuotationStatus()
    {
        $validationErrors = array();
        try {
            if (!Tools::strlen(trim(Tools::getValue('id_status'))) > 0) {
                $validationErrors[] = $this->l('You must provide a status.');
            }
            $quotation = new RojaQuotation(Tools::getValue('id_roja45_quotation'));
            if (!Validate::isLoadedObject($quotation)) {
                die(Tools::jsonEncode(
                    array(
                        'result' => false,
                        'error' => Tools::displayError('The quotation could not be loaded.'),
                    )
                ));
            }

            if (!count($validationErrors)) {
                $quotation->id_roja45_quotation_status = Tools::getValue('id_status');
                if (!$quotation->save()) {
                    $validationErrors[] = $this->l('Unable to save quotation.');
                    $json = Tools::jsonEncode(
                        array(
                            'result' => 'error',
                            'errors' => $validationErrors
                        )
                    );
                    die($json);
                }

                //$status = new QuotationStatus(Tools::getValue('id_status'), $this->context->language->id);
                die(Tools::jsonEncode(
                    array(
                        'redirect' => $this->context->link->getAdminLink(
                            'AdminQuotationsPro',
                            true
                        ).'&id_roja45_quotation='.$quotation->id_roja45_quotation.'&viewroja45_quotationspro',
                        'result' => 'success',
                        'response' => $this->l('Success')
                    )
                ));
            } else {
                die(Tools::jsonEncode(
                    array(
                        'result' => 'error',
                        'errors' => $validationErrors,
                    )
                ));
            }
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(
                array(
                    'result' => 'error',
                    'errors' => $validationErrors,
                    'exception' => $e,
                )
            );
            die($json);
        }
    }

    /**
     * ajaxProcessSubmitSelectCustomer - Sets the quotation status
     *
     * @return json
     *
     */
    public function ajaxProcessSubmitSelectCustomer()
    {
        $validationErrors = array();
        try {
            if (!Tools::strlen(trim(Tools::getValue('id_customer'))) > 0) {
                $validationErrors[] = $this->l('You must provide a status.');
            }
            $quotation = new RojaQuotation(Tools::getValue('id_roja45_quotation'));
            if (!Validate::isLoadedObject($quotation)) {
                die(Tools::jsonEncode(
                    array(
                        'result' => 0,
                        'error' => Tools::displayError('The quotation could not be loaded.'),
                    )
                ));
            }

            if (!count($validationErrors)) {
                $customer = new Customer(Tools::getValue('id_customer'));
                $quotation->id_customer = Tools::getValue('id_customer');
                $quotation->email = $customer->email;
                $quotation->firstname = $customer->firstname;
                $quotation->lastname = $customer->lastname;
                if (!$quotation->save()) {
                    $validationErrors[] = $this->l('Unable to save quotation.');
                    $json = Tools::jsonEncode(
                        array(
                            'result' => 0,
                            'errors' => $validationErrors
                        )
                    );
                    die($json);
                }

                die(Tools::jsonEncode(
                    array(
                        'redirect' => $this->context->link->getAdminLink(
                            'AdminQuotationsPro',
                            true
                        ).'&id_roja45_quotation='.$quotation->id_roja45_quotation.'&viewroja45_quotationspro',
                        'result' => 1,
                        'response' => $this->l('Success')
                    )
                ));
            } else {
                die(Tools::jsonEncode(
                    array(
                        'result' => 0,
                        'errors' => $validationErrors,
                    )
                ));
            }
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(
                array(
                    'result' => 0,
                    'errors' => $validationErrors,
                    'exception' => $e,
                )
            );
            die($json);
        }
    }

    /**
     * ajaxProcessSetCountry - Update country
     *
     * @return json
     *
     */
    public function ajaxProcessSetCountry()
    {
        $validationErrors = array();
        try {
            if (!Tools::strlen(trim(Tools::getValue('id_country'))) > 0) {
                $validationErrors[] = $this->l('No country provided.');
            }

            $quotation = new RojaQuotation(Tools::getValue('id_roja45_quotation'));
            if (!count($validationErrors)) {
                $reload = false;
                $states = State::getStatesByIdCountry(Tools::getValue('id_country'));
                if (Validate::isLoadedObject($quotation)) {
                    $quotation->id_country = Tools::getValue('id_country');
                    if (!$quotation->save()) {
                        $validationErrors[] = $this->l('Unable to save quotation.');
                        $json = Tools::jsonEncode(
                            array(
                                'result' => 'error',
                                'errors' => $validationErrors
                            )
                        );
                        die($json);
                    }
                    $reload = $this->context->link->getAdminLink(
                        'AdminQuotationsPro',
                        true
                    ).'&id_roja45_quotation='.$quotation->id_roja45_quotation.'&viewroja45_quotationspro';
                }

                die(Tools::jsonEncode(
                    array(
                        'result' => 'success',
                        'states' => $states,
                        'reload' => $reload
                    )
                ));
            } else {
                die(Tools::jsonEncode(
                    array(
                        'result' => 'error',
                        'errors' => $validationErrors,
                    )
                ));
            }
        } catch (Exception $e) {
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(
                array(
                    'result' => 'error',
                    'errors' => $validationErrors,
                    'exception' => $e,
                )
            );
            die($json);
        }
    }

    /**
     * ajaxProcessSetCountry - Update country
     *
     * @return json
     *
     */
    public function ajaxProcessSetField()
    {
        $validationErrors = array();
        try {
            if (!Tools::strlen(trim(Tools::getValue('name'))) > 0) {
                $validationErrors[] = $this->l('No field name provided');
            }
            if (!Tools::strlen(trim(Tools::getValue('value'))) > 0) {
                $validationErrors[] = $this->l('No value provided');
            }
            $quotation = new RojaQuotation(Tools::getValue('id_roja45_quotation'));
            if (!Validate::isLoadedObject($quotation)) {
                die(Tools::jsonEncode(
                    array(
                        'result' => 'error',
                        'error' => Tools::displayError('The quotation could not be loaded.'),
                    )
                ));
            }

            if (!count($validationErrors)) {
                $name = trim(Tools::getValue('name'));
                $value = trim(Tools::getValue('value'));
                $quotation->$name = $value;
                if (!$quotation->save()) {
                    $validationErrors[] = $this->l('Unable to save quotation.');
                    $json = Tools::jsonEncode(
                        array(
                            'result' => 'error',
                            'errors' => $validationErrors
                        )
                    );
                    die($json);
                }
                $view = $this->_getQuotationHTML($quotation);
                die(Tools::jsonEncode(
                    array(
                        'result' => 'success',
                        'view' => $view,
                    )
                ));
            } else {
                die(Tools::jsonEncode(
                    array(
                        'result' => 'error',
                        'errors' => $validationErrors,
                    )
                ));
            }
        } catch (Exception $e) {
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(
                array(
                    'result' => 'error',
                    'errors' => $validationErrors,
                    'exception' => $e,
                )
            );
            die($json);
        }
    }

    /**
     * ajaxProcessSetCountry - Update country
     *
     * @return json
     *

    public function ajaxProcessSetValidForDays()
    {
        $validationErrors = array();
        try {
            if (!Tools::strlen(trim(Tools::getValue('valid_for'))) > 0) {
                $validationErrors[] = $this->l('No valid for number provided.');
            }
            $quotation = new RojaQuotation(Tools::getValue('id_roja45_quotation'));
            if (!Validate::isLoadedObject($quotation)) {
                die(Tools::jsonEncode(
                    array(
                        'result' => 'error',
                        'error' => Tools::displayError('The quotation could not be loaded.'),
                    )
                ));
            }

            if (!count($validationErrors)) {
                $quotation->valid_days = Tools::getValue('valid_for');
                if (!$quotation->save()) {
                    $validationErrors[] = $this->l('Unable to save quotation.');
                    $json = Tools::jsonEncode(
                        array(
                            'result' => 'error',
                            'errors' => $validationErrors
                        )
                    );
                    die($json);
                }
                $view = $this->_getQuotationHTML($quotation);
                die(Tools::jsonEncode(
                    array(
                        'result' => 'success',
                        'view' => $view,
                    )
                ));
            } else {
                die(Tools::jsonEncode(
                    array(
                        'result' => 'error',
                        'errors' => $validationErrors,
                    )
                ));
            }
        } catch (Exception $e) {
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(
                array(
                    'result' => 'error',
                    'errors' => $validationErrors,
                    'exception' => $e,
                )
            );
            die($json);
        }
    }*/

    /**
     * ajaxProcessSetState - Update request status
     *
     * @return json
     *
     */
    public function ajaxProcessSetState()
    {
        $validationErrors = array();
        if (!Tools::strlen(trim(Tools::getValue('id_state'))) > 0) {
            $validationErrors[] = $this->l('You must provide a state.');
        }
        $quotation = new RojaQuotation(Tools::getValue('id_roja45_quotation'));
        if (!count($validationErrors)) {
            try {
                $reload = false;
                if (Validate::isLoadedObject($quotation)) {
                    $quotation->id_state = Tools::getValue('id_state');
                    if (!$quotation->save()) {
                        $validationErrors[] = $this->l('Unable to save quotation.');
                        $json = Tools::jsonEncode(
                            array(
                                'result' => 'error',
                                'errors' => $validationErrors
                            )
                        );
                        die($json);
                    }
                    $reload = $this->context->link->getAdminLink(
                        'AdminQuotationsPro',
                        true
                    ).'&id_roja45_quotation='.$quotation->id_roja45_quotation.'&viewroja45_quotationspro';
                }

                die(Tools::jsonEncode(
                    array(
                        'result' => 'success',
                        'reload' => $reload,
                    )
                ));
            } catch (Exception $e) {
                $validationErrors = array();
                $validationErrors[] = $e->getMessage();
                $json = Tools::jsonEncode(
                    array(
                        'result' => 'error',
                        'errors' => $validationErrors,
                        'exception' => $e,
                    )
                );
                die($json);
            }
        } else {
            die(Tools::jsonEncode(
                array(
                    'result' => 'error',
                    'errors' => $validationErrors,
                )
            ));
        }
    }

    /**
     * ajaxProcessSetLanguage- Update request status
     *
     * @return json
     *
     */
    public function ajaxProcessSetLanguage()
    {
        $validationErrors = array();
        if (!Tools::strlen(trim(Tools::getValue('id_lang'))) > 0) {
            $validationErrors[] = $this->l('You must provide a language id.');
        }
        $quotation = new RojaQuotation(Tools::getValue('id_roja45_quotation'));
        if (!count($validationErrors)) {
            try {
                $reload = false;
                if (Validate::isLoadedObject($quotation)) {
                    $quotation->id_lang = Tools::getValue('id_lang');
                    if (!$quotation->save()) {
                        $validationErrors[] = $this->l('Unable to save quotation.');
                        $json = Tools::jsonEncode(
                            array(
                                'result' => 'error',
                                'errors' => $validationErrors
                            )
                        );
                        die($json);
                    }
                    $reload = $this->context->link->getAdminLink(
                        'AdminQuotationsPro',
                        true
                    ).'&id_roja45_quotation='.$quotation->id_roja45_quotation.'&viewroja45_quotationspro';
                }

                die(Tools::jsonEncode(
                    array(
                        'result' => 'success',
                        'reload' => $reload,
                    )
                ));
            } catch (Exception $e) {
                $validationErrors = array();
                $validationErrors[] = $e->getMessage();
                $json = Tools::jsonEncode(
                    array(
                        'result' => 'error',
                        'errors' => $validationErrors,
                        'exception' => $e,
                    )
                );
                die($json);
            }
        } else {
            die(Tools::jsonEncode(
                array(
                    'result' => 'error',
                    'errors' => $validationErrors,
                )
            ));
        }
    }

    /**
     * ajaxProcessSubmitNewVoucher - Add a voucher to the request
     *
     * @return json
     *
     */
    public function ajaxProcessSubmitAddDiscount()
    {
        $validationErrors = array();
        if (!Tools::strlen(trim(Tools::getValue('discount_name'))) > 0) {
            $validationErrors[] = $this->l('You must specify a name in order to create a new discount.');
        }
        if (!Tools::strlen(trim(Tools::getValue('discount_type'))) > 0) {
            $validationErrors[] = $this->l('You must specify a discount type.');
        }
        if (!Tools::strlen(trim(Tools::getValue('discount_value'))) > 0) {
            $validationErrors[] = $this->l('The discount value must be greater than 0.');
        }
        if (!count($validationErrors)) {
            try {
                $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));
                if (!Validate::isLoadedObject($quotation)) {
                    $validationErrors[] = $this->l('The quotation could not be loaded.');
                    die(Tools::jsonEncode(
                        array(
                            'result' => false,
                            'errors' => $validationErrors,
                        )
                    ));
                }
                $charge = new QuotationCharge();
                $charge->id_roja45_quotation = $quotation->id;
                $charge->charge_name = trim(Tools::getValue('discount_name'));
                $charge->charge_type = QuotationCharge::$DISCOUNT;
                $discount_value = (float)str_replace(',', '.', Tools::getValue('discount_value'));
                $charge->charge_value = $discount_value;
                if (Tools::getValue('apply_discount') == 1) {
                    $charge->specific_product = false;
                } else {
                    $charge->specific_product = true;
                    $charge->id_roja45_quotation_product = Tools::getValue('select_product');
                }

                switch (Tools::getValue('discount_type')) {
                    case 1:
                        $charge->charge_method = QuotationCharge::$PERCENTAGE;
                        if ($discount_value < 100) {
                        } else {
                            $validationErrors[] = Tools::displayError('The discount value is invalid.');
                        }
                        break;
                    case 2:
                        $charge->charge_method = QuotationCharge::$VALUE;
                        $base_total_tax_exc = $quotation->getQuotationTotal(false);
                        if ($discount_value > $base_total_tax_exc) {
                            $validationErrors[] = Tools::displayError(
                                'The discount value is greater than the order total.'
                            );
                        }
                        break;
                    case 3:
                        $charge->charge_method = QuotationCharge::$VALUE;
                        break;
                    default:
                        $this->errors[] = Tools::displayError('The discount type is invalid.');
                        break;
                }

                if (count($validationErrors)) {
                    die(Tools::jsonEncode(
                        array(
                            'result' => 'error',
                            'errors' => $validationErrors,
                        )
                    ));
                }

                // TODO - Create new QuotationCharge object and save
                if (!$charge->save()) {
                    $validationErrors[] = Tools::displayError('Unable to create discount.');
                    die(Tools::jsonEncode(
                        array(
                            'result' => 'error',
                            'errors' => $validationErrors,
                        )
                    ));
                }

                if (!$quotation->save()) {
                    $validationErrors[] = Tools::displayError('Unable to save quotation.');
                    die(Tools::jsonEncode(
                        array(
                            'result' => 'error',
                            'errors' => $validationErrors,
                        )
                    ));
                }

                die(Tools::jsonEncode(
                    array(
                        'redirect' => $this->context->link->getAdminLink(
                            'AdminQuotationsPro',
                            true
                        ).'&id_roja45_quotation='.$quotation->id_roja45_quotation.'&viewroja45_quotationspro',
                        'result' => 'success',
                        'response' => $this->l('Success'),
                    )
                ));
            } catch (Exception $e) {
                $validationErrors = array();
                $validationErrors[] = $e->getMessage();
                $json = Tools::jsonEncode(
                    array(
                        'result' => 'error',
                        'errors' => $validationErrors,
                        'exception' => $e,
                    )
                );
                die($json);
            }
        } else {
            die(Tools::jsonEncode(
                array(
                    'result' => 'error',
                    'errors' => $validationErrors,
                )
            ));
        }
    }

    /**
     * ajaxProcessSubmitDeleteVoucher - Delete voucher on a request
     *
     * @return json
     *
     */
    public function ajaxProcessSubmitDeleteVoucher()
    {
        $validationErrors = array();
        $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));
        if (!Validate::isLoadedObject($quotation)) {
            $validationErrors[] = $this->l('The quotation could not be loaded.');
            die(Tools::jsonEncode(
                array(
                    'result' => 'error',
                    'errors' => $validationErrors,
                )
            ));
        }

        $quotation_charge = new QuotationCharge((int)Tools::getValue('id_roja45_quotation_charge'));
        if (!Validate::isLoadedObject($quotation_charge)) {
            $validationErrors[] = $this->l('The quotation charge cannot be loaded.');
            die(Tools::jsonEncode(
                array(
                    'result' => 'error',
                    'errors' => $validationErrors
                )
            ));
        }

        if ($quotation_charge->delete()) {
            // TODO - check for any vouchers for this quote and delete them
            $sql = '
                SELECT id_cart_rule
                FROM ' . _DB_PREFIX_ . 'cart_rule
                WHERE code like "%'. $quotation->reference .'%"';
            $results = Db::getInstance()->executeS($sql);
            foreach ($results as $row) {
                $cart_rule = new CartRule($row['id_cart_rule']);
                $cart_rule->delete();
            }
            die(Tools::jsonEncode(
                array(
                    'result' => 'success',
                    'view' => $this->_getQuotationHTML($quotation),
                )
            ));
        }
    }

    /**
     * ajaxProcessSubmitEnableTaxes - Enable taxes on a request
     *
     * @return json
     *
     */
    public function ajaxProcessSubmitEnableTaxes()
    {
        $validationErrors = array();

        if (!Tools::strlen(trim(Tools::getValue('enable_taxes'))) > 0) {
            $validationErrors[] = $this->l('You must specify whether to enable taxes.');
        }

        if (!count($validationErrors)) {
            $res = true;

            try {
                $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));
                $quotation->calculate_taxes = (int) Tools::getValue('enable_taxes');
                $quotation->update();

                die(Tools::jsonEncode(
                    array(
                        'result' => $res,
                        'view' => $this->_getQuotationHTML($quotation),
                    )
                ));
            } catch (Exception $e) {
                $validationErrors = array();
                $validationErrors[] = $e->getMessage();
                $json = Tools::jsonEncode(
                    array(
                        'result' => false,
                        'errors' => $validationErrors,
                        'exception' => $e,
                    )
                );
                die($json);
            }
        } else {
            die(Tools::jsonEncode(
                array(
                    'result' => false,
                    'errors' => $validationErrors,
                )
            ));
        }
    }

    /**
     * getQuotationHtml - Returns the quotation in HTML format
     *
     * @param RojaQuotation $quotation The quotation object to process.
     *
     * @return view
     *
    private function _getQuotationHtml(RojaQuotation $quotation)
    {
        $validationErrors = array();
        $products = $quotation->getProducts();
        $discounts = $quotation->getQuotationChargeList(QuotationCharge::$DISCOUNT);
        $charges = $quotation->getQuotationAllCharges();
        $carrierData = $quotation->getCarriers();
        $lang = new Language($quotation->id_lang);
        $currency = new Currency((int)$quotation->id_currency);
        $summary = $quotation->getSummaryDetails($quotation->id_lang);

        if (!Validate::isLoadedObject($quotation)) {
            $validationErrors[] = $this->l('The quotation could not be loaded.');
            die(Tools::jsonEncode(
                array(
                    'result' => false,
                    'errors' => $validationErrors,
                )
            ));
        }

        $tpl = $this->context->smarty->createTemplate(
            $this->getTemplatePath('quotationview_quotation.tpl') . 'quotationview_quotation.tpl'
        );
        $tpl->assign($summary);
        $tpl->assign(
            array(
                'languages' => $this->context->controller->getLanguages(),
                'link' => $this->context->link,
                'currency' => $currency,
                'products' => $products,
                'carriers' => $carrierData['carriers'],
                'charges' => $charges,
                'discounts' => $discounts,
                'lang' => $lang,
                'id_roja45_quotation' => $quotation->id_roja45_quotation,
                'quotation' => $quotation,
            )
        );
        $view = $tpl->fetch();

        return $view;
    }*/

    public function ajaxProcessSubmitShippingCharge()
    {
        $validationErrors = array();
        try {
            if (!Tools::strlen(trim(Tools::getValue('id_roja45_quotation'))) > 0) {
                $validationErrors[] = $this->l('No quotation id available.');
            }
            if (!Tools::strlen(trim(Tools::getValue('carriers'))) > 0) {
                $validationErrors[] = $this->l('No carrier id is available.');
            }
            if (!Tools::strlen(trim(Tools::getValue('charge_name'))) > 0) {
                $validationErrors[] = $this->l('No carrier name is available.');
            }
            if (!Tools::strlen(trim(Tools::getValue('charge_value'))) > 0) {
                $validationErrors[] = $this->l('No carrier value is available.');
            }
            if (!count($validationErrors)) {
                $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));
                if (!Validate::isLoadedObject($quotation)) {
                    $validationErrors[] = $this->l('The quotation could not be loaded.');
                    die(Tools::jsonEncode(
                        array(
                            'result' => 'error',
                            'errors' => $validationErrors,
                        )
                    ));
                }

                $carrier = new Carrier(Tools::getValue('carriers'));
                $address = Address::initialize(null);
                $carrier_tax = $carrier->getTaxesRate($address);

                // save shipping cost as new charge
                $charge = new QuotationCharge();
                $charge->id_roja45_quotation = $quotation->id;
                $charge->charge_name = trim(Tools::getValue('charge_name'));
                $charge->charge_type = QuotationCharge::$SHIPPING;
                $charge_value = (float)str_replace(',', '.', Tools::getValue('charge_value'));
                $charge->charge_method = QuotationCharge::$VALUE;
                $charge->charge_amount = (float) Tools::ps_round(
                    (float) $charge_value,
                    (Currency::getCurrencyInstance((int)$quotation->id_currency)->decimals*_PS_PRICE_DISPLAY_PRECISION_)
                );

                $charge->charge_amount_wt = Tools::ps_round(
                    $charge_value * (1 + ($carrier_tax/100)),
                    (Currency::getCurrencyInstance((int)$quotation->id_currency)->decimals*_PS_PRICE_DISPLAY_PRECISION_)
                );

                if (!$charge->save()) {
                    $validationErrors[] = Tools::displayError('Unable to save charge.');
                    die(Tools::jsonEncode(
                        array(
                            'result' => 'error',
                            'errors' => $validationErrors,
                        )
                    ));
                }

                if ($carrier->shipping_handling && Configuration::get('PS_SHIPPING_HANDLING') > 0) {
                    $charge = new QuotationCharge();
                    $charge->id_roja45_quotation = $quotation->id;
                    $charge->charge_name = $this->module->l('Handling', 'QuotationsProFront');
                    $charge->charge_type = QuotationCharge::$HANDLING;
                    $charge->charge_method = QuotationCharge::$VALUE;
                    $charge->charge_amount = Configuration::get('PS_SHIPPING_HANDLING');
                    $charge->charge_amount_wt = $charge->charge_amount * (1 + ($quotation->getTaxesAverage() / 100));
                    $charge->save();
                }

                $quotation->total_shipping += $charge->charge_amount;
                $quotation->total_shipping_wt += $charge->charge_amount_wt;
                $quotation->id_carrier = (int)Tools::getValue('carriers');
                if (!$quotation->save()) {
                    $validationErrors[] = Tools::displayError('Unable to save quotation.');
                    die(Tools::jsonEncode(
                        array(
                            'result' => 'error',
                            'errors' => $validationErrors,
                        )
                    ));
                }

                die(Tools::jsonEncode(
                    array(
                        'redirect' => $this->context->link->getAdminLink(
                            'AdminQuotationsPro',
                            true
                        ).'&id_roja45_quotation='.$quotation->id_roja45_quotation.'&viewroja45_quotationspro',
                        'result' => 'success',
                        'response' => $this->l('Success'),
                    )
                ));
            } else {
                die(Tools::jsonEncode(array(
                    'result' => 'error',
                    'errors' => $validationErrors,
                )));
            }
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(array(
                'result' => 'error',
                'errors' => $validationErrors,
                'exception' => $e,
            ));
            die($json);
        }
    }

    public function ajaxProcessSubmitNewCharge()
    {
        $validationErrors = array();
        try {
            if (!Tools::strlen(trim(Tools::getValue('charge_name'))) > 0) {
                $validationErrors[] = $this->l('No name provided for this charge.');
            }
            if (!Tools::strlen(trim(Tools::getValue('charge_value'))) > 0) {
                $validationErrors[] = $this->l('No value provided for this charge');
            }
            if (!Tools::strlen(trim(Tools::getValue('charge_method'))) > 0) {
                $validationErrors[] = $this->l('No method provided for this charge.');
            }
            if (!count($validationErrors)) {
                $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));
                if (!Validate::isLoadedObject($quotation)) {
                    $validationErrors[] = $this->l('The quotation could not be loaded.');
                    die(Tools::jsonEncode(array(
                        'result' => false,
                        'errors' => $validationErrors,
                    )));
                }

                $charge = new QuotationCharge();
                $charge->id_roja45_quotation = $quotation->id;
                $charge->charge_name = trim(Tools::getValue('charge_name'));
                switch (Tools::getValue('charge_type')) {
                    case 'general':
                        $charge->charge_type = QuotationCharge::$CHARGE;
                        break;
                    case 'shipping':
                        $charge->charge_type = QuotationCharge::$SHIPPING;
                        break;
                    case 'handling':
                        $charge->charge_type = QuotationCharge::$HANDLING;
                        break;
                }

                $charge_value = (float)str_replace(',', '.', Tools::getValue('charge_value'));
                switch (Tools::getValue('charge_method')) {
                    case 1:
                        $charge->charge_method = QuotationCharge::$PERCENTAGE;
                        if ($charge_value < 100) {
                            $charge->charge_amount = Tools::ps_round($quotation->total_to_pay * $charge_value / 100, 2);
                            $charge->charge_amount_wt = Tools::ps_round(
                                $quotation->total_to_pay_wt * $charge_value / 100,
                                2
                            );
                        } else {
                            $validationErrors[] = Tools::displayError('The discount value is invalid.');
                        }
                        break;
                    // Amount type
                    case 2:
                        $charge->charge_method = QuotationCharge::$VALUE;
                        if ($charge_value < 0) {
                            $validationErrors[] = Tools::displayError('Your charge should not be negative');
                        } else {
                            $charge->charge_amount = Tools::ps_round($charge_value, 6);
                            $charge->charge_amount_wt = Tools::ps_round(
                                $charge_value * (1 + ($quotation->getTaxesAverage() / 100)),
                                6
                            );
                            /*
                            $with_tax = $quotation->calculate_taxes;
                            if ($with_tax) {
                                $charge->charge_amount = Tools::ps_round(
                                    $charge_value / (1 + ($quotation->getTaxesAverage() / 100))
                                );
                                $charge->charge_amount_wt = Tools::ps_round($charge_value, 6);
                            } else {
                                $charge->charge_amount = $charge_value;
                                $charge->charge_amount_wt = $charge_value;
                            }
                            */
                        }
                        break;
                    default:
                        $validationErrors[] = Tools::displayError('The charge type is invalid.');
                        break;
                }

                if (count($validationErrors)) {
                    die(Tools::jsonEncode(
                        array(
                            'result' => 'error',
                            'errors' => $validationErrors,
                        )
                    ));
                }

                // TODO - Create new QuotationCharge object and save
                if (!$charge->save()) {
                    $validationErrors[] = Tools::displayError('Unable to create charge. ');
                    die(Tools::jsonEncode(
                        array(
                            'result' => 'error',
                            'errors' => $validationErrors,
                        )
                    ));
                }
                $quotation->total_charges += $charge->charge_amount;
                $quotation->total_charges_wt += $charge->charge_amount_wt;

                if (!$quotation->save()) {
                    $validationErrors[] = Tools::displayError('Unable to save quotation.');
                    die(Tools::jsonEncode(
                        array(
                            'result' => 'error',
                            'errors' => $validationErrors,
                        )
                    ));
                }

                die(Tools::jsonEncode(
                    array(
                        'result' => 'success',
                        'redirect' => $this->context->link->getAdminLink(
                            'AdminQuotationsPro',
                            true
                        ).'&id_roja45_quotation='.$quotation->id_roja45_quotation.'&viewroja45_quotationspro',
                    )
                ));
            } else {
                die(Tools::jsonEncode(
                    array(
                        'result' => 'error',
                        'errors' => $validationErrors,
                    )
                ));
            }
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(
                array(
                    'result' => 'error',
                    'errors' => $validationErrors,
                    'exception' => $e,
                )
            );
            die($json);
        }
    }

    public function ajaxProcessSubmitDeleteCharge()
    {
        $validationErrors = array();
        try {
            $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));
            if (!Validate::isLoadedObject($quotation)) {
                $validationErrors[] = $this->l('The quotation could not be loaded.');
                die(Tools::jsonEncode(
                    array(
                        'result' => 'error',
                        'errors' => $validationErrors,
                    )
                ));
            }

            $charge = new QuotationCharge((int)Tools::getValue('id_roja45_quotation_charge'));
            if (!Validate::isLoadedObject($charge)) {
                $validationErrors[] = $this->l('The quotation charge cannot be loaded.');
                die(Tools::jsonEncode(array(
                    'result' => 'error',
                    'errors' => $validationErrors,
                )));
            }

            switch (Tools::getValue('charge_type')) {
                case 'general':
                    $quotation->total_charges -= $charge->charge_amount;
                    $quotation->total_charges_wt -= $charge->charge_amount_wt;
                    break;
                case 'shipping':
                    $quotation->total_shipping -= $charge->charge_amount;
                    $quotation->total_shipping_wt -= $charge->charge_amount_wt;
                    break;
                case 'handling':
                    $quotation->total_handling -= $charge->charge_amount;
                    $quotation->total_handling_wt -= $charge->charge_amount_wt;
                    break;
            }

            if ($charge->delete()) {
                if (!$quotation->save()) {
                    $validationErrors[] = $this->l('Unable to save quotation.');
                    die(Tools::jsonEncode(array(
                        'result' => 'error',
                        'errors' => $validationErrors,
                    )));
                };
            }

            die(Tools::jsonEncode(
                array(
                    'result' => 'success',
                    'redirect' => $this->context->link->getAdminLink(
                        'AdminQuotationsPro',
                        true
                    ).'&id_roja45_quotation='.$quotation->id_roja45_quotation.'&viewroja45_quotationspro',
                )
            ));
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(
                array(
                    'result' => 'error',
                    'errors' => $validationErrors,
                    'exception' => $e,
                )
            );
            die($json);
        }
    }

    public function ajaxProcessSubmitQuotationNote()
    {
        $validationErrors = array();
        if (!Tools::strlen(trim(Tools::getValue('note'))) > 0) {
            $validationErrors[] = $this->l('You must provide a note.');
        }

        if (!count($validationErrors)) {
            try {
                $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));

                if (!Validate::isLoadedObject($quotation)) {
                    $validationErrors[] = $this->l('The quotation could not be loaded.');
                    die(Tools::jsonEncode(
                        array(
                            'result' => 'error',
                            'errors' => $validationErrors,
                        )
                    ));
                }

                $note = new QuotationNote();
                $note->id_roja45_quotation = $quotation->id;
                $note->note = trim(Tools::getValue('note'));
                $note->added = date('Y-m-d H:i:s');

                if (count($validationErrors)) {
                    die(Tools::jsonEncode(
                        array(
                            'result' => 'error',
                            'errors' => $validationErrors,
                        )
                    ));
                }

                if (!$note->add()) {
                    $validationErrors[] = Tools::displayError('Unable to create charge. ');
                    die(Tools::jsonEncode(
                        array(
                            'result' => 'error',
                            'errors' => $validationErrors,
                        )
                    ));
                }

                die(Tools::jsonEncode(
                    array(
                        'result' => 'success',
                        'response' => $this->l('Success'),
                        'redirect' => $this->context->link->getAdminLink(
                            'AdminQuotationsPro',
                            true
                        ).'&id_roja45_quotation='.$quotation->id_roja45_quotation.'&viewroja45_quotationspro',
                    )
                ));
            } catch (Exception $e) {
                $validationErrors = array();
                $validationErrors[] = $e->getMessage();
                $json = Tools::jsonEncode(
                    array(
                        'result' => 'error',
                        'errors' => $validationErrors,
                        'exception' => $e,
                    )
                );
                die($json);
            }
        } else {
            die(Tools::jsonEncode(
                array(
                    'result' => 'error',
                    'errors' => $validationErrors,
                )
            ));
        }
    }

    public function ajaxProcessDeleteQuotationNote()
    {
        $validationErrors = array();
        try {
            $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));
            if (!Validate::isLoadedObject($quotation)) {
                $validationErrors[] = $this->l('The quotation could not be loaded.');
                die(Tools::jsonEncode(array(
                    'result' => false,
                    'errors' => $validationErrors,
                )));
            }

            $note = new QuotationNote((int)Tools::getValue('id_roja45_quotation_note'));
            if (!Validate::isLoadedObject($note)) {
                $validationErrors[] = $this->l('The quotation note cannot be loaded.');
                die(Tools::jsonEncode(array(
                    'result' => false,
                    'errors' => $validationErrors,
                )));
            }
            // TODO - Create new QuotationCharge object and save
            if (!$note->delete()) {
                $validationErrors[] = Tools::displayError('Unable to delete note. ');
                die(Tools::jsonEncode(array(
                    'result' => false,
                    'errors' => $validationErrors,
                )));
            }

            die(Tools::jsonEncode(array(
                'result' => 'success',
                'response' => $this->l('Success'),
                'redirect' => $this->context->link->getAdminLink(
                    'AdminQuotationsPro',
                    true
                ).'&id_roja45_quotation='.$quotation->id_roja45_quotation.'&viewroja45_quotationspro',
            )));
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(array(
                'result' => false,
                'errors' => $validationErrors,
                'exception' => $e,
            ));
            die($json);
        }
    }

    public function ajaxProcessSubmitSendQuotationForm()
    {
        $validationErrors = array();
        try {
            $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));
            if (!Validate::isLoadedObject($quotation)) {
                $validationErrors[] = $this->l('The quotation could not be loaded.');
            }

            $message_content = trim(Tools::getValue('response_content'));
            if (!Tools::strlen($message_content) > 0) {
                $validationErrors[] = $this->l('You must provide a message to send.');
            }

            if (!count($validationErrors)) {
                $contacts = Contact::getContacts($this->context->language->id);
                foreach ($contacts as $contact) {
                    if (strpos(Configuration::get('ROJA45_QUOTATIONSPRO_EMAIL'), $contact['email']) !== false) {
                        $id_contact = $contact['id_contact'];
                    }
                }

                if (!isset($id_contact)) { // if not use the default contact category
                    $id_contact = $contacts[0]['id_contact'];
                }

                if ($quotation_message = $quotation->getQuotationMessageList()) {
                    if (count($quotation_message)) {
                        $ct = new CustomerThread($quotation_message[0]['id_customer_thread']);
                    }
                }

                if (!isset($ct) || !$ct->id) {
                    $ct = new CustomerThread();
                    if (isset($quotation->id_customer)) { //if mail is owned by a customer assign to him
                        $ct->id_customer = $quotation->id_customer;
                    }
                    $ct->email = $quotation->email;
                    $ct->id_contact = $id_contact;
                    $ct->id_lang = (int)$quotation->id_lang;
                    $ct->id_shop = $quotation->id_shop;
                    $ct->status = 'open';
                    $ct->token = $quotation->reference;
                    $ct->save();

                    $quotation_message = new QuotationMessage();
                    $quotation_message->id_roja45_quotation = (int)$quotation->id_roja45_quotation;
                    $quotation_message->id_customer_thread = (int)$ct->id;
                    if (!($quotation_message->add())) {
                        throw new Exception($this->l('Unable to create quotation message entry.'));
                    }
                }

                $message_txt = new Html2Text($message_content);
                $message_txt = $message_txt->getText();
                $params = array(
                    '{content_txt}' => $message_txt,
                    '{content_html}' => $message_content,
                );

                $cm = new CustomerMessage();
                $cm->id_customer_thread = $ct->id;
                $cm->message = $message_txt;
                $cm->add();

                $file_attachment = null;
                if (Tools::getValue('message_template')=='roja45_customer_quote') {
                    $file_attachment['invoice']['content'] = $quotation->generateQuotationPDF(
                        false,
                        $quotation->calculate_taxes
                    );
                    $file_attachment['invoice']['name'] = $quotation->reference;
                    $file_attachment['invoice']['mime'] = 'application/pdf';
                }

                $bcc = Configuration::get('ROJA45_QUOTATIONSPRO_CONTACT_BCC');
                if (Tools::strlen($bcc) == 0) {
                    $bcc = null;
                }

                $subject = sprintf(
                    Tools::getValue('message_subject'),
                    $quotation->reference,
                    $ct->id,
                    $quotation->reference
                );
                $sent = Mail::Send(
                    (int)$this->context->language->id,
                    'message_wrapper',
                    $subject,
                    $params,
                    $quotation->email,
                    $quotation->firstname . ' ' . $quotation->lastname,
                    Configuration::get('ROJA45_QUOTATIONSPRO_EMAIL'),
                    Configuration::get('ROJA45_QUOTATIONSPRO_CONTACT_NAME'),
                    $file_attachment,
                    null,
                    _PS_MODULE_DIR_ . 'roja45quotationspro/mails/',
                    false,
                    null,
                    $bcc,
                    null
                );

                if ($sent) {
                    $quotation->tmp_password = '';
                    $quotation->quote_sent = true;
                    $customer = new Customer($quotation->id_customer);
                    if (Validate::isLoadedObject($customer)) {
                        $hasAccount = 1;
                        $addresses = $customer->getAddresses($this->context->language->id);
                        if (count($addresses) > 0 && !$quotation->id_address) {
                            $quotation->id_address = $addresses[0]['id_address'];
                        }
                    } else {
                        $hasAccount = 0;
                        $addresses = array();
                    }
                    $quotation->setStatus(QuotationStatus::$SENT);
                    $tpl = $this->context->smarty->createTemplate(
                        $this->getTemplatePath('quotationview_buttons.tpl') . 'quotationview_buttons.tpl'
                    );
                    $tpl->assign(
                        array(
                            'languages' => $this->context->controller->getLanguages(),
                            'link' => $this->context->link,
                            'quotation' => $quotation,
                            'has_account' => $hasAccount,
                            'deleted' => 0,
                        )
                    );
                    $buttons = $tpl->fetch();
                    die(Tools::jsonEncode(
                        array(
                            'result' => 1,
                            'buttons' => $buttons,
                            'status' => new QuotationStatus(
                                $quotation->id_roja45_quotation_status,
                                $this->context->language->id
                            ),
                            'message' => $this->l('Quotation sent successfully.')
                        )
                    ));
                } else {
                    $customer_thread_messages = $this->getMessageCustomerThreads($ct->id);
                    if (count($customer_thread_messages) == 1) {
                        $ct->delete();
                    }
                    $cm->delete();
                    PrestaShopLogger::addLog(
                        'Unable to send email to customer, please try again. ' .
                        'If the problem persists, please contact your system administrator.',
                        1,
                        null,
                        'roja45quotationspro',
                        null,
                        true
                    );
                    throw new Exception($this->l('Unable to send email to customer, please try again.  ' .
                        'If the problem persists, please contact your system administrator.'));
                }
            } else {
                die(Tools::jsonEncode(
                    array(
                        'result' => 0,
                        'errors' => $validationErrors,
                    )
                ));
            }
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(array(
                'result' => 0,
                'errors' => $validationErrors,
                'message' => 'Caught exception: ' . $e->getMessage() . "\n",
                'exception' => $e,
            ));
            die($json);
        }
    }

    public function ajaxProcessSubmitSendMessageForm()
    {
        $validationErrors = array();
        try {
            $quotation = new RojaQuotation((int)Tools::getValue('id_roja45_quotation'));
            if (!Validate::isLoadedObject($quotation)) {
                $validationErrors[] = $this->l('The quotation could not be loaded.');
            }

            $message_content = trim(Tools::getValue('response_content'));
            if (!Tools::strlen($message_content) > 0) {
                $validationErrors[] = $this->l('You must provide a message to send.');
            }

            if (!count($validationErrors)) {
                $contacts = Contact::getContacts($this->context->language->id);
                foreach ($contacts as $contact) {
                    if (strpos(Configuration::get('ROJA45_QUOTATIONSPRO_EMAIL'), $contact['email']) !== false) {
                        $id_contact = $contact['id_contact'];
                    }
                }

                if (!isset($id_contact)) { // if not use the default contact category
                    $id_contact = $contacts[0]['id_contact'];
                }

                if ($quotation_message = $quotation->getQuotationMessageList()) {
                    if (count($quotation_message)) {
                        $ct = new CustomerThread($quotation_message[0]['id_customer_thread']);
                    }
                }

                if (!isset($ct) || !$ct->id) {
                    $ct = new CustomerThread();
                    if (isset($quotation->id_customer)) {
                        $ct->id_customer = $quotation->id_customer;
                    }
                    $ct->email = $quotation->email;
                    $ct->id_contact = $id_contact;
                    $ct->id_lang = (int)$quotation->id_lang;
                    $ct->id_shop = $quotation->id_shop;
                    $ct->status = 'open';
                    $ct->token = $quotation->reference;
                    $ct->save();

                    $quotation_message = new QuotationMessage();
                    $quotation_message->id_roja45_quotation = (int)$quotation->id_roja45_quotation;
                    $quotation_message->id_customer_thread = (int)$ct->id;
                    if (!($quotation_message->add())) {
                        throw new Exception($this->l('Unable to create quotation message entry.'));
                    }
                }

                $message_txt = new Html2Text($message_content);
                $message_txt = $message_txt->getText();
                $params = array(
                    '{content_txt}' => $message_txt,
                    '{content_html}' => $message_content,
                );

                $cm = new CustomerMessage();
                $cm->id_customer_thread = $ct->id;
                $cm->message = $message_txt;
                $cm->add();

                $file_attachment = null;
                if (Tools::getValue('message_template')=='roja45_customer_quote') {
                    $file_attachment['invoice']['content'] = $quotation->generateQuotationPDF(
                        false,
                        $quotation->calculate_taxes
                    );
                    $file_attachment['invoice']['name'] = $quotation->reference;
                    $file_attachment['invoice']['mime'] = 'application/pdf';
                }

                $bcc = Configuration::get('ROJA45_QUOTATIONSPRO_CONTACT_BCC');
                if (Tools::strlen($bcc) == 0) {
                    $bcc = null;
                }

                $subject = sprintf(
                    Tools::getValue('message_subject'),
                    $quotation->reference,
                    $ct->id,
                    $quotation->reference
                );

                $sent = Mail::Send(
                    (int)$this->context->language->id,
                    'message_wrapper',
                    $subject,
                    $params,
                    $quotation->email,
                    $quotation->firstname . ' ' . $quotation->lastname,
                    Configuration::get('ROJA45_QUOTATIONSPRO_EMAIL'),
                    Configuration::get('ROJA45_QUOTATIONSPRO_CONTACT_NAME'),
                    $file_attachment,
                    null,
                    _PS_MODULE_DIR_ . 'roja45quotationspro/mails/',
                    false,
                    null,
                    $bcc,
                    null
                );

                if ($sent) {
                    $hasAccount = 0;
                    $customer = new Customer($quotation->id_customer);
                    if (Validate::isLoadedObject($customer)) {
                        $hasAccount = 1;
                    }
                    $tpl = $this->context->smarty->createTemplate(
                        $this->getTemplatePath('quotationview_buttons.tpl') . 'quotationview_buttons.tpl'
                    );
                    $tpl->assign(
                        array(
                            'languages' => $this->context->controller->getLanguages(),
                            'link' => $this->context->link,
                            'has_account' => $hasAccount,
                            'quotation' => $quotation,
                            'deleted' => 0,
                        )
                    );
                    $buttons = $tpl->fetch();
                    die(Tools::jsonEncode(
                        array(
                            'result' => 1,
                            'buttons' => $buttons,
                            'status' => new QuotationStatus(
                                $quotation->id_roja45_quotation_status,
                                $this->context->language->id
                            ),
                            'message' => $this->l('Quotation sent successfully.')
                        )
                    ));
                } else {
                    $customer_thread_messages = $this->getMessageCustomerThreads($ct->id);
                    if (count($customer_thread_messages) == 1) {
                        $ct->delete();
                    }
                    $cm->delete();
                    PrestaShopLogger::addLog(
                        'Unable to send email to customer, please try again. ' .
                        ' If the problem persists, please contact your system administrator.',
                        1,
                        null,
                        'roja45quotationspro',
                        null,
                        true
                    );
                    throw new Exception($this->l('Unable to send email to customer, please try again.  ' .
                        'If the problem persists, please contact your system administrator.'));
                }
            } else {
                die(Tools::jsonEncode(
                    array(
                        'result' => 0,
                        'errors' => $validationErrors,
                    )
                ));
            }
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(array(
                'result' => 0,
                'errors' => $validationErrors,
                'message' => 'Caught exception: ' . $e->getMessage() . "\n",
                'exception' => $e,
            ));
            die($json);
        }
    }

    public function ajaxProcessUpdateQuotationRequestCounter()
    {
        $validationErrors = array();
        try {
            if (!count($validationErrors)) {
            } else {
                die(Tools::jsonEncode(
                    array(
                        'result' => 'error',
                        'errors' => $validationErrors,
                    )
                ));
            }
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(array(
                'result' => 'error',
                'errors' => $validationErrors,
                'msg' => 'Caught exception: ' . $e->getMessage() . "\n",
                'exception' => $e,
            ));
            die($json);
        }
    }

    public function ajaxProcessSubmitGetCarrierCharge()
    {
        $validationErrors = array();
        try {
            $quotation = new RojaQuotation((int) Tools::getValue('id_roja45_quotation'));
            if (!Validate::isLoadedObject($quotation)) {
                $validationErrors[] = $this->l('The quotation could not be loaded.');
            }
            $id_carrier = (int) Tools::getValue('id_carrier');
            if (!$id_carrier) {
                $validationErrors[] = $this->l('No carrier id provided.');
            }

            if (!count($validationErrors)) {
                $products = $quotation->getProducts();
                if (!$this->context->cart) {
                    $this->context->cart = new Cart();
                }
                $this->context->cart->id_currency = $quotation->id_currency;
                $this->context->cart->save();

                $country = new Country($quotation->id_country);
                $id_zone = (int) $country->id_zone;
                $carrier = new Carrier($id_carrier);
                if ($carrier->getShippingMethod() == Carrier::SHIPPING_METHOD_WEIGHT) {
                    $shipping_cost = $carrier->getDeliveryPriceByWeight(
                        $this->context->cart->getTotalWeight($products),
                        $id_zone
                    );
                } else {
                    $order_total = $this->context->cart->getOrderTotal(
                        true,
                        Cart::ONLY_PHYSICAL_PRODUCTS_WITHOUT_SHIPPING,
                        $products
                    );
                    $shipping_cost = $carrier->getDeliveryPriceByPrice(
                        $order_total,
                        $id_zone,
                        $quotation->id_currency
                    );
                }
                die(Tools::jsonEncode(
                    array(
                        'result' => 1,
                        'shipping_cost' => $shipping_cost,
                        'include_handling' => (int) Configuration::get('ROJA45_QUOTATIONSPRO_INCLUDEHANDLING'),
                        'shipping_handling' => (int) $carrier->shipping_handling
                    )
                ));
            } else {
                die(Tools::jsonEncode(
                    array(
                        'result' => 0,
                        'errors' => $validationErrors,
                    )
                ));
            }
        } catch (Exception $e) {
            $validationErrors = array();
            $validationErrors[] = $e->getMessage();
            $json = Tools::jsonEncode(array(
                'result' => 0,
                'errors' => $validationErrors,
                'msg' => 'Caught exception: ' . $e->getMessage() . "\n",
                'exception' => $e,
            ));
            die($json);
        }
    }

    /**
     * @param $quotation RojaQuotation
     * @return string
     */
    private function buildForm($quotation)
    {
        $status = new QuotationStatus($quotation->id_roja45_quotation_status, $this->context->language->id);
        //$products = $quotation->getProducts();
        $discounts = $quotation->getQuotationAllDiscounts();
        $charges = $quotation->getQuotationAllCharges();
        $quotation_orders = QuotationOrder::getList($quotation->id);
        foreach ($quotation_orders as &$quotation_order) {
            $order = new Order($quotation_order['id_order']);
            $quotation_order['reference'] = $order->reference;
            $quotation_order['order_url'] = $this->context->link->getAdminLink(
                'AdminOrders',
                true
            ) . '&vieworder&id_order=' . $quotation_order['id_order'];
        }

        $notes = $quotation->getQuotationNotesList();
        $customer = new Customer($quotation->id_customer);
        if (Validate::isLoadedObject($customer)) {
            $hasAccount = 1;
            $addresses = $customer->getAddresses($this->context->language->id);
            if (count($addresses) > 0 && !$quotation->id_address) {
                $quotation->id_address = $addresses[0]['id_address'];
                $quotation->save();
            }
        } else {
            $hasAccount = 0;
            $addresses = array();
        }
        $currencies = Currency::getCurrencies(false, true);
        $employee = new Employee($quotation->id_employee);
        $lang = new Language($quotation->id_lang);
        $templates = QuotationAnswer::getTemplates();
        $templates_lang = array();
        if (array_key_exists($lang->iso_code, $templates)) {
            $templates_lang = $templates[$lang->iso_code];
        }
        $quotation_statuses = QuotationStatus::getQuotationStates($this->context->language->id);
        $carrierData = $quotation->getCarriers();

        $customer_thread_messages = array();
        if ($quotation_message = $quotation->getQuotationMessageList()) {
            $ct = new CustomerThread($quotation_message[0]['id_customer_thread']);
            $customer_thread_messages = $this->getMessageCustomerThreads($ct->id);
        }

        $currency = new Currency((int)$quotation->id_currency);
        // Process request json obj into array of name value pairs, with field type
        $quotation_request = new QuotationRequest($quotation->id_request);
        if ($quotation_request->form_data) {
            $requestJSON = Tools::jsonDecode($quotation_request->form_data);
        } else {
            $requestJSON = Tools::jsonDecode($quotation->form_data);
        }

        $request = array();
        if ($requestJSON) {
            $counter = 0;
            foreach ($requestJSON->columns as $column) {
                foreach ($column->fields as $field) {
                    if (($field->name != 'FIRSTNAME') &&
                        ($field->name != 'LASTNAME') &&
                        ($field->name != 'CONTACT_EMAIL')
                    ) {
                        $request[$counter]['name'] = $field->name;
                        $request[$counter]['value'] = $field->value;
                        $request[$counter]['label'] = $field->label;
                        if (isset($field->type) && ($field->type=='CUSTOM_SELECT')) {
                        } elseif (isset($field->type) && ($field->type=='SHIPPING_METHOD')) {
                            $carrier = new Carrier($field->value, $this->context->language->id);
                            $request[$counter]['value'] = $carrier->name;
                        } elseif (isset($field->type) && ($field->type=='COUNTRY')) {
                            $country = new Country($field->value, $this->context->language->id);
                            $request[$counter]['value'] = $country->name;
                        }
                        ++$counter;
                    }
                }
            }
        }

        $countries = Country::getCountries($this->context->language->id, true);
        $id_country = !empty($quotation->id_country) ?
            $quotation->id_country :
            Configuration::get('PS_COUNTRY_DEFAULT');
        $states = State::getStatesByIdCountry($id_country);

        $total_paid = 0;
        if ($quotation->id_order) {
            $order = new Order($quotation->id_order);
            $total_paid = $order->getOrdersTotalPaid();
        }
        $view = '';
        $tpl = $this->context->smarty->createTemplate($this->getTemplatePath('_adminHeader.tpl') . '_adminHeader.tpl');
        $view .= $tpl->fetch();

        $last_message = null;
        if (count($customer_thread_messages) > 0) {
            $last_message = $customer_thread_messages[0];
        }
        $tpl = $this->context->smarty->createTemplate(
            $this->getTemplatePath('quotationview.tpl') . 'quotationview.tpl'
        );
        $summary = $quotation->getSummaryDetails(Context::getContext()->language->id);
        $edit_customer_url = $this->context->link->getAdminLink('AdminAddresses') . '&addaddress';

        $filename = sha1($quotation->email . $quotation->filename . $quotation->id_request);
        if (Shop::isFeatureActive()) {
            $tpl->assign(
                array(
                    'multistore_active' => 1,
                )
            );
        }

        $shop = new Shop($quotation->id_shop);
        $quotation->shop_name = $shop->name;
        $tpl->assign($summary);
        $tpl->assign(
            array(
                'quotationspro_link' => $this->context->link->getAdminLink(
                    'AdminQuotationsPro',
                    true
                ),
                'languages' => $this->context->controller->getLanguages(),
                'link' => $this->context->link,
                'id_roja45_quotation' => $quotation->id,
                'payment_methods' => PaymentModule::getInstalledPaymentModules(),
                'order_states' => OrderState::getOrderStates(Context::getContext()->language->id),
                'quotation' => $quotation,
                'filename' => $filename,
                'employee' => $employee,
                'customer' => $customer,
                'addresses' => $addresses,
                'has_account' => $hasAccount,
                'currency' => $currency,
                'notes' => $notes,
                'total_paid' => $total_paid,
                'carriers' => $carrierData['carriers'],
                'templates' => $templates_lang,
                'discounts' => $discounts,
                'messages' => $customer_thread_messages,
                'last_message' => $last_message,
                'quotation_statuses' => $quotation_statuses,
                'quotation_orders' => $quotation_orders,
                'charges' => $charges,
                'request' => $request,
                'status' => $status,
                'currencies' => $currencies,
                'countries' => $countries,
                'states' => $states,
                'lang' => $lang,
                'ROJA45_QUOTATIONSPRO_ENABLE_TAXES' => $quotation->calculate_taxes,
                'current_id_lang' => $this->context->language->id,
                'id_shop' => $quotation->id_shop,
                'current_index' => self::$currentIndex,
                'edit_customer_url' => $edit_customer_url,
                'fields_value' => $this->getFieldsValues(),
                'deleted' => ($status->id == (int) Configuration::get('ROJA45_QUOTATIONSPRO_STATUS_DLTD')),
                'shipping_handling' => Configuration::get('PS_SHIPPING_HANDLING'),
                'id_currency' => $quotation->id_currency,
                'currency_sign' => $currency->sign,
                'currency_format' => $currency->format,
                'currency_blank' => $currency->blank,
                'has_voucher' => (count($discounts) > 0) ? 1 : 0,
                'has_charges' => (count($charges) > 0) ? 1 : 0,
                'use_taxes' => (int) $quotation->calculate_taxes,
                'deposit_enabled' => (int) Configuration::get('ROJA45_QUOTATIONSPRO_ENABLEDEPOSITPAYMENTS'),
                'priceDisplayPrecision' => _PS_PRICE_DISPLAY_PRECISION_,
            )
        );

        $view .= $tpl->fetch();
        return $view;
    }

    private function getEmailTemplatePath($template, $id_lang)
    {
        $mail_type = Configuration::get('PS_MAIL_TYPE');
        $filetype = '';
        if ($mail_type == Mail::TYPE_BOTH || $mail_type == Mail::TYPE_TEXT) {
            $filetype = '.txt';
        }
        if ($mail_type == Mail::TYPE_BOTH || $mail_type == Mail::TYPE_HTML) {
            $filetype = '.html';
        }

        $module_name = 'roja45quotationspro';

        $iso = Language::getIsoById($id_lang);
        if (!$iso) {
            return false;
        }
        $iso_template = $iso . '/' . $template;

        $theme_path = _PS_THEME_DIR_;

        if (file_exists($theme_path . 'modules/' . $module_name . '/mails/' . $iso_template . $filetype)) {
            $template_path = $theme_path . 'modules/' . $module_name . '/mails/' . $iso_template . $filetype;
        } elseif (file_exists($theme_path . 'mails/' . $iso_template . $filetype)) {
            $template_path = $theme_path . 'mails/' . $iso_template . $filetype;
        } elseif (file_exists(_PS_ROOT_DIR_.'/modules/'.$module_name.'/mails/'.$iso_template . $filetype)) {
            $template_path = _PS_ROOT_DIR_ . '/modules/' . $module_name . '/mails/' . $iso_template . $filetype;
        } elseif (file_exists(_PS_ROOT_DIR_ . '/mails/' . $iso_template . $filetype)) {
            $template_path = _PS_ROOT_DIR_ . '/mails/' . $iso_template . $filetype;
        } elseif (file_exists(_PS_ROOT_DIR_.'/modules/'.$module_name.'/mails/en/' . $template . $filetype)) {
            $template_path = _PS_ROOT_DIR_ . '/modules/' . $module_name . '/mails/en/' . $template . $filetype;
        } else {
            return false;
        }

        return $template_path;
    }

    private function populateTemplate($template_vars, $template_path)
    {
        $mail_type = Configuration::get('PS_MAIL_TYPE');
        if ($mail_type == Mail::TYPE_BOTH || $mail_type == Mail::TYPE_TEXT) {
            //$template_body = strip_tags(html_entity_decode(Tools::file_get_contents($template_path), null, 'utf-8'));
            $template_body = Tools::file_get_contents($template_path);
        }
        if ($mail_type == Mail::TYPE_BOTH || $mail_type == Mail::TYPE_HTML) {
            $template_body = Tools::file_get_contents($template_path);
        }
        $body = str_replace(array_keys($template_vars), array_values($template_vars), $template_body);

        return $body;
    }

    public function getMessageCustomerThreads($id_customer_thread)
    {
        return Db::getInstance()->executeS('
            SELECT ct.*, cm.*, cl.name subject, CONCAT(e.firstname, \' \', e.lastname) employee_name,
                CONCAT(c.firstname, \' \', c.lastname) customer_name, c.firstname
            FROM ' . _DB_PREFIX_ . 'customer_thread ct
            LEFT JOIN ' . _DB_PREFIX_ . 'customer_message cm
                ON (ct.id_customer_thread = cm.id_customer_thread)
            LEFT JOIN ' . _DB_PREFIX_ . 'contact_lang cl
                ON (cl.id_contact = ct.id_contact AND cl.id_lang = ' . (int)Context::getContext()->language->id . ')
            LEFT JOIN ' . _DB_PREFIX_ . 'employee e
                ON e.id_employee = cm.id_employee
            LEFT JOIN ' . _DB_PREFIX_ . 'customer c
                ON (IFNULL(ct.id_customer, ct.email) = IFNULL(c.id_customer, c.email))
            WHERE ct.id_customer_thread = ' . (int)$id_customer_thread . '
            ORDER BY cm.date_add DESC
        ');
    }

    private function createCustomerAccount($quotation)
    {
        $customer = new Customer();
        $customer->firstname = trim($quotation->firstname);
        $customer->lastname = trim($quotation->lastname);
        $customer->email = trim($quotation->email);
        $password = Tools::passwdGen();
        $quotation->tmp_password = $password;
        $customer->passwd =Tools::encrypt($password);
        if (!$customer->save()) {
            return false;
        }
        if (!$quotation->save()) {
            return false;
        }

        // TODO - Send email
        return $customer->id;
    }

    private function preProcessCart($quotation)
    {
        $id_customer = (int)$quotation->id_customer;
        $customer = new Customer((int)$id_customer);
        $this->context->customer = $customer;
        $this->context->cart = new Cart();
        $this->context->cart->recyclable = 0;
        $this->context->cart->gift = 0;

        if (!$this->context->cart->id_customer) {
            $this->context->cart->id_customer = $id_customer;
        }
        if (Validate::isLoadedObject($this->context->cart) && $this->context->cart->OrderExists()) {
            return;
        }
        if (!$this->context->cart->secure_key) {
            $this->context->cart->secure_key = $this->context->customer->secure_key;
        }
        if (!$this->context->cart->id_shop) {
            $this->context->cart->id_shop = (int)$this->context->shop->id;
        }
        if (!$this->context->cart->id_lang) {
            $this->context->cart->id_lang = (($id_lang = (int)Tools::getValue('id_lang')) ?
                $id_lang : Configuration::get('PS_LANG_DEFAULT'));
        }
        if (!$this->context->cart->id_currency) {
            $this->context->cart->id_currency = (($id_currency = (int)Tools::getValue('id_currency')) ?
                $id_currency : Configuration::get('PS_CURRENCY_DEFAULT'));
        }

        $addresses = $customer->getAddresses((int)$this->context->cart->id_lang);
        if (!count($addresses)) {
            $address = new Address();
            $address->id_country = $quotation->id_country;
            $address->id_state = $quotation->id_state;
            $address->lastname = $quotation->lastname;
            $address->firstname = $quotation->firstname;
            $address->city = $this->l('UNKNOWN');
            $address->address1 = $this->l('UNKNOWN');
            $address->alias = $this->l('SYSTEM GENERATED');
            $address->save();
            $quotation->id_address = $address->id;
            $quotation->save();
        }
        $id_address_delivery = (int)$quotation->id_address;
        $id_address_invoice = (int)$quotation->id_address;

        if (!$this->context->cart->id_address_invoice && isset($addresses[0])) {
            $this->context->cart->id_address_invoice = (int)$addresses[0]['id_address'];
        } elseif ($id_address_invoice) {
            $this->context->cart->id_address_invoice = (int)$id_address_invoice;
        }
        if (!$this->context->cart->id_address_delivery && isset($addresses[0])) {
            $this->context->cart->id_address_delivery = $addresses[0]['id_address'];
        } elseif ($id_address_delivery) {
            $this->context->cart->id_address_delivery = (int)$id_address_delivery;
        }
        $this->context->cart->setNoMultishipping();
        $this->context->cart->save();
        $currency = new Currency((int)$this->context->cart->id_currency);
        $this->context->currency = $currency;
        Configuration::updateGlobalValue('PS_CART_RULE_FEATURE_ACTIVE', '1');
        return 1;
    }

    private function markDeleted($id_roja45_quotation)
    {
        $object = new RojaQuotation($id_roja45_quotation);
        if (!$object->isRemovable()) {
            $this->errors[] = $this->l('For security reasons, you cannot delete this quotation.');
        }

        if ($object->id_cart) {
            SpecificPrice::deleteByIdCart($object->id_cart);
        }

        $charges = $object->getQuotationChargeList();
        foreach ($charges as $charge) {
            if ($charge['id_cart_rule']) {
                $rule = new CartRule($charge['id_cart_rule']);
                $rule->delete();
            }
            $chargeObj = new QuotationCharge($charge['id_roja45_quotation_charge']);
            $chargeObj->delete();
        }

        $object->setStatus(QuotationStatus::$DLTD);
        $object->save();
    }

    public function createModuleTemplate($tpl_name)
    {
        if (file_exists(_PS_THEME_DIR_ .
                'modules/' .
                $this->module->name .
                '/views/templates/admin/' .
                $tpl_name) &&
            $this->viewAccess()
        ) {
            return $this->context->smarty->createTemplate(
                _PS_THEME_DIR_ . 'modules/' . $this->module->name . '/views/templates/admin/' . $tpl_name,
                $this->context->smarty
            );
        } elseif (file_exists($this->getTemplatePath() . $this->override_folder . $tpl_name) &&
            $this->viewAccess()
        ) {
            return $this->context->smarty->createTemplate(
                $this->getTemplatePath() . $this->override_folder . $tpl_name,
                $this->context->smarty
            );
        }

        return $this->context->smarty->createTemplate($this->getTemplatePath() . $tpl_name);
    }
}

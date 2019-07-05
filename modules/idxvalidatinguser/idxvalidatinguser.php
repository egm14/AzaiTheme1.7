<?php
/**
 * 2007-2014 PrestaShop
 *
 * NOTICE OF LICENSE
 *
 * @author    Innova Deluxe SL
 * @copyright 2014 Innova Deluxe SL

 * @license   INNOVADELUXE
 */

if (!defined('_PS_VERSION_')) {
    exit;
}

if (!class_exists('InnovaTools')) {
    require_once(_PS_ROOT_DIR_ . '/modules/idxvalidatinguser/libraries/innovatools.php');
}

class Idxvalidatinguser extends Module
{
    private $file_name = '';
    
    public function __construct()
    {
        $this->name = 'idxvalidatinguser';
        $this->tab = 'administration';
        $this->version = '2.9.7';
        $this->ps_versions_compliancy = array('min' => '1.7', 'max' => _PS_VERSION_);
        $this->author_address = '0x899FC2b81CbbB0326d695248838e80102D2B4c53';
        $this->innovatabs = "";
        $this->doclink = $this->name."/doc/readme_en.pdf";
        $this->author = 'innovadeluxe';
        $this->need_instance = 0;
        $this->es15 = version_compare(_PS_VERSION_, '1.6.0.0', '<');
        $this->file_name = Tools::strtolower(trim(str_ireplace(' ', '', Context::getContext()->shop->name)));
        $this->module_key = '9c257d6e300c9f676d994b2f306f8f1b';

        $this->bootstrap = true;
        parent::__construct();
        $this->displayName = $this->l('Deluxe Validating User');
        $this->description = $this->l('Registered user will be enabled from Backoffice');
    }

    public function install()
    {
        $lang_examples = Language::getLanguages(false);
        $extra_info_example = array();
        $alert_example = array();
        $file_message_example = array();
        foreach ($lang_examples as $lang_example) {
            $extra_info_example[$lang_example['id_lang']] = Tools::htmlentitiesUTF8('

                <p id="marca_right"><strong>'.$this->l('You can specificate if the customer could send an attachment:').'</strong></p>
				<p id="marca_right"><strong>'.$this->l('You can configure a custom page content from here:').'</strong></p>
				<p id="p_marca_right" class="no_padding">'.$this->l('Registered user will be redirected to this page when they sign in.').'</p>
				<p id="marca_right"><strong>'.$this->l('You can set a message like:').'</strong></p>
				<p id="p_marca_right" class="no_padding">'.$this->l('This shop is a Private Shop. Your account must be validated by an administrator.').'</p>
			');
            
            $alert_example[$lang_example['id_lang']] = Tools::htmlentitiesUTF8('
               				
				<p id="p_marca_right" class="no_padding">'.$this->l('This shop is a Private Shop. Your account must be validated by an administrator.').'</p>
			');
            
            $file_message_example[$lang_example['id_lang']] = $this->l('Your register still pending of an administrator validation once that the attached documentation will be validated.');
        }

        if (!$id_hook = Hook::getIdByName('actionAuthenticationBefore')) {
            $hook = new Hook();
            $hook->name = 'actionAuthenticationBefore';
            $hook->title = 'actionAuthenticationBefore';
            $hook->description = 'actionAuthenticationBefore';
            $hook->position = false;
            $hook->add();
        }
        
        $tab = new Tab();
        $tab->active = 1;
        $tab->class_name = 'AdminIdxvalidatinguser';
        $tab->name = array();
        foreach (Language::getLanguages(true) as $lang) {
            $tab->name[$lang['id_lang']] = 'Idxvalidatinguser';
        }
        $tab->id_parent = -1;
        $tab->module = $this->name;


        Configuration::updateValue(Tools::strtoupper($this->name) . '_MAIL', '');
        Configuration::updateValue(Tools::strtoupper($this->name) . '_ADMN_MAIL', '');
        Configuration::updateValue(Tools::strtoupper($this->name) . '_TEMPLATE', 0);
        Configuration::updateValue(Tools::strtoupper($this->name) . '_HASATTACHMENT', 0);
        Configuration::updateValue(Tools::strtoupper($this->name) . '_REQATTACHMENT', 0);
        Configuration::updateValue(Tools::strtoupper($this->name) . '_RETAILERALLOW', 0);
        Configuration::updateValue(Tools::strtoupper($this->name) . '_WHOLESALEFORM', 0);
        Configuration::updateValue(Tools::strtoupper($this->name) . '_MOREINFO', $extra_info_example);
        Configuration::updateValue(Tools::strtoupper($this->name) . '_ALERT', $alert_example);
        Configuration::updateValue(Tools::strtoupper($this->name) . '_FILEMESSAGE', $file_message_example);
        return parent::install() &&
            $tab->add() &&
            $this->registerHook('actionCustomerAccountAdd') &&
            $this->registerHook('displayBackOfficeHeader') &&
            $this->registerHook('Header') &&
            $this->registerHook('displayCustomerAccountForm') &&
            $this->registerHook('additionalCustomerFormFields') &&
            $this->registerHook('displayCustomerLoginFormAfter') &&
            $this->registerHook('dashboardZoneOne') &&
            $this->registerHook('actionAuthenticationBefore') &&
            $this->registerHook('validateCustomerFormFields');
    }

    public function uninstall()
    {
        Configuration::deleteByName(Tools::strtoupper($this->name) . '_MAIL');
        Configuration::deleteByName(Tools::strtoupper($this->name) . '_ADMN_MAIL');
        Configuration::deleteByName(Tools::strtoupper($this->name) . '_TEMPLATE');
        Configuration::deleteByName(Tools::strtoupper($this->name) . '_MOREINFO');
        Configuration::deleteByName(Tools::strtoupper($this->name) . '_ALERT');
        Configuration::deleteByName(Tools::strtoupper($this->name) . '_FILEMESSAGE');
        Configuration::deleteByName(Tools::strtoupper($this->name) . '_HASATTACHMENT');
        Configuration::deleteByName(Tools::strtoupper($this->name) . '_REQATTACHMENT');
        Configuration::deleteByName(Tools::strtoupper($this->name) . '_RETAILERALLOW');
        Configuration::deleteByName(Tools::strtoupper($this->name) . '_WHOLESALEFORM');

        return parent::uninstall();
    }

     
    public function hookHeader()
    {
        $this->context->controller->addCSS($this->_path.'/views/css/front.css');
        Media::addJsDef(array('wholesaleForm' => Configuration::get(Tools::strtoupper($this->name) . '_WHOLESALEFORM')));
        $is_b2bForm = Tools::getValue('idxb2b');
        Media::addJsDef(array('is_b2bForm' => $is_b2bForm));
        Media::addJsDef(array('notAllowedFileTranslation' => addslashes($this->l('File extension is not allowed'))));
        $this->context->controller->registerJavascript('modules-idxvalidatinguser', 'modules/'.$this->name.'/views/js/wholesalereglink.js', array('position' => 'bottom', 'priority' => 150));
    }
        
    public function hookActionAuthenticationBefore($params)
    {
        $customer = new Customer();
        $authentication = $customer->getByEmail(
            Tools::getValue('email'),
            Tools::getValue('password')
        );

        if (isset($authentication->active) && !$authentication->active) {
            Media::addJsDef(array('noactivemessage' => Tools::htmlentitiesDecodeUTF8(Configuration::get('IDXVALIDATINGUSER_MOREINFO', $this->context->language->id))));
            $this->context->controller->addJS($this->_path.'views/js/changenoactivemessage.js', 'all');
        }
    }
    
    public function hookDisplayCustomerLoginFormAfter()
    {
        if ($this->active) {
            if (Configuration::get(Tools::strtoupper($this->name) . '_WHOLESALEFORM')) {
                return $this->display(__FILE__, 'views/templates/front/wholesalereglink.tpl');
            }
        }
    }
    
    public function hookActionCustomerAccountAdd($params)
    {
        
        if ($this->active) {
            $is_wholesaler = Tools::getValue('id_customertype');
            $is_b2bForm = Tools::getValue('idxb2b');
            
            if ($is_wholesaler == '1' || $is_b2bForm || !Configuration::get(Tools::strtoupper($this->name).'_RETAILERALLOW')) {
                $default_tamplate_user_mail = 'validating';
                $this->context->customer->mylogout();
                $customer = new Customer($this->context->customer->id);
                $customer->cleanGroups();
                $wholesale_group = array();
                $wholesale_group[] = Configuration::get(Tools::strtoupper($this->name) . '_WHOLEGROUP');
                $customer->addGroups($wholesale_group);
                $customer->active = 0;
                $customer->id_default_group = Configuration::get(Tools::strtoupper($this->name) . '_WHOLEGROUP');
                $customer->update();
                $mail_vars = array();
                $attach = array();
                $file = null;
                $admin_mail = Configuration::get('PS_SHOP_EMAIL');

                if (Configuration::get(Tools::strtoupper($this->name) . '_ADMN_MAIL')) {
                    $admin_mail = Configuration::get(Tools::strtoupper($this->name) . '_ADMN_MAIL');
                }


                if ($file = dirname(__FILE__). '/attach_files/'.$this->file_name.'_shop.zip') {
                    if ($zip = Tools::file_get_contents($file)) {
                        $attach['content'] = $zip;
                        $attach['name'] = 'example.zip';
                        $attach['mime'] = 'application/zip';
                    }
                }

                if (Configuration::get(Tools::strtoupper($this->name) . '_TEMPLATE')) {
                    $default_tamplate_user_mail = 'custom_user_template';
                    $mail_vars = array(
                        '{content}' => Tools::htmlentitiesDecodeUTF8(Configuration::get(Tools::strtoupper($this->name) . '_MAIL', $this->context->language->id)),
                    );
                }

                Mail::Send(
                    $this->context->language->id,
                    $default_tamplate_user_mail,
                    $this->l('Notifying of register.'),
                    $mail_vars,
                    Tools::getValue('email'),
                    null,
                    null,
                    null,
                    $attach, // attachment_files
                    null,
                    dirname(__FILE__).'/mails/',
                    false,
                    $this->context->shop->id
                );

                // mail admin
                Mail::Send(
                    $this->context->language->id,
                    'adminemail',
                    $this->l('Notifying of registered user.'),
                    array(),
                    $admin_mail,
                    null,
                    null,
                    null,
                    null,
                    null,
                    dirname(__FILE__).'/mails/',
                    false,
                    $this->context->shop->id
                );

                $allowed_extensions=array('pdf','doc','docx','txt','zip','rar','jpg','png');

                if (isset($_FILES['b2b_attachment']) && isset($_FILES['b2b_attachment']['tmp_name']) && !empty($_FILES['b2b_attachment']['tmp_name'])) {
                    $ext = Tools::substr($_FILES['b2b_attachment']['name'], strrpos($_FILES['b2b_attachment']['name'], '.') + 1);
                    if (!in_array(Tools::strtolower($ext), $allowed_extensions)) {
                        return false;
                    }
                    $file_name = md5($customer->id.'_documentation').'.'.$ext;
                    if (!move_uploaded_file($_FILES['b2b_attachment']['tmp_name'], dirname(__FILE__). '/attach_files/'.$file_name)) {
                        $this->displayError($this->l('A problem ocurred while uploading.'));
                    }
                } else {
                    $file_name = md5($customer->id.'_nodoc').'.txt';
                    $nodoc = fopen(dirname(__FILE__). '/attach_files/'.$file_name, "w+");
                    if ($nodoc == false) {
                        return false;
                    }
                }

                //Tools::redirect($this->context->link->getModuleLink('idxvalidatinguser', 'deluxevalidatinguser'));
            } else {
                $customer = new Customer($this->context->customer->id);
                $customer->cleanGroups();
                $wholesale_group = array();
                $wholesale_group[] = Configuration::get(Tools::strtoupper($this->name) . '_RETAILERGROUP');
                $customer->addGroups($wholesale_group);
                $customer->id_default_group = Configuration::get(Tools::strtoupper($this->name) . '_RETAILERGROUP');
                $customer->update();
            }
        }
    }

    
    public function hookAdditionalCustomerFormFields()
    {
        if ($this->context->controller->php_self == 'authentication'|| $this->context->controller->php_self == 'order' || $this->context->controller->php_self == 'identity') {
            $this->context->controller->addCSS($this->_path.'views/css/idxvalidatinguserform.css', 'all');
            $this->context->controller->addJS($this->_path.'views/js/idxvalidatinguserform.js', 'all');


            $ajaxLinkmsglogin=$this->context->link->getModuleLink('idxvalidatinguser', 'msglogin');

                Media::addJsDef(array('ajaxLinkmsglogin' => $ajaxLinkmsglogin));
                Media::addJsDef(array('modulename' => Tools::strtoupper($this->name)));
                Media::addJsDef(array('id_lang' => $this->context->language->id));

            $showupload = Configuration::get(Tools::strtoupper($this->name).'_HASATTACHMENT');
            if ($showupload) {
                $reqattachment = Configuration::get(Tools::strtoupper($this->name).'_REQATTACHMENT');
            } else {
                $reqattachment = 0;
            }
            $formarray = array();
            $is_b2bForm = Tools::getValue('idxb2b');
            if (Configuration::get(Tools::strtoupper($this->name).'_RETAILERALLOW') && !$is_b2bForm && !Configuration::get(Tools::strtoupper($this->name).'_WHOLESALEFORM')) {
                $allowretailer = new FormField();
                $allowretailer->setName('id_customertype');
                $allowretailer->setType('checkbox');
                $allowretailer->setLabel($this->l('Are you professional?'));
                $allowretailer->setRequired($reqattachment);
                $formarray[] = $allowretailer;
            }

            if (($showupload && !$is_b2bForm && !Configuration::get(Tools::strtoupper($this->name).'_WHOLESALEFORM')) || ($showupload && $is_b2bForm && Configuration::get(Tools::strtoupper($this->name).'_WHOLESALEFORM'))) {
                $formfield = new FormField();
                $formfield->setName('b2b_attachment');
                $formfield->setType('file');
                $formfield->setLabel($this->l('Choose a file'));
                $formfield->setRequired($reqattachment);

                $formarray[] = $formfield;
            }
            return $formarray;
        }
    }

    public function hookValidateCustomerFormFields($params)
    {
        $field = $params['fields'][0];
        $allowed_extensions=array('pdf','doc','docx','txt','zip','rar','jpg','png');

        if (isset($_FILES['b2b_attachment']) && isset($_FILES['b2b_attachment']['tmp_name']) && !empty($_FILES['b2b_attachment']['tmp_name'])) {
            $ext = Tools::substr($_FILES['b2b_attachment']['name'], strrpos($_FILES['b2b_attachment']['name'], '.') + 1);
            if (!in_array(Tools::strtolower($ext), $allowed_extensions)) {
                $field->setValue($_FILES['b2b_attachment']['tmp_name']);
                $field->setErrors(array($this->l('Not valid extension')));
            } else {
                $field->setValue($_FILES['b2b_attachment']['tmp_name']);
            }
        } elseif (Configuration::get(Tools::strtoupper($this->name).'_REQATTACHMENT')) {
            $showupload = Configuration::get(Tools::strtoupper($this->name).'_HASATTACHMENT');
            if ($showupload) {
                $reqattachment = Configuration::get(Tools::strtoupper($this->name).'_REQATTACHMENT');
            } else {
                $reqattachment = 0;
            }
            if($reqattachment) {
                $field->setErrors(array($this->l('The file is required')));
            }
        }
        return array($field);
    }

    public function hookDisplayBackOfficeHeader()
    {
        $this->context->controller->addCSS($this->_path.'views/css/dashback.css');
        if (Tools::getValue('configure') == 'idxvalidatinguser') {
            $this->context->controller->addJQuery();
            $this->context->controller->addCSS($this->_path.'views/css/back.css');
            $this->context->controller->addCSS($this->_path.'views/css/idxvalidatinguser.css', 'all');
            Media::addJsDef(array(
                'AdminIdxvalidatinguser' => $this->context->link->getAdminLink('AdminIdxvalidatinguser'),
                'msgSuccessGroup' => $this->l('Data saved'),
                'msgErrorsGroup' => $this->l('An error ocurred while saveing data'),
                'showDeleteButton' => file_exists(dirname(__FILE__). '/attach_files/'.$this->file_name.'_shop.zip')?true:false,
                'img_path' => _MODULE_DIR_ . 'idxvalidatinguser/views/img/trash.png',
                'confirmMsg' => $this->l('Are you sure delete this file?'),
                'successMsg' => $this->l('ZIP file have been deleted.'),
                'errorMsg' => $this->l('A problem ocurred while deleteing ZIP file.'),
            ));

            $this->context->controller->addJS($this->_path.'views/js/back.js');
//            $this->smarty->assign(array(
//                        'img_path' => _MODULE_DIR_ . 'idxvalidatinguser/views/img/trash.png',
//                        'confirm' => $this->l('Are you sure delete this file?'),
//                        'registroValidadoDir' => _MODULE_DIR_,
//                        'successMsg' => $this->l('ZIP file have been deleted.'),
//                        'errorMsg' => $this->l('A problem ocurred while deleteing ZIP file.'),
//                        'showImg' => file_exists(dirname(__FILE__). '/attach_files/'.$this->file_name.'_shop.zip')?true:false,
//            ));
//
//            return $this->display(__FILE__, 'views/templates/front/conf.tpl');
        }
    }

    public function postProcess()
    {
        $languages = Language::getLanguages(false);


        if (Tools::isSubmit('id_configuration') || Tools::getIsset(Tools::getValue('submitSettings'))) {
            if (!Tools::isEmpty('id_configuration') && Tools::getValue('delete_user') == 0) {
                $id_customer = Tools::getValue('id_configuration');

                if (!Db::getInstance()->Execute('UPDATE `'._DB_PREFIX_.'customer` SET active = 1 WHERE id_customer = "'.(int)$id_customer.'"')) {
                    return $this->displayError($this->l(('The customer cant\'t be enabled')));
                } else {
                    // Enviar mail al usuario.
                    $customer_to_mail = new Customer($id_customer);
                    if ($this->sendActivationEmail($customer_to_mail->email, $customer_to_mail->id_lang)) {
                        return $this->displayConfirmation($this->l('The user have been activated.'));
                    }
                }
            }

            if (!Tools::isEmpty('id_configuration') && Tools::getValue('delete_user') == 1) {
                $id_customer = Tools::getValue('id_configuration');
                $customer = new Customer($id_customer);
                if ($customer->delete()) {
                    return $this->displayConfirmation($this->l('The user have been deleted.'));
                }
            }
        }

        if (Tools::isSubmit('submitSettingsRegister')) {
            $msg_sign_in = array();
            $msg_log_in = array();
            foreach ($languages as $language) {
                $msg_sign_in[$language['id_lang']] = Tools::htmlentitiesUTF8(Tools::getValue(Tools::strtoupper($this->name).'_REGISTERED_MSG_'.$language['id_lang']));
                $msg_log_in[$language['id_lang']] = Tools::htmlentitiesUTF8(Tools::getValue(Tools::strtoupper($this->name).'_BEFOREREGISTER_MSG_'.$language['id_lang']));
            }

            Configuration::updateValue(Tools::strtoupper($this->name).'_MOREINFO', $msg_sign_in);
            Configuration::updateValue(Tools::strtoupper($this->name).'_ALERT', $msg_log_in);
            return $this->displayConfirmation($this->l('The settings have been updated.'));
        }

        if (Tools::isSubmit('submitSettingsTemplate')) {
            $custom_mail = array();
            foreach ($languages as $language) {
                $custom_mail[$language['id_lang']] = Tools::htmlentitiesUTF8(Tools::getValue(Tools::strtoupper($this->name).'_MAIL_'.$language['id_lang']));
            }


            Configuration::updateValue(Tools::strtoupper($this->name).'_MAIL', $custom_mail);
            Configuration::updateValue(Tools::strtoupper($this->name).'_TEMPLATE', Tools::getValue(Tools::strtoupper($this->name).'_TEMPLATE'));
            return $this->displayConfirmation($this->l('The settings have been updated.'));
        }

        if (Tools::isSubmit('submitSettingsFile')) {
            $extension = array('.zip');
            $file_attachment = Tools::fileAttachment(Tools::strtoupper($this->name). '_FILE');

            if (!empty($file_attachment['name']) && !in_array(Tools::strtolower(Tools::substr($file_attachment['name'], -4)), $extension) && !in_array(Tools::strtolower(Tools::substr($file_attachment['name'], -5)), $extension)) {
                return $this->displayError($this->l('Please, upload a ZIP file.'));
            } elseif ($file_attachment['size'] > 15728640) {
                return $this->displayError($this->l('ZIP size must be 15 MB max.'));
            }

            if (!move_uploaded_file($file_attachment['tmp_name'], dirname(__FILE__). '/attach_files/'.$this->file_name.'_shop.zip')) {
                return $this->displayError($this->l('A problem ocurred while uploading ZIP.'));
            }

            return $this->displayConfirmation($this->l('ZIP have been uploaded.'));
        }


        if (Tools::isSubmit('submitAdminMail')) {
            if (!Validate::isEmail(Tools::getValue(Tools::strtoupper($this->name).'_ADMN_MAIL'))) {
                return $this->displayError($this->l('Please, set a valid email.'));
            }

            Configuration::updateValue(Tools::strtoupper($this->name).'_ADMN_MAIL', Tools::getValue(Tools::strtoupper($this->name).'_ADMN_MAIL'));
            return $this->displayConfirmation($this->l('The settings have been updated.'));
        }


        if (Tools::isSubmit('submitSetCustomerAttach')) {
            Configuration::updateValue(Tools::strtoupper($this->name).'_HASATTACHMENT', Tools::getValue(Tools::strtoupper($this->name).'_HASATTACHMENT'));
//            if (!Configuration::get(Tools::strtoupper($this->name).'_WHOLESALEFORM')) {
//                Configuration::updateValue(Tools::strtoupper($this->name).'_REQATTACHMENT', 0);
//            } else {
                Configuration::updateValue(Tools::strtoupper($this->name).'_REQATTACHMENT', Tools::getValue(Tools::strtoupper($this->name).'_REQATTACHMENT'));
            //}
            $file_message = array();
            foreach ($languages as $language) {
                $file_message[$language['id_lang']] = Tools::htmlentitiesUTF8(Tools::getValue(Tools::strtoupper($this->name).'_FILEMESSAGE_'.$language['id_lang']));
            }
            Configuration::updateValue(Tools::strtoupper($this->name).'_FILEMESSAGE', $file_message);
            return $this->displayConfirmation($this->l('The settings have been updated.'));
        }
        
        if (Tools::isSubmit('submitSetRetailerAllow')) {
            Configuration::updateValue(Tools::strtoupper($this->name).'_RETAILERALLOW', Tools::getValue(Tools::strtoupper($this->name).'_RETAILERALLOW'));
            Configuration::updateValue(Tools::strtoupper($this->name).'_RETAILERGROUP', Tools::getValue(Tools::strtoupper($this->name).'_RETAILERGROUP'));
            Configuration::updateValue(Tools::strtoupper($this->name).'_WHOLEGROUP', Tools::getValue(Tools::strtoupper($this->name).'_WHOLEGROUP'));
//            if (!Tools::getValue(Tools::strtoupper($this->name).'_WHOLESALEFORM') && Configuration::get(Tools::strtoupper($this->name).'_REQATTACHMENT')) {
//                Configuration::updateValue(Tools::strtoupper($this->name).'_REQATTACHMENT', 0);
//            }
            Configuration::updateValue(Tools::strtoupper($this->name).'_WHOLESALEFORM', Tools::getValue(Tools::strtoupper($this->name).'_WHOLESALEFORM'));
            return $this->displayConfirmation($this->l('The settings have been updated.'));
        }

        return '';
    }

    public function getContent()
    {
        $output = $this->innovaTitle();
        $output .= $this->postProcess() . $this->renderForm();
        return $output;
    }


    public function listOfCustomer()
    {
        $selectAllConfiguration = $this->deluxeGetCustomers();
        $select = array();

        foreach ($selectAllConfiguration as $key => $value) {
            $select[$key]['id_configuration'] = $value['id_customer'];
            $select[$key]['name'] = $value['firstname']. ' '.$value['lastname'];
            $select[$key]['description'] = $value['email'];
            $select[$key]['b2bdoc'] = $value['b2doc'];
            $select[$key]['group'] = $value['id_default_group'];
        }

        $this->smarty->assign(array(
            'registroValidadoDir' => _MODULE_DIR_,
            'activation_customers' => $select,
            'ps_version' => Tools::substr(_PS_VERSION_, 0, -4),
            'token' => Tools::getValue('token'),
            'es15' => $this->es15,
            'shop_groups' => Group::getGroups($this->context->language->id, $this->context->shop->id),
            'msgSuccessGroup' => $this->l('Data saved'),
            'msgErrorsGroup' => $this->l('An error ocurred while saving data'),
        ));
        return $this->display(__FILE__, 'views/templates/admin/activation.tpl');
    }
    
    public function listOfDocs()
    {
        $selectAllConfiguration = $this->deluxeGetDocCustomers();
        $select = array();

        foreach ($selectAllConfiguration as $key => $value) {
            $select[$key]['id_configuration'] = $value['id_customer'];
            $select[$key]['name'] = $value['firstname']. ' '.$value['lastname'];
            $select[$key]['description'] = $value['email'];
            $select[$key]['b2bdoc'] = $value['b2doc'];
            $select[$key]['group'] = $value['id_default_group'];
        }

        $this->smarty->assign(array(
            'activation_customers' => $select,
            'ps_version' => Tools::substr(_PS_VERSION_, 0, -4),
            'token' => Tools::getValue('token'),
            'es15' => $this->es15,
            'shop_groups' => Group::getGroups($this->context->language->id, $this->context->shop->id),
            'msgSuccessGroup' => $this->l('Data saved'),
            'msgErrorsGroup' => $this->l('An error ocurred while saving data'),
        ));
        return $this->display(__FILE__, 'views/templates/admin/doclist.tpl');
    }
    
    public function hookDashboardZoneOne($params)
    {
        $numPending = count($this->deluxeGetCustomers());
        
        $this->smarty->assign(array(
            'numPending' => $numPending,
        ));
                
        return  $this->display(__FILE__, 'views/templates/admin/dashwidget.tpl');
    }
    
    public function renderForm()
    {
        return InnovaTools::adminTabWrap($this);
    }

    public function helpGenerateForm()
    {
        return $this->renderFormAllowB2C() .
        $this->renderFormSetCustomerAttach() .
        $this->renderFormMessageAfterRegister();
    }

    public function renderFormAllowB2C()
    {
        $id_lang = $this->context->language->id;
        $cust_groups = Group::getGroups($id_lang);
        $fields_form = array(
                'form' => array(
                        'tinymce' => true,
                        'legend' => array(
                                'title' => $this->l('Allow retailer customer'),
                                'icon' => 'icon-cogs'
                        ),
                        'input' => array(
                            array(
                                'type' => 'switch',
                                'label' => $this->l('Allow retailer customers registration'),
                                'name' => Tools::strtoupper($this->name) . '_RETAILERALLOW',
                                'required' => false,
                                'class' => 't',
                                'is_bool' => true,
                                'values' => array(
                                    array(
                                        'id' => 'active_on',
                                        'value' => 1,
                                        'label' => $this->l('Disable Retailer Register')
                                    ),
                                    array(
                                        'id' => 'active_off',
                                        'value' => 0,
                                        'label' => $this->l('Allow Retailer Register')
                                    )
                                ),
                                'desc' => $this->l('This option allow to register retailer customer')
                            ),
                            array(
                                'type' => 'switch',
                                'label' => $this->l('Wholesale registration from separate form'),
                                'name' => Tools::strtoupper($this->name) . '_WHOLESALEFORM',
                                'required' => false,
                                'class' => 't',
                                'is_bool' => true,
                                'values' => array(
                                    array(
                                        'id' => 'active_on',
                                        'value' => 1,
                                        'label' => $this->l('Disable Wholesale registration from separate form')
                                    ),
                                    array(
                                        'id' => 'active_off',
                                        'value' => 0,
                                        'label' => $this->l('Allow Wholesale registration from separate form')
                                    )
                                ),
                                'desc' => $this->l('This option allow to register wholesale clients from separate form that retail customer registration form')
                            ),
                            array(
                                'type' => 'select',
                                'lang' => false,
                                'label' => $this->l('Default group for Retailers'),
                                'name' => Tools::strtoupper($this->name) . '_RETAILERGROUP',
                                'desc' => $this->l('The retailers customers will be included in this group.'),
                                'options' => array(
                                  'query' => $cust_groups,
                                  'id' => 'id_group',
                                  'name' => 'name'
                                ),
                            ),
                            array(
                                'type' => 'select',
                                'lang' => false,
                                'label' => $this->l('Default group for Wholesalers'),
                                'name' => Tools::strtoupper($this->name) . '_WHOLEGROUP',
                                'desc' => $this->l('The wholesalers customers will be included in this group.'),
                                'options' => array(
                                  'query' => $cust_groups,
                                  'id' => 'id_group',
                                  'name' => 'name'
                                ),
                            ),
                        ),
                        'submit' => array(
                                'title' => $this->l('Save'),
                                'class' => 'btn btn-default')
                ),
        );

        return $this->helperCreator('submitSetRetailerAllow', $fields_form);
    }

    public function renderFormSetCustomerAttach()
    {
        $fields_form = array(
                'form' => array(
                        'tinymce' => true,
                        'legend' => array(
                                'title' => $this->l('Allow Documentation'),
                                'icon' => 'icon-cogs'
                        ),
                        'input' => array(
                            array(
                                   'type' => 'switch',
                                   'label' => $this->l('Allow attach documentation'),
                                   'name' => Tools::strtoupper($this->name) . '_HASATTACHMENT',
                                   'required' => false,
                                   'class' => 't',
                                   'is_bool' => true,
                                   'values' => array(
                                       array(
                                           'id' => 'active_on',
                                           'value' => 1,
                                           'label' => $this->l('Disable Documentation')
                                       ),
                                       array(
                                           'id' => 'active_off',
                                           'value' => 0,
                                           'label' => $this->l('Allow Documentation')
                                       )
                                   ),
                                   'desc' => $this->l('This option allow customer to attach documentation on registration form')
                            ),
                            array(
                                   'type' => 'switch',
                                   'label' => $this->l('Documentation Required'),
                                   'name' => Tools::strtoupper($this->name) . '_REQATTACHMENT',
                                   'required' => false,
                                   'class' => 't',
                                   'is_bool' => true,
                                   'values' => array(
                                       array(
                                           'id' => 'active_on',
                                           'value' => 1,
                                           'label' => $this->l('Disable Documentation Required')
                                       ),
                                       array(
                                           'id' => 'active_off',
                                           'value' => 0,
                                           'label' => $this->l('Enable Documentation Required')
                                       )
                                   ),
                                   'desc' => $this->l('This option set if the documentation attachment field is required')
                            ),
                            array(
                                'type' => 'text',
                                'lang' => true,
                                'label' => $this->l('Message before attach file input form'),
                                'name' => Tools::strtoupper($this->name). '_FILEMESSAGE',
                                'desc' => $this->l('This message will be show just before documentation request'),
                            ),
                               
                        ),
                        'submit' => array(
                                'title' => $this->l('Save'),
                                'class' => 'btn btn-default')
                ),
        );

        return $this->helperCreator('submitSetCustomerAttach', $fields_form);
    }

    public function renderFormMessageAfterRegister()
    {
        $fields_form = array(
                'form' => array(
                        'tinymce' => true,
                        'legend' => array(
                                'title' => $this->l('Sign in Message Configuration'),
                                'icon' => 'icon-cogs'
                        ),
                        'input' => array(
                                array(
                                        'type' => 'textarea',
                                        'lang' => true,
                                        'rows' => 10,
                                        'col' => 7,
                                        'autoload_rte' => true,
                                        'label' => $this->l('Before Register Message'),
                                        'name' => Tools::strtoupper($this->name). '_BEFOREREGISTER_MSG',
                                        'desc' => $this->l('This message will be displayed when a client  try to register'),
                                ),
                                array(
                                        'type' => 'textarea',
                                        'lang' => true,
                                        'rows' => 10,
                                        'col' => 7,
                                        'autoload_rte' => true,
                                        'label' => $this->l('Registered message'),
                                        'name' => Tools::strtoupper($this->name). '_REGISTERED_MSG',
                                        'desc' => $this->l('This message will be displayed when registered user try to sign in'),
                                ),
                        ),
                        'submit' => array(
                                'title' => $this->l('Save'),
                                'class' => 'btn btn-default')
                ),
        );

        return $this->helperCreator('submitSettingsRegister', $fields_form);
    }

    public function renderFormAdminEmail()
    {
        $fields_form = array(
                'form' => array(
                        'tinymce' => true,
                        'legend' => array(
                                'title' => $this->l('Admin Email'),
                                'icon' => 'icon-cogs'
                        ),
                        'input' => array(

                                array(
                                    'type' => 'text',
                                    'label' => $this->l('Admin Email'),
                                    'name' => Tools::strtoupper($this->name). '_ADMN_MAIL',
                                    'desc' => $this->l('Alerts will be sent to this mail. Empty for use shop configuration mail'),
                                    'class' => 'fixed-xl',
                                ),
                        ),
                        'submit' => array(
                                'title' => $this->l('Save'),
                                'class' => 'btn btn-default')
                ),
        );

        return $this->helperCreator('submitAdminMail', $fields_form);
    }

    public function renderCustomTemplate()
    {
        $fields_form = array(
                'form' => array(
                        'tinymce' => true,
                        'legend' => array(
                                'title' => $this->l('Custom template mail'),
                                'icon' => 'icon-cogs'
                        ),
                        'input' => array(
                                array(
                                    'type' => 'radio',
                                    'label' => $this->l('Would you like to send custom template to users?'),
                                    'name' => Tools::strtoupper($this->name). '_TEMPLATE',
                                    'values' => array(
                                        array(
                                            'id' => 'yes',
                                            'value' => 1,
                                            'label' => $this->l('Yes')
                                        ),
                                        array(
                                            'id' => 'no',
                                            'value' => 0,
                                            'label' => $this->l('No')
                                        ),
                                    )
                                ),
                                array(
                                    'type' => 'textarea',
                                    'lang' => true,
                                    'rows' => 10,
                                    'col' => 7,
                                    'autoload_rte' => true,
                                    'label' => $this->l('Custom content for custom mail template'),
                                    'name' => Tools::strtoupper($this->name). '_MAIL',
                                    'desc' => $this->l('This message will be displayed after registered user by email'),
                                ),
                        ),
                        'submit' => array(
                                'title' => $this->l('Save'),
                                'class' => 'btn btn-default')
                ),
        );

        return $this->helperCreator('submitSettingsTemplate', $fields_form);
    }


    public function renderFormAttachFile()
    {
        $fields_form = array(
                'form' => array(
                        'tinymce' => true,
                        'legend' => array(
                                'title' => $this->l('Email Attachment'),
                                'icon' => 'icon-cogs'
                        ),
                        'input' => array(
                            array(
                                'type' => 'file',
                                'label' => $this->l('Attach ZIP file (15 MB max)'),
                                'name' => Tools::strtoupper($this->name). '_FILE',
                                'hint' => $this->l('You be able to attach a ZIP file in customer response that  requesting an account in your shop'),
                                //'thumb' => '../modules/'.$this->name.'/views/img/trash.png',
                            )
                        ),
                        'submit' => array(
                                'title' => $this->l('Save'),
                                'class' => 'btn btn-default')
                ),
        );

        return $this->helperCreator('submitSettingsFile', $fields_form);
    }

    private function helperCreator($submitAction, $fields_form)
    {
        $languages = Language::getLanguages(false);
        foreach ($languages as $k => $language) {
            $languages[$k]['is_default'] = (int)$language['id_lang'] == Configuration::get('PS_LANG_DEFAULT');
        }
        $helper = new HelperForm();
        $helper->show_toolbar = false;
        $helper->table =  $this->table;
        $lang = new Language((int)Configuration::get('PS_LANG_DEFAULT'));
        $helper->default_form_language = $lang->id;
        $helper->languages = $languages;
        $helper->allow_employee_form_lang = Configuration::get('PS_BO_ALLOW_EMPLOYEE_FORM_LANG') ? Configuration::get('PS_BO_ALLOW_EMPLOYEE_FORM_LANG') : 0;
        $helper->identifier = $this->identifier;
        $helper->submit_action = $submitAction;
        $helper->currentIndex = $this->context->link->getAdminLink('AdminModules', false).'&configure='.$this->name.'&tab_module='.$this->tab.'&module_name='.$this->name;
        $helper->token = Tools::getAdminTokenLite('AdminModules');
        $helper->tpl_vars = array(
                'fields_value' => $this->getConfigFieldsValues(),
                'languages' => $this->context->controller->getLanguages(),
                'id_language' => $this->context->language->id
        );

        return $helper->generateForm(array($fields_form));
    }

    public function getConfigFieldsValues()
    {
        $languages = Language::getLanguages(false);
        $msg_sign_in = array();
        $msg_log_in = array();
        $custom_content_mail = array();
        $msg_wholesale = array();

        foreach ($languages as $language) {
            $msg_sign_in[$language['id_lang']] = Tools::htmlentitiesDecodeUTF8(Configuration::get(Tools::strtoupper($this->name).'_MOREINFO', $language['id_lang']));
            $msg_log_in[$language['id_lang']] = Tools::htmlentitiesDecodeUTF8(Configuration::get(Tools::strtoupper($this->name).'_ALERT', $language['id_lang']));
            $custom_content_mail[$language['id_lang']] = Tools::htmlentitiesDecodeUTF8(Configuration::get(Tools::strtoupper($this->name).'_MAIL', $language['id_lang']));
            $msg_wholesale[$language['id_lang']] = Tools::htmlentitiesDecodeUTF8(Configuration::get(Tools::strtoupper($this->name).'_FILEMESSAGE', $language['id_lang']));
        }

        return array(
            Tools::strtoupper($this->name). '_REGISTERED_MSG' => Tools::getValue(Tools::strtoupper($this->name). '_REGISTERED_MSG', $msg_sign_in),
            Tools::strtoupper($this->name). '_BEFOREREGISTER_MSG' => Tools::getValue(Tools::strtoupper($this->name). '_BEFOREREGISTER_MSG', $msg_log_in),
            Tools::strtoupper($this->name). '_FILEMESSAGE' => Tools::getValue(Tools::strtoupper($this->name). '_FILEMESSAGE', $msg_wholesale),
            Tools::strtoupper($this->name). '_MAIL' => Tools::getValue(Tools::strtoupper($this->name). '_MAIL', $custom_content_mail),
            Tools::strtoupper($this->name). '_TEMPLATE' => Tools::getValue(Tools::strtoupper($this->name). '_TEMPLATE', Configuration::get(Tools::strtoupper($this->name).'_TEMPLATE')),
            Tools::strtoupper($this->name). '_ADMN_MAIL' => Tools::getValue(Tools::strtoupper($this->name). '_ADMN_MAIL', Configuration::get(Tools::strtoupper($this->name).'_ADMN_MAIL')),
            Tools::strtoupper($this->name). '_HASATTACHMENT' => Tools::getValue(Tools::strtoupper($this->name). '_HASATTACHMENT', Configuration::get(Tools::strtoupper($this->name).'_HASATTACHMENT')),
            Tools::strtoupper($this->name). '_REQATTACHMENT' => Tools::getValue(Tools::strtoupper($this->name). '_REQSATTACHMENT', Configuration::get(Tools::strtoupper($this->name).'_REQATTACHMENT')),
            Tools::strtoupper($this->name). '_RETAILERALLOW' => Tools::getValue(Tools::strtoupper($this->name). '_RETAILERALLOW', Configuration::get(Tools::strtoupper($this->name).'_RETAILERALLOW')),
            Tools::strtoupper($this->name). '_RETAILERGROUP' => Tools::getValue(Tools::strtoupper($this->name). '_RETAILERGROUP', Configuration::get(Tools::strtoupper($this->name).'_RETAILERGROUP')),
            Tools::strtoupper($this->name). '_WHOLEGROUP' => Tools::getValue(Tools::strtoupper($this->name). '_WHOLEGROUP', Configuration::get(Tools::strtoupper($this->name).'_WHOLEGROUP')),
            Tools::strtoupper($this->name). '_WHOLESALEFORM' => Tools::getValue(Tools::strtoupper($this->name). '_WHOLESALEFORM', Configuration::get(Tools::strtoupper($this->name).'_WHOLESALEFORM')),
        );
    }

    public static function deluxeGetCustomers()
    {
        $sql = 'SELECT `id_customer`, `email`, `firstname`, `lastname`, `id_default_group`
				FROM `'._DB_PREFIX_.'customer`
				WHERE 1 '.Shop::addSqlRestriction(Shop::SHARE_CUSTOMER).' AND active <> 1
				ORDER BY `id_customer` DESC';
        $customers = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($sql);
        $toValidate = array();
        foreach ($customers as $id_customer) {
            $file_name = md5($id_customer['id_customer'] . '_nodoc').'.txt';
            $nomd5_file_name = $id_customer['id_customer'] . '_nodoc'.'.txt';
            if (file_exists(dirname(__FILE__). '/attach_files/'.$file_name) || file_exists(dirname(__FILE__). '/attach_files/'.$nomd5_file_name)) {
                $id_customer['b2doc'] = 'nodoc';
                $toValidate[] = $id_customer;
            } else {
                $allowed_extensions=array('pdf','doc','docx','txt','zip','rar','jpg','png');
                foreach ($allowed_extensions as $ext) {
                    $file_name = md5($id_customer['id_customer'] . '_documentation').'.'.$ext;
                    $nomd5_file_name = $id_customer['id_customer'] . '_documentation'.'.'.$ext;
                    if (file_exists(dirname(__FILE__). '/attach_files/'.$file_name) || file_exists(dirname(__FILE__). '/attach_files/'.$nomd5_file_name)) {
                        if (file_exists(dirname(__FILE__). '/attach_files/'.$file_name)) {
                            $id_customer['b2doc'] = _PS_BASE_URL_.__PS_BASE_URI__.'modules/idxvalidatinguser/attach_files/'.$file_name;
                        }
                        if (file_exists(dirname(__FILE__). '/attach_files/'.$nomd5_file_name)) {
                            $id_customer['b2doc'] = _PS_BASE_URL_.__PS_BASE_URI__.'modules/idxvalidatinguser/attach_files/'.$nomd5_file_name;
                        }
                        $toValidate[] = $id_customer;
                    }
                }
                //si sigue sin tener documentación, determinamos que es un cliente sin documentación adjunta "sin nombre"
                if (!isset($id_customer['b2doc'])) {
                    $id_customer['b2doc'] = 'nodoc';
                    $toValidate[] = $id_customer;
                }
            }
        }

        return $toValidate;
    }
    
    public static function deluxeGetDocCustomers()
    {
        $sql = 'SELECT `id_customer`, `email`, `firstname`, `lastname`, `id_default_group`
				FROM `'._DB_PREFIX_.'customer`
				WHERE 1 '.Shop::addSqlRestriction(Shop::SHARE_CUSTOMER).' 
				ORDER BY `id_customer` DESC';
        $customers = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($sql);
        $toValidate = array();
        foreach ($customers as $id_customer) {
            $file_name = md5($id_customer['id_customer'] . '_nodoc').'.txt';
            $nomd5_file_name = $id_customer['id_customer'] . '_nodoc'.'.txt';
            if (!(file_exists(dirname(__FILE__). '/attach_files/'.$file_name) || file_exists(dirname(__FILE__). '/attach_files/'.$nomd5_file_name))) {
                $allowed_extensions=array('pdf','doc','docx','txt','zip','rar','jpg','png');
                foreach ($allowed_extensions as $ext) {
                    $file_name = md5($id_customer['id_customer'] . '_documentation').'.'.$ext;
                    $nomd5_file_name = $id_customer['id_customer'] . '_documentation'.'.'.$ext;
                    if (file_exists(dirname(__FILE__). '/attach_files/'.$file_name) || file_exists(dirname(__FILE__). '/attach_files/'.$nomd5_file_name)) {
                        if (file_exists(dirname(__FILE__). '/attach_files/'.$file_name)) {
                            $id_customer['b2doc'] = _PS_BASE_URL_.__PS_BASE_URI__.'modules/idxvalidatinguser/attach_files/'.$file_name;
                        }
                        if (file_exists(dirname(__FILE__). '/attach_files/'.$nomd5_file_name)) {
                            $id_customer['b2doc'] = _PS_BASE_URL_.__PS_BASE_URI__.'modules/idxvalidatinguser/attach_files/'.$nomd5_file_name;
                        }
                        $toValidate[] = $id_customer;
                    }
                }
            }
        }

        return $toValidate;
    }

    protected function sendActivationEmail($email, $lang = false)
    {
        if (!$lang) {
            $lang = $this->context->language->id;
        }
        return Mail::Send($lang, 'privateactivation',  Mail::l('Notifying of enabled account.', $lang), array(), pSQL($email), null, null, null, null, null, dirname(__FILE__).'/mails/', false, $this->context->shop->id);
    }
    
    public function backMailWrapTab()
    {
        return $this->renderFormAdminEmail() .
        $this->renderCustomTemplate().
        $this->renderFormAttachFile();
    }
    
    public function setInnovaTabs()
    {
        $isoLinks = InnovaTools::getIsoLinks($this);
        $this->innovatabs = array();
        $active = true;
        
        if (Tools::getValue('validatelist') ||
            Tools::isSubmit('id_configuration') ||
            Tools::getIsset(Tools::getValue('submitSettings')) ||
            Tools::isSubmit('submitSettingsFile') ||
            Tools::isSubmit('submitSettingsTemplate') ||
            Tools::isSubmit('submitAdminMail')) {
            $active=false;
        } else {
            $active=true;
        }
        $this->innovatabs [] = array(
                "title" => $this->l('Configuration'),
                "icon" => "wrench",
                "link" => "helpGenerateForm",
                "type" => "tab",
                "show" => "both",
                "active" => $active,
            );
        if (Tools::isSubmit('submitSettingsFile') ||
            Tools::isSubmit('submitSettingsTemplate') ||
            Tools::isSubmit('submitAdminMail')) {
            $active=true;
        } else {
            $active=false;
        }
        $this->innovatabs [] = array(
                "title" => $this->l('E-mail Preferences'),
                "icon" => "envelope",
                "link" => "backMailWrapTab",
                "type" => "tab",
                "show" => "both",
                "active" => $active,
            );
        if (Tools::getValue('validatelist') || Tools::isSubmit('id_configuration') || Tools::getIsset(Tools::getValue('submitSettings'))) {
            $active=true;
        } else {
            $active = false;
        }
        $this->innovatabs [] = array(
                "title" => $this->l('Customers Activation'),
                "icon" => "check",
                "link" => "listOfCustomer",
                "type" => "tab",
                "show" => "both",
                "active" => $active,
            );
        $this->innovatabs [] = array(
                "title" => $this->l('Customers Documentation'),
                "icon" => "check",
                "link" => "listOfDocs",
                "type" => "tab",
                "show" => "both",
            );
        $this->innovatabs [] = array(
                "title" => $this->l('Documentation'),
                "icon" => "file",
                "link" => $this->doclink,
                "type" => "doc",
                "show" => "both",
            );
        $this->innovatabs [] = array(
                "title" => $this->l('Support'),
                "icon" => "life-saver",
                "link" => $isoLinks["support"],
                "type" => "url",
                "show" => "whmcs",
            );
            /*
        $this->innovatabs [] = array(
                "title" => $this->l('Opinion'),
                "icon" => "comments",
                "link" => $isoLinks["ratings"],
                "type" => "url",
                "show" => "both",
            );
            */
            /*
        $this->innovatabs [] = array(
                "title" => $this->l('Certified Agency'),
                "icon" => "trophy",
                "link" => $isoLinks["certified"],
                "type" => "url",
                "show" => "addons",
            );
            */
        $this->innovatabs [] = array(
                "title" => $this->l('Our Modules'),
                "icon" => "cubes",
                "link" => $isoLinks["ourmodules"],
                "type" => "url",
                "show" => "both",
            );
    }

    public function innovaTitle()
    {
        //tabs version
        $innovaTabs = "";
        if (method_exists(get_class($this), "setInnovaTabs")) {
            $innovaTabs=$this->setInnovaTabs();
        }
        $this->smarty->assign(array(
            "module_dir" => $this->_path,
            "module_name" => $this->displayName,
            "module_description" => $this->description,
            "isoLinks" => InnovaTools::getIsoLinks($this),
            "isAddons" => InnovaTools::isAddons($this),
            "tabs" => InnovaTools::getVersionTabs($this),
        ));

        $this->context->controller->addCSS(($this->_path)."views/css/backinnova.css", "all");
        return $this->display(__FILE__, "views/templates/admin/innova-title.tpl");
    }

    public function notValidated($mail)
    {
        $sql = 'SELECT `email`, `active` FROM `'._DB_PREFIX_.'customer` WHERE `email` = \''.pSQL($mail).'\' ';
        $user_registered = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS($sql);

        if (@$user_registered[0]['email'] && $user_registered[0]['active'] == 0) {
            return 1;
        }
        return 0;
    }

    public function deleteFileAjax()
    {
        if ($file = dirname(__FILE__). '/attach_files/'.$this->file_name.'_shop.zip') {
            if (unlink($file)) {
                return true;
            }
        }
        return false;
    }

    public function assignCustomerToGroup($idCustomer, $idGroup)
    {
        $customer = new Customer($idCustomer);
        $customer->addGroups(array($idGroup));
        $customer->id_default_group = $idGroup;
        if ($customer->update()) {
            return true;
        }
        return false;
    }
}

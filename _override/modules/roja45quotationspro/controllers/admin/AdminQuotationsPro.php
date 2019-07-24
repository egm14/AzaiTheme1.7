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

class AdminQuotationsProControllerOverride extends AdminQuotationsProController
{
   /**
     * ajaxProcessLoadCustomerQuotation - Retrieve a customer's request
     *
     * @return json
     *
     */
    public function ajaxProcessLoadCustomerQuotation()
    {
        $theme_path = _PS_THEME_DIR_;

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
                   'send_quote.tpl');
              
                
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

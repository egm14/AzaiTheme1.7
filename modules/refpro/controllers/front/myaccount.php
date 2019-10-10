<?php
/**
 * 2007-2017 PrestaShop
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License (AFL 3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/afl-3.0.php
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@prestashop.com so we can send you a copy immediately.
 *
 * DISCLAIMER
 *
 * Do not edit or add to this file if you wish to upgrade PrestaShop to newer
 * versions in the future. If you wish to customize PrestaShop for your
 * needs please refer to http://www.prestashop.com for more information.
 *
 * @author    PrestaShop SA    <contact@prestashop.com>
 * @copyright 2007-2017 PrestaShop SA
 * @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
 * International Registered Trademark & Property of PrestaShop SA
 */

use RefPro\QRCode\QRCode;
use RefPro\QRCode\QROptions;

require_once __DIR__.'/../../lib/QRCode.php';
require_once __DIR__.'/../../lib/QROptions.php';

class RefProMyAccountModuleFrontController extends ModuleFrontController
{
	/**
	 * @var RefPro
	 */
	public $module;
	public $php_self;
	public $authRedirection;

	/**
	 * @var int[] Map of QR code version to maximum data length in bytes using L ECC encoding
	 */
	protected $qrCodeVersionToMaxLength = array(
		1 => 17,
		2 => 32,
		3 => 53,
		4 => 78,
		5 => 106,
		6 => 134,
		7 => 154,
		8 => 192,
		9 => 230,
		10 => 271,
	);

	public function __construct()
	{
		parent::__construct();

		$this->authRedirection = $this->context->link->getModuleLink('refpro', 'myaccount');

		$this->auth = true;
		$this->ssl = true;

		if (!Referral::isFunctionalityAvailibleForGroup())
			Tools::redirect($this->context->link->getPageLink('authentication', null, null, array(
				'back' => $this->context->link->getModuleLink('refpro', 'myaccount')
			)));

	}

	public function postProcess()
	{
		$s_action = Tools::getValue('action');
		switch ($s_action)
		{
			case 'save_settings':
				for ($i = 1; $i <= 5; $i++)
				{
					$key = 'ps_'.$i;
					if (Tools::getIsset($key) && (Tools::getValue($key) || Tools::getValue($key) == ''))
					{
						$s_custom_value = Tools::getValue($key);
						Referral::saveUserSettings($this->context->customer->id, $key, pSQL($s_custom_value));
					}
				}
				die($this->module->l('Settings saved!', 'myaccount'));
		}

		parent::postProcess();
	}

	public function setMedia()
	{
		parent::setMedia();
		$this->context->controller->addJS($this->module->getPathUri().'views/js/tab_container.js');

		$this->context->controller->addJS($this->module->getPathUri().'views/js/bootstrap-modalmanager.js');
		$this->context->controller->addJS($this->module->getPathUri().'views/js/bootstrap-modal.js');

		ToolsModuleRP::autoloadCSS($this->module->getPathUri().'views/css/autoload/');

		$this->context->controller->addCSS(_THEME_CSS_DIR_.'my-account.css');
		$this->context->controller->addCSS(_THEME_CSS_DIR_.'global.css');
		$this->context->controller->addJS(__PS_BASE_URI__.'js/tools.js');
		$this->context->controller->addJS(__PS_BASE_URI__.'js/jquery/plugins/jquery.easing.js');
		$this->context->controller->addJS(__PS_BASE_URI__.'js/jquery/plugins/autocomplete/jquery.autocomplete.js');
	}

	public function getBreadcrumbLinks()
	{
			$breadcrumb = parent::getBreadcrumbLinks();

			$breadcrumb['links'][] = array(
					'title' => $this->module->l('My account', 'myaccount'),
					'url' => $this->context->link->getPageLink('my-account')
			);

			$breadcrumb['links'][] = array(
					'title' => $this->module->l('Affiliate program', 'myaccount'),
					'url' => ''
			);

			return $breadcrumb;
	}

	public function initContent()
	{
		$this->display_column_left = false;
		parent::initContent();

		if (version_compare(_PS_VERSION_, '1.7', '>='))
			$this->context->controller->addJS($this->module->getPathUri().'views/js/jquery-migrate-1.2.1.min.js');

		$this->context->controller->addJS($this->module->getPathUri().'views/js/framework.js');
		$this->context->controller->addJS($this->module->getPathUri().'views/js/jquery.form.js');
		$this->context->controller->addJS($this->module->getPathUri().'views/js/jquery.fancybox-1.3.4.js');
		$this->context->controller->addJS($this->module->getPathUri().'views/js/refpro.js');

		$this->context->controller->addCSS($this->module->getPathUri().'views/css/refpro.css');
		$this->context->controller->addCSS($this->module->getPathUri().'views/css/framework.css');
		$this->context->controller->addCSS($this->module->getPathUri().'views/css/jquery.fancybox-1.3.4.css');

		$this->context->smarty->assign(array(
			'ifGreateThen15' => version_compare(_PS_VERSION_, '1.5', '>='),
			'ifGreateThen16' => version_compare(_PS_VERSION_, '1.6', '>='),
			'enable_fancybox' => true,
		));

		if (version_compare(_PS_VERSION_, '1.7', '<'))
				$this->context->smarty->assign(array(
					'path' => ToolsModuleRP::fetchTemplate('admin/bread.tpl')
				));
$this->context->smarty->assign(array('user_data' => Referral::getUserData($this->context->customer->id)));
		$this->context->smarty->assign(array(
			'meta_title' => $this->module->l('Affiliate program', 'myaccount').' - '.Configuration::get('PS_SHOP_NAME')
		));
		$s_goref = Tools::getValue('goref');
		if (!empty($s_goref) && Referral::checkNeedCompletedOrders())
		{
			if (Referral::getUserData($this->context->customer->id))
				$result = Db::getInstance()->update('refpro_customer', array(
					'is_sponsor' => 1,
					'active' => (int)(!Referral::getSettings('validation_of_new_affiliates'))
				), 'id = '.(int)$this->context->customer->id);
			else
				$result = Db::getInstance()->insert('refpro_customer', array(
					array('id' => $this->context->customer->id, 'is_sponsor' => 1, 'active' => (int)(!Referral::getSettings('validation_of_new_affiliates')))
				));
		}
		else
		{
			$query_str = 'SELECT * FROM '._DB_PREFIX_.'refpro_customer WHERE id = '.(int)$this->context->customer->id.' AND is_sponsor = "1"';
			$result = Db::getInstance()->GetRow($query_str);
		}

		if (!empty($s_goref) || (isset($result) && is_array($result)))
		{
			$link_num = $this->context->link->getPageLink('index.php').'?ref='.$this->context->customer->id;
			$link_char = $this->context->link->getPageLink('index.php').'?ref='.$this->context->customer->email;
			$link_sec = $this->generateSecureLink();
			$this->context->smarty->assign(array(
				'is_sponsor_tmp' => 1 && Referral::checkNeedCompletedOrders(),
				'link_num' => $link_num,
				'link_char' => $link_char,
				'link_sec' => $link_sec,
			));
		}
		if (!empty($s_goref)) $this->context->smarty->assign(array('reload' => 1));
		if (!empty($result['id']))
		{
			$referrals = Referral::getReferrals($this->context->customer->id);
			$referrals = Referral::setProfit($referrals, 1);

			$subrefs = false;
			$subrefs3 = false;
			$subrefs4 = false;
			$subrefs5 = false;
			$subrefs6 = false;
			$subrefs7 = false;
			$subrefs8 = false;
			$subrefs9 = false;

			if (!Referral::getSettings('show_only_direct_affiliates')) {

				//Second level
				if ((int)Referral::getSettings('levels') > 1) {
					$subrefs = Array();
					$count_refs = count($referrals);
					for ($i = 0; $i < $count_refs; $i++) {
						$subref = false;
						$subref = Referral::getReferrals($referrals[$i]['id_customer']);
						if ($subref) {
							$referrals[$i]['sub'] = $subref;
							$subrefs = array_merge($subrefs, $subref);
						}
					}
					if (!empty($subrefs)) $subrefs = Referral::setProfit($subrefs, 2);
				}
				//Third level
				if ((int)Referral::getSettings('levels') > 2) {
					$subrefs3 = Array();
					$count_subrefs = count($subrefs);
					for ($i = 0; $i < $count_subrefs; $i++) {
						$subref = false;
						$subref = Referral::getReferrals($subrefs[$i]['id_customer']);
						if ($subref) {
							$subrefs[$i]['sub'] = $subref;
							$subrefs3 = array_merge($subrefs3, $subref);
						}
					}
					if (!empty($subrefs3)) $subrefs3 = Referral::setProfit($subrefs3, 3);
				}

				//Affiliates of fourth level
				if ((int)Referral::getSettings('levels') > 3) {
					$subrefs4 = Array();
					$count_subrefs3 = count($subrefs3);
					for ($i = 0; $i < $count_subrefs3; $i++) {
						$subref = false;
						$subref = Referral::getReferrals($subrefs3[$i]['id_customer']);
						if ($subref) {
							$subrefs3[$i]['sub'] = $subref;
							$subrefs4 = array_merge($subrefs4, $subref);
						}
					}
					if (!empty($subrefs4)) $subrefs4 = Referral::setProfit($subrefs4, 4);
				}
				//Affiliates of fifth level
				if ((int)Referral::getSettings('levels') > 4) {
					$subrefs5 = Array();
					$count_subrefs4 = count($subrefs4);
					for ($i = 0; $i < $count_subrefs4; $i++) {
						$subref = false;
						$subref = Referral::getReferrals($subrefs4[$i]['id_customer']);
						if ($subref) {
							$subrefs4[$i]['sub'] = $subref;
							$subrefs5 = array_merge($subrefs5, $subref);
						}
					}
					if (!empty($subrefs5)) $subrefs5 = Referral::setProfit($subrefs5, 5);
				}

				if ((int)Referral::getSettings('levels') > 5) {
					$subrefs6 = Array();
					$count_subrefs5 = count($subrefs5);
					for ($i = 0; $i < $count_subrefs5; $i++) {
						$subref = false;
						$subref = Referral::getReferrals($subrefs5[$i]['id_customer']);
						if ($subref) {
							$subrefs5[$i]['sub'] = $subref;
							$subrefs6 = array_merge($subrefs6, $subref);
						}
					}
					if (!empty($subrefs6)) $subrefs6 = Referral::setProfit($subrefs6, 6);
				}

				if ((int)Referral::getSettings('levels') > 6) {
					$subrefs7 = Array();
					$count_subrefs6 = count($subrefs6);
					for ($i = 0; $i < $count_subrefs6; $i++) {
						$subref = false;
						$subref = Referral::getReferrals($subrefs6[$i]['id_customer']);
						if ($subref) {
							$subrefs6[$i]['sub'] = $subref;
							$subrefs7 = array_merge($subrefs7, $subref);
						}
					}
					if (!empty($subrefs7)) $subrefs7 = Referral::setProfit($subrefs7, 7);
				}

				if ((int)Referral::getSettings('levels') > 7) {
					$subrefs8 = Array();
					$count_subrefs7 = count($subrefs7);
					for ($i = 0; $i < $count_subrefs7; $i++) {
						$subref = false;
						$subref = Referral::getReferrals($subrefs7[$i]['id_customer']);
						if ($subref) {
							$subrefs7[$i]['sub'] = $subref;
							$subrefs8 = array_merge($subrefs8, $subref);
						}
					}
					if (!empty($subrefs8)) $subrefs8 = Referral::setProfit($subrefs8, 8);
				}

				if ((int)Referral::getSettings('levels') > 8) {
					$subrefs9 = Array();
					$count_subrefs8 = count($subrefs8);
					for ($i = 0; $i < $count_subrefs8; $i++) {
						$subref = false;
						$subref = Referral::getReferrals($subrefs8[$i]['id_customer']);
						if ($subref) {
							$subrefs8[$i]['sub'] = $subref;
							$subrefs9 = array_merge($subrefs9, $subref);
						}
					}
					if (!empty($subrefs9)) $subrefs9 = Referral::setProfit($subrefs9, 9);
				}

			}

			$user_data = Referral::getUserData($this->context->customer->id);

			$p_systems = Referral::jsonDecode(Referral::getSettings('ps'));
			$p_systems_to_use = Array();
			if (!empty($p_systems))
			{
				foreach ($p_systems as $key => $value)
					$p_systems_to_use[] = array('key' => $key, 'value' => $value);

			}

			$rate_1 = Referral::getBonusRate($this->context->customer->id_default_group, 1);
			$rate_2 = Referral::getBonusRate($this->context->customer->id_default_group, 2);
			$rate_3 = Referral::getBonusRate($this->context->customer->id_default_group, 3);
			$rate_4 = Referral::getBonusRate($this->context->customer->id_default_group, 4);
			$rate_5 = Referral::getBonusRate($this->context->customer->id_default_group, 5);
			$rate_6 = Referral::getBonusRate($this->context->customer->id_default_group, 6);
			$rate_7 = Referral::getBonusRate($this->context->customer->id_default_group, 7);
			$rate_8 = Referral::getBonusRate($this->context->customer->id_default_group, 8);
			$rate_9 = Referral::getBonusRate($this->context->customer->id_default_group, 9);


			$assign_arr = array(
				'money' => round($result['money'], 2),
				'currency_default' => (int)Configuration::get('PS_CURRENCY_DEFAULT'),
				'get_def_currency' => $this->module->getDefCurrency(),
				'referrals' => $referrals,
				'sponsor' => Referral::getSponsor($this->context->customer->id),
				'p_systems' => $p_systems_to_use,
				'user_data' => $user_data,
				'subrefs' => $subrefs,
				'subrefs3' => $subrefs3,
				'subrefs4' => $subrefs4,
				'subrefs5' => $subrefs5,
				'subrefs6' => $subrefs6,
				'subrefs7' => $subrefs7,
				'subrefs8' => $subrefs8,
				'subrefs9' => $subrefs9,
				'rate_1' => $rate_1,
				'ip_installed' => $this->module->ip_installed,
				'payments' => ($this->module->ip_installed?false:Referral::getPayments($this->context->customer->id, 1)),
				'nb_payments' => ($this->module->ip_installed?false:ceil(count(Referral::getPayments($this->context->customer->id)) / 50)),
				'withdrawal_allowed' => !$this->module->ip_installed
			);

			if (Referral::getSettings('levels') > 1) $assign_arr['rate_2'] = $rate_2;
			if (Referral::getSettings('levels') > 2) $assign_arr['rate_3'] = $rate_3;
			if (Referral::getSettings('levels') > 3) $assign_arr['rate_4'] = $rate_4;
			if (Referral::getSettings('levels') > 4) $assign_arr['rate_5'] = $rate_5;
			if (Referral::getSettings('levels') > 5) $assign_arr['rate_6'] = $rate_6;
			if (Referral::getSettings('levels') > 6) $assign_arr['rate_7'] = $rate_7;
			if (Referral::getSettings('levels') > 7) $assign_arr['rate_8'] = $rate_8;
			if (Referral::getSettings('levels') > 8) $assign_arr['rate_9'] = $rate_9;

			$this->context->smarty->assign($assign_arr);
		}

		$is_cust_priv = (bool)Referral::getSettings('cust_priv');
		$need_completed_orders = (int)Referral::getSettings('need_completed_orders');
		$is_need_completed_orders = Referral::checkNeedCompletedOrders();
		$cms_page = new CMS(Referral::getSettings('rules'), $this->context->language->id);
		$alias = null;
		if (Validate::isLoadedObject($cms_page))
			$alias = $cms_page->link_rewrite;
		$rules_url = ((int)Referral::getSettings('rules') ? $this->context->link->getCMSLink(Referral::getSettings('rules'), $alias) : '');
		if ($rules_url)
		{
			$rules_url = $rules_url.(strpos($rules_url, '?') !== false ? '&' : '?').'adtoken='.Tools::encrypt('PreviewCMS'.Referral::getSettings('rules'));
			$this->context->smarty->assign(array('rules' => $rules_url));
		}

		$lngs = Language::getLanguages();
		$lngs_to_replace = array();
		foreach ($lngs as $lng) {
			$lngs_to_replace[] = '/'.$lng['iso_code'].'/';
		}
		$banners = $this->module->getBanners();
		foreach ($banners as $k => $banner) {
			$url = $banners[$k]['url'];
			if (!$url)
				$url = $this->context->link->getPageLink('index.php');
			$banners[$k]['url'] = str_replace($lngs_to_replace, '/'.$this->context->language->iso_code.'/', $url).'?ref='.$this->context->customer->id;
		}
		$this->context->smarty->assign(array(
			'banner_url' => Referral::getSettings('banner_link'),
			'banner_img' => Referral::getSettings('banner_img'),
			'banners' => $banners,
			'hide_left_column' => true,
			'ref_pro_img_dir' => _MODULE_DIR_.$this->module->name.'/views/img/',
			'is_cust_priv' => $is_cust_priv,
			'need_completed_orders' => $need_completed_orders,
			'is_need_completed_orders' => $is_need_completed_orders,
            'voucher_cart_rule' => $this->getReferralCartRule(
                (isset($user_data) ? $user_data : array(
                    'has_voucher' => false
                )
                )
            ),
            'has_voucher' => (isset($user_data) && $user_data['has_voucher'] ? $user_data['has_voucher'] : Referral::getSettings('has_voucher')),
		));

		if (isset($link_sec)) {
			$this->context->smarty->assign(array(
				'qrCodeTargetUrl' => $link_sec,
				'qrCodeInlineUrl' => $this->context->link->getModuleLink(
					'refpro',
					'myaccount',
					array('action' => 'download_qr_code', 'ajax' => true, 'url' => $link_sec),
					true
				),
				'qrCodeDownloadUrl' => $this->context->link->getModuleLink(
					'refpro',
					'myaccount',
					array('action' => 'download_qr_code', 'ajax' => true, 'url' => $link_sec, 'download' => true),
					true
				),
			));
		}

		if (version_compare(_PS_VERSION_, '1.7', '>='))
		{
			$this->context->smarty->assign(array(
				'base_uri' => __PS_BASE_URI__
			));
            $smarty = $this->context->smarty;

            if (!array_key_exists('convertPriceWithCurrency', $smarty->registered_plugins['function'])) {
                smartyRegisterFunction(
                    $smarty,
                    'function',
                    'convertPriceWithCurrency',
                    array('Product', 'convertPriceWithCurrency')
                );
            }

			$this->setTemplate('module:refpro/views/templates/front/my-account-17.tpl');
		}
		else
			$this->setTemplate('my-account.tpl');
	}

	public function getReferralCartRule($user_data)
    {
        if (!isset($user_data['id'])) {
            return false;
        }
        $has_voucher = $user_data['has_voucher'];
        if (!$has_voucher) {
            $has_voucher = Referral::getSettings('has_voucher');

            $user_data['voucher_percent'] = (float)Referral::getSettings('voucher_percent');
            $user_data['voucher_amount'] = (float)Referral::getSettings('voucher_amount');
        }

        if (!$has_voucher) {
            return false;
        }

        $id_cart_rule = (int)Referral::getCartRuleByCustomer($this->context->customer->id);

        $cart_rule = new CartRule($id_cart_rule);
        if (Validate::isLoadedObject($cart_rule)) {
            return $cart_rule;
        } else {
            $cart_rule = Referral::createNewCartRule($this->context->customer, $has_voucher, $user_data);
            if ($cart_rule) {
                Referral::setCartRuleByCustomer($this->context->customer->id, $cart_rule->id);
                return $cart_rule;
            } else {
                throw new Exception('Can not create cart rule!');
            }
        }
    }

	public function displayAjaxGetPaid()
	{
		$template_vars = array();
		$user_data = Referral::getUserData($this->context->customer->id);
		if (!$user_data['order'])
		{
			$min_balance = Referral::getSettings('min_balance');
			if ($user_data['money'] >= $min_balance)
			{
				$no_ps = true;
				for ($i = 1; $i <= 5; $i++)
				{
					$key = 'ps_'.$i;
					if ($user_data[$key])
					{
						$no_ps = false;
						break;
					}
				}
				if (!$no_ps)
				{
					Db::getInstance()->update('refpro_customer', array(
						'order' => 1
					), ' id = '.(int)$this->context->customer->id);

					$user_data['order'] = 1;
					if (Referral::getSettings('manager'))
					{
						$contacts = Contact::getContacts($this->context->language->id);
						$contact_id = Referral::getSettings('manager');
						foreach ($contacts as $contact)
						{
							if ($contact['id_contact'] == $contact_id)
								$to_email = $contact['email'];
						}
					}

					if (empty($to_email)) $to_email = Configuration::get('PS_SHOP_EMAIL');
					$template_vars['{user}'] = $this->context->customer->firstname.' '.$this->context->customer->lastname.' (id #'.$this->context->customer->id.')';

					MailModRP::sendMail('bonus-order', $to_email, null, $this->module->l('Bonus order', 'myaccount'),
						$template_vars, $this->context->language->id);

					die(Referral::ajaxWrap($this->module->l('Your order is sent for processing!', 'myaccount')."<span class='ok_flag'></span>"));
				}
				else
					die(Referral::ajaxWrap($this->module->l('You have not filled payment information for withdrawal. Please do this on the tab "Payment information"!', 'myaccount')));
			}
			else
				die(Referral::ajaxWrap($this->module->l('To order the money withdrawal your balance must be at least', 'myaccount')
					.' '.Referral::formatMoney($min_balance).' !'));

		}
		else
			die(Referral::ajaxWrap($this->module->l('You have already ordered the withdrawal.', 'myaccount')));
	}

	public function displayAjaxGetPayments()
	{
		$page = (int)Tools::getValue('page');
		$payments = Referral::getPayments($this->context->customer->id, $page);
		$message = '';
		$currency_obj = new Currency(Configuration::get('PS_CURRENCY_DEFAULT'));
		if (is_array($payments) && count($payments))
		{
			foreach ($payments as $payment)
				$message .= '<tr>
								<td>'.$payment['ts'].'</td>
								<td>'.Tools::displayPrice(Tools::convertPrice($payment['amount'], null, $currency_obj)).'</td>
							</tr>';
		}
		die(Tools::jsonEncode(array(
			'hasError' => false,
			'message' => $message
		)));
	}

	public function displayAjaxDownloadQrCode()
	{
		$qrCodeTargetUrl = (string)Tools::getValue('url');;;
		$download = (bool)Tools::getValue('download');;

		$contentDisposition = $download ? 'attachment' : 'inline';

		header('Content-Type: image/svg+xml');
		header('Content-Disposition: ' . $contentDisposition . '; filename="Affiliate QR code.svg"');
		echo $this->generateSvgQrCode($qrCodeTargetUrl);
		die();
	}

	protected function generateSecureLink()
	{
		//$url = $this->context->link->getPageLink('index.php').'?ref='.md5($this->context->customer->email);
		$url = $this->context->link->getPageLink('index.php').'?ref='.'hi5');
		return $url;
	}

	protected function generateSvgQrCode($data)
	{
		foreach($this->qrCodeVersionToMaxLength as $version => $maxLength) {
			if (strlen($data) > $maxLength) {
				continue;
			}
			$qrCode = new QRCode(
				new QROptions(
					array(
						'version' => $version,
						'outputType' => QRCode::OUTPUT_MARKUP_SVG,
						'eccLevel' => QRCode::ECC_L,
					)
				)
			);
			return $qrCode->render($data);
		}

		return null;
	}
}
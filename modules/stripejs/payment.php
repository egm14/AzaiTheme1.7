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
 * @copyright 2007-2015 PrestaShop SA
 * @license   http://addons.prestashop.com/en/content/12-terms-and-conditions-of-use
 * International Registered Trademark & Property of PrestaShop SA
 */

include_once(dirname(__FILE__).'/../../config/config.inc.php');
include_once(dirname(__FILE__).'/../../init.php');
include_once(dirname(__FILE__).'/stripejs.php');

if (!defined('_PS_VERSION_'))
    exit;

$stripe = new StripeJs();
$context = Context::getContext();

if ($stripe->active && Tools::getIsset('stripeToken') && Tools::getValue('stripeToken')!='') {
	
	if (Tools::getIsset('checkOrder') && Tools::getValue('checkOrder')) {
          $link = Context::getContext()->link;
          $transaction = Db::getInstance()->getRow('SELECT * FROM ' . _DB_PREFIX_ . 'stripejs_transaction WHERE `type`= "payment" && `source` = "'.Tools::getValue('stripeToken').'"');
          
          if ($transaction && ($transaction['status'] == 'paid' || $transaction['status'] == 'unpaid')) {
              if ($transaction['id_order']!='') {
                  $order = new Order((int)$transaction['id_order']);
                  $url = ($link->getPageLink('order-confirmation', true).'?id_cart='.(int)$order->id_cart.'&id_module='.(int)$stripe->id.'&id_order='.(int)$transaction['id_order'].'&key='.$order->secure_key);
                  die(Tools::jsonEncode(array('code' => 1,'url' => $url)));
              }
          } else if ($transaction && ($transaction['result'] == "failed" || $transaction['result'] == "canceled")) {
              die(Tools::jsonEncode(array('code' => 0)));
          }
     }

    $amount = $context->cart->getOrderTotal();
	$amount = $stripe->isZeroDecimalCurrency($context->currency->iso_code) ? round($amount) : $amount * 100;
	$multibanco = (Tools::getValue('sourceType')=='multibanco'?array('entity' => Tools::getValue('mb_entity'),'reference' => Tools::getValue('mb_ref'),'status' => Tools::getValue('status')):'');

    $params = array(
        'token' => Tools::getValue('stripeToken'),
        'amount' => $amount,
        'currency' => $context->currency->iso_code,
		'multibanco' => $multibanco,
        'source_type' => str_replace('source_','',Tools::getValue('sourceType')),
    );

    $stripe->processPayment($params);
	 
} else {
    die(Tools::jsonEncode(array(
                'code' => '0',
                'msg' => 'Empty token. Unknown error, please use another card or contact us.',
            )));
}
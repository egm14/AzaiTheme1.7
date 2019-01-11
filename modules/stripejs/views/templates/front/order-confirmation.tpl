{*
* 2019-2020 NTS
*
* DISCLAIMER
*
* You are NOT allowed to modify the software. 
* It is also not legal to do any changes to the software and distribute it in your own name / brand. 
*
* @author NTS
* @copyright  2019-2020 NTS
* @license   http://addons.prestashop.com/en/content/12-terms-and-conditions-of-use
* International Registered Trademark & Property of NTS
*}
{if $stripe_order.valid == 1}
   {if $stripe_order.pending == 1}
      <div class="info alert alert-info"><ul><li>{l s='Congratulations, your order has been placed and saved under the reference' mod='stripejs'} <b>{$stripe_order.reference|escape:'htmlall':'UTF-8'}</b>. </li><li>{l s='Order will be processed automatically after receiving the payment.' mod='stripejs'}</li></ul></div>
      <div class="text-center" style="text-align: center;">
      <img alt="secure" src="{$module_dir|escape:'htmlall':'UTF-8'}views/img/multibanco.png" />
      <h3>{l s='Multibanco Order information' mod='stripejs'}</h3>
      <table style="border:2px solid #1568BC;color: #000;" class="table"><tr>
      <td style="text-align:center;color:#1568BC;font-weight:bold;">{l s='Entity (PPRO Financial for COMUNITI.PT*):' mod='stripejs'}</td><td>{$stripe_order.pending_arr.btc_address|escape:'htmlall':'UTF-8'}</td> </tr>
      <tr><td style="text-align:center;color:#1568BC;font-weight:bold;">{l s='Reference:' mod='stripejs'} </td><td>{$stripe_order.pending_arr.cc_type|escape:'htmlall':'UTF-8'}</td></tr>
      <tr><td style="text-align:center;color:#1568BC;font-weight:bold;">{l s='Amount:' mod='stripejs'}</td><td>{$stripe_order.pending_arr.amount|escape:'htmlall':'UTF-8'} {$stripe_order.pending_arr.currency|escape:'htmlall':'UTF-8'}</td>
      </tr></table>
      <b>{l s='In your online account or ATM machine choose "Payment and other services" and then "Payments of services/shopping".' mod='stripejs'}</b>
      <hr />
      </div>
   {else}
	<div class="success alert alert-success">{l s='Congratulations, your payment has been approved and your order has been saved under the reference' mod='stripejs'} <b>{$stripe_order.reference|escape:'htmlall':'UTF-8'}</b>.</div>
    {/if}
{else}
	{if $order_pending}
		<div class="warning alert alert-warning">{l s='Unfortunately we detected a problem while processing your order and it needs to be reviewed.' mod='stripejs'}<br /><br />
		{l s='Do not try to submit your order again, as the funds have already been received.  We will review the order and provide a status shortly.' mod='stripejs'}<br /><br />
		({l s='Your Order\'s Reference:' mod='stripejs'} <b>{$stripe_order.reference|escape:'htmlall':'UTF-8'}</b>)</div>
	{else}
		<div class="error alert alert-danger">{l s='Sorry, unfortunately an error occured during the transaction.' mod='stripejs'}<br /><br />
		{l s='Please double-check your credit card details and try again or feel free to contact us to resolve this issue.' mod='stripejs'}<br /><br />
		({l s='Your Order\'s Reference:' mod='stripejs'} <b>{$stripe_order.reference|escape:'htmlall':'UTF-8'}</b>)</div>
	{/if}
{/if}

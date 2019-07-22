{**
 * 2007-2017 PrestaShop
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License 3.0 (AFL-3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * https://opensource.org/licenses/AFL-3.0
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
 * @author    PrestaShop SA <contact@prestashop.com>
 * @copyright 2007-2017 PrestaShop SA
 * @license   https://opensource.org/licenses/AFL-3.0 Academic Free License 3.0 (AFL-3.0)
 * International Registered Trademark & Property of PrestaShop SA
 *}
<section id="js-checkout-summary" class="js-cart cart-summary mt-4 mb-3" data-refresh-url="{$urls.pages.cart}?ajax=1&action=refresh">
  <h4 class="page-heading">{l s='Cart' d='Shop.Theme.Checkout'}<small class="float-right">{$cart.summary_string}</small></h4>
  <div class="cart-products-block">
    {block name='hook_checkout_summary_top'}
      {hook h='displayCheckoutSummaryTop'}
    {/block}

    {block name='cart_summary_products'}
      <div class="cart-summary-products">
        {block name='cart_summary_product_list'}
          <ul id="cart-summary-product-list">
            {foreach from=$cart.products item=product}
              <li class="cart-summary-product-item">{include file='checkout/_partials/cart-summary-product-line.tpl' product=$product}</li>
              <hr>
            {/foreach}
          </ul>
        {/block}
      </div>
    {/block}

    {block name='cart_summary_subtotals'}
      {foreach from=$cart.subtotals item="subtotal"}
        {if $subtotal && $subtotal.type !== 'tax'}
          <div class="cart-summary-line cart-summary-subtotals" id="cart-subtotal-{$subtotal.type}">
            <span class="label">{$subtotal.label}</span>
            <span class="value">{$subtotal.value}</span>
          </div>
        {/if}
      {/foreach}
    {/block}

    <hr>
    {*block name='cart_summary_voucher'*}
      {*include file='checkout/_partials/cart-voucher.tpl'*}
    {*/block*}

    {block name='cart_summary_totals'}
      {include file='checkout/_partials/cart-summary-totals.tpl' cart=$cart}
    {/block}

    {block name='cart_detailed_notification'}

   <!-- Alert to Dominican Republic customer - buy over $200.o0 -->

    {if $cart.totals.total.value >= '$200' && ($customer.addresses[$cart.id_address_delivery].country == 'Dominican Republic' || $customer.addresses[$cart.id_address_delivery].country == 'República Dominicana')}
        <div class="notification alert alert-warning">
          <h3 style="color:white;margin-left:.4rem;margin-bottom:0px;text-decoration:underline;">{l s='Cargos aduanales República Dominicana' d='Shop.Theme.Checkout'}</h3>
         <p style="padding-left:.4rem">{l s="Se aplicarán cargos aduanales en compras mayores a "}<span style="text-decoration:underline;color:black">{l s="USD$200.00. "}</span>{l s='Para mayor información marcar o escribenos a: ' d='Shop.Theme.Checkout'}<a href="phone:+1-809-705-8665">{l s="+1(809)705-8665"}</a> | <a href="mailto:autorizaciones@azai.com.com?subject=Compras%20RD%20mayor%20a%20USD$200">{l s="autorizaciones@azai.com" d='Shop.Theme.Checkout'}</a>
        </div>
    {/if}
{/block}
  </div>
</section>

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
<div id="_desktop_cart">
  <div class="blockcart cart-preview" data-refresh-url="{$refresh_url}">
    <a class="clone-slidebar-toggle" data-id-slidebar="blockcart-slidebar" rel="nofollow" href="{$cart_url}" title="{l s='View Cart' d='Shop.Theme.Actions'}">
      {if $cart.products_count > 0}
      <p class="cart-products-count">{l s='%products_count%' sprintf=['%products_count%' => $cart.products_count] d='Shop.Theme.Checkout'}</p>
      {/if}
      <i class="fl-chapps-hand135" aria-hidden="true"></i>
      <span class="cart-products-label">{l s='Cart' d='Shop.Theme.Checkout'}</span>
      <span class="cart-products-count">{$cart.products_count}</span>
      <span class="cart-products-count-text"> {if $cart.products_count != 1}{l s='Items' d='Shop.Theme.Checkout'}{else}{l s='Item' d='Shop.Theme.Checkout'}{/if}</span>
    </a>
  </div>
  <div class="cart-summary" data-off-canvas="blockcart-slidebar right push">
    <button type="button" class="closeSlidebar btn" aria-label="Close"></button>
    <div class="block-cart-body">
      <h4 class="cart-summary-header text-center page-heading">{l s='Cart' d='Shop.Theme.Actions'}</h4>
      <div class="cart-grid row">
        
        <!-- Left Block: cart product informations & shpping -->
        <div class="cart-grid-body mb-3 mb-lg-0 col-12 col-lg-8">

          <!-- cart products detailed -->
          <div class="cart-container mb-4">
            {block name='cart_overview'}
              {include file='checkout/_partials/cart-detailed.tpl' cart=$cart}
            {/block}
          </div>

          {block name='cart_summary'}
          <div class="cart-summary mb-3">
            <hr>
              <div class="cart-total d-flex flex-wrap justify-content-between my-3">
                <strong class="label" style="font-style:underline;">{l s='Subtotal' d='Shop.Theme.Checkout'}</strong>
              </div>

              <!-- Section to block a voucher tpl -->
              {block name='cart_totals'}
                {include file='checkout/_partials/cart-detailed-totals.tpl' cart=$cart}
              {/block}
              <!-- Section to block a voucher tpl END-->

              {block name='cart_actions'}
                {include file='checkout/_partials/cart-detailed-actions.tpl' cart=$cart}
              {/block}
               <button type="button" class="closeSlidebar shopping" aria-label="Close">{l s='Continue shopping' d='Shop.Theme.Actions'}</button>
          </div>
          {/block}

        </div>
        <!-- Left Block: cart product informations & shpping END-->
      </div>
    </div>
  </div>
</div>
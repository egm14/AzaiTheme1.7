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
    <button type="button" class="closeSlidebar" aria-label="Close"></button>
    <div class="block-cart-body">
      <h4 class="cart-summary-header text-center page-heading">{l s='Cart' d='Shop.Theme.Actions'}</h4>
      <ul id="cart-summary-product-list">
        {foreach from=$cart.products item=product}
          <li class="cart-summary-product-item text-left">
            {include 'module:ps_shoppingcart/ps_shoppingcart-product-line.tpl' product=$product}
          </li>
          <hr>
        {/foreach}
      </ul>
      <div class="cart-subtotals">
        {foreach from=$cart.subtotals item="subtotal"}
          {if isset($subtotal) && $subtotal}
            <div class="cart-{$subtotal.type} d-flex flex-wrap justify-content-between">
              <span class="label">{$subtotal.label}</span>
              <span class="value">{$subtotal.value}</span>
              {if $subtotal.type == 'discount'}
                {if $cart.vouchers.added}
                  <ul class="list-group mb-2 w-100">
                    {foreach from=$cart.vouchers.added item='voucher'}
                      <li class="list-group-item d-flex flex-wrap justify-content-between">
                        <span>{$voucher.name}({$voucher.reduction_formatted})</span><a data-link-action="remove-voucher" href="{$voucher.delete_url}" class="close" aria-label="Close">
                          <span aria-hidden="true">&times;</span>
                        </a>
                      </li>
                    {/foreach}
                  </ul>
                {/if}
              {/if}
            </div>
          {/if}
        {/foreach}
      </div>
      <hr>
      <div class="cart-total d-flex flex-wrap justify-content-between my-3">
        <strong class="label">{$cart.totals.total.label}</strong>
        <strong class="value">{$cart.totals.total.value}</strong>
      </div>
      <div class="cart-footer text-center">
        <a id="tocheckout" class="btn btn-secondary btn-sm" href="{$cart_url}" title="{l s='Proceed to checkout' d='Shop.Theme.Actions'}">{l s='Proceed to checkout' d='Shop.Theme.Actions'}</a>
        <button type="button" class="closeSlidebar shopping" aria-label="Close"><i class="material-icons">keyboard_arrow_left</i>{l s='Continue shopping' d='Shop.Theme.Actions'}</button>
        <!--<button type="button" class="btn btn-secondary" data-dismiss="modal">{l s='Continue shopping' d='Shop.Theme.Actions'}</button>-->
      </div>
    </div>
  </div>
</div>
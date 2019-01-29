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
{if $cart.vouchers.allowed}
  {block name='cart_voucher'}
    <div class="block-promo">
      <div id="cart-voucher-promo" class="cart-voucher">
        {if $cart.vouchers.added}
          {block name='cart_voucher_list'}
            <ul class="promo-name card-block">
              {foreach from=$cart.vouchers.added item=voucher}
                <li class="d-flex align-items-center mt-2 row no-gutters">
                  <div class="cart-summary-line bg-white py-2 px-3 col">
                    <span class="label">{$voucher.name}</span>
                    <span class="value">{$voucher.reduction_formatted}</span>
                  </div>
                  <div class="col-auto ml-2">
                    <a class="close" href="{$voucher.delete_url}" data-link-action="remove-voucher"><span aria-hidden="true">&times;</span></a>
                  </div>
                </li>
              {/foreach}
            </ul>
          {/block}
        {/if}

        <p>
          <!--Adding xtra classes to promo code btn: payment-option clearfix custom-control custom-radio-->
          <a class="promo-code-button btn-link btn-link-primary payment-option clearfix custom-control custom-radio" data-toggle="collapse" href="#promo-code" aria-expanded="false" aria-controls="promo-code">
            {l s='Have a promo code?' d='Shop.Theme.Checkout'}
          </a>
        </p>

        <div class="promo-code collapse{if $cart.discounts|count > 0} in{/if}" id="promo-code">
          {block name='cart_voucher_form'}
            <form class="input-group bg-white p-3" action="{$urls.pages.cart}" data-link-action="add-voucher" method="post">
              <span class="input-group-btn">
                <button type="submit" class="btn btn-secondary btn-sm">{l s='Add' d='Shop.Theme.Actions'}</button>
              </span>
              <input type="hidden" name="token" value="{$static_token}">
              <input type="hidden" name="addDiscount" value="1">
              <input class="form-control" type="text" name="discount_name" placeholder="{l s='Promo code' d='Shop.Theme.Checkout'}">
            </form>
          {/block}

          {block name='cart_voucher_notifications'}
            <div class="alert alert-danger js-error" role="alert">
              <span class="js-error-text"></span>
            </div>
          {/block}

          <hr>
        </div>

        {if $cart.discounts|count > 0}
          <p class="block-promo promo-highlighted">
            {l s='Take advantage of our exclusive offers:' d='Shop.Theme.Actions'}
          </p>
          <ul class="js-discount card-block promo-discounts">
          {foreach from=$cart.discounts item=discount}
            <li class="cart-summary-line">
              <span class="label"><span class="code">{$discount.code}</span> - {$discount.name}</span>
            </li>
          {/foreach}
          </ul>
          <hr>
        {/if}
      </div>
    </div>
  {/block}
{/if}

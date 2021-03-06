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
{block name='cart_detailed_actions'}

  {if $customer.id_default_group == 11}
    {assign var="btncheckout" value="pre-order"}
  {else}
    {assign var="btncheckout" value="Proceed to checkout"}
  {/if}
  <div class="checkout cart-detailed-actions text-center">
    {if $cart.minimalPurchaseRequired}
      <div class="alert alert-warning" role="alert">
        {$cart.minimalPurchaseRequired}
      </div>
      <button id="cartAction" type="button" class="btn btn-lg btn-secondary icon-right disabled" disabled><span>{l s=$btncheckout d='Shop.Theme.Actions'}</span></button>
    {elseif empty($cart.products) }
      <button id="cartAction" type="button" class="btn btn-lg btn-secondary icon-right disabled" disabled><span>{l s=$btncheckout d='Shop.Theme.Actions'}</span></button>
    {else}
      <a id="cartAction" href="{$urls.pages.cart}?action=show&checkout" class="btn btn-lg btn-secondary icon-right"><span>{l s=$btncheckout d='Shop.Theme.Actions'}</span></a>
      {hook h='displayExpressCheckout'}
    {/if}
    <p style="display:none;">{l s='pre-order' d='Shop.Theme.Actions'}</p>
  </div>
{/block}


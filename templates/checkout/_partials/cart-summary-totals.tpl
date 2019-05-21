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
<div class="card-block cart-summary-totals">
  {if $hasTax}
  {block name='cart_summary_total'}
    <div class="cart-summary-line cart-total">
      <span class="label">{$cart.totals.total_including_tax.label}</span>
      <span class="value">{$cart.totals.total_including_tax.value}</span>
    </div>
  {/block}
  {else}
  {block name='cart_summary_total'}
    <div class="cart-summary-line cart-total hi-total">
      <strong class="label">{$cart.totals.total.label} {$cart.labels.tax_short}</strong>
      <strong class="value">{$cart.totals.total.value}</strong>
    </div>
  {/block}
  {/if}
  {block name='cart_summary_tax'}
    <div class="cart-summary-line hi-tax">
      <span class="label sub">{$cart.subtotals.tax.label}</span>
      <span class="value sub">{$cart.subtotals.tax.value}</span>
    </div>
    <div class="cart-summary-line cart-total">
    <span class="label sub">{l s='Total General'}</span>
    <span class="value sub">{$currency.iso_code}{$currency.sign}{$cart.totals.total.amount+$cart.subtotals.tax.amount}</span>

  </div>
  {/block}
 

</div>

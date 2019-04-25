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
<div id="_desktop_currency_selector">
  <div class="currency-selector js-dropdown">
    <span data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" aria-label="{l s='Currency dropdown' d='Shop.Theme.Global'}">
      <span class="expand-more-desktop">{$current_currency.iso_code}</span>
	  <span class="expand-more-mobil">{l s='currency' d='Shop.Theme.Global'} ({$current_currency.iso_code})</span>
      <i class="fa fa-angle-down ml-1" aria-hidden="true"></i>
    </span>
    <ul class="dropdown-menu dropdown-menu-left" aria-labelledby="currency-selector-label">
      {foreach from=$currencies item=currency}
        <a title="{$currency.name}" rel="nofollow" href="{$currency.url}" class="dropdown-item{if $currency.current} active{/if}">{$currency.iso_code}({$currency.sign})</a>
      {/foreach}
    </ul>
  </div>
</div>

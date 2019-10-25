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
{extends file='customer/page.tpl'}

{block name='page_title'}
  {l s='Your account' d='Shop.Theme.Customeraccount'}
{/block}

{block name='page_content'}
  <ul class="my-account-links row">

    {block name='display_customer_account'}
        {hook h='displayCustomerAccount'}
      {/block}

    <li class="ma-link-item col-lg-2 col-md-3 col-sm-4 col-6">
      <a id="identity-link" href="{$urls.pages.identity}">
        <i class="fa fa-user-circle-o" aria-hidden="true"></i>
        {l s='Information' d='Shop.Theme.Customeraccount'}
      </a>
    </li>

    <li class="ma-link-item col-lg-2 col-md-3 col-sm-4 col-6">
      {if $customer.addresses|count}
        <a id="addresses-link" href="{$urls.pages.addresses}">
          <i class="fa fa-building" aria-hidden="true"></i>
          {l s='Addresses' d='Shop.Theme.Customeraccount'}
        </a>
      {else}
        <a id="address-link" href="{$urls.pages.address}">
          <i class="fa fa-map-marker" aria-hidden="true"></i>
          {l s='Add first address' d='Shop.Theme.Customeraccount'}
        </a>
      {/if}
    </li>

    {if !$configuration.is_catalog}
      <li class="ma-link-item col-lg-2 col-md-3 col-sm-4 col-6">
        <a id="history-link" href="{$urls.pages.history}">
          <i class="fa fa-list-ol" aria-hidden="true"></i>
          {l s='Order history and details' d='Shop.Theme.Customeraccount'}
        </a>
      </li>
    {/if}

    {if !$configuration.is_catalog}
      <li class="ma-link-item col-lg-2 col-md-3 col-sm-4 col-6">
        <a id="order-slips-link" href="{$urls.pages.order_slip}">
          <i class="fa fa-money" aria-hidden="true"></i>
          {l s='Credit slips' d='Shop.Theme.Customeraccount'}
        </a>
      </li>
    {/if}

    {if $configuration.voucher_enabled && !$configuration.is_catalog}
      <li class="ma-link-item col-lg-2 col-md-3 col-sm-4 col-6">
        <a id="discounts-link" href="{$urls.pages.discount}">
          <i class="fa fa-barcode" aria-hidden="true"></i>
          {l s='Vouchers' d='Shop.Theme.Customeraccount'}
        </a>
      </li>
    {/if}

    {if $configuration.return_enabled && !$configuration.is_catalog}
      <li class="ma-link-item col-lg-2 col-md-3 col-sm-4 col-6">
        <a id="returns-link" href="{$urls.pages.order_follow}">
          <i class="fa fa-refresh" aria-hidden="true"></i>
          {l s='Merchandise returns' d='Shop.Theme.Customeraccount'}
        </a>
      </li>
    {/if}
   
      
      
    

  </ul>
  <hr>
{/block}

{block name='page_footer'}
  {block name='my_account_links'}
    <a class="btn btn-secondary" href="{$logout_url}">
      {l s='Sign out' d='Shop.Theme.Actions'}
    </a>
  {/block}
{/block}

{*
* 2007-2018 PrestaShop
*

* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
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
*	@author PrestaShop SA <contact@prestashop.com>
*	@copyright	2007-2018 PrestaShop SA
*	@license		http://opensource.org/licenses/afl-3.0.php	Academic Free License (AFL 3.0)
*	International Registered Trademark & Property of PrestaShop SA
*}


{extends file="page.tpl"}

{block name='page_content'}
    {if $payment_option.additionalInformation}
        <div id="{$payment_option.id|escape:'htmlall':'UTF-8'}-additional-information" class="js-additional-information definition-list additional-information">
            {$payment_option.additionalInformation nofilter}
        </div>
    {/if}

    <div class="payment-options">
    {foreach from=$payment_options item="option"}
        <div>
          <div id="{$option.id|escape:'htmlall':'UTF-8'}-container" class="payment-option clearfix">
            {* This is the way an option should be selected when Javascript is enabled *}
            <span class="custom-radio pull-xs-left">
              <input class="ps-shown-by-js" id="{$option.id|escape:'htmlall':'UTF-8'}" data-module-name="{$option.module_name|escape:'htmlall':'UTF-8'}" name="payment-option" type="radio" required>
              <span></span>
            </span>

            <label for="{$option.id|escape:'htmlall':'UTF-8'}">
              <span>{$option.call_to_action_text|escape:'htmlall':'UTF-8'}</span>
              {if $option.logo}
                <img src="{$option.logo|escape:'htmlall':'UTF-8'}">
              {/if}
            </label>

          </div>
        </div>

        {if $option.additionalInformation}
          <div id="{$option.id|escape:'htmlall':'UTF-8'}-additional-information" class="js-additional-information definition-list additional-information"  style="display:none;">
            {$option.additionalInformation nofilter}
          </div>
        {/if}

        <div id="pay-with-{$option.id|escape:'htmlall':'UTF-8'}-form" class="js-payment-option-form" style="display:none;">
          {if $option.form}
            {$option.form nofilter}
          {else}
            <form id="payment-form" method="POST" action="{$option.action nofilter}">
              {foreach from=$option.inputs item=input}
                <input type="{$input.type|escape:'htmlall':'UTF-8'}" name="{$input.name|escape:'htmlall':'UTF-8'}" value="{$input.value|escape:'htmlall':'UTF-8'}">
              {/foreach}
              <button style="display:none" id="pay-with-{$option.id|escape:'htmlall':'UTF-8'}" type="submit"></button>
            </form>
          {/if}
        </div>
    {/foreach}
  </div>
        <br class="clearfix">
        <div id="payment-confirmation">
            <button type="submit" class="btn btn-primary center-block">
                {l s='Confirm order' mod='stripejs'}
            </button>
        </div>
    </div>
{/block}

{block name='page_footer'}
    {block name='my_account_links'}
        {include file='customer/_partials/my-account-links.tpl'}
    {/block}
{/block}
{*
* 2007-2017 PrestaShop
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
*  @author    Goryachev Dmitry <dariusakafest@gmail.com>
*  @copyright 2007-2017 Goryachev Dmitry
*  @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}

{capture name=path}
	<a href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}">
		{l s='My account' mod='userbalance'}</a>
		<span class="navigation-pipe">{if isset($navigationPipe)}{$navigationPipe}{/if}</span>{l s='My balance' mod='userbalance'}
{/capture}

<div class="row">
    <div class="col-md-12 text-center" style="margin-top:1.5rem;">
        <span class="balance_value balance_{if $balance >= 0}positive{else}negative{/if}">
            {l s='My balance' mod='userbalance'}: <span class="balance_price" style="font-weight:700;padding:.4rem .8rem;background-color:#00ae00;color:white;border-radius:5px;">{displayPrice currency=$default_currency price=$balance }</span>
        </span>
    </div>
</div>
<div class="tabContainer">
    <ul class="tabs">
        {if ConfUB::getConf('enable_funding_balance')}<li data-tab="refill_tab">{l s='Refill' mod='userbalance'}</li>{/if}
        {if $balance > 0 && ConfUB::getConf('enable_withdrawal')}<li data-tab="withdrawal_tab">{l s='Withdrawal' mod='userbalance'}</li>{/if}
        <li data-tab="history_tab">{l s='History' mod='userbalance'}</li>
    </ul>
    <div class="tabs_content">
        {if ConfUB::getConf('enable_funding_balance')}
            <div id="refill_tab">
                {include file="`$tpl_module_dir`tabs/refill.tpl"}
            </div>
        {/if}
        {if $balance > 0 && ConfUB::getConf('enable_withdrawal')}
            <div id="withdrawal_tab">
                {include file="`$tpl_module_dir`tabs/withdrawal.tpl"}
            </div>
        {/if}
        <div id="history_tab">
            {include file="`$tpl_module_dir`tabs/history.tpl"}
            {include file="`$tpl_module_dir`pagination.tpl"}
        </div>
    </div>
</div>

{if {versionCompare v='1.7.0.0' op='<'}}
<ul class="footer_links clearfix">
		<li>
			<a class="btn btn-default button button-small" href="{$link->getPageLink('my-account', true)|escape:'quotes':'UTF-8'}">
				<span>
					<i class="icon-chevron-left"></i> {l s='Back to Your Account' mod='userbalance'}
				</span>
			</a>
		</li>
		<li>
			<a class="btn btn-default button button-small" href="{$base_dir|escape:'quotes':'UTF-8'}">
				<span>
					<i class="icon-chevron-left"></i> {l s='Home' mod='userbalance'}
				</span>
			</a>
		</li>
</ul>
{/if}
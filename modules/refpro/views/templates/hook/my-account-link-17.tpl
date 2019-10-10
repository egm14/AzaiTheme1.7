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
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2017 PrestaShop SA
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}

<!-- MODULE Refpro -->
{if !$side}
<li class="ma-link-item col-lg-2 col-md-3 col-sm-4 col-6">
	<a class="col-lg-4 col-md-6 col-sm-6 col-xs-12" href="{$link->getModuleLink('refpro', 'myaccount')|escape:'quotes':'UTF-8'}" title="{l s='Affiliate program' mod='refpro'}">
			<span class="link-item">
				<i class="material-icons">&#xE7FB;</i>
				{l s='Affiliate program' mod='refpro'}
			</span>
	</a>
</li>
{else}
	<li>
		<a href="{$link->getModuleLink('refpro', 'myaccount')|escape:'quotes':'UTF-8'}" title="{l s='Affiliate program' mod='refpro'} rel="nofollow">
			{l s='Affiliate program' mod='refpro'}
		</a>
	</li>
{/if}

{if !isset($hide) || $hide !='1'}
	<li>
		<a href="#" class="reflinks">
			{l s='Get an affiliate link' mod='refpro'}
		</a>
	</li>
{/if}

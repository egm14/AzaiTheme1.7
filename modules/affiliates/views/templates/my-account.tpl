{*
* Affiliates
*
* NOTICE OF LICENSE
*
* This source file is subject to the Open Software License (OSL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/osl-3.0.php
*
* @author    FMM Modules
* @copyright © Copyright 2017 - All right reserved
* @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
* @category  FMM Modules
* @package   affiliates
*}

{if $ps_17 > 0}
	<a class="col-lg-4 col-md-6 col-sm-6 col-xs-12" href="{$link->getModuleLink('affiliates', 'myaffiliates')}">
	<span class="link-item">
	  <i class="fa fa-street-view" aria-hidden="true"></i>
	  {l s='icon' mod='affiliates'}
	  {l s='Affiliation' mod='affiliates'}
	</span>
	</a>
{else}
<li class="lnk_affiliates">
	<a href="{$link->getModuleLink('affiliates', 'myaffiliates', array(), true)|escape:'htmlall':'UTF-8'}" title="{l s='My Affiliatess' mod='affiliates'}">
		{if $ps_version < 1.6}
			<img src="{$module_template_dir|escape:'htmlall':'UTF-8'}views/img/ico_15.png" alt="{l s='Affiliates' mod='affiliates'}" class="icon" />
		{/if}
			<span>{l s='Affiliation' mod='affiliates'}</span>
		{if $ps_version >= 1.6}
			<i class="icon-street-view"></i>
		{/if}
	</a>
</li>
{/if}
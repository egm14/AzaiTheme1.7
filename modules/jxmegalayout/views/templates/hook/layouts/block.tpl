{**
* 2002-2018 Zemez
*
* JX Mega Layout
*
* NOTICE OF LICENSE
*
* This source file is subject to the General Public License (GPL 2.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/GPL-2.0
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade the module to newer
* versions in the future.
*
*  @author    Zemez (Alexander Grosul & Alexander Pervakov)
*  @copyright 2002-2018 Zemez
*  @license   http://opensource.org/licenses/GPL-2.0 General Public License (GPL 2.0)
*}

{if $items.module_name == "logo"}
  <a class="jxml-logo{if $items.specific_class} {$items.specific_class}{/if}" href="{$urls.base_url}" title="{$shop.name}">
    <img class="logo img-fluid" src="{$shop.logo}" alt="{$shop.name}" /> <spam class="logo img-fluid-refresh" ><i class="fa fa-refresh" aria-hidden="true"></i></spam>
  </a>
{/if}
{if $items.module_name == "copyright"}
  {if Configuration::get('FOOTER_POWEREDBY')}
    <div class="jxml-copyright{if $items.specific_class} {$items.specific_class}{/if}">
      {l s='[1] %3$s %2$s - Ecommerce software by %1$s [/1]' mod='jxmegalayout' sprintf=['PrestaShop™', 'Y'|date, '©'] tags=['<a class="_blank" href="http://www.prestashop.com">'] nocache}
      {if $urls.shop_domain_url !== "http://ld-prestashop.template-help.com" && $urls.shop_domain_url !== "https://ld-prestashop.template-help.com"}
        Design by <a href="https://zemez.io/">Zemez</a>
      {/if}
    </div>
  {/if}
{/if}
{if $items.module_name == "tabs"}
  {if isset($HOOK_HOME_TAB_CONTENT) && $HOOK_HOME_TAB_CONTENT|trim}
    <div class="tab-content{if $items.specific_class} {$items.specific_class}{/if}">{$HOOK_HOME_TAB_CONTENT}</div>
  {/if}
{/if}
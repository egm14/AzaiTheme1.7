{*
* 2002-2017 Jetimpex
*
* Jetimpex Social Login
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
* @author     Jetimpex (Alexander Grosul)
* @copyright  2002-2017 Jetimpex
* @license    http://opensource.org/licenses/GPL-2.0 General Public License (GPL 2.0)
*}
{if $f_status}
  <li class="ma-link-item col-lg-2 col-md-3 col-sm-4 col-6">
    <a href="{$link->getModuleLink('jxheaderaccount', 'facebooklink', [], true)}" title="{l s='Facebook Login Manager' mod='jxheaderaccount'}">
      <i class="fa fa-facebook" aria-hidden="true"></i>
      {if !$facebook_id}{l s='Connect With Facebook' mod='jxheaderaccount'}{else}{l s='Facebook Login Manager' mod='jxheaderaccount'}{/if}
    </a>
  </li>
{/if}
{if $g_status}
  <li class="ma-link-item col-lg-2 col-md-3 col-sm-4 col-6">
    <a {if isset($back) && $back}href="{$link->getModuleLink('jxheaderaccount', 'googlelogin', ['back' => $back], true)}" {else}href="{$link->getModuleLink('jxheaderaccount', 'googlelogin', [], true)}"{/if} title="{l s='Google Login Manager' mod='jxheaderaccount'}">
      <i class="fa fa-google-plus" aria-hidden="true"></i>
      {if !$google_id}{l s='Connect With Google' mod='jxheaderaccount'}{else}{l s='Google Login Manager' mod='jxheaderaccount'}{/if}
    </a>
  </li>
{/if}
{if $vk_status}
  <li class="ma-link-item col-lg-2 col-md-3 col-sm-4 col-6">
    <a {if isset($back) && $back}href="{$link->getModuleLink('jxheaderaccount', 'vklogin', ['back' => $back], true)}" {else}href="{$link->getModuleLink('jxheaderaccount', 'vklogin', [], true)}"{/if} title="{l s='VK Login Manager' mod='jxheaderaccount'}">
      <i class="fa fa-vk" aria-hidden="true"></i>
      {if !$vkcom_id}{l s='Connect With VK' mod='jxheaderaccount'}{else}{l s='VK Login Manager' mod='jxheaderaccount'}{/if}
    </a>
  </li>
{/if}

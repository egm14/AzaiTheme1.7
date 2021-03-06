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
{block name='head_charset'}
  <meta charset="utf-8">
{/block}

{*ASSIGN GLOBAL VARIABLES TO USE ON AZAI*}

{*Variable behavior form objective Quote or Sale*}
{assign var=packBehavior value="quote" scope="global"}

{if $packBehavior == "quote"}

    {if ($customer.id_default_group == 12 or $customer.id_default_group == 13)}
        {assign var=packageAzai value="1" scope="global"}
        {assign var=packageAzaiStep value="1" scope="global"}
        {assign var="WMinQuoteOrder" value="500" scope="global"}
    {else}
        <!-- Quantity package split by category id at the shop-->
        {if $product.id_category_default == 12 or $product.id_category_default == 15 or $product.id_category_default == 16 or $product.id_category_default == 37 or $product.id_category_default == 36 or $product.id_category_default == 61 or $product.id_category_default == 62 or $product.id_category_default == 55 or $product.id_category_default == 56 or $product.id_category_default == 57 or $product.id_category_default == 58 or $product.id_category_default == 33}  
          {assign var=packageAzai value="3" scope="global"}
          {assign var=packageAzaiStep value="3" scope="global"}
          {assign var="WMinQuoteOrder" value="0" scope="global"}
        {else}
        <!-- Quantity package by other product category -->
          {assign var=packageAzai value="3" scope="global"}
          {assign var=packageAzaiStep value="1" scope="global"}
          {assign var="WMinQuoteOrder" value="0" scope="global"}
        {/if}
    {/if}
{else}
    {if ($customer.id_default_group == 12 or $customer.id_default_group == 13)}
        {assign var=packageAzai value="1" scope="global"}
        {assign var=packageAzaiStep value="1" scope="global"}
        {assign var="WMinQuoteOrder" value="500" scope="global"}
    {else}  
        <!-- Quantity package split by category id at the shop-->
        {if $product.id_category_default == 12 or $product.id_category_default == 15 or $product.id_category_default == 16 or $product.id_category_default == 37 or $product.id_category_default == 36 or $product.id_category_default == 61 or $product.id_category_default == 62 or $product.id_category_default == 55 or $product.id_category_default == 56 or $product.id_category_default == 57 or $product.id_category_default == 58 or $product.id_category_default == 33}  
          {assign var=packageAzai value="3" scope="global"}
          {assign var=packageAzaiStep value="3" scope="global"}
          {assign var="WMinQuoteOrder" value="0" scope="global"}
        {else}
        <!-- Quantity package by other product category -->
          {assign var=packageAzai value="3" scope="global"}
          {assign var=packageAzaiStep value="3" scope="global"}
          {assign var="WMinQuoteOrder" value="0" scope="global"}
        {/if}
    {/if}

{/if}



 

{assign var=azaimayoreo value="azaimayoreo" scope="global"}

<!-- Creatting new variable about shop-->
<script type="text/javascript" hidden>
      /*var ShopAzai = {ldelim}
        shop : {$shop|@json_encode nofilter},
        page : {$page|@json_encode nofilter},
        currency : {$currency|@json_encode nofilter},
        language : {$language|@json_encode nofilter},
        cart : {$cart|@json_encode nofilter},
        customer: {$customer|@json_encode nofilter}
        urls : {*$urls|@json_encode nofilter*}
        {rdelim}*/
        var packBehavior = "{$packBehavior|escape:javascript}";
        var cGroup = "{$customer.id_default_group}";
</script>

{block name='head_ie_compatibility'}
  <meta http-equiv="x-ua-compatible" content="ie=edge">
{/block}
  {if $shop.name == $azaimayoreo}
    <div id="ship"><div class="ship-text">{l s='Para realizar compra debes registrate.' d='Shop.Theme.Global'}</div></div>
  {else}
   <div id="ship"><div class="ship-text"> {*$azaimayoreo*}{l s='Free Shipping Over $90 USA | Over $150 México (1 - 2 days) | Rep. Dom. Envío Gratis (2 - 3 Dias)' d='Shop.Theme.Global'}</div></div>
  {/if}
  
{block name='head_seo'}
  <title id="page-title">{block name='head_seo_title'}{$page.meta.title}{/block}</title>
  <meta name="description" content="{block name='head_seo_description'}{$page.meta.description}{/block}">
  <meta name="keywords" content="{block name='head_seo_keywords'}{$page.meta.keywords}{/block}">
  {if $page.meta.robots !== 'index'}
    <meta name="robots" content="{$page.meta.robots}">
  {/if}
  {if $page.canonical}
    <link rel="canonical" href="{$page.canonical}">
  {/if}
{/block}

{block name='head_viewport'}
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0,user-scalable=0"/>
{/block}

{block name='head_icons'}
  <link rel="icon" type="image/vnd.microsoft.icon" href="{$shop.favicon}?{$shop.favicon_update_time}">
  <link rel="shortcut icon" type="image/x-icon" href="{$shop.favicon}?{$shop.favicon_update_time}">
{/block}
<!--
<script type="text/javascript">
function downloadJSAtOnload() {
var element = document.createElement("script");
element.src = "defer.js";
document.body.appendChild(element);
}
if (window.addEventListener)
window.addEventListener("load", downloadJSAtOnload, false);
else if (window.attachEvent)
window.attachEvent("onload", downloadJSAtOnload);
else window.onload = downloadJSAtOnload;
</script>-->

{block name='hook_header'}
  {$HOOK_HEADER nofilter}
{/block}

{block name='stylesheets'}
  {include file="_partials/stylesheets.tpl" stylesheets=$stylesheets}
{/block}

{block name='javascript_head'}
      {include file="_partials/javascript.tpl" javascript=$javascript.head vars=$js_custom_vars}
{/block}

{block name='hook_extra'}
<script src='https://www.google.com/recaptcha/api.js'></script>
{/block}

{assign var="parts" value=":"|explode:$urls.shop_domain_url}
         
  {if $parts[1] != "//localhost"}
    {literal}
      
        <!-- Google Tag Manager -->
        <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
        new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
        j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
        'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
        })(window,document,'script','dataLayer','GTM-PBFFQKC');</script>
        <!-- End Google Tag Manager -->
      
    {/literal}
  {/if}

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
*  @author Snegurka <site@web-esse.ru>
*  @copyright  2007-2018 PrestaShop SA
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}
{if $logged}
        <a class="add_to_ws_wishlist {if !$advansedwishlistis17}add_to_ws_wishlist_17{/if}" title="{l s='Add to wishlist' mod='advansedwishlist'}" data-id-product="{$product['id_product']|escape:'htmlall':'UTF-8'}" data-id-product-attribute="{$product['id_product_attribute']|escape:'htmlall':'UTF-8'}"
        data-ids="{$product['id_product']|escape:'htmlall':'UTF-8'}_{$product['id_product_attribute']|escape:'htmlall':'UTF-8'}_0_{$id_address_delivery|escape:'htmlall':'UTF-8'}">
            {if $advansedwishlistis17 == 1}
            <!--<i class="material-icons">schedule</i>-->

            <i class="fa fa-heart-o" aria-hidden="true"></i>
            {else}
            <i class="icon-clock-o"></i>
            {/if}
        </a>
{else}
<div class="wrap_allert">
<p class="buttons_bottom_block">
        <a title="{l s='Add to wishlist' mod='advansedwishlist'}" onclick="return false;">
            {if $advansedwishlistis17 == 1}
            <i class="material-icons">schedule</i>
            {else}
            <i class="icon-clock-o"></i>
            {/if}
        </a>
</p>        
    <div class="allert_note">{l s='You must be logged' mod='advansedwishlist'}
    <p class="login_links">
    <a class="inline" href="{$link->getPageLink('my-account', true)|escape:'htmlall':'UTF-8'}">{l s='Sign in' mod='advansedwishlist'}</a> | <a class="inline" href="{$link->getPageLink('my-account', true)|escape:'htmlall':'UTF-8'}">{l s='Register' mod='advansedwishlist'}</a>
    </p>
    </div>

    </div>
{/if}
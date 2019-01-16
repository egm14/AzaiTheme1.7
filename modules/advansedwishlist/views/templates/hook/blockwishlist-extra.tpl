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
<script>
var single_mode = '{$single_mode}';
var advansedwishlist_ajax_controller_url = '{$advansedwishlist_ajax_controller_url nofilter}';
var added_to_wishlist = '{l s='The product was successfully added to your wishlist.' mod='advansedwishlist' js=1}'
var added_to_wishlist_btn = '{l s='Added to wishlist' mod='advansedwishlist' js=1}';
var add_to_wishlist_btn = '{l s='Add to wishlist' mod='advansedwishlist' js=1}';
var idDefaultWishlist = '{$id_wishlist}';
{if $advansedwishlistis17 == 1}
/*var wishlist_btn_icon = '<i class="material-icons">Hola</i>';*/
var wishlist_btn_icon = '<i class="fa fa-heart" aria-hidden="true"></i>';
var ps_ws_version = 'advansedwishlistis17';
{else}
var wishlist_btn_icon = '<i class="icon icon-heart"></i>';
var ps_ws_version = 'advansedwishlistis16';
{/if}
</script>

{if $logged}
    <div id="wishlist_button_block" class="buttons_bottom_block {if $issetProduct}wrap_allert{/if}">
    {if isset($wishlists) && count($wishlists) > 1}

        <select id="idWishlist">
            {foreach $wishlists as $wishlist}
                <option value="{$wishlist.id_wishlist|escape:'htmlall':'UTF-8'}">{$wishlist.name|escape:'htmlall':'UTF-8'}</option>
            {/foreach}
        </select>
        <button class="btn btn-primary" onclick="WishlistCart('wishlist_block_list', 'add', '{$id_product|intval}', $('#idCombination').val(), 1, $('#idWishlist').val()); return false;"  title="{l s='Add to wishlist' mod='advansedwishlist'}">
{if $wl_custom_font == 1 || (!$wl_custom_font && $advansedwishlistis17 == 1)}
<i class="material-icons">favorite</i>
{elseif $wl_custom_font == 3}
<span class="jms-heart-1"></span>
{else}
<i class="icon-heart"></i>
{/if}
        {l s='Add' mod='advansedwishlist'}
        </button>

    {else}
        {if $advansedwishlistis17}
        <input type="hidden" name="id_product_attribute" id="idCombination" value="{$id_product_attribute|intval}">
        {/if}
        
        {if $issetProduct}
            <a href="#" id="wishlist_button" class="checked" onclick="WishlistCart('wishlist_block_list', 'delete', '{$id_product|intval}', $('#idCombination').val(), 1, {$id_wishlist|intval}); return false;">
{if $wl_custom_font == 1 || (!$wl_custom_font && $advansedwishlistis17 == 1)}
<i class="material-icons">favorite</i>
{elseif $wl_custom_font == 3}
<span class="jms-heart-1"></span>
{else}
<i class="icon-heart"></i>
{/if}
            {l s='Added to wishlist' mod='advansedwishlist'}</a>
            <div class="allert_note">{l s='Delete from wishlist' mod='advansedwishlist'}</div>
        {else}

          <a id="wishlist_button" href="#" onclick="WishlistCart('wishlist_block_list', 'add', '{$id_product|intval}', $('#idCombination').val(), 1, {$id_wishlist|intval}); return false;" rel="nofollow"  title="{l s='Add to my wishlist' mod='advansedwishlist'}">
{if $wl_custom_font == 1 || (!$wl_custom_font && $advansedwishlistis17 == 1)}
<i class="material-icons">favorite</i>
{elseif $wl_custom_font == 3}
<span class="jms-heart-1"></span>
{else}
<i class="icon-heart"></i>
{/if}
        {l s='Add to wishlist' mod='advansedwishlist'}
        </a>
        {/if}

    {/if}
        </div>
{else}
<div class="wrap_allert">
<p class="buttons_bottom_block"><a href="#" id="wishlist_button" onclick="return false;">
{if $wl_custom_font == 1 || (!$wl_custom_font && $advansedwishlistis17 == 1)}
<i class="material-icons">favorite</i>
{elseif $wl_custom_font == 3}
<span class="jms-heart-1"></span>
{else}
<i class="icon-heart"></i>
{/if}
<span class="wishlist-keyword" '>{l s='Add to wishlist' mod='advansedwishlist'}</span></a></p>

    <div class="allert_note">{l s='You must be logged' mod='advansedwishlist'}
    <p class="login_links">
    <a class="inline" href="{$link->getPageLink('my-account', true)|escape:'htmlall':'UTF-8'}">{l s='Sign in' mod='advansedwishlist'}</a> | <a class="inline" href="{$link->getPageLink('my-account', true)|escape:'htmlall':'UTF-8'}">{l s='Register' mod='advansedwishlist'}</a>
    </p>
    </div>

    </div>
{/if}

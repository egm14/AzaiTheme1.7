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

<div id="mywishlist" class="{if $advansedwishlistis17 == 1}mywishlist_17{else}mywishlist_16{/if}">
<script>
    var baseDir = '{$base_dir|addslashes}';
    var static_token = '{$static_token|addslashes}';
    var isLogged = true;
    var advansedwishlist_controller_url = '{$advansedwishlist_controller_url nofilter}';
    var mywishlist_url= '{$mywishlist_url nofilter}';
    var url_cart = "{$link->getModuleLink('ps_shoppingcart', 'ajax', array(), true)|escape:'html':'UTF-8'}";
    {if $advansedwishlistis17 != 1}
        var ps_ws_version = 'advansedwishlistis16';
    {else}
        var ps_ws_version = 'advansedwishlistis17';
    {/if} 
    var single_mode = '{$single_mode}';
</script>
{if $advansedwishlistis17 != 1}
    {capture name=path}
        <a href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}">
            {l s='My account' mod='advansedwishlist'}
        </a>
        <span class="navigation-pipe">
            {$navigationPipe|escape:'htmlall':'UTF-8'}
        </span>
        <span class="navigation_page">
            {l s='My wishlists' mod='advansedwishlist'}
        </span>
    {/capture}

    <h1 class="page-heading">{l s='My wishlists' mod='advansedwishlist'}</h1>
{/if}
    {if $id_customer|intval neq 0}
    {if !$single_mode}
        <form method="post" class="std box" id="form_wishlist">
            <fieldset>
                <h3 class="page-subheading">{l s='New wishlist' mod='advansedwishlist'}</h3>
                <div class="form-group">
                    <input type="hidden" name="token" value="{$token|escape:'html':'UTF-8'}" />
                    <label class="align_right" for="name">
                        {l s='Name' mod='advansedwishlist'}
                    </label>
                    <input type="text" id="name" name="name" class="inputTxt form-control" value="{if isset($smarty.post.name) and $errors|@count > 0}{$smarty.post.name|escape:'html':'UTF-8'}{/if}" />
                </div>
                <p class="submit">
                    <button id="submitWishlist" class="btn btn-default button button-medium" type="submit" name="submitWishlist">
                        <span> <i class="fa fa-floppy-o" aria-hidden="true"></i>{l s=' Save' mod='advansedwishlist'}
</span>
                    </button>
                </p>
            </fieldset>
        </form>
        {/if}
        {if $wishlists}
            <div id="block-history" class="block-center">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th class="col-xs-2 col-md-2">{l s='Name' mod='advansedwishlist'}</th>
                            <th class="col-xs-1 col-md-1">{l s='Qty' mod='advansedwishlist'}</th>
                            <th class="col-xs-1 col-md-1">{l s='Viewed' mod='advansedwishlist'}</th>
                            <th class="col-xs-2 col-md-2">{l s='Created' mod='advansedwishlist'}</th>
                            {if !$single_mode}
                            <th class="col-xs-2 col-md-2">{l s='Direct Link' mod='advansedwishlist'}</th>
                            <th class="col-xs-2 col-md-2">{l s='Default' mod='advansedwishlist'}</th>
                            <th class="col-xs-2 col-md-2">{l s='Delete' mod='advansedwishlist'}</th>
                            {/if}
                        </tr>
                    </thead>
                    <tbody>
                        {section name=i loop=$wishlists}
                            <tr id="wishlist_{$wishlists[i].id_wishlist|intval}">
                                <td class="col-xs-2 col-md-2">
                                    <a href="#" onclick="javascript:event.preventDefault();WishlistManage('block-order-detail', '{$wishlists[i].id_wishlist|intval}');">
                                        {$wishlists[i].name|truncate:30:'...'|escape:'htmlall':'UTF-8'}
                                    </a>
                                </td>
                                <td class="col-xs-1 col-md-1">
                                    {assign var=n value=0}
                                    {foreach from=$nbProducts item=nb name=i}
                                        {if $nb.id_wishlist eq $wishlists[i].id_wishlist}
                                            {assign var=n value=$nb.nbProducts|intval}
                                        {/if}
                                    {/foreach}
                                    {if $n}
                                        {$n|intval}
                                    {else}
                                        0
                                    {/if}
                                </td>
                                <td class="col-xs-1 col-md-1">{$wishlists[i].counter|intval}</td>
                                <td class="col-xs-2 col-md-2">{$wishlists[i].date_add|date_format:"%Y-%m-%d"|escape:'htmlall':'UTF-8'}</td>
                               {if !$single_mode}
                                <td class="col-xs-2 col-md-2">
                                    <a href="#" onclick="javascript:event.preventDefault();WishlistManage('block-order-detail', '{$wishlists[i].id_wishlist|intval}');">
                                        {l s='View' mod='advansedwishlist'}
                                    </a>
                                </td>
                                <td class="col-xs-2 col-md-2 wishlist_default">
                                    {if isset($wishlists[i].default) && $wishlists[i].default == 1}
                                        <p class="is_wish_list_default">
                                                {if $wl_custom_font}
                                                <span class="jms-heart-1"></span>
                                                {else}
                                                {if $advansedwishlistis17 == 1}
                                                <i class="material-icons">assignment_turned_in</i>
                                                {else}
                                                <i class="icon icon-check-square"></i>
                                                {/if}
                                                {/if}
                                        </p>
                                    {else}
                                        <a href="#" onclick="javascript:event.preventDefault();(WishlistDefault('wishlist_{$wishlists[i].id_wishlist|intval}', '{$wishlists[i].id_wishlist|intval}'));">
                                                {if $wl_custom_font}
                                                <span class="jms-compare-1"></span>
                                                {else}
                                                {if $advansedwishlistis17 == 1}
                                                <i class="material-icons">check_box_outline_blank</i>
                                                {else}
                                                <i class="icon icon-square"></i>
                                                {/if}
                                                {/if}
                                        </a>
                                    {/if}
                                </td>
                                <td class="col-xs-2 col-md-2 wishlist_delete">
                                    <a class="icon" href="#" onclick="javascript:event.preventDefault();return (WishlistDelete('wishlist_{$wishlists[i].id_wishlist|intval}', '{$wishlists[i].id_wishlist|intval}', '{l s='Do you really want to delete this wishlist ?' mod='advansedwishlist' js=1}'));">
                                                {if $wl_custom_font}
                                                <span class="jms-arrows-remove-1"></span>
                                                {else}
                                                {if $advansedwishlistis17 == 1}
                                                <i class="material-icons">delete</i>
                                                {else}
                                                <i class="icon-remove"></i>
                                                {/if}
                                                {/if}
                                        
                                    </a>
                                </td>
                                {/if}
                            </tr>
                        {/section}
                    </tbody>
                </table>
            </div>
            <div id="block-order-detail">&nbsp;</div>
        {else}
            {if $single_mode}
            {l s='No products in the list' mod='advansedwishlist'}
            {/if}
        {/if}
    {/if}
    <ul class="footer_links clearfix">
        <li style="display:inline-block;">
            <a class="btn btn-default button button-small" style="padding:.8rem 1rem;background-color:black; color:white;" href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}">
                <span>
                    <i class="fa fa-chevron-left" aria-hidden="true"></i>
{l s='Back to Your Account' mod='advansedwishlist'}
                </span>
            </a>
        </li>
        <li style="display:inline-block;">
            <a class="btn btn-default button button-small" style="padding:.8rem 1rem; background-color:black; color:white;" href="{$base_dir|escape:'html':'UTF-8'}">
                <span>
                    <i class="fa fa-home" aria-hidden="true"></i>
{l s='Home' mod='advansedwishlist'}
                </span>
            </a>
        </li>

    </ul>
</div>

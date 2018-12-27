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

<!-- MODULE WishList -->
{if $advansedwishlistis17 == 0}
<li>
{/if}   
        <li class="ma-link-item col-lg-2 col-md-3 col-sm-4 col-6">
	<a {if $advansedwishlistis17 == 1}class="col-lg-4 col-md-6 col-sm-6"{/if} href="{$link->getModuleLink('advansedwishlist', 'mywishlist', array(), true)|escape:'html':'UTF-8'}" title="{l s='My wishlists' mod='advansedwishlist'}">
        {if $advansedwishlistis17 == 1}<span class="link-item">{/if}
        
        {if $advansedwishlistis17 == 1}
        <i class="fa fa-heart" aria-hidden="true"></i>

        {else}
        <i class="icon-heart"></i>
        {/if}
        {if $advansedwishlistis17 == 0}<span>{/if}

        {l s='My wishlists' mod='advansedwishlist'}{if $advansedwishlistis17 == 0}</span>{/if}
		
		{if $advansedwishlistis17 == 1}</span>{/if}
	</a>
        </li>
{if $advansedwishlistis17 == 0}
</li>
{/if}
<!-- END : MODULE WishList -->
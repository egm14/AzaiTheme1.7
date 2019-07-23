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
 * @author    Edwin Marte <dev@azai.com>
 * @copyright 2012-2019 PrestaShop SA
 * @license   https://opensource.org/licenses/AFL-3.0 Academic Free License 3.0 (AFL-3.0)
 * International Registered Trademark & Property of PrestaShop SA
 *}

{block name='headElement'}
 <!-- Add loader --->
  <div class="loader-page">
      <!--spinner 1<div class="lds-ripple"><div></div><div></div></div>-->
     <!-- spinner 2--><div class="spinner2"><div class="dot1"></div><div class="dot2"></div></div>
  </div> 

   <!-- Alert account create. -->
  <div id="alerts-n">
  <div class="alerts create-acount alert-success"> {l s='Created account successful!' d='Shop.Theme.Global'} </div>
  <div class="alerts create-acount alert-processing"> {l s='Procesing account' d='Shop.Theme.Global'} </div>
  <div class="alerts create-acount alert-error"> {l s='An error has occurred, please review the form.' d='Shop.Theme.Global'} </div>
  {if $shop.name != 'azaimayoreo'}
  <div class="alerts create-acount alert-success-product"> {l s='Product added to cart' d='Shop.Theme.Global'} </div>
  {else}
  <div class="alerts create-acount alert-success-product"> {l s='Product added to Order' d='Shop.Theme.Global'} </div>
  {/if}
  </div>
  <!-- Alert account created end -->
{/block}


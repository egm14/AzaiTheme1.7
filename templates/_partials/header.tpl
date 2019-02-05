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
 <!-- Add loader --->
  <div class="loader-page">
      <!--spinner 1<div class="lds-ripple"><div></div><div></div></div>-->
     <!-- spinner 2--><div class="spinner2"><div class="dot1"></div><div class="dot2"></div></div>
  </div> 
   <!-- Alert account create. -->
  <div class="alert create-acount alert-success"> {l s='Created account successful!' d='Shop.Theme.Global'} </div>
  <!-- Alert account created end -->
  
{assign var='displayMegaHeader' value={hook h='jxMegaLayoutHeader'}}
{if $displayMegaHeader}
  {$displayMegaHeader nofilter}
{else}
  {block name='header_banner'}
    <div class="header-banner">
      {hook h='displayBanner'}
    </div>
  {/block}

  {block name='header_nav'}
    <nav class="header-nav">
      <div class="container">
        <div class="row">
          <div class="col d-none d-md-block">
            {hook h='displayNav1'}
          </div>
          <div class="col-auto separator-list justify-content-end">
            {hook h='displayNav2'}
          </div>
        </div>
      </div>
    </nav>
  {/block}

  {block name='header_top'}
    <div class="header-top">
      <div class="container">
        <div class="row align-items-center">
          <div class="col-12 col-xl-3 text-center text-xl-left mb-md-2 mb-xl-0">
            <a href="{$urls.base_url}">
              <img class="logo img-fluid" src="{$shop.logo}" alt="{$shop.name}">
            </a>
          </div>
          <div class="col-12 col-xl-9 d-flex justify-content-center justify-content-xl-end align-items-center">
            {hook h='displayTop'}
          </div>
        </div>
      </div>
    </div>
  {/block}
{/if}

{block name='header_nav_mobile'}
  <div class="d-xl-none header-nav header-nav-mobile container">
    <div class="separator-list justify-content-center">
      <div id="_mobile_menu_wrapper" class="menu-toggle">
        <span class="slidebar-toggle icon-toggle" data-id-slidebar="nav-slidebar">
          <i class="material-icons-dehaze"></i>
        </span>
        <div data-off-canvas="nav-slidebar left push" class="only-mobile">
          <button type="button" class="closeSlidebar fa fa-times" aria-label="Close"></button>
          <div id="_mobile_links_toggle" class="mb-3 d-xl-none"></div>
          <div id="_mobile_jxmegamenu"></div>
          <div id="_mobile_lg_current" style="display:flex;">
          <div id="_mobile_language_selector" style="width:50%" class="d-xl-none js-dropdown mt-3"></div>
          <div id="_mobile_currency_selector" style="width:50%" class="d-xl-none js-dropdown mt-3"></div>
          </div>

          <!-- ICONOS MENU MOBILE -->
          <nav class="iconos-menu-mobile redessociales">
               <a class="fl icon-menu-login" href="#" style="display:block;"><i class="fa fa-user"></i></a>
                <a class="fb" href="//facebook.com/azaiwomen/" target="_blank"><i class="fa fa-facebook"></i></a>
                <a class="ig" href="//www.instagram.com/azaiwomen/" target="_blank"><i class="fa fa-instagram"></i></a> 
                <a class="tw" href="//twitter.com/azaiwomen/" target="_blank"><i class="fa fa-twitter"></i></a> 
                <a class="vi" href="https://goo.gl/zTJpsd" target="_blank" rel="noopener"><i class="fa fa-map-marker"></i></a>
          </nav>
        </div>
      </div>
      <div id="_mobile_user_info"></div>
      <div id="_mobile_jxsearch"></div>
      <div id="_mobile_Jxwishlist"></div>
      <div id="_mobile_cart"></div>
    </div>
  </div>
{/block}

{hook h='displayNavFullWidth'}

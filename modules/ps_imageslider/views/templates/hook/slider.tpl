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

{assign var="homeslider_paginations" value=true}
{assign var="homeslider_navigations" value=true}

{if $homeslider.slides}
  <div id="ps-image-slider" class="swiper-container" data-autoplay="{$homeslider.speed}" data-loop="{(string)$homeslider.wrap}" data-pause="{if $homeslider.pause}true{else}false{/if}">
    <ul class="list-unstyled swiper-wrapper m-0" role="listbox">
      {foreach from=$homeslider.slides item=slide name='homeslider'}
        <li class="swiper-slide" role="option" aria-hidden="{if $smarty.foreach.homeslider.first}false{else}true{/if}">
          <a href="{$slide.url}">
            <figure class="m-0">
              <img class="img-fluid lozad" 
              src="{$urls.theme_assets}OtherFile/img_category_default.png"
              data-src="{$slide.image_url}" 
              alt="{$slide.legend|escape}">
              {if $slide.title || $slide.description}
                <figcaption>
                  <h2 class="d-none">{$slide.title}</h2>
                  <div class="swiper text-center">{$slide.description nofilter}</div>
                </figcaption>
              {/if}
            </figure>
          </a>
        </li>
      {/foreach}
    </ul>
    {if $homeslider_navigations}
      <div class="swiper-button-wrapper">
        <div class="swiper-button-prev"></div>
        <div class="swiper-button-next"></div>
      </div>
    {/if}
  </div>
{/if}

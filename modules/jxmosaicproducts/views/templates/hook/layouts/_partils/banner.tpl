{*
* 2017-2018 Zemez
*
* JX Mosaic Products
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
* @author    Zemez
* @copyright 2017-2018 Zemez
* @license   http://opensource.org/licenses/GPL-2.0 General Public License (GPL 2.0)
*}

{assign var='banner' value=$data}
<div class="jxmp-frontend-banner jxmp-frontend-banner-{$banner->id}{if $banner->specific_class} {$banner->specific_class}{/if}">
  <h3>{$banner->title}</h3>
  {if $banner->url}
    <a href="{$banner->url}" title="{$banner->title}">
  {/if}
    {if $banner->image_path}
      <img class="img-fluid lozad" 
      src="{$urls.theme_assets}OtherFile/img_category_default.jpg"
      data-src="{$jxmp_image_path}{$banner->image_path}" 
      alt="{$banner->title}" />
    {/if}
    {if $banner->description}
      <div class="jxmp-banner-description">
        {$banner->description nofilter}
      </div>
    {/if}
  {if $banner->url}
    </a>
  {/if}
</div>
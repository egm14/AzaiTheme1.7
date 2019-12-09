{*
 * 2015-2017 Bonpresta
 *
 * Bonpresta Awesome Image Slider
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
 *  @author    Bonpresta
 *  @copyright 2015-2017 Bonpresta
 *  @license   http://opensource.org/licenses/GPL-2.0 General Public License (GPL 2.0)
*}

{if isset($items) && $items}
    <div class="clearfix"></div>
    <section id="bonslick">
        <ul class="bonslick-slider">
            {foreach from=$items item=item name=item}
                <li>
                    <!--a class="link-bonslick" href="{$item.url|escape:'htmlall':'UTF-8'}" title="{$item.title|escape:'htmlall':'UTF-8'}"-->
					<a class="link-bonslick">
                        {if isset($item.image) && $item.image}
                            <img class="img-responsive" 
                            data-src="{$urls.theme_assets}OtherFile/img_category_default.png"
                            src="{$image_baseurl|escape:'htmlall':'UTF-8'}{$item.image|escape:'htmlall':'UTF-8'}" alt="{$item.title|escape:'htmlall':'UTF-8'}" />
                        {/if}
                        <section class="box-bonslick">
                            {if isset($item.description) && $item.description}
                                <div class="container">
                                    <div class="bonslick-caption col-xs-6 col-sm-6">
                                        {$item.description nofilter}
                                    </div>
                                </div>
                            {/if}
                        </section>
                    </a>
                </li>
            {/foreach}
        </ul>
    </section>
{/if}

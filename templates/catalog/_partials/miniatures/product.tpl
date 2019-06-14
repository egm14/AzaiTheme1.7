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
{block name='product_miniature_item'}
  <article class="product-miniature js-product-miniature" data-id-product="{$product.id_product}" data-id-product-attribute="{$product.id_product_attribute}" itemscope itemtype="http://schema.org/Product">
    <div class="product-miniature-container">
      <div class="product-miniature-thumbnail">
        <div class="product-thumbnail">
          {block name='product_thumbnail'}
          {if $shop.name == "azaimayoreo" && $customer.is_logged == NULL}
                  <a href="{$link->getPageLink('authentication', true)|escape:'html':'UTF-8'}?create_account=1" class="product-thumbnail-link">
          {else}
                   <a href="{$product.url}" class="product-thumbnail-link">
          {/if}
              {capture name='displayProductListGallery'}{hook h='displayProductListGallery' product=$product}{/capture}
              {if $smarty.capture.displayProductListGallery}
                {hook h='displayProductListGallery' product=$product}
              {else}
                <img
                  src = "{$product.cover.bySize.home_default.url}"
                  alt = "{if !empty($product.cover.legend)}{$product.cover.legend}{else}{$product.name|truncate:30:'...'}{/if}"
                  data-full-size-image-url = "{$product.cover.large.url}"
                >
              {/if}
            </a>
          {/block}
          {block name='product_flags'}
            <ul class="product-flags">
              {foreach from=$product.flags item=flag}
                <li class="product-flag {$flag.type}">{$flag.label}</li>
              {/foreach}
            </ul>
          {/block}
          {block name='quick_view'}
            <a class="quick-view" href="#" data-link-action="quickview" data-img-cover="{$product.cover.large.url}" data-loading-text="{l s='Loading product info...' d='Shop.Theme.Actions'}">
              <i class="material-icons-zoom_in"></i>
              <span>{l s='Quick view' d='Shop.Theme.Actions'}</span>
            </a>
          {/block}
        </div>
      </div>

      <div class="product-miniature-information">
        {block name='product_name'}
          <h1 class="product-title" itemprop="name">
            {if $shop.name == "azaimayoreo"}
              {if $customer.is_logged == NULL}
                   <a href="{$link->getPageLink('authentication', true)|escape:'html':'UTF-8'}?create_account=1">{$product.name|truncate:45:'...'}</a></h1>
              {else}
                  <a href="{$product.url}">{$product.name|truncate:45:'...'}</a></h1>
              {/if}
            {/if}
        {/block}
        {block name='product_price_and_shipping'}
          {if $product.show_price && !$configuration.is_catalog}
            <div class="product-prices-md{if $product.has_discount} with-discount{/if}">
              {if $product.has_discount}
                <span class="sr-only">{l s='Regular price' d='Shop.Theme.Catalog'}</span>
                <span class="regular-price">{$product.regular_price}</span>
                {if $product.discount_type === 'percentage'}
                  <span class="discount-percentage discount-product">{$product.discount_percentage}</span>
                {elseif $product.discount_type === 'amount'}
                  <span class="discount-amount discount-product">{$product.discount_amount_to_display}</span>
                {/if}
              {/if}
              {hook h='displayProductPriceBlock' product=$product type="before_price"}
              <span class="sr-only">{l s='Price' d='Shop.Theme.Catalog'}</span>
              <span itemprop="price" class="price">{$product.price}</span>
              {if $product.has_discount}
                {hook h='displayProductPriceBlock' product=$product type="old_price"}
              {/if}
              {hook h='displayProductPriceBlock' product=$product type='unit_price'}

              {hook h='displayProductPriceBlock' product=$product type='weight'}
            </div>
          {/if}
        {/block}
        {block name='product_description_short'}
          <div class="product-description-short">{$product.description_short|strip_tags|truncate:200:'...' nofilter}</div>
        {/block}
        {block name='product_variants'}
          {if $product.main_variants}
            {include file='catalog/_partials/variant-links.tpl' variants=$product.main_variants}
          {/if}
        {/block}

        <div class="functional-buttons">
          {block name='quick_view'}
            <a class="quick-view" href="#" data-link-action="quickview" data-img-cover="{$product.cover.large.url}" data-loading-text="{l s='Loading product info...' d='Shop.Theme.Actions'}">
              <i class="material-icons-zoom_in"></i>
              <span>{l s='Quick view' d='Shop.Theme.Actions'}</span>
            </a>
          {/block}
          {hook h='displayProductListFunctionalButtons' product=$product}
          <div class="product-buttons">
            {if $product.add_to_cart_url && !$configuration.is_catalog && ({$product.minimal_quantity} < {$product.quantity})}
              <a class="add-to-cart" href="{$product.add_to_cart_url}" rel="nofollow" data-id-product="{$product.id_product}" data-id-product-attribute="{$product.id_product_attribute}" data-link-action="add-to-cart">
                <i class="fl-chapps-hand135"></i>
                <span>{l s='Add to cart' d='Shop.Theme.Actions'}</span>
              </a>
            {else}
              {if $product.customizable == 0}
                {if $shop.name == "azaimayoreo" && $customer.is_logged == NULL}
                      <a itemprop="url" class="view-product" style="display:none;" href="{$link->getPageLink('authentication', true)|escape:'html':'UTF-8'}?create_account=1" title="{l s='View product' d='Shop.Theme.Actions'}">
                  {else}
                      <a itemprop="url" class="view-product" href="{$product.url}" title="{l s='View product' d='Shop.Theme.Actions'}">
                  {/if}
                  <i class="fl-chapps-eye95"></i>
                  <span>{l s='View product' d='Shop.Theme.Actions'}</span>
                </a>
              {else}
                <a itemprop="url" class="customize" href="{$product.url}" title="{l s='Customize' d='Shop.Theme.Actions'}">
                  <i class="fl-chapps-configuration13"></i>
                  <span>{l s='Customize' d='Shop.Theme.Actions'}</span>
                </a>
              {/if}
            {/if}
          </div>
        </div>
        {block name='product_reviews'}
          {hook h='displayProductListReviews' product=$product}
        {/block}
      </div>
    </div>
    <script id="quickview-template-{$product.id}-{$product.id_product_attribute}" type="text/template">
          {if $shop.name == "azaimayoreo"}
              <div id="quickview-modal-{$product.id}-{$product.id_product_attribute}" class="quickview modal fade modal-close-inside" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-dialog-mayoreo" role="document">
                  <div class="modal-content">
                    <a href="{$product.url}" class="product-thumbnail-link"><button class="goProduct">{l s='View product' d='Shop.Theme.Actions'}<i style="margin-left:5px;" class="fa fa-chevron-right" aria-hidden="true"></i></button></a>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" aria-hidden="true"></button>
                    <div class="modal-body">
                      <div class="row m-0">
                        <div class="product-left-column col-12 col-md">
                          {block name='product_cover_thumbnails'}
                            {include file='catalog/_partials/product-cover-thumbnails.tpl'}
                          {/block}
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
          {else}
              <div id="quickview-modal-{$product.id}-{$product.id_product_attribute}" class="quickview modal fade modal-close-inside" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-sm modal-lg" role="document">
                  <div class="modal-content">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" aria-hidden="true"></button>
                    <div class="modal-body">
                      <div class="row m-0">
                        <div class="product-left-column col-12 col-md-6">
                          {block name='product_cover_thumbnails'}
                            {include file='catalog/_partials/product-cover-thumbnails.tpl'}
                          {/block}
                        </div>

                        <div class="product-right-column col-12 col-md-6">
                          <p class="product-reference">
                            {l s='Reference' d='Shop.Theme.Catalog'} <span>{$product.reference}</span>
                          </p>
                          <h1 class="product-name">{$product.name}</h1>
                         
                            <div id="quickview-product-prices"></div>
                         
                          {block name='product_buy'}
                            <div id="quickview-product-addToCart" class="product-actions"></div>
                          {/block}
                          {block name='product_description_short'}
                            <div id="product-description-short" class="d-none" itemprop="description">{$product.description_short nofilter}</div>
                          {/block}

                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
         {/if}
    </script>
  </article>
{/block}

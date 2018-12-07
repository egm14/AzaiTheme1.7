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
{extends file=$layout}

{block name='head_seo' prepend}
  <link rel="canonical" href="{$product.canonical_url}">
{/block}

{block name='head' append}
  <meta property="og:type" content="product">
  <meta property="og:url" content="{$urls.current_url}">
  <meta property="og:title" content="{$page.meta.title}">
  <meta property="og:site_name" content="{$shop.name}">
  <meta property="og:description" content="{$page.meta.description}">
  <meta property="og:image" content="{$product.cover.large.url}">
  <meta property="product:pretax_price:amount" content="{$product.price_tax_exc}">
  <meta property="product:pretax_price:currency" content="{$currency.iso_code}">
  <meta property="product:price:amount" content="{$product.price_amount}">
  <meta property="product:price:currency" content="{$currency.iso_code}">
  {if isset($product.weight) && ($product.weight != 0)}
    <meta property="product:weight:value" content="{$product.weight}">
    <meta property="product:weight:units" content="{$product.weight_unit}">
  {/if}
{/block}

{block name='content'}
  <section id="main" itemscope itemtype="https://schema.org/Product">
    <meta itemprop="url" content="{$product.url}">

    <div class="product-card row mb-2 mb-lg-3 mb-xxl-4">
      <div class="product-left-column col-12 col-md-6">
        {block name='page_content_container'}
          <section class="page-content" id="content">
            {block name='page_content'}
              {block name='product_cover_thumbnails'}
                {include file='catalog/_partials/product-cover-thumbnails.tpl'}
              {/block}
            {/block}
          </section>
        {/block}
      </div>
      <div class="product-right-column col-12 col-md-6">
        {block name='page_header_container'}
        {block name='page_header'}
            <h1 class="h2 product-name" itemprop="name">{block name='page_title'}{$product.name}{/block}</h1>
          {/block}
          <p class="product-reference">
            {l s='Reference:' d='Shop.Theme.Catalog'} <span>{$product.reference}</span>
          </p>
          
          {block name='product_availability'}
            <span id="product-availability">
              {if $product.show_availability && $product.availability_message}
                <span class="{if $product.availability == 'available'}product-available{elseif $product.availability == 'last_remaining_items'}product-last-items{else}product-unavailable{/if}">
                  {$product.availability_message}
                </span>
              {/if}
            </span>
          {/block}
          {block name='product_prices'}
            {include file='catalog/_partials/product-prices.tpl'}
          {/block}
          {block name='product_description_short'}
            <div id="product-description-short-{$product.id}" class="d-none" itemprop="description">{$product.description_short nofilter}</div>
          {/block}
        {/block}

        <div class="product-information">
          {if $product.is_customizable && count($product.customizations.fields)}
            {block name='product_customization'}
              {include file="catalog/_partials/product-customization.tpl" customizations=$product.customizations}
            {/block}
          {/if}
          <div class="product-actions">
            {block name='product_buy'}
              <form action="{$urls.pages.cart}" method="post" id="add-to-cart-or-refresh">
                <input type="hidden" name="token" value="{$static_token}">
                <input type="hidden" name="id_product" value="{$product.id}" id="product_page_product_id">
                <input type="hidden" name="id_customization" value="{$product.id_customization}" id="product_customization_id">

                {block name='product_variants'}
                  {include file='catalog/_partials/product-variants.tpl'}
                {/block}

                 <!-- Size Chart Dinamic -->
                  {block name='size_chart'}
                    {include file='catalog/sizechart.tpl'}
                  {/block}
                  <!-- End Size Chart Dinamic -->

                {block name='product_pack'}
                  {if $packItems}
                    <section class="product-pack u-carousel uc-el-pack-miniature uc-nav mb-3">
                      <h3 class="subpages-heading">{l s='This pack contains' d='Shop.Theme.Catalog'}</h3>
                      <div class="product-pack-row">
                        {foreach from=$packItems item="product_pack"}
                          {block name='product_miniature'}
                            {include file='catalog/_partials/miniatures/pack-product.tpl' product=$product_pack}
                          {/block}
                        {/foreach}
                      </div>
                    </section>
                  {/if}
                {/block}

                {block name='product_discounts'}
                  {include file='catalog/_partials/product-discounts.tpl'}
                {/block}

                {block name='product_add_to_cart'}
                  {include file='catalog/_partials/product-add-to-cart.tpl'}
                {/block}

                {block name='product_additional_info'}
                  {include file='catalog/_partials/product-additional-info.tpl'}
                {/block}

                {block name='product_refresh'}
                  <input class="product-refresh ps-hidden-by-js" name="refresh" type="submit" value="{l s='Refresh' d='Shop.Theme.Actions'}">
                {/block}
              </form>
            {/block}
          </div>
        </div>
          {block name='product_tabs'}
      <div class="tabs product-tabs mb-4">
        <ul class="nav nav-tabs d-none d-md-flex align-items-md-center justify-content-md-center" role="tablist">
          {if $product.description}
            <li class="nav-item">
              <a
                class="nav-link{if $product.description} active{/if}"
                data-toggle="tab"
                href="#description"
                role="tab"
                aria-controls="description"
                {if $product.description} aria-selected="true"{/if}>{l s='Description' d='Shop.Theme.Catalog'}
              </a>
            </li>
          {/if}
          <li class="nav-item">
            <a
              class="nav-link{if !$product.description} active{/if}"
              data-toggle="tab"
              href="#product-details"
              role="tab"
              aria-controls="product-details"
              {if !$product.description} aria-selected="true"{/if}>{l s='Product Details' d='Shop.Theme.Catalog'}
            </a>
          </li>
          {if $product.attachments}
            <li class="nav-item">
              <a
                class="nav-link"
                data-toggle="tab"
                href="#attachments"
                role="tab"
                aria-controls="attachments">{l s='Attachments' d='Shop.Theme.Catalog'}
              </a>
            </li>
          {/if}
          {foreach from=$product.extraContent item=extra key=extraKey}
            <li class="nav-item">
              <a
                class="nav-link"
                data-toggle="tab"
                href="#extra-{$extraKey}"
                role="tab"
                aria-controls="extra-{$extraKey}">{$extra.title}
              </a>
            </li>
          {/foreach}
        </ul>

        <div class="tab-content" id="tab-content">
          {if $product.description}
            <div class="tab-pane fade in{if $product.description} active show{/if}" id="description" role="tabpanel">
              {block name='product_description'}
                <a class="d-md-none" data-toggle="collapse" href="#description-collapse" role="button" aria-expanded="true">{l s='Description' d='Shop.Theme.Catalog'}</a>
                <div id="description-collapse" class="product-description collapse show">{$product.description nofilter}</div>
              {/block}
            </div>
          {/if}

          {block name='product_details'}
            {include file='catalog/_partials/product-details.tpl'}
          {/block}

          {block name='product_attachments'}
            {if $product.attachments}
              <div class="tab-pane fade in" id="attachments" role="tabpanel">
                <a class="d-md-none collapsed" data-toggle="collapse" href="#attachments-collapse" role="button" aria-expanded="false">{l s='Attachments' d='Shop.Theme.Catalog'}</a>
                <section id="attachments-collapse" class="product-attachments collapse d-md-block">
                  <h3 class="h4">{l s='Download' d='Shop.Theme.Actions'}</h3>
                  {foreach from=$product.attachments item=attachment}
                    <div class="attachment mb-2">
                      <h4 class="h6"><a href="{url entity='attachment' params=['id_attachment' => $attachment.id_attachment]}">{$attachment.name}</a></h4>
                      <p>{$attachment.description}</p>
                      <a class="btn btn-primary btn-sm" href="{url entity='attachment' params=['id_attachment' => $attachment.id_attachment]}">
                        {l s='Download' d='Shop.Theme.Actions'} ({$attachment.file_size_formatted})
                      </a>
                    </div>
                  {/foreach}
                </section>
              </div>
            {/if}
          {/block}

          {foreach from=$product.extraContent item=extra key=extraKey}
            <div class="tab-pane fade in {$extra.attr.class}" id="extra-{$extraKey}" role="tabpanel" {foreach $extra.attr as $key => $val} {$key}="{$val}"{/foreach}>
              <a class="d-md-none collapsed" data-toggle="collapse" href="#extra-{$extraKey}-collapse" role="button" aria-expanded="false">{$extra.title}</a>
              <div id="extra-{$extraKey}-collapse" class="collapse d-md-block">
                {$extra.content nofilter}
              </div>
            </div>
          {/foreach}
        </div>
      </div>
    {/block}

      </div>
    </div>
    

    {block name='product_accessories'}
      {if $accessories}
        <section class="container col-xl-12 product-accessories clearfix grid u-carousel uc-el-product-miniature uc-nav">
          <h3 class="text-center subpages-heading mb-3">{l s='You might also like' d='Shop.Theme.Catalog'}</h3>
          <div class="products">
            {foreach from=$accessories item="product_accessory"}
              {block name='product_miniature'}
                {include file='catalog/_partials/miniatures/product.tpl' product=$product_accessory}
              {/block}
            {/foreach}
          </div>
        </section>
      {/if}
    {/block}

    {block name='product_footer'}
      {assign var='displayMegaProductFooter' value={hook h='jxMegaLayoutProductFooter' product=$product category=$category}}
      {if $displayMegaProductFooter}
        {$displayMegaProductFooter nofilter}
      {else}
        {hook h='displayFooterProduct' product=$product category=$category}
      {/if}
    {/block}

    {block name='product_images_modal'}
      {include file='catalog/_partials/product-images-modal.tpl'}
    {/block}

    {block name='page_footer_container'}
      <footer class="page-footer">
        {block name='page_footer'}
          <!-- Footer content -->
        {/block}
      </footer>
    {/block}
  </section>
{/block}

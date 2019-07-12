{*
* 2016 ROJA45
* All rights reserved.
*
* DISCLAIMER
*
* Changing this file will render any support provided by us null and void.
*
*  @author 			Roja45
*  @copyright  		2016 Roja45
*  @license          /license.txt
*}

<div id="_desktop_quotecart" class="">
    <div class="quotation_cart {if $nbr_products > 0}active{else}inactive{/if} collapsed">
        {if $nbr_products > 0}
        <a href="{url entity='module' name='roja45quotationspro' controller='QuotationsProFront' params = ['action' => 'quoteSummary']}" class="quote-summary" >
            {/if}
        <div class="header" data-refresh-url="{url entity='module' name='roja45quotationspro' controller='QuotationsProFront' params = ['action' => 'quoteSummary']}">

            <!--<i class="material-icons">assignment</i>-->
            <i class="fl-chapps-hand135" aria-hidden="true" style="font-size:1.65rem;margin-top:-6px;"></i>
            <span class="hidden-sm-down">{l s='Quote' mod='roja45quotationspro'}</span>
            {if $request_qty > 0}<span class="cart-products-count">{$request_qty}</span>{/if}
            {if $nbr_products > 0}
            {if $roja45quotationspro_enable_quote_dropdown}
            <!--<i class="material-icons expand-more"></i>---->
            {/if}
            {/if}
        </div>
        {if $nbr_products > 0}
            </a>
        {/if}
        {if isset($requested_products)}
        <div class="quote-cart-block dropdown-menu">
            
            <div class="block-content">
                <dl class="products">
                    {foreach from=$requested_products item=product}
                    <dt data-id="cart_block_product_3_13_0" class="first_item">
                        <a class="cart-images" href="{$product.link}" title="{$product.name}">
                            <img src="{$product.image_quote_cart}" alt="{$product.image_title}">
                        </a>
                        <div class="cart-info">
                            <div class="product-name">
                                <span class="product-quantity">{$product.qty_in_cart|escape:'html':'UTF-8'}</span>
                                <a class="cart_block_product_name" href="{$product.link}" title="{$product.name}">{$product.name}</a>
                            </div>
                            {if isset($product.attributes)}
                            <div class="product-atributes">
                                <a href="{$product.link}" title="Product detail">
                                    {assign var="color" value=","|explode:$product.attributes}
                                    {$color[0]}</a>

                            {assign var="priceValue" value=$product.price*($product.quote_quantity*9)}
                            <p>${$priceValue}</p>
                            
                            {assign var ="priceSum" value= $priceValue}
                            <p>{$priceSum}</p>

                            </div>
                            {/if}
                        </div>
                        <a  class="remove-from-cart"
                            rel="nofollow"
                            href="{url entity='module' name='roja45quotationspro' controller='QuotationsProFront' params = ['action' => 'deleteProductFromRequest', 'ajax' => 1, 'id_roja45_quotation_request' => $product.id_roja45_quotation_request, 'id_product' => $product.id_product, 'id_product_attribute' => $product.id_product_attribute]}"
                            data-link-action="remove-from-cart">
                            <i class="material-icons">delete</i>
                        </a>
                    </dt>
                    {/foreach}
                    <p class="cart-buttons">
                        <a class="btn btn-primary btn-request-quote" href="{url entity='module' name='roja45quotationspro' controller='QuotationsProFront' params = ['action' => 'quoteSummary']}" title="Check out" rel="nofollow">
                            <span>{l s='Request Quote' d='Shop.Theme.Actions'}</span>
                        </a>
                    </p>
                </dl>
            </div>
        </div>
        {/if}
    </div>
</div>



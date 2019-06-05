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

<tr id="product_{$product.id_product|escape:'html':'UTF-8'}_{$product.id_product_attribute|escape:'html':'UTF-8'}_{if $displayQuantity > 0}nocustom{else}0{/if}"
    class="quote_item{if isset($productLast) && $productLast && (!isset($ignoreProductLast) || !$ignoreProductLast)} last_item{/if}{if isset($productFirst) && $productFirst} first_item{/if}{if $displayQuantity == 0} alternate_item{/if} {if $odd}odd{else}even{/if}">
    <td class="quote_product">
        <a href="{$product.link|escape:'html':'UTF-8'}">
            <img src="{$link->getImageLink($product.link_rewrite, $product.id_image, 'small_default')|escape:'html':'UTF-8'}"
                 alt="{$product.name|escape:'html':'UTF-8'}"
                 {if isset($smallSize)}
                 width="{$smallSize.width|escape:'html':'UTF-8'}"
                 height="{$smallSize.height|escape:'html':'UTF-8'}"{/if}/>
        </a>
    </td>
    <td class="quote_description">
        {capture name=sep} : {/capture}
        {capture}{l s=' :' mod='roja45quotationspro'}{/capture}
        <h4 class="product-name" style="margin-bottom:.3rem;">
            <a href="{$product.link|escape:'html':'UTF-8'}">{$product.name|escape:'html':'UTF-8'}</a>
        </h4>
        {if isset($product.attributes) && $product.attributes}
            <p>
                <a href="{$product.link|escape:'html':'UTF-8'}">
                    {*assign var="color" value=","|split:$product.attributes*}{*color[0]*}
                </a>
            </p>
        {/if}

        {assign var="priceValue" value=$product.price*($product.quote_quantity*9)}
            <p>${$priceValue}</p>
        
        <a href="{$product.link}" title="Product detail">
                                    {assign var="color" value=","|explode:$product.attributes}
                                    {$color[0]}</a>

        
        {if $product.reference}
        <small class="quote_ref">{l s='SKU: ' mod='roja45quotationspro'}{$product.reference|escape:'html':'UTF-8'}</small>
        {/if}
    </td>

    <td class="quote_quantity text-center"
        data-title="{l s='Quantity' mod='roja45quotationspro'}"
        data-id-product="{$product.id_product|escape:'html':'UTF-8'}"
        data-id-product-attribute="{$product.id_product_attribute|escape:'html':'UTF-8'}">
        <input
            type="text"
            name="quote_quantity"
            id="quantity_wanted" 
            value="{$product.quote_quantity|escape:'html':'UTF-8'}"
            class="quote_quantity input-group"
            min="{$product.minimal_quantity|escape:'html':'UTF-8'}"
            aria-label="{l s='Quantity' mod='roja45quotationspro'}">
    </td>

    <td class="quote_delete text-center" data-title="{l s='Delete' mod='roja45quotationspro'}">
        <div>
            <a rel="nofollow" title="{l s='Delete' mod='roja45quotationspro'}" class="quote_quantity_delete"
               id="{$product.id_product|escape:'html':'UTF-8'}_{$product.id_product_attribute|escape:'html':'UTF-8'}_{if $displayQuantity > 0}nocustom{else}0{/if}"
               href="{url entity='module' name='roja45quotationspro' controller='QuotationsProFront' params = ['action' => 'deleteFromQuote', 'id_product' => $product.id_product, 'id_product_attribute' => $product.id_product_attribute]}">
                <i class="material-icons">delete</i>
            </a>
        </div>
    </td>
</tr>

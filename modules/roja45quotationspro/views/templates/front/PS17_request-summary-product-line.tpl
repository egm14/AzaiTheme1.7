{*
* 2016 ROJA45
* All rights reserved.
*
* DISCLAIMER
*
* Changing this file will render any support provided by us null and void.
*
*  @author          Roja45
*  @copyright       2016 Roja45
*  @license          /license.txt
*}

{if $product.id_category_default == 12 or $product.id_category_default == 15 or $product.id_category_default == 16 or $product.id_category_default == 37 or $product.id_category_default == 36 or $product.id_category_default == 61 or $product.id_category_default == 62 or $product.id_category_default == 55 or $product.id_category_default == 56 or $product.id_category_default == 57 or $product.id_category_default == 58 or $product.id_category_default == 33}  
      {assign var=packageAzai value="3" scope="global"}
      {assign var=packageAzaiStep value="3" scope="global"}
      {assign var="WMinQuoteOrder" value="0" scope="global"}
    {else}
      {assign var=packageAzai value="3" scope="global"}
      {assign var=packageAzaiStep value="3" scope="global"}
      {assign var="WMinQuoteOrder" value="0" scope="global"}
    {/if}

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
            <!--<p>
                <a href="{$product.link|escape:'html':'UTF-8'}">
                    {*assign var="color" value=","|split:$product.attributes*}{*color[0]*}
                </a>
            </p>-->
        {/if}

        {assign var="priceValue" value=$product.product_price*($product.quote_quantity*$packageAzai) scope=parent}
         <p style="margin-bottom:0px;" id="product-price-quantity" data-price="{$product.product_price}" >{$product.product_price_currency_iso}{$product.product_price_currency_symbol} <span class="product-amount">{$priceValue|number_format:2:".":","}</span></p>

        <a href="{$product.link}" title="Product detail">
            {assign var="color" value=","|explode:$product.attributes}{$color[0]}
        </a>

        {if $product.reference}
        <small class="quote_ref">{assign var="productReference" value="-"|explode:$product.reference}{l s='SKU: ' mod='roja45quotationspro'}{$productReference[1]|escape:'html':'UTF-8'}</small>
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
            aria-label="{l s='Quantity' mod='roja45quotationspro'}"
            data-pack="{$packageAzai}">
    </td>

    <td class="quote_delete text-center" data-title="{l s='Delete' mod='roja45quotationspro'}">
        <div>
            <a rel="nofollow" title="{l s='Delete' mod='roja45quotationspro'}" class="quote_quantity_delete"
               id="{$product.id_product|escape:'html':'UTF-8'}_{$product.id_product_attribute|escape:'html':'UTF-8'}_{if $displayQuantity > 0}nocustom{else}0{/if}"
               href="{url entity='module' name='roja45quotationspro' controller='QuotationsProFront' params = ['action' => 'deleteFromQuote', 'id_product' => $product.id_product, 'id_product_attribute' => $product.id_product_attribute]}" >
                <i class="material-icons">delete</i>
            </a>
        </div>
    </td>
</tr>



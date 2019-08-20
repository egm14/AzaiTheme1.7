{*
* 2016 ROJA45.COM
* All rights reserved.
*
* DISCLAIMER
*
* Changing this file will render any support provided by us null and void.
*
*  @author 			Roja45
*  @copyright  		2016 Roja45
*}

<div id="roja45quotationspro_buttons_block" class="roja45quotationspro_button_container no-print ">
     

    <div class="qty" style="display:none!important;">
    
               <input 
                 type="number" 
                 step="6"
                 name="qty" 
                 id="quote_quantity_wanted"
                 value="{if isset($product->product_attribute_minimal_quantity) && $product->product_attribute_minimal_quantity >= 1}{$product->product_attribute_minimal_quantity|intval}{else}{$product->minimal_quantity|intval}{/if}"
                 min="1"
                 class="form-control"
                 aria-label="{l s='Quantity' mod='roja45quotationspro'}"
                 style="max-width:70px;color:black;height:35px;padding:10px;min-width:35px;"
                 >
            
    </div>
    <div class="add">
        <a class="btn btn-primary add-to-quote {if $roja45_quotation_enablequotecart}{if $roja45_quotation_useajax}ajax_add_quote_button{else}add_quote_button{/if}{/if}"
           href="{url entity='module' name='roja45quotationspro' controller='QuotationsProFront' params = ['action' => 'addToQuote', 'id_product' => $product->id, 'id_product_attribute' => $id_product_attribute, 'qty' => $packageAzaiStep ]}"
           rel="nofollow"
           title="{l s='Add to quote' mod='roja45quotationspro'}"
           data-url="{url entity='module' name='roja45quotationspro' controller='QuotationsProFront' params = ['action' => 'addToQuote']}"
           data-id-product-attribute="{$id_product_attribute}"
           data-id-product="{$product->id}"
           data-minimal-quantity="{if isset($product->product_attribute_minimal_quantity) && $product->product_attribute_minimal_quantity >= 1}{$product->product_attribute_minimal_quantity|intval}{else}{$product->minimal_quantity|intval}{/if}">
            <i class="material-icons">format_list_numbered</i>
            {l s='Add to quote' mod='roja45quotationspro'}
        </a>
        <br />
    </div>
</div>

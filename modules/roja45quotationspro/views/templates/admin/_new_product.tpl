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
<div id="new_quotation_product" class="panel" style="display:none;margin-bottom:10px;">
<table class="table">
    <thead>
        <tr>
            <th>{l s='Product' mod='roja45quotationspro'}</th>
            <th>{l s='Combination' mod='roja45quotationspro'}</th>
            <th>{l s='Comment' mod='roja45quotationspro'}</th>
            <th>{l s='Wholesale Price' mod='roja45quotationspro'}</th>
            <th>{l s='Retail Price' mod='roja45quotationspro'}&nbsp;{l s='(tax excl.)' mod='roja45quotationspro'}</th>
            <th class="qty-header" data-original-text="{l s='Qty' mod='roja45quotationspro'}">{l s='Qty' mod='roja45quotationspro'}</th>
            <th>{l s='Total' mod='roja45quotationspro'}</th>
            <th></th>
        </tr>
    </thead>
    <tbody>
    <tr class="product-line-row">
        <input type="hidden"
               class="product_quotation_id"
               name="product_quotation[id_product]"
               value="0" />
        <td>
            <div class="row">
                <div class="input-group">
                    <input type="text"
                           id="addProductToQuotationProductSearch"
                           name="product_quotation[product_name]"
                           value=""/>
                    <div class="input-group-addon">
                        <i class="icon-search"></i>
                    </div>
                </div>
            </div>
        </td>
        <td>
            <div class="row">
                <div id="product_quotation_product_attribute_area" style="display: none;">
                    <select name="product_quotation[id_product_attribute]"
                            id="addProductToQuotationProductAttribute"
                            class="product_quotation_id_product_attribute"></select>
                </div>
            </div>
        </td>
        <td>
            <div class="row">
                <div id="product_quotation_product_comment">
                    <input type="text"
                           name="product_quotation[comment]"
                           id="addProductToQuotationProductComment"
                           class="product_quotation_product_comment"></input>
                </div>
            </div>
        </td>
        <td class="product_wholesale_price">
            <input type="text" name="product_quotation[wholesale_price]" id="addProductToQuotationProductWholesalePrice" class="product_quotation_product_wholesale_price" disabled="disabled">
        </td>
        <td>
            <div class="row">
                <div class="input-group">
                    <div class="input-group-addon">
                        {$currency->sign|escape:'html':'UTF-8'}
                    </div>
                    <input type="text"
                           id="addProductToQuotationProductPriceTaxExcl"
                           name="product_quotation[product_price_tax_excl]"
                           class="product_quotation_price_tax_excl product_price"
                           value=""
                           disabled="disabled" />
                </div>
            </div>
        </td>
        <td class="productQuantity">
            <input type="number"
                   class="form-control product_quotation_quantity"
                   id="addProductToQuotationProductQuantity"
                   name="product_quotation[product_quantity]"
                   min="1"
                   value="1"
                   disabled="disabled" />
        </td>
        <td class="total_product">{displayPrice price=0 currency=$currency->id}</td>
        <td>
            <button type="button" class="btn btn-default" id="cancelAddProductToQuotation" style="float:right;">
                {l s='Cancel' mod='roja45quotationspro'}
            </button>
            <button type="button" class="btn btn-default" id="submitAddProductToQuotation" disabled="disabled" style="float:right;">
                {l s='Add' mod='roja45quotationspro'}
            </button>
        </td>
    </tr>
    </tbody>
</table>
</div>
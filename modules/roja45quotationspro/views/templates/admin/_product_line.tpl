{*
* 2016 ROJA45.COM
* All rights reserved.
*
* DISCLAIMER
*
* Changing this file will render any support provided by us null and void.
*
*  @author 			Roja45 <support@roja45.com>
*  @copyright  		2016 roja45.com
*}

<table class="table" id="quotationProducts">
    <thead>
    <tr>
        <th></th>
        <th><span class="title_box">{l s='Product' mod='roja45quotationspro'}</span></th>
        <th><span class="title_box">{l s='Comment' mod='roja45quotationspro'}</span></th>
        <th>
            <span class="title_box ">{l s='Wholesale' mod='roja45quotationspro'}</span>
        </th>
        <th>
            <span class="title_box">{l s='Unit Price' mod='roja45quotationspro'}</span>
            <small class="text-muted">{if ($use_taxes)}{l s='tax incl.' mod='roja45quotationspro'}{else}{l s='tax excl.' mod='roja45quotationspro'}{/if}</small>
        </th>
        <th>
            <span class="title_box ">{l s='Quote' mod='roja45quotationspro'}</span>
            <small class="text-muted">{if ($use_taxes)}{l s='tax incl.' mod='roja45quotationspro'}{else}{l s='tax excl.' mod='roja45quotationspro'}{/if}</small>
        </th>
        <th><span class="title_box ">{l s='Qty' mod='roja45quotationspro'}</span></th>
        <th>
            <span class="title_box ">{l s='Total' mod='roja45quotationspro'}</span>
            <small class="text-muted">{if ($use_taxes)}{l s='tax incl.' mod='roja45quotationspro'}{else}{l s='tax excl.' mod='roja45quotationspro'}{/if}</small>
        </th>
        <th>
            <span class="title_box ">{l s='Total Profit' mod='roja45quotationspro'}</span>
            <small class="text-muted">{if ($use_taxes)}{l s='tax incl.' mod='roja45quotationspro'}{else}{l s='tax excl.' mod='roja45quotationspro'}{/if}</small>
        </th>
        <th>
            <span class="title_box ">{l s='Deposit %' mod='roja45quotationspro'}</span>
        </th>
        <th class="add_product_quotation_fields fixed-width-lg"></th>
        <th style="display:none;" class="edit_product_quotation_fields fixed-width-lg"></th>
    </tr>
    </thead>
    <tbody>
    {foreach from=$requested_products item=product key=k}
        {if ($use_taxes)}
            {assign var=product_price value=$product['unit_price_tax_incl']}
        {else}
            {assign var=product_price value=($product['unit_price_tax_excl'])}
        {/if}
        <tr class="product-line-row">
            <input type="hidden" name="product_quotation[product_quotation_id]" class="product_quotation_id" value="{$product['id_roja45_quotation_product']|escape:'html':'UTF-8'}"/>
            <input type="hidden" name="product_quotation[id_product]" class="product_id" value="{$product['id_product']|escape:'html':'UTF-8'}"/>
            {if $product.deleted}
                <td></td>
                <td>{l s='Product no longer available' mod='roja45quotationspro'}</td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                {if $deposit_enabled}
                <td></td>
                {/if}
                <td>
                    <button type="button" class="btn btn-default delete_product_quotation_line" {if $deleted}disabled="disabled"{/if}>
                        <i class="icon-trash"></i>
                        {l s='Delete' mod='roja45quotationspro'}
                    </button>
                </td>
            {else}
                <td>{if isset($product.image_tag)}<img src="{$product.image_tag|escape:'htmlall':'UTF-8'}" alt="{$product['product_title']|escape:'html':'UTF-8'}" class="img img-thumbnail" />{/if}</td>
                <td>
                    <a href="{$link->getAdminLink('AdminProducts')|escape:'html':'UTF-8'}&amp;id_product={$product['id_product']|intval|escape:'html':'UTF-8'}&amp;updateproduct&amp;token={getAdminToken tab='AdminProducts'}">
                        <span class="productName">{$product['product_title']|escape:'html':'UTF-8'}</span><br/>
                        {if $product.reference}{l s='Reference #:' mod='roja45quotationspro'} {$product.reference|escape:'html':'UTF-8'}<br/>{/if}
                        {if $product.supplier_reference}{l s='Supplier #' mod='roja45quotationspro'} {$product.supplier_reference|escape:'html':'UTF-8'}{/if}
                    </a>
                </td>
                <td>
                    {if isset($product.comment)}
                    <span class="product_comment_show">{$product.comment|substr:0:20|escape:'htmlall':'UTF-8'}</span>
                    <div class="product_comment_edit" style="display:none;">
                        <div class="fixed-width-md">
                            <input type="text" name="product_quotation[comment]" class="product_quotation_comment product_comment" value="{$product.comment|escape:'htmlall':'UTF-8'}"/>
                        </div>
                    </div>
                    {/if}
                </td>
                <td>
                    <span>{displayPrice price=Tools::ps_round(Tools::convertPrice($product.wholesale_price, $currency), 2) currency=$currency->id}</span>
                </td>
                <td>
                    {if ($use_taxes)}
                        <!--<span>{displayPrice price=Tools::ps_round(Tools::convertPrice($product.list_price_incl, $currency), 2) currency=$currency->id}</span>-->
                        <span>{displayPrice price=$product.list_price_incl currency=$currency->id}</span>
                    {else}
                    <!-- <span>{displayPrice price=Tools::ps_round(Tools::convertPrice($product.list_price_excl, $currency), 2) currency=$currency->id}</span>-->
                        <span>{displayPrice price=$product.list_price_excl currency=$currency->id}</span>
                    {/if}
                </td>
                <td>
                    <span class="product_price_show">
                        {if ($use_taxes)}
                            {displayPrice price=Tools::ps_round(Tools::convertPrice($product['unit_price_tax_incl'], $currency), 2) currency=$currency->id}
                        {else}
                            {displayPrice price=Tools::ps_round(Tools::convertPrice($product['unit_price_tax_excl'], $currency), 2) currency=$currency->id}
                        {/if}
                    </span>
                    {if !($quotation->isLocked())}
                        <div class="product_price_edit" style="display:none;">
                            {if ($use_taxes)}
                                <div class="fixed-width-md">
                                    <div class="input-group">
                                        <div class="input-group-addon">{$currency->sign|escape:'html':'UTF-8'}</div>
                                        <input type="text" name="product_quotation[product_price_tax_incl]" class="product_quotation_price_tax_incl product_price" value="{Tools::ps_round(Tools::convertPrice($product['unit_price_tax_incl'], $currency), 6)|escape:'html':'UTF-8'}" onkeydown="javascript: if(event.keyCode == 13)submitProductLineChange(event);"/>
                                    </div>
                                </div>
                            {else}
                                <div class="fixed-width-md">
                                    <div class="input-group">
                                        <div class="input-group-addon">{$currency->sign|escape:'html':'UTF-8'}</div>
                                        <input type="text" name="product_quotation[product_price_tax_excl]" class="product_quotation_price_tax_excl product_price" value="{Tools::ps_round(Tools::convertPrice($product['unit_price_tax_excl'], $currency), 6)|escape:'html':'UTF-8'}"/>
                                    </div>
                                </div>
                            {/if}
                        </div>
                    {/if}
                </td>
                <td class="productQuantity">
                    <span class="fixed-width-xs product_quantity_show">{$product['qty']|escape:'html':'UTF-8'}</span>
                    {if !($quotation->isLocked())}
                        <span class="product_quantity_edit" style="display:none;">
                            <input type="number"
                                   name="product_quotation[product_quantity]"
                                   class="form-control fixed-width-xs product_quotation_quantity"
                                   value="{$product['qty']|escape:'html':'UTF-8'}"/>
                        </span>
                    {/if}
                </td>
                <td class="total_product">
                    <span class="product_price_show">
                        {if ($use_taxes)}
                            {displayPrice price=Tools::ps_round(Tools::convertPrice( ($product['unit_price_tax_incl']*($product['qty'])), $currency), 2) currency=$currency->id}
                        {else}
                            {displayPrice price=Tools::ps_round(Tools::convertPrice(($product['unit_price_tax_excl']*($product['qty'])), $currency), 2) currency=$currency->id}
                        {/if}
                    </span>
                </td>
                <td class="total_product_profit">
                    <span class="product_price_show">
                        {if ($use_taxes)}
                            {displayPrice price=Tools::ps_round(Tools::convertPrice((($product['unit_price_tax_incl']-$product['wholesale_price'])*($product['qty'])), $currency), 2) currency=$currency->id}
                        {else}
                            {displayPrice price=Tools::ps_round(Tools::convertPrice((($product['unit_price_tax_excl']-$product['wholesale_price'])*($product['qty'])), $currency), 2) currency=$currency->id}
                        {/if}
                    </span>
                </td>
                {if $deposit_enabled}
                <td class="deposit_required">
                    <span class="deposit_required_show">{$product['deposit_amount']|escape:'html':'UTF-8'}</span>
                    <div class="deposit_required_edit" style="display:none;">
                        <div class="fixed-width-md">
                            <input type="text" name="product_quotation[deposit_amount]" class="product_quotation_deposit_amount product_deposit_amount" value="{$product.deposit_amount|escape:'htmlall':'UTF-8'}"/>
                        </div>
                    </div>
                </td>
                <td class="total_to_pay">
                    <span class="fixed-width-xs total_to_pay_show">
                        {if ($use_taxes)}
                            {displayPrice price=Tools::ps_round(Tools::convertPrice($product['product_price_deposit_incl'], $currency), 2) currency=$currency->id}
                        {else}
                            {displayPrice price=Tools::ps_round(Tools::convertPrice($product['product_price_deposit_excl'], $currency), 2) currency=$currency->id}
                        {/if}
                    </span>
                </td>
                {/if}
                <td class="deposit">
                </td>
                <td class="quotation_action text-right fixed-width-lg">
                    {if !$quotation->is_template}
                    {* edit/delete controls *}
                    <div class="btn-group">
                        <button type="button" class="btn btn-default edit_product_quotation_change_link" {if $deleted}disabled="disabled"{/if}>
                            <i class="icon-pencil"></i>
                            {l s='Edit' mod='roja45quotationspro'}
                        </button>
                        <button type="button" class="btn btn-default delete_product_quotation_line" {if $deleted}disabled="disabled"{/if}>
                            <i class="icon-trash"></i>
                            {l s='Delete' mod='roja45quotationspro'}
                        </button>
                    </div>
                    {* Update controls *}
                    <div class="btn-group">
                        <button type="button" class="btn btn-default submitProductQuotationChange" style="display: none;">
                            {l s='Update' mod='roja45quotationspro'}
                        </button>
                        <button type="button" class="btn btn-default cancel_product_quotation_change_link" style="display: none;">
                            {l s='Cancel' mod='roja45quotationspro'}
                        </button>
                    </div>
                    {/if}
                </td>

            {/if}
        </tr>
    {/foreach}
    </tbody>
</table>

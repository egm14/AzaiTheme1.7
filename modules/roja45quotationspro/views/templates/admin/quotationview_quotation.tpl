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

<div class="panel-heading">
    <i class="icon-file"></i>{l s='Quotation' mod='roja45quotationspro'}</span>
    {if $quotation->id_cart}<span class="badge cart-badge"><a href="{$link->getAdminLink('AdminCarts', true)|escape:"html":"UTF-8"}&id_cart={$quotation->id_cart|escape:"html":"UTF-8"}&viewcart" target="_blank">{l s='Cart: #' mod='roja45quotationspro'}{$quotation->id_cart|escape:"html":"UTF-8"}</a></span>{/if}
    {if ($quotation->id_cart>0)  && ($quotation->id_order==0)}
    <div class="panel-heading-action">
        <a class="btn btn-default btn-lg" id="resetCart" href="#">
            <i class="icon-edit"></i>
            {l s='Reset Cart' mod='roja45quotationspro'}
        </a>
    </div>
    {/if}
</div>
<div class="form-horizontal">
    <form id="roja45quotation_form" class="defaultForm form-horizontal"
          action="{$link->getAdminLink('AdminQuotationsPro')|escape:'html':'UTF-8'}" method="post" enctype="multipart/form-data"
          novalidate="">
        {capture name="TaxMethod"}{l s='tax excl.' mod='roja45quotationspro'}{/capture}
        {if (!$quotation->calculate_taxes)}
            <input type="hidden" name="TaxMethod" value="0">
        {else}
            <input type="hidden" name="TaxMethod" value="1">
        {/if}
        <div class="row">
            <div class="col-xs-12">
                <div class="panel panel-charges clearfix">
                    <div class="panel-heading">
                        {l s='Products' mod='roja45quotationspro'}
                        <span class="badge">{$requested_products|@count|escape:'html':'UTF-8'}</span>
                        <span class="panel-heading-action">
                            {if !$quotation->is_template}
                            <a id="add_quotation_product" class="add-product list-toolbar-btn" href="#" {if ($quotation->isLocked()) || $deleted}style="display:none;"{/if}>
                                <span title="" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Add a Product' mod='roja45quotationspro'}" data-html="true" data-placement="top">
                                    <i class="process-icon-new"></i>
                                </span>
                            </a>
                            {/if}
                        </span>
                    </div>
                    <div class="table-responsive" style="position: relative;">
                        {if !($quotation->isLocked())}
                            {include file='./_new_product.tpl'}
                        {/if}
                        {include file='./_product_line.tpl'}
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-6">
                <div class="panel panel-charges clearfix">
                    <div class="panel-heading">
                        {l s='Charges' mod='roja45quotationspro'}
                        <span class="badge">{$charges|@count|escape:'html':'UTF-8'}</span>
                        <span class="panel-heading-action">
                            {if !$quotation->is_template}
                            <a id="add_quotation_charge" class="add-charge list-toolbar-btn" href="#" {if ($quotation->isLocked()) || $deleted}style="display:none;"{/if}>
                                <span title="" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Add a Charge' mod='roja45quotationspro'}" data-html="true" data-placement="top">
                                    <i class="process-icon-new"></i>
                                </span>
                            </a>
                            {/if}
                        </span>
                    </div>

                    {if (sizeof($charges) || !($quotation->isLocked()))}
                        <div class="current-edit" id="charges_form" style="display:none;">
                            {include file='./_charge_form.tpl'}
                        </div>
                        <div id="charges_table">
                            {include file='./_charge_table.tpl'}
                        </div>
                    {/if}
                </div>
            </div>
            <div class="col-xs-6">
                <div class="panel panel-vouchers clearfix">
                    <div class="panel-heading">
                        {l s='Discounts' mod='roja45quotationspro'}
                        <span class="badge">{$discounts|@count|escape:'html':'UTF-8'}</span>
                        <span class="panel-heading-action">
                            {if !$quotation->is_template}
                            <a id="desc-discount-new" class="add_discount list-toolbar-btn" href="#" {if ($quotation->isLocked()) || $deleted}style="display:none;"{/if}>
                                <span title="" data-toggle="tooltip" class="label-tooltip" data-original-title="{l s='Add a discount' mod='roja45quotationspro'}" data-html="true" data-placement="top">
                                <i class="process-icon-new"></i>
                                </span>
                            </a>
                            {/if}
                        </span>
                    </div>
                    {if (sizeof($discounts) || !($quotation->isLocked()))}
                        <div class="current-edit" id="voucher_form" style="display:none;">
                            {include file='./_discount_form.tpl'}
                        </div>
                        <div id="discount_table">
                            {include file='./_discount_table.tpl'}
                        </div>
                    {/if}
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-6">
            </div>
            <div class="col-xs-6">
                <div id="totals_panel" class="panel panel-total">
                    {include file='./_quotation_totals.tpl'}
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-xs-12">
                <div class="row pull-right">
                    <div class="btn-group">
                        {if !$quotation->is_template}
                        <button type="button" class="btn btn-default btn-lg saveAsTemplate">
                            <i class="icon-envelope"></i>
                            {l s='Save As Template' mod='roja45quotationspro'}
                        </button>
                        {else}
                        <button type="button" class="btn btn-default btn-lg pull-right createQuote">
                            <i class="icon-envelope"></i>
                            {l s='Create Quote' mod='roja45quotationspro'}
                        </button>
                        {/if}
                    </div>
                    {if !$quotation->is_template}
                    <div class="btn-group">
                        <a href="{$quotationspro_link|escape:'html':'UTF-8'}&action=downloadPDFQuotation&id_roja45_quotation={$quotation->id|escape:'html':'UTF-8'}"
                           target="_blank"
                           class="btn btn-default btn-lg downloadPDFQuotation">
                            <i class="icon-file"></i>
                            {l s='Download PDF' mod='roja45quotationspro'}
                        </a>
                    </div>
                    <div class="btn-group">
                        <button type="button" class="btn btn-default btn-lg sendCustomerQuotation">
                            <i class="icon-envelope"></i>
                            {l s='Send Quote' mod='roja45quotationspro'}
                        </button>
                    </div>
                    {/if}
                </div>
            </div>
        </div>
        {if ($show_exchange_rate == 1)}
        <div class="row" style="margin-top: 10px;">
            <div class="col-xs-12">
                <div class="panel panel-total">
                    <p class="alert alert-warning">
                        {l s='Your quote has been provided in your requested currency.  Please be aware that currency fluctuations may result in the price you have been quoted changing.  We reserve the right to change or cancel this quote at any time.' mod='roja45quotationspro'}
                    </p>
                </div>
            </div>
        </div>
        {/if}
    </form>
</div>
<div class="panel-footer">
</div>
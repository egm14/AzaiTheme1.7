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
*  @license          /license.txtr
*}

<div id="container-quotations">
    <div class="leadin"></div>
    <div class="row">
        <div class="col-lg-7">
            <div class="panel clearfix">
                {if isset($customer)}
                <div class="panel-heading">
                    <i class="icon-male"></i>
                    {l s='Customer Information' mod='roja45quotationspro'}
                    <a class="btn btn-default pull-right" href="{$customer->email}"><i class="icon-envelope"></i>{$customer->email}</a>
                </div>
                <h2>
                    <i class="icon-male"></i>
                    <a href="{$customer_controller}&id_customer={$customer->id}&viewcustomer">{$customer->firstname}&nbsp;{$customer->lastname}</a>
                </h2>
                <div class="form-horizontal">
                    <div class="form-group">
                        <label class="col-lg-3 control-label">{l s='Account registration date' mod='roja45quotationspro'}</label>
                        <div class="col-lg-3"><p class="form-control-static">{$registration_date}</p></div>
                    </div>
                    <div class="form-group">
                        <label class="col-lg-3 control-label">{l s='Quote Requests Received' mod='roja45quotationspro'}</label>
                        <div class="col-lg-3"><p class="form-control-static">{$number_of_requests}</p></div>
                    </div>
                    <div class="form-group">
                        <label class="col-lg-3 control-label">{l s='Quotes Converted To Orders' mod='roja45quotationspro'}</label>
                        <div class="col-lg-3"><p class="form-control-static">{$number_of_orders}</p></div>
                    </div>
                </div>
                    {else}
                    <div class="panel-heading">
                        <i class="icon-male"></i>
                        {l s='Guest' mod='roja45quotationspro'}
                    </div>
                {/if}
            </div>
        </div>
        <div class="col-lg-5">
            <div class="panel clearfix">
                <div class="panel-heading">
                    <i class="icon-cart"></i>
                    {l s='Quote Information' mod='roja45quotationspro'}
                </div>
                {if isset($quotation)}
                    <h2>
                        <a target="_blank" href="{$quotation_controller}&id_roja45_quotation={$quotation->id}&updateroja45_quotationspro">{l s='Quotation #' mod='roja45quotationspro'}{$quotation->id}</a>
                    </h2>
                {/if}
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <div class="panel clearfix">
                <div class="panel-heading">
                    <i class="icon-cart"></i>
                    {l s='Quote Summary' mod='roja45quotationspro'}
                </div>

                <div class="row">
                    <table class="table" id="quotationProducts">
                        <thead>
                        <tr>
                            <th class="fixed-width-xs">&nbsp;</th>
                            <th><span class="title_box">{l s='Product' mod='roja45quotationspro'}</span></th>
                            <th class="text-right fixed-width-md"><span class="title_box">{l s='Unit price (inc.)' mod='roja45quotationspro'}</span></th>
                            <th class="text-center fixed-width-md"><span class="title_box">{l s='Quantity' mod='roja45quotationspro'}</span></th>
                            <th class="text-center fixed-width-sm"><span class="title_box">{l s='Stock' mod='roja45quotationspro'}</span></th>
                        </tr>
                        </thead>
                        <tbody>
                        {foreach $quotation_products as $product}
                        <tr>
                            <td><img src="{$product.image_quote_cart}" alt="{$product.image_title}" class="imgm img-thumbnail"></td>
                            <td>
                                <a href=""><span class="productName">{$product.name}</span></a>
                            </td>
                            <td class="text-right">{$product.price}</td>
                            <td class="text-center">{$product.quote_quantity}</td>
                            <td class="text-center">{$product.quantity_available}</td>
                        </tr>
                        {/foreach}
                        </tbody>
                    </table>
                </div>

            </div>
        </div>
    </div>
</div>
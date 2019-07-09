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

{extends file='customer/page.tpl'}

{block name="page_title"}
    <h4>{l s='Open Quotes' mod='roja45quotationspro'}</h4>
{/block}

{block name='page_content'}
    {if !$num_address}
        <div id="customerquotes_block_address_warning" class="">
            <p class="alert alert-warning">{l s='You will need to add an address before you can add a quote to your cart.' mod='roja45quotationspro'}<a href="{url entity='address'}">{l s='Click here.' mod='roja45quotationspro'}</a></p>
        </div>
    {/if}


    {if isset($customerquotes) && ($customerquotes|@count gt 0)}
    <table class="table tableDnD table-responsive" id="downloadableItemsTable">
        <thead>
        <tr class="nodrag nodrop">
            <th class="fixed-width-lg">
                <span class="title_box">{l s='Reference' mod='roja45quotationspro'}</span>
            </th>
            <th class="fixed-width-lg">
                <span class="title_box">{l s='Requested' mod='roja45quotationspro'}</span>
            </th>
            <th class="fixed-width-lg">
                <span class="title_box">{l s='Last Update' mod='roja45quotationspro'}</span>
            </th>
            <th class="fixed-width-lg">
                <span class="title_box">{l s='Expires' mod='roja45quotationspro'}</span>
            </th>
            <th class="fixed-width-lg"><span class="title_box">{l s='Total (exc)' mod='roja45quotationspro'}</span></th>
            <th class="fixed-width-lg"><span class="title_box">{l s='Total (inc)' mod='roja45quotationspro'}</span></th>
            <th class="fixed-width-xs"></th>
            <th class="fixed-width-xs"></th>
        </tr>
        </thead>
        <tbody id="fileList">
             
        {foreach $customerquotes as $customerquote}
            <pre>{*$customerquote|print_r*}</pre>
            <tr class="nodrag nodrop" data-id="{$customerquote->id_roja45_quotation}">
                <td class="fixed-width-lg reference">{$customerquote->reference}</td>
                <td class="fixed-width-lg added-date">{dateFormat date=$customerquote->date_add full=false}</td>
                <td class="fixed-width-lg updated-date">{dateFormat date=$customerquote->date_upd full=true}</td>
                <td class="fixed-width-lg expiration-date">{if ($customerquote->expiry_date != '0000-00-00 00:00:00')}{dateFormat date=$customerquote->expiry_date full=true}{/if}</td>
                <td class="fixed-width-sm total">
                    {if $customerquote->quote_sent == 1}
                       {$customerquote->total_exc_formatted}   
                    {else}
                         {$currency.sign}{($customerquote->total_exc*$packageAzai)|number_format:2:".":","}
                    {/if}
                </td>
                <td class="fixed-width-sm total">
                    {if $customerquote->calculate_taxes}
                        {if $customerquote->quote_sent == 1}
                           {$customerquote->total_inc_formatted}  
                        {else}
                             {$currency.sign}{($customerquote->total_inc*$packageAzai)|number_format:2:".":","}
                        {/if}
                        
                    {else}
                        {l s='N/A' mod='roja45quotationspro'}
                     {/if}
                </td>

                <td class="fixed-width-lg">
                    {if $customerquote->quote_sent == 1}
                    <a href=" 
                                  {url entity='module'
                                  name='roja45quotationspro'
                                  controller='QuotationsProFront'
                                  params = [
                                        'action' => 'getQuotationDetails',
                                        'id_roja45_quotation' => $customerquote->id_roja45_quotation,
                                        'back' => 'getCustomerQuotes']}"
                       class="btn btn-default btn-primary viewQuote"
                       title="{l s='View Quote Details' mod='roja45quotationspro'}">
                        <i class="material-icons">
                            assignment
                        </i>
                    </a>
                    {else}
                    <div title="{l s='Download PDF' mod='roja45quotationspro'}"
                        target="_blank"
                       class="btn btn-default btn-primary downloadPDF" style="background:#e7e7e7!important;box-shadow:none!important">
                        <i class="material-icons">description</i></div>
                    {/if}
                    {if $customerquote->quote_sent == 1}
                    <a href="{url entity='module'
                                name='roja45quotationspro'
                                controller='QuotationsProFront'
                                params = [
                                'action' => 'downloadPDF',
                                'id_roja45_quotation' => $customerquote->id_roja45_quotation
                                ]}"
                        title="{l s='Download PDF' mod='roja45quotationspro'}"
                        target="_blank"
                       class="btn btn-default btn-primary downloadPDF">
                        <i class="material-icons">description</i>
                    </a>

                    {else}
                        <div title="{l s='Download PDF' mod='roja45quotationspro'}"
                        target="_blank"
                       class="btn btn-default btn-primary downloadPDF" style="background:#e7e7e7!important;box-shadow:none!important">
                        <i class="material-icons">description</i></div>
                    {/if}
                </td>
                <td class="fixed-width-lg">
                {if $customerquote->expired=="1"}
                    <div class="quote-expired">
                        <span>{l s='EXPIRED' mod='roja45quotationspro'}</span>
                    </div>
                {elseif $customerquote->ordered=="1"}
                    <div class="quote-ordered">
                        <span>{l s='ORDERED' mod='roja45quotationspro'}</span>
                    </div>
                {elseif $customerquote->quote_sent=="1"}
                    {if $catalog_mode}
                        {if $num_address}
                        <a title="{l s='Click here to request as order.  You request will be sent to our operators.' mod='roja45quotationspro'}" href="{url entity='module' name='roja45quotationspro' controller='QuotationsProFront' params = ['action' => 'submitRequestOrder', 'id_roja45_quotation' => $customerquote->id_roja45_quotation]}" class="btn btn-default btn-primary addToOrder">
                            <i class="material-icons">shopping_cart</i>
                        </a>
                        {/if}
                    {else}
                        {if $num_address}
                        <a title="{l s='Click to add this quote to your cart.' mod='roja45quotationspro'}" href="{url entity='module' name='roja45quotationspro' controller='QuotationsProFront' params = ['action' => 'submitAddToCart', 'id_roja45_quotation' => $customerquote->id_roja45_quotation]}" class="btn btn-default btn-primary addToCart">
                            <i class="material-icons">shopping_cart</i>
                        </a>
                        {/if}
                    {/if}
                {else}
                        <a title="{l s='Please wait, quotation in progress' mod='roja45quotationspro'}" href="#" class="btn btn-default btn-secondary">
                            <i class="material-icons">av_timer</i>
                        </a>
                {/if}
                </td>
            </tr>
        {/foreach}
        </tbody>
    </table>
    {else}
        <p class="warning">{l s='You have no available quotes.' mod='roja45quotationspro'}</p>
    {/if}
{/block}
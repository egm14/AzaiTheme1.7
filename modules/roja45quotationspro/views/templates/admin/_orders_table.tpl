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

<div class="table-responsive">
    <table class="table">
        <thead>
        <tr>
            <th><span class="title_box ">{l s='Order Reference' mod='roja45quotationspro'}</span></th>
            <th><span class="title_box ">{l s='Added' mod='roja45quotationspro'}</span></th>
            <th></th>
        </tr>
        </thead>
        <tbody>
        {foreach from=$quotation_orders item=quotation_order}
            <tr class="quotation_order_row">
                <td style="width: 75%">
                    <a href="{$quotation_order['order_url']|escape:'html':'UTF-8'}" target="_blank">
                        {$quotation_order['reference']|truncate:100|escape:'html':'UTF-8'}
                    </a>
                </td>
                <td>{$quotation_order['date_add']|escape:'html':'UTF-8'}</td>
                <td>
                    <a href="{$quotation_order['order_url']|escape:'html':'UTF-8'}" target="_blank">
                        {l s='View' mod='roja45quotationspro'}
                    </a>
                </td>
            </tr>
        {/foreach}
        </tbody>
    </table>
</div>
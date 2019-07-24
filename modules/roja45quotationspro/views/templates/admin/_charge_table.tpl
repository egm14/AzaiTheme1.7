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

<div class="table-responsive" style="overflow: auto;">
    <table class="table">
        <thead>
        <tr>
            <th><span class="title_box ">{l s='Charge' mod='roja45quotationspro'}</span></th>
            <th><span class="title_box ">{l s='Type' mod='roja45quotationspro'}</span></th>
            <th><span class="title_box ">{l s='Value (exc)' mod='roja45quotationspro'}</span></th>
            {if $quotation->calculate_taxes}
            <th><span class="title_box ">{l s='Value (inc.)' mod='roja45quotationspro'}</span></th>
            {/if}
            {if !($quotation->isLocked())}
                <th></th>
            {/if}
        </tr>
        </thead>
        <tbody>
        {foreach from=$charges item=charge}
            <tr class="charge_row" data-id-quotation-charge="{$charge['id_roja45_quotation_charge']|escape:"html":"UTF-8"}">
                <td>{$charge['charge_name']|escape:"html":"UTF-8"}</td>
                <td>{if $charge['charge_type']=='SHIPPING'}{l s='Shipping' mod='roja45quotationspro'}{elseif $charge['charge_type']=='HANDLING'}{l s='Handling' mod='roja45quotationspro'}{/if}</td>
                <td>
                    <span>{displayPrice price=Tools::ps_round(Tools::convertPrice($charge['charge_amount'], $currency), 2) currency=$currency->id}</span>
                </td>
                {if $quotation->calculate_taxes}
                <td>
                    <span>{displayPrice price=Tools::ps_round(Tools::convertPrice($charge['charge_amount_wt'], $currency), 2) currency=$currency->id}</span>
                </td>
                {/if}
                {if !($quotation->isLocked())}
                    <td>
                        {if !isset($email)}
                        <a href="#" class="submit-delete-charge pull-right"
                           data-id-roja45-quotation="{$charge['id_roja45_quotation']|escape:"html":"UTF-8"}"
                           data-id-roja45-quotation-charge="{$charge['id_roja45_quotation_charge']|escape:"html":"UTF-8"}">
                            <i class="icon-minus-sign"></i>
                            {l s='Delete' mod='roja45quotationspro'}
                        </a>
                        {/if}
                        {/if}
                    </td>
            </tr>
        {/foreach}
        </tbody>
    </table>
</div>
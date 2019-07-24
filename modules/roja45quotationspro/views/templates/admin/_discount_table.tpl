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
            <th><span class="title_box ">{l s='Discount name' mod='roja45quotationspro'}</span></th>
            <th><span class="title_box ">{l s='Value' mod='roja45quotationspro'}</span></th>
            {if !($quotation->isLocked())}
                <th></th>
            {/if}
        </tr>
        </thead>
        <tbody>
        {foreach from=$discounts item=discount}
            <tr class="discount_row">
                <td>{$discount['charge_name']|escape:"html":"UTF-8"}</td>
                <td>
                    {if ($discount['charge_method']=='PERCENTAGE')}
                        {$discount['charge_value']|escape:"html":"UTF-8"|string_format:"%.2f"}%
                    {elseif ($discount['charge_method']=='VALUE')}
                        {displayPrice price=Tools::ps_round(Tools::convertPrice($discount['charge_value'], $currency), 2) currency=$currency->id}
                    {/if}
                </td>
                {if !($quotation->isLocked())}
                    <td>
                        <a href="#" class="submitDeleteVoucher pull-right"
                           data-id-roja45-quotation="{$discount['id_roja45_quotation']|escape:"html":"UTF-8"}"
                           data-id-roja45-quotation-charge="{$discount['id_roja45_quotation_charge']|escape:"html":"UTF-8"}">
                            <i class="icon-minus-sign"></i>
                            {l s='Delete' mod='roja45quotationspro'}
                        </a>
                    </td>
                {/if}
            </tr>
        {/foreach}
        </tbody>
    </table>
</div>
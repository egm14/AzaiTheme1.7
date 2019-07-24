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

{if ($quotation->calculate_taxes)}
    {assign var=show_with_tax value=1}
{else}
    {assign var=show_with_tax value=0}
{/if}

<div class="table-responsive">
    <table class="table">
        {assign var=quotation_discount_price value=0.00}
        {assign var=quotation_charges_price value=0.00}
        {assign var=quotation_wrapping_price value=0.00}
        {assign var=quotation_shipping_price value=0.00}
        {if ($show_exchange_rate == 1)}
            <tr id="exchange_rate">
                <td class="text-right">{l s='Exchange Rate' mod='roja45quotationspro'}
                    &nbsp;({$default_currency_symbol|escape:'html':'UTF-8'})
                </td>
                <td class="amount text-right nowrap">
                    {$exchange_rate|escape:'html':'UTF-8'}
                </td>
            </tr>
            <tr>
                <td>
                    &nbsp;
                </td>
                <td>
                    &nbsp;
                </td>
            </tr>
        {/if}
        {if ($show_with_tax)}
            <tr id="tax_rate">
                <td class="text-right">{l s='Tax Rate (%)' mod='roja45quotationspro'}</td>
                <td class="amount text-right nowrap">
                    {$tax_average_rate|escape:'html':'UTF-8'}
                </td>
            </tr>

            <tr id="total_products">
                <td class="text-right">{l s='Total Products (exc. tax)' mod='roja45quotationspro'}</td>
                <td class="amount text-right nowrap" >
                    {displayPrice price=Tools::ps_round(Tools::convertPrice($total_products, $currency), 2) currency=$currency->id}
                </td>
            </tr>
            <tr id="total_taxes">
                <td class="text-right">{l s='Taxes' mod='roja45quotationspro'}</td>
                <td class="amount text-right nowrap">{displayPrice price=Tools::ps_round(Tools::convertPrice($total_tax, $currency), 2) currency=$currency->id}</td>
                <td class="partial_refund_fields current-edit" style="display:none;"></td>
            </tr>
            <tr id="total_products">
                <td class="text-right"
                    style="font-weight: bold;border-bottom:1px solid #666;background-color:#f4f8fb;">{l s='Total Products (inc. tax)' mod='roja45quotationspro'}</td>
                <td class="amount text-right nowrap"
                    style="font-weight: bold;border-bottom:1px solid #666;background-color:#f4f8fb;">
                    {displayPrice price=Tools::ps_round(Tools::convertPrice($total_products_wt, $currency), 2) currency=$currency->id}
                </td>
            </tr>
            {if $deposit_enabled}
            <tr id="total_deposit_to_pay">
                <td class="text-right"
                    style="font-weight: bold;border-bottom:1px solid #666;background-color:#f4f8fb;">{l s='Total Deposit (inc. tax)' mod='roja45quotationspro'}</td>
                <td class="amount text-right nowrap"
                    style="font-weight: bold;border-bottom:1px solid #666;background-color:#f4f8fb;">
                    {displayPrice price=Tools::ps_round(Tools::convertPrice($total_deposit_wt, $currency), 2) currency=$currency->id}
                </td>
            </tr>
            {/if}
            <tr id="total_discounts">
                <td class="text-right">{l s='Discounts' mod='roja45quotationspro'}</td>
                <td class="amount text-right nowrap">
                    {displayPrice price=Tools::ps_round(Tools::convertPrice($total_discounts, $currency), 2) currency=$currency->id}
                </td>
            </tr>
            <tr id="total_products_with_discount">
                <td class="text-right"
                    style="font-weight: bold;border-bottom:1px solid #666;background-color:#f4f8fb;">{l s='Sub-Total' mod='roja45quotationspro'}</td>
                <td class="amount text-right nowrap"
                    style="font-weight: bold;border-bottom:1px solid #666;background-color:#f4f8fb;">
                    {displayPrice price=Tools::ps_round(Tools::convertPrice($total_products_after_discount_wt, $currency), 2) currency=$currency->id}
                </td>
            </tr>
            <tr id="total_charges">
                <td class="text-right">{l s='Charges (inc. tax)' mod='roja45quotationspro'}</td>
                <td class="amount text-right nowrap">
                    {displayPrice price=Tools::ps_round(Tools::convertPrice($total_charges_wt, $currency), 2) currency=$currency->id}
                </td>
            </tr>
            <tr id="total_shipping">
                <td class="text-right">{l s='Shipping (inc. tax)' mod='roja45quotationspro'}</td>
                <td class="amount text-right nowrap">
                    {displayPrice price=Tools::ps_round(Tools::convertPrice($total_shipping_wt, $currency), 2) currency=$currency->id}
                </td>
            </tr>
            <tr id="total_handling">
                <td class="text-right" style="border-bottom:1px solid #666;background-color:#fff;">{l s='Handling (inc. tax)' mod='roja45quotationspro'}</td>
                <td class="amount text-right nowrap" style="border-bottom:1px solid #666;background-color:#fff;">
                    {displayPrice price=Tools::ps_round(Tools::convertPrice($total_handling_wt, $currency), 2) currency=$currency->id}
                </td>
            </tr>
        {else}
            <tr id="total_products">
                <td class="text-right" style="font-weight: bold;border-bottom:1px solid #666;background-color:#f4f8fb;">{l s='Sub-Total Products' mod='roja45quotationspro'}</td>
                <td class="amount text-right nowrap" style="font-weight: bold;border-bottom:1px solid #666;background-color:#f4f8fb;">
                    {displayPrice price=Tools::ps_round(Tools::convertPrice($total_products, $currency), 2) currency=$currency->id}
                </td>
            </tr>
            <tr id="total_discounts">
                <td class="text-right">{l s='Discounts' mod='roja45quotationspro'}</td>
                <td class="amount text-right nowrap">
                    {displayPrice price=Tools::ps_round(Tools::convertPrice($total_discounts, $currency), 2) currency=$currency->id}
                </td>
            </tr>
            <tr id="total_products_with_discount">
                <td class="text-right"
                    style="font-weight: bold;border-bottom:1px solid #666;background-color:#f4f8fb;">{l s='Total Products' mod='roja45quotationspro'}</td>
                <td class="amount text-right nowrap"
                    style="font-weight: bold;border-bottom:1px solid #666;background-color:#f4f8fb;">
                    {displayPrice price=Tools::ps_round(Tools::convertPrice($total_products_after_discount, $currency), 2) currency=$currency->id}
                </td>
            </tr>
            {if $deposit_enabled}
            <tr id="total_deposit_to_pay">
                <td class="text-right"
                    style="font-weight: bold;border-bottom:1px solid #666;background-color:#f4f8fb;">{l s='Total Deposit (exc. tax)' mod='roja45quotationspro'}</td>
                <td class="amount text-right nowrap"
                    style="font-weight: bold;border-bottom:1px solid #666;background-color:#f4f8fb;">
                    {displayPrice price=Tools::ps_round(Tools::convertPrice($total_deposit, $currency), 2) currency=$currency->id}
                </td>
            </tr>
            {/if}
            <tr id="total_charges">
                <td class="text-right">{l s='Charges (exc. tax)' mod='roja45quotationspro'}</td>
                <td class="amount text-right nowrap">
                    {displayPrice price=Tools::ps_round(Tools::convertPrice($total_charges, $currency), 2) currency=$currency->id}
                </td>
            </tr>
            <tr id="total_shipping">
                <td class="text-right">{l s='Shipping (exc. tax)' mod='roja45quotationspro'}</td>
                <td class="amount text-right nowrap">
                    {displayPrice price=Tools::ps_round(Tools::convertPrice($total_shipping, $currency), 2) currency=$currency->id}
                </td>
            </tr>
            <tr id="total_handling">
                <td class="text-right" style="border-bottom:1px solid #666;background-color:#fff;">{l s='Handling (exc. tax)' mod='roja45quotationspro'}</td>
                <td class="amount text-right nowrap" style="border-bottom:1px solid #666;background-color:#fff;">
                    {displayPrice price=Tools::ps_round(Tools::convertPrice($total_handling, $currency), 2) currency=$currency->id}
                </td>
            </tr>
        {/if}

        <tr id="total_quotation">
            <td class="text-right"
                style="background-color:#f4f8fb;">
                <strong>{l s='Total' mod='roja45quotationspro'}</strong>
            </td>
            <td class="amount text-right nowrap"
                style="background-color:#f4f8fb;">
                {if ($show_with_tax)}
                    <strong>{displayPrice price=Tools::ps_round(Tools::convertPrice($total_price, $currency), 2) currency=$currency->id}</strong>
                {else}
                    <strong>{displayPrice price=Tools::ps_round(Tools::convertPrice($total_price_without_tax, $currency), 2) currency=$currency->id}</strong>
                {/if}
            </td>
        </tr>
    </table>
</div>
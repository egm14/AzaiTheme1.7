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

<table class="table" bgcolor="#ffffff" style="width:100%" cellSpacing=0 cellPadding=0 border=1>
    <tr>
        <th colspan=1 bgcolor="#f8f8f8" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;padding: 10px;"></th>
        <th colspan=3 bgcolor="#f8f8f8" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;padding: 10px;">{l s='Product' mod='roja45quotationspro'}</th>
        <th colspan=2 bgcolor="#f8f8f8" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;padding: 10px;">{l s='Reference' mod='roja45quotationspro'}</th>
        <th colspan=2 bgcolor="#f8f8f8" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;padding: 10px;">{l s='Comment' mod='roja45quotationspro'}</th>
        <th colspan=2 bgcolor="#f8f8f8" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;padding: 10px;">{l s='Unit price' mod='roja45quotationspro'}</th>
        <th colspan=2 bgcolor="#f8f8f8" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;padding: 10px;">{l s='Package Quantity' mod='roja45quotationspro'}</th>
        <th colspan=2 bgcolor="#f8f8f8" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;padding: 10px;">{l s='Total price' mod='roja45quotationspro'}</th>
    </tr>
    {foreach from=$requested_products item=product key=k}
        {include file='./quote_template_product_line.tpl'}
    {/foreach}
</table>
<table class="table" bgcolor="#ffffff" style="width:100%;border:0px;background-color: #ffffff;" cellSpacing=0 cellPadding=0 border=0>
    {if (sizeof($charges))}
    <tr>
        <td colspan=4 vAlign=top>
        </td>
        <th colspan=2 class="text-right" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Charge' mod='roja45quotationspro'}</span>
        </th>
        <th colspan=2 class="text-right" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;padding: 10px;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Type' mod='roja45quotationspro'}</span>
        </th>
        <th colspan=2 class="text-right" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;padding: 10px;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Value' mod='roja45quotationspro'}</span>
        </th>
        <th colspan=2 class="text-right" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;padding: 10px;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Value (inc. tax)' mod='roja45quotationspro'}</span>
        </th>
    </tr>
    {foreach from=$charges item=charge}
    <tr class="charge_row" data-id-quotation-charge="{$charge['id_roja45_quotation_charge']|escape:"html":"UTF-8"}">
        <td colspan=4 vAlign=top  style="border:0px;background-color: #ffffff;">
        </td>
        <td colspan=2 class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$charge['charge_name']|escape:"html":"UTF-8"}</span>
        </td>
        {if $charge['charge_type']=='SHIPPING'}
            <td colspan=2 class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
                <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{if $charge['charge_type']=='SHIPPING'}{l s='Shipping' mod='roja45quotationspro'}{/if}</span>
            </td>
        {/if}
        {if $charge['charge_type']=='HANDLING'}
            <td colspan=2 class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
                <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Handling' mod='roja45quotationspro'}</span>
            </td>
        {/if}
        <td colspan=2 class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$charge['charge_amount_formatted']|escape:'htmlall':'UTF-8'}</span>
        </td>
        <td colspan=2 class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$charge['charge_amount_wt_formatted']|escape:'htmlall':'UTF-8'}</span>
        </td>
    </tr>
    {/foreach}
    {/if}
    <tr>
        <td colspan=12 vAlign=top width="100%" style="border:0px;background-color: #ffffff;">&nbsp;</td>
    </tr>
    {if (sizeof($discounts))}
    <tr>
        <td colspan=6 vAlign=top style="border:0px solid #D6D4D4;background-color: #ffffff;">
        </td>
        <th colspan=3 class="text-left" style="border:0px solid #D6D4D4;border-top: 1px solid #d6d4d4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;text-align: left;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Discount Name' mod='roja45quotationspro'}</span>
        </th>
        <th colspan=3 class="text-left" style="border:0px solid #D6D4D4;border-top: 1px solid #d6d4d4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;text-align: left;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Amount' mod='roja45quotationspro'}</span>
        </th>
    </tr>
    {foreach from=$discounts item=discount}
    <tr class="discount_row">
        <td colspan=6 vAlign=top width="50%" style="border:0px solid #D6D4D4;background-color: #ffffff;">
        </td>
        <td colspan=3 width="25%" class="amount text-left nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;text-align: left;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$discount['charge_name']|escape:"html":"UTF-8"}</span>
        </td>
        <td colspan=3 width="25%" class="amount text-left nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;text-align: left;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{if ($discount['charge_method']  =='PERCENTAGE')}
                {$discount['charge_value']|escape:"html":"UTF-8"|string_format:"%.2f"}%
            {elseif ($discount['charge_method']  =='AMOUNT')}
                {$discount['charge_value_formatted']|escape:'htmlall':'UTF-8'}
            {/if}</span>
        </td>
    </tr>
    {/foreach}

    {/if}
    <tr>
        <td colspan=6 vAlign=top style="border:0px;background-color: #ffffff;">&nbsp;</td>
        <td colspan=3 vAlign=top style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;">&nbsp;</td>
        <td colspan=3 vAlign=top style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;">&nbsp;</td>
    </tr>
    {if ($show_exchange_rate == 1)}
    <tr id="exchange_rate">
        <td colspan=6 vAlign=top style="border:0px solid #D6D4D4;background-color: #ffffff;"></td>
        <th colspan=3 class="text-right" style="border:0px solid #D6D4D4;border-top: 1px solid #d6d4d4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;text-align: left;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Exchange Rate' mod='roja45quotationspro'} ({$default_currency_symbol|escape:'html':'UTF-8'})</span>
        </th>
        <td colspan=3 class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$exchange_rate|escape:'html':'UTF-8'}</span>
        </td>
    </tr>
    {/if}

    {assign var=total_products value=$total_products_wt}

    {assign var=total_charges value=$total_charges_wt}
    {assign var=total_charges_formatted value=$total_charges_wt_formatted}
    {assign var=total_shipping value=$total_shipping_wt}
    {assign var=total_shipping_formatted value=$total_shipping_wt_formatted}
    {assign var=total_handling value=$total_handling_wt}
    {assign var=total_handling_formatted value=$total_handling_wt_formatted}
    {assign var=total_price value=$total_price}
    {assign var=total_products value=$total_products}

    {assign var=total_charges value=$total_charges}
    {assign var=total_charges_formatted value=$total_charges_formatted}
    {assign var=total_shipping value=$total_shipping}
    {assign var=total_shipping_formatted value=$total_shipping_formatted}
    {assign var=total_handling value=$total_handling}
    {assign var=total_handling_formatted value=$total_handling_formatted}
    {assign var=total_price value=$total_price_without_tax}

    <tr id="total_before_discount" {if $total_products == 0}style="display: none;"{/if}>
        <th colspan=6 vAlign=top style="border:0px solid #D6D4D4;background-color: #ffffff;width:50%;"></th>
        <th colspan=3 class="text-right" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;text-align: left;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Sub-Total Products (exc)' mod='roja45quotationspro'}</span>
        </th>
        <td colspan=3 class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;text-align: center;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$total_products_formatted|escape:'htmlall':'UTF-8'}</span>
        </td>
    </tr>
    {if $total_discounts > 0}
    <tr id="total_discounts">
        <td colspan=6 vAlign=top style="border:0px solid #D6D4D4;background-color: #ffffff;"></td>
        <th colspan=3 class="text-right" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;text-align: left;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Discounts' mod='roja45quotationspro'}</span>
        </th>
        <td colspan=3 class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;text-align: center;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$total_discounts_formatted|escape:'htmlall':'UTF-8'}</span>
        </td>
    </tr>
    {/if}
    {if $total_charges > 0}
    <tr id="total_charges">
        <td colspan=6 vAlign=top style="border:0px solid #D6D4D4;background-color: #ffffff;"></td>
        <th colspan=3 class="text-right" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;text-align: left;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Charges (inc. tax)' mod='roja45quotationspro'}</span>
        </th>
        <td colspan=3 class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;text-align: center;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$total_charges_formatted|escape:'htmlall':'UTF-8'}</span>
        </td>
    </tr>
    {/if}
    <tr id="total_shipping">
        <td colspan=6 vAlign=top style="border:0px solid #D6D4D4;background-color: #ffffff;"></td>
        <th colspan=3 class="text-right" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;text-align: left;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Shipping (inc. tax)' mod='roja45quotationspro'}</span>
        </th>
        <td colspan=3 class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;text-align: center;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$total_shipping_formatted|escape:'htmlall':'UTF-8'}</span>
        </td>
    </tr>
    {if $total_handling > 0}
    <tr id="total_handling">
        <td colspan=6 vAlign=top style="border:0px solid #D6D4D4;background-color: #ffffff;"></td>
        <th colspan=3 class="text-right" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;text-align: left;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Handling (inc. tax)' mod='roja45quotationspro'}</span>
        </th>
        <td colspan=3 class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;text-align: center;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$total_handling_formatted|escape:'htmlall':'UTF-8'}</span>
        </td>
    </tr>
    {/if}
    <tr id="total_products">
        <td colspan=6 vAlign=top style="border:0px solid #D6D4D4;background-color: #ffffff;"></td>
        <th colspan=3 class="text-right" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;text-align: left;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Total Products' mod='roja45quotationspro'}</span></th>
        <td colspan=3 class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;text-align: center;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$total_products_after_discount_formatted|escape:'htmlall':'UTF-8'}</span>
        </td>
    </tr>

    {if ($show_with_tax)}
        <tr id="tax_rate">
            <td colspan=6 vAlign=top style="border:0px solid #D6D4D4;background-color: #ffffff;">
            </td>
            <th colspan=3 class="text-right" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;text-align: left;">
                <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Tax Rate' mod='roja45quotationspro'}</span>
            </th>
            <td colspan=3 class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;text-align: center;">
                <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$tax_average_rate|escape:'html':'UTF-8'} (%)</span>
            </td>
        </tr>
        <tr id="total_taxes">
            <td colspan=6 vAlign=top style="border:0px solid #D6D4D4;background-color: #ffffff;"></td>
            <th colspan=3 class="text-right" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;text-align: left;">
                <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Taxes' mod='roja45quotationspro'}</span>
            </th>
            <td colspan=3 class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;text-align: center;">
                <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$total_tax_formatted|escape:'htmlall':'UTF-8'}</span>
            </td>
        </tr>
        <tr id="total_quotation">
            <td colspan=6 vAlign=top style="border:0px solid #D6D4D4;background-color: #ffffff;"></td>
            <th colspan=3 class="text-right" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;text-align: left;">
                <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Total' mod='roja45quotationspro'}</span>
            </th>
            <td colspan=3 class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;text-align: center;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">
                <strong>{$total_price_formatted|escape:'htmlall':'UTF-8'}</strong>
            </span>
            </td>
        </tr>
        {else}
        <tr id="total_quotation">
            <td colspan=6 vAlign=top style="border:0px solid #D6D4D4;background-color: #ffffff;"></td>
            <th colspan=3 class="text-right" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;text-align: left;">
                <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Total' mod='roja45quotationspro'}</span>
            </th>
            <td colspan=3 class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;text-align: center;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">
                <strong>{$total_price_without_tax_formatted|escape:'htmlall':'UTF-8'}</strong>
            </span>
            </td>
        </tr>
    {/if}
</table>

{if ($quotation->expiry_date != '0000-00-00 00:00:00')}
    <table class="table" bgcolor="#ffffff" style="width:100%">
        <tr>
            <td style="padding:7px 0">
                <p style="font-family: Helvetica, 'Open Sans', Arial, sans-serif;border:0px solid #D6D4D4;color: #c70005;margin:3px 0 7px;font-weight:500;font-size:14px;padding-bottom:10px">{l s='This quote will expire on %s at %s' sprintf=[$expiry_date|escape:'html':'UTF-8', $expiry_time|escape:'html':'UTF-8'] mod='roja45quotationspro'}</p>
            </td>
        </tr>
    </table>
{/if}
{if ($exchange_rate != 1)}
<table class="table" bgcolor="#ffffff" style="width:100%">
    <tr>
        <td class="linkbelow" style="padding:7px 0">
            <p style="font-family: Helvetica, 'Open Sans', Arial, sans-serif;border-bottom:1px solid #D6D4D4;margin:3px 0 7px;font-weight:500;font-size:14px;padding-bottom:10px">{l s='Your quote has been provided in your requested currency.  Please be aware that currency fluctuations may result in changes to the price you have been quoted.  We reserve the right to change or cancel this quote at any time.' mod='roja45quotationspro'}</p>
        </td>
    </tr>
</table>
{/if}
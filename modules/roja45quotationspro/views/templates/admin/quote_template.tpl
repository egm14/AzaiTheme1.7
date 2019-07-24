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

<table class="table" bgcolor="#ffffff" style="width:100%;border:1px solid #D6D4D4;background-color: #ffffff;" cellSpacing=0 cellPadding=0>
    <tr>
        <th colspan=1 bgcolor="#f8f8f8" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;padding: 10px;"></th>
        <th colspan=3 bgcolor="#f8f8f8" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;padding: 10px;">{l s='Product' mod='roja45quotationspro'}</th>
        <th align="center" colspan=2 bgcolor="#f8f8f8" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;padding: 10px;">{l s='Reference' mod='roja45quotationspro'}</th>
        <th colspan=2 bgcolor="#f8f8f8" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;padding: 10px;">{l s='Comment' mod='roja45quotationspro'}</th>
        <th align="center" colspan=2 bgcolor="#f8f8f8" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;padding: 10px;">{l s='Unit price' mod='roja45quotationspro'} {if $quotation->calculate_taxes}{l s='(inc.)' mod='roja45quotationspro'}{else}{l s='(exc.)' mod='roja45quotationspro'}{/if}</th>
        <th align="center" colspan=2 bgcolor="#f8f8f8" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;padding: 10px;">{l s='Quantity' mod='roja45quotationspro'}</th>
        <th align="center" colspan=2 bgcolor="#f8f8f8" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;padding: 10px;">{l s='Total price' mod='roja45quotationspro'} {if $quotation->calculate_taxes}{l s='(inc.)' mod='roja45quotationspro'}{else}{l s='(exc.)' mod='roja45quotationspro'}{/if}</th>
    </tr>
    {foreach from=$requested_products item=product key=k}
        {include file='./quote_template_product_line.tpl'}
    {/foreach}
</table>
<table class="table" bgcolor="#ffffff" style="border: 0;width:100%" cellSpacing=0 cellPadding=0 border="0">
    <tr>
        <td border="0" align="left" class="titleblock" style="padding:5px"></td>
    </tr>
</table>


{if (sizeof($charges))}
<table class="table" bgcolor="#ffffff" style="width:100%;border:0px;background-color: #ffffff;" cellSpacing=0 cellPadding=0 border="0">
    <tr>
        <th vAlign=top border="0" style="border:0;background-color: #ffffff;width:50%;">
        </th>
        <th colspan=2 align="center" style="border:0px solid #D6D4D4;border-top: 1px solid #d6d4d4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;background-color: #fbfbfb;padding: 10px;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Charge' mod='roja45quotationspro'}</span>
        </th>
        <th colspan=2 align="center" style="border:0px solid #D6D4D4;border-top: 1px solid #d6d4d4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;padding: 10px;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Type' mod='roja45quotationspro'}</span>
        </th>
        <th colspan=2 align="center" style="border:0px solid #D6D4D4;border-top: 1px solid #d6d4d4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;padding: 10px;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Value' mod='roja45quotationspro'}</span>
        </th>
        <th colspan=2 align="center" style="border:0px solid #D6D4D4;border-top: 1px solid #d6d4d4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;padding: 10px;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Value (inc. tax)' mod='roja45quotationspro'}</span>
        </th>
    </tr>
    {foreach from=$charges item=charge}
    <tr class="charge_row" data-id-quotation-charge="{$charge['id_roja45_quotation_charge']|escape:"html":"UTF-8"}">
        <td vAlign=top border="0" style="border:0;border-bottom: 0;background-color: #ffffff;width:50%;">
        </td>
        <td colspan=2 align="center" class="amount nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$charge['charge_name']|escape:"html":"UTF-8"}</span>
        </td>
        {if $charge['charge_type']=='SHIPPING'}
            <td colspan=2 align="center" class="amount nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
                <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{if $charge['charge_type']=='SHIPPING'}{l s='Shipping' mod='roja45quotationspro'}{/if}</span>
            </td>
        {/if}
        {if $charge['charge_type']=='HANDLING'}
            <td colspan=2 align="center" class="amount nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
                <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Handling' mod='roja45quotationspro'}</span>
            </td>
        {/if}
        <td colspan=2 align="center" class="amount nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$charge['charge_amount_formatted']|escape:'htmlall':'UTF-8'}</span>
        </td>
        <td colspan=2 align="center" class="amountnowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$charge['charge_amount_wt_formatted']|escape:'htmlall':'UTF-8'}</span>
        </td>
    </tr>
    {/foreach}
</table>
<table class="table" bgcolor="#ffffff" style="border: 0;width:100%" cellSpacing=0 cellPadding=0 border="0">
    <tr>
        <td border="0" align="left" class="titleblock" style="padding:5px"></td>
    </tr>
</table>
{/if}
{if (sizeof($discounts))}
<table class="table" bgcolor="#ffffff" style="width:100%;border:0px;background-color: #ffffff;" cellSpacing=0 cellPadding=0 border="0">
    <tr>
        <th border="0" width="50%" vAlign=top style="border:0;background-color: #ffffff;width:50%;">
        </th>
        <th width="25%" align="center" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;border-top: 1px solid #d6d4d4;background-color: #fbfbfb;padding: 10px;border-left: 1px solid #d6d4d4;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Discount' mod='roja45quotationspro'}</span>
        </th>
        <th width="25%" align="center" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;border-top: 1px solid #d6d4d4;background-color: #fbfbfb;padding: 10px;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Amount' mod='roja45quotationspro'} {if ($show_with_tax)}{l s='(inc.)' mod='roja45quotationspro'}{else}{l s='(exc.)' mod='roja45quotationspro'}{/if}</span>
        </th>
    </tr>
    {foreach from=$discounts item=discount}
        <tr class="discount_row">
            <td border="0" width="50%" vAlign=top style="border:0;background-color: #ffffff;width:50%;">
            </td>
            <td width="25%" align="center" class="amount text-left nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
                <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$discount['charge_name']|escape:"html":"UTF-8"} : {if ($discount['charge_method']  =='PERCENTAGE')}{$discount['charge_value']|escape:"html":"UTF-8"|string_format:"%.2f"}%{elseif ($discount['charge_method']  =='AMOUNT')}{$discount['charge_value_formatted']|escape:'htmlall':'UTF-8'}{/if}</span>
            </td>
            <td width="25%" align="center" class="amount text-left nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">
                {if ($show_with_tax)}
                    {$discount['amount_wt_formatted']}
                {else}
                    {$discount['amount_formatted']}
                {/if}
            </span>
            </td>
        </tr>
    {/foreach}
</table>
<table class="table" bgcolor="#ffffff" style="border: 0;width:100%">
    <tr>
        <td border="0" align="left" class="titleblock" style="padding:5px"></td>
    </tr>
</table>
{/if}

<table class="table" bgcolor="#ffffff" style="width:100%;border:0px;background-color: #ffffff;" cellSpacing=0 cellPadding=0 border=0>
    {if ($show_exchange_rate == 1)}
    <tr id="exchange_rate">
        <td  width="50%" vAlign=top style="border:0;background-color: #ffffff;width:50%;"></td>
        <th  width="25%" class="text-right" style="border:1px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;padding: 10px;border-left: 1px solid #d6d4d4;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Exchange Rate' mod='roja45quotationspro'} ({$default_currency_symbol|escape:'html':'UTF-8'})</span>
        </th>
        <td  width="25%" class="amount text-right nowrap" style="border:1px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
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

    {if ($show_with_tax)}
        <tr id="total_before_discount" {if $total_products == 0}style="display: none;"{/if}>
            <th border="0" vAlign=top width="50%" style="border:0;background-color: #ffffff;width:50%;"></th>
            <th align="center" width="25%" style="border:0px solid #D6D4D4;border-top: 1px solid #d6d4d4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;background-color: #fbfbfb;padding: 10px;">
                <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Sub-total (inc)' mod='roja45quotationspro'}</span>
            </th>
            <td align="center" width="25%" class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-top: 1px solid #d6d4d4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;border-right: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
                <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$total_products_wt_formatted|escape:'htmlall':'UTF-8'}</span>
            </td>
        </tr>

        <tr id="total_taxes">
            <td border="0" width="50%" vAlign=top style="border:0;background-color: #ffffff;"></td>
            <th align="center" width="25%" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;background-color: #fbfbfb;padding: 10px;">
                <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Taxes' mod='roja45quotationspro'} ({$tax_average_rate|escape:'html':'UTF-8'}%)</span>
            </th>
            <td align="center" width="25%" class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;border-right: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
                <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$total_tax_formatted|escape:'htmlall':'UTF-8'}</span>
            </td>
        </tr>

    {else}
        <tr id="total_before_discount" {if $total_products == 0}style="display: none;"{/if}>
            <th border="0" vAlign=top width="50%" style="border:0;background-color: #ffffff;width:50%;"></th>
            <th align="center" width="25%" style="border:0px solid #D6D4D4;border-top: 1px solid #d6d4d4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;background-color: #fbfbfb;padding: 10px;">
                <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Sub-total (exc)' mod='roja45quotationspro'}</span>
            </th>
            <td align="center" width="25%" class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-top: 1px solid #d6d4d4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;border-right: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
                <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$total_products_formatted|escape:'htmlall':'UTF-8'}</span>
            </td>
        </tr>
    {/if}

    {if $total_discounts > 0}
    <tr id="total_discounts">
        <td border="0" width="50%" vAlign=top style="border:0;background-color: #ffffff;"></td>
        <th align="center" width="25%" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;background-color: #fbfbfb;padding: 10px;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Discounts' mod='roja45quotationspro'}</span>
        </th>
        <td align="center" width="25%" class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;border-right: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$total_discounts_formatted|escape:'htmlall':'UTF-8'}</span>
        </td>
    </tr>

        {if ($show_with_tax)}
            <tr id="total_before_discount" {if $total_products == 0}style="display: none;"{/if}>
                <th border="0" vAlign=top width="50%" style="border:0;background-color: #ffffff;width:50%;"></th>
                <th align="center" width="25%" style="border:0px solid #D6D4D4;border-top: 1px solid #d6d4d4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;background-color: #fbfbfb;padding: 10px;">
                    <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Subtotal (inc)' mod='roja45quotationspro'}</span>
                </th>
                <td align="center" width="25%" class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-top: 1px solid #d6d4d4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;border-right: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
                    <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$total_products_after_discount_wt_formatted|escape:'htmlall':'UTF-8'}</span>
                </td>
            </tr>

        {else}
            <tr id="total_before_discount" {if $total_products == 0}style="display: none;"{/if}>
                <th border="0" vAlign=top width="50%" style="border:0;background-color: #ffffff;width:50%;"></th>
                <th align="center" width="25%" style="border:0px solid #D6D4D4;border-top: 1px solid #d6d4d4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;background-color: #fbfbfb;padding: 10px;">
                    <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Subtotal (exc)' mod='roja45quotationspro'}</span>
                </th>
                <td align="center" width="25%" class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-top: 1px solid #d6d4d4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;border-right: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
                    <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$total_products_after_discount_formatted|escape:'htmlall':'UTF-8'}</span>
                </td>
            </tr>
        {/if}
    {/if}
    {if $total_charges > 0}
    <tr id="total_charges">
        <td border="0" width="50%" vAlign=top style="border:0;background-color: #ffffff;"></td>
        <th align="center" width="25%" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;background-color: #fbfbfb;padding: 10px;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Charges (inc. tax)' mod='roja45quotationspro'}</span>
        </th>
        <td align="center" width="25%" class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;border-right: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$total_charges_formatted|escape:'htmlall':'UTF-8'}</span>
        </td>
    </tr>
    {/if}
    <tr id="total_shipping">
        <td border="0" width="50%" vAlign=top style="border:0;background-color: #ffffff;"></td>
        <th align="center" width="25%" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;background-color: #fbfbfb;padding: 10px;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Shipping (inc. tax)' mod='roja45quotationspro'}</span>
        </th>
        <td align="center" width="25%" class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;border-right: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$total_shipping_formatted|escape:'htmlall':'UTF-8'}</span>
        </td>
    </tr>
    {if $total_handling > 0}
    <tr id="total_handling">
        <td border="0" width="50%" vAlign=top style="border:0;background-color: #ffffff;"></td>
        <th align="center" width="25%" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;background-color: #fbfbfb;padding: 10px;">
            <span style="color: #333;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Handling (inc. tax)' mod='roja45quotationspro'}</span>
        </th>
        <td align="center" width="25%" class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;border-right: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$total_handling_formatted|escape:'htmlall':'UTF-8'}</span>
        </td>
    </tr>
    {/if}


    {if ($show_with_tax)}
        <tr id="total_quotation">
            <td border="0" width="50%" vAlign=top style="border:0;background-color: #ffffff;"></td>
            <th align="center" width="25%" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;background-color: #fbfbfb;padding: 10px;">
                <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Total' mod='roja45quotationspro'}</span>
            </th>
            <td align="center" width="25%" class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;border-right: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
                <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">
                    <strong>{$total_price_formatted|escape:'htmlall':'UTF-8'}</strong>
                </span>
            </td>
        </tr>
        {else}
        <tr id="total_quotation">
            <td border="0" width="50%" vAlign=top style="border:0;background-color: #ffffff;"></td>
            <th align="center" width="25%" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;background-color: #fbfbfb;padding: 10px;">
                <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{l s='Total' mod='roja45quotationspro'}</span>
            </th>
            <td align="center" width="25%" class="amount text-right nowrap" style="border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;border-left: 1px solid #d6d4d4;border-right: 1px solid #d6d4d4;background-color: #ffffff;padding: 10px;">
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
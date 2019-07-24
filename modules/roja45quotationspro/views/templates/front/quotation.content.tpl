{*
* 2016 ROJA45.COM
* All rights reserved.
*
* DISCLAIMER
*
* Changing this file will render any support provided by us null and void.
*
*  @author          Roja45 <support@roja45.com>
*  @copyright       2016 roja45.com
*}

<table width="100%" id="body" border="0" cellpadding="3" cellspacing="0" style="margin:0;">
    <tr>
        <td class="text-right">
            <h4 class="title">{l s='Customer Details' mod='roja45quotationspro'}</h4>
        </td>
    </tr>
</table>
<table width="100%" id="body" border="0" cellpadding="0" cellspacing="0" style="margin:0;">
    <tr>
        <td width="50%">
            <span>{l s='Customer Name' mod='roja45quotationspro'}</span>
        </td>
        <td width="50%">
            <span>{$template_data->customer->firstname|escape:'htmlall':'UTF-8'}&nbsp;{$template_data->customer->lastname|escape:'htmlall':'UTF-8'}</span>
        </td>
    </tr>
    <tr>
        <td width="50%">
            <span>{l s='Customer Email' mod='roja45quotationspro'}</span>
        </td>
        <td width="50%">
            <span>{$template_data->customer->email|escape:'htmlall':'UTF-8'}</span>
        </td>
    </tr>
    <tr>
        <td width="50%">
            <span>{l s='Customer Address' mod='roja45quotationspro'}</span>
        </td>
        <td width="50%">
            <span>{$customer_address|escape:'htmlall':'UTF-8'}</span>
        </td>
    </tr>
</table>
<table width="100%" id="body" border="0" cellpadding="0" cellspacing="0" style="margin:0;">
    <tr>
        <td width="100%" class="text-right">
            <h4 class="title">{l s='Quotation Details' mod='roja45quotationspro'}</h4>
        </td>
    </tr>
</table>
<table width="100%" id="body" border="0" cellpadding="3" cellspacing="0" style="margin:0;">
    {$products_tab} {* HTML Content *}
</table>
<table width="100%" id="body" border="0" cellpadding="0" cellspacing="0" style="margin:0;">
    <tr>
        <td class="space">&nbsp;</td>
    </tr>
</table>
{if (sizeof($template_data->charges)>0)}
<table width="100%" id="body" border="0" cellpadding="3" cellspacing="0" style="margin:0;">
    <tr>
        <th colspan=6 vAlign=top style="width:50%;text-align: center;background-color: #ffffff;"></th>
        <th colspan=2 style="width:16.666%; text-align: center;border:0px solid #D6D4D4;background-color: #f8f8f8;">
            <span style="font-weight:500;font-size:11px;"><font size="10">{l s='Charge' mod='roja45quotationspro'}</font></span>
        </th>
        <th colspan=2 style="width:16.666%; text-align: center;border:0px solid #D6D4D4;background-color: #f8f8f8;">
            <span><font size="10">{l s='Value' mod='roja45quotationspro'}</font></span>
        </th>
        <th colspan=2 style="width:16.666%; text-align: center;border:0px solid #D6D4D4;background-color: #f8f8f8;">
            <span><font size="10">{l s='Value (inc.)' mod='roja45quotationspro'}</font></span>
        </th>
    </tr>
    {foreach from=$template_data->charges item=charge}
    <tr class="charge_row" data-id-quotation-charge="{$charge['id_roja45_quotation_charge']|escape:"html":"UTF-8"}">
        <td colspan=6 vAlign=top style="text-align: center;background-color: #ffffff;"></td>
        <td colspan=2 style="width:16.666%; text-align: center;border:0px solid #D6D4D4;background-color: #ffffff;">
            <span><font size="10">{$charge['charge_name']|escape:"html":"UTF-8"}</font></span>
        </td>
        <td colspan=2 style="width:16.666%; text-align: center;border:0px solid #D6D4D4;background-color: #ffffff;">
            <span><font size="10">{$charge['charge_amount_formatted']|escape:'htmlall':'UTF-8'}</font></span>
        </td>
        <td colspan=2 style="width:16.666%; text-align: center;border:0px solid #D6D4D4;background-color: #ffffff;">
            <span><font size="10">{$charge['charge_amount_wt_formatted']|escape:'htmlall':'UTF-8'}</font></span>
        </td>
    </tr>
    {/foreach}
</table>
    <table width="100%" id="body" border="0" cellpadding="0" cellspacing="0" style="margin:0;">
        <tr>
            <td class="space">&nbsp;</td>
        </tr>
    </table>
{/if}
{if (sizeof($template_data->discounts))}
    <table width="100%" id="body" border="0" cellpadding="3" cellspacing="0" style="margin:0;">
    <tr>
        <th colspan=6 vAlign=top style="width:50%;text-align: center;background-color: #ffffff;"></th>
        <th colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #f8f8f8;">
            <span><font size="10">{l s='Discount' mod='roja45quotationspro'}</font></span>
        </th>
        <th colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #f8f8f8;">
            <span><font size="10">{l s='Amount' mod='roja45quotationspro'}</font></span>
        </th>
    </tr>
    {foreach from=$template_data->discounts item=discount}
    <tr class="discount_row">
        <td colspan=6 vAlign=top style="width:50%;text-align: center;background-color: #ffffff;"></td>
        <td colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #ffffff;">
            <span><font size="10">{$discount['charge_name']|escape:"html":"UTF-8"} : {if ($discount['charge_method']  =='PERCENTAGE')}{$discount['charge_value']|escape:"html":"UTF-8"|string_format:"%.2f"}%{elseif ($discount['charge_method']  =='AMOUNT')}{$discount['charge_value_formatted']|escape:'htmlall':'UTF-8'}{/if}</font></span>
        </td>
        <td colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #ffffff;">
            <span><font size="10">{if ($template_data->use_taxes)}{$discount['amount_wt_formatted']}{else}{$discount['amount_formatted']}{/if}</font></span>
        </td>
    </tr>
    {/foreach}
</table>
    <table width="100%" id="body" border="0" cellpadding="0" cellspacing="0" style="margin:0;">
        <tr>
            <td class="space">&nbsp;</td>
        </tr>
    </table>
{/if}

<table width="100%" id="body" border="0" cellpadding="3" cellspacing="0" style="margin:0;">
    <!--Change behavior on show rate and total order box -->
    {if ($template_data->show_exchange_rate != 0)}
        <tr id="exchange_rate">
            <td colspan=6 vAlign=top style="width:50%;text-align: center;background-color: #ffffff;"></td>
            <th colspan=3 class="text-right" style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #f8f8f8;">
                <span><font size="10">{l s='Exchange Rate' mod='roja45quotationspro'} ({$default_currency_symbol|escape:'html':'UTF-8'})</font></span>
            </td>
            <td colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #ffffff;">
                <span><font size="10">{$exchange_rate|escape:'html':'UTF-8'}</font></span>
            </td>
        </tr>
    {/if}

    {if ($template_data->use_taxes)}
        <tr id="total_before_discount">
            <td colspan=6 vAlign=top style="width:50%;text-align: center;background-color: #ffffff;"></td>
            <th colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #f8f8f8;">
                <span>{l s='Sub-Total (exc.)' mod='roja45quotationspro'}</span>
            </th>
            <td colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #ffffff;">
                <span>{$template_data->total_products_formatted}</span>
            </td>
        </tr>
    {if $template_data->total_discounts > 0}
        <tr id="total_discounts">
            <td colspan=6 vAlign=top style="width:50%;text-align: center;background-color: #ffffff;"></td>
            <th colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #f8f8f8;">
                <span>{l s='Discounts' mod='roja45quotationspro'}</span>
            </th>
            <td colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #ffffff;">
                <span>{$template_data->total_discounts_formatted|escape:'htmlall':'UTF-8'}</span>
            </td>
        </tr>
    {/if}
        {if $template_data->total_charges_wt > 0}
        <tr id="total_charges">
            <td colspan=6 vAlign=top style="width:50%;text-align: center;background-color: #ffffff;"></td>
            <th colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #f8f8f8;">
                <span>{l s='Charges (inc.)' mod='roja45quotationspro'}</span>
            </th>
            <td colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #ffffff;">
                <span>{$template_data->total_charges_wt_formatted|escape:'htmlall':'UTF-8'}</span>
            </td>
        </tr>
        {/if}
        <tr id="total_shipping">
            <td colspan=6 vAlign=top style="width:50%;text-align: center;background-color: #ffffff;"></td>
            <th colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #f8f8f8;">
                <span>{l s='Shipping (inc.)' mod='roja45quotationspro'}</span>
            </th>
            <td colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #ffffff;">
                <span>{$template_data->total_shipping_wt_formatted|escape:'htmlall':'UTF-8'}</span>
            </td>
        </tr>
        {if $template_data->total_shipping_wt > 0}
        <tr id="total_handling">
            <td colspan=6 vAlign=top style="width:50%;text-align: center;background-color: #ffffff;"></td>
            <th colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #f8f8f8;">
                <span>{l s='Handling (inc. tax)' mod='roja45quotationspro'}</span>
            </th>
            <td colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #ffffff;">
                <span>{$template_data->total_handling_wt_formatted|escape:'htmlall':'UTF-8'}</span>
            </td>
        </tr>
        {/if}
        <tr id="total_products">
            <td colspan=6 vAlign=top style="width:50%;text-align: center;background-color: #ffffff;"></td>
            <th colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #f8f8f8;">
                <span>{l s='Total Products' mod='roja45quotationspro'}</span></th>
            <td colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #ffffff;">
                <span>{$template_data->total_products_after_discount_wt_formatted|escape:'htmlall':'UTF-8'}</span>
            </td>
        </tr>
        <tr id="total_taxes">
            <td colspan=6 vAlign=top style="width:50%;text-align: center;background-color: #ffffff;"></td>
            <th colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #f8f8f8;">
                <span>{l s='Taxes' mod='roja45quotationspro'} ({$template_data->tax_average_rate|escape:'html':'UTF-8'}%)</span>
            </th>
            <td colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #ffffff;">
                <span>{$template_data->total_tax_formatted|escape:'htmlall':'UTF-8'}</span>
            </td>
        </tr>

        <tr id="total_quotation">
            <td colspan=6 vAlign=top style="width:50%;text-align: center;background-color: #ffffff;"></td>
            <th colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #f8f8f8;">
                <span>{l s='Total' mod='roja45quotationspro'}</span>
            </th>
            <td colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #ffffff;">
            <span>
                <strong>{$template_data->total_price_formatted|escape:'htmlall':'UTF-8'}</strong>
            </span>
            </td>
        </tr>
    {else}
        <tr id="total_before_discount">
            <td colspan=6 vAlign=top style="width:50%;text-align: center;background-color: #ffffff;"></td>
            <th colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #f8f8f8;">
                <span>{l s='Sub-Total Products (exc)' mod='roja45quotationspro'}</span>
            </th>
            <td colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #ffffff;">
                <span>{$template_data->total_products_formatted|escape:'htmlall':'UTF-8'}</span>
            </td>
        </tr>
        <tr id="total_discounts">
            <td colspan=6 vAlign=top style="width:50%;text-align: center;background-color: #ffffff;"></td>
            <th colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #f8f8f8;">
                <span>{l s='Discounts' mod='roja45quotationspro'}</span>
            </th>
            <td colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #ffffff;">
                <span>{$template_data->total_discounts_formatted|escape:'htmlall':'UTF-8'}</span>
            </td>
        </tr>
        {if $template_data->total_charges > 0}
        <tr id="total_charges">
            <td colspan=6 vAlign=top style="width:50%;text-align: center;background-color: #ffffff;"></td>
            <th colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #f8f8f8;">
                <span>{l s='Charges (exc.)' mod='roja45quotationspro'}</span>
            </th>
            <td colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #ffffff;">
                <span>{$template_data->total_charges_formatted|escape:'htmlall':'UTF-8'}</span>
            </td>
        </tr>
        {/if}
        <tr id="total_shipping">
            <td colspan=6 vAlign=top style="width:50%;text-align: center;background-color: #ffffff;"></td>
            <th colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #f8f8f8;">
                <span>{l s='Shipping (exc.)' mod='roja45quotationspro'}</span>
            </th>
            <td colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #ffffff;">
                <span>{$template_data->total_shipping_formatted|escape:'htmlall':'UTF-8'}</span>
            </td>
        </tr>
        {if $template_data->total_charges > 0}
        <tr id="total_handling">
            <td colspan=6 vAlign=top style="width:50%;text-align: center;background-color: #ffffff;"></td>
            <th colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #f8f8f8;">
                <span>{l s='Handling (exc.)' mod='roja45quotationspro'}</span>
            </th>
            <td colspan=3 class="right">
                <span>{$template_data->total_handling_formatted|escape:'htmlall':'UTF-8'}</span>
            </td>
        </tr>
        {/if}
        <tr id="total_products">
            <td colspan=6 vAlign=top></td>
            <th colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #f8f8f8;">
                <span>{l s='Total Products' mod='roja45quotationspro'}</span></th>
            <td colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #ffffff;">
                <span>{$template_data->total_products_after_discount_formatted|escape:'htmlall':'UTF-8'}</span>
            </td>
        </tr>

        <tr id="total_quotation">
            <td colspan=6 vAlign=top style="width:50%;text-align: center;background-color: #ffffff;"></td>
            <th colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #f8f8f8;">
                <span>{l s='Total' mod='roja45quotationspro'}</span>
            </th>
            <td colspan=3 style="width:25%; text-align: center;border:0px solid #D6D4D4;background-color: #ffffff;">
            <span>
                <strong>{$template_data->total_price_without_tax_formatted|escape:'htmlall':'UTF-8'}</strong>
            </span>
            </td>
        </tr>
    {/if}
</table>

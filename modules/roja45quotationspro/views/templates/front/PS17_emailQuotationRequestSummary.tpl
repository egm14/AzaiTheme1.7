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

 {assign var=packageAzaiW value="9"}
<table class="table table-recap" bgcolor="#ffffff" style="width:100%;border-collapse:collapse" cellSpacing=0 cellPadding=0 border=0>
    <tr>
        <td class="text-right" style="width:100%;border:1px solid #D6D4D4;border-bottom: 0;background-color: #fbfbfb;padding: 5px;">
            <span class="title" style="font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-weight:500;font-size:15px;color: #444444;text-transform:uppercase;line-height:20px;">{l s='Request Summary' mod='roja45quotationspro'}</span>
        </td>
    </tr>
</table>

<table class="table table-recap" bgcolor="#ffffff" style="width:100%;border-collapse:collapse" cellSpacing=0 cellPadding=0 border=0>
    <thead>
    <tr>
        <td colspan="2" style="border:1px solid #D6D4D4;text-align:center;color:#777;padding:7px 0">
        </td>
        <th colspan="5" bgcolor="#f8f8f8" style="border:1px solid #D6D4D4;background-color: #fbfbfb;color: #333;font-family: Arial;font-size: 12px;padding: 5px;text-transform:uppercase;">
            <span style="color: #333;font-family: Arial;font-size: 13px;padding: 5px;font-weight: 500;text-transform:uppercase;">{l s='Product' mod='roja45quotationspro'}</span>
        </th>
        <th colspan="5" bgcolor="#f8f8f8" style="border:1px solid #D6D4D4;background-color: #fbfbfb;color: #333;font-family: Arial;font-size: 12px;padding: 5px;text-transform:uppercase;">
            <span style="color: #333;font-family: Arial;font-size: 13px;padding: 5px;font-weight: 500;text-transform:uppercase;">{l s='Combination' mod='roja45quotationspro'}</span>
        </th>
        <th colspan="5" bgcolor="#f8f8f8" style="border:1px solid #D6D4D4;background-color: #fbfbfb;color: #333;font-family: Arial;font-size: 12px;padding: 5px;text-transform:uppercase;">
            <span style="color: #333;font-family: Arial;font-size: 13px;padding: 5px;font-weight: 500;text-transform:uppercase;">{l s='Reference' mod='roja45quotationspro'}</span>
        </th>
        <th colspan="5" bgcolor="#f8f8f8" style="border:1px solid #D6D4D4;background-color: #fbfbfb;color: #333;font-family: Arial;font-size: 12px;padding: 5px;text-transform:uppercase;">
            <span style="color: #333;font-family: Arial;font-size: 13px;padding: 5px;font-weight: 500;text-transform:uppercase;">{l s='Quantity Requested' mod='roja45quotationspro'}</span>
        </th>
        <th colspan="5" bgcolor="#f8f8f8" style="border:1px solid #D6D4D4;background-color: #fbfbfb;color: #333;font-family: Arial;font-size: 12px;padding: 5px;text-transform:uppercase;">
            <span style="color: #333;font-family: Arial;font-size: 13px;padding: 5px;font-weight: 500;text-transform:uppercase;">{l s='Price' mod='roja45quotationspro'}</span>
        </th>
    </tr>
    </thead>
    <tbody>
        {assign var="total_quote" value='0'} 
        {assign var="total_quote_qtye" value='0'} 
    {foreach $requested_products as $product}
    <tr>
        <td colspan="2" style="border:1px solid #D6D4D4;text-align:center;color:#777;padding:7px 0">
            <img src="{$link->getImageLink($product.link_rewrite, $product.id_image, 'small_default')|escape:'html':'UTF-8'}"
                 alt="{$product.name|escape:'html':'UTF-8'}"/>
        </td>
        <td colspan="5" style="border:1px solid #D6D4D4;text-align:center;color:#777;padding:7px 0">
            <span style="color: #333;font-family: Arial;font-size: 13px;padding: 5px;font-weight: 500;">{$product.name|escape:'html':'UTF-8'}</span>
        </td>
        <td colspan="5" style="border:1px solid #D6D4D4;text-align:center;color:#777;padding:7px 0">
            <span style="color: #333;font-family: Arial;font-size: 13px;padding: 5px;font-weight: 500;">{if isset($product.attributes)}
                {assign var="color" value=","|explode:$product.attributes}{$color[0]}
                {*$product.attributes|escape:'html':'UTF-8'*}
        {/if}</span>
        </td>
        <td colspan="5" style="border:1px solid #D6D4D4;text-align:center;color:#777;padding:7px 0">
            <span style="color: #333;font-family: Arial;font-size: 13px;padding: 5px;font-weight: 500;">{if isset($product.reference)}
            {*$product.reference|escape:'html':'UTF-8'*}
            {assign var="referenceProduct" value="-"|explode:$product.reference}{$referenceProduct[1]|escape:'html':'UTF-8'}
        {/if}</span>
        </td>
        <td colspan="5" style="border:1px solid #D6D4D4;text-align:center;color:#777;padding:7px 0">
            <span style="color: #333;font-family: Arial;font-size: 13px;padding: 5px;font-weight: 500;">{$product.qty_in_cart|escape:'html':'UTF-8'} ({$packageAzaiW} {l s='Und'})</span>
        </td>
        {assign var="priceValue" value=$product.product_price*($product.quote_quantity*$packageAzaiW) scope=parent}
        <td colspan="5" style="border:1px solid #D6D4D4;text-align:center;color:#777;padding:7px 0">
            <span style="color: #333;font-family: Arial;font-size: 13px;padding: 5px;font-weight: 500;">{$product.product_price_currency_iso}{$product.product_price_currency_symbol}{$priceValue|number_format:2:".":","}</span>
        </td>
    </tr>
        {*Sum the total quote*}
        {$total_quote=$total_quote+$priceValue}
        {$total_quote_qtye=$total_quote_qtye+$product.qty_in_cart}
    {/foreach}
    <!--Adding total Quote request -->
    <tr class="last-row-resumen" style="font-weight:bold;font-size:1rem;">
        <td colspan="2" style="text-align:center;color:#777;padding:7px 0"></td>
        <td colspan="5" style="text-align:center;color:#777;padding:7px 0"></td>  
        <td colspan="5" style="text-align:center;color:#777;padding:7px 0"></td>              
        <td colspan="5" style="text-align:center;color:#777;padding:7px 0;background-color:#000;"><span style="color: #fff;font-family: Arial;font-size: 13px;padding: 5px;font-weight: 500;">Total</span></td>
        <td colspan="5" style="border:1px solid #D6D4D4;text-align:center;color:#777;padding:7px 0;background-color:#000;"><span style="color: #fff;font-family: Arial;font-size: 13px;padding: 5px;font-weight: 500;">{$total_quote_qtye} ({$total_quote_qtye*$packageAzaiW} {l s='Und'})</span></td>
        <td colspan="5" style="border:1px solid #D6D4D4;text-align:center;color:#777;padding:7px 0;background-color:#000;"><span style="color: #fff;font-family: Arial;font-size: 13px;padding: 5px;font-weight: 500;">{$product.product_price_currency_iso}{$product.product_price_currency_symbol}{$total_quote|number_format:2:".":","}</span></h3></td>
        
        
    </tr>
</table>
<table class="table" bgcolor="#ffffff" style="width:100%">
    <tr>
        <td class="space" style="width:20px;padding:2px 0">&nbsp;</td>
    </tr>
</table>


<table class="table table-recap" bgcolor="#ffffff" style="width:100%;border-collapse:collapse" cellSpacing=0 cellPadding=0 border=0>
    <tr>
{foreach $request_data->columns as $column}
    {if isset($column->heading) && $column->heading}
    <table class="table table-recap" bgcolor="#ffffff" style="width:100%;border-collapse:collapse" cellSpacing=0 cellPadding=0 border=0>
        <tr>
            <td class="text-right" style="width:100%;border:1px solid #D6D4D4;border-bottom: 0;background-color: #fbfbfb;padding: 5px;">
                <span class="title" style="font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-weight:500;font-size:15px;color: #444444;text-transform:uppercase;line-height:20px;">{$column->heading|escape:'html':'UTF-8'}</span>
            </td>
        </tr>
    </table>
    {/if}
    {foreach $column->fields as $field}
    <table class="table table-recap" bgcolor="#ffffff" style="width:100%;border-collapse:collapse" cellSpacing=0 cellPadding=0 border=0>
        <tr>
            <td colspan=1 class="text-right" style="width:40%;border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #fbfbfb;padding: 5px;">
                <span style="font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-weight:500;font-size:13px;color: #444444;text-transform:uppercase;">{$field->label|escape:'html':'UTF-8'}</span>
            </td>
            {if ($field->type=='CHECKBOX')}
            <td colspan=1 class="text-right" style="width:60%;border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;padding: 5px;">
                <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{if $field->value == "1"}{l s='CHECKED' mod='roja45quotationspro'}{else}{l s='UNCHECKED' mod='roja45quotationspro'}{/if}</span>
            </td>
            {elseif ($field->type=='SWITCH')}
            <td colspan=1 class="text-right" style="width:60%;border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;padding: 5px;">
                <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{if $field->value == "1"}{l s='SELECTED' mod='roja45quotationspro'}{else}{l s='UNSELECTED' mod='roja45quotationspro'}{/if}</span>
            </td>
            {else}
            <td colspan=1 class="text-right" style="width:60%;border:0px solid #D6D4D4;border-bottom: 1px solid #d6d4d4;background-color: #ffffff;padding: 5px;">
                <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$field->value|escape:'html':'UTF-8'}</span>
            </td>
            {/if}
        </tr>
    </table>
    {/foreach}
    </tr>
{/foreach}
</table>

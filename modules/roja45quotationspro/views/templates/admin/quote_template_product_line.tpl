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
    {assign var=product_price value=$product.unit_price_tax_incl}
    {assign var=product_price_formatted value=$product.unit_price_tax_incl_formatted}
    {assign var=product_price_subtotal_formatted value=$product.unit_price_tax_incl_formatted}
{else}
    {assign var=product_price value=$product.unit_price_tax_excl}
    {assign var=product_price_formatted value=$product.unit_price_tax_excl_formatted}
    {assign var=product_price_subtotal_formatted value=$product.product_price_subtotal_excl_formatted}
{/if}

<tr>
    <td colspan=1 style="border:0px solid #D6D4D4;border-bottom:1px solid #D6D4D4;">
        {if isset($product.image) && $product.image->id}<img src="{$product.image_tag|escape:'html':'UTF-8'}" alt="{$product['product_title']|escape:'html':'UTF-8'}" class="img img-thumbnail" />{/if}
    </td>
    <td colspan=3 style="border:0px solid #D6D4D4;border-bottom:1px solid #D6D4D4;">
        <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$product['product_title']|escape:'html':'UTF-8'}</span>
    </td>
    <td align="center" colspan=2 style="border:0px solid #D6D4D4;border-bottom:1px solid #D6D4D4;">
        <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{if $product.reference}{$product.reference|escape:'html':'UTF-8'}{/if}</span>
    </td>
    <td colspan=2 style="border:0px solid #D6D4D4;border-bottom:1px solid #D6D4D4;">
    <table class="table">
        <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{if isset($product.comment)}{$product.comment|escape:'html':'UTF-8'}{/if}</span>
    </table>
    </td>
    {if $quotation->calculate_taxes}
        <td align="center" colspan=2 style="border:0px solid #D6D4D4;border-bottom:1px solid #D6D4D4;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$product.unit_price_tax_incl_formatted|escape:'htmlall':'UTF-8'}</span>
        </td>
    {else}
        <td align="center" colspan=2 style="border:0px solid #D6D4D4;border-bottom:1px solid #D6D4D4;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$product.unit_price_tax_excl_formatted|escape:'htmlall':'UTF-8'}</span>
        </td>
    {/if}
    <td align="center" colspan=2 style="border:0px solid #D6D4D4;border-bottom:1px solid #D6D4D4;">
        <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$product['qty']|escape:'html':'UTF-8'}</span>
    </td>
    {if $quotation->calculate_taxes}
        <td align="center" colspan=2 style="border:0px solid #D6D4D4;border-bottom:1px solid #D6D4D4;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$product.product_price_subtotal_incl_formatted|escape:'htmlall':'UTF-8'}</span>
        </td>
    {else}
        <td align="center" colspan=2 style="border:0px solid #D6D4D4;border-bottom:1px solid #D6D4D4;">
            <span style="color: #444444;font-family: Helvetica, 'Open Sans', Arial, sans-serif;font-size: 13px;">{$product.product_price_subtotal_excl_formatted|escape:'htmlall':'UTF-8'}</span>
        </td>
    {/if}
</tr>
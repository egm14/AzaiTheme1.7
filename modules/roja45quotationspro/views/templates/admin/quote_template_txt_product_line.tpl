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

{if ($quotation->calculate_taxes == 0)}
    {assign var=product_price value=$product.unit_price_tax_excl}
    {assign var=product_price_formatted value=$product.unit_price_tax_excl_formatted}
    {assign var=product_price_subtotal_formatted value=$product.product_price_subtotal_excl_formatted}
{else}
    {assign var=product_price value=$product.unit_price_tax_incl}
    {assign var=product_price_formatted value=$product.unit_price_tax_incl_formatted}
    {assign var=product_price_subtotal_formatted value=$product.unit_price_tax_incl_formatted}
{/if}

{$product['name']|escape:'html':'UTF-8'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{if $product.reference} Reference number: {$product.reference|escape:'html':'UTF-8'} {/if}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{if $product.comment} {$product.comment|escape:'html':'UTF-8'} {/if}    {$product_price_formatted}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$product['qty']|escape:'html':'UTF-8'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$product_price_formatted}
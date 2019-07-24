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


{l s='Product' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{l s='Reference' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{l s='Comment' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{l s='Unit Price' mod='roja45quotationspro'} {if ($default_tax_method==1)}{l s='(tax excl.)' mod='roja45quotationspro'}{else}{l s='(tax incl.)' mod='roja45quotationspro'}{/if}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{l s='Quantity' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{l s='Total' mod='roja45quotationspro'}{if ($default_tax_method==1)} {l s='(tax excl.)' mod='roja45quotationspro'}{else}{l s='(tax incl.)' mod='roja45quotationspro'}{/if}
{foreach from=$requested_products item=product key=k}
    {include file='./quote_template_txt_product_line.tpl'}
{/foreach}

{if (sizeof($charges))}
    {include file='./quote_template_txt_charge_table.tpl'}
{else}
    {l s='No Charges Included' mod='roja45quotationspro'}
{/if}

{if (sizeof($discounts))}
    {include file='./quote_template_txt_discount_table.tpl'}
{else}
    {l s='No Discounts Included' mod='roja45quotationspro'}
{/if}
{include file='./quote_template_txt_totals.tpl'}

{if ($exchange_rate != 1)}
    {l s='Your quote has been provided in your requested currency.  Please be aware that currency fluctuations may result in changes to the price you have been quoted.  We reserve the right to change or cancel this quote at any time.' mod='roja45quotationspro'}
{/if}
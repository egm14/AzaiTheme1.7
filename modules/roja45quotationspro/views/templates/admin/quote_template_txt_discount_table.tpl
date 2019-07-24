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

{l s='Discount' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{l s='Amount' mod='roja45quotationspro'}
{foreach from=$discounts item=discount}
    {$discount['charge_name']|escape:"html":"UTF-8"}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{if ($discount['charge_method']  =='PERCENTAGE')} {$discount['charge_value']|string_format:"%.2f"}%{elseif ($discount['charge_method']  =='AMOUNT')} {$discount['charge_value_formatted']}{/if}
{/foreach}
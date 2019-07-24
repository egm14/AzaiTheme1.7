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

Charge Name          Charge Type          Value (exc. tax)          Value (inc. tax)
{foreach from=$charges item=charge}
    {$charge['charge_name']|escape:'html':'UTF-8'}          {if $charge['charge_type']=='SHIPPING'}Shipping Charge{/if} {if $charge['charge_type']=='HANDLING'}Handling Charge{/if} {$charge['charge_amount_formatted']}</span> {$charge['charge_amount_wt_formatted']}</span>
{/foreach}

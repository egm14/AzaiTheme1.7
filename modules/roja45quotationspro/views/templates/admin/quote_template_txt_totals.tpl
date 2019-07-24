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

{assign var=quotation_discount_price value=0.00}
{assign var=quotation_charges_price value=0.00}
{assign var=quotation_wrapping_price value=0.00}
{assign var=quotation_shipping_price value=0.00}
{if ($show_exchange_rate == 1)}
    {l s='Exchange Rate' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;({$default_currency_symbol|escape:'html':'UTF-8'}) {$exchange_rate|escape:'html':'UTF-8'}

    {/if}
{if ($use_taxes)}
    {l s='Tax Rate (%)' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$tax_average_rate|escape:'html':'UTF-8'}
    {l s='Taxes' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$total_tax_formatted|escape:'htmlall':'UTF-8'}
    {l s='Sub-Total Products' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$total_products_wt_formatted|escape:'htmlall':'UTF-8'}
    {l s='Discounts' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$total_discounts_formatted|escape:'htmlall':'UTF-8'}
    {l s='Total Products' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$total_products_after_discount_wt_formatted|escape:'htmlall':'UTF-8'}
    {l s='Charges (inc.tax)' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$total_charges_wt_formatted|escape:'htmlall':'UTF-8'}
    {l s='Shipping (inc.tax)' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$total_shipping_wt_formatted|escape:'htmlall':'UTF-8'}
    {l s='Handling (inc.tax)' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$total_handling_wt_formatted|escape:'htmlall':'UTF-8'}
    {l s='Sub-Total' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$total_price_before_discount_wt_formatted|escape:'htmlall':'UTF-8'}
    {l s='Discounts' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$total_discounts_formatted|escape:'htmlall':'UTF-8'}
{else}
    {l s='Sub-Total Products' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$total_products_formatted|escape:'htmlall':'UTF-8'}
    {l s='Discounts' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$total_discounts_formatted|escape:'htmlall':'UTF-8'}
    {l s='Total Products' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$total_products_after_discount_wt_formatted|escape:'htmlall':'UTF-8'}
    {l s='Charges (exc.tax)' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$total_charges_formatted|escape:'htmlall':'UTF-8'}
    {l s='Shipping (exc.tax)' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$total_shipping_formatted|escape:'htmlall':'UTF-8'}
    {l s='Handling (exc.tax)' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$total_handling_formatted|escape:'htmlall':'UTF-8'}
    {l s='Sub-Total' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$total_price_before_discount_formatted|escape:'htmlall':'UTF-8'}
    {l s='Discounts' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$total_discounts_formatted|escape:'htmlall':'UTF-8'}
{/if}
&nbsp;
{if ($use_taxes)}
    {l s='Total' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$total_price_formatted|escape:'htmlall':'UTF-8'}
{else}
    {l s='Total' mod='roja45quotationspro'}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$total_price_without_tax_formatted|escape:'htmlall':'UTF-8'}
{/if}
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

<li class="ma-link-item col-lg-2 col-md-3 col-sm-4 col-6">
  <a id="quotes-link"
   href="{url entity='module' name='roja45quotationspro' controller='QuotationsProFront' params = ['action' => 'getCustomerQuotes']}">
      <span class="link-item">
        <i class="material-icons">view_list</i>
        <span>{l s='Open Quotes' mod='roja45quotationspro'}</span>
      </span>
</li></a>

<li class="ma-link-item col-lg-2 col-md-3 col-sm-4 col-6">
 <a  id="quote-history-link"
   href="{url entity='module' name='roja45quotationspro' controller='QuotationsProFront' params = ['action' => 'getCustomerQuoteHistory']}">
      <span class="link-item">
        <i class="material-icons">view_list</i>
        <span>{l s='Quote History' mod='roja45quotationspro'}</span>
      </span>
</li></a>
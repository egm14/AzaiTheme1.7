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

{l s='Dear %1$s %2$s' sprintf=[$customer->firstname, $customer->lastname] mod='roja45quotationspro'},

Many thanks for your request.  We are pleased to provide below our quotation for the items you requested.

{if isset($include_account) && $include_account}
    {include file='./send_quote_account.tpl'}
{/if}
{include file='./quote_template.tpl'}

Open the following link to purchase this quote now: {$purchase_link}

You can find more details regarding this quote the My Quotes section in your account area.  Log in to the 'My Quotes' section of your account using this link: {my_quotes_link}
If you would like to change the items on your quote you may either email us by replying to this email, with your changes, or create a new quotation request via the website.

If you have any questions, please do not hesitate to contact us.

{$shop_name} built by http://www.roja45.com/
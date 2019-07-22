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

{extends file='page.tpl'}

{block name="page_title"}
    <h4 id="quote_title" class="title_block">{l s='Request Received' mod='roja45quotationspro'}</h4>
{/block}

{block name='page_content'}
<div class="quotationspro_request_dialog_overlay"></div>
    <div class="box">
        <p>{l s='Many thanks, we have received your request.  We will contact you with your quotation as soon as possible.' mod='roja45quotationspro'}</p>
    </div>
    <p class="quote_navigation clearfix">
        <a href="{$home_url}" title="{l s='Home' mod='roja45quotationspro'}" class="pull-right button-exclusive btn btn-default">
            {l s='Home' mod='roja45quotationspro'}
            <i class="icon-chevron-right right"></i>
        </a>
    </p>
</div>
{/block}
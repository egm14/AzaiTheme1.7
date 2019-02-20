{*
 *
 * GIFT CARD
 *
 * @category pricing_promotion
 * @author EIRL Timactive De Véra
 * @copyright TIMACTIVE 2013
 * @version 1.0.0
 *
 *************************************
 **            GIFT CARD			 *              
 **             V 1.0.0              *
 *************************************
 * +
 * + Languages: EN, FR
 * + PS version: 1.5
 *
 *}
{extends file='page.tpl'}
{block name='page_content'}
<div id="choicegiftcard" data-link-controller="{$linkcgc|escape:'htmlall':'UTF-8'}">
	{* visible when ajax call*}
	<div class="ui-loader-background"> </div>
	{capture name=path}{l s='Gift card' mod='giftcard'}{/capture}
	
	{$front_content nofilter}{** CONTENT HTML / SETTING MODULE **}
	
	{if !isset($templates) || count($templates) == 0}
		<p class="warning">
					{l s='No model available' mod='giftcard'}
		</p>
	{elseif !isset($cards) || $cards|@count == 0}
		<p class="warning">
					{l s='No card available' mod='giftcard'}
		</p>
	{else}
       <form class="form" id="formgiftcard" action="{$linkcgc|escape:'quotes':'UTF-8'}" method="POST">
        {*** STEP 1 RECEPTION MODE ***}
        <section  id= "gc-step-receptmode" class="js-current-step" data-gcstep-enable="1" data-gcstep-valid="0">
        <h2 class="step-title">
		    <i class="icon-ta-check done"></i>
		    <span class="step-number">1</span>
		    {l s='Select the reception mode' mod='giftcard'}
		    <span class="step-edit text-muted"><i class="icon-ta-pencil"></i> {l s='edit' mod='giftcard'}</span>
  		</h2>
  		<div class="gc-section-content">
	    <div class="gc-receptmode-options">
	    {if $virtual_cards_available}
	     {* Comentario <!--<div class="gc-receptmode-option clearfix">
		     <span class="custom-radio pull-xs-left">
              <input
                class="ps-shown-by-js"
                id="receptmode_printathome"
                name="receptmode"
                type="radio"
                value="0"
              >
              <span></span>
            </span>
            <label for="receptmode_printathome">
              <span>{l s='Print at home' mod='giftcard'}</span>
            </label>
           </div>-->Final*}
           <div class="gc-receptmode-option clearfix">
            <div>
            <span class="custom-radio pull-xs-left">
              <input
                class="ps-shown-by-js"
                id="receptmode_mail"
                name="receptmode"
                type="radio"
                value="1"
              >
              <span></span>
            </span>
            <label for="receptmode_mail">
              <span>{l s='Send by e-mail' mod='giftcard'}</span>
            </label>
            </div>
            <div id="recepmode-mail-additional-information">
	            <p class="email datesendcard">
			      <input name="mailto" type="text" class="input email" placeholder="{l s='To : Email' mod='giftcard'}" />
		        </p>
		        <p class="description datesendcard">
			         {l s='The gift card will be sent by email to the recipient as soon as your payment is confirmed. You can also choose to send at a later date by selecting that date below.' mod='giftcard'}	
		        </p>
				<p class="select datesendcard">
					{* Not delete is use in translat tools
					{l s='January' mod='giftcard'}
					{l s='February' mod='giftcard'}
					{l s='March' mod='giftcard'}
					{l s='April' mod='giftcard'}
					{l s='May' mod='giftcard'}
					{l s='June' mod='giftcard'}
					{l s='July' mod='giftcard'}
					{l s='August' mod='giftcard'}
					{l s='September' mod='giftcard'}
					{l s='October' mod='giftcard'}
					{l s='November' mod='giftcard'}
					{l s='December' mod='giftcard'}
				    *}
					<select name="days" id="days">
						<option value="">-</option>
						{foreach from=$days item=v}
							<option value="{$v|intval}" {if ($sl_day == $v)}selected="selected"{/if}>{$v|escape:'htmlall':'UTF-8'}&nbsp;&nbsp;</option>
						{/foreach}
					</select>
					<select id="months" name="months">
						<option value="">-</option>
						{foreach from=$months key=k item=v}
							<option value="{$k|intval}" {if ($sl_month == $k)}selected="selected"{/if}>{l s=$v mod='giftcard'}&nbsp;</option>
						{/foreach}
					</select>
					<select id="years" name="years">
						<option value="">-</option>
						{foreach from=$years item=v}
							<option value="{$v|intval}" {if ($sl_year == $v)}selected="selected"{/if}>{$v|escape:'htmlall':'UTF-8'}&nbsp;&nbsp;</option>
						{/foreach}
					</select>
				</p>
	        </div>
	       
           </div>
	     {/if}
	     {if $physical_cards_available}
	     	<div class="gc-receptmode-option clearfix">
            <span class="custom-radio pull-xs-left">
              <input
                class="ps-shown-by-js"
                id="receptmode_post"
                name="receptmode"
                type="radio"
                value="2"
                {if !$virtual_cards_available}checked{/if}
              >
              <span></span>
            </span>
            <label for="receptmode_post">
              <span>{l s='Send by post' mod='giftcard'}</span>
            </label>
           </div>
	     {/if}
	</div>
	
	<div class="clearfix gc-actions">
          <button class="btn btn-primary" type="button"  disabled="disabled" data-rel-gcstep="gc-step-template">
              {l s='Continue' mod='giftcard'}
          </button>
    </div>
	
		
	
	</div>
	</section>
	{*** END STEP 1 RECEPTION MODE ***}
	{*** STEP 2 BLOCK SELECT TEMPLATE ***}
    <section  id= "gc-step-template" data-gcstep-enable="0" data-gcstep-valid="0">
    <h2 class="step-title">
	  <i class="icon-ta-check done"></i>
	  <span class="step-number">2</span>
	  {l s='Select a template' mod='giftcard'}
	  <span class="step-edit text-muted"><i class="icon-ta-pencil"></i> {l s='edit' mod='giftcard'}</span>
 	</h2>
 	<div class="gc-section-content">
	<div id="templates_block">
		<ul  class="gctabs clearfix">
			<li><a id="tab_template_all"  href="javascript:;" class="selected tab_template" data-tab="block_templates_all">{l s='All' mod='giftcard'}&nbsp;(<span class="ta-gc-number">{$templates|@count|intval}</span>)</a></li>										
			{if isset($gc_tags) && $gc_tags && $gc_tags|@count > 0}
				{foreach from=$gc_tags item=tag} 
					{if (isset($templatesGroupTag[$tag.id_gift_card_tag]) && $templatesGroupTag[$tag.id_gift_card_tag]|@count > 0)}
						<li>
							<a id="tab_template_tag{$tag.id_gift_card_tag|intval}" href="javascript:;"  data-tab="block_templates_in_tags{$tag.id_gift_card_tag|intval}"  class="tab_template">{$tag.name|escape:'htmlall':'UTF-8'}&nbsp;(<span class="ta-gc-number">{$templatesGroupTag[$tag.id_gift_card_tag]|@count}</span>)</a>
						</li>
					{/if}
				{/foreach}
			{/if}
		</ul>
		<div>
			{******* TAB CONTENT ALL TEMPLATES ******}
			<div id="block_templates_all" class="gctab_content selected">
				{if isset($templates) && count($templates) > 0}
				<div class="jcarousel-wrapper" id="jcarouselcardtemplates-all">
	                <div class="jcarousel" >
	                    <ul>
	                    	
								{foreach from=$templates item=template name=thumbnails}
			                        <li class="template_item template_item{$template.id_gift_card_template|intval} {if isset($template_default) && $template_default->id==$template.id_gift_card_template}selected{/if}"  data-physicaluse="{$template.physicaluse|intval}" data-virtualuse="{$template.virtualuse|intval}">
			                        		<a href="javascript:;"  class="link_template" rel="link_template{$template.id_gift_card_template|intval}">

			                        			
			                        			<img src="{$link->getMediaLink("`$giftcard_templates_dir``$template.id_gift_card_template`/`$template.id_gift_card_template`-front{if $template.issvg}-{$id_lang|intval}{/if}.jpg")|escape:'quotes':'UTF-8'}" alt="
			                        			{$template.name|escape:'htmlall':'UTF-8'}" title="{$template.name|escape:'htmlall':'UTF-8'}">
			                        			
			                        			
			                        		</a>
			                        		
			                        		<a href="{$link->getMediaLink("`$giftcard_templates_dir``$template.id_gift_card_template`/`$template.id_gift_card_template`-thickbox{if $template.issvg}-{$id_lang|intval}{/if}")|escape:'quotes':'UTF-8'}.jpg" data-fancybox-group="other-views" class="thickbox-giftcard shown" title="{$template.name|escape:'html':'UTF-8'}">	
			                        			<span class="zoom_link">{l s='View larger' mod='giftcard'}</span>
			                        		</a>
			                        		<span class="check"></span>
			                        </li>
			                	{/foreach}
		            	</ul>
	        		</div>
	       			<a href="#" class="jcarousel-control-prev">&lsaquo;</a>
	        		<a href="#" class="jcarousel-control-next">&rsaquo;</a>
	        		<div class="jcarousel-pagination-container">
						<p class="jcarousel-pagination"></p>
					</div>
	            </div>
            	{/if}
			</div>
			{******* END TAB CONTENT ALL TEMPLATES ******}
			{******* TAB CONTENT BY FILTER TAG ******}
			{if isset($gc_tags) && $gc_tags && $gc_tags|@count > 0}
				{foreach from=$gc_tags item=tag} 
					<div id="block_templates_in_tags{$tag.id_gift_card_tag|intval}" class="rte gctab_content">
					{if isset($templatesGroupTag[$tag.id_gift_card_tag]) && $templatesGroupTag[$tag.id_gift_card_tag]|@count > 0}
					<div class="jcarousel-wrapper" id="jcarouselcardtemplates-tag{$tag.id_gift_card_tag|intval}">
		                <div class="jcarousel" >
		                <ul>
		                			{foreach from=$templatesGroupTag[$tag.id_gift_card_tag] item=template}
			                        <li class="template_item template_item{$template.id_gift_card_template|intval} {if isset($template_default) && $template_default->id==$template.id_gift_card_template}selected{/if}"  data-physicaluse="{$template.physicaluse|intval}" data-virtualuse="{$template.virtualuse|intval}">

			                        		<a href="javascript:;"  class="link_template" rel="link_template{$template.id_gift_card_template|intval}">
			                        		
			                        		<img src="{$link->getMediaLink("`$giftcard_templates_dir``$template.id_gift_card_template`/`$template.id_gift_card_template`-front{if $template.issvg}-{$id_lang}{/if}.jpg")|escape:'quotes':'UTF-8'}" alt="
			                        			{$template.name|escape:'htmlall':'UTF-8'}" title="{$template.name|escape:'htmlall':'UTF-8'}">
			                        		</a>
			                        		
			                        		<a href="{$link->getMediaLink("`$giftcard_templates_dir``$template.id_gift_card_template`/`$template.id_gift_card_template`-thickbox{if $template.issvg}-{$id_lang|intval}{/if}")|escape:'quotes':'UTF-8'}.jpg" data-fancybox-group="other-views" class="thickbox-giftcard shown" title="{$template.name|escape:'html':'UTF-8'}">	
			                        			<span class="zoom_link">{l s='View larger' mod='giftcard'}</span>
			                        		</a>
			                        		<span class="check"></span>
			                        	
			                        </li>

			                		{/foreach}
				        </ul>
		        		</div>
		        		<a href="#" class="jcarousel-control-prev">&lsaquo;</a>
	        			<a href="#" class="jcarousel-control-next">&rsaquo;</a>
						<div class="jcarousel-pagination-container">
	        				<p class="jcarousel-pagination"></p>
						</div>
		        	</div>
					{/if}
					</div>
				{/foreach}
			{/if}
			{******* END TAB CONTENT BY FILTER TAG ******}
		</div>
	</div>
	<div class="clearfix gc-actions">
          <button class="btn btn-primary" type="button"  disabled="disabled" data-rel-gcstep="gc-step-information">
              {l s='Continue' mod='giftcard'}
          </button>
    </div>
	</div>
	</section>
	{*** END STEP 2 BLOCK SELECT TEMPLATE ***}
	{*** STEP 3 GIFT CARD INFORMATION ***}
	<section  id= "gc-step-information" data-gcstep-enable="0" data-gcstep-valid="0">
	
    <h2 class="step-title">
	  <i class="icon-ta-check done"></i>
	  <span class="step-number">3</span>
	  {l s='Gift card information' mod='giftcard'}
	  <span class="step-edit text-muted"><i class="icon-ta-pencil"></i> {l s='edit' mod='giftcard'}</span>
 	</h2>
 	<div class="gc-section-content">
	<input type="hidden" name="action" value="" />
	<input type="hidden" name="id_lang" value="{$id_lang|intval}" />
	<input type="hidden" name="token" value="{$token|escape:'html':'UTF-8'}" />
	<input type="hidden" name="id_gift_card_template" id="id_gift_card_template" value="{$template_default->id|intval}"/>
	<p> {l s='Amount' mod='giftcard'}&nbsp;
		<select name="id_product_virtual" id="ta_gc_products_virtual">
		{foreach from=$cards item=carditem name=foo}
			{if $carditem.virtualcard == 1}
	           	<option value="{$carditem.id_product|intval}" {if ((!isset($card)&&$carditem.isdefaultgiftcard) || (isset($card) && $card->id==$carditem.id_product))}selected{/if}>
	           	{$carditem.price_dp|escape:'htmlall':'UTF-8'}
	           	</option>
	        {/if}
        {/foreach}
       	</select>
	    <select name="id_product_physical" id="ta_gc_products_physical">
		{foreach from=$cards item=carditem name=foo}
			{if $carditem.virtualcard == 0}
	           	<option value="{$carditem.id_product|intval}" {if ((!isset($card)&&$carditem.isdefaultgiftcard) || (isset($card) && $card->id==$carditem.id_product))}selected{/if}>
	           	{$carditem.price_dp|escape:'htmlall':'UTF-8'}
	           	</option>
	        {/if}
        {/foreach}
       	</select>
		</p>
		<p class="from">
       		 <input name="from" type="text" class="input input_user_from" placeholder="{l s='From : your lastname' mod='giftcard'}"  />
     	 </p>
      	<p class="name">
       		 <input name="lastname" type="text" class="input input_user_to" placeholder="{l s='To : Lastname' mod='giftcard'}"  />
     	</p>
      <p class="text">
        <textarea name="message" class="input textarea_comment"  placeholder="{l s='Indicate your message' mod='giftcard'}" onkeyup="countChar(this)"></textarea>
        <div id="remaining characters">(<span id="charNum">200</span>&nbsp;{l s='remaining characters' mod='giftcard'})</div>
      </p>
      {*** BUTTON SUBMIT ***}
      <div class="row ta-gc-submit">
      	<div class="col-sm-6">
      	   <button class="btn pull-xs-left" type="button"  disabled="disabled"  data-ta-action="preview">
              {l s='Preview' mod='giftcard'}
          </button>
        </div>
        <div class="col-sm-6">
          <button class="btn btn-primary pull-xs-right" type="button"  disabled="disabled"  data-ta-action="add_to_cart">
              <i class="icon-ta-shopping-cart"></i>
              {l s='Add to cart' mod='giftcard'}
          </button>
        </div>
    </div>
	{*** END BUTTON SUBMIT ***}
	</div>
	</section>
	{*** END STEP 3 GIFT CARD INFORMATION ***}
	<br/>
	{* is use for display ajax messages errors, sucess*}
	<div class="messages"></div>
	
	</form>
	{/if}
</div>
{/block}

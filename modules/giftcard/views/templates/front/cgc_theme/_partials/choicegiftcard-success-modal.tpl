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
<div id="gc-success-modal" role="dialog">
	<div class="gcsm-header">
      <h4><i class="fa fa-gift">&nbsp;</i>{l s='Gift Card Successfully Added to Your Shopping Cart' mod='giftcard'}</h4>
    </div>
    <div class="gcsm-body">
    <div class="row">
      <div class="col-md-6 gcsmb-left">
      <div class="row">
      	<div class="col-md-6">
      		<img src="{$gc_upload_img|escape:'htmlall':'UTF-8'}" alt="I love you" title="I love you">
      	</div>
      	<div class="col-md-6">
			<p><strong>{l s='Price:' mod='giftcard'}</strong>&nbsp;{$gc_price|escape:'htmlall':'UTF-8'}</p>
            <p><strong>{l s='From:' mod='giftcard'}</strong>&nbsp;{$gc_from|escape:'htmlall':'UTF-8'}</p>
            <p><strong>{l s='To:' mod='giftcard'}</strong>&nbsp;{$gc_to|escape:'htmlall':'UTF-8'}</p><br>
        </div>
      </div>
      </div>
      <div class="col-md-6">
      		<div class="gcsm-cart-summary">
              {if $cart.products_count > 1}
                <p class="cart-products-count">{l s='There are %s items in your cart.' sprintf=[$cart.products_count] mod='giftcard'}</p>
              {else}
                <p class="cart-products-count">{l s='There is %s items in your cart.' sprintf=[$cart.products_count] mod='giftcard'}</p>
              {/if}
              <p><strong>{l s='Total products:' mod='giftcard'}</strong>&nbsp;{$cart.subtotals.products.value|escape:'htmlall':'UTF-8'}</p>
              <p><strong>{l s='Total shipping:' mod='giftcard'}</strong>&nbsp;{$cart.subtotals.shipping.value|escape:'htmlall':'UTF-8'} {hook h='displayCheckoutSubtotalDetails' subtotal=$cart.subtotals.shipping}</p>
              {if $cart.subtotals.tax}
              	<p><strong>{$cart.subtotals.tax.label|escape:'htmlall':'UTF-8'}</strong>&nbsp;{$cart.subtotals.tax.value|escape:'htmlall':'UTF-8'}</p>
              {/if}
              <p><strong>{l s='Total:' mod='giftcard'}</strong>&nbsp;{$cart.totals.total.value|escape:'htmlall':'UTF-8'} {$cart.labels.tax_short|escape:'htmlall':'UTF-8'}</p>
              <button type="button" class="btn btn-secondary" data-ta-action="dismiss">{l s='Continue shopping' mod='giftcard'}</button>
              <a href="{$cart_url|escape:'htmlall':'UTF-8'}" class="btn btn-primary"><i class="fa fa-check"> </i>{l s='proceed to checkout' mod='giftcard'}</a>
            </div>
      	</div>
    </div>
  </div>
</div>
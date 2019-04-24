{extends file='checkout/_partials/steps/checkout-step.tpl'}

{block name='step_content'}

  {hook h='displayPaymentTop'}

   <div id="show-orden">
          <div class="span btn-order-summary">
            <span class="text-resumen-cart"><i class="fa fa-shopping-bag" aria-hidden="true" style="margin-right:5px"></i> {l s='Show Order Summary' d='Shop.Theme.Checkout'}</span>
            <span>{$currency.iso_code}{$currency.sign}{$cart.totals.total.amount+$cart.subtotals.tax.amount}</span>      
          </div>
    
     <!-- Summary cart container -->
          <div id="order-summary-content" class="table_block table-responsive" style="padding:.8rem">
              <div class="cart-subtotals">
              {foreach from=$cart.subtotals item="subtotal"}
                {if isset($subtotal) && $subtotal}
                  <div class="cart-{$subtotal.type} d-flex flex-wrap justify-content-between">
                    {if $subtotal.type == 'discount'}
                    <span class="label">{$subtotal.label}</span>
                    <span class="value">-{$subtotal.value}</span>
                    {else}
                    <span class="label">{$subtotal.label}</span>
                    <span class="value">{$subtotal.value}</span>
                    {/if}
                    
                  </div>
                {/if}
                 <!--{if $subtotal.type == 'discount'}
                      {if $cart.vouchers.added == true}
                        <ul class="list-group mb-2 w-100">
                          {foreach from=$cart.vouchers.added item='voucher'}
                            <li class="list-group-item d-flex flex-wrap justify-content-between">
                              <span>{$voucher.name}({$voucher.reduction_formatted})</span><a data-link-action="remove-voucher" href="{$voucher.delete_url}" class="close" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                              </a>
                            </li>
                          {/foreach}
                        </ul>
                      {/if}
                    {/if}-->
              {/foreach}

            </div>
            <hr>
            <div class="cart-total d-flex flex-wrap justify-content-between my-3" style="margin-bottom:.3rem!important;">
              <!--<strong class="label">{$cart.totals.total.label}</strong>
              <strong class="value">{$cart.totals.total.value}</strong>
              <span>{$totals.total.value}</span>-->
              <strong><span class="label">{l s='Total (tax + shipping incl.)' d='Shop.Theme.Checkout'}</span></strong>
              <strong><span class="value">{$currency.iso_code}{$currency.sign}{$cart.totals.total.amount+$cart.subtotals.tax.amount}</span> </strong>
            </div>
            
          </div> 
    <!-- Final Summary cart container -->
 </div>
 <!-- Final Show Order -->

  <h2 class="Payment-method-title">{l s='Select your payment method' d='Shop.Theme.Checkout'}</h2>

  {if $is_free}
    <p>{l s='No payment needed for this order' d='Shop.Theme.Checkout'}</p>
  {/if}

      

  <div class="payment-options{if $is_free} d-none{/if}">
    <!-- ADD template voucher checkout visible before to payment -->
        {block name='cart_voucher'}
          {include file='checkout/_partials/cart-voucher.tpl'}
        {/block}
    <!--template voucher inclueded -->

    {foreach from=$payment_options item="module_options"}
      {foreach from=$module_options item="option"}
        

          {if $option.module_name == "paypal"}
            <div id="{$option.id}-container" class="paypal-option-payment payment-option clearfix custom-control custom-radio">
            {* This is the way an option should be selected when Javascript is enabled *}
            <input class="custom-control-input{if $option.binary} binary{/if}" id="{$option.id}" data-module-name="{$option.module_name}" name="payment-option" type="radio" required {if $selected_payment_option == $option.id || $is_free} checked {/if}>

             <label class="ps-shown-by-js custom-control-label" for="{$option.id}">
                {if $option.logo}
                  <img class="img-fluid" src="{$option.logo}">
                {/if}
                {$option.call_to_action_text}
                <i class="fa fa-hand-o-down" aria-hidden="true"></i>
              </label>
          {else}
          <div id="{$option.id}-container" class="payment-option clearfix custom-control custom-radio">
          {* This is the way an option should be selected when Javascript is enabled *}
            <input class="custom-control-input{if $option.binary} binary{/if}" id="{$option.id}" data-module-name="{$option.module_name}" name="payment-option" type="radio" required {if $selected_payment_option == $option.id || $is_free} checked {/if}>
               <label class="ps-shown-by-js custom-control-label" for="{$option.id}">
                  {if $option.logo}
                    <img class="img-fluid" src="{$option.logo}">
                  {/if}
                  {$option.call_to_action_text}
              </label>
          {/if}
         
          {* This is the way an option should be selected when Javascript is disabled *}
          <form method="GET" class="ps-hidden-by-js">
            {if $option.id === $selected_payment_option}
              {l s='Selected' d='Shop.Theme.Checkout'}
            {else}
              <button class="ps-hidden-by-js" type="submit" name="select_payment_option" value="{$option.id}">
                {l s='Choose' d='Shop.Theme.Actions'}
              </button>
            {/if}
          </form>

          <label class="ps-hidden-by-js" for="{$option.id}">
            <span>{$option.call_to_action_text}</span>
            {if $option.logo}
              <img src="{$option.logo}">
            {/if}
          </label>

        </div>
        {if $option.additionalInformation}
          <div id="{$option.id}-additional-information" class="js-additional-information definition-list additional-information{if $option.id != $selected_payment_option} ps-hidden {/if}">
            {$option.additionalInformation nofilter}
          </div>
        {/if}
        <div
                id="pay-with-{$option.id}-form"
                class="js-payment-option-form {if $option.id != $selected_payment_option} ps-hidden {/if}"
        >
          {if $option.form}
            {$option.form nofilter}
          {else}
            <form id="payment-form" method="POST" action="{$option.action nofilter}">
              {foreach from=$option.inputs item=input}
                <input type="{$input.type}" name="{$input.name}" value="{$input.value}">
              {/foreach}
              <button style="display:none" id="pay-with-{$option.id}" type="submit"></button>
            </form>
          {/if}
        </div>
      {/foreach}
      {foreachelse}
      <p class="alert alert-danger">{l s='Unfortunately, there are no payment method available.' d='Shop.Theme.Checkout'}</p>
    {/foreach}
  </div>
  {if $conditions_to_approve|count}
    <p class="ps-hidden-by-js">
      {* At the moment, we're not showing the checkboxes when JS is disabled
         because it makes ensuring they were checked very tricky and overcomplicates
         the template. Might change later.
      *}
      {l s='By confirming the order, you certify that you have read and agree with all of the conditions below:' d='Shop.Theme.Checkout'}
    </p>
    <form id="conditions-to-approve" method="GET">
      <ul>
        {foreach from=$conditions_to_approve item="condition" key="condition_name"}
          <li class="custom-control custom-checkbox">
            <input id="conditions_to_approve[{$condition_name}]" name="conditions_to_approve[{$condition_name}]" required type="checkbox" value="1" class="custom-control-input ps-shown-by-js">
            <label class="js-terms custom-control-label" for="conditions_to_approve[{$condition_name}]">{$condition nofilter}</label>
          </li>
        {/foreach}
      </ul>
    </form>
  {/if}

  {if $show_final_summary}
    {include file='checkout/_partials/order-final-summary.tpl'}
  {/if}
  <div id="payment-confirmation">
    <div class="ps-shown-by-js">
      <button type="submit" {if ($cart.vouchers.added != true && $cart.totals.total.amount+$cart.subtotals.tax.amount == 0)|| $selected_payment_option != false} disabled {/if} class="btn btn-primary btn-sm">
       
        {l s='Order with an obligation to pay' d='Shop.Theme.Checkout'}
      </button>
      {if $show_final_summary}
        <article class="alert alert-danger mt-2 js-alert-payment-conditions" role="alert" data-alert="danger">
          {l
          s='Please make sure you\'ve chosen a [1]payment method[/1] and accepted the [2]terms and conditions[/2].'
          sprintf=[
          '[1]' => '<a href="#checkout-payment-step">',
          '[/1]' => '</a>',
          '[2]' => '<a href="#conditions-to-approve">',
          '[/2]' => '</a>'
          ]
          d='Shop.Theme.Checkout'
          }
        </article>
      {/if}
    </div>
    <div class="ps-hidden-by-js">
      {if $selected_payment_option and $all_conditions_approved}
        <label for="pay-with-{$selected_payment_option}">{l s='Order with an obligation to pay' d='Shop.Theme.Checkout'}</label>
      {/if}
    </div>
  </div>
  {hook h='displayPaymentByBinaries'}

  <div id="modal" class="modal fade modal-close-inside">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close" aria-hidden="true"></button>
        <div class="modal-body js-modal-content"></div>
      </div>
    </div>
  </div>
{/block}

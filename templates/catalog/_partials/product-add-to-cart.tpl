{**
 * 2007-2017 PrestaShop
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License 3.0 (AFL-3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * https://opensource.org/licenses/AFL-3.0
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@prestashop.com so we can send you a copy immediately.
 *
 * DISCLAIMER
 *
 * Do not edit or add to this file if you wish to upgrade PrestaShop to newer
 * versions in the future. If you wish to customize PrestaShop for your
 * needs please refer to http://www.prestashop.com for more information.
 *
 * @author    PrestaShop SA <contact@prestashop.com>
 * @copyright 2007-2017 PrestaShop SA
 * @license   https://opensource.org/licenses/AFL-3.0 Academic Free License 3.0 (AFL-3.0)
 * International Registered Trademark & Property of PrestaShop SA
 *}
<div class="product-add-to-cart">
  {if !$configuration.is_catalog}

    {block name='product_quantity'}
      {if $shop.name == $azaimayoreo && $customer.is_logged != NULL}

          <table id="table_qty" class="table" style="margin-top:1rem;max-width:400px;text-align:center;">
                
                  <tr style="background-color:black; color:white; text-align:center">
                    <td scrop="col">{l s='Color' d='Shop.Theme.Actions'}</td>
                    <td scope="col" style="cuento">
                    {if ($customer.id_default_group == 12 or $customer.id_default_group == 13) and $shop.name == $azaimayoreo}
                            {l s='QTY' d='Shop.Theme.Actions'}</td>
                      {else}
                            <span>{l s='Pack' d='Shop.Theme.Actions'}</span></td>
                      {/if} 
                    
                          {if ($product.category == 'bags') or ($product.category == 'necklaces') or ($product.category == 'jewelry-necklaces') or ($product.category == 'earrings') or ($product.category == 'jewelry-earrings') or ($product.category == 'bracelets') or ($product.category == 'jewelry-bracelets') or ($product.category == 'hats') or ($product.category == 'brooches') or ($product.category == 'clutches-crossbody-bags') or ($product.category == 'jewelry') or
                          ($product.category == 'rings') or ($product.category == 'jewelry-rings') or
                          ($product.category == 'accessories')}
                            
                            
                    <td scope="col">{l s='TotalQty' d='Shop.Theme.Actions'}</b></td>
                            
                    {else}
                      <td scope="col">
                            {l s='TotalQty' d='Shop.Theme.Actions'}
                             {if ($customer.id_default_group == 12 or $customer.id_default_group == 13) and $shop.name == $azaimayoreo}
                             <!--do nothing-->
                             {else}
                            <br /><b>{l s='S-M-L' d='Shop.Theme.Actions'} ({$packageAzai/3}-{$packageAzai/3}-{$packageAzai/3})</b>
                            {/if}
                      </td>
                    {/if}

                    <td scope="col">
                      {if ($customer.id_default_group == 12 or $customer.id_default_group == 13) and $shop.name == $azaimayoreo}
                         <!--do nothing-->
                         {else}
                         <span>{l s='Pack' d='Shop.Theme.Actions'}</span>
                       {/if} {l s='Price' d='Shop.Theme.Actions'}</td>
                  </tr>
                
                </tbody>
                  <tr>
                   
                    <td><div id="backColor" style="width:2rem; height:2rem;border-radius:50%;background-color:black;margin-left:auto;margin-right:auto;"></div></td>

                            {if $customer.id_default_group == 11}
                                  <!-- FOR CUSTOMER - WHOLESALER - AZAMAYOREO-->
                                    {if $packBehavior == "quote"}
                                          <td style="padding-left:0px;padding-right:0px;padding-top:5px;text-align:center;">
                                              <div class="product-quantity d-flex flex-wrap align-content-center">
                                                <div class="qty mb-1 mr-3" style="margin-right:auto!important;margin-left:auto;">
                                
                                                  <input
                                                    type="text"
                                                    name="qty"
                                                    step={$packageAzaiStep}
                                                    min={$packageAzaiStep}
                                                    max="100"
                                                    data-pack="{$packageAzai}"
                                                    id="quantity_wanted"
                                                    value="{$product.quantity_wanted}"
                                                    class="input-group input-group-lg"
                                                    min="{$product.minimal_quantity}"
                                                    aria-label="{l s='Quantity' d='Shop.Theme.Actions'}"
                                                    style="max-width:70px;color:black;height:47px;padding:10px;min-width:55px;font-size:1rem;"
                                                  >
                                                  </div>
                                              </div>
                                         </td>
                                         <td id="table_qty_qty">{$packageAzai}</td>
                                    {else}
                                         <td id="table_qty_qty">1</td>
                                          <td {if $packBehavior == 'sale'}class="sales"{/if} style="padding-left:0px;padding-right:0px;padding-top:5px;text-align:center;">
                                              <div class="product-quantity d-flex flex-wrap align-content-center">
                                                <div class="qty mb-1 mr-3" style="margin-right:auto!important;margin-left:auto;">
                                
                                                  <input
                                                    type="text"
                                                    name="qty"
                                                    step={$packageAzaiStep}
                                                    min={$packageAzaiStep}
                                                    max="100"
                                                    data-pack="{$packageAzai}"
                                                    id="quantity_wanted"
                                                    value="{$product.quantity_wanted}"
                                                    class="input-group input-group-lg"
                                                    min="{$product.minimal_quantity}"
                                                    aria-label="{l s='Quantity' d='Shop.Theme.Actions'}"
                                                    style="max-width:70px;color:black;height:47px;padding:10px;min-width:55px;font-size:1rem;"
                                                  >
                                                  </div>
                                              </div>
                                         </td>
                                    {/if}
                            {else}
                                   <!-- FOR VIP CUSTOMER - AZAMAYOREO-->
                                        <td style="padding-left:0px;padding-right:0px;padding-top:5px;text-align:center;">
                                            <div class="product-quantity d-flex flex-wrap align-content-center">
                                              <div class="qty mb-1 mr-3" style="margin-right:auto!important;margin-left:auto;">
                                                     <input
                                                    type="text"
                                                    name="qty"
                                                    step="{$packageAzaiStep}"
                                                    min="{$packageAzaiStep}"
                                                    max="100"
                                                    data-pack="{$packageAzai}"
                                                    id="quantity_wanted"
                                                    value="{$product.quantity_wanted}"
                                                    class="input-group input-group-lg"
                                                    min="{$product.minimal_quantity}"
                                                    aria-label="{l s='Quantity' d='Shop.Theme.Actions'}"
                                                    style="max-width:70px;color:black;height:47px;padding:10px;min-width:55px;font-size:1rem;"
                                                    >
                                             </div>
                                    </div>
                                </td>
                                <td id="table_qty_qty">1</td>
                            {/if}
                      
                   <td>
                    <div id="product-price-quantity" data-price="{$product.price_amount}">{$currency.iso_code}{$currency.sign} <span class="product-amount">{($product.price_amount*$packageAzai)|number_format:2:".":","}</span></div>
                  </td>
                </tr>
              </tbody>
          </table>
        {else}
              <div class="product-quantity d-flex flex-wrap align-content-center">
                    <div class="qty mb-1 mr-3">
                      <input
                        type="text"
                        name="qty"
                        step="1"
                        id="quantity_wanted"
                        value="{$product.quantity_wanted}"
                        class="input-group input-group-lg"
                        min="{$product.minimal_quantity}"
                        aria-label="{l s='Quantity' d='Shop.Theme.Actions'}"
                      >
                    </div>
              </div>
        {/if}

         {if $packBehavior == "quote"}
                {if ($shop.name != $azaimayoreo) or ($shop.name == $azaimayoreo && ($customer.id_default_group == 12 or $customer.id_default_group == 13))}
                    <div class="add mb-1">
                      
                      <button
                        id="box-cart-btn"
                        class="btn btn-md btn-primary add-to-cart"
                        data-button-action="add-to-cart"
                        type="submit"
                        {if !$product.add_to_cart_url}
                          disabled
                        {/if}
                      >  
                    {$in_cart = 0}
                    {foreach from=$cart['products'] item='cart_product' }
                      {if $cart_product['id_product'] == $product.id}
                        {$in_cart = 1}
                      {/if}
                    {/foreach}
                    
                      {if $in_cart}
                      {l s='Already in cart' d='Shop.Theme.Actions'}
                      {else}
                      {l s='Add to cart' d='Shop.Theme.Actions'}
                      {/if}
                      </button>
                    </div>

                {/if}

         {else}
                {if ($shop.name != $azaimayoreo) or ($shop.name == $azaimayoreo && ($customer.id_default_group == 11 or $customer.id_default_group == 12 or $customer.id_default_group == 13))}
                    <div class="add mb-1">
                      
                      <button
                        id="box-cart-btn"
                        class="btn btn-md btn-primary add-to-cart"
                        data-button-action="add-to-cart"
                        type="submit"
                        {if !$product.add_to_cart_url}
                          disabled
                        {/if}
                      >  
                    {$in_cart = 0}
                    {foreach from=$cart['products'] item='cart_product' }
                      {if $cart_product['id_product'] == $product.id}
                        {$in_cart = 1}
                      {/if}
                    {/foreach}
                    
                      {if $in_cart}
                      {l s='Already in cart' d='Shop.Theme.Actions'}
                      {else}
                      {l s='Add to cart' d='Shop.Theme.Actions'}
                      {/if}
                      </button>
                    </div>

                {/if}

         {/if}
        
        
    {/block}
    
    {block name='product_availability'}
      <span id="product-availability">
        {if $product.show_availability && $product.availability_message}
          {if $product.availability == 'available'}
            <i class="material-icons rtl-no-flip product-available">&#xE5CA;</i>
          {elseif $product.availability == 'last_remaining_items'}
            <i class="material-icons product-last-items">&#xE002;</i>
          {else}
            <i class="material-icons product-unavailable">&#xE14B;</i>
          {/if}
          {$product.availability_message}
        {/if}
      </span>
    {/block}
    
    {block name='product_minimal_quantity'}
      <p class="product-minimal-quantity">
        {if $product.minimal_quantity > 1}
          {l
          s='The minimum purchase order quantity for the product is %quantity%.'
          d='Shop.Theme.Checkout'
          sprintf=['%quantity%' => $product.minimal_quantity]
          }
        {/if}
      </p>
    {/block}
  {/if}
</div>

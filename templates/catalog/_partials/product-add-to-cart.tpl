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
              <td scrop="col">Color</td>
              <td scope="col" style="cuento">Pack QTY</td>

              {if ($product.category == 'bags') or ($product.category == 'necklaces') or ($product.category == 'jewelry-necklaces') or ($product.category == 'earrings') or ($product.category == 'jewelry-earrings') or ($product.category == 'bracelets') or ($product.category == 'jewelry-bracelets') or ($product.category == 'hats') or ($product.category == 'brooches') or ($product.category == 'clutches-crossbody-bags') or
              ($product.category == 'jewelry') or
              ($product.category == 'rings') or ($product.category == 'jewelry-rings')}
                <td scope="col">TotalQty</b></td>
              {else}
                <td scope="col">TotalQty<br /><b>S-M-L (3-3-3)</b></td>
              {/if}

              <td scope="col">Pack Price</td>
            </tr>
          
          </tbody>
            <tr>
              <td><div id="backColor" style="width:2rem; height:2rem;border-radius:50%;background-color:black;margin-left:auto;margin-right:auto;"></div></td>
              <td style="padding-left:0px;padding-right:0px;padding-top:5px;text-align:center;">
                  <div class="product-quantity d-flex flex-wrap align-content-center">
                    <div class="qty mb-1 mr-3" style="margin-right:auto!important;margin-left:auto;">
                      <input
                        type="text"
                        name="qty"
                        step="1"
                        min="1"
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
        {if $shop.name != $azaimayoreo}
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
      </div>{/if}
        
    {/block}
    
    {block name='product_minimal_quantity'}
      {if $product.minimal_quantity > 1}
        <p class="product-minimal-quantity required">
          {l
          s='The minimum purchase order quantity for the product is %quantity%.'
          d='Shop.Theme.Checkout'
          sprintf=['%quantity%' => $product.minimal_quantity]
          }
        </p>
      {/if}
    {/block}
  {/if}
</div>

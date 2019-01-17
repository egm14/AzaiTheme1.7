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
      <div class="product-quantity d-flex flex-wrap align-content-center">
        <div class="qty mb-1 mr-3">
          <input
            type="text"
            name="qty"
            id="quantity_wanted"
            value="{$product.quantity_wanted}"
            class="input-group input-group-lg"
            min="{$product.minimal_quantity}"
            aria-label="{l s='Quantity' d='Shop.Theme.Actions'}"
          >
        </div>
      </div>
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
          {l s='Add to cart' d='Shop.Theme.Actions'}
        </button>
      </div>
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

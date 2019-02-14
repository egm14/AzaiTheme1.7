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
{block name='address_selector_blocks'}
  {foreach $addresses as $address}
    <article
      class="address-item{if $address.id == $selected} selected{/if}"
      id="{$name|classname}-address-{$address.id}"
    >
    <label class="radio-block">
      <header class="address-header">
        
          <div class="custom-control custom-radio">
            <label>
              <input class="custom-control-input" type="radio" name="{$name}" value="{$address.id}" {if $address.id == $selected}checked{/if}>
              <span class="custom-control-label">
                <span class="address-alias h6">{$address.alias}</span>
                <div class="address">{$address.formatted nofilter}</div>
              </span>

              {*<span class="custom-control-description">*}
                {*<span class="custom-control-label">*}
                  {*<span class="address-alias h6">{$address.alias}</span>*}
                  {*<div class="address">{$address.formatted nofilter}</div>*}
                {*</span>*}
            </span>
            </label>
          </div>
        </header>
      </label>
      <hr>
      <footer class="address-footer">
        {if $interactive}
          <a
            class="edit-address btn-link"
            data-link-action="edit-address"
            href="{url entity='order' params=['id_address' => $address.id, 'editAddress' => $type, 'token' => $token]}"
          >
            <i class="fa fa-pencil-square mr-1" aria-hidden="true"></i>{l s='Edit' d='Shop.Theme.Actions'}
          </a><br />
          <a
            class="delete-address btn-link"
            data-link-action="delete-address"
            href="{url entity='order' params=['id_address' => $address.id, 'deleteAddress' => true, 'token' => $token]}"
          >
            <i class="fa fa-trash-o mr-1" aria-hidden="true"></i>{l s='Delete' d='Shop.Theme.Actions'}
          </a>
        {/if}
      </footer>
    </article>
  {/foreach}
    <article
      class="address-item{if $address.id == $selected} selected{/if}"
      id="{$name|classname}-address-{$address.id}"
    >
    <label class="radio-block">
      
        <a class="btn-link btn-link-primary icon-left" style="padding-left:0;" href="{$new_address_delivery_url}">
          <header class="address-header" style="display:flex;align-items:center;">
          <div class="custom-control custom-radio">
            
              <input class="custom-control-input" type="radio" name="{$name}" value="{$address.id}" {if $address.id == $selected}checked{/if}>
              <span class="custom-control-label add-new-address">
                <span class="address-alias h6">{*$address.alias*}</span>
                <div class="address"><p class="add-address"><i class="material-icons-add_box"></i>{l s='add new address' d='Shop.Theme.Actions'}</p>
                {*$address.formatted nofilter*}</div>
              </span>
            </label>
          </div>
          </header>
      <hr>
      <footer class="address-footer">
        {if $interactive}
          <!--<a
            class="edit-address btn-link"
            data-link-action="edit-address"
            href="{url entity='order' params=['id_address' => $address.id, 'editAddress' => $type, 'token' => $token]}"
          >
            <i class="fa fa-pencil-square mr-1" aria-hidden="true"></i>{l s='Edit' d='Shop.Theme.Actions'}
          </a>
          <a
            class="delete-address btn-link"
            data-link-action="delete-address"
            href="{url entity='order' params=['id_address' => $address.id, 'deleteAddress' => true, 'token' => $token]}"
          >
            <i class="fa fa-trash-o mr-1" aria-hidden="true"></i>{l s='Delete' d='Shop.Theme.Actions'}
          </a>-->
          {l s='Click in the box to create new addres'}
        {/if}
      </footer>
      </a>
    </article>
  {if $interactive}
    <p>
      <button class="ps-hidden-by-js form-control-submit center-block" type="submit">{l s='Save' d='Shop.Theme.Actions'}</button>
    </p>
  {/if}
{/block}

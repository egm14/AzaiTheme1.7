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
{extends file='checkout/_partials/steps/checkout-step.tpl'}



{block name='step_content'}

<!-- Alert to Dominican Republic customer - buy over $200.o0 -->

    {if $cart.totals.total.value >= '$200' && ($customer.addresses[$cart.id_address_delivery].country == 'Dominican Republic' || $customer.addresses[$cart.id_address_delivery].country == 'República Dominicana')}
        <div class="notification alert alert-warning mobil" style="margin-bottom:2rem;">
          <h3 style="color:white;margin-left:.4rem;margin-bottom:0px;text-decoration:underline;">{l s='Cargos aduanales República Dominicana' d='Shop.Theme.Checkout'}</h3>
         <p style="padding-left:.4rem">{l s="Se aplicarán cargos aduanales en compras mayores a "}<span style="text-decoration:underline;color:black">{l s="USD$200.00. "}</span>{l s='Para mayor información marcar o escribenos a: ' d='Shop.Theme.Checkout'}<a href="phone:+1-809-705-8665">{l s="+1(809)705-8665"}</a> | <a href="mailto:autorizaciones@azai.com.com?subject=Compras%20RD%20mayor%20a%20USD$200">{l s="autorizaciones@azai.com" d='Shop.Theme.Checkout'}</a>
        </div>
    {/if}

  <div id="hook-display-before-carrier">
    {$hookDisplayBeforeCarrier nofilter}
  </div>

  <div title="{l s='Seleccione su metodo de envio' d='Shop.Theme.Actions'}" class="delivery-options-list">
    {if $delivery_options|count}
      <form
        class="clearfix"
        id="js-delivery"
        data-url-update="{url entity='order' params=['ajax' => 1, 'action' => 'selectDeliveryOption']}"
        method="post"
      >
        <div class="form-fields mb-3">
          {block name='delivery_options'}
            <div class="delivery-options">
              {foreach from=$delivery_options item=carrier key=carrier_id}
              <div class="delivery-option-item">
                <label class="custom-control custom-radio">
                  <!--<div class="col-1">-->
                          <input class="custom-control-input" type="radio" name="delivery_option[{$id_address}]" id="delivery_option_{$carrier.id}" value="{$carrier_id}"{if $delivery_option == $carrier_id} checked{/if}>
                          <span class="custom-control-label"><a class="custtom-test-shiping">{l s='Seleccionar este metodo de envio' d='Shop.Theme.Actions'}</a></span>
                      <!--</div>-->
                    <div class="row delivery-option">
                      
                      <label for="delivery_option_{$carrier.id}" class="col-11 delivery-option-2" >
                        <div class="row">
                          <div class="col-sm-5">
                            <div class="row">
                              {if $carrier.logo}
                              <div class="col-3">
                                  <img class="img-fluid" src="{$carrier.logo}" alt="{$carrier.name}" />
                              </div>
                              {/if}
                              <div class="{if $carrier.logo}col-9{else}col-12{/if}">
                                <span class="h6 carrier-name">{$carrier.name}</span>
                              </div>
                            </div>
                          </div>
                          <div class="col-sm-4">
                            {if $shop.name == $azaimayoreo}
                               <!-- Exception to dominican REpublica Carrier -->
                              {if $carrier.url != "https://azai.com"}
                                <img class="imgInternationCarrier" src="{$urls.theme_assets}OtherFile/internationalCarriers.png" style="max-height:30px;display:block;text-align:center;margin:10px auto"/>
                              {/if}
                                <span class="carrier-delay">{$carrier.delay}</span>
                                 </div>
                                <div class="col-sm-3" style="font-weight:600;">
                                  <span class="carrier-price">{$carrier.price}</span>
                                </div>

                            {else}
                                <!-- Exception to dominican REpublica Carrier -->
                              {if ($customer.addresses[$cart.id_address_delivery].country == 'Dominican Republic' || $customer.addresses[$cart.id_address_delivery].country == 'República Dominicana')}
                                <br />
                                  <ol style="list-style:disc;padding-left:10px;text-align:left;">
                                  <li style="margin-bottom:.4rem">{l s='Delivery time:' d='Shop.Theme.Checkout'}&nbsp;{$carrier.delay}&nbsp;</li>
                                  <!--<li style="margin-bottom:.4rem">{l s='Le enviaremos un correo eléctrico con las instrucciones y el número de identificación de su pedido, el cual le permitirá dar seguimiento a su paquete (Traking number).'}</li>-->
                                  <li>{l s='Al momento de la entrega del paquete  lo estaremos contactando a travez de su número de teléfono. Así garantizamos una entrega satisfactoria.' d='Shop.Theme.Checkout'}</li>
                                </ol>
                                 </div>
                                <div class="col-sm-3" style="font-weight:600;">
                                  <span class="carrier-price">{$carrier.price}</span><i style="margin-left:5px" class="fa fa-hand-peace-o" aria-hidden="true"></i>

                                </div>
                              {else}
                                <span class="carrier-delay">{$carrier.delay}</span>
                                 </div>
                                <div class="col-sm-3" style="font-weight:600;">
                                  <span class="carrier-price">{$carrier.price}</span>
                                </div>
                              {/if}

                            {/if}
                            
                        </div>
                      </label>
                      
                    </label>
                  </div>
                  <div class="row carrier-extra-content"{if $delivery_option != $carrier_id} style="display:none;"{/if}>
                    {$carrier.extraContent nofilter}
                  </div>
                </div>
                <div class="clearfix"></div>
                <hr>
              {/foreach}
            </div>
          {/block}

          <div class="order-options">
            {if ($customer.addresses[$cart.id_address_delivery].country)}
              <!-- Lightbox Timer_Map -->
                <span class="zone_map" data-toggle="modal" data-target="#maptime_modal"><a class="sizes-chart" href="#maptime_modal" style="background-color:black;text-decoration:underline!important; color:white; text-align:right; padding:5px 10px!important; text-decoration:none; border-radius:10px;">{l s='Consult transit time' d='Shop.Theme.Checkout'}</a></span>
                
              

                <!-- Modal -->
                <div class="modal fade" id="maptime_modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true" >
                  <div class="modal-dialog modal-dialog-centered" role="document" >
                    <div class="modal-content" style="max-height:700px; max-width:500px;margin-left:auto;margin-right:auto;display:block;">
                        <!-- Close btn -->
                        <button type="button" class="btn close-modal" data-dismiss="modal">X</button>
                        <img style="width:inherit;" src="{$urls.theme_assets}OtherFile/ups_map.jpg" />
                    </div>
                  </div>
                </div>

              
            {/if}
            <div id="delivery" style="margin-top:.7rem">
              <label for="delivery_message">{l s='If you would like to add a comment about your order, please write it in the field below.' d='Shop.Theme.Checkout'}</label>
              <textarea class="form-control" rows="2" cols="120" id="delivery_message" name="delivery_message">{$delivery_message}</textarea>
            </div>

            {if $recyclablePackAllowed}
              <span class="custom-checkbox">
                <input type="checkbox" id="input_recyclable" name="recyclable" value="1" {if $recyclable} checked {/if}>
                <span><i class="fa fa-check rtl-no-flip checkbox-checked" aria-hidden="true"></i></span>
                <label for="input_recyclable">{l s='I would like to receive my order in recycled packaging.' d='Shop.Theme.Checkout'}</label>
              </span>
            {/if}

            {if $gift.allowed}
              <span class="custom-checkbox">
                <input class="js-gift-checkbox" id="input_gift" name="gift" type="checkbox" value="1" {if $gift.isGift}checked="checked"{/if}>
                <span><i class="fa fa-check rtl-no-flip checkbox-checked" aria-hidden="true"></i></span>
                <label for="input_gift">{$gift.label}</label >
              </span>

              <div id="gift" class="collapse{if $gift.isGift} in{/if}">
                <label for="gift_message">{l s='If you\'d like, you can add a note to the gift:' d='Shop.Theme.Checkout'}</label>
                <textarea rows="2" cols="120" id="gift_message" name="gift_message">{$gift.message}</textarea>
              </div>
            {/if}

          </div>
        </div>
        <button type="submit" class="continue btn btn-primary btn-sm float-right" name="confirmDeliveryOption" value="1">
          {l s='Continue' d='Shop.Theme.Actions'}
        </button>
      </form>
    {else}
      <p class="alert alert-danger">{l s='Unfortunately, there are no carriers available for your delivery address.' d='Shop.Theme.Checkout'}</p>
    {/if}
  </div>

  <div id="hook-display-after-carrier">
    {$hookDisplayAfterCarrier nofilter}
  </div>

  <div id="extra_carrier"></div>
{/block}

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

<div class="form-horizontal well">

    <div class="form-group">
        <label class="control-label col-lg-3">
            {l s='Charge Type' mod='roja45quotationspro'}
        </label>
        <div class="col-lg-9">
            <select class="form-control" name="charge_type" id="charge_type">
                <option value="general">{l s='General' mod='roja45quotationspro'}</option>
                <option value="shipping">{l s='Shipping' mod='roja45quotationspro'}</option>
                <option value="handling">{l s='Handling' mod='roja45quotationspro'}</option>
            </select>
        </div>
    </div>
    <div class="form-group" id="charge-name-block" style="display:none;">
        <label class="control-label col-lg-3">
            {l s='Name' mod='roja45quotationspro'}
        </label>
        <div class="col-lg-9">
            <input class="form-control" type="text" name="charge_name" id="charge_name" value=""/>
        </div>
    </div>

    <div class="form-group" id="carriers-block" style="display:none;">
        <label class="control-label col-lg-3">
            {l s='Carriers' mod='roja45quotationspro'}
        </label>
        <div class="col-lg-9">
            <select class="form-control" name="carriers" id="carriers">
                <option value="0">{l s='Select a carrier' mod='roja45quotationspro'}</option>
                {foreach $carriers as $carrier}
                    <option value="{$carrier['carrier']->id|escape:"html":"UTF-8"}"
                            data-name="{$carrier['carrier']->name|escape:"html":"UTF-8"}"
                            data-rate="{$carrier['shipping']|escape:"html":"UTF-8"}"
                            data-rate-formatted="{displayPrice price=Tools::ps_round(Tools::convertPrice($carrier['shipping'], $currency), 2) currency=$currency->id}">{$carrier['carrier']->name|escape:"html":"UTF-8"}</option>
                {/foreach}
            </select>
        </div>
    </div>

    <div class="form-group" id="charge-method-block" style="display:none;">
        <label class="control-label col-lg-3">
            {l s='Charge Method' mod='roja45quotationspro'}
        </label>
        <div class="col-lg-9">
            <select class="form-control" name="charge_method" id="charge_method">
                <option value="1">{l s='Percent' mod='roja45quotationspro'}</option>
                <option value="2">{l s='Amount' mod='roja45quotationspro'}</option>
            </select>
        </div>
    </div>

    <div class="form-group" id="available-taxes-block" style="display:none;">
        <label class="control-label col-lg-3">
            {l s='Charge Method' mod='roja45quotationspro'}
        </label>
        <div class="col-lg-9">
            <select class="form-control" name="tax_id" id="tax_id">
                <option value="1">{l s='Tax 1' mod='roja45quotationspro'}</option>
                <option value="2">{l s='Tax 2' mod='roja45quotationspro'}</option>
            </select>
        </div>
    </div>
    <div id="charge_value_field" class="form-group">
        <label class="control-label col-lg-3">
            {l s='Value (exc.)' mod='roja45quotationspro'}
        </label>
        <div class="col-lg-9">
            <div class="input-group">
                <div class="input-group-addon">
                    <span id="charge_currency_sign" style="display: none;">{$currency->sign|escape:"html":"UTF-8"}</span>
                    <span id="charge_percent_symbol">%</span>
                </div>
                <input id="charge_value" class="form-control" type="text" name="charge_value"/>
            </div>
        </div>
    </div>
    <p id="handling_warning" class="alert alert-warning" style="display:none;">{l s='You have configured this module to include handling and the carrier is configured to include handling, this should be disable to avoid an incorrect value being recorded.' mod='roja45quotationspro'}</p>
    <p id="charges_warning" class="alert alert-warning" style="display:none;">{l s='Handling and General charges are advisory to the customer only, they will not be included in a cart order.  See the documentation for more details.' mod='roja45quotationspro'}</p>
    <div class="row">
        <div class="col-lg-9 col-lg-offset-3">
            <button class="btn btn-default" type="button" id="cancel_add_charge">
                <i class="icon-remove text-danger"></i>
                {l s='Cancel' mod='roja45quotationspro'}
            </button>
            <button class="btn btn-default submit-new-charge" type="submit" name="submitNewCharge">
                <i class="icon-ok text-success"></i>
                {l s='Add' mod='roja45quotationspro'}
            </button>
        </div>
    </div>
</div>
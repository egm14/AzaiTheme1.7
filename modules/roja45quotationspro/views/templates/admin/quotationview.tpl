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
*  @license          /license.txtr
*}

<div id="container-quotations">
    <div class="leadin"></div>
    {if !$quotation->is_template}
    <div class="panel kpi-container">
        <div class="row">
            <div class="col-xs-6 col-sm-2 box-stats color3">
                <div class="kpi-content">
                    <i class="icon-calendar-empty"></i>
                    <span class="title">{l s='Received' mod='roja45quotationspro'}</span>
                    <span class="value">{if isset($quotation->date_add)}{dateFormat date=$quotation->date_add full=false}{/if}</span>
                </div>
            </div>
            {if $quotation->purchase_date}
                <div class="col-xs-6 col-sm-2 box-stats color3">
                    <div class="kpi-content">
                        <i class="icon-calendar-empty"></i>
                        <span class="title">{l s='Ordered On' mod='roja45quotationspro'}</span>
                        <span class="value">{if isset($quotation)}{dateFormat date=$quotation->purchase_date full=false}{/if}</span>
                    </div>
                </div>
                <div class="col-xs-6 col-sm-2 box-stats color4">
                    <div class="kpi-content">
                        <i class="icon-money"></i>
                        <span class="title">{l s='Order Total' mod='roja45quotationspro'}</span>
                        <span class="value">{if isset($total_paid)}{displayPrice price=$total_paid currency=$currency->id}{/if}</span>
                    </div>
                </div>
            {else}
                <div class="col-xs-6 col-sm-2 box-stats color4">
                    <div class="kpi-content">
                        <i class="icon-money"></i>
                        <span class="title">{l s='Quotation Total' mod='roja45quotationspro'}</span>
                        <span class="value">{if isset($quotation)}{displayPrice price=Tools::ps_round(Tools::convertPrice($total_price, $currency), 2) currency=$currency->id}{/if}</span>
                    </div>
                </div>
            {/if}

            <div class="col-xs-6 col-sm-2 box-stats color2">
                <div class="kpi-content">
                    <i class="icon-comments"></i>
                    <span class="title">{l s='Messages' mod='roja45quotationspro'}</span>
                    <span class="value">{$messages|count}</span>
                </div>
            </div>
            <div class="col-xs-6 col-sm-2 box-stats color1">
                <a href="#roja45quotation_form">
                    <div class="kpi-content">
                        <i class="icon-book"></i>
                        <span class="title">{l s='Products' mod='roja45quotationspro'}</span>
                        <span class="value">{$requested_products|count}</span>
                    </div>
                </a>
            </div>
            <div class="col-xs-6 col-sm-2 box-stats color3">
                <div class="kpi-content">
                    <i class="icon-calendar-empty"></i>
                    <span class="title">{l s='Last Update' mod='roja45quotationspro'}</span>
                    <span class="value">{if isset($quotation->date_upd)}{$quotation->date_upd|escape:"html":"UTF-8"}{/if}</span>
                </div>
            </div>
        </div>
    </div>
    {/if}
    <div class="row">
        <div class="col-lg-7">
            <div class="panel clearfix">
                <div class="panel-heading">
                    <span {if $deleted}style="color: grey !important;font-style:italic !important;"{/if}>
                    <i class="icon-inbox"></i>
                        {if !$quotation->is_template}
                        {l s='Quote' mod='roja45quotationspro'}
                        {if isset($quotation->reference)}<span
                                class="badge">{$quotation->reference|escape:"html":"UTF-8"}</span>{/if}
                        {if $deleted}
                            - {l s='(DELETED)' mod='roja45quotationspro'}
                        {/if}
                        {else}
                        {l s='Template' mod='roja45quotationspro'}<span class="badge">{$quotation->template_name|escape:"html":"UTF-8"}</span>
                        {/if}
                    </span>
                    <span id="current_status" style="background-color:{$status->color|escape:'html':'UTF-8'};" class="badge">
                        {$status->status|escape:"html":"UTF-8"}
                    </span>
                    {if !$quotation->is_template}
                    <div class="panel-heading-action">
                        <a class="btn btn-default btn-lg" id="releaseRequest" href=""
                           {if isset($quotation) && $quotation->id_employee == 0}style="display:none;"{/if}>
                            <i class="icon-edit"></i>
                            {l s='Release' mod='roja45quotationspro'}
                        </a>
                        <a class="btn btn-default btn-lg {if $deleted}disabled{/if}" id="claimRequest" href=""
                           {if isset($quotation) && $quotation->id_employee > 0}style="display:none;"{/if}>
                            <i class="icon-edit"></i>
                            {l s='Claim' mod='roja45quotationspro'}
                        </a>
                    </div>
                    {/if}
                </div>
                <form id="roja45quotationspro_form" class="defaultForm form-horizontal" action="{$quotationspro_link|escape:'html':'UTF-8'}&submiteditroja45_quotationspro=1" method="post" enctype="multipart/form-data" novalidate="">
                    <input type="hidden" name="id_roja45_quotation" value="{$quotation->id|escape:'html':'UTF-8'}">
                    <div class="panel-body">
                    <div class="form-horizontal">
                        {if isset($multistore_active) && $multistore_active}
                        <div class="form-group">
                            <label class="control-label col-lg-3">{l s='Shop' mod='roja45quotationspro'}</label>
                            <div class="col-lg-4">
                                <p class="form-control-static">{$quotation->shop_name|escape:"html":"UTF-8"}</p>
                            </div>
                        </div>
                        {/if}
                        {if $quotation->is_template}
                            <div class="form-group">
                                <label class="control-label col-lg-3">{l s='Template Name' mod='roja45quotationspro'}</label>
                                <div class="col-lg-8">
                                    <input type="text" disabled="disabled" name="template_name" id="template_name" value="{$quotation->quote_name|escape:"html":"UTF-8"}"/>
                                </div>
                            </div>
                        {else}
                        <div class="form-group">
                            <label class="control-label col-lg-3">{l s='Quote Name' mod='roja45quotationspro'}</label>
                            <div class="col-lg-8">
                                <input type="text" name="quote_name" id="quote_name" value="{$quotation->quote_name|escape:"html":"UTF-8"}"/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-lg-3">{l s='Customer Name' mod='roja45quotationspro'}</label>
                            <div class="col-lg-4">
                                <input type="text" name="firstname" id="customer_firstname" value="{$quotation->firstname|escape:"html":"UTF-8"}"/>
                            </div>
                            <div class="col-lg-4">
                                <input type="text" name="lastname" id="customer_lastname" value="{$quotation->lastname|escape:"html":"UTF-8"}"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-lg-3">{l s='Customer Email' mod='roja45quotationspro'}</label>
                            <div class="col-lg-7">
                                <input type="text" name="email" id="customer_email" value="{$quotation->email|escape:"html":"UTF-8"}"/>
                            </div>
                            <div class="col-lg-2">
                                <button data-customer-controller="{$link->getAdminLink('AdminCustomers')}" type="text" name="find_account" id="find_account" value="1" class="btn btn-default btn-search-account">{l s='Search' mod='roja45quotationspro'}</button>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-lg-3">{l s='Main Address' mod='roja45quotationspro'}</label>
                            <div class="col-lg-5">
                            {if $addresses|@count>0}
                                <select class="form-control" name="customer_main_address" id="customer_main_address">
                                    {foreach $addresses as $address}
                                        <option value="{$address.id_address|escape:"html":"UTF-8"}" {if ($quotation->id_address==$address.id_address)}selected="selected"{/if}>{$address.alias|escape:"html":"UTF-8"}</option>
                                    {/foreach}
                                </select>
                            {else}
                                <input type="text" name="customer_no_main_address" id="customer_no_main_address" disabled="disabled" class="disabled" value="{if $has_account==0}{l s='No customer account.' mod='roja45quotationspro'}{else}{l s='No addresses available.' mod='roja45quotationspro'}{/if}"/>
                            {/if}
                            </div>
                            <div class="col-lg-4">
                                <a href="{$edit_customer_url|escape:"html":"UTF-8"}" target="_blank" class="btn btn-default {if $has_account==0}add_customer_address_link hidden{/if}">{l s='Add customer address' mod='roja45quotationspro'}</a>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-lg-3">{l s='Owner' mod='roja45quotationspro'}</label>
                            <div class="col-lg-5">
                                {if isset($quotation) && $quotation->id_employee > 0}
                                    <input type="text" name="customer_employee" id="customer_employee" disabled="disabled" value="{$employee->firstname|escape:"html":"UTF-8"}&nbsp;{$employee->lastname|escape:"html":"UTF-8"}"/>
                                {else}
                                    <input type="text" name="customer_employee" id="customer_employee" disabled="disabled" value="{l s='UNASSIGNED' mod='roja45quotationspro'}"/>
                                {/if}
                            </div>
                        </div>
                        <!--
                        <div class="form-group">
                            <label class="control-label col-lg-3">{l s='Created' mod='roja45quotationspro'}</label>
                            <div class="col-lg-5">
                                <input type="text" name="received_date" id="received_date" disabled="disabled" value="{if isset($quotation->date_add)}{$quotation->date_add|escape:"html":"UTF-8"}{/if}"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-lg-3">{l s='Last Update' mod='roja45quotationspro'}</label>
                            <div class="col-lg-5">
                                <input type="text" name="last_update" id="last_update" disabled="disabled" value="{if isset($quotation->date_upd)}{$quotation->date_upd|escape:"html":"UTF-8"}{/if}"/>
                            </div>
                        </div>
                        -->
                        {/if}
                        {if ($quotation->expiry_date != '0000-00-00 00:00:00')}
                        <div class="form-group">
                            <label class="control-label col-lg-3">{l s='Expires' mod='roja45quotationspro'}</label>
                            <div class="col-lg-5">
                                <input type="text" name="expires" id="expires" disabled="disabled" value="{if isset($quotation->expiry_date)}{$quotation->expiry_date|escape:"html":"UTF-8"}{/if}"/>
                            </div>
                        </div>
                        {/if}
                        <div class="form-group">
                            <label class="control-label col-lg-3">{l s='Expires After' mod='roja45quotationspro'}</label>
                            <div class="col-lg-1">
                                <input type="number" class="form-control" name="valid_for" id="valid_for" value="0"/>
                            </div>
                            <div class="col-lg-4">
                                <select name="valid_for_period" id="valid_for_period">
                                    <option value="1">{l s='Hours' mod='roja45quotationspro'}</option>
                                    <option value="2">{l s='Days' mod='roja45quotationspro'}</option>
                                    <option value="3">{l s='Months' mod='roja45quotationspro'}</option>
                                </select>
                            </div>
                        </div>

                        {if $languages|@count > 1}
                            <div class="form-group">
                                <label class="control-label col-lg-3">
                                    {l s='Language' mod='roja45quotationspro'}
                                </label>
                                <div class="col-lg-5">
                                    <select class="form-control" name="quote_language" id="quote_language">
                                        {foreach $languages as $language}
                                            <option value="{$language.id_lang|escape:"html":"UTF-8"}"
                                                    {if ($quotation->id_lang==$language.id_lang)}selected="selected"{/if}>{$language.name|escape:"html":"UTF-8"}</option>
                                        {/foreach}
                                    </select>
                                </div>
                            </div>
                        {else}
                            <div class="row">
                                <div class="form-group">
                                    <input type="hidden" name="quote_language" id="quote_language" value="{$languages[0].id_lang|escape:"html":"UTF-8"}"/>
                                    <label class="control-label col-lg-3">{l s='Language' mod='roja45quotationspro'}</label>
                                    <div class="col-lg-9">
                                        <p class="form-control-static">
                                            {if isset($languages[0].name)}
                                                {$languages[0].name|escape:"html":"UTF-8"}
                                            {else}
                                                {l s='n/a' mod='roja45quotationspro'}
                                            {/if}
                                        </p>
                                    </div>
                                </div>
                            </div>
                        {/if}
                        {if $currencies|@count > 1}
                            <div class="form-group">
                                <label class="control-label col-lg-3">
                                    {l s='Currency' mod='roja45quotationspro'}
                                </label>
                                <div class="col-lg-5">
                                    <select class="form-control" name="quote_currency" id="quote_currency">
                                        {foreach $currencies as $currencyObj}
                                            <option value="{$currencyObj.id_currency|escape:"html":"UTF-8"}"
                                                    {if ($quotation->id_currency==$currencyObj.id_currency)}selected="selected"{/if}>{$currencyObj.name|escape:"html":"UTF-8"}</option>
                                        {/foreach}
                                    </select>
                                </div>
                            </div>
                        {else}
                            <input type="hidden" name="quote_currency" value="{$quotation->id_currency|escape:"html":"UTF-8"}"/>
                        {/if}
                        <div class="row enable_taxes">
                            <div class="form-group">
                                <label class="control-label col-lg-3">
                                    {l s='Select country' mod='roja45quotationspro'}
                                </label>
                                <div class="col-lg-5">
                                    <select class="form-control" name="tax_country" id="tax_country">
                                        <option value="0">{l s='Select country' mod='roja45quotationspro'}</option>
                                        {foreach $countries as $country}
                                            <option value="{$country.id_country|escape:"html":"UTF-8"}"
                                                    {if ($quotation->id_country==$country.id_country)}selected="selected"{/if}>{$country.name|escape:"html":"UTF-8"}</option>
                                        {/foreach}
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-lg-3">
                                    {l s='Select state' mod='roja45quotationspro'}
                                </label>
                                <div class="col-lg-5">
                                    <select class="form-control" name="tax_state" id="tax_state"
                                            {if $currencies|@count ==0}disabled="disabled"{/if}>
                                        <option value="0">{l s='Select state' mod='roja45quotationspro'}</option>
                                        {foreach $states as $state}
                                            <option value="{$state.id_state|escape:"html":"UTF-8"}"
                                                    {if ($quotation->id_state==$state.id_state)}selected="selected"{/if}>{$state.name|escape:"html":"UTF-8"}</option>
                                        {/foreach}
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-lg-3">{l s='Display Taxes' mod='roja45quotationspro'}</label>
                                <div class="col-lg-9">
                                    <span class="switch prestashop-switch fixed-width-lg">
                                        <input type="radio" name="ROJA45_QUOTATIONSPRO_ENABLE_TAXES"
                                               id="ROJA45_QUOTATIONSPRO_ENABLE_TAXES_on" value="1"
                                               {if ($quotation->calculate_taxes == 1)}checked="checked"{/if}>
                                        <label for="ROJA45_QUOTATIONSPRO_ENABLE_TAXES_on">{l s='Yes' mod='roja45quotationspro'}</label>
                                        <input type="radio" name="ROJA45_QUOTATIONSPRO_ENABLE_TAXES"
                                               id="ROJA45_QUOTATIONSPRO_ENABLE_TAXES_off" value="0"
                                               {if ($quotation->calculate_taxes == 0)}checked="checked"{/if}>
                                        <label for="ROJA45_QUOTATIONSPRO_ENABLE_TAXES_off">{l s='No' mod='roja45quotationspro'}</label>
                                        <a class="slide-button btn"></a>
                                    </span>
                                </div>
                            </div>
                        </div>
                        {if !$quotation->is_template}
                        <div class="row">
                            <div class="form-group">
                                <label class="control-label col-lg-3">{l s='Order Process' mod='roja45quotationspro'}</label>
                                <ul id="quotation-pipeline" class="form-control-static">
                                    <li>
                                        {if $has_account==1}
                                            <span style="padding: 6px;" class="user-account label label-success">
                                            <i class="icon-check"></i>
                                                {l s='User Account' mod='roja45quotationspro'}
                                        </span>
                                            <span style="display:none;padding: 6px;" class="user-account label label-danger">
                                            <i class="icon-remove"></i>
                                                {l s='User Account' mod='roja45quotationspro'}
                                        </span>
                                        {else}
                                            <span style="display:none;padding: 6px;" class="user-account label label-success">
                                            <i class="icon-check"></i>
                                                {l s='User Account' mod='roja45quotationspro'}
                                        </span>
                                            <span style="padding: 6px;" class="user-account label label-danger">
                                            <i class="icon-remove"></i>
                                                {l s='User Account' mod='roja45quotationspro'}
                                        </span>
                                        {/if}
                                    </li>
                                    <li>
                                        {if isset($quotation) && $quotation->quote_sent}
                                            <span style="padding: 6px;" class="quote-sent label label-success">
                                            <i class="icon-check"></i>
                                                {l s='Quote Sent' mod='roja45quotationspro'}
                                        </span>
                                            <span style="display:none;padding: 6px;" class="quote-sent label label-danger">
                                            <i class="icon-remove"></i>
                                                {l s='Quote Sent' mod='roja45quotationspro'}
                                        </span>
                                        {else}
                                            <span style="display:none;padding: 6px;" class="quote-sent label label-success">
                                            <i class="icon-check"></i>
                                                {l s='Quote Sent' mod='roja45quotationspro'}
                                        </span>
                                            <span style="padding: 6px;" class="quote-sent label label-danger">
                                            <i class="icon-remove"></i>
                                                {l s='Quote Sent' mod='roja45quotationspro'}
                                        </span>
                                        {/if}
                                    </li>
                                    <li>
                                        {if isset($quotation) && $quotation->id_cart}
                                            <span style="padding: 6px;" class="in-cart label label-success">
                                            <i class="icon-check"></i>
                                                {l s='Offer Created' mod='roja45quotationspro'}
                                        </span>
                                            <span style="display:none;padding: 6px;" class="in-cart label label-danger">
                                            <i class="icon-check"></i>
                                                {l s='Offer Created' mod='roja45quotationspro'}
                                        </span>
                                        {else}
                                            <span style="display:none;padding: 6px;" class="in-cart label label-success">
                                            <i class="icon-check"></i>
                                                {l s='Offer Created' mod='roja45quotationspro'}
                                        </span>
                                            <span style="padding: 6px;" class="in-cart label label-danger">
                                            <i class="icon-remove"></i>
                                                {l s='Offer Created' mod='roja45quotationspro'}
                                        </span>
                                        {/if}
                                    </li>
                                    <li>
                                        {if isset($quotation) && $quotation->id_order}
                                            <span style="padding: 6px;" class="order-raised label label-success">
                                            <i class="icon-remove"></i>
                                                {l s='Order Confirmed' mod='roja45quotationspro'}
                                        </span>
                                            <span style="display:none;padding: 6px;" class="order-raised label label-danger">
                                            <i class="icon-remove"></i>
                                                {l s='Order Confirmed' mod='roja45quotationspro'}
                                        </span>
                                        {else}
                                            <span style="display:none;padding: 6px;" class="order-raised label label-success">
                                            <i class="icon-remove"></i>
                                                {l s='Order Confirmed' mod='roja45quotationspro'}
                                        </span>
                                            <span style="padding: 6px;" class="order-raised label label-danger">
                                            <i class="icon-remove"></i>
                                                {l s='Order Confirmed' mod='roja45quotationspro'}
                                        </span>
                                        {/if}
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="row">
                            <div class="form-group">
                                <label class="control-label col-lg-3">
                                    {l s='Set Status' mod='roja45quotationspro'}
                                </label>
                                <div class="col-lg-5">
                                    <select class="form-control" name="quotation_status" id="quotation_status">
                                        {foreach $quotation_statuses as $quotation_status}
                                            <option value="{$quotation_status.id_roja45_quotation_status|escape:"html":"UTF-8"}"
                                                    {if ($quotation->id_roja45_quotation_status==$quotation_status.id_roja45_quotation_status)}selected="selected"{/if}>{$quotation_status.status|escape:"html":"UTF-8"}</option>
                                        {/foreach}
                                    </select>
                                </div>
                                <div class="col-lg-4">
                                    <a href="#" class="btn btn-default btn-set-status">{l s='Set Status' mod='roja45quotationspro'}</a>
                                </div>
                            </div>
                        </div>
                        {/if}
                    </div>
                </div>
                <div class="panel-footer">
                    <div id="quotationspro_buttons" class="row">
                        {include file='./quotationview_buttons.tpl'}
                    </div>
                </div>
                </form>
            </div>
        </div>

        <div class="col-lg-5">
            <div class="panel">
                <div class="panel-heading">
                    <i class="icon-file"></i>{l s='Request Details' mod='roja45quotationspro'}</span>
                </div>
                <div class="form-horizontal">
                    {foreach $request AS $key => $field}
                        <div class="row">
                            <label class="control-label col-lg-3">{$field['label']|escape:"html":"UTF-8"}</label>
                            <div class="col-lg-9">
                                <p class="form-control-static">{$field['value']|escape:"html":"UTF-8"}</p>
                            </div>
                        </div>
                    {/foreach}
                    {if isset($quotation->filename) && strlen($quotation->filename)}
                        <div class="row">
                            <label class="control-label col-lg-3"> {l s='Uploaded File' mod='roja45quotationspro'}</label>
                            <div class="col-lg-9">
                                <p class="form-control-static"><a href="get-file-admin.php?file={$filename|escape:"html":"UTF-8"}&filename={$quotation->filename|escape:"html":"UTF-8"}">{l s='Download' mod='roja45quotationspro'}</a></p>
                            </div>
                        </div>
                    {/if}
                </div>
            </div>
            {if $quotation_orders}
            <div class="panel">
                <div class="panel-heading">
                    <i class="icon-eye-close"></i> {l s='Orders Raised' mod='roja45quotationspro'} <span
                            class="badge">{count($quotation_orders)|escape:"html":"UTF-8"}</span>
                </div>
                <div class="alert alert-info">{l s='All orders created from this quotation.' mod='roja45quotationspro'}</div>
                <div class="panel panel-notes notes-container" >
                    <div id="notes_table">
                        {include file='./_orders_table.tpl'}
                    </div>
                </div>
            </div>
            {/if}
            <div class="panel">
                <div class="panel-heading">
                    <i class="icon-eye-close"></i> {l s='Customer Notes' mod='roja45quotationspro'} <span
                            class="badge">{count($notes)|escape:"html":"UTF-8"}</span>
                </div>
                <div class="alert alert-info">{l s='Notes will be displayed to all employees but not to customers.' mod='roja45quotationspro'}</div>
                <div class="panel panel-notes notes-container" >
                    <div id="notes_table" {if count($notes) == 0} style="display:none;"{/if}>
                        {include file='./_notes_table.tpl'}
                    </div>
                </div>
                <div class="panel panel-total note-container">
                    <div class="panel-heading">
                        {l s='Add a private note' mod='roja45quotationspro'}
                    </div>
                    <form id="customer_note" class="form-horizontal" method="post" action="{$quotationspro_link|escape:'html':'UTF-8'}">
                        <div class="form-group">
                            <div class="col-lg-12">
                                <textarea name="note" id="noteContent"
                                          onkeyup="$('#submitQuotationNote').removeAttr('disabled');">{if isset($customer_note)}{$customer_note|escape:"html":"UTF-8"}{/if}</textarea>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <button type="submit" id="submitQuotationNote" class="btn btn-default btn-lg pull-right"
                                        disabled="disabled">
                                    <i class="icon-save"></i>
                                    {l s='Save' mod='roja45quotationspro'}
                                </button>
                            </div>
                        </div>
                        <span id="note_feedback"></span>
                    </form>
                </div>
            </div>
            <div class="panel">
                <div class="panel-heading">
                    <i class="icon-envelope"></i> {l s='Message History' mod='roja45quotationspro'} <span
                            class="badge">{count($messages)|escape:"html":"UTF-8"}</span>
                </div>
                {if count($messages)}
                    <table class="table">
                        <thead>
                        <th><span class="title_box">{l s='Received' mod='roja45quotationspro'}</span></th>
                        <th><span class="title_box">{l s='Message' mod='roja45quotationspro'}</span></th>
                        <th></th>
                        </thead>
                        {foreach $messages AS $message}
                            <tr>
                                <td>{$message['date_add']|escape:'html':'UTF-8'}</td>
                                <td>
                                    <a href="index.php?tab=AdminCustomerThreads&amp;id_customer_thread={$message.id_customer_thread|escape:"html":"UTF-8"}&amp;viewcustomer_thread&amp;token={getAdminToken tab='AdminCustomerThreads'}">
                                        {$message['message']|truncate:100|escape:"html":"UTF-8"}...
                                    </a>
                                </td>
                                <td>
                                    <a href="#" class="delete-customer-message"
                                       onclick="{literal}if (confirm('Delete selected item?')){return true;}else{event.stopPropagation(); event.preventDefault();};{/literal}"
                                       title="{l s='Delete' mod='roja45quotationspro'}" class="delete">
                                        <i class="icon-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        {/foreach}
                    </table>
                {elseif isset($customer)}
                    <p class="text-muted text-center">
                        {l s='%1$s %2$s has never contacted you' sprintf=[$customer->firstname, $customer->lastname] mod='roja45quotationspro'}
                    </p>
                {/if}
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-xs-12">
            <div class="panel" id="quotation_panel">
                {include file='./quotationview_quotation.tpl'}
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-xs-12">
            <div id="message-panel" class="panel">
                <div class="panel-heading">
                    <i class="icon-eye-close"></i>{l s='Customer Message' mod='roja45quotationspro'}
                </div>
                <div class="panel-body">
                    <form id="sendMessageForm" method="post" action="{$quotationspro_link|escape:'html':'UTF-8'}" enctype="multipart/form-data" novalidate="">
                        <input type="hidden" name="submitSendMessageForm" value="1">
                        <input type="hidden" name="message_template">
                        <input type="hidden" name="id_roja45_quotation" value="{$quotation->id|escape:"html":"UTF-8"}">
                        <div id="loaded-quotation-answer" class="panel-body">
                            <div class="form-horizontal">
                                <div class="form-group">
                                    <label class="control-label col-lg-3">
                                        {l s='Load template' mod='roja45quotationspro'}
                                    </label>
                                    <div class="col-lg-5">
                                        <select class="form-control" name="select_quotation_answer"
                                                id="select_quotation_answer">
                                            <option value="roja45quotationspro_blank"
                                                    selected="selected">{l s='Blank' mod='roja45quotationspro'}</option>
                                            {foreach $templates AS $template}
                                                <option value="{$template.id|escape:'html':'UTF-8'}">{$template.name|escape:"html":"UTF-8"}</option>
                                            {/foreach}
                                        </select>
                                    </div>
                                    <div class="col-lg-3">
                                        <a id="response-selection-link"></a>
                                        <button type="submit" id="loadMessageTemplate" class="btn btn-default">
                                            <i class="icon-download"></i>
                                            {l s='Load' mod='roja45quotationspro'}
                                        </button>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-lg-3">
                                        {l s='Subject' mod='roja45quotationspro'}
                                    </label>
                                    <div class="col-lg-5">
                                        <input type="text"
                                               name="message_subject"
                                               value="{if isset($message_subject)}{$message_subject}{/if}"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="loaded-quotation-answer" class="panel-body">
                            <div class="form-horizontal">
                                <div class="form-group">
                                    <textarea id="final-quotation-response"
                                              name="response_content"
                                              class="rte autoload_rte"></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="panel-footer">
                            <div class="row">
                                <div class="col-lg-12">
                                    <button type="submit" id="cancelSendQuotationToCustomer"
                                            class="btn btn-default btn-lg pull-left">
                                        <i class="icon-remove"></i>
                                        {l s='Cancel' mod='roja45quotationspro'}
                                    </button>
                                    <button type="submit"
                                            id="sendMessageToCustomer"
                                            class="btn btn-default btn-lg pull-right">
                                        <i class="icon-save"></i>
                                        {l s='Send' mod='roja45quotationspro'}
                                    </button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="quotationspro_request_dialog_overlay"></div>

<div id="quotationspro_request_dialog" class="quotationspro_request_dialog quotationspro_dialog modal-dialog" style="display:none">
    <form action="{$quotationspro_link|escape:'html':'UTF-8'}&action=submitNewCustomerOrder" method="post" id="quotationspro_form" class="std box">
        <input type="hidden" name="id_roja45_quotation" value="{$quotation->id|escape:'html':'UTF-8'}">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">{l s='Select a Payment Method' mod='roja45quotationspro'}</h3>
                <span class="cross" title="{l s='Close window' mod='roja45quotationspro'}"></span>
            </div>
            <div id="quotationspro_request_column_12" class="quotationspro_request modal-body">
                <div class="quotationspro_request_column_container">
                    <div class="form-group">
                        <label class="control-label">{l s='Payment Method' mod='roja45quotationspro'}</label>
                        <select name="payment_method">
                            {foreach from=$payment_methods item=payment_method}
                                <option value="{$payment_method.name|escape:'htmlall':'UTF-8'}">{$payment_method.name|escape:'htmlall':'UTF-8'}</option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="control-label">{l s='Initial Status' mod='roja45quotationspro'}</label>
                        <select name="order_state">
                            {foreach from=$order_states item=order_state}
                                <option value="{$order_state.id_order_state|escape:'htmlall':'UTF-8'}">{$order_state.name|escape:'htmlall':'UTF-8'}</option>
                            {/foreach}
                        </select>
                    </div>
                </div>
            </div>
            <div class="modal-footer quotationspro_request buttons">
                <div class="button-container">
                    <a id="quotationspro_createorder" class="btn btn-primary btn-create-order" href="#" title="{l s='Create Order' mod='roja45quotationspro'}" rel="nofollow">
                        <span>{l s='Create Order' mod='roja45quotationspro'}</span>
                    </a>
                </div>
            </div>
        </div>
    </form>
</div>

<div id="quotationspro_save_template" class="quotationspro_save_template quotationspro_dialog modal-dialog" style="display:none">
    <form action="{$quotationspro_link|escape:'html':'UTF-8'}&action=saveAsTemplate" method="post" id="quotationspro_save_template_form" class="std box">
        <input type="hidden" name="id_roja45_quotation" value="{$quotation->id|escape:'html':'UTF-8'}">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">{l s='Please provide the template name' mod='roja45quotationspro'}</h3>
                <span class="cross" title="{l s='Close window' mod='roja45quotationspro'}"></span>
            </div>
            <div id="quotationspro_request_column_12" class="quotationspro_request modal-body">
                <div class="quotationspro_request_column_container">
                    <div class="form-group">
                        <label class="control-label">{l s='Template Name' mod='roja45quotationspro'}</label>
                        <input type="text" name="template_name" value="{if !empty($quotation->template_name)}{$quotation->template_name|escape:'html':'UTF-8'}{elseif !empty($quotation->quote_name)}{$quotation->quote_name|escape:'html':'UTF-8'}{/if}"/>
                    </div>
                </div>
            </div>
            <div class="modal-footer quotationspro_request buttons">
                <div class="button-container">
                    <a id="quotationspro_savetemplate" class="btn btn-primary btn-save-template" href="#" title="{l s='Save Template' mod='roja45quotationspro'}" rel="nofollow">
                        <span>{l s='Save Template' mod='roja45quotationspro'}</span>
                    </a>
                </div>
            </div>
        </div>
    </form>
</div>

<div id="quotationspro_select_customer" class="quotationspro_select_customer quotationspro_dialog modal-dialog" style="display:none">
    <form action="{$quotationspro_link|escape:'html':'UTF-8'}&action=selectCustomer" method="post" id="quotationspro_select_customer_form" class="std box">
        <input type="hidden" name="id_roja45_quotation" value="{$quotation->id|escape:'html':'UTF-8'}">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">{l s='Please select the customer' mod='roja45quotationspro'}</h3>
                <span class="cross" title="{l s='Close window' mod='roja45quotationspro'}"></span>
            </div>
            <div class="quotationspro_request modal-body">

            </div>
            <div class="modal-footer quotationspro_request buttons">
                <div class="button-container">
                    <a class="btn btn-secondary btn-close" href="#" title="{l s='Close' mod='roja45quotationspro'}" rel="nofollow">
                        <span>{l s='Close' mod='roja45quotationspro'}</span>
                    </a>
                </div>
            </div>
        </div>
    </form>
</div>

<script type="text/javascript">
    var quotationspro_link = '{$quotationspro_link}'
    var id_lang = {$current_id_lang|escape:'html':'UTF-8'}
    var id_roja45_quotation = {$id_roja45_quotation|escape:'html':'UTF-8'}
    var id_shop = {$id_shop|escape:'html':'UTF-8'}
    var id_currency = {$id_currency|escape:'html':'UTF-8'}
    var currency_sign = '{$currency_sign|escape:'html':'UTF-8'}'
    var currency_format = '{$currency_format|escape:'html':'UTF-8'}'
    var currency_blank = {$currency_blank|escape:'html':'UTF-8'}
    var has_voucher = {$has_voucher|escape:'html':'UTF-8'}
    var has_charges = {$has_charges|escape:'html':'UTF-8'}
    var use_taxes = {$use_taxes|escape:'html':'UTF-8'}
    var priceDisplayPrecision = {$priceDisplayPrecision|escape:'html':'UTF-8'}

    var roja45_quotationspro_error_unabletoclaim = '{l s='An unexpected error occurred while trying to claim this request.' mod='roja45quotationspro' js=1}';
    var roja45_quotationspro_error_nocustomeraccountsfound = '{l s='No accounts found.' mod='roja45quotationspro' js=1}';
    var roja45_quotationspro_error_unabletorelease = '{l s='An unexpected error occurred while trying to release this request.' mod='roja45quotationspro' js=1}';
    var roja45_quotationspro_error_createaccount = '{l s='An unexpected error occurred while trying to create the customer account.' mod='roja45quotationspro' js=1}';
    var roja45_quotationspro_error_unexpected = '{l s='An unexpected error has occurred while trying to complete your request' mod='roja45quotationspro' js=1}';
    var roja45quotationspro_success = '{l s='Updated Successfully' mod='roja45quotationspro' js=1}';
    var roja45quotationspro_txt_select = '{l s='Select' mod='roja45quotationspro' js=1}';
    var roja45quotationspro_txt_confirm = '{l s='Are you sure?' mod='roja45quotationspro' js=1}';
    var roja45quotationspro_confirmbutton = '{l s='Confirm' mod='roja45quotationspro' js=1}';
    var roja45quotationspro_cancelbutton = '{l s='Close' mod='roja45quotationspro' js=1}';
    var roja45quotationspro_txt_adddiscount = '{l s='Are you sure you want to apply this discount to the quotation?' mod='roja45quotationspro' js=1}';
    var roja45quotationspro_txt_deletediscount = '{l s='Are you sure you want to delete this discount from the quotation?' mod='roja45quotationspro' js=1}';
    var roja45quotationspro_txt_addcharge = '{l s='Are you sure you want to apply this charge to the quotation?' mod='roja45quotationspro' js=1}';
    var roja45quotationspro_txt_deletecharge = '{l s='Are you sure you want to delete this charge from the quotation?' mod='roja45quotationspro' js=1}';
    var roja45quotationspro_txt_addproduct = '{l s='Are you sure you want to add this product to the quotation?' mod='roja45quotationspro' js=1}';
    var roja45quotationspro_txt_deleteproduct = '{l s='Are you sure you want to delete this product from the quotation?' mod='roja45quotationspro' js=1}';
    var roja45quotationspro_txt_addnote = '{l s='Are you sure you want to add this note to the quotation' mod='roja45quotationspro' js=1}';
    var roja45quotationspro_txt_createorder = '{l s='Are you sure you want to create an order for the customer?' mod='roja45quotationspro' js=1}';
    var roja45quotationspro_txt_createcustomeraccount = '{l s='Are you sure you want to create this customer account?' mod='roja45quotationspro' js=1}';
    var roja45quotationspro_txt_sendcustomerquotation = '{l s='Are you sure you want to send this quotation?' mod='roja45quotationspro' js=1}';
    var roja45quotationspro_txt_sendcustomermessage = '{l s='Are you sure you want to send this message?' mod='roja45quotationspro' js=1}';
    var roja45quotationspro_txt_claimrequest = '{l s='Are you sure you want to claim this request?' mod='roja45quotationspro' js=1}';
    var roja45quotationspro_txt_releaserequest = '{l s='Are you sure you want to release this request?' mod='roja45quotationspro' js=1}';
    var roja45quotationspro_txt_resetcart = '{l s='Are you sure you want to reset the associated cart?' mod='roja45quotationspro' js=1}';
    var txt_add_product_stock_issue = '{l s='Are you sure you want to add this quantity?' mod='roja45quotationspro' js=1}';
    var txt_add_product_new_invoice = '{l s='Are you sure you want to create a new invoice?' mod='roja45quotationspro' js=1}';
    var txt_add_product_no_product = '{l s='Error: No product has been selected' mod='roja45quotationspro' js=1}';
    var txt_add_product_no_product_quantity = '{l s='Error: Quantity of products must be set' mod='roja45quotationspro' js=1}';
    var txt_add_product_no_product_price = '{l s='Error: Product price must be set' mod='roja45quotationspro' js=1}';
    var txt_add_discount_no_discount_name = '{l s='You must specify a name in order to create a new discount.' mod='roja45quotationspro' js=1}';
    var txt_add_discount_no_discount_value = '{l s='You must provide a value for the new discount.' mod='roja45quotationspro' js=1}';
    var txt_add_charge_no_charge_name = '{l s='You must specify a name in order to add a charge to the quotation.' mod='roja45quotationspro' js=1}';
    var txt_add_charge_no_charge_value = '{l s='You must provide a value for the new charge.' mod='roja45quotationspro' js=1}';
    var txt_enable_taxes_country_missing = '{l s='You must set a country for tax calculations to work.' mod='roja45quotationspro' js=1}';
    var txt_no_addresses_available = '{l s='No addresses available.' mod='roja45quotationspro' js=1}';
    var roja45quotationspro_txt_deletequotation = '{l s='Are you sure you want to delete this quote?' mod='roja45quotationspro' js=1}';
    var roja45quotationspro_txt_createquote = '{l s='Are you sure you want to create a new quote using this template?' mod='roja45quotationspro' js=1}';
    var roja45quotationspro_txt_savetemplate = '{l s='Are you sure you want to save this as a template?' mod='roja45quotationspro' js=1}';
</script>



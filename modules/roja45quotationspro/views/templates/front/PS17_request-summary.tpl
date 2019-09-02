{*
* 2016 ROJA45
* All rights reserved.
*
* DISCLAIMER
*
* Changing this file will render any support provided by us null and void.
*
*  @author          Roja45
*  @copyright       2016 Roja45
*  @license          /license.txt
*}
{extends file='page.tpl'}

{block name="page_title"}
    <h4 id="quote_title" class="title_block">{l s='Request summary' mod='roja45quotationspro'}
        {if isset($numberProducts)}<span id="summary_products_quantity">{*$numberProducts*} ({if $numberProducts == 1}{l s='Package' mod='roja45quotationspro'}{else}{l s='Packages' mod='roja45quotationspro'}{/if})</span>{/if}
    </h4>
{/block}

{block name='page_content'}
    <form action="{url entity='module' name='roja45quotationspro' controller='QuotationsProFront' params = ['action' => 'submitRequest']}" method="post" id="quotationspro_request_form" enctype="multipart/form-data">
        <input type="hidden" name="action" value="submitRequest"/>
        <input type="hidden" name="ROJA45QUOTATIONSPRO_FORMDATA"/>

    {assign var='current_step' value='summary'}

    {include file='_partials/form-errors.tpl' errors=$errors}

    {if isset($empty) && $empty}
        <p class="alert alert-warning">{l s='Your request is empty.' mod='roja45quotationspro'}</p>
    {else}
        {if isset($lastProductAdded) AND $lastProductAdded}
            <div class="quote_last_product">
                <div class="quote_last_product_header">
                    <div class="left">{l s='Last product added' mod='roja45quotationspro'}</div>
                </div>
                <a class="quote_last_product_img"
                   href="{$lastProductAdded.link}">
                    <img src="{$link->getImageLink($lastProductAdded.link_rewrite, $lastProductAdded.id_image, 'small_default')}"
                         alt="{$lastProductAdded.name}"/>
                </a>
                <div class="quote_last_product_content">
                    <p class="product-name">
                        <a href="{$link->getProductLink($lastProductAdded.id_product, $lastProductAdded.link_rewrite, $lastProductAdded.category, null, null, null, $lastProductAdded.id_product_attribute)}">
                            {$lastProductAdded.name}
                        </a>
                    </p>
                    {if isset($lastProductAdded.attributes) && $lastProductAdded.attributes}
                        <small>
                            <a href="{$lastProductAdded.link}">
                                {*$lastProductAdded.attributes*}
                            </a>
                        </small>
                    {/if}
                </div>
            </div>
        {/if}
        <div id="request-summary-content" class="table_block table-responsive">
            <table id="quote_summary"
                   class="table table-bordered table-responsive">
                <thead>
                <tr>
                    <th class="quote_product first_item">{l s='Product' mod='roja45quotationspro'}</th>
                    <th class="quote_description item">{l s='Description' mod='roja45quotationspro'}</th>
                    {assign var='col_span_subtotal' value='2'}
                    <th class="quote_quantity item text-center">{l s='Packages' mod='roja45quotationspro'}</th>
                    <th class="quote_delete last_item">&nbsp;</th>
                </tr>
                </thead>

                <tbody>
                {assign var='odd' value=0}
                {assign var='have_non_virtual_products' value=false}
                {if isset($requested_products)}
               
                {assign var="total_quote" value='0'} 
                {assign var="total_quote_qtye" value='0'} 
                {foreach $requested_products as $product key=k item=v}

                    {if $product.is_virtual == 0}
                        {assign var='have_non_virtual_products' value=true}
                    {/if}
                    {assign var='productId' value=$product.id_product}
                    {assign var='productAttributeId' value=$product.id_product_attribute}
                    {assign var='odd' value=($odd+1)%2}
                    {* Display the product line *}
                    {include file="module:roja45quotationspro/views/templates/front/PS17_request-summary-product-line.tpl" productLast=$product@last productFirst=$product@first}
                    {*Sum the total quote*}
                    {$total_quote=$total_quote+$priceValue}
                    {$total_quote_qtye=$total_quote_qtye+$product.qty_in_cart}
                    
                {/foreach}
                    {assign var='last_was_odd' value=$product@iteration%2}
                {/if}

                <tr class="last-row-resumen" style="font-weight:bold;font-size:1rem;">
                    <td>Total</td>
                    <td>{$currency.iso_code}{$currency.sign} <span class="product-amount-quote">{$total_quote|number_format:2:".":","}</span></h3></td>
                    <td colspan="2" style="text-align:left!important;padding-left:10px;">
                        <div class="quote-qty-total-div">
                            <p style="margin-bottom:.6rem;">
                            {if ($customer.id_default_group == 12 or $customer.id_default_group == 13) and $shop.name == $azaimayoreo}
                         <!--do nothing-->
                         {else}
                                <span class="product-amount-quote-qty" >{$total_quote_qtye}</span>
                                    <span>
                                    
                                        {if $total_quote_qtye <= 1}
                                            {l s='Package' mod='roja45quotationspro'}
                                        {else}
                                            {l s='Packages' mod='roja45quotationspro'}
                                        {/if}
                                    
                                    </span>
                                {/if}
                            </p>
                            <p style="margin-bottom:0;">
                                <span class="product-amount-quote-qty-und">{$packageAzai*$total_quote_qtye}</span>
                                <span>
                                     {if $total_quote_qtye <= 1}
                                        {l s='Unit' mod='roja45quotationspro'}
                                    {else}
                                        {l s='Units' mod='roja45quotationspro'}
                                    {/if}
                                </span>
                            </p>
                        </div>
                    </td>
                </tr>

              

                </tbody>
            </table>
        </div>
        <h3 class="page-heading" style="margin-bottom:1rem;">{l s='Please provide the following additional information' mod='roja45quotationspro'}</h3>

        <div class="row_2" style="display:none;">
        <div class="collapse-group_2">
        <span class="collapse" id="viewdetails3">

        <div class="quotationspro_request_container col-lg-12">
            <div class="row">
        {for $col_counter=1 to $columns}
            <div id="quotationspro_request_column_{$col_counter}" data-column="{$col_counter}" class="quotationspro_request column col-lg-{$col_width} col-md-12 col-xs-12">
                <div class="quotationspro_request_column_container col-lg-12">
                    {if (isset( $form.$col_counter.settings.column_heading ))}
                        <h3 class="page-subheading">{$form.$col_counter.settings.column_heading}</h3>
                    {/if}
                    {foreach $form.$col_counter.fields as $field}
                        {if $field.type=='TEXT'}
                            {include
                                file="module:roja45quotationspro/views/templates/front/fo_text_field.tpl"
                                id=$field.id
                                name=$field.name
                                field_label=$field.label
                                field_type=$field.field_type
                                required=$field.required
                                class=$field.class
                                validationMethod=$field.validation
                                customregex=$field.custom_regex
                                size=$field.size
                                placeholder=$field.description
                                suffix=$field.suffix
                                prefix=$field.prefix
                                maxlength=$field.maxlength
                            }
                        {elseif $field.type=='TEXTAREA'}
                            {include
                                file="module:roja45quotationspro/views/templates/front/fo_textarea_field.tpl"
                                id=$field.id
                                name=$field.name
                                field_label=$field.label
                                field_type=$field.field_type
                                required=$field.required
                                class=$field.class
                                placeholder=$field.description
                                field_description=$field.description
                                rows=$field.rows
                            }
                        {elseif $field.type=='CHECKBOX'}
                            {include
                                file="module:roja45quotationspro/views/templates/front/fo_checkbox_field.tpl"
                                id=$field.id
                                name=$field.name
                                default='0'
                                field_label=$field.label
                                field_type=$field.field_type
                                field_description=$field.description
                                required=$field.required
                                class=$field.class
                            }
                        {elseif $field.type=='SELECT'}
                            {include
                                file="module:roja45quotationspro/views/templates/front/fo_select_field.tpl"
                                id=$field.id
                                name=$field.name
                                default='0'
                                field_label=$field.label
                                field_type=$field.field_type
                                field_description=$field.description
                                required=$field.required
                                class=$field.class
                                options=$field.options
                                key_options=$field.key_options
                                value_options=$field.value_options
                            }
                        {elseif $field.type=='SWITCH'}
                            {include
                                file="module:roja45quotationspro/views/templates/front/fo_switch_field.tpl"
                                id=$field.id
                                name=$field.name
                                default='0'
                                field_label=$field.label
                                field_type=$field.field_type
                                field_description=$field.description
                                required=$field.required
                                class=$field.class
                            }
                        {elseif $field.type=='DATE'}
                            {include
                                file="module:roja45quotationspro/views/templates/front/fo_date_field.tpl"
                                id=$field.id
                                name=$field.name
                                default='0'
                                field_label=$field.label
                                field_type=$field.field_type
                                field_description=$field.description
                                required=$field.required
                                format=$field.format
                                class=$field.class
                                validationMethod='isDate'
                            }
                        {/if}
                    {/foreach}
                </div>
            </div>
        {/for}
        </div>
        {if $roja45quotationspro_enable_fileupload}
        <div class="row">
            <div id="quotationspro_request_column_file" class="quotationspro_request column col-lg-12 col-md-12">
                <div class="quotationspro_request_column_container col-lg-12">
                    <div class="form-group _group">
                        <label class="control-label">
                            {l s='Attach File' mod='roja45quotationspro'}
                        </label>
                        <div class="row">
                            <div class="col-lg-12">
                                <input type="hidden" name="UploadReceipt" value="1"/>
                                <input name="uploadedfile" type="file" value=""/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        {/if}
        {if $roja45quotationspro_enable_captcha}
            {if $roja45quotationspro_enable_captchatype == 1}
                <div class="g-recaptcha"
                     data-sitekey="{$roja45quotationspro_recaptcha_site_key}"
                     data-callback="onRecaptchaInvisibleSubmitCallback"
                     data-error-callback="onRecaptchaInvisibleSubmitCallbackError"
                     data-expired-callback="onRecaptchaInvisibleSubmitCallbackError"
                     data-size="invisible">
                </div>
            {elseif $roja45quotationspro_enable_captchatype == 0}
            <div class="clearfix">
                <div class="quotationspro_request captcha col-lg-12">
                    <div class="captcha-block">
                        <div id="sendQuotationsPro" class="g-recaptcha"
                             data-sitekey="{$roja45quotationspro_recaptcha_site_key}">
                        </div>
                    </div>
                </div>
            </div>
            {/if}
        {/if}
        </div>
        </span> <a data-toggle="collapse" data-target="#viewdetails3" style="margin-left:3rem;"><i class="fas fa-chevron-square-up"></i></a></p>
        </div>
      </div>

      <div class="quotationspro_request notes col-lg-12" style="margin-bottom:2rem;">
            <div class="row button-container">
                <div class="col-lg-6">
                    <div class="row">
                        <span class="required-field-indicator" style="color:gray;display:none;"><sup>&#42</sup>{l s='Required field' mod='roja45quotationspro'}</span>
                        <p style="color:#fefefe;margin-bottom:0px;">{l s='Send to: ' mod='roja45quotationspro'}{$customer.email}</p>
                    </div>
                </div>
                <div class="customer-copy-checkbox offset-lg-4 col-lg-2" style="display:none;">
                    <div class="row">
                        <label class="field-label pull-right" for="ROJA45QUOTATIONSPRO_CUSTOMER_COPY"><input type="checkbox" class="form-control" id="ROJA45QUOTATIONSPRO_CUSTOMER_COPY" name="ROJA45QUOTATIONSPRO_CUSTOMER_COPY" checked/> {l s='Receive a copy on my email.' d="Shop.Theme.Actions"}</label>
                    </div>
                </div>
            </div>
        </div>
        <div>
           <!-- <p class="alert alert-warning">{l s='To send a request quote, this have minimal: ' mod='roja45quotationspro'}{$WMinQuoteOrder}</p>-->
        </div>

        <div class="quote_navigation clearfix col-lg-12">
            <div class="row">
            {if $roja45quotationspro_enable_captcha && $roja45quotationspro_enable_captchatype == 1}
            <button class="btn btn-default btn-primary request-quotation button-medium"
                    id="submitRequest"
                    data-sitekey="{$roja45quotationspro_recaptcha_site_key}"
                    data-callback='onRecaptchaInvisibleSubmitCallback'>
                {l s='Request Quote' d='Shop.Theme.Actions'}

            </button>
            {else}
                <button type="submit"
                        id="submitRequest"
                        class="btn btn-default btn-primary request-quotation button-medium {if ($roja45quotationspro_enable_captcha) or ($total_quote < $WMinQuoteOrder)}disabled{/if}"
                        title="{l s='Request Quote' mod='roja45quotationspro'}">
                {l s='Request Quote' d='Shop.Theme.Actions'}
                </button>
            {/if}
            <a href="{$home_url}"
               class="button-exclusive btn btn-default" 
               title="{l s='Continue shopping' mod='roja45quotationspro'}">
                <i class="material-icons">keyboard_arrow_left</i>{l s='Continue shopping' mod='roja45quotationspro'}
            </a>
            </div>
        </div>
        <div class="clear"></div>

    {/if}
    </form>
{/block}

{block name="page_footer"}
    {if ($roja45quotationspro_enable_captchatype == 0)}
    <script type="text/javascript">
        {if (($roja45quotationspro_enable_captcha==1) && (null !== $roja45quotationspro_recaptcha_site_key) )}
        var roja45quotationspro_recaptcha_site_key = "{$roja45quotationspro_recaptcha_site_key}";
        if (typeof roja45_recaptcha_widgets == 'undefined') {
            roja45_recaptcha_widgets = [];
        }
        roja45_recaptcha_widgets.push('sendQuotationsPro');
        var roja45quotationspro_enable_captcha = true;
        {else}
        var roja45quotationspro_enable_captcha = false;
        {/if}
    </script>
    {/if}
{/block}
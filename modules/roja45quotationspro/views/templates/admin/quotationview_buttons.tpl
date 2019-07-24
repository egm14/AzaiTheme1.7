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

{if !$quotation->is_template}
    <button type="submit"
            id="saveQuotation"
            class="btn btn-default btn-lg">
        <i class="icon-save"></i>
    </button>
{else}
    <button type="submit"
            id="updateTemplate"
            class="btn btn-default btn-lg">
        <i class="icon-save"></i>
    </button>
{/if}

{if !$quotation->is_template}

    <button type="submit"
            id="sendCustomerQuotation"
            style="font-size:15px;cursor: pointer; {if $deleted}display:none;{/if}"
            class="btn btn-default btn-lg sendCustomerQuotation {if $deleted}disabled{/if}">
        <i class="icon-envelope"></i>
        {l s='Send Quote' mod='roja45quotationspro'}
    </button>

{/if}
<button type="button"
        id="deleteQuotation"
        class="btn btn-default btn-lg pull-right"
        title="{l s='Delete' mod='roja45quotationspro'}">
    <i class="icon-trash"></i>
</button>
<button type="button"
        id="saveAsTemplate"
        class="btn btn-default btn-lg pull-right"
        title="{l s='Save As Template' mod='roja45quotationspro'}">
    <i class="icon-files-o"></i>
</button>

{if !$quotation->is_template}
    <div class="btn-group ">
        {if $has_account}
            <button type="button" id="addQuotationToOrder" class="btn btn-default btn-lg">
                <i class="icon-shopping-cart"></i>
                {l s='Raise Order' mod='roja45quotationspro'}
            </button>
        {else}
            <button type="button" id="sendCustomerMessage" class="btn btn-default btn-lg">
                <i class="icon-user"></i>
                {l s='Send Message to Customer' mod='roja45quotationspro'}
            </button>
        {/if}
        <button type="button"
                class="btn btn-default btn-lg dropdown-toggle customerOptionsDropdown"
                style="font-size:15px;cursor: pointer;border-left: 1px; {if $deleted}display:none;{/if}"
                {if $deleted}disabled="disabled"{/if}
                data-toggle="dropdown">
            <span class="caret"></span>
        </button>
        <ul class="dropdown-menu"
            role="menu"
            style="{if $deleted}display:none;{/if}">
            {if $has_account}
            <li>
                <a id="addQuotationToOrder"
                   style="font-size:15px;cursor:pointer;"
                   class="">
                    {l s='Raise Order' mod='roja45quotationspro'}
                </a>
            </li>
            <li>
                <a id="sendCustomerMessage"
                   href="#response-selection-link"
                   style="font-size:15px;cursor:pointer;"
                   class="">
                    {l s='Send Message to Customer' mod='roja45quotationspro'}
                </a>
            </li>
            {/if}
        </ul>
    </div>
{else}
    <button type="button" class="btn btn-default btn-lg pull-right createQuote">
        <i class="icon-envelope"></i>
        {l s='Create Quote' mod='roja45quotationspro'}
    </button>
{/if}
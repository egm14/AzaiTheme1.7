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

<div class="table-responsive">
    <table class="table">
        <thead>
        <tr>
            <th><span class="title_box ">{l s='Note (click to view content)' mod='roja45quotationspro'}</span></th>
            <th><span class="title_box ">{l s='Added' mod='roja45quotationspro'}</span></th>
            <th></th>
        </tr>
        </thead>
        <tbody>
        {foreach from=$notes item=note}
            <tr class="note_row">
                <td style="width: 75%">
                    <a href="#" class="quotation-note-link" data-id-roja45-quotation="{$note['id_roja45_quotation']|escape:'html':'UTF-8'}" data-id-roja45-quotation-note="{$note['id_roja45_quotation_note']|escape:'html':'UTF-8'}">
                        <i class="icon-envelope"></i>
                        {$note['note']|truncate:100|escape:'html':'UTF-8'}
                    </a>
                    <p class="note-detail-div" data-received="{l s='Added' mod='roja45quotationspro'}: {$note['added']|escape:'html':'UTF-8'}" style="display:none;">{$note['note']|escape:'html':'UTF-8'}</p>
                </td>
                <td>{$note['added']|escape:'html':'UTF-8'}</td>
                <td>
                    <a href="#" class="delete-quotation-note-link" data-id-roja45-quotation="{$note['id_roja45_quotation']|escape:'html':'UTF-8'}" data-id-roja45-quotation-note="{$note['id_roja45_quotation_note']|escape:'html':'UTF-8'}">
                        <i class="icon-trash"></i>
                    </a>
                </td>
            </tr>
        {/foreach}
        </tbody>
    </table>
</div>
<div id="note-detail-div"></div>
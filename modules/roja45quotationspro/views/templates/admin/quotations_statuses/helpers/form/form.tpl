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

{extends file="helpers/form/form.tpl"}

{block name="label"}
	{if $input.type == "select_template"}
	<div id="tpl" style="display:{if isset($fields_value.send_email) && $fields_value.send_email}block{else}none{/if}">
	{/if}
	{$smarty.block.parent}
	{/block}

	{block name="input"}
		{if $input.type == "select_template"}
			<div class="col-lg-9">
				<div class="row">
					{foreach $languages as $language}
						{assign var='value_text' value=$fields_value[$input.name][$language.id_lang]|escape:'html':'UTF-8'}
						<div class="translatable-field lang-{$language.id_lang|escape:'html':'UTF-8'}" {if $language.id_lang != $defaultFormLanguage}style="display:none"{/if}>
							<div class="col-lg-8">
								<select name="{$input.name|escape:'html':'UTF-8'}_{$language.id_lang|escape:'html':'UTF-8'}"
										id="{$input.name|escape:'html':'UTF-8'}_select_{$language.id_lang|escape:'html':'UTF-8'}"
										{if isset($input.multiple)}multiple="multiple" {/if}
										{if isset($input.size)}size="{$input.size|escape:'html':'UTF-8'}"{/if}
										{if isset($input.onchange)}onchange="{$input.onchange|escape:'html':'UTF-8'}"{/if}>
									{foreach $input.options.query[$language.iso_code] AS $option}
										<option value="{$option[$input.options.id]|escape:'html':'UTF-8'}"
												{if isset($input.multiple)}
													{foreach $fields_value[$input.name] as $field_value}
														{if $field_value == $option[$input.options.id]}selected="selected"{/if}
													{/foreach}
												{else}
													{if isset($fields_value[$input.name][$language.id_lang]) && ($fields_value[$input.name][$language.id_lang] == $option[$input.options.id])}selected="selected"{/if}
												{/if}
												data-preview="{$option[$input.options.folder]|escape:'html':'UTF-8'}"
												>{$option[$input.options.name]|escape:'html':'UTF-8'}</option>
									{/foreach}
								</select>
							</div>
							<div class="col-lg-4">
								<button type="button" class="btn btn-default dropdown-toggle" tabindex="-1" data-toggle="dropdown">
									{$language.iso_code|escape:'html':'UTF-8'}
									<span class="caret"></span>
								</button>
								<ul class="dropdown-menu">
									{foreach from=$languages item=language_flag}
										<li>
											<a href="javascript:hideOtherLanguage({$language_flag.id_lang|escape:'html':'UTF-8'});" tabindex="-1">{$language_flag.name|escape:'html':'UTF-8'}</a>
										</li>
									{/foreach}
								</ul>
								<button type="button" class="btn btn-default" onclick="viewTemplates('#answer_template_select_{$language.id_lang|escape:'html':'UTF-8'}', '{$language.iso_code|escape:'html':'UTF-8'}/', '.html');">
									<i class="icon-eye-open"></i>
									{l s='Preview' mod='roja45quotationspro'}
								</button>
							</div>
						</div>
					{/foreach}
					{if isset($input.hint)}
						<div class="clearfix">&nbsp;</div>
						<div class="col-lg-9">
							<div class="alert alert-info">
								{if is_array($input.hint)}
									{foreach from=$input.hint item=hint}
										{$hint|escape:'html':'UTF-8'}<br/>
									{/foreach}
								{else}
									{$input.hint|escape:'html':'UTF-8'}
								{/if}
							</div>
						</div>
					{/if}
				</div>
			</div>

		{else}
			{$smarty.block.parent}
		{/if}
	{/block}

	{block name="field"}
	{$smarty.block.parent}
	{if $input.type == "select_template"}
</div>
	{/if}
{/block}

{block name="script"}
	$(document).ready(function() {
	    $('input[name=send_email]').on('change', function() {
	        $('#tpl').slideToggle();
	    });
	});
{/block}
{*
 *
 * OrderStatisticsFilter module for Prestashop by Avellana Digital
 *
 * @author     Avellana Digital SL
 * @copyright  Copyright (c) 2019 Avellana Digital - www.avellanadigital.com
 * @license    Commercial license
 * @version    1.1.1
*}

{$header|escape:'html':'UTF-8'|htmlspecialchars_decode:3}

<script type="text/javascript">
$(document).ready(function() {
	$('.butaction_list').click( function() {
		var idList = $(this).attr('id');
		$('ul#'+idList+'_list li.nototal').fadeToggle();
	});
});
</script>

<div id="resultats" class="col-lg-12 row">
	<h2>{l s='Summary of total payments' mod='orderstatisticsfilter'}</h2>

	<div class="col-lg-12 clearfix row">
		<div class="col-lg-4 blockresult">
			<h3 id="view_payment" class="butaction_list">{l s='Payment method' mod='orderstatisticsfilter'}
			</h3>

			<ul class="infototals col-lg-12" id="view_payment_list">
			{foreach $info_payments as $module => $payment}
				<li{if $payment.total == '0.00'} class="nototal"{/if}>
					<div class="statname col-xs-12 col-sm-8 col-md-9 col-lg-8">{$payment.name|escape:'htmlall':'UTF-8'} <small>({$module|escape:'htmlall':'UTF-8'})</small>:</div>
					<div class="stattotal col-xs-12 col-sm-4 col-md-3 col-lg-4">{convertPrice price=$payment.total}</div></li>
			{/foreach}
			</ul>		
		</div>

		<div class="col-lg-4 blockresult">
			<h3 id="view_group" class="butaction_list">{l s='Customer group' mod='orderstatisticsfilter'}</h3>

			<ul class="infototals col-lg-12" id="view_group_list">
			{foreach $info_groups as $group}
				<li{if $group.total == '0.00'} class="nototal"{/if}>
					<div class="statname col-xs-12 col-sm-8 col-md-9 col-lg-8">{$group.name|escape:'htmlall':'UTF-8'}:</div>
					<div class="stattotal col-xs-12 col-sm-4 col-md-3 col-lg-4">{convertPrice price=$group.total}</div>
				</li>
			{/foreach}
			</ul>		
		</div>

		<div class="col-lg-4 blockresult">
			<h3 id="view_state" class="butaction_list">{l s='Order current state' mod='orderstatisticsfilter'}</h3>

			<ul class="infototals col-lg-12" id="view_state_list">
			{foreach $info_states as $state}
				<li{if $state.total == '0.00'} class="nototal"{/if}>
					<div class="statname col-xs-12 col-sm-8 col-md-9 col-lg-8" style="background-color:{$state.color|escape:'htmlall':'UTF-8'};color:{$state.textcolor|escape:'htmlall':'UTF-8'}">{$state.name|escape:'htmlall':'UTF-8'}:</div>
					<div class="stattotal col-xs-12 col-sm-4 col-md-3 col-lg-4">{convertPrice price=$state.total}</div>
				</li>
			{/foreach}
			</ul>		
		</div>

	</div>

	<div class="col-lg-12 clearfix row total_info">
		<h3>{l s='TOTAL' mod='orderstatisticsfilter'}</h3>
		
		<ul class="col-lg-12">
			<li >
				<div class="statname col-xs-12 col-sm-8 col-md-9 col-lg-8">{l s='Orders' mod='orderstatisticsfilter'}:</div>
				<div class="stattotal col-xs-12 col-sm-4 col-md-3 col-lg-4">{convertPrice price=$info_total}</div>
			</li>
		</ul>		
	</div>

	<p class="col-lg-12 clearfix row text-center">
		<small>{l s='(Results based on the selected filters and the number of items displayed in the current page)' mod='orderstatisticsfilter'}</small>
	</p>
</div>

{$content|escape:'html':'UTF-8'|htmlspecialchars_decode:3}

{$footer|escape:'html':'UTF-8'|htmlspecialchars_decode:3}

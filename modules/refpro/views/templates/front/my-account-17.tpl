{*
* 2007-2017 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
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
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2017 PrestaShop SA
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}

{extends file='page.tpl'}

{block name='page_title'}
  {l s='Affiliate program' mod='refpro'}
{/block}

{block name='page_content'}
	{if isset($reload) && $reload == 1}
		{Tools::redirect($link->getModuleLink('refpro', 'myaccount'))|escape:'htmlall':'UTF-8'}
	{/if}

	<script type="text/javascript">
		var baseDir = "{$base_uri|escape:'quotes':'UTF-8'}";
		var phrases = [];
		phrases['saved'] = "{l s='Settings saved!' mod='refpro'}";
		phrases['error'] = "{l s='Error!' mod='refpro'}";
		phrases['ordered'] = "{l s='Withdrawal of rewards ordered!' mod='refpro'}";
		phrases['alert_text'] = "{l s='Please read the Terms of Service and confirm your agreement.' mod='refpro'}";
	</script>
{if $user_data.active || !(isset($is_sponsor_tmp) && $is_sponsor_tmp)}
	<div id="tabs" class="tab_container">
		<ul class="tabs">
			<li data-tab="tabs-1">{l s='General information' mod='refpro'}</li>
			{if isset($is_sponsor_tmp) && $is_sponsor_tmp}
				<li data-tab="tabs-2">{l s='Affiliates' mod='refpro'}</li>
				{if !empty($banners)}<li data-tab="tabs-banners">{l s='Banners' mod='refpro'}</li>{/if}
				{if isset($p_systems) && $p_systems && $withdrawal_allowed}
					<li data-tab="tabs-3">{l s='Payment information' mod='refpro'}</li>
				{/if}
				{if isset($payments) && $payments}
					<li data-tab="tabs-4">{l s='Payout history' mod='refpro'}</li>
				{/if}
			{/if}
		</ul>
		<div class="tabs_content">
			<div class="tab" id="tabs-1">
				{if isset($is_sponsor_tmp) && $is_sponsor_tmp}
					<h2>{l s='Your affiliate links:' mod='refpro'}</h2>
					<div class="refpro-svg">
						<a href="{$qrCodeTargetUrl}" target="_blank"><img src="{$qrCodeInlineUrl}" /></a>
						<div>
							<a href="{$qrCodeDownloadUrl}">{l s='Download QR code' mod='refpro'}</a>
						</div>
					</div>
					<!--<p><span style="font-weight:700;">{l s='Client VIP' d='Shop.Theme.Global'}: </span><a href="{$link_num|escape:'htmlall':'UTF-8'}&cl=vip" target=new>{$link_num|escape:'htmlall':'UTF-8'}&cl=vip</a></p> -->
					<p><span style="font-weight:700;">{l s='Referer Link' d='Shop.Theme.Global'}: </span><br style="margin-bottom:10px;"/>
					<span class="group-clipboard">
						<span id="refproLink" style="padding:10px 15px;text-decoration:underline;border:1.4px solid #e2e2e2;font-size:1rem" class="force-select-all" href="" target=new>{$link_num|escape:'htmlall':'UTF-8'}&cl=shop</span>
						<span id="copyText">
							<i  class="fa fa-clipboard" aria-hidden="true">
							<span class="off_X" style="display:none"> {l s='Click to copy Clipboard' d='Shop.Theme.Global'}</span>
							<span class="on" style="display:none"> {l s='Link was copy' d='Shop.Theme.Global'}</span>
						</i></span>
					</span>
</p>
					<!--<p>{l s='or' mod='refpro'}</p>
					<p><a href="{$link_char|escape:'htmlall':'UTF-8'}" target=new>{$link_char|escape:'htmlall':'UTF-8'}</a><br></p>
					<p>{l s='or' mod='refpro'}</p>
					<p><a href="{$link_sec|escape:'htmlall':'UTF-8'}" target=new>{$link_sec|escape:'htmlall':'UTF-8'}</a><br></p>-->
                    {include file="module:refpro/views/templates/front/voucher.tpl"}
					<h2>{l s='Your rewards:' mod='refpro'}</h2>
					{if isset($money) && $money}
						<p>
							{if $ip_installed}
								<a href="{$link->getModuleLink('userbalance', 'balance')|escape:'quotes':'UTF-8'}" class="btn btn-default button-small">{l s='My balance' mod='refpro'}</a>
							{else}
                                {l s='On your account:' mod='refpro'}
								<span class="money">{Tools::displayPrice($money, $currency_default, false)|escape:'htmlall':'UTF-8'}</span>
								{if $withdrawal_allowed && isset($not_set) && $not_set}
										dd<a href="#/modules/internalpay/internalpay-user.php" id="getPaid">{l s='Order the withdrawal of rewards' mod='refpro'} »</a>
								{/if}
							{/if}
							{if $withdrawal_allowed}
								{if !$user_data.order}
									<a href="#"  id="getPaid">{l s='Order the withdrawal of rewards' mod='refpro'} »</a>
								{else}
									<span class="ordered">{l s='Withdrawal of rewards ordered!' mod='refpro'}</span>
								{/if}
							{/if}
						</p>
					{else}
						<p>{l s='Your account is empty!' mod='refpro'}</p>
					{/if}
					<h2>{l s='Your interest:' mod='refpro'}</h2>
					<table class="table">
						<tr>
							<td>{l s='The first level:' mod='refpro'}</td>
							<td><b>{if isset($rate_1) && $rate_1}{$rate_1|escape:'htmlall':'UTF-8'}{else}0{/if}</b> %</td>
						</tr>

						{if isset($rate_2) && $rate_2}
							<tr>
								<td>{l s='The second level:' mod='refpro'}</td>
								<td><b>{$rate_2|escape:'htmlall':'UTF-8'}</b> %</td>
							</tr>
						{/if}

						{if isset($rate_3) && $rate_3}
							<tr>
								<td>{l s='The third level:' mod='refpro'}</td>
								<td><b>{$rate_3|escape:'htmlall':'UTF-8'}</b> %</td>
							</tr>
						{/if}
						{if isset($rate_4) && $rate_4}
							<tr>
								<td>{l s='The fourth level:' mod='refpro'}</td>
								<td><b>{$rate_4|escape:'htmlall':'UTF-8'}</b> %</td>
							</tr>
						{/if}
						{if isset($rate_5) && $rate_5}
							<tr>
								<td>{l s='The fifth level:' mod='refpro'}</td>
								<td><b>{$rate_5|escape:'htmlall':'UTF-8'}</b> %</td>
							</tr>
						{/if}
                        {if isset($rate_6) && $rate_6}
							<tr>
								<td>{l s='The sixth level:' mod='refpro'}</td>
								<td><b>{$rate_6|escape:'htmlall':'UTF-8'}</b> %</td>
							</tr>
                        {/if}
                        {if isset($rate_7) && $rate_7}
							<tr>
								<td>{l s='The seventh level:' mod='refpro'}</td>
								<td><b>{$rate_7|escape:'htmlall':'UTF-8'}</b> %</td>
							</tr>
                        {/if}
						{if isset($rate_8) && $rate_8}
							<tr>
								<td>{l s='The eighth level:' mod='refpro'}</td>
								<td><b>{$rate_8|escape:'htmlall':'UTF-8'}</b> %</td>
							</tr>
						{/if}
						{if isset($rate_9) && $rate_9}
							<tr>
								<td>{l s='The nineth level:' mod='refpro'}</td>
								<td><b>{$rate_9|escape:'htmlall':'UTF-8'}</b> %</td>
							</tr>
						{/if}
					</table>
				{else}
                	{if $is_need_completed_orders}
						<p>{l s='You do not participate in the affiliate program.' mod='refpro'}
						{if isset($rules) && $rules}
							<p>
								<div style='margin-right: 5px;float: left; width: 15px; height: 15px;'><input type="checkbox" name="ref_agree" class="ref_cb" /></div>
								<label for="ref_agree" class="ref_lbl" style="color: #000000; margin-left: 5px;">{l s='I have read and agree to the' mod='refpro'} <a href="{$rules|escape:'quotes':'UTF-8'}" id="ref_agree" class="iframe">"{l s='Terms of Service' mod='refpro'}"</a>.</label>
							</p>
						{else}
							<input type="hidden" name="ref_agree" value="checked" id="ref_agree_alt" />
						{/if}
						<br/>
						<a href="{$link->getModuleLink('refpro', 'myaccount', ['goref' => 1])|escape:'quotes':'UTF-8'}" id="goref_a">{l s='Participate' mod='refpro'} »</a>
                    {else}
						<p>{l s='You can participate in our affiliate program only if you have' mod='refpro'}
                            {$need_completed_orders|intval} {l s='paid order(-s) in the store' mod='refpro'}</p>
                    {/if}
				{/if}
			</div>
			{if isset($is_sponsor_tmp) && $is_sponsor_tmp && isset($sponsor) && $sponsor}
				<div class="tab" id="tabs-2">
					{if $sponsor->email}
						<h2>{l s='Your sponsor:' mod='refpro'}</h2>
						<p>{$sponsor->firstname|escape:'htmlall':'UTF-8'} {if !$is_cust_priv}{$sponsor->lastname|escape:'htmlall':'UTF-8'} ({$sponsor->email|escape:'htmlall':'UTF-8'}){else}{$sponsor->lastname|mb_substr:0:1|escape:'htmlall':'UTF-8'}.{/if}</p>
					{/if}
					<h2>{l s='Your direct affiliates:' mod='refpro'}</h2>
					{if $referrals}
						<table class="table affiliates-table">
							<thead>
							<tr>
								<td class="number">№</td>
								<td class="name">{l s='Name' mod='refpro'}</td>
								{if !$is_cust_priv}<td class="email">Email</td>{/if}
								<td class="profit">{l s='Brought a profit' mod='refpro'}</td>
							</tr>
							</thead>
							<tbody>
							{foreach from=$referrals item=ref name=refs}
								<tr>
									<td class="number">{$smarty.foreach.refs.iteration|escape:'htmlall':'UTF-8'}</td>
									<td class="name">
										{if $ref.is_sponsor}
											<span class="sponsor">{$ref.firstname|escape:'htmlall':'UTF-8'} {if !$is_cust_priv}{$ref.lastname|escape:'htmlall':'UTF-8'}{else}{$ref.lastname|mb_substr:0:1|escape:'htmlall':'UTF-8'}.{/if}</span>
										{else}
											{$ref.firstname|escape:'htmlall':'UTF-8'} {if !$is_cust_priv}{$ref.lastname|escape:'htmlall':'UTF-8'}{else}{$ref.lastname|mb_substr:0:1|escape:'htmlall':'UTF-8'}.{/if}
										{/if}
									</td>
									{if !$is_cust_priv}<td class="email">{$ref.email|escape:'htmlall':'UTF-8'}</td>{/if}
									<td class="profit">{Tools::displayPrice($ref.profit, $currency_default, false)|escape:'htmlall':'UTF-8'}</td>
								</tr>
							{/foreach}
							</tbody>
						</table>
					{else}
						<p>{l s='There are currently no affiliates!' mod='refpro'}</p>
					{/if}
					{if $subrefs}
						<br />
						<h2>{l s='Affiliates of second level:' mod='refpro'}</h2>
						<table class="table affiliates-table">
							<thead>
							<tr><td class="number">№</td>
								<td class="name">{l s='Name' mod='refpro'}</td>
								{if !$is_cust_priv}<td class="email">Email</td>{/if}
								<td class="profit">{l s='Brought a profit' mod='refpro'}</td>
							</tr>
							</thead>
							<tbody>
							{foreach from=$subrefs item=ref name=refs}
								<tr>
									<td class="number">{$smarty.foreach.refs.iteration|escape:'htmlall':'UTF-8'}</td>
									<td class="name">
										{if $ref.is_sponsor}
											<span class="sponsor">{$ref.firstname|escape:'htmlall':'UTF-8'} {if !$is_cust_priv}{$ref.lastname|escape:'htmlall':'UTF-8'}{else}{$ref.lastname|mb_substr:0:1|escape:'htmlall':'UTF-8'}.{/if}</span>
										{else}
											{$ref.firstname|escape:'htmlall':'UTF-8'} {if !$is_cust_priv}{$ref.lastname|escape:'htmlall':'UTF-8'}{else}{$ref.lastname|mb_substr:0:1|escape:'htmlall':'UTF-8'}.{/if}
										{/if}
									</td>
									{if !$is_cust_priv}<td class="email">{$ref.email|escape:'htmlall':'UTF-8'}</td>{/if}
									<td class="profit">{Tools::displayPrice($ref.profit, $currency_default, false)|escape:'htmlall':'UTF-8'}</td>
								</tr>
							{/foreach}
							</tbody>
						</table>
					{/if}
					{*Third level of program*}
					{if isset($subrefs3) && !empty($subrefs3)}
						<br />
						<h2>{l s='Affiliates of third level:' mod='refpro'}</h2>
						<table class="table affiliates-table">
							<thead>
							<tr><td class="number">№</td>
								<td class="name">{l s='Name' mod='refpro'}</td>
								{if !$is_cust_priv}<td class="email">Email</td>{/if}
								<td class="profit">{l s='Brought a profit' mod='refpro'}</td>
							</tr>
							</thead>
							<tbody>
							{foreach from=$subrefs3 item=ref name=refs}
								<tr>
									<td class="number">{$smarty.foreach.refs.iteration|escape:'htmlall':'UTF-8'}</td>
									<td class="name">
										{if $ref.is_sponsor}
											<span class="sponsor">{$ref.firstname|escape:'htmlall':'UTF-8'} {if !$is_cust_priv}{$ref.lastname|escape:'htmlall':'UTF-8'}{else}{$ref.lastname|mb_substr:0:1|escape:'htmlall':'UTF-8'}.{/if}</span>
										{else}
											{$ref.firstname|escape:'htmlall':'UTF-8'} {if !$is_cust_priv}{$ref.lastname|escape:'htmlall':'UTF-8'}{else}{$ref.lastname|mb_substr:0:1|escape:'htmlall':'UTF-8'}.{/if}
										{/if}
									</td>
									{if !$is_cust_priv}<td class="email">{$ref.email|escape:'htmlall':'UTF-8'}</td>{/if}
									<td class="profit">{Tools::displayPrice($ref.profit, $currency_default, false)|escape:'htmlall':'UTF-8'}</td>
								</tr>
							{/foreach}
							</tbody>
						</table>
					{/if}
					{*Affiliates of fourth level*}
					{if isset($subrefs4) && !empty($subrefs4)}
						<br />
						<h2>{l s='Affiliates of fourth level:' mod='refpro'}</h2>
						<table class="table affiliates-table">
							<thead>
							<tr><td class="number">№</td>
								<td class="name">{l s='Name' mod='refpro'}</td>
								{if !$is_cust_priv}<td class="email">Email</td>{/if}
								<td class="profit">{l s='Brought a profit' mod='refpro'}</td>
							</tr>
							</thead>
							<tbody>
							{foreach from=$subrefs4 item=ref name=refs}
								<tr>
									<td class="number">{$smarty.foreach.refs.iteration|escape:'htmlall':'UTF-8'}</td>
									<td class="name">
										{if $ref.is_sponsor}
											<span class="sponsor">{$ref.firstname|escape:'htmlall':'UTF-8'} {if !$is_cust_priv}{$ref.lastname|escape:'htmlall':'UTF-8'}{else}{$ref.lastname|mb_substr:0:1|escape:'htmlall':'UTF-8'}.{/if}</span>
										{else}
											{$ref.firstname|escape:'htmlall':'UTF-8'} {if !$is_cust_priv}{$ref.lastname|escape:'htmlall':'UTF-8'}{else}{$ref.lastname|mb_substr:0:1|escape:'htmlall':'UTF-8'}.{/if}
										{/if}
									</td>
									{if !$is_cust_priv}<td class="email">{$ref.email|escape:'htmlall':'UTF-8'}</td>{/if}
									<td class="profit">{Tools::displayPrice($ref.profit, $currency_default, false)|escape:'htmlall':'UTF-8'}</td>
								</tr>
							{/foreach}
							</tbody>
						</table>
					{/if}
					{*Affiliates of fifth level*}
					{if isset($subrefs5) && !empty($subrefs5)}
						<br />
						<h2>{l s='Affiliates of fifth level:' mod='refpro'}</h2>
						<table class="table affiliates-table">
							<thead>
							<tr><td class="number">№</td>
								<td class="name">{l s='Name' mod='refpro'}</td>
								{if !$is_cust_priv}<td class="email">Email</td>{/if}
								<td class="profit">{l s='Brought a profit' mod='refpro'}</td>
							</tr>
							</thead>
							<tbody>
							{foreach from=$subrefs5 item=ref name=refs}
								<tr>
									<td class="number">{$smarty.foreach.refs.iteration|escape:'htmlall':'UTF-8'}</td>
									<td class="name">
										{if $ref.is_sponsor}
											<span class="sponsor">{$ref.firstname|escape:'htmlall':'UTF-8'} {if !$is_cust_priv}{$ref.lastname|escape:'htmlall':'UTF-8'}{else}{$ref.lastname|mb_substr:0:1|escape:'htmlall':'UTF-8'}.{/if}</span>
										{else}
											{$ref.firstname|escape:'htmlall':'UTF-8'} {if !$is_cust_priv}{$ref.lastname|escape:'htmlall':'UTF-8'}{else}{$ref.lastname|mb_substr:0:1|escape:'htmlall':'UTF-8'}.{/if}
										{/if}
									</td>
									{if !$is_cust_priv}<td class="email">{$ref.email|escape:'htmlall':'UTF-8'}</td>{/if}
									<td class="profit">{Tools::displayPrice($ref.profit, $currency_default, false)|escape:'htmlall':'UTF-8'}</td>
								</tr>
							{/foreach}
							</tbody>
						</table>
					{/if}
                    {*Affiliates of 6 level*}
                    {if isset($subrefs6) && !empty($subrefs6)}
						<br />
						<h2>{l s='Affiliates of sixth level:' mod='refpro'}</h2>
						<table class="table affiliates-table">
							<thead>
							<tr><td class="number">№</td>
								<td class="name">{l s='Name' mod='refpro'}</td>
                                {if !$is_cust_priv}<td class="email">Email</td>{/if}
								<td class="profit">{l s='Brought a profit' mod='refpro'}</td>
							</tr>
							</thead>
							<tbody>
                            {foreach from=$subrefs6 item=ref name=refs}
								<tr>
									<td class="number">{$smarty.foreach.refs.iteration|escape:'htmlall':'UTF-8'}</td>
									<td class="name">
                                        {if $ref.is_sponsor}
											<span class="sponsor">{$ref.firstname|escape:'htmlall':'UTF-8'} {if !$is_cust_priv}{$ref.lastname|escape:'htmlall':'UTF-8'}{else}{$ref.lastname|mb_substr:0:1|escape:'htmlall':'UTF-8'}.{/if}</span>
                                        {else}
                                            {$ref.firstname|escape:'htmlall':'UTF-8'} {if !$is_cust_priv}{$ref.lastname|escape:'htmlall':'UTF-8'}{else}{$ref.lastname|mb_substr:0:1|escape:'htmlall':'UTF-8'}.{/if}
                                        {/if}
									</td>
                                    {if !$is_cust_priv}<td class="email">{$ref.email|escape:'htmlall':'UTF-8'}</td>{/if}
									<td class="profit">{convertPriceWithCurrency price=$ref.profit currency=$currency_default}</td>
								</tr>
                            {/foreach}
							</tbody>
						</table>
                    {/if}
                    {*Affiliates of 7 level*}
                    {if isset($subrefs7) && !empty($subrefs7)}
						<br />
						<h2>{l s='Affiliates of seventh level:' mod='refpro'}</h2>
						<table class="table affiliates-table">
							<thead>
							<tr><td class="number">№</td>
								<td class="name">{l s='Name' mod='refpro'}</td>
                                {if !$is_cust_priv}<td class="email">Email</td>{/if}
								<td class="profit">{l s='Brought a profit' mod='refpro'}</td>
							</tr>
							</thead>
							<tbody>
                            {foreach from=$subrefs7 item=ref name=refs}
								<tr>
									<td class="number">{$smarty.foreach.refs.iteration|escape:'htmlall':'UTF-8'}</td>
									<td class="name">
                                        {if $ref.is_sponsor}
											<span class="sponsor">{$ref.firstname|escape:'htmlall':'UTF-8'} {if !$is_cust_priv}{$ref.lastname|escape:'htmlall':'UTF-8'}{else}{$ref.lastname|mb_substr:0:1|escape:'htmlall':'UTF-8'}.{/if}</span>
                                        {else}
                                            {$ref.firstname|escape:'htmlall':'UTF-8'} {if !$is_cust_priv}{$ref.lastname|escape:'htmlall':'UTF-8'}{else}{$ref.lastname|mb_substr:0:1|escape:'htmlall':'UTF-8'}.{/if}
                                        {/if}
									</td>
                                    {if !$is_cust_priv}<td class="email">{$ref.email|escape:'htmlall':'UTF-8'}</td>{/if}
									<td class="profit">{convertPriceWithCurrency price=$ref.profit currency=$currency_default}</td>
								</tr>
                            {/foreach}
							</tbody>
						</table>
                    {/if}
					{*Affiliates of 8 level*}
					{if isset($subrefs8) && !empty($subrefs8)}
						<br />
						<h2>{l s='Affiliates of eighth level:' mod='refpro'}</h2>
						<table class="table affiliates-table">
							<thead>
							<tr><td class="number">№</td>
								<td class="name">{l s='Name' mod='refpro'}</td>
								{if !$is_cust_priv}<td class="email">Email</td>{/if}
								<td class="profit">{l s='Brought a profit' mod='refpro'}</td>
							</tr>
							</thead>
							<tbody>
							{foreach from=$subrefs8 item=ref name=refs}
								<tr>
									<td class="number">{$smarty.foreach.refs.iteration|escape:'htmlall':'UTF-8'}</td>
									<td class="name">
										{if $ref.is_sponsor}
											<span class="sponsor">{$ref.firstname|escape:'htmlall':'UTF-8'} {if !$is_cust_priv}{$ref.lastname|escape:'htmlall':'UTF-8'}{else}{$ref.lastname|mb_substr:0:1|escape:'htmlall':'UTF-8'}.{/if}</span>
										{else}
											{$ref.firstname|escape:'htmlall':'UTF-8'} {if !$is_cust_priv}{$ref.lastname|escape:'htmlall':'UTF-8'}{else}{$ref.lastname|mb_substr:0:1|escape:'htmlall':'UTF-8'}.{/if}
										{/if}
									</td>
									{if !$is_cust_priv}<td class="email">{$ref.email|escape:'htmlall':'UTF-8'}</td>{/if}
									<td class="profit">{convertPriceWithCurrency price=$ref.profit currency=$currency_default}</td>
								</tr>
							{/foreach}
							</tbody>
						</table>
					{/if}
					{*Affiliates of 9 level*}
					{if isset($subrefs9) && !empty($subrefs9)}
						<br />
						<h2>{l s='Affiliates of nineth level:' mod='refpro'}</h2>
						<table class="table affiliates-table">
							<thead>
							<tr><td class="number">№</td>
								<td class="name">{l s='Name' mod='refpro'}</td>
								{if !$is_cust_priv}<td class="email">Email</td>{/if}
								<td class="profit">{l s='Brought a profit' mod='refpro'}</td>
							</tr>
							</thead>
							<tbody>
							{foreach from=$subrefs9 item=ref name=refs}
								<tr>
									<td class="number">{$smarty.foreach.refs.iteration|escape:'htmlall':'UTF-8'}</td>
									<td class="name">
										{if $ref.is_sponsor}
											<span class="sponsor">{$ref.firstname|escape:'htmlall':'UTF-8'} {if !$is_cust_priv}{$ref.lastname|escape:'htmlall':'UTF-8'}{else}{$ref.lastname|mb_substr:0:1|escape:'htmlall':'UTF-8'}.{/if}</span>
										{else}
											{$ref.firstname|escape:'htmlall':'UTF-8'} {if !$is_cust_priv}{$ref.lastname|escape:'htmlall':'UTF-8'}{else}{$ref.lastname|mb_substr:0:1|escape:'htmlall':'UTF-8'}.{/if}
										{/if}
									</td>
									{if !$is_cust_priv}<td class="email">{$ref.email|escape:'htmlall':'UTF-8'}</td>{/if}
									<td class="profit">{convertPriceWithCurrency price=$ref.profit currency=$currency_default}</td>
								</tr>
							{/foreach}
							</tbody>
						</table>
					{/if}
					<p><span style="color: rgb(48, 111, 245);">{l s='Blue' mod='refpro'}</span> {l s='- for users also participating in the affiliate program.' mod='refpro'}</p>
				</div>
				{if isset($p_systems) && $p_systems && $withdrawal_allowed}
					<div class="tab" id="tabs-3">
						<p>{l s='Please enter your payment details (account number, account, etc.) of the payment system from the list that you would like to use for money withdrawal.' mod='refpro'}<br><br></p>
						<form method="post" id="settings">
							<table class="table">
								{foreach from=$p_systems item=ps}
									<tr>
										<td>{$ps.value|escape:'htmlall':'UTF-8'}</td>
										{assign var="ps_key" value=$ps.key}
										<td><input type="text" name="{$ps.key|escape:'htmlall':'UTF-8'}" value="{$user_data.$ps_key|escape:'htmlall':'UTF-8'}" /></td>
									</tr>
								{/foreach}
							</table>
							<input type="hidden" name="action" value="save_settings" />
							<input type="submit" value="{l s='Save settings' mod='refpro'}" class="big_button" />
						</form>
					</div>
				{/if}
				{if !empty($banners)}
					<div class="tab" id="tabs-banners">
						<table class="table">
							{foreach from=$banners item=banner}
								<tr>
									<td style="width:50%"><img src="{$banner.b|escape:'htmlall':'UTF-8'}" class="img-responsive img-thumbnail" {if !$ifGreateThen16}style="width:100%"{/if}/></td>
									<td><textarea style="width:100%;height:70px;" onClick="this.select();" title="{l s='Click and use Ctrl+C to copy' mod='refpro'}" readonly>&lt;a href=&quot;{$banner.url|escape:'htmlall':'UTF-8'}&quot; target=&quot;new&quot;&gt;&lt;img src=&quot;{$banner.b|escape:'htmlall':'UTF-8'}&quot;&gt;&lt;/a&gt;</textarea></td>
								</tr>
							{/foreach}
						</table>

					</div>
				{/if}
				{if $payments}
					<div class="tab" id="tabs-4">
						<table class="table">
							<thead>
							<tr>
								<td>{l s='Date - Time' mod='refpro'}</td>
								<td>{l s='Amount' mod='refpro'}</td>
							</tr>
							</thead>
							<tbody class="list_payments">
							{foreach from=$payments item=payment}
								<tr>
									<td>{$payment.ts|strip_tags|escape:'quotes':'UTF-8'}</td>
									<td>{Tools::displayPrice($payment.amount, $currency_default, false)|escape:'quotes':'UTF-8'}</td>
								</tr>
							{/foreach}
							</tbody>
						</table>
						{if $nb_payments > 1}
							<a class="view_more" href="#">{l s='View more' mod='refpro'}</a>
						{/if}
						<script>
							var pages = [];
							{for $i=1 to $nb_payments}
							pages.push({$i|escape:'quotes':'UTF-8'});
							{/for}
							pages.shift();

							function defer(method) {
								if (window.jQuery)
										method();
								else
									setTimeout(function() { defer(method) }, 50);
							}
							

							var fnbt = function() {

								jQuery('.view_more').live('click', function (e) {
									e.preventDefault();
									var page = pages.shift();
									$.ajax({
										url: document.location.href.replace(document.location.hash, ''),
										type: 'POST',
										dataType: 'json',
										data: {
											ajax: true,
											action: 'get_payments',
											page: page
										},
										success: function (r)
										{
											if (r.hasError)
												pages.unshift(page);
											else
												$('.list_payments').append(r.message);
											if (!pages.length)
												$('.view_more').hide();
										},
										error: function () {
											pages.unshift(page);
										}
									});
								});
							}

							defer(fnbt);
						</script>
					</div>
				{/if}
			{/if}
		</div>
	</div>

	{if $banner_url}
	<a href="{$banner_url|escape:'quotes':'UTF-8'}" class="refbanner" target="_blank"><img src="{$module_img_dir|escape:'quotes':'UTF-8'}{$banner_img|escape:'quotes':'UTF-8'}" alt="" title="" /></a>
	{/if}
{else}
<div class="help-block">
<ul>
<li class="alert alert-danger">{l s='Your account has been disabled, contact the store owner to specify the reason! ' mod='refpro'}</li>
</ul>
</div>

{/if}
{/block}

{block name='page_footer'}
	<a href="{$link->getPageLink('my-account')|escape:'quotes':'UTF-8'}" class="account-link">
		<i class="material-icons">&#xE5CB;</i>
		<span>{l s='Back to Your Account' mod='refpro'}</span>
	</a>
	<a href="{$base_uri|escape:'quotes':'UTF-8'}" class="account-link">
		<i class="material-icons">&#xE88A;</i>
		<span>{l s='Home' mod='refpro'}</span>
	</a>
{/block}
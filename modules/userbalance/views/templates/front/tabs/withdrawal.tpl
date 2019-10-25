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
*  @author    Goryachev Dmitry <dariusakafest@gmail.com>
*  @copyright 2007-2017 Goryachev Dmitry
*  @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}

{if $balance && ConfUB::getConf('enable_withdrawal')}
    {if ConfUB::getConf('minimum_withdrawal') && $balance < ConfUB::getConf('minimum_withdrawal')}
        <div class="row">
            <div class="col-md-12">
                <div class="error alert alert-warning">
                    {l s='Minimum withdrawal' mod='userbalance'}: {displayPrice price=ConfUB::getConf('minimum_withdrawal') currency=$obj_default_currency->id}
                </div>
            </div>
        </div>
    {/if}
    <div class="row balance_row">
        <div class="col-md-12">
            {l s='Withdrawal' mod='userbalance'}
            <input type="text" class="form-control" name="withdrawal"> {$obj_default_currency->sign|escape:'quotes':'UTF-8'}
        </div>
    </div>
    <div class="row balance_row">
        <div class="col-md-12">
            <div class="row">
                <div class="col-md-12">
                    {l s='Payment requisites' mod='userbalance'}
                    <textarea placeholder="{ConfUB::getConf('type_payment_text')|escape:'quotes':'UTF-8'}" {if $message}readonly{/if} rows="10" class="form-control" name="message">{$message|escape:'quotes':'UTF-8'}</textarea>
                </div>
            </div>
            <div class="row {if $message}hidden{/if}">
                <div class="col-md-12">
                    <input class="form-control" type="checkbox" name="as_template">
                    {l s='Save as template?' mod='userbalance'}
                </div>
            </div>
            {if $message}
                <div class="row">
                    <div class="col-md-12">
                        <div class="error alert alert-info">{l s='Change the details you can through the administration of the site.' mod='userbalance'}</div>
                    </div>
                </div>
            {/if}
        </div>
    </div>
    <div class="row">
        <div class="col-md-12 text-center">
            <input type="button" class="btn btn-default withdrawal {if {versionCompare v='1.6.0.0' op='<'}}exclusive{/if}" value="{l s='Withdrawal' mod='userbalance'}">
        </div>
    </div>
{/if}
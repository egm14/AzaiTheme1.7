{*
* 2002-2017 Jetimpex
*
* JX Header Account
*
* NOTICE OF LICENSE
*
* This source file is subject to the General Public License (GPL 2.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/GPL-2.0

* @author     Jetimpex (Alexander Grosul)
* @copyright  2002-2017 Jetimpex
* @license    http://opensource.org/licenses/GPL-2.0 General Public License (GPL 2.0)
*}

<div class="jx-header-account-wrapper {$configs.JXHEADERACCOUNT_DISPLAY_STYLE}{if $customer.is_logged} is-logged{/if}">
  {if $customer.is_logged}
    <div class="header-account-content{if {$configs.JXHEADERACCOUNT_DISPLAY_STYLE} == 'onecolumn'} text-center{else}{/if}">
      <h3 class="page-heading">{l s='My account' mod='jxheaderaccount'}</h3>
      <div class="user-data">
        <h3>{$firstname} {$lastname}</h3>
        {if $configs.JXHEADERACCOUNT_USE_AVATAR}
          <img class="img-fluid mb-2" src="{$avatar}" alt="">
        {/if}
      </div>
      <ul class="list-default-sm">
        <li>
          <a href="{$link->getPageLink('history', true)|escape:'htmlall':'UTF-8'}" title="{l s='My orders' mod='jxheaderaccount'}" rel="nofollow">
            {l s='My orders' mod='jxheaderaccount'}
          </a>
        </li>
        <!--{if $returnAllowed}
          <li>
            <a href="{$link->getPageLink('order-follow', true)|escape:'htmlall':'UTF-8'}" title="{l s='My returns' mod='jxheaderaccount'}" rel="nofollow">
              {l s='My merchandise returns' mod='jxheaderaccount'}
            </a>
          </li>-->
        {/if}
        <li>
          <a href="{$link->getPageLink('order-slip', true)|escape:'htmlall':'UTF-8'}" title="{l s='My credit slips' mod='jxheaderaccount'}" rel="nofollow">
            {l s='My credit slips' mod='jxheaderaccount'}
          </a>
        </li>
        <li>
          <a href="{$link->getPageLink('addresses', true)|escape:'htmlall':'UTF-8'}" title="{l s='My addresses' mod='jxheaderaccount'}" rel="nofollow">
            {l s='My addresses' mod='jxheaderaccount'}
          </a>
        </li>
        <li>
          <a href="{$link->getPageLink('identity', true)|escape:'htmlall':'UTF-8'}" title="{l s='Manage my personal information' mod='jxheaderaccount'}" rel="nofollow">
            {l s='My personal info' mod='jxheaderaccount'}
          </a>
        </li>
        {if $voucherAllowed}
          <li>
            <a href="{$link->getPageLink('discount', true)|escape:'htmlall':'UTF-8'}" title="{l s='My vouchers' mod='jxheaderaccount'}" rel="nofollow">
              {l s='My vouchers' mod='jxheaderaccount'}
            </a>
          </li>
        {/if}
        {if $f_status}
          <li>
            <a href="{$link->getModuleLink('jxheaderaccount', 'facebooklink', [], true)}" title="{l s='Facebook Login Manager' mod='jxheaderaccount'}">
              <span class="link-item">
                {if !$facebook_id}{l s='Connect With Facebook' mod='jxheaderaccount'}{else}{l s='Facebook Login Manager' mod='jxheaderaccount'}{/if}
              </span>
            </a>
          </li>
        {/if}
        {if $g_status}
          <li>
            <a {if isset($back) && $back}href="{$link->getModuleLink('jxheaderaccount', 'googlelogin', ['back' => $back], true)}" {else}href="{$link->getModuleLink('tmheaderaccount', 'googlelogin', [], true)}"{/if}
               title="{l s='Google Login Manager' mod='tmheaderaccount'}">
              <span class="link-item">
                {if !$google_id}{l s='Connect With Google' mod='jxheaderaccount'}{else}{l s='Google Login Manager' mod='jxheaderaccount'}{/if}
              </span>
            </a>
          </li>
        {/if}
        {if $vk_status}
          <li>
            <a {if isset($back) && $back}href="{$link->getModuleLink('jxheaderaccount', 'vklogin', ['back' => $back], true)}" {else}href="{$link->getModuleLink('tmheaderaccount', 'vklogin', [], true)}"{/if}
               title="{l s='VK Login Manager' mod='tmheaderaccount'}">
              <span class="link-item">
                {if !$vkcom_id}{l s='Connect With VK' mod='jxheaderaccount'}{else}{l s='VK Login Manager' mod='jxheaderaccount'}{/if}
              </span>
            </a>
          </li>
        {/if}
        {hook h='displayMyAccountBlock'}
      </ul>
    </div>
    <p class="logout">
      <a class="btn btn-secondary btn-md btn-block" href="{$link->getPageLink('index')|escape:'html':'UTF-8'}?mylogout" title="{l s='Sign out' mod='jxheaderaccount'}" rel="nofollow">
        {l s='Sign out' mod='jxheaderaccount'}
      </a>
    </p>
  {else}
    <div id="login-content-{$hook}" class="header-login-content login-content active text-center">
      <form action="{$link->getPageLink('authentication', true)|escape:'html':'UTF-8'}" method="post">
        <h3 class="page-heading">{l s='Login' mod='tmheaderaccount'}</h3>
        <div class="main-help-block"><ul></ul></div>
        <section>
          {assign value=$login_form.formFields var="formFields"}
          {foreach from=$formFields item="field"}
            {form_field field=$field}
          {/foreach}
        </section>
        <div class="header-login-footer">
          <button type="submit" name="HeaderSubmitLogin" class="btn btn-secondary btn-md btn-block submit">
            {l s='Sign in' mod='jxheaderaccount'}
          </button>
          <div class="register-link nav d-block">
            <a {if $configs.JXHEADERACCOUNT_USE_REDIRECT}href="{$urls.pages.register}" {else}href="#create-account-content-{$hook}" data-toggle="tab"{/if} data-link-action="display-register-form">
              {l s='No account? Create one here' d='Shop.Theme.Customeraccount'}
            </a>
          </div>
          <div class="nav d-block">
            <a class="forgot-password" {if $configs.JXHEADERACCOUNT_USE_REDIRECT}href="{$link->getPageLink('password', 'true')|escape:'html':'UTF-8'}" {else}href="#forgot-password-content-{$hook}" data-toggle="tab"{/if}>
              {l s='Forgot your password?' mod='jxheaderaccount'}
            </a>
          </div>
          {hook h="displayHeaderLoginButtons"}
        </div>
      </form>
    </div>
    <div id="create-account-content-{$hook}" class="header-login-content create-account-content">
      <form action="{$link->getPageLink('authentication', true)|escape:'html':'UTF-8'}" method="post" class="std">
        {hook h='HOOK_CREATE_ACCOUNT_TOP'}
        <div class="main-help-block"><ul></ul></div>
        <section>
          {assign value=$register_form.formFields var="formFields"}
          {foreach from=$formFields item="field"}
            {form_field field=$field}
          {/foreach}
        </section>
        <div class="header-login-footer">
          {$HOOK_CREATE_ACCOUNT_FORM}
          <div class="submit clearfix">
            <input type="hidden" name="email_create" value="1"/>
            <input type="hidden" name="is_new_customer" value="1"/>
            <input type="hidden" class="hidden" name="back" value="my-account"/>
            <button type="submit" name="submitAccount" class="btn btn-secondary btn-md btn-block submit">
              {l s='Register' mod='jxheaderaccount'}
            </button>
            <div class="button-login nav d-block">
              <a href="#login-content-{$hook}" data-toggle="tab" class="btn btn-primary btn-md btn-block">
                {l s='Back to login' d='Shop.Theme.Actions'}
              </a>
            </div>
          </div>
        </div>
      </form>
    </div>
    <div id="forgot-password-content-{$hook}" class="header-login-content forgot-password-content">
      <form method="post" class="std">
        <section>
          <div class="main-help-block"><ul></ul></div>
          <p>{l s='Please enter the email address you used to register. You will receive a temporary link to reset your password.' d='Shop.Theme.Customeraccount'}</p>
          <fieldset>
            <div class="form-group">
              <label class="form-control-label required">{l s='Email' d='Shop.Forms.Labels'}</label>
              <div class="email">
                <input class="form-control" type="email" name="email" placeholder="{l s='Email' d='Shop.Forms.Labels'}" required>
              </div>
            </div>
            <div class="submit clearfix">
              <button class="form-control-submit btn btn-secondary btn-md btn-block" name="submit" type="submit">
                {l s='Send' d='Shop.Theme.Actions'}
              </button>
            </div>
          </fieldset>
        </section>
        <div class="header-login-footer">
          <div class="button-login nav d-block">
            <a href="#login-content-{$hook}" data-toggle="tab" class="btn btn-primary btn-md btn-block">
              {l s='Back to login' d='Shop.Theme.Actions'}
            </a>
          </div>
        </div>
      </form>
    </div>
  {/if}
</div>
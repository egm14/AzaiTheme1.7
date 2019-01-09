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
<div id="_desktop_user_info">
  <div class="jx-header-account{if $configs.JXHEADERACCOUNT_DISPLAY_TYPE == 'dropdown'} js-dropdown dropdown{/if}">
    <a id="jx-header-account-link" href="#" onclick="return false;"{if $configs.JXHEADERACCOUNT_DISPLAY_TYPE == 'dropdown'} data-toggle="dropdown"{/if}{if $configs.JXHEADERACCOUNT_DISPLAY_TYPE == 'leftside' || $configs.JXHEADERACCOUNT_DISPLAY_TYPE == 'rightside'}  data-id-slidebar="jxheaderaccount-slidebar" class="slidebar-toggle"{/if}>
      {if $customer.is_logged}
        <i class="fa fa-sign-in" aria-hidden="true"></i>
        <span>{l s='Your Account' mod='jxheaderaccount'}</span>
      {else}
        <i class="fl-chapps-user139" aria-hidden="true"></i>
        <span>{l s='Sign in' mod='jxheaderaccount'}</span>
      {/if}
    </a>
    {if $configs.JXHEADERACCOUNT_DISPLAY_TYPE == 'dropdown'}
      <div class="dropdown-menu dropdown-menu-right">
        {include file="../default/jxheaderaccount-content.tpl"}
      </div>
    {elseif $configs.JXHEADERACCOUNT_DISPLAY_TYPE == 'popup'}
      <div id="jxha-modal" class="modal fade modal-close-inside" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-sm modal-md" role="document">
          <div class="modal-content">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close" aria-hidden="true"></button>
            <div class="modal-body">
              {include file="../default/jxheaderaccount-content.tpl"}
            </div>
          </div>
        </div>
      </div>
    {else}
      <div data-off-canvas="jxheaderaccount-slidebar{if $configs.JXHEADERACCOUNT_DISPLAY_TYPE == 'leftside'} left{else} right{/if} push" class="jxheaderaccount-{if $configs.JXHEADERACCOUNT_DISPLAY_TYPE == 'leftside'}left{else}right{/if}">
        <button type="button" class="closeSlidebar" aria-label="Close"></button>
        {include file="../default/jxheaderaccount-content.tpl"}
      </div>
    {/if}
  </div>
</div>
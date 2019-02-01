{**
 * 2007-2017 PrestaShop
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License 3.0 (AFL-3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * https://opensource.org/licenses/AFL-3.0
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
 * @author    PrestaShop SA <contact@prestashop.com>
 * @copyright 2007-2017 PrestaShop SA
 * @license   https://opensource.org/licenses/AFL-3.0 Academic Free License 3.0 (AFL-3.0)
 * International Registered Trademark & Property of PrestaShop SA
 *}

{$step_classes = [
  'active' => $step_is_current,
  'reachable' => $step_is_reachable,
  'complete' => $step_is_complete
]}

{if isset($tab) && $tab}
  {block name='nav_step'}
    <li class="nav-item">
      <a id="{$identifier}-tab" class="nav-link {$step_classes|classnames}" href="#{$identifier}" data-toggle="tab" role="tab" aria-controls="{$identifier}"><span class="step-number">{$position}<span class="punto-step">. </span></span>{$title}</a>
    </li>
  {/block}
{else}
  {block name='step'}
    <div id="{$identifier}" class="tab-pane checkout-step {$step_classes|classnames}" role="tabpanel" aria-labelledby="{$identifier}-tab">
      {block name='step_content'}DUMMY STEP CONTENT{/block}
    </div>
  {/block}
{/if}

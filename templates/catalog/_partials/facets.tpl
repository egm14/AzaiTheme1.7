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
  <div id="search_filters">

    {block name='facets_title'}
      <h4 class="facets_title subpages-heading">{l s='Filter By' d='Shop.Theme.Actions'}</h4>
    {/block}

    <div id="js-active-search-filters-duplicate" class="active_filters mb-3 d-xl-none"></div>

    {block name='facets_clearall_button'}
      <button data-search-url="{$clear_all_link}" class="btn btn-sm btn-secondary-2 js-search-filters-clear-all d-xl-none mb-3 mt-1 m-xl-0">
        <i class="material-icons-close right-space" aria-hidden="true"></i>
        <span>{l s='Clear all' d='Shop.Theme.Actions'}</span>
      </button>
    {/block}

    {foreach from=$facets item="facet"}

      {if $facet.displayed}

        <section class="facet">
          
          <h1 class="h6 facet-title d-none d-xl-block">{$facet.label}</h1>
          {assign var=_expand_id value=10|mt_rand:100000}
          {assign var=_collapse value=true}
          {foreach from=$facet.filters item="filter"}
            {if $filter.active}{assign var=_collapse value=false}{/if}
          {/foreach}
          <h1 class="h6 facet-title d-xl-none{if $_collapse} collapsed{/if}" data-target="#facet_{$_expand_id}" data-toggle="collapse"{if !$_collapse} aria-expanded="true"{/if}>
            <span>{$facet.label}</span>
            <i class="fa fa-angle-down ml-1" aria-hidden="true"></i>
          </h1>

            {if $facet.widgetType != 'dropdown'}

              {block name='facet_item_other'}
                <ul id="facet_{$_expand_id}" class="facet-list collapse d-xl-block{if !$_collapse} show{/if}{if isset($filter.properties.color) || isset($filter.properties.texture)} variant-links list-inline{/if}"> 
               

                  {foreach from=$facet.filters key=filter_key item="filter"}
                    {if $filter.displayed}
                      <li class="{if isset($filter.properties.color)}list-inline-item d-inline-block{/if}">
                        {if $facet.type == 'price'}
                          <div class="p-1 pt-3">
                            <input id="price-slider"{if !$_collapse} class="active"{/if} data-slidermin="{$facet.properties.min}" data-slidermax="{$facet.properties.max}" type="hidden" value="{$facet.properties.min},{$facet.properties.max}" />
                            <a href="{$filter.nextEncodedFacetsURL}" id="price-slider-link" class="d-none search-link js-search-link" rel="nofollow"></a>
                          </div>
                          {break}
                        {elseif $facet.multipleSelectionAllowed}
                          <div class="custom-control custom-checkbox">
                            <input
                              id="facet_input_{$_expand_id}_{$filter_key}"
                              class="custom-control-input"
                              data-search-url="{$filter.nextEncodedFacetsURL}"
                              type="checkbox"
                              {if $filter.active } checked {/if}
                            >
                            <label class="facet-label custom-control-label{if $filter.active} active{/if}" for="facet_input_{$_expand_id}_{$filter_key}"{if isset($filter.properties.color)} style="background-color:{$filter.properties.color}"{/if}{if isset($filter.properties.texture)} style="background-image:url({$filter.properties.texture})"{/if}>
                              <span {if !$js_enabled}class="ps-shown-by-js"{/if}>
                                <a href="{$filter.nextEncodedFacetsURL}" class="search-link js-search-link" rel="nofollow">
                                  {$filter.label}
                                  {if $filter.magnitude}
                                    <span class="magnitude">{$filter.magnitude}</span>
                                  {/if}
                                </a>
                              </span>
                            </label>
                          </div>
                        {else}
                          <div class="custom-control custom-radio">
                            <input
                              id="facet_input_{$_expand_id}_{$filter_key}"
                              class="custom-control-input"
                              data-search-url="{$filter.nextEncodedFacetsURL}"
                              type="radio"
                              name="filter {$facet.label}"
                              {if $filter.active } checked {/if}
                            >
                            <label class="facet-label custom-control-label{if $filter.active} active{/if}" for="facet_input_{$_expand_id}_{$filter_key}">
                              <span {if !$js_enabled}class="ps-shown-by-js"{/if}>
                                <a href="{$filter.nextEncodedFacetsURL}" class="search-link js-search-link" rel="nofollow">
                                  {$filter.label}
                                  {if $filter.magnitude}
                                    <span class="magnitude">{$filter.magnitude}</span>
                                  {/if}
                                </a>
                              </span>
                            </label>
                          </div>
                        {/if}
                      </li>
                    {/if}
                  {/foreach}
                </ul>
              {/block}

            {else}

              {block name='facet_item_dropdown'}
                <ul id="facet_{$_expand_id}" class="facet-list collapse{if !$_collapse} in{/if} d-xl-block">
                  <li>
                    <div class="facet-dropdown dropdown">
                      <button class="custom-select" rel="nofollow" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        {$active_found = false}
                        {foreach from=$facet.filters item="filter"}
                          {if $filter.active}
                            {$filter.label}
                            {if $filter.magnitude}
                              ({$filter.magnitude})
                            {/if}
                            {$active_found = true}
                          {/if}
                        {/foreach}
                        {if !$active_found}
                          {l s='(no filter)' d='Shop.Theme.Global'}
                        {/if}
                      </button>
                      <div class="dropdown-menu">
                        {foreach from=$facet.filters item="filter"}
                          {if !$filter.active}
                            <a
                              rel="nofollow"
                              href="{$filter.nextEncodedFacetsURL}"
                              class="select-list js-search-link dropdown-item"
                            >
                              {$filter.label}
                              {if $filter.magnitude}
                                ({$filter.magnitude})
                              {/if}
                            </a>
                          {/if}
                        {/foreach}
                      </div>
                    </div>
                  </li>
                </ul>
              {/block}

            {/if}
        </section>
      {/if}
    {/foreach}
  </div>

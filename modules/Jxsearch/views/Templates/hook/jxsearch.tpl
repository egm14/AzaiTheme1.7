{*
* 2017 Zemez
*
* JX Search
*
* NOTICE OF LICENSE
*
* This source file is subject to the General Public License (GPL 2.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/GPL-2.0
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade the module to newer
* versions in the future.
*
* @author     Zemez (Alexander Grosul)
* @copyright  2017 Zemez
* @license    http://opensource.org/licenses/GPL-2.0 General Public License (GPL 2.0)
*}

<div id="_desktop_jxsearch">
  <div class="jxsearch-wrapper">
    <div class="icon-toggle search-icon">
      <i class="fl-chapps-search70" aria-hidden="true"></i>
    </div>
    <div id="jxsearchwrapper" class="d-flex">
      <span class="search-close"><i class="material-icons-close"></i></span>
      {if isset($search_blog_categories) && $search_blog_categories}
        <ul class="nav nav-tabs" id="jxsearch-tab" role="tablist">
          <li class="nav-item">
            <a class="nav-link{if !isset($blog_search_query) || !$blog_search_query} active{/if}" id="catalog-tab" data-toggle="tab" href="#jxsearchbox" role="tab" aria-controls="catalog" aria-selected="true"><i class="fa fa-exchange" aria-hidden="true"></i></a>
          </li>
          <li class="nav-item">
            <a class="nav-link{if isset($blog_search_query) && $blog_search_query} active{/if}" id="blog-tab" data-toggle="tab" href="#jxsearchbox-blog" role="tab" aria-controls="blog" aria-selected="false"><i class="fa fa-exchange" aria-hidden="true"></i></a>
          </li>
        </ul>
      {/if}
      <div id="jxsearchblock" class="tab-content">
        <form class="tab-pane show {if !isset($blog_search_query) || !$blog_search_query} active{/if}" role="tabpanel" aria-labelledby="catalog" id="jxsearchbox" method="get" action="{Jxsearch::getJXSearchLink('jxsearch')|escape:'htmlall':'UTF-8'}">
          {if !Configuration::get('PS_REWRITING_SETTINGS')}
            <input type="hidden" name="fc" value="module"/>
            <input type="hidden" name="controller" value="jxsearch"/>
            <input type="hidden" name="module" value="jxsearch"/>
          {/if}
          <div class="form-inline">
            <select name="search_categories" class="custom-select">
              {foreach from=$search_categories item=category}
                <option {if isset($active_category) && $active_category == $category.id}selected="selected"{/if} value="{$category.id|escape:'htmlall':'UTF-8'}">{if $category.id == 2}{l s='All Categories' mod='jxsearch'}{else}{$category.name|escape:'htmlall':'UTF-8'}{/if}</option>
              {/foreach}
            </select>
            <input class="jx_search_query form-control" type="text" id="jx_search_query" name="search_query" placeholder="{l s='Search' mod='jxsearch'}" value="{if isset($search_query)}{$search_query|escape:'htmlall':'UTF-8'|stripslashes}{/if}"/>
            <button  name="jx_submit_search" class="button-search">
              <i class="fl-chapps-search70" aria-hidden="true"></i>
              <span>{l s='Search' mod='jxsearch'}</span>
            </button>
          </div>
        </form>
        {if isset($search_blog_categories) && $search_blog_categories}
          <form class="tab-pane {if isset($blog_search_query) && $blog_search_query} active{/if}" role="tabpanel" aria-labelledby="blog-tab" id="jxsearchbox-blog" method="get" action="{Jxsearch::getJXBlogSearchLink()|escape:'htmlall':'UTF-8'}">
            <div class="form-inline">
              <select name="search_blog_categories" class="custom-select">
                <option value="0">{l s='Blog Categories' mod='jxsearch'}</option>
                {foreach from=$search_blog_categories item='blog_category'}
                  <option {if isset($active_blog_category) && $active_blog_category == $blog_category.id_jxblog_category}selected="selected"{/if} value="{$blog_category.id_jxblog_category}">{$blog_category.name}</option>
                {/foreach}
              </select>
              <input class="jx_blog_search_query form-control" type="text" id="jx_blog_search_query" name="blog_search_query" placeholder="{l s='Search through the blog' mod='jxsearch'}" value="{if isset($blog_search_query)}{$blog_search_query}{/if}"/>
              <button type="submit" name="jx_blog_submit_search" class="button-search">
                <i class="fl-chapps-search70" aria-hidden="true"></i>
                <span>{l s='Search' mod='jxsearch'}</span>
              </button>
            </div>
          </form>
        {/if}
      </div>
    </div>
  </div>
</div>
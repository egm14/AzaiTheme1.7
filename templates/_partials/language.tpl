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
 * to dev@azai.com so we can send you a copy immediately.
 *
 * DISCLAIMER
 *
 * Do not edit or add to this file if you wish to upgrade PrestaShop to newer
 * versions in the future. If you wish to customize PrestaShop for your
 * needs please refer to http://www.prestashop.com for more information.
 *
 * @author    Edwin Marte <dev@azai.com	>
 * @copyright 2007-2017 PrestaShop SA
 * @license   https://opensource.org/licenses/AFL-3.0 Academic Free License 3.0 (AFL-3.0)
 * Interna
 *}

<div class="modal fade" id="languagemodal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
	  <div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">

				<!--<button type="button" class="btn close-modal" data-dismiss="modal">X</button>-->
				
					<ul class="list-group list-group-flush" data-width="fit">
					  

					<li  class="list-group-item" data-content='<span class="flag-icon flag-icon-mx"></span> Español'>
					  <a class="es" data-language="es" href="#">
					  		
					  			<div class="row">
								  <div class="col-6 col-sm-6 col-md-6">
								  	<span>{l s='Spanish (Español)' d='Shop.Theme.Global'}</span>
								  </div>
								  <div class="col-3 col-sm-3 col-md-3">
								  	<img class="flags" src="{$urls.theme_assets}OtherFile/flags/es.png" />
								  	<i class="fa fa-spinner fa-spin"></i>
								  </div>
								  <div class="col-3 col-sm-3 col-md-3" style="text-align:right;">
								  		<!--<input class="medium" type="radio" name="a"/>-->
									          <i class="fa fa-square-o fa-2x"></i><i class="fa fa-check-square-o fa-2x"></i>
								  </div>
								</div>

							</a>
					  </li>

					  <li  class="list-group-item" data-content='<span class="flag-icon flag-icon-mx"></span> English'>
					  	<a class="en" data-language="en" href="#">
					  		<div class="row">
								  <div class="col-6 col-sm-6 col-md-6">
								  	<span>{l s='English (Ingés)' d='Shop.Theme.Global'}</span>
								  </div>
								  <div class="col-3 col-sm-3 col-md-3">
								  	<img class="flags" src="{$urls.theme_assets}OtherFile/flags/en.png" />
								  	<i class="fa fa-spinner fa-spin"></i>
								  </div>
								  <div class="col-3 col-sm-3 col-md-3" style="text-align:right;">
								  	<!--<input class="medium" type="radio" name="a"/>-->
									          <i class="fa fa-square-o fa-2x"></i><i class="fa fa-check-square-o fa-2x"></i>
								  </div>
								</div>
							</a>
					  </li>

					  
					</ul>

					<div class="language-title"><h3>{l s="Select language to navigate" d="Shop.Theme.Global"}</h3></div>
		</div>
	</div>
</div>
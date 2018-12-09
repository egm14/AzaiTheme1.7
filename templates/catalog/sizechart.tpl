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
 * @author    Edwin Marte <egm0815@gmail.com>
 * @copyright 2018-2019 ©Azai.com
 * @license   https://opensource.org/licenses/AFL-3.0 Academic Free License 3.0 (AFL-3.0)
 * International Registered Trademark & Property of PrestaShop SA
 *}


<!-- Size Chart Dinamic -->
                  {if ({$product.category} == 'rings') or ({$product.category} == 'jewelry-rings')}
                      <!-- Sizechard -->
						<span class="size-chart-container" data-toggle="modal" data-target="#sizechartmodal"><a class="sizes-chart" href="#sizechartmodal">{l s='Sizes chart Rings'}</a></span>
                      	<!-- Modal -->
						<div class="modal fade" id="sizechartmodal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
						  <div class="modal-dialog modal-dialog-centered" role="document">
						    <div class="modal-content">
						    	<!-- Ring Size Chart 
						    	  <object data="{$urls.theme_assets}OtherFile/Azai-RingSizeguide.pdf" type="application/pdf">
					                <embed src="{$urls.theme_assets}OtherFile/Azai-RingSizeguide.pdf" type="application/pdf">&nbsp; </embed>
					                    <a href="{$urls.theme_assets}OtherFile/Azai-RingSizeguide.pdf">
					              </object>-->
					              <img class="sizes-chart-ring container-images" src="{$urls.theme_assets}OtherFile/azai-ring-size-chart.jpg" width="100%" height="100%" />
						    </div>
						   </div>
						</div>
                      <script type="text/javascript">
                        console.log('Sizes Chart Rings');
                      </script>
                    {elseif ({$product.category} == 'jewelry')}
                     <!-- Sizechard -->
						<span class="size-chart-container" data-toggle="modal" data-target="#sizechartmodal"><a class="sizes-chart" href="#sizechartmodal">{l s='Sizes chart Jewelry 2'}</a></span>
                      	<!-- Modal -->
						<div class="modal fade" id="sizechartmodal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
						  <div class="modal-dialog modal-dialog-centered" role="document">
						    <div class="modal-content">
						    	<!-- Ring Size Chart 
						    	  <object data="{$urls.theme_assets}OtherFile/Azai-RingSizeguide.pdf" type="application/pdf">
					                <embed src="{$urls.theme_assets}OtherFile/Azai-RingSizeguide.pdf" type="application/pdf">&nbsp; </embed>
					                    <a href="{$urls.theme_assets}OtherFile/Azai-RingSizeguide.pdf">
					              </object>-->
					              <img class="sizes-chart-ring container-images" src="{$urls.theme_assets}OtherFile/azai-ring-size-chart.jpg" width="100%" height="100%" />
						    </div>
						   </div>
						</div>
                        <script type="text/javascript">
                          console.log('Size Chart Jewelry');
                        </script>
                    {elseif ($product->category == 'bags') or ($product->category == 'necklaces') or ($product->category == 'jewelry-necklaces') or ($product->category == 'earrings') or ($product->category == 'jewelry-earrings') or ($product->category == 'bracelets') or ($product->category == 'jewelry-bracelets') or ($product->category == 'hats') or ($product->category == 'brooches') or ($product->category == 'clutches-crossbody-bags')}
                        <script type="text/javascript">
                          console.log('Categorias sin Size-chart');
                        </script>
                    {else}
                        <script type="text/javascript">
                          console.log('Cualquier otra categoria');
                        </script>
                        <!-- Sizechard -->
						<span class="size-chart-container" data-toggle="modal" data-target="#sizechartmodal"><a class="sizes-chart" href="#sizechartmodal">{l s='Sizes chart'}</a></span>

						<!-- Modal -->
						<div class="modal fade" id="sizechartmodal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
						  <div class="modal-dialog modal-dialog-centered" role="document">
						    <div class="modal-content">
						      
								<div class="container-woman-size-chart"><center>
									<h2>Azai Size Chart</h2>
									<h5>APPAREL</h5>
									</center>
									<ul class="tabs">
									<li class="tab-link current"><a href="#tab-1">IN / LB</a></li>
									<li class="tab-link"><a href="#tab-2">CM / KG</a></li>
									</ul>
									<div id="tab-1" class="tab-content current"><!-- TABLE IN / LB -->
									<div class="table-zchart">
									<table>
									<tbody>
									<tr><th colspan="2" align="center">SIZES</th><th>BUST</th><th>WAIST</th><th>HIP</th></tr>
									<!-- ROW XS -->
									<tr class="row-even">
									<td rowspan="2">XS</td>
									<td class="no-border">0</td>
									<!-- DATA SIZE -->
									<td>33"</td>
									<!-- DATA BUST -->
									<td>26"</td>
									<!-- DATA WAIST -->
									<td>36"</td>
									<!-- DATA HIP --></tr>
									<tr class="row-even">
									<td class="no-border">2</td>
									<!-- DATA SIZE -->
									<td>34"</td>
									<!-- DATA BUST -->
									<td>27"</td>
									<!-- DATA WAIST -->
									<td>37"</td>
									<!-- DATA HIP --></tr>
									<!-- ROW S -->
									<tr class="row-odd">
									<td rowspan="2">S</td>
									<td class="no-border">4</td>
									<!-- DATA SIZE -->
									<td>35"</td>
									<!-- DATA BUST -->
									<td>28"</td>
									<!-- DATA WAIST -->
									<td>38"</td>
									<!-- DATA HIP --></tr>
									<tr class="row-odd">
									<td class="no-border">6</td>
									<!-- DATA SIZE -->
									<td>36"</td>
									<!-- DATA BUST -->
									<td>29"</td>
									<!-- DATA WAIST -->
									<td>39"</td>
									<!-- DATA HIP --></tr>
									<!-- ROW M -->
									<tr class="row-even">
									<td rowspan="2">M</td>
									<td class="no-border">8</td>
									<!-- DATA SIZE -->
									<td>37"</td>
									<!-- DATA BUST -->
									<td>30"</td>
									<!-- DATA WAIST -->
									<td>40"</td>
									<!-- DATA HIP --></tr>
									<tr class="row-even">
									<td class="no-border">10</td>
									<!-- DATA SIZE -->
									<td>38"</td>
									<!-- DATA BUST -->
									<td>31"</td>
									<!-- DATA WAIST -->
									<td>41"</td>
									<!-- DATA HIP --></tr>
									<!-- ROW L -->
									<tr class="row-odd">
									<td rowspan="2">L</td>
									<td class="no-border">12</td>
									<!-- DATA SIZE -->
									<td>39.5"</td>
									<!-- DATA BUST -->
									<td>32.5"</td>
									<!-- DATA WAIST -->
									<td>42.5"</td>
									<!-- DATA HIP --></tr>
									<tr class="row-odd">
									<td class="no-border">14</td>
									<!-- DATA SIZE -->
									<td>41"</td>
									<!-- DATA BUST -->
									<td>34"</td>
									<!-- DATA WAIST -->
									<td>44"</td>
									<!-- DATA HIP --></tr>
									<!-- ROW XL -->
									<tr class="row-even">
									<td rowspan="2">XL</td>
									<td class="no-border">16</td>
									<!-- DATA SIZE -->
									<td>43"</td>
									<!-- DATA BUST -->
									<td>36"</td>
									<!-- DATA WAIST -->
									<td>46"</td>
									<!-- DATA HIP --></tr>
									<tr class="row-even">
									<td class="no-border">18</td>
									<!-- DATA SIZE -->
									<td>45"</td>
									<!-- DATA BUST -->
									<td>38"</td>
									<!-- DATA WAIST -->
									<td>48"</td>
									<!-- DATA HIP --></tr>
									<tr><th colspan="2" align="center">SIZES</th><th>BUST</th><th>WAIST</th><th>HIP</th></tr>
									</tbody>
									</table>
									</div>
									</div>
									<div id="tab-2" class="tab-content"><!-- TABLE CM / KG -->
									<div class="table-zchart">
									<table>
									<tbody>
									<tr><th colspan="2" align="center">SIZES</th><th>BUST</th><th>WAIST</th><th>HIP</th></tr>
									<!-- ROW XS -->
									<tr class="row-even">
									<td rowspan="2">XS</td>
									<td class="no-border">0</td>
									<!-- DATA SIZE -->
									<td>83.8 cm</td>
									<!-- DATA BUST -->
									<td>66 cm</td>
									<!-- DATA WAIST -->
									<td>91.4 cm</td>
									<!-- DATA HIP --></tr>
									<tr class="row-even">
									<td class="no-border">2</td>
									<!-- DATA SIZE -->
									<td>86.4 cm</td>
									<!-- DATA BUST -->
									<td>68.6 cm</td>
									<!-- DATA WAIST -->
									<td>94 cm</td>
									<!-- DATA HIP --></tr>
									<!-- ROW S -->
									<tr class="row-odd">
									<td rowspan="2">S</td>
									<td class="no-border">4</td>
									<!-- DATA SIZE -->
									<td>88.9 cm</td>
									<!-- DATA BUST -->
									<td>71.1 cm</td>
									<!-- DATA WAIST -->
									<td>96.5 cm</td>
									<!-- DATA HIP --></tr>
									<tr class="row-odd">
									<td class="no-border">6</td>
									<!-- DATA SIZE -->
									<td>91.4 cm</td>
									<!-- DATA BUST -->
									<td>73.7 cm</td>
									<!-- DATA WAIST -->
									<td>99.1 cm</td>
									<!-- DATA HIP --></tr>
									<!-- ROW M -->
									<tr class="row-even">
									<td rowspan="2">M</td>
									<td class="no-border">8</td>
									<!-- DATA SIZE -->
									<td>94 cm</td>
									<!-- DATA BUST -->
									<td>76.2 cm</td>
									<!-- DATA WAIST -->
									<td>101.6 cm</td>
									<!-- DATA HIP --></tr>
									<tr class="row-even">
									<td class="no-border">10</td>
									<!-- DATA SIZE -->
									<td>96.5 cm</td>
									<!-- DATA BUST -->
									<td>78.7 cm</td>
									<!-- DATA WAIST -->
									<td>104.1 cm</td>
									<!-- DATA HIP --></tr>
									<!-- ROW L -->
									<tr class="row-odd">
									<td rowspan="2">L</td>
									<td class="no-border">12</td>
									<!-- DATA SIZE -->
									<td>100.3 cm</td>
									<!-- DATA BUST -->
									<td>82.6 cm</td>
									<!-- DATA WAIST -->
									<td>108 cm</td>
									<!-- DATA HIP --></tr>
									<tr class="row-odd">
									<td class="no-border">14</td>
									<!-- DATA SIZE -->
									<td>104.1 cm</td>
									<!-- DATA BUST -->
									<td>86.4 cm</td>
									<!-- DATA WAIST -->
									<td>111.8 cm</td>
									<!-- DATA HIP --></tr>
									<!-- ROW XL -->
									<tr class="row-even">
									<td rowspan="2">XL</td>
									<td class="no-border">16</td>
									<!-- DATA SIZE -->
									<td>109.2 cm</td>
									<!-- DATA BUST -->
									<td>91.4 cm</td>
									<!-- DATA WAIST -->
									<td>116.8 cm</td>
									<!-- DATA HIP --></tr>
									<tr class="row-even">
									<td class="no-border">18</td>
									<!-- DATA SIZE -->
									<td>114.3 cm</td>
									<!-- DATA BUST -->
									<td>96.5 cm</td>
									<!-- DATA WAIST -->
									<td>121.9 cm</td>
									<!-- DATA HIP --></tr>
									<tr><th colspan="2" align="center">SIZES</th><th>BUST</th><th>WAIST</th><th>HIP</th></tr>
									</tbody>
									</table>
									</div>
									</div>
									<p style="font-size: .7em; text-align: center; margin-top: 10px;">With outerwear, choose your true size for the best fit.<br /> All sizes are approximate.</p>
									<!-- container -->
								</div>
						    </div>
						  </div>
						</div>
                  {/if}
  <!-- End Size Chart Dinamic -->


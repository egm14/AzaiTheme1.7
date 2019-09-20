<form name="savecgma" id="savecgma" method="POST">
    <input type="hidden" name="actionsavecgma" value="savesavecgma" />
    <div style="padding:15px; background:#FFF;">
        <div class="bootstrap">
            <div class="alert alert-info">
                {l s='Define minimal order amount for each Customer group below. If you dont want to define it - use 0 as minimal amount' mod='cgma'}
            </div>
            <table style="width:100%;">
                {foreach Group::getGroups(Configuration::get('PS_LANG_DEFAULT')) as $group}
                    <tr>
                        <td style="padding:5px; text-align:right;">
                        {$group.name}:
                        </td>
                        <td style="padding:5px;"> 
                            <div class="input-group fixed-width-lg">
    				            <span class="input-group-addon">{$currency->sign}</span>
    				            <input type="text" name="CustomerGroup[{$group.id_group}]" value="{if cgma::getGroupValue($group.id_group)==false}0{else}{cgma::getGroupValue($group.id_group)}{/if}"/>
    				        </div>
                        </td>
                    </tr>
                {/foreach}
                    <tr>
                        <td style="padding:5px; text-align:right;">
                            {l s='Tax included' mod='cgma'}
                        </td>
                        <td style="padding:5px;"> 
                            <select class=" fixed-width-xl" id="cgma_tax" name="cgma_tax">
                                <option value="1" {if Configuration::get('cgma_tax')==1}selected="selected"{/if}>
                                    {l s='Yes' mod='cgma'}
                                </option>
                                <option value="0" {if Configuration::get('cgma_tax')!=1}selected="selected"{/if}>
                                    {l s='No' mod='cgma'}
                                </option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:5px; text-align:right;">
                            {l s='Allow free orders' mod='cgma'}
                        </td>
                        <td style="padding:5px;"> 
                            <select class=" fixed-width-xl" id="cgma_free" name="cgma_free">
                                <option value="1" {if Configuration::get('cgma_free')==1}selected="selected"{/if}>
                                    {l s='Yes' mod='cgma'}
                                </option>
                                <option value="0" {if Configuration::get('cgma_free')!=1}selected="selected"{/if}>
                                    {l s='No' mod='cgma'}
                                </option>
                            </select>
                        </td>
                    </tr>
            </table>
            
            <div style="clear:both; display:block; overflow:hidden;">
                <button type="submit" class="btn btn-default pull-right" name="submitOptionsconfiguration"><i class="process-icon-save"></i>{l s='Save' mod='cgma'}</button>
            </div>
        </div>
    </div>
</form>
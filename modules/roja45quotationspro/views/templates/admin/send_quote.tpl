{*
* 2016 ROJA45
* All rights reserved.
*
* DISCLAIMER
*
* Changing this file will render any support provided by us null and void.
*
*  @author 			Roja45
*  @copyright  		2016 Roja45
*  @license          /license.txt
*}

<table class="table table-mail" width="100%" style="width:100%;margin-top:10px;-moz-box-shadow:0 0 5px #afafaf;-webkit-box-shadow:0 0 5px #afafaf;-o-box-shadow:0 0 5px #afafaf;box-shadow:0 0 5px #afafaf;filter:progid:DXImageTransform.Microsoft.Shadow(color=#afafaf,Direction=134,Strength=5)">
    <tbody>
    <tr>
        <td id=bodyCell style="BORDER-COLLAPSE: collapse" vAlign=top align=center>
            <table width="800" id=templateContainer cellSpacing=0 cellPadding=0 border=0>
                <tbody>
                <tr>
                    <td align="center" style="padding:7px 0">
                        <table class="table" bgcolor="#ffffff" style="width:100%">
                            <tr>
                                <td colspan=2 align="left" class="logo" style="border-bottom:4px solid #333333;padding:7px 0;width:66.66%;">
                                    <a title="{$shop_name}" href="{$shop_url}" style="color:#337ff1">
                                        <img src="{$shop_logo}" alt="{$shop_name}" />
                                    </a>
                                </td>
                                <td colspan=1 align="center" style="border-bottom:4px solid #333333;padding:7px 0;width:33.33%;">
                                    <p style="font-family: Helvetica, 'Open Sans', Arial, sans-serif;border:0;margin:3px 0 7px;font-weight:700;font-size:14px;padding-bottom:10px">{l s='Reference:' mod='roja45quotationspro'} {$quotation_reference}</p>
                                    <p style="font-family: Helvetica, 'Open Sans', Arial, sans-serif;border:0;margin:3px 0 7px;font-weight:700;font-size:14px;padding-bottom:10px">{l s='Date:' mod='roja45quotationspro'} {$date_now_formatted}</p>
                                </td>
                            </tr>
                        </table>
                        <table class="table" bgcolor="#ffffff" style="width:100%">
                            <tr>
                                <td align="left" class="titleblock" style="padding:7px 0">
                                    <h1 style="font-family: Helvetica, 'Open Sans', Arial, sans-serif;border:0;margin:3px 0 7px;font-weight:700;font-size:18px;padding-bottom:10px">{l s='Dear %1$s %2$s' sprintf=[$customer_firstname, $customer_lastname] mod='roja45quotationspro'}</h1>
                                </td>
                            </tr>
                            <tr>
                                <td class="linkbelow" style="padding:7px 0">
                                    <p style="font-family: Helvetica, 'Open Sans', Arial, sans-serif;border:0;margin:3px 0 7px;font-weight:500;font-size:14px;padding-bottom:10px">{l s='Many thanks for your request.' mod='roja45quotationspro'}</p>
                                    <p style="font-family: Helvetica, 'Open Sans', Arial, sans-serif;border:0;margin:3px 0 7px;font-weight:500;font-size:14px;padding-bottom:10px">{l s='We are pleased to provide below our quotation for the items you requested.' mod='roja45quotationspro'}</p>
                                </td>
                            </tr>
                        </table>
                        {if isset($include_account) && $include_account}
                        {include file='./send_quote_account.tpl'}
                        {/if}
                        {include file='./quote_template.tpl'}
                        <table class="table" bgcolor="#ffffff" style="border: 0;width:100%">
                            <tr>
                                <td border="0" align="left" class="titleblock" style="padding:5px"></td>
                            </tr>
                        </table>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width="25%" style="border-top:1px solid #D6D4D4;border-bottom:1px solid #D6D4D4;">
                                </td>
                                <td width="50%" style="border-top:1px solid #D6D4D4;border-bottom:1px solid #D6D4D4;">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td align="center" style="font-family: Helvetica, 'Open Sans', Arial, sans-serif;border-bottom:1px solid #D6D4D4;margin:3px 0 7px;font-weight:500;font-size:14px;padding-bottom:10px"><p>{l s='Purchase this quote now by clicking the button below.' mod='roja45quotationspro'}</p></td>
                                        </tr>
                                        <tr>
                                            <td align="center" bgcolor="#000"  aling="center" style="padding: 12px 18px 12px 18px; border-radius:3px"><p><a href="{$purchase_link}" target="_blank" style="font-size: 18px; font-family: Helvetica, Arial, sans-serif; font-weight: normal; color: #ffffff; text-decoration: none; display: inline-block; padding:12px 18px 12px 20px;">{l s='BUY NOW' mod='roja45quotationspro'} &rarr;</a></p></td>
                                        </tr>
                                        <tr>
                                            <td align="center" class="linkbelow" style="font-family: Helvetica, 'Open Sans', Arial, sans-serif;border-bottom:1px solid #D6D4D4;margin:3px 0 7px;font-weight:500;font-size:14px;padding-bottom:10px"><p>{l s='You will need to log in to your account to see the offered price.' mod='roja45quotationspro'}</p></td>
                                        </tr>
                                    </table>
                                </td>
                                <td width="25%" style="border-top:1px solid #D6D4D4;border-bottom:1px solid #D6D4D4;">
                                </td>
                            </tr>
                        </table>
                        <table class="table" bgcolor="#ffffff" style="border: 0;width:100%">
                            <tr>
                                <td border="0" align="left" class="titleblock" style="padding:5px"></td>
                            </tr>
                        </table>
                        <table class="table" bgcolor="#ffffff" style="width:100%">
                            <tr>
                                <td class="linkbelow" style="padding:7px 0">
                                    <p style="font-family: Helvetica, 'Open Sans', Arial, sans-serif;border-bottom:1px solid #D6D4D4;margin:3px 0 7px;font-weight:500;font-size:14px;padding-bottom:10px">{l s='You can find more details regarding this quote the My Quotes section in your account area.' mod='roja45quotationspro'}</p>
                                    <p style="font-family: Helvetica, 'Open Sans', Arial, sans-serif;border-bottom:1px solid #D6D4D4;margin:3px 0 7px;font-weight:500;font-size:14px;padding-bottom:10px">{l s='Log in to the My Quotes section of your account using this link.' mod='roja45quotationspro'} : <a href="{$my_quotes_link}">{l s='My Quotes' mod='roja45quotationspro'}</a></p>
                                    <p style="font-family: Helvetica, 'Open Sans', Arial, sans-serif;border-bottom:1px solid #D6D4D4;margin:3px 0 7px;font-weight:500;font-size:14px;padding-bottom:10px">{l s='If you would like to change the items on your quote you may either email us by replying to this email, with your changes, or create a new quotation request via the website.' mod='roja45quotationspro'}</p>
                                </td>
                            </tr>
                            <tr>
                                <td class="linkbelow" style="padding:7px 0">
                                    <p style="font-family: Helvetica, 'Open Sans', Arial, sans-serif;border-bottom:1px solid #D6D4D4;margin:3px 0 7px;font-weight:500;font-size:14px;padding-bottom:10px">{l s='If you have any questions, please do not hesitate to contact us.' mod='roja45quotationspro'}</p>
                                </td>
                            </tr>
                        </table>
                          <!----------------------------- Start Footer ------------------------>
                <table align="center" class="footer-mail" style="width:100%;margin-top:10px;text-align:center;" >
                  <tbody>
                    <tr><td>
                        <table align="center">
                            <tr>
                                <td align="center" class="footer" style="padding:7px 0;">
                                <img class="slogan" style="height:30px" src="https://azai.com/themes/AzaiShop/mails/mail_element/slogan.png" alt="Live the Azai Experience" />
                                </td>
                            </tr>
                            
                            <tr>
                                <td align="center">
                                    <table>
                                        <tr>
                                            <td>
                                                <a style="padding:0px 5px" href="https://www.facebook.com/azaistore"><img style="height:30px" src="https://azaiwholesale.com/themes/AzaiShop/mails/mail_element/facebook.png" /></a>
                                            </td>
                                            <td>
                                                <a href="https://twitter.com/azaistore" style="padding:0px 5px" ><img style="height:30px" src="https://azaiwholesale.com/themes/AzaiShop/mails/mail_element/instagram.png" /></a>
                                                </td>
                                            <td>
                                                <a href="https://www.instagram.com/azaistore/" style="padding:0px 5px" ><img style="height:30px" src="https://azaiwholesale.com/themes/AzaiShop/mails/mail_element/twitter.png" /></a>
                                                </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td align="center" class="footer" style="padding:0px 7px;">
                                    <table width="300"">
                                        <tr>
                                            <td>
                                                <p style="text-align:center">AZAI Store ,  275 Miracle Mile, Coral Gables, FL 33134, EE.UU.</p>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td align="center">
                                    <table style="font-size:10px">
                                        <tr>
                                            <td>
                                                <a href="{$shop_url}content/3-terms-and-conditions-of-use" alt="" style="padding:0px 5px;color:gray;" >ABOUT US</a>
                                            </td>
                                            <td>
                                                <a href="{$shop_url}content/2-privacy-policies" alt="" style="padding:0px 5px;color:gray;" >PRIVACY POLICY</a>
                                            </td>
                                            <td>
                                                <a href="{$shop_url}content/1-shipping-and-delivery" alt="" style="padding:0px 5px;color:gray;" >SHIPPING INFORMATION</a>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </tr></td>
                    </table>
                  </tbody>
                </table>
                <!----------------------------- End Footer ------------------------>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                </tbody>
            </table>
        </td>
    </tr>
    </tbody>
</table>

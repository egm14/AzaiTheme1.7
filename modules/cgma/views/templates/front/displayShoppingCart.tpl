{*
* PrestaShop module created by VEKIA, a guy from official PrestaShop community ;-)
*
* @author    VEKIA https://www.prestashop.com/forums/user/132608-vekia/
* @copyright 2010-2017 VEKIA
* @license   This program is not free software and you can't resell and redistribute it
*
* CONTACT WITH DEVELOPER
* support@mypresta.eu
*}

<div id="cgma_errors{if isset($smarty.get.cgma)}_pulsate{/if}" class="alert alert-danger" role="alert">
    {$cgma_error nofilter}
</div>
<script>
    var disableCheckout = 1;
    console.log(disableCheckout);
</script>
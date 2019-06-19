<?php 
	$resultado = $_POST['QtyxData'] * $_POST['prodprice'];
	echo number_format($resultado, 2, '.', ',');
?>
<?php
error_reporting(E_ERROR); 
$fs = escapeshellarg($_REQUEST["fs"]);
$output = shell_exec("lfs $fs");
echo "$output";
?>


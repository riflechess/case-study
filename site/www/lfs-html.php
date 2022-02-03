<html>
<head>
<title>lfs</title>
</head>
<style>

table {
    width: 100%;
    border-collapse: collapse;
}
table, td, th {
    border: 0px solid black;
    font: normal 12px Verdana, Arial, sans-serif;
}
th {text-align: left;}
body{
	font: normal 12px Verdana, Arial, sans-serif;
}
form label {
    display: inline-block;
    width: 100px;
}
form input {
    width: 400px;
}


</style>
</head>
<body>
<code>
<?php
error_reporting(E_ERROR); 
$fs = $_REQUEST["fs"];


$output = shell_exec("lfs $fs");
echo "$output";
?>
</code>
</body>


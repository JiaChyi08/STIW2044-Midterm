<?php

$servername = "localhost";

$username = "lowtancq_270964myshopadmin";

$password = ")y+raA3i#@n4";

$dbname = "lowtancq_270964myshopdb";



$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {

die("Connection failed: " . $conn->connect_error);

}

?>
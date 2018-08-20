<?php
$servername = "localhost";
$username = "admin";
$password = "ghfjdddkkk";
$dbname = "foodorder";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
$query_one = "show tables";
$result = $conn -> query($query_one);

if($result-> num_rows > 0)
{
	while($rows = $result->fetch_assoc())
		print_r($rows['Tables_in_foodorder']);
}
print_r($result);
echo "Connected successfully";
echo ("<br/><a href='sessiontest_2.php'>Go to Next</a>");
?>

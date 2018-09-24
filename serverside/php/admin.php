<?php
session_start();
$connection = NULL;
function makeConnection($username, $password)
{
	global $connection;
	$connection = new mysqli("localhost", $username, $password, "foodorder");
	if ($connection -> connect_error)
		session_destroy();
}
$show = false;
function showLog($item)
{
	global $show;
	if ($show)
		echo ($item);
}
$queries = array();
if(isset($_SERVER['QUERY_STRING']))
	parse_str($_SERVER['QUERY_STRING'], $queries);	

if(isset($queries['request']))
{
	//print_r($connection);
	makeConnection($_SESSION['username'], $_SESSION['password']);
	switch($queries['request'])
	{
		case "LOGOUT":
			session_destroy();
			break;
		case "PROMOTION":
			$path = '../../clientside/html/assets/promotional';
			$files = scandir($path);
			echo(json_encode($files));
			break;
		case "FEEDBACK":
			$req = $connection -> query("SELECT feedbackContent, feedbackRate, feedbackDateTime FROM `feedback` where feedbackDateTime > '" . $queries['date'] . "' order by feedbackDateTime asc");
			$rows = [];
			while($row = $req -> fetch_assoc())
				array_push($rows, $row);
			echo(json_encode($rows));
			break;
	}
	
}

elseif(isset($queries['action']))
{
	switch($queries['action'])
	{
	}
}
else //open a connection
{
	$has_session = isset($_SESSION['username']);
	if(!$has_session)
	{
		$_SESSION['username'] = $_POST['username'];
		$_SESSION['password'] = $_POST['password'];
		showLog("Username is " . $_SESSION['username'] . "<br/>");
		showLog("Password is " . $_SESSION['password'] . "<br/>");		
	}
	makeConnection($_SESSION['username'], $_SESSION['password']);
	if($connection -> connect_error)
		echo(0);
	else
		echo(1);
}
?>

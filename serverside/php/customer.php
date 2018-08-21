<?php
session_start();
$connection = NULL;
function makeConnection()
{
	global $connection;
	$connection = new mysqli("localhost", "customer", "", "foodorder");
	if ($connection -> connect_error)
		die("Connection failed: " . $connection->connect_error);
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
	makeConnection();
	//print_r($connection);
	switch($queries['request'])
	{
		case "ID":
			echo ("ID generator is requested.");
			break;
		case "FIND_ID":
			if (isset($queries['phone_no']))
				$_SESSION['cphone_no'] = $queries['phone_no'];
			else
				$_SESSION['cphone_no'] = "";
			$_SESSION['cname'] = $queries['name'];
			showLog ("ID search by name: ". $_SESSION['cname']. " and " . $_SESSION['cphone_no']. " is requested.");
			$res = $connection -> query("select find_cust_id('" . $_SESSION['cname'] . "' ,'" . $_SESSION['cphone_no'] . "') as id");
			$rows = $res->fetch_assoc();
			$_SESSION['cid'] = $rows['id'];
			echo ($_SESSION['cid']);
			break;
	}
	
}

elseif(isset($queries['action']))
{
	makeConnection();
	switch($queries['action'])
	{
		case "PLACE_ORDER":
			showLog ("Placing of order is performed.");
			break;
		case "SET_NAME":
			showLog ("Name of customer is set. ");
			$_SESSION['cid'] = $_POST['id'];
			$_SESSION['cname'] = $_POST['name'];
			$req = $connection -> query("update customer set customername = '".$_SESSION['cname']."' where customerid = '". $_SESSION['cid'] ."'");
			if($req)
				echo(true);
			else 
				echo (0);
			break;
		case "FEEDBACK":
			showLog ("Feedback of customer is sent.");
			break;
		case "SET_PHONE_NO":
			showLog ("Phone number of customer is set.");
			$_SESSION['cid'] = $_POST['id'];
			$_SESSION['cphone_no'] = $_POST['phone_no'];
			$req = $connection -> query("update customer set customerphoneno = '".$_SESSION['cphone_no']."' where customerid = '". $_SESSION['cid'] ."'");
			if($req)
				echo(true);
			else 
				echo (0);
			break;
			break;
		case "CREATE":
			//print_r($_POST);
			showLog ("Customer info is inserted into database.");
			$res = $connection -> query("insert into customer values('" . $_SESSION['cid'] ."','". $_SESSION['cname']."','".$_SESSION['cphone_no']."')");
			if (!$res)
				echo (0);
			else
				echo (true);
			break;
	}
}
?>

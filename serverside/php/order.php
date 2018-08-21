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
$show = true;
function showLog($item)
{
	global $show;
	if ($show)
		echo ($item);
}
function showpr($item)
{
	global $show;
	if ($show)
		print_r ($item);
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
		case "ORDER":
			if (isset($queries['ready_status']))
			{
				if ($queries['order_id'] === "ALL")
				{
					$res = $connection -> query("select orderid from ordering where orderReadyStatus = " . $queries['ready_status']);
					$rows = array();
					while ($row = $res -> fetch_assoc())
						array_push($rows, $row['orderid']);
					showpr($rows);
				}
			}
			else
			{
				$res = $connection -> query("select * from ordering where orderid = '" . $queries['order_id']. "'");
				$row = $res -> fetch_assoc();
				$res = $connection -> query("select foodid from orderlist where orderid = '" . $queries['order_id']. "'");
				$foodids = array();
				while($rows = $res -> fetch_assoc())
					array_push($foodids, $rows['foodid']);
				$row['foodlistid'] = $foodids;
				echo (json_encode($row));
			}
			break;
	}
	
}

elseif(isset($queries['action']))
{
	makeConnection();
	switch($queries['action'])
	{
		case "UPDATE_ORDER":
			$_SESSION['oid'] = $_POST['order_id'];
			$_SESSION['fid'] = $_POST['food_id'];
			$_SESSION['ofstatus'] = $_POST['status'];
			$req = $connection -> query("update orderlist set orderStatus = '".$_SESSION['ofstatus']."' where foodid = '". $_SESSION['fid'] ."' and orderid = '". $_SESSION['oid'] ."'");
			if($req)
				echo(true);
			else 
				echo (0);
			$req = $connection -> query("select * from orderlist");
			while($row = $req -> fetch_assoc())
				showpr($row);
			showLog ("Update of order is performed.");
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

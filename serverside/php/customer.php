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
			do
			{
				$res = $connection -> query("call generate_id('customer', @id, @isunique)");
				$res = $connection -> query("select @id, @isunique");
				$row = $res -> fetch_assoc();
				if($row['@isunique'] == "0")
					continue;
				echo($row['@id']);
				break;
			} while(true);
			break;
		case "FIND_ID":
			if (isset($queries['phone_no']))
				$_SESSION['cphone_no'] = $queries['phone_no'];
			else
				$_SESSION['cphone_no'] = "";
			$_SESSION['cname'] = $queries['name'];
			$res = $connection -> query("select find_cust_id('" . $_SESSION['cname'] . "' ,'" . $_SESSION['cphone_no'] . "') as id");
			showLog ("ID search by name: ". $_SESSION['cname']. " and " . $_SESSION['cphone_no']. " is requested.");
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
			print_r($_POST);
			$_SESSION['cid'] = $_POST['id'];
			$_SESSION['cname'] = $_POST['name'];
			$_SESSION['cphone_no'] = $_POST['phone_no'];
			if($_SESSION['cphone_no'] === "undefined")
				$_SESSION['cphone_no'] = "";
			$_SESSION['corder'] = $_POST['order'];
			$req = $connection -> query("select insert_customer('" . $_SESSION['cid'] . "', '" . $_SESSION['cname'] . "', '" . $_SESSION['cphone_no'] . "')");
			// if(!$req)
				// echo (mysql_error());
			$order = json_decode($_SESSION['corder']);
			print_r($order);
			$tableno = $order -> tableNo;
			$orderid=file_get_contents("http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/order.php?request=FIND_ID&cid=" . $_SESSION['cid'] . "&tno=" . $tableno);
			$orderlist = $order -> orderFoods;
			for($i = 0; $i < count($orderlist); $i++)
			{
				echo("select add_order('" . $orderid . "', '" . $orderlist[$i] -> foodid . "', " . $orderlist[$i] -> foodquantity . ")");
				if($connection -> query("select add_order('" . $orderid . "', '" . $orderlist[$i] -> foodid . "', " . $orderlist[$i] -> foodquantity . ")"))
					echo("Added");
			}
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
		//$_POST['name'] $_POST['table_no'] $_POST['rate'] $_POST['review'] 
			$res = $connection -> query("call add_feedback('" . $_POST['name'] . "', " . $_POST['table_no'] . ", " . $_POST['rate'] . ", '" . $_POST['review'] . "')");
			if (!$res)
				echo ("call add_feedback('" . $_POST['name'] . "', " . $_POST['table_no'] . ", " . $_POST['rate'] . ", '" . $_POST['review'] . "')");
			else
				echo ("call add_feedback('" . $_POST['name'] . "', " . $_POST['table_no'] . ", " . $_POST['rate'] . ", '" . $_POST['review'] . "')");
				//echo (true);
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
			$res = $connection -> query("insert into customer values('" . $_POST['id'] ."','". $_POST['name']."','".$_POST['phone_no']."')");
			if (!$res)
				echo (0);
			else
				echo (true);
			break;
	}
}
?>

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
	//showpr($connection);
	switch($queries['request'])
	{
		case "UNPAID_ORDERS":
			$res = $connection -> query("select orderid from ordering where tableno = ". $queries['table_no'] ." and ((select creditcardno from receipt where ordering.orderid = receipt.orderid) is NULL or (orderid not in (select orderid from receipt)))");
			$rows = array();
			while ($row = $res -> fetch_assoc())
				array_push($rows, $row['orderid']);
			echo(json_encode($rows));
			showLog ("List of unpaid orders is requested.");
			break;
		case "RECEIPT":
			$res = $connection -> query("select receiptid, receipt.orderid, orderdate, ordertotal, governmenttax, additional, paidTotal from ordering, receipt where receipt.orderid = ordering.orderid and receiptid = '". $queries['receipt_id'] ."'");
			$rows = $res -> fetch_assoc();
			$rows['foods'] = [];
			$res = $connection -> query("select foodname, foodprice, orderQuantity from food, orderlist where food.foodid = orderlist.foodid and orderid = (select orderid from receipt where receiptid = '". $queries['receipt_id'] ."')");
			while($row = $res -> fetch_assoc())
			{
				array_push($rows['foods'], $row);
			}
			echo(json_encode($rows));
			showLog ("Receipt is requested.");
			break;
	}
}

elseif(isset($queries['action']))
{
	makeConnection();
	switch($queries['action'])
	{
		case "RECORD":
			$_SESSION['oid'] = $_POST['order_id'];
			$req = $connection -> query("CALL record_order_as_paid('".$_SESSION['oid']."')");
			if($req)
				echo(true);
			else 
				echo (0);
			$req = $connection -> query("select * from receipt");
			while($row = $req -> fetch_assoc())
				showpr($row);
			showLog ("Receipt recording of order is performed.");
			break;
		case "CANCEL_RECORD":
			$_SESSION['oid'] = $_POST['order_id'];
			$req = $connection -> query("DELETE FROM receipt WHERE orderid = '".$_SESSION['oid']."'");
			if($req)
				echo(true);
			else 
				echo (0);
			$req = $connection -> query("select * from receipt");
			while($row = $req -> fetch_assoc())
				showpr($row);
			showLog ("Receipt unrecording of order is performed.");
			break;
		case "PAY":
			if ($_POST['method'] === "CASH")
				$method = "0";
			else
				$method = $_POST['ccnumber'];
			$req = $connection -> query("UPDATE receipt SET creditcardno = '". $method ."' WHERE orderid = '".$_POST['receipt_id']."'");
			if($req)
				echo(true);
			else 
				echo (0);
			showLog ("Feedback of customer is sent.");
			break;
	}
}
?>

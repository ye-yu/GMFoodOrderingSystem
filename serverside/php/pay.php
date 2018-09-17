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
			if($queries['table_no'] == "0")
				$queries['table_no'] = "is null";
			else
				$queries['table_no'] = " = " . (string)$queries['table_no'];
			$res = $connection -> query("select orderid from ordering where (tableno " . $queries['table_no'] . " and customerid in (select customerid from customer where customer.customerphoneno =  '" . $queries['phone_no'] . "'))and ((select creditcardno from receipt where ordering.orderid = receipt.orderid) is NULL or (orderid not in (select orderid from receipt)))");
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
			$req = $connection -> query("UPDATE receipt SET creditcardno = ". $method ." WHERE orderid = '".$_POST['order_id']."'");
			if($req)
			{
				$req = $connection -> query("select ordering.orderid, ordering.orderdate as orderdate, ordering.ordertotal as ordertotal, receipt.governmenttax as governmenttax, receipt.additional as additional, receipt.paidTotal as paidTotal from ordering,receipt where ordering.orderid = receipt.orderid and ordering.orderid = '" . $_POST['order_id'] . "';");
				$row = $req -> fetch_assoc();
				print_r($row);
				//variables
				$date = $row['orderdate'];
				$total = $row['ordertotal'];
				$gtax = $row['governmenttax'];
				$atax = $row['additional'];
				$paid = $row['paidTotal'];
				
				
				$toWrite = fopen("receipts-" . $_POST['order_id'] . ".txt", "w");
				fwrite($toWrite, "Order ID: " . $_POST['order_id']);
				fwrite($toWrite, "\r\n");
				fwrite($toWrite, "Date: ". $date);
				fwrite($toWrite, "\r\n");
				fwrite($toWrite, "\r\n");
				
				$req = $connection -> query("select foodname, foodprice, orderQuantity from food, orderlist where food.foodid = orderlist.foodid and orderid = '" . $_POST['order_id']. "'");
				
				$counter = 0;
				while($row = $req -> fetch_assoc())
				{
					$counter++;
					fwrite($toWrite, $counter . ". " . $row['foodname'] . " (RM " . $row['foodprice'] . ") x " . $row['orderQuantity']);
					fwrite($toWrite, "\r\n");
				}

				fwrite($toWrite, "Subtotal (Before tax): RM". $total);
				fwrite($toWrite, "\r\n");
				fwrite($toWrite, "Government Tax: ". $gtax . "%");
				fwrite($toWrite, "\r\n");
				fwrite($toWrite, "Service Tax: ". $atax . "%");
				fwrite($toWrite, "\r\n");
				fwrite($toWrite, "Total (After tax): RM". $paid);
				fwrite($toWrite, "\r\n");
				
				if($method === '0')
				{
					fwrite($toWrite, "Received: RM". $_POST['received']);
					fwrite($toWrite, "\r\n");
					$balance = (float)$_POST['received'] - (float)$paid;
					fwrite($toWrite, "Return: RM". round($balance,2));
					fwrite($toWrite, "\r\n");
				}
				else
				{
					fwrite($toWrite, "Paid with card.");
					fwrite($toWrite, "\r\n");
				}
				fclose($toWrite);
				echo(true);
			}
			else 
				echo (0);
			break;
		case "INVOICE":
			$res = $connection -> query("update diningtable set tableStatus = 'In Queue' where tableno = ". $_POST['table_no']);
			$res = $connection -> query("SELECT DEFAULT(governmenttax) as gtax FROM (SELECT 1) AS dummy LEFT JOIN receipt ON True LIMIT 1;");
			$row = $res -> fetch_assoc();
			$gtax = (int)$row['gtax'];
			$res = $connection -> query("SELECT DEFAULT(additional) as atax FROM (SELECT 1) AS dummy LEFT JOIN receipt ON True LIMIT 1;");
			$row = $res -> fetch_assoc();
			$atax = (int)$row['atax'];
			
			//get list of order ids
			$res = $connection -> query("select orderid, ordertotal from ordering where (tableno = " . $_POST['table_no'] . " and customerid in (select customerid from customer where customer.customerphoneno =  ''))and ((select creditcardno from receipt where ordering.orderid = receipt.orderid) is NULL or (orderid not in (select orderid from receipt)))");
			$invoices = [];
			array_push($invoices, []);
			$invoices[0]['gtax'] = $gtax;
			$invoices[0]['atax'] = $atax;
			$counter = 1;
			while($row = $res -> fetch_assoc())
			{
				array_push($invoices, []);
				$invoices[$counter]['orderid'] = $row['orderid'];
				$invoices[$counter]['subtotal'] = (float)$row['ordertotal'];
				$invoices[$counter]['total'] = round(($invoices[$counter]['subtotal']) * (100 + $gtax + $atax) / 100, 2);
				$invoices[$counter]['foods'] = [];
				$counter++;
			}
			
			$toWrite = fopen("invoice-table". $_POST['table_no'] .".txt", "w");
			fwrite($toWrite, "Table number: " . $_POST['table_no']);
			fwrite($toWrite, "\r\n");
			fwrite($toWrite, "\r\n");
			fwrite($toWrite, "All items are inclusive of government tax and service tax of ");
			fwrite($toWrite, "\r\n");
			fwrite($toWrite, $gtax . "% and " . $atax . "% respectively.");
			fwrite($toWrite, "\r\n");
			fwrite($toWrite, "-----------------------------------------------------------------");
			fwrite($toWrite, "\r\n");
			fwrite($toWrite, "\r\n");
			for($i = 1; $i < count($invoices); $i++)
			{
				fwrite($toWrite, "Order Number: " . $i);
				fwrite($toWrite, "\r\n");
				$res = $connection -> query("select foodname, foodprice, orderQuantity from food, orderlist where food.foodid = orderlist.foodid and orderid = '" . $invoices[$i]['orderid'] . "'");
				$counter = 0;
				while($row = $res -> fetch_assoc())
				{
					$counter++;
					fwrite($toWrite, $counter . ". " . $row['foodname'] . " (RM " . $row['foodprice'] . ") x " . $row['orderQuantity']);
					fwrite($toWrite, "\r\n");
					// array_push($invoices[$i]['foods'], [
						// "foodname" => $row["foodname"],
						// "foodprice" => $row["foodprice"],
						// "orderQuantity" => $row["orderQuantity"]
					// ]);
				}
				fwrite($toWrite, "Subtotal: RM" . number_format($invoices[$i]['subtotal'], 2));
				fwrite($toWrite, "\r\n");
				fwrite($toWrite, "Total: RM" . number_format($invoices[$i]['total'], 2));
				fwrite($toWrite, "\r\n");
				fwrite($toWrite, "\r\n");
			fwrite($toWrite, "-----------------------------------------------------------------");
			fwrite($toWrite, "\r\n");
				fwrite($toWrite, "\r\n");
			}
			fwrite($toWrite, "Please present this ticket to the counter during payment.");
			fwrite($toWrite, "\r\n");
			fclose($toWrite);
			break;
	}
}
?>

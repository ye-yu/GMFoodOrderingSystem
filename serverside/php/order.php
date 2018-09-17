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
			do
			{
				$res = $connection -> query("call generate_id('". $queries['from'] ."', @id, @isunique)");
				$res = $connection -> query("select @id, @isunique");
				$row = $res -> fetch_assoc();
				if($row['@isunique'] == "0")
					continue;
				echo($row['@id']);
				break;
			} while(true);
			break;
		case "FIND_ID":
			$res = $connection -> query("select find_order_id_from_table('". $queries['cid'] ."', ". $queries['tno'] .") as id");
			$row = $res -> fetch_assoc();
			echo($row['id']);
			break;
		case "ORDER":
			if (isset($queries['unpaid']))
			{
				if ($queries['order_id'] === "ALL")
				{
					$res = $connection -> query("select orderid from ordering where orderReadyStatus = FALSE and orderid not in (select orderid from receipt)");
					$rows = array();
					while ($row = $res -> fetch_assoc())
						array_push($rows, $row['orderid']);
					echo(json_encode($rows));
				}
			}
			else
			{
				$res = $connection -> query("select * from ordering where orderid = '" . $queries['order_id']. "'");
				$row = $res -> fetch_assoc();
				$res = $connection -> query("select foodname, foodprice, orderQuantity from food, orderlist where food.foodid = orderlist.foodid and orderid = '" . $queries['order_id']. "'");
				$foodids = [];
				while($rows = $res -> fetch_assoc())
				{
					$assocarr = [
						"foodname" => $rows['foodname'],
						"foodprice" => $rows['foodprice'],
						"quantity" => $rows['orderQuantity']
					];
					array_push($foodids, $assocarr);
				}
				$row['foodlist'] = $foodids;
				echo (json_encode($row));
			}
			break;
		case "ORDERED_FOOD_LIST":
			$res = $connection -> query("SELECT entryno, case when tableno is null then concat('Phone no: ', customer.customerphoneno) else concat('Table no: ', cast(tableno as char)) end as orderinfo, food.foodname, ordering.orderdate ,orderlist.orderQuantity FROM `ordering`, orderlist, food, customer where customer.customerid = ordering.customerid and food.foodid = orderlist.foodid and ordering.orderid = orderlist.orderid and ((ordering.orderid not in (select orderid from receipt)) or (`ordering`.`tableno` is null and ordering.orderid in (select orderid from receipt))) and orderlist.orderStatus != 'Prepared' and entryno > " . $queries['last_entry_no'] . " order by orderdate ASC");
			$rows = [];
			while($row = $res -> fetch_assoc())
				array_push($rows, $row);
			echo(json_encode($rows));
			break;
		case "STATUS_FROM_TABLE":
			$noOfCustomer = (int)$queries['no_of_cust'];
			$custs = [];
			for($i = 0; $i < $noOfCustomer; $i++)
			{
				$custs[$queries['table_no'] . " " . ($i + 1)] = [];
				$res = $connection -> query("select foodname, orderQuantity as foodquantity, orderStatus as foodstatus from orderlist, food where food.foodid = orderlist.foodid and orderid = (SELECT `orderid` FROM ordering where orderid not in (select orderid from receipt) and customerid = (select customerid from customer where customername = '" . $queries["table_no"] . " " . ($i + 1) ."'));");
				if($res)
				{
					while($rows = $res -> fetch_assoc())
					array_push($custs[$queries['table_no'] . " " . ($i + 1)], $rows);
				}
			}
			echo(json_encode($custs));
			break;
		case "TOTAL":
			$res = $connection -> query("select orderTotal from ordering where orderid = '" . $queries['order_id']. "'");
			$row = $res -> fetch_assoc();
			echo($row['orderTotal']);
			break;
		case "STATUS":
			$res = $connection -> query("select orderReadyStatus from ordering where orderid = '" . $queries['order_id']. "'");
			$row = $res -> fetch_assoc();
			echo($row['orderReadyStatus']);
			break;
		case "FOOD":
			if ($queries['food_id'] === "ALL")
			{
				if(isset($queries['group_by']))
				{
					$res = $connection -> query("SELECT `foodtype` FROM `food` GROUP BY foodtype");
					$row = [];
					while($rows = $res -> fetch_assoc())
					{
						$row[$rows['foodtype']] = [];
					}
					$res = $connection -> query("SELECT * FROM `food`");
					while($rows = $res -> fetch_assoc())
					{
						array_push($row[$rows['foodtype']], $rows);
					}
				}
				else
				{
					$res = $connection -> query("select * from food");
					$row = [];
					while($rows = $res -> fetch_assoc())
					{
						array_push($row, $rows);
					}
				}
				//print_r($row);
			}
			else
			{
				$res = $connection -> query("select * from food where foodid = '" . $queries['food_id']. "'");
				$row = $res -> fetch_assoc();
			}
			echo(json_encode($row));
			break;
	}
}

elseif(isset($queries['action']))
{
	makeConnection();
	switch($queries['action'])
	{
		case "UPDATE_ORDER":
			$_SESSION['eno'] = $_POST['entry_no'];
			$_SESSION['ofstatus'] = $_POST['status'];
			$req = $connection -> query("update orderlist set orderStatus = '".$_SESSION['ofstatus']."' where entryno = '". $_SESSION['eno'] ."'");
			if($req)
				echo(true);
			else 
				echo (0);
			$req = $connection -> query("select * from orderlist");
			while($row = $req -> fetch_assoc())
				showpr($row);
			showLog ("Update of order is performed.");
			break;
	}
}
?>

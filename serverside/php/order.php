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
				$res = $connection -> query("select foodid, orderQuantity from orderlist where orderid = '" . $queries['order_id']. "'");
				$foodids = [];
				while($rows = $res -> fetch_assoc())
					$foodids[$rows['foodid']] = $rows['orderQuantity'];
				$row['foodlistid'] = $foodids;
				echo (json_encode($row));
			}
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
						$row[$rows['foodtype']] = array();
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
					$row = array();
					while($rows = $res -> fetch_assoc())
					{
						array_push($row, $rows);
					}
				}
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
	}
}
?>

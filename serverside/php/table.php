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
		case "STATUS":
			$row = NULL;
			if(isset($queries['seat_size']))
			{
				$res = $connection -> query("select tableno from diningtable where seatQuantity >= " . $queries['seat_size'] . " order by seatQuantity asc");
				$rows = $res -> fetch_assoc();
				$row = $rows['tableno'];
				
			}
			else if(isset($queries['table_no']))
			{
				$res = $connection -> query("select tableStatus from diningtable where tableno = " . $queries['table_no']);
				$rows = $res -> fetch_assoc();
				$row = $rows['tableStatus'];
			}
			echo($row);
			break;
		case "BILLING":
		{
			$res = $connection -> query("select tableno from diningtable where tablestatus = 'Billing'");
			$rows = [];
			while($row = $res -> fetch_assoc())
			{
				array_push($rows, $row['tableno']);
			}
			echo (json_encode($rows));
			break;
		}
		case "WAITER":
		{
			$res = $connection -> query("select tableno from diningtable where tablestatus = 'Waiter'");
			$rows = [];
			while($row = $res -> fetch_assoc())
			{
				array_push($rows, $row['tableno']);
			}
			echo (json_encode($rows));
		}
	}
	
}

elseif(isset($queries['action']))
{
	makeConnection();
	switch($queries['action'])
	{
		case "RESERVE":
			if(isset($_POST['table_no']))
			{
				$req = $connection -> query("select tableno from diningtable where seatQuantity >= " . $_POST['no_of_cust'] . " and tableno = ". $_POST['table_no']);
				$rows = $req -> fetch_assoc();
				if($_POST['table_no'] != $rows['tableno'])
					echo(0);
				else
				{
					$req = $connection -> query("update diningtable set tableStatus = 'Req " . $_POST['no_of_cust'] . "' where tableno = ". $_POST['table_no']);
					echo($rows['tableno']);
				}
				break;
			}
			$req = $connection -> query("select reserve_table(".$_POST['no_of_cust'].") as tableno");
			if($req)
			{
				$rows = $req -> fetch_assoc();
				echo($rows['tableno']);
			}
			else 
				echo (0);
			break;
		case "UNRESERVE":
			if(isset($_POST['table_no']))
			{
				$req = $connection -> query("update diningtable set tableStatus = 'Ready' where tableno = ". $_POST['table_no']);
			}
			else if(isset($_POST['order_id']))
			{
				$req = $connection -> query("update diningtable set tableStatus = 'Paid' where tableno = (select tableno from ordering where orderid = '" . $_POST['order_id'] . "')");
			}
			if($req)
				echo(true);
			else 
				echo (0);
			break;
		case "WAITER":
			$req = $connection -> query("update diningtable set tableStatus = 'Waiter' where tableno = ". $_POST['table_no']);
			if($req)
				echo(true);
			else 
				echo (0);
			break;
		case "BILLING":
			$req = $connection -> query("update diningtable set tableStatus = 'Billing' where tableno = ". $_POST['table_no']);
			if($req)
				echo(true);
			else 
				echo (0);
			break;
		case "QUEUE":
			$req = $connection -> query("update diningtable set tableStatus = 'In Queue' where tableno = ". $_POST['table_no']);
			if($req)
				echo(true);
			else 
				echo (0);
			break;
		case "PAID":
			$req = $connection -> query("update diningtable set tableStatus = 'Paid' where tableno = ". $_POST['table_no']);
			if($req)
				echo(true);
			else 
				echo (0);
			break;
	}
}
?>

var orderandfoodlist = [];
var waitinglist = [];
var preparing = [];
var prepared = [];
var checkfoodlist = setInterval(function(){
	sendRequest(
		'GET',
		'',
		'http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/order.php?request=ORDERED_FOOD_LIST',
		function(a){
			orderandfoodlist = JSON.parse(a);
			updatefoodlist();
		}
	);
	sendRequest(
		'GET',
		'',
		'http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/table.php?request=WAITER',
		function(a){
			waitinglist = JSON.parse(a);
			updatetablelist();
		}
	);
}, 5000);

var _parent = null;
function preparingFood(eno)
{
	//send request to update food status
	sendRequest(
		'POST',
		'entry_no=' + eno + "&status=Preparing",
		'http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/order.php?action=UPDATE_ORDER',
		function(a){
			console.log(a);
		}
	);
	//
	console.log("This food is being prepared.");
	var pb = document.getElementById('p' + eno);
	pb.style = "background-color: #ddefaa;";
	pb.disabled = true;
	var db = document.getElementById('d' + eno);
	db.disabled = false;
	preparing.push(eno);
}

function donePreparingFood(eno)
{
	sendRequest(
		'POST',
		'entry_no=' + eno + "&status=Prepared",
		'http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/order.php?action=UPDATE_ORDER',
		function(a){
			console.log(a);
		}
	);
	prepared.push(eno);
	console.log("This food is done prepared.");
}

function updatetablelist()
{
	var stg = '';
	for(let i = 0; i < waitinglist.length; i++)
		stg += '<button onclick="servetable(this, ' + waitinglist[i] + ');">' + waitinglist[i] + '</button>';
	document.getElementById('table-num').innerHTML = stg;
}

function servetable(ele, tno)
{
	ele.parentElement.removeChild(ele);
	sendRequest(
		'POST',
		'table_no=' + tno,
		'http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/table.php?action=QUEUE',
		function(a){
			console.log(a);
		}
	);
}
function checkEntry(arr, ele)
{
	for(var i = 0; i < arr.length; i++) 
	{
		if(arr[i] === ele)
		{
			return true;
		}
	}
	return false;
}
function resetInterval()
{
	clearInterval(checkfoodlist);
	checkfoodlist = setTimeout(function(){
		sendRequest(
			'GET',
			'',
			'http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/order.php?request=ORDERED_FOOD_LIST',
			function(a){
				orderandfoodlist = JSON.parse(a);
			}
		);
	}, 5000);
}
/*
function isInPreparingAndRemove(oid, fid, qty)
{
	var result = new Tuple(false, false);
	for(let i = 0; i < preparing.length; i++)
	{
		if(preparing[i].x = oid && preparing[i].y = fid)
		{
			result.x = true;
			if(parseInt(preparing[i].z) < parseInt(qty))
			{
				preparing.splice(i, 1);
				result.y = true;
			}
			return result;
		}
	}
	return result;
}*/

function updatefoodlist()
{
	var stg = '';
	for(let i = 0; i < orderandfoodlist.length; i++)
	{
		var isDone = checkEntry(prepared, orderandfoodlist[i].entryno);
		stg += '<tr ordertype="' + orderandfoodlist[i].orderinfo.split(" ")[0] + '">';
		stg += '<td width="35%">' + orderandfoodlist[i].foodname + ' &times; ' + orderandfoodlist[i].orderQuantity + '</td>';
		stg += '<td width="21%">' + orderandfoodlist[i].orderdate + '</td>';
		if(isDone)
			stg += '<td width="21%" style="background-color: #a9dea9;">' + orderandfoodlist[i].orderinfo + '</td>';
		else	
			stg += '<td width="21%">' + orderandfoodlist[i].orderinfo + '</td>';
		if(isDone) //it is inside done
		{
			if(orderandfoodlist[i].orderinfo.split(" ")[0] === "Table")
				stg += '<td><span style=margin:5px>Deliver to Table</span><button class="remove-order-btn">Remove</button></td>';
			else
				stg += '<td><span style=margin:5px>Wrap the Food</span><button class="remove-order-btn">Remove</button></td>';
		}
		else if(checkEntry(preparing, orderandfoodlist[i].entryno)) //it is inside preparing
			stg += '<td width="23%"><button class="preparing-btn" id="p' + orderandfoodlist[i].entryno + '" style="background-color: #ddefaa;" disabled>Preparing ' + orderandfoodlist[i].orderQuantity + '</button><button id="d' + orderandfoodlist[i].entryno + '" class="deliver-btn" onclick="donePreparingFood(\'' + orderandfoodlist[i].entryno + '\');">Done Preparing</button></td>';
		else
			stg += '<td width="23%"><button class="preparing-btn" id="p' + orderandfoodlist[i].entryno + '" onclick="preparingFood(\'' + orderandfoodlist[i].entryno + '\');">Preparing ' + orderandfoodlist[i].orderQuantity + '</button><button id="d' + orderandfoodlist[i].entryno + '" class="deliver-btn" disabled onclick="donePreparingFood(\'' + orderandfoodlist[i].entryno + '\');">Done Preparing</button></td>';
		stg += '</tr>';
	}
	document.getElementById('showfoodlisthere').innerHTML = stg;
}
$(document).ready(function(){
			$(".preparing-btn").click(function(){
			});
});

$(document).ready(function(){
	$("#order-table-body").on("click",".remove-order-btn",function(){
		$(this).parent().parent().remove();
	});
	$("#order-table-body").on("click",".deliver-btn",function(){
		var prevBtn = $(this).parent();
		$("#order-status-btn").empty();
		
		//resetInterval();
		
		let _parent = $(this).parent().parent();
		_parent.children()[2].style = "background-color: #a9dea9;";	
		//setTimeout(function(){_parent.remove();}, 3000);
		// var newContent = '<button class="undo-btn">&lt;&lt;</button><span style=margin:5px>Delivered</span><button class="remove-order-btn">Remove</button></td>';
		if(_parent[0].attributes.ordertype.nodeValue === "Table")
			var newContent = '<span style=margin:5px>Deliver to Table</span></td><button class="remove-order-btn">Remove</button></td>';
		else
			var newContent = '<span style=margin:5px>Wrap the Food</span></td><button class="remove-order-btn">Remove</button></td>';
		prevBtn.html(newContent);
	});	
});

$(document).ready(function(){
	$("#table-num button").click(function(evtObj){
		$(this).animate({ opacity:0.1 },250,function(){
			$(this).remove();
		});
	});

//
	sendRequest(
		'GET',
		'',
		'http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/order.php?request=ORDERED_FOOD_LIST',
		function(a){
			orderandfoodlist = JSON.parse(a);
			updatefoodlist();
		}
	);
	sendRequest(
		'GET',
		'',
		'http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/table.php?request=WAITER',
		function(a){
			waitinglist = JSON.parse(a);
			updatetablelist();
		}
	);
//
});

function check()
{
	console.log("Script is loaded.");
}

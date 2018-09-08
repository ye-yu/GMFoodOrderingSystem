/*
function sendRequest(method,param,url,toSet){
	var ourRequest = new XMLHttpRequest();
	ourRequest.open(method,url);

	ourRequest.onload = function()
	{
		if(ourRequest.readyState== 4 && ourRequest.status == 200)
			{
				toSet(ourRequest.responseText);
				console.log(ourRequest.responseText);
			}
	}
	ourRequest.send(param);
}
*/
function calculateTotal(c){
		this.sendRequest('GET', '', 'http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/order.php?request=TOTAL&order_id=' + c.orderID, function(a){c.orderTotal = a;});
}
	
function loadOrder(c, id)
{
	sendRequest(
		'GET', 
		'', 
		'http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/order.php?request=ORDER&order_id=' + id,
		function(str)
		{
			var j = JSON.parse(str);
			c.orderID = j.orderid;
			c.orderDate = j.orderdate;
			c.orderTotal = j.ordertotal;
			c.orderPickTime = j.orderpickuptime;
			c.tableNo = j.tableno;
			c.orderReadyStatus = j.orderReadyStatus;
			c.orderFoods = j.foodlistid;
		}
	);
}

function getOrderFromDatabase(c)
{
	sendRequest('GET', '', 'http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/order.php?request=ID&from=ordering',
	function(a)
	{ c.orderID = a;}
	);
}

function addMenu(c, food, qty)
	{
		c.orderFoods[food] = qty;
		calculateTotal(c);
	}
	
function removeMenu(c, food)
	{
		var newArr = {};
		for(var x in c.orderFoods)
		if(x != food) newArr[x] = c.orderFoods[x];
		c.orderFoods = newArr;
	}
class Ordering{

	constructor(){
		this.orderID = null;
		this.orderDate = null;
		this.orderTotal = null;
		this.orderPickTime = null;
		this.tableNo = null;
		this.orderFeedback = null;
		this.orderReadyStatus = null;
		this.orderFoods = [];
		var date = new Date();
		this.orderDate = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
	}
}

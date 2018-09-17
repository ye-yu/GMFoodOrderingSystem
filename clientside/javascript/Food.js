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
function getFoodFromDatabase(c)
{
	sendRequest('GET', '', 'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/order.php?request=ID&from=food',
	function(a)
	{ c.orderID = a;}
	);
}

function loadFood(c, id)
{
	sendRequest('GET', '', 'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/order.php?request=FOOD&food_id=' + id, 
	function(a){
		var s = JSON.parse(a);
		c.foodID = id;
		c.foodName = s.foodname;
		c.foodPrice = s.foodprice;
		c.foodType = s.foodtype;
		c.foodDescription = s.fooddescription;
		c.foodImageLink = s.foodimagelink;
	}
	);
}
class Food{
	constructor(){
		this.foodID = null;
		this.foodName = null;
		this.foodPrice = null;
		this.foodType = null;
		this.foodDescription = null;
		this.foodImageLink = null;
    }
}
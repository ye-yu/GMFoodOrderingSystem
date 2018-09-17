function getCustFromDatabase(c)
{
	if(c.phone_no == null)
		var url = 'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/customer.php?request=FIND_ID&name=' + c.custName;
	else
		var url = 'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/customer.php?request=FIND_ID&name=' + c.custName + '&phone_no=' + c.custPhoneNo;
	sendRequest('GET', '', url, function(a){c.custID = a;});
}
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
	if (method == 'POST')
		ourRequest.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
	ourRequest.send(param);
}

class Customer{
	constructor(custName, custPhoneNo){
		this.custName = custName;
		this.custPhoneNo = custPhoneNo;
		this.order = null;
		this.custID = null;
	}
	
	placeOrder(func)
	{
		var param = "";
		param += "id="+this.custID;
		param += "&";
		param += "phone_no="+this.custPhoneNo;
		param += "&";
		param += "name="+this.custName;
		param += "&";
		param += "order="+ JSON.stringify(this.order);
		sendRequest('POST', param, 'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/customer.php?action=PLACE_ORDER', func);
	}
	
	createCustomer()
	{
		var param = "";
		param += "id="+this.custID;
		param += "&";
		param += "phone_no="+this.custPhoneNo;
		param += "&";
		param += "name="+this.custName;
		sendRequest('POST', param, 'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/customer.php?action=CREATE', function(a){console.log(a)});
	}

}

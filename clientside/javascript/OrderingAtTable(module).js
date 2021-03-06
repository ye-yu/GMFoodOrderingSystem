var noOfCustomer = 1;
var tableNumber = 1;
var reserved = false;
var customers = [];
var requestSent = false;
var ordered = false;
var customersWithOrder = {};
var checked = false;
var checkfoodinterval = null;

function sendCheckTableRequest(method,param,url,toSet){
	if(checked)
		return;
	checked = true;
	var ourRequest = new XMLHttpRequest();
	ourRequest.open(method,url);
	ourRequest.onload = function()
	{
		console.log("Checking every 1.5s");
		checked = false;
		if(ourRequest.readyState== 4 && ourRequest.status == 200)
			{
				console.log(ourRequest.responseText);
				var t = ourRequest.responseText;
				if(t.indexOf("Req") > -1)
				{
					toSet(ourRequest.responseText);
				}
			}
	}
	if (method == 'POST')
		ourRequest.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
	ourRequest.send(param);
}

function createCustomer()
{
	if(noOfCustomer == null)
		noOfCustomer = 1;
	var diff = "empty";
	for(var i=0; i < noOfCustomer; i++)
	{
		var a = new Customer;
		a.custName = tableNumber + ' ' + (i+1);
		a.custPhoneNo = '';
		customers.push(a);
		customersWithOrder[a.custName] = [];
		
		console.log("number of customer is " + noOfCustomer);
		console.log(a);
	}
	if(checkfoodinterval !== undefined)
		checkfoodinterval = setInterval(refreshCustomerAndFoodOrderArray, 10000);
}
function waitingOnReservation(){
	sendCheckTableRequest(
		'GET',
		'',
		'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/table.php?request=STATUS&table_no=' + tableNumber,
		function(a)
		{
			reserved = true;
			tableIsReserved(a.replace("Req ", ""));
		}
	);
	if(reserved == false)
		setTimeout(waitingOnReservation,1500);
	// else
		// tableIsReserved();
		//console.log("table is reserved!");
}

function splitTheBillOnClick(split)
{
	if(!split)
		noOfCustomer = 1;
	var e = document.getElementById('custnumbertop');
	e.innerHTML = noOfCustomer;
	saveToCookie();
	displayOrderSummary();
}

function customerButton(n)
{
	if(n.innerHTML == 'Rate &amp; Review')
	{
		$('#rate-modal').val(n.value);
		$('#rate-modal').modal('show');
		document.getElementById('review').value = '';
		console.log("Rate & Review by " + n.value);
		return;
	}
	console.log("Order by " + n.value);
	var theform = document.createElement('form');
	theform.method = 'POST';
	theform.action = 'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/clientside/html/Ordering.php';
	var thevalue = document.createElement('input');
	thevalue.type = 'hidden';
	thevalue.name = 'customer_number';
	thevalue.value = tableNumber + ' ' + n.value;
	theform.appendChild(thevalue);
	var thevalue = document.createElement('input');
	thevalue.type = 'hidden';
	thevalue.name = 'table_number';
	thevalue.value = tableNumber;
	theform.appendChild(thevalue);
	$('body').append(theform);
	saveToCookie();
	theform.submit();
}
function displayOrderSummary()
{
	document.getElementById('cust-order-summary').innerHTML = '';
	for(var i = 0; i < noOfCustomer; i++)
	{
		var parent_a = document.getElementById('cust-order-summary');
			var child_a = document.createElement('div');
				var child_a_a = document.createElement('span');
				child_a_a.className = "customername";
				child_a_a.innerHTML = "Customer " + (i + 1);
				child_a.appendChild(child_a_a);

				var child_a_b = document.createElement('span');
				child_a_b.className = "ordernow";
					var child_a_b_a = document.createElement('button');
					var cnumber = (i + 1) + "";
					child_a_b_a.id = 'customerbutton-' + cnumber;
					child_a_b_a.value = cnumber;
					child_a_b_a.innerHTML = 'Order Now';
					child_a_b.appendChild(child_a_b_a);
				child_a.appendChild(child_a_b);
			parent_a.appendChild(child_a);

			var child_b = document.createElement('div');
			child_b.className = "orderlist";
			child_b.id = "orderlist";
			
			var foodArray = customersWithOrder[customers[i].custName];
			for(var j = 0;j < foodArray.length; j++)
			{
				var child_b_a = document.createElement('hr');
				child_b_a.className = "orderdividor";
				child_b.appendChild(child_b_a);
				
				var child_b_b = document.createElement('span');
				child_b_b.className = "foodname";
				child_b_b.innerHTML = (j + 1) + ". " + foodArray[j]['foodname'];
				child_b.appendChild(child_b_b);
				
				var child_b_c = document.createElement('span');
				child_b_c.className = "foodquantity";
				child_b_c.innerHTML = "&times; " + foodArray[j]['foodquantity'];
				child_b.appendChild(child_b_c);
				
				var child_b_d = document.createElement('span')
				child_b_d.className = "foodstatus";
				child_b_d.id = "orderstatus-" + (i + 1) + "-" + (j + 1); //i is the customer number, j is the food number
				child_b_d.innerHTML = foodArray[j]['foodstatus'];
				child_b.appendChild(child_b_d);
			}
			parent_a.appendChild(child_b);
			var child_c = document.createElement('hr');
			child_c.className = "customerdividor";
			parent_a.appendChild(child_c);
			
	}
	for(var i = 0; i < noOfCustomer; i++)
	{
		$('#customerbutton-' + (i + 1)).click(
			function()
			{
				customerButton(this);
			}
		);
	}
	console.log("Displying order summary");
}

function fadeFirstLayer()
{
	var op = 1;  // initial opacity
	var timer = setInterval(
		function () 
		{
			var d = document.getElementById('first-layer-elements');
			if (op <= 0.1)
			{
				clearInterval(timer);
				d.style.display = 'none';
				var oop = 1;  // initial opacity
				var ttimer = setInterval(
					function () 
					{
						var dd = document.getElementById('first-layer');
						if (oop <= 0.1)
						{
							clearInterval(ttimer);
							dd.style.display = 'none';
							if($.cookie("first") == null || $.cookie("first") == "")
								$('#bill-split-pref').modal('show');
						}
						dd.style.opacity = oop;
						dd.style.filter = 'alpha(opacity=' + oop * 100 + ")";
						oop -= oop * 0.2;
				}, 50);
			}
			d.style.opacity = op;
			d.style.filter = 'alpha(opacity=' + op * 100 + ")";
			op -= op * 0.2;
	}, 50);
}

function tableIsReserved(b){
	noOfCustomer = parseInt(b);
	var d = document.getElementById('tablenumbertop');
	d.innerHTML = tableNumber;
	var a = document.getElementById('first-information');
	a.innerHTML = "";
	var a_1 = document.createElement('h5');
	a_1.innerHTML = 'The table is reserved by ' + noOfCustomer + ' customer(s).';
	var a_2 = document.createElement('input');
	a_2.type = 'submit';
	a_2.value = 'Start Dining Here';
	a_2.onclick = fadeFirstLayer;
	a.appendChild(a_1);
	a.appendChild(a_2);
	var b = document.getElementById('waiting-message');
	b.innerHTML = 'Reserved';
}

function waitingContinueOnClick(){
	
	//checkNumberOfCustomer();
	//checkforReservation();
	if(noOfCustomer>=1 || reserved == false){
		reserved = true;
	}
//	dismissWaiting();
}

function dismissWaiting(){
	var continueBtn = $("#continue-btn");
	var noOfCustomer = $("#no-of-customer")
	$("continue-btn").on("click",function(){
		continueBtn.attr("href",'main.html');
		noOfCustomer.text("Number of Customer: "+ noOfCustomer);
	});
} 

var waiterCalled = false;
function setDisableTimer(elem)
{
	if(waiterCalled)
	{
		waiterMessage();
		return;
	}
	elem.disabled = true;
	var defvalue = elem.innerHTML;
	setTimeout( function() 
	{
		elem.innerHTML = defvalue;
		elem.disabled = false;
		elem.style = null;
		waiterCalled = false;
		console.log("button enabled");
	}
	, 5000);
}

var billCalled = false;
function callBillOnClick(elem)
{
	clearInterval(checkfoodinterval);
	if(waiterCalled)
		return;
	checked = false;
	waiterCalled = true;
	waitingOnPayment();
	sendRequest(
		'POST',
		'table_no=' + tableNumber,
		'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/table.php?action=BILLING',
		function(a)
		{
			if(billCalled)
				return;
			billCalled = true;
			for(var i = 0; i < noOfCustomer; i++)
			{
				document.getElementById('customerbutton-' + (i + 1)).innerHTML = 'Rate & Review';
			}
		}
	);
	elem.innerHTML =  'Calling for billing';
}

function waiterMessage()
{
	document.getElementById('waiter-message').innerHTML = "Please wait for the waiter to come.";
	setTimeout( function()
	{
		document.getElementById('waiter-message').innerHTML = "";
	}, 3000
	);
}

function callWaiterOnClick(elem)
{
	if(waiterCalled)
		return;
	waiterCalled = true;
	sendRequest(
		'POST',
		'table_no=' + tableNumber,
		'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/table.php?action=WAITER',
		function(a)
		{
			
		}
	);
	elem.innerHTML = 'Calling waiter...';
}
function displayTableNumber()
{
	var a = document.getElementById('table-number');
	a.innerHTML = tableNumber;
	var b = document.getElementById('waiting-message');
	b.innerHTML = 'Waiting...';
	var c = document.getElementById('first-information');
	c.innerHTML = '<h5 align="center">You may manually enter the number of customer here:</h5><input type="text" id="manual-no-of-cust"><input type="submit" value="Start Dining Here" onclick="startDiningHereManualOnClick()">'
}

function changeNumberOfCustomerOnClick()
{
	var a = document.getElementById('new-cust-input');
	if (/^\d+$/.test(a.value))
	{
		var v = parseInt(a.value);
		if(v < noOfCustomer)
		{
			a.value = '';
			var b = document.getElementById('new-cust-input-message');
			b.innerHTML = 'Please enter the number more than the existing number of customers.';
			return
		}
		noOfCustomer = v;
		createCustomer();
		return;
	}
	a.value = '';
	var b = document.getElementById('new-cust-input-message');
	b.innerHTML = 'Please enter the correct number of customers.';
	return;
}
function startDiningHereManualOnClick()
{
	var a = document.getElementById('manual-no-of-cust');
	if (/^\d+$/.test(a.value))
	{
		noOfCustomer = parseInt(a.value);
		a.value = 'Reserving...';
		a.disabled = true;
		sendRequest(
			'POST',
			'no_of_cust=' + noOfCustomer + '&table_no=' + tableNumber,
			'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/table.php?action=RESERVE',
			function(b)
			{
				if(b == '' || b == '0')
				{
					document.getElementById('manual-no-of-cust').disabled = false;
					document.getElementById('manual-no-of-cust').value = '';
					document.getElementById('manual-no-of-cust').placeholder = 'Too many customers';
				}
				else
				{
				}
			}
		);
	}
	else
	{
		a.value = '';
		a.placeholder = "Please enter the correct value.";
		a.style = 'background-color: #edc4c9;';
		setTimeout(function(){document.getElementById('manual-no-of-cust').placeholder = "";document.getElementById('manual-no-of-cust').style = 'background-color: #white;';}, 5000);
	}
}

function checkCookie()
{
	if($.cookie("first") == null || $.cookie("first") == "")
		return true;
	return false;
}

function saveToCookie()
{
	$.cookie("first", "true");
	$.cookie("noOfCustomer", noOfCustomer);
	$.cookie("customers", JSON.stringify(customers));
	$.cookie("customersWithOrder", JSON.stringify(customersWithOrder));
}

function loadCookie()
{
	noOfCustomer = parseInt($.cookie("noOfCustomer"));
	customers = JSON.parse($.cookie("customers"));
	customersWithOrder = JSON.parse($.cookie("customersWithOrder"));
}

function submitRating()
{
	console.log($('#rate-modal').val());
	var cnumber = $('#rate-modal').val();
	var rating = document.getElementsByName('rating');
	var review = document.getElementById('review').value;
	var rate = 0;
	for(var i = 0; i < rating.length; i++)
	{
		if(rating[i].checked)
		{
			console.log("Rated: " + rating[i].value);
			rate = rating[i].value;
			break;
		}
	}
	console.log("Reviewed: " + document.getElementById('review').value);
	$('#rate-modal').modal('hide');
	document.getElementById('customerbutton-' + cnumber).innerHTML = 'Thank you!';
	document.getElementById('customerbutton-' + cnumber).disabled = true;
	sendRequest(
		'POST',
		'name=' + tableNumber + ' ' + cnumber + '&table_no=' + tableNumber + "&rate=" + rate + "&review=" + review,
		'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/customer.php?action=FEEDBACK',
		function(a)
		{
			console.log(a);
		}
	);
}

function waitingOnPayment()
{
	if (checked)
		return;
	checked = true;
	sendRequest(
		'GET',
		'',
		'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/table.php?request=STATUS&table_no=' + tableNumber,
		function(a)
		{
			console.log("Checked payment");
			checked = false;
			if(a == "Paid")
			{
				sendRequest(
					'POST',
					'table_no=' + tableNumber,
					'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/table.php?action=UNRESERVE',
					function(b)
					{
						$.cookie('first', '');
						window.location.reload();
					}
				);
			}
			else
			{
				setTimeout(waitingOnPayment, 1500);
			}
		}
	);
}

function refreshCustomerAndFoodOrderArray()
{
	sendRequest(
		'GET',
		'',
		'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/order.php?request=STATUS_FROM_TABLE&table_no=' + tableNumber + '&no_of_cust=' + noOfCustomer,
		function(a)
		{
			customersWithOrder = JSON.parse(a);
			displayOrderSummary();
		}
	);
}
window.onload = function()
{
	if (checkCookie())
	{
		displayTableNumber();
		waitingOnReservation();
	}
	else
	{
		loadCookie();
		tableIsReserved(noOfCustomer);
		var e = document.getElementById('custnumbertop');
		e.innerHTML = noOfCustomer;
		fadeFirstLayer();
		refreshCustomerAndFoodOrderArray();
		if(checkfoodinterval !== undefined)
			checkfoodinterval = setInterval(refreshCustomerAndFoodOrderArray, 10000);
		displayOrderSummary();
		dismissWaiting();
	}
};
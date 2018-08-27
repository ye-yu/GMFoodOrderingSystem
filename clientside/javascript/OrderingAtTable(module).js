var noOfCustomer;
var tableNumber = 2;
var reserved = false;
var customers = [];
var requestSent = false;
var customerWithOrders = {};
var checked = false;

function sendRequest(method,param,url,toSet){
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
	for(var i=0; i < noOfCustomer; i++)
	{
		var a = new Customer;
		
	}
}
function waitingOnReservation(){
	sendRequest(
		'GET',
		'',
		'http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/table.php?request=STATUS&table_no=' + tableNumber,
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

function tableIsReserved(b){
	noOfCustomer = parseInt(b)
	var a = document.getElementById('first-information');
	a.innerHTML = "";
	var a_1 = document.createElement('h5');
	a_1.innerHTML = 'The table is reserved by ' + noOfCustomer + ' customer(s).';
	var a_2 = document.createElement('input');
	a_2.type = 'submit';
	a_2.value = 'Start Dining Here';
	a_2.onclick = function()
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
	a.appendChild(a_1);
	a.appendChild(a_2);
	var b = document.getElementById('waiting-message');
	b.innerHTML = 'Reserved';
}

function waitingContinueOnClick(){
	
	checkNumberOfCustomer();
	checkforReservation();
	if(noOfCustomer>=1 || reserved == false){
		reserved = true;
	}
	dismissWaiting();
}

function dismissWaiting(){
	var continueBtn = $("#continue-btn");
	var noOfCustomer = $("#no-of-customer")
	$("continue-btn").on("click",function(){
		continueBtn.attr("href",'main.html');
		noOfCustomer.text("Number of Customer: "+ noOfCustomer);
	});
} 
/*
function splitTheBillYesOnClick(noOfCustomer){
	for (var i=0; i<noOfCustomer; i++){
		 customers[i] = {
			tableNumber = getTableNum();
		}
		customers.Ordering();
	}
}
*/
function refreshCustomerAndFoodOrder(){
	var customersDOM;
	customersDOM = document.getElementById('customerOrders');
	for(i=0; i<noOfCustomer; i++){
		var subElement;
		subElement += document.createElement('<div>');
		subElement.attr('id','customer');
		subElement.innerHTML += customerWithOrders[i]; 
		customersDOM.appendChild(subElement);
	}
}
function startOrdering(customerNumber){
	var orderForm = document.createElement('<form>');
	orderForm = createForm(orderForm,customerNumber);
	orderForm.submit();
}
/*
function createForm(orderForm,customerNumber){
	orderForm.method = 'post';
	Set orderform.action = '/ordering.html';
	var subElement;
	subElement = document.createElement('input');
	subElement.type = 'hidden';
	subElement.name = 'order from';
	subElement.value = 'table';
	orderForm.appendChild(subElement);
	subElement = document.createElement('input');
	subElement.type = 'hidden';
	subElement.name = 'customer';
	subElement.value = customerNumber + " " + tableNumber;
	orderForm.appendChild(subElement);
	subElement = document.createElement('input');
	subElement.type = 'hidden';
	subElement.name = 'orders';
	subElement.value = JSON.stringify(customersWithOrder[customerNumber]);
	orderForm.appendChild(subElement);
	return orderForm;
}
*/
function displayTableNumber()
{
	var a = document.getElementById('table-number');
	a.innerHTML = tableNumber;
	var b = document.getElementById('waiting-message');
	b.innerHTML = 'Waiting...';
	var c = document.getElementById('first-information');
	c.innerHTML = '<h5 align="center">You may manually enter the number of customer here:</h5><input type="text" id="manual-no-of-cust"><input type="submit" value="Start Dining Here" onclick="startDiningHereManualOnClick()">'
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
			'table_no=' + tableNumber + '&no_of_cust=' + noOfCustomer,
			'http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/table.php?action=RESERVE',
			function(a)
			{
				if(a === "1")
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
window.onload = function()
{
	console.log("document is ready");
	displayTableNumber();
	waitingOnReservation();
};
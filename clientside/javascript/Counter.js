var flags = {"last":false, "orderid": null};
$(document).ready(function(){
	$("#table-num button").click(function(evtObj){
		$(this).animate({ opacity:0.1 },250,function(){
			$(this).remove();
		});
	});
});

var searchEntry = null;
function searchOrder(ele){
		
		let tableNumber = '0';
		let phoneNo = '';
		searchEntry = $('#search-entry').val().trim();
		if(searchEntry == '')
		{
			$('#search-entry').val('');
			var popUp = $(".modal-content");
			popUp.empty();
			var popupHeader = $("<p>");
			popupHeader.html('Please enter a valid value.');
			popUp.append(popupHeader);
			return;
		}
		if(searchEntry.length <=9)
			tableNumber = searchEntry;
		else
			phoneNo = searchEntry;
		sendRequest(
			'GET',
			'',
			'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/pay.php?request=UNPAID_ORDERS&table_no=' + tableNumber + '&phone_no=' + phoneNo,
			function(a)
			{
				showUnpaidOrderID(JSON.parse(a), searchEntry);
			}
		);
}

function showUnpaidOrderID(ordersAtTable, info)
{
		/**********pop up design***********/
		var popUp = $(".modal-content");
		popUp.empty();
		var popupHeader = $("<p>");
		var popupTitle = $("<p>");
		popupHeader.attr("class", "mod-header");
		if(info.length <= 9)
			popupHeader.html("Unpaid Orders at table " + info);
		else if (info == '')
			popupHeader.html("Unpaid Orders at all table");
		else
			popupHeader.html("Unpaid Orders by phone number " + info);
		popUp.append(popupHeader);
		popupTitle.html("(Click one of the order ID to proceed with the payment.)");
		popUp.append(popupTitle);
		/**********************************/

		/**************/
		//here must initialise limit value(number of orders in that particular table) for the loop below 
		//either that or you can use hasnext()
		/**************/
		
		/*****for loop for adding all the orders at the table into the pop up************/
		for(let i=0; i< ordersAtTable.length; i++){
			console.log("created");
			let order = $("<button>");
			order.html(ordersAtTable[i]);
			order.css({width:"60%"});
			order.attr("id","order-summary");
			order.click(function(){getOrderSummary(ordersAtTable[i]);});
			order.attr("data-dismiss","modal");
			//appending to the pop up
			popUp.append(order);
			popUp.css({padding:"10px"});
		}
		
		if(ordersAtTable.length == 1)
		{
			flags['last'] = true;
			flags['orderid'] = ordersAtTable[0];
		}
		/***********************************************************/
}
//once all the orders is assigned to an element in an array we can access it now
$(document).ready(function(){
	$("#order-payment").click();
});

/*********************************************/
$(document).ready(function(){
	$('#search-entry').val('');
	//adding attribute for the pop up effect
	$("#table-order-summary").attr("data-target",".bd-example-modal-lg");
	$("#table-order-summary").attr("data-toggle","modal");	
});

function getOrderSummary(id)
{
	sendRequest(
		'POST',
		'order_id=' + id,
		'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/pay.php?action=RECORD',
		function(a)
		{
			sendRequest(
				'GET',
				'',
				'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/pay.php?request=RECEIPT&receipt_id=' + id,
				function(a)
				{
					console.log(a);
					showOrderSummary(JSON.parse(a));
				}
			);
		}
	);
}

function showOrderSummary(orderInfo)
{
	//referencing the section where the order summary shows up
	var orderSummarySection = $("#cust-order-summary1");
	orderSummarySection.empty();
	var food = $("<p>");
	food.attr("class", "order-summary-title")
	food.html("Order Summary");
	orderSummarySection.append(food);	

	/********this loop is used to access all the food in a particular order and display it*********/
	var foodlist = orderInfo.foods;
	var ul = $('<ol>')
	ul.attr('class', 'food-list');
	for(var i=0; i<foodlist.length; i++){
		let food = $("<li>");
		food.html(foodlist[i].foodname + '(RM' + foodlist[i].foodprice + ') &times; ' + foodlist[i].orderQuantity);
		ul.append(food);
	}
	orderSummarySection.append(ul);
	
	var totalPrice = orderInfo.paidTotal;
	var forinfo = $('<div class="payment-info">');
	forinfo.append("<div class='subtotal-price'>Subtotal Price: RM" + orderInfo.ordertotal + "</div>");
	forinfo.append("<div class='gtax'>Government tax: " + orderInfo.governmenttax + "%</div>");
	forinfo.append("<div class='atax'>Additional tax: " + orderInfo.additional + "%</div>");
	forinfo.append("<div class='total-price'>Total Price: RM" + totalPrice + "</div>");
	orderSummarySection.append(forinfo);

	var btnSection = $("<div class='payment-method'>");
	ctn = "<button class='pay'>Cash</button> <button class='pay'>Card</button>";
	btnSection.html(ctn);
	orderSummarySection.append(btnSection);
	btnSection.css({display:"inline-block"},{margin:"30px"});
	$('.pay').click(function(){
		showPay($(this).html(), orderInfo.orderid, totalPrice);
	});
	$(".pay").attr("data-target",".bd-example-modal-lg");
	$(".pay").attr("data-toggle","modal");
	/************************************************************************************/
}
/***************************************************************/

/*********************adds the payment button section********************************/
$(document).ready(function(){
});

function showPay(method, orderid, ordertotal)
{
	var mod = $(".modal-content");
	mod.empty();
	if(method == 'Cash')
	{
		var header = $('<p>');
		header.html('Please enter received money (RM):');
		header.attr("class", "mod-header");
		mod.append(header);
		var textbox = '<input type="text" id="received-money">';
		mod.append(textbox);
		var btn = $('<button>');
		btn.html("Proceed");
		btn.click(
			function ()
			{
				var received = parseFloat($('#received-money').val());
				if(Number.isNaN(received))
				{
					$('#received-money').val("");
					$('#received-money').attr("placeholder","Please enter a valid number.");
				}
				else
				{
					if(received < parseFloat(ordertotal))
					{
						$('#received-money').val("");
						$('#received-money').attr("placeholder","Not enough balance.");
					}
					else
					{
						$(this).html('Paying...');
						pay(orderid, method, received);
					}
				}
			}
		);
		mod.append(btn);
	}
	else
	{
		var header = $('<p>');
		header.html('Waiting for card swiping...');
		header.attr("class", "mod-header");
		mod.append(header);
		var textbox = 'Please swipe the card.';
		mod.append(textbox);
		setTimeout( function(){pay(orderid, method, '12345678901234');}, 1000);
	}
}
function pay(orderid, method, paymentinfo)
{
	var query = '';
	if(method == 'Cash')
		query = 'order_id=' + orderid + '&method=CASH&received=' + paymentinfo;
	else
		query = 'order_id=' + orderid + '&&method=CARD&ccnumber=' + paymentinfo;
	sendRequest(
		'POST',
		query,
		'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/pay.php?action=PAY',
		function(a)
		{
			if(flags['last'])
			{
				sendRequest(
					'POST',
					'order_id=' + flags['orderid'],
					'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/table.php?action=UNRESERVE',
					function(a)
					{
						transactionSuccessful();
					}
				);
			}
			else
				transactionSuccessful();
		}
	);
}

function transactionSuccessful()
{
	var popUp1 = $(".modal-content");
	popUp1.empty();
	var message = $("<div>");
	var okBtn = "<button data-dismiss='modal' onclick='window.location= window.location;'>Ok</button>";
	message.html("Transaction is successful.");
	message.attr("class", "mod-header");
	popUp1.append(message);
	popUp1.append("<p>Receipt has been printed.</p>");
	popUp1.append(okBtn);
	$('body').click(function(){window.location=window.location;});
}

function checkWaitingList()
{
	sendRequest(
		'GET',
		'',
		'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/table.php?request=BILLING',
		function(a){
			console.log(a);
			let waitinglist = JSON.parse(a);
			updatetablelist(waitinglist);
		}
	);
}

function updatetablelist(waitinglist)
{
	var stg = '';
	for(let i = 0; i < waitinglist.length; i++)
		stg += '<button onclick="servetable(this, ' + waitinglist[i] + ');">' + waitinglist[i] + '</button>';
	document.getElementById('table-num').innerHTML = stg;
}

function servetable(ele, id)
{
	sendRequest(
		'POST',
		'table_no=' + ele.innerHTML,
		'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/pay.php?action=INVOICE',
		function(a){
			console.log(a);
		}
	);
	ele.parentElement.removeChild(ele);
}

setInterval(checkWaitingList, 3000);
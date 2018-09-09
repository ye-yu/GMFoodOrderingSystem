var foodsByCategory = {};
var cart = {};
var customer = null;

function getFoodsByCategory()
{
	sendRequest(
		'GET',
		'',
		'http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/order.php?request=FOOD&food_id=ALL&group_by=TRUE',
		function(a)
		{
			foodsByCategory = JSON.parse(a);
			showFoodCategory();
		}
	);
}

function showFoodByCategory(category)
{
	document.getElementById('selected-category').innerHTML = '>> ' + category;
	var foodlist = foodsByCategory[category];
	console.log(foodlist);
	document.getElementById('ordering-content').innerHTML = '';
	var itemlisting = null;
	var string = '';
	var _end = foodlist.length;
	for(var i = 0; i < _end; i++) {
		if(i % 3 == 0){
				itemlisting = document.createElement('div');
				itemlisting.className = 'container-fluid bg-3 text-center';
				itemlisting.innerHTML = '';
				string += '                        <div class="row">';
		}
		string += '<div class="col-sm-4">';
		string += '  <div class="thumbnail">        ';
		if(foodlist[i].foodimagelink == null)
			foodlist[i].foodimagelink = 'https://i.hungrygowhere.com/cms/f3/01/83/e8/163650/western-subang-default2.jpg';
		string += '  <img src="' + foodlist[i].foodimagelink + '" alt="" style="width:300px; height: 200px;">';
		string += '  <div class="caption" style="background-color: lightgrey">';
		string += '<p>' + foodlist[i].foodname + ' -- RM' + foodlist[i].foodprice +'</p>';
		string += '  <div class="form-inline">';
		string += '  <div class="form-group">';
		string += '<label class="control-label">Qty:</label>';
		string += '<input id="' + foodlist[i].foodid + '" class="form-control" style="width: 100px;" type="number" value="1" min="1"/>';
		string += '  </div>';
		string += '  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#food' + i + 'Modal" onclick="document.getElementById(\'button-' + foodlist[i].foodid + '\').innerHTML = \'Add \' + $(\'#' + foodlist[i].foodid + '\').val() + \' quantity\';">Add</button>';
		string += '<script>';
		string += '</script>';
		string += '  <!-- Modal -->';
		string += '  <div class="modal fade" id="food' + i + 'Modal" role="dialog">';
		string += '<div class="modal-dialog">';
		string += '';
		string += '  <!-- Modal content-->';
		string += '  <div class="modal-content">';
		string += '<div class="modal-header">';
		string += '  <button type="button" class="close" data-dismiss="modal">&times;</button>';
		string += '  <h2 class="modal-title">Add this to cart?</h2>';
		string += '</div>';
		string += '<div class="modal-body">';
		string += '  <div class="row">';
		string += '<div class="col-sm-4">';
		string += '<img src="' + foodlist[i].foodimagelink + '" style="width:100%;" class="img-rounded" alt="">';
		string += '</div>';
		string += '<div class="col-sm-8 text-left">';
		string += '<p>' + foodlist[i].foodname + '</p>';
		string += '<p>' + foodlist[i].fooddescription + '</p>';
		string += '</div>';
		string += '  </div>';
		string += '</div>';
		string += '<div class="modal-footer">';
		string += '  <button type="button" id="button-' + foodlist[i].foodid + '" data-dismiss="modal" onclick="addToCart(\'' + foodlist[i].foodid + '\', $(\'#' + foodlist[i].foodid + '\').val());" class="btn btn-default">Add x quantity</button>';
		string += '  <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>';
		string += '</div>';
		string += '  </div>';
		string += '';
		string += '</div>';
		string += '  </div>';
		string += '  </div>';
		string += '  </div>        ';
		string += '  </div>';
		string += '</div>';
		if(i % 3 == 2 || (i + 1) == _end) {
				if(_end < 3)
				{
					for(var j = i; j < 2; j++)
					{
						// string += '<div class="col-sm-4"><div class="thumbnail"></div></div>';
						string += '<div class="col-sm-4"></div>';
					}
				}
				string += '                        </div>';
				itemlisting.innerHTML = string;
				string = '';
		document.getElementById('ordering-content').appendChild(itemlisting);
		}	
	}
	for(var i = 0; i < _end; i++) {
		$('#' + foodlist[i].foodid).bootstrapNumber();
	}
}

function showFoodCategory()
{
	document.getElementById('selected-category').innerHTML = ' ';
	var categories = Object.keys(foodsByCategory);
	document.getElementById('ordering-content').innerHTML = '';
	var itemlisting = null;
	var string = '';
	for(var i = 0; i < categories.length; i++) {
		if(i % 3 == 0){
				itemlisting = document.createElement('div');
				itemlisting.className = 'container-fluid bg-3 text-center';
				itemlisting.innerHTML = '';
		string += '                       <div class="row">';
		}
		string += '<a href="#" onclick="showFoodByCategory(\'' + categories[i] + '\')">';
		string += '<div class="col-sm-4">';
		string += '  <div class="thumbnail">        ';
		if(foodsByCategory[categories[i]][0].foodimagelink == null)
			foodsByCategory[categories[i]][0].foodimagelink = 'https://i.hungrygowhere.com/cms/f3/01/83/e8/163650/western-subang-default2.jpg';
		string += '  <img src="' + foodsByCategory[categories[i]][0].foodimagelink +'" alt="" style="width:300px; height: 200px;">';
		string += '  <div class="caption" style="background-color: lightgrey">';
		string += '<p>' + categories[i] + '</p>';
		string += '  </div>        ';
		string += '  </div>';
		string += '</div>';
		string += '</a>';
		if(i % 3 == 2 || i == categories.length - 1) {
			string += '                       </div>';
			itemlisting.innerHTML += string;
			string = '';
			document.getElementById('ordering-content').appendChild(itemlisting);
		}
	}
}

function addToCart(foodid, foodquantity)
{
	var food = findFood(foodid);
	food["foodquantity"] = foodquantity;
	cart[foodid] = food;
	document.getElementById('cart-count').innerHTML = Object.keys(cart).length;
}

function removeFromCart(foodid)
{
	delete cart[foodid];
	updateCartFoodList();
	document.getElementById('cart-count').innerHTML = Object.keys(cart).length;
}

function findFood(foodid)
{
	for(let i = 0; i < Object.keys(foodsByCategory).length; i++) {
		let foods = foodsByCategory[Object.keys(foodsByCategory)[i]];
		for(let k = 0; k < foods.length; k++) {
			if(foods[k].foodid == foodid)
				return foods[k];
		}
	}
}
function updateCartFoodList()
{
	var total = 0;
	document.getElementById('cartFoodList').innerHTML = '';
	var foodids = Object.keys(cart);
	for(let i = 0; i < foodids.length; i++)
	{
		var food = cart[foodids[i]];
		let string = '';
		string += '<p><span class="cart-food-name">'+ food.foodname +'</span><span class="item-desc">(RM<span class="price-per-item">' + food.foodprice + '</span>) &times; ' + food.foodquantity + ' </span><button type="button" class="btn btn-default cart-btn" onclick="removeFromCart(\'' + foodids[i] + '\');">Remove</button></p>';
		string += '<hr style="background-color: lightgray; height: 1px; border: 0;">';
		total += parseFloat(food.foodprice) * parseInt(food.foodquantity);
		document.getElementById('cartFoodList').innerHTML += string;
	}
	document.getElementById('cart-total').innerHTML = round(total, 2);
}

function round(value, decimals) {
    return Number(Math.round(value +'e'+ decimals) +'e-'+ decimals).toFixed(decimals);
}

function checkIfFromTable()
{
	return typeof customerNumber !== 'undefined';
}

function placeOrder()
{
	if(checkIfFromTable())
	{
		customer.order.orderFoods = trimCart();
		customer.placeOrder(function(a){
			console.log(a);
			window.location = 'http://localhost:11111/dashboard/workspace/SEF1819/GMFoodOrderingSystem/clientside/html/OrderingAtTable' + tableNumber +'.html'
			});
	}
}

function trimCart()
{
	let a = Object.keys(cart);
	var t = [];
	for(let i = 0; i < a.length; i++)
	{
		let temp = {};
		let arr = cart[a[i]];
		temp['foodid'] = arr['foodid'];
		temp['foodquantity'] = arr['foodquantity'];
		t.push(temp);
	}
	return t;
}
$(document).ready(function() {
	getFoodsByCategory();
	if(checkIfFromTable())
	{
		customer = new Customer();
		customer.custName = customerNumber;
		customer.custID = customerid;
		customer.order = new Ordering();
		customer.order.tableNo = tableNumber;
	}
});

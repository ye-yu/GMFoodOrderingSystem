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

function setSlideUp(ele)
{
	$(ele).fadeTo(2000, 500).slideUp(500, function(){
	$(ele).slideUp(500);
	});
}

function previewFile() {
  var preview = document.querySelectorAll('img');
  var file    = document.querySelector('input[type=file]').files[0];
  var reader  = new FileReader();

  reader.addEventListener("load", function () {
	for(let i = 0; i < preview.length; i++)
		preview[i].src = reader.result;
  }, false);

  if (file) {
    reader.readAsDataURL(file);
  }
}
function previewFileModal(fileUploader) {
  // var file    = document.querySelector('#foodimageupdate').files[0];
  var file = fileUploader.files[0];
  var reader  = new FileReader();

  reader.addEventListener("load", function () {
		$('#prev').attr("src", reader.result);
  }, false);

  if (file) {
    reader.readAsDataURL(file);
  }
}

$(document).ready(function(){
	$("#login-btn").click(function(){
		$("#login-error").html("");
		$("#login-error").attr("class", "");
		sendRequest(
			'POST',
			'username=' + $("#uname").val() + '&password=' + $("#pword").val(),
			'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/admin.php',
			function(a)
			{
				if(a == "1")
				{
					// console.log("Login successful.");
					// $("#login-page").css({display:"none"});
					// $("#menu-mgmt-page").show();
					// $("#task").show();
					// $("#task-2").hide();
					// $("#fdbck-page").hide();
					window.location = window.location;
				}
				else
				{
					$("#login-error").attr("class", "alert alert-warning");
					$("#login-error").html("Login unsuccessful. Please enter the correct username and password.");
				}
			}
			);
	});
});

function disableOthers()
{
	$(".other-name").prop('disabled', true);
	$(".other-name").prop('required', true);
}

function enableOthers()
{
	$(".other-name").prop('disabled', false);
	$(".other-name").prop('required', false);
}

function logOut()
{
	localStorage.clear();
	sendRequest(
		'POST',
		'',
		'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/admin.php?request=LOGOUT',
		function(a)
		{
			window.location = window.location;
		}
		);
}

var foods = null;
$(document).ready(function(){
	$("#view-food").click(showFoods);
});

function showFoods()
{
	$("#task").hide();
	$("#fdbck-page").hide();
	$("#task-2").show();
	var taskContent = $("#task-2");
	taskContent.empty();
	taskContent.append("<div class='view-header' style='display: inline-block'>View Food: <select> <option onclick='showFoodByCategory(\"all\")'>All Foods</option>" + replaceAll(categories, 'disableOthers(', 'showFoodByCategory(this') + " </select></div><p class='add-caption'> You may edit the entry of each food or remove the food entirely.</p> ");
	var foodContainer = $("<div>");
	foodContainer.attr("id", "food-container");
	foodContainer.attr("class", "food-container");
	taskContent.append(foodContainer);
	sendRequest(
		'GET',
		'',
		'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/order.php?request=FOOD&food_id=ALL',
		function(a)
		{
			let b = JSON.parse(a);
			foods = b;
			showFoodByCategory('all');
		}
	);
}

function showFoodByCategory(cat)
{
	if(typeof cat == 'string')
		var category = cat;
	else
		var category = $(cat).html();
	var foodContainer = $("#food-container");
	foodContainer.empty();
	for(let i = 0; i < foods.length; i++)
	{
		let food = foods[i];
		if(category !== 'all' && food.foodtype !== category)
			continue;
		var viewBtn = $("<button>");
		viewBtn.html("Edit");
		viewBtn.attr("class", "view-food pull-right");	
		viewBtn.attr("value", JSON.stringify(food));	
		var rmBtn = $("<button>");
		rmBtn.html("Remove");
		rmBtn.attr("class","remove-food pull-right");
		rmBtn.attr("value", JSON.stringify(food));
		rmBtn.attr("data-target",".bd-example-modal-lg");
		rmBtn.attr("data-toggle","modal");	
		var foodRecord = $("<div class='food-record'>");
		var newFood = $("<p>");
		newFood.html(food.foodname + " RM" + food.foodprice);
		foodRecord.append('<img src="dashboard/workspace/SEF1819/GMFoodOrderingSystem/clientside/html/assets/foods/' + food.foodimagelink + '">');
		foodRecord.append(newFood);
		foodRecord.append("<br>");
		foodRecord.append(viewBtn);
		foodRecord.append(rmBtn);
		foodContainer.append(foodRecord);
		foodRecord.children().css({display:"inline-block"});
	}
}

function replaceAll(str, find, replace) {
    return str.replace(new RegExp(escapeRegExp(find), 'g'), replace);
}

function escapeRegExp(str) {
    return str.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
}

$(document).ready(function(){
	$("#task-2").on("click",".remove-food",function(){
		let food = JSON.parse($(this).val());
		var modalContent = $(".modal-content");
		modalContent.empty();
		modalContent.html('<div class="remove-header">Removing ' + food.foodname + '.</div><form enctype="multipart/form-data" id="removeFood" action="dashboard/workspace/SEF1819/GMFoodOrderingSystem/clientside/html/MenuManagement.php" method="POST" class="text-left"><input type="hidden" name="id" value="' + food.foodid + '" /><input type="hidden" name="submittype" value="Remove" /></form><div class="modal-body remove-menu"><div class="remove-description">This action is not undoable. Proceed with the removal?</div></div><div class="modal-footer"><input type="button" onclick="removeFood();" value="Remove"><input type="button" value="Cancel" data-dismiss="modal"></div>');
	});
});

function removeFood()
{
	localStorage.setItem('section', 'menuedit');
	document.getElementById('removeFood').submit();
}
$(document).ready(function(){
	$("#task-2").on("click",".view-food",function(){
		let food = JSON.parse($(this).val());
		var modalContent = $(".modal-content");
		modalContent.empty();
		modalContent.html('<div class="edit-header">Edit Food</div><div class="modal-body view-menu"><form enctype="multipart/form-data" id="updateFood" action="dashboard/workspace/SEF1819/GMFoodOrderingSystem/clientside/html/MenuManagement.php" method="POST" class="text-left"><input type="hidden" name="id" value="' + food.foodid + '" /><input type="hidden" name="submittype" value="Make Changes" /><div style="float: right; width: 250;"><img id="prev" src="dashboard/workspace/SEF1819/GMFoodOrderingSystem/clientside/html/assets/foods/' + food.foodimagelink + '" height="250" width="250" alt="Image preview..."><br/>Update Image: <input type="file" onchange="previewFileModal(this);" onclick="enableChangeButton();" style="display: inline-block;" name="upload" id="foodimageupdate"><br/></div><p style="display: inline-block;">Food Name:<input maxlength="100" required type="text" name="foodname" value="' +  food.foodname + '" onclick="enableChangeButton();" /></p><br/><p style="display: inline-block;">Price(RM): <input onclick="enableChangeButton();" id="money_input" required type="number" min="0" step=".01" name="foodprice" value="' + food.foodprice + '"/></p><br/><p style="display:inline-block;">Category: <select name="foodtype" onclick="enableChangeButton();">' + replaceAll(categories, '>' + food.foodtype, ' selected>' + food.foodtype) + '<option value="Others" onclick="enableOthers();">Add Others:</option></select><input maxlength="50" type="text" id="other-name" class="other-name" name="other" placeholder="New category" disabled /></p><br/><p style="display: inline-block;">Description: <br/> <textarea maxlength="500" name="foodDesription" rows="7" style="resize: none;" required onclick="enableChangeButton();">'+ food.fooddescription + '</textarea></p></div><div class="modal-footer"><input type="submit" name="submit" id="make-menu-change" value="Make Changes" onclick="submitFoodEdit()" disabled><button data-dismiss="modal" onclick="disableOthers();">Return</button></form></div>');
		$(".view-food").attr("data-target",".bd-example-modal-lg");
		$(".view-food").attr("data-toggle","modal");
	});
});

function enableChangeButton()
{
	$("#make-menu-change").prop('disabled', false);
}

function submitFoodEdit()
{
	localStorage.setItem('section', 'menuedit');
	document.getElementById('updateFood').submit();
}

$(document).ready(function(){
	$("#add-food").click(function(){
		localStorage.clear();
		$("#task").show();
		$("#task-2").hide();
		$("#fdbck-page").hide();
	});
});

$(document).ready(function(){
	$("#view-fdbck").click(function(){
		localStorage.clear();
		$("#task").hide();
		$("#task-2").hide();
		$("#fdbck-page").show();
		$("#fdbck-page").empty();
		$("#fdbck-page").append("<div class='feedback-header'>View Feedback</div>						<span>From date:</span><input id='start_dt' type='date' value='dateChosen' /><input type='submit' value='Go' onclick='showFeedbacks($(\"#start_dt\").val());'/><p class='add-caption'>You may select the date to view the feedback from the customer.</p>");
		
		let section = $("<div class='feedback-section' id='feedback-section'>");
		$("#fdbck-page").append(section);
		showFeedbacks('2001-01-01');
		
	});
});

function showFeedbacks(date)
{
	let section = $('#feedback-section');
	section.empty();
	sendRequest(
		'GET',
		'',
		'http://' + document.location.host + '/dashboard/workspace/SEF1819/GMFoodOrderingSystem/serverside/php/admin.php?request=FEEDBACK&date=' + date,
		function(a)
		{
			let b = JSON.parse(a);
			for(let i = 0; i < b.length; i++)
			{				
				let feedback = b[i];
				let fdbckRow = $("<div class='feedback-row'>");
				let fdbckTitle = $("<div class='feedback-title'>");
				fdbckTitle.html("On " + feedback.feedbackDateTime + ",");
				let content = $("<div class='feedback-content'>");
				let str = "<div class='feedback-rating'>Rated: ";
				for(let j = 0; j < parseInt(feedback.feedbackRate); j++)
					str += "⭐️";
				str += "</div>";
				content.html(str + "<div class='feedback-review'>Reviewed: <blockquote>" + feedback.feedbackContent + "</blockquote></div>");
				fdbckRow.append(fdbckTitle);
				fdbckRow.append(content);
				section.append(fdbckRow);
			}
		}
	);
}
function getDateString(dt) {
  return dt.getDate() + '-' + 
    ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][dt.getMonth()] + 
    '-' + dt.getFullYear();
}

// Converts a date into 'July 2010' format
function getMonthYearString(dt) {
  return ['January','February','March','April','May','June','July',
          'August','September','October','November','December'][dt.getMonth()] +
         ' ' + dt.getFullYear();
}

// This is the function called when the user clicks any button
function chooseDate(e) {
  var targ; // Crossbrowser way to find the target (http://www.quirksmode.org/js/events_properties.html)
	if (!e) var e = window.event;
	if (e.target) targ = e.target;
	else if (e.srcElement) targ = e.srcElement;
	if (targ.nodeType == 3) targ = targ.parentNode; // defeat Safari bug

  var div = targ.parentNode.parentNode.parentNode.parentNode.parentNode; // Find the div
  var idOfTextbox = div.getAttribute('datepickertextbox'); // Get the textbox id which was saved in the div
  var textbox = document.getElementById(idOfTextbox); // Find the textbox now
  if (targ.value=='<' || targ.value=='>' || targ.value=='<<' || targ.value=='>>') { // Do they want the change the month?
    createCalendar(div, new Date(targ.getAttribute('date')));
    return;
  }
  textbox.value = targ.getAttribute('date'); // Set the selected date
  div.parentNode.removeChild(div); // Remove the dropdown box now
}

// Parse a date in d-MMM-yyyy format
function parseMyDate(d) {
  if (d=="") return new Date('NotADate'); // For Safari
  var a = d.split('-');
  if (a.length!=3) return new Date(d); // Missing 2 dashes
  var m = -1; // Now find the month
  if (a[1]=='Jan') m=0;
  if (a[1]=='Feb') m=1;
  if (a[1]=='Mar') m=2;
  if (a[1]=='Apr') m=3;
  if (a[1]=='May') m=4;
  if (a[1]=='Jun') m=5;
  if (a[1]=='Jul') m=6;
  if (a[1]=='Aug') m=7;
  if (a[1]=='Sep') m=8;
  if (a[1]=='Oct') m=9;
  if (a[1]=='Nov') m=10;
  if (a[1]=='Dec') m=11;
  if (m<0) return new Date(d); // Couldn't find the month
  return new Date(a[2],m,a[0],0,0,0,0);
}

// This creates the calendar for a given month
function createCalendar(div, month) {
  var idOfTextbox = div.getAttribute('datepickertextbox'); // Get the textbox id which was saved in the div
  var textbox = document.getElementById(idOfTextbox); // Find the textbox now
  var tbl = document.createElement('table');
  var topRow = tbl.insertRow(-1);
  var td = topRow.insertCell(-1);
  var lastYearBn = document.createElement('input');
  lastYearBn.type='button'; // Have to immediately set the type due to IE
  td.appendChild(lastYearBn);
  lastYearBn.value='<<';
  lastYearBn.onclick=chooseDate;
  lastYearBn.setAttribute('date',new Date(month.getFullYear(),month.getMonth()-12,1,0,0,0,0).toString());
  var td = topRow.insertCell(-1);
  var lastMonthBn = document.createElement('input');
  lastMonthBn.type='button'; // Have to immediately set the type due to IE
  td.appendChild(lastMonthBn);
  lastMonthBn.value='<';
  lastMonthBn.onclick=chooseDate;
  lastMonthBn.setAttribute('date',new Date(month.getFullYear(),month.getMonth()-1,1,0,0,0,0).toString());
  var td = topRow.insertCell(-1);
  td.colSpan=3;
  var mon = document.createElement('input');
  mon.type='text';
  td.appendChild(mon);
  mon.value = getMonthYearString(month);
  mon.size=15;
  mon.disabled='disabled';
  mon.className='monthDsp';
  var td = topRow.insertCell(-1);
  var nextMonthBn = document.createElement('input');
  nextMonthBn.type='button';
  td.appendChild(nextMonthBn);
  nextMonthBn.value = '>';
  nextMonthBn.onclick=chooseDate;
  nextMonthBn.setAttribute('date',new Date(month.getFullYear(),month.getMonth()+1,1,0,0,0,0).toString());
  var td = topRow.insertCell(-1);
  var nextYearBn = document.createElement('input');
  nextYearBn.type='button'; // Have to immediately set the type due to IE
  td.appendChild(nextYearBn);
  nextYearBn.value='>>';
  nextYearBn.onclick=chooseDate;
  nextYearBn.setAttribute('date',new Date(month.getFullYear(),month.getMonth()+12,1,0,0,0,0).toString());  
  var daysRow = tbl.insertRow(-1);
  daysRow.insertCell(-1).innerHTML="Mon";  
  daysRow.insertCell(-1).innerHTML="Tue";
  daysRow.insertCell(-1).innerHTML="Wed";
  daysRow.insertCell(-1).innerHTML="Thu";
  daysRow.insertCell(-1).innerHTML="Fri";
  daysRow.insertCell(-1).innerHTML="Sat";
  daysRow.insertCell(-1).innerHTML="Sun";
  daysRow.className='daysRow';  
  // Make the calendar
  var selected = parseMyDate(textbox.value); // Try parsing the date
  var today = new Date();
  date = new Date(month.getFullYear(),month.getMonth(),1,0,0,0,0); // Starting at the 1st of the month
  var extras = (date.getDay() + 6) % 7; // How many days of the last month do we need to include?
  date.setDate(date.getDate()-extras); // Skip back to the previous monday
  while (1) { // Loop for each week
    var tr = tbl.insertRow(-1);
    for (i=0;i<7;i++) { // Loop each day of this week
      var td = tr.insertCell(-1);
      var inp = document.createElement('input');
      inp.type = 'button';
      td.appendChild(inp);
      inp.value = date.getDate();
      inp.onclick = chooseDate;
      inp.setAttribute('date',getDateString(date));
      if (date.getMonth() != month.getMonth()) {
        if (inp.className) inp.className += ' ';
        inp.className+='othermonth';
      }
      if (date.getDate()==today.getDate() && date.getMonth()==today.getMonth() && date.getFullYear()==today.getFullYear()) {
        if (inp.className) inp.className += ' ';
        inp.className+='today';
      }
      if (!isNaN(selected) && date.getDate()==selected.getDate() && date.getMonth()==selected.getMonth() && date.getFullYear()==selected.getFullYear()) {
        if (inp.className) inp.className += ' ';
        inp.className+='selected';
      }
      date.setDate(date.getDate()+1); // Increment a day
    }
    // We are done if we've moved on to the next month
    if (date.getMonth() != month.getMonth()) {
      break;
    }
  }
  
  // At the end, we do a quick insert of the newly made table, hopefully to remove any chance of screen flicker
  if (div.hasChildNodes()) { // For flicking between months
    div.replaceChild(tbl, div.childNodes[0]);
  } else { // For creating the calendar when they first click the icon
    div.appendChild(tbl);
  }
}

// This is called when they click the icon next to the date inputbox
function showDatePicker(idOfTextbox) {
  var textbox = document.getElementById(idOfTextbox);
  
  // See if the date picker is already there, if so, remove it
  x = textbox.parentNode.getElementsByTagName('div');
  for (i=0;i<x.length;i++) {
    if (x[i].getAttribute('class')=='datepickerdropdown') {
      textbox.parentNode.removeChild(x[i]);
      return false;
    }
  }

  // Grab the date, or use the current date if not valid
  var date = parseMyDate(textbox.value);
  if (isNaN(date)) date = new Date();

  // Create the box
  var div = document.createElement('div');
  div.className='datepickerdropdown';
  div.setAttribute('datepickertextbox', idOfTextbox); // Remember the textbox id in the div
  createCalendar(div, date); // Create the calendar
  insertAfter(div, textbox); // Add the box to screen just after the textbox
  return false;
}

// Adds an item after an existing one
function insertAfter(newItem, existingItem) {
  if (existingItem.nextSibling) { // Find the next sibling, and add newItem before it
    existingItem.parentNode.insertBefore(newItem, existingItem.nextSibling); 
  } else { // In case the existingItem has no sibling after itself, append it
    existingItem.parentNode.appendChild(newItem);
  }
}

/*
 * onDOMReady
 * Copyright (c) 2009 Ryan Morr (ryanmorr.com)
 * Licensed under the MIT license.
 */
function onDOMReady(fn,ctx){var ready,timer;var onStateChange=function(e){if(e&&e.type=="DOMContentLoaded"){fireDOMReady()}else if(e&&e.type=="load"){fireDOMReady()}else if(document.readyState){if((/loaded|complete/).test(document.readyState)){fireDOMReady()}else if(!!document.documentElement.doScroll){try{ready||document.documentElement.doScroll('left')}catch(e){return}fireDOMReady()}}};var fireDOMReady=function(){if(!ready){ready=true;fn.call(ctx||window);if(document.removeEventListener)document.removeEventListener("DOMContentLoaded",onStateChange,false);document.onreadystatechange=null;window.onload=null;clearInterval(timer);timer=null}};if(document.addEventListener)document.addEventListener("DOMContentLoaded",onStateChange,false);document.onreadystatechange=onStateChange;timer=setInterval(onStateChange,5);window.onload=onStateChange};

// This is called when the page loads, it searches for inputs where the class is 'datepicker'
onDOMReady(function(){
  // Search for elements by class
  var allElements = document.getElementsByTagName("*");
  for (i=0; i<allElements.length; i++) {
    var className = allElements[i].className;
    if (className=='datepicker' || className.indexOf('datepicker ') != -1 || className.indexOf(' datepicker') != -1) {
      // Found one! Now lets add a datepicker next to it  
    }
  }
  if(has_session)
  {
	console.log("Login successful.");
	$("#login-page").css({display:"none"});
	$("#menu-mgmt-page").show();
	$("#task").show();
	$("#task-2").hide();
	$("#fdbck-page").hide();
	
	if($(".alert")[0] != null)
	{
		for(let i = 0; i < $(".alert").length; i++)
			setSlideUp($(".alert")[i]);
	}
	
	if(localStorage.getItem('section') != null) {
		showFoods();
	}
	}
});

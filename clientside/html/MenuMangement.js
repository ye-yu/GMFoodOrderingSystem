function previewFile() {
  var preview = document.querySelector('img');
  var file    = document.querySelector('input[type=file]').files[0];
  var reader  = new FileReader();

  reader.addEventListener("load", function () {
    preview.src = reader.result;
  }, false);

  if (file) {
    reader.readAsDataURL(file);
  }
}

$(document).ready(function(){
	$("#login-btn").click(function(){
		$("#login-page").css({display:"none"});
		$("#menu-mgmt-page").show();
	});
});

$(document).ready(function(){
	$("#view-food").click(function(){
		$("#task").hide();
		$("#fdbck-page").hide();
		$("#task-2").show();
		var taskContent = $("#task-2");
		taskContent.empty();
		//have to initialize a variable 'total food'
		//here is set to 5
		var totalFood = 5;
		var taskTitle = $("<h5>");
		taskTitle.html("View Food");
		taskContent.append(taskTitle);
		//var foodCollection = '{"foodDetails":['+'{"foodname:":"Roti canai", "price:":"RM1.20"},'+'{"foodname:":"Roti bakar", "price:":"RM1.00"},'+'{"foodname:":"Roti naan", "price:":"RM2.00"}]}';
		//var food = JSON.parse(foodCollection);
		
		for(var i=0; i<5; i++){
			var viewBtn = $("<button>");
		viewBtn.html("View");
		viewBtn.attr("class", "view-food");	
		var rmBtn = $("<button>");
		rmBtn.html("Remove");
		rmBtn.attr("class","remove-food");
		rmBtn.attr("data-target",".bd-example-modal-lg");
		rmBtn.attr("data-toggle","modal");	
			var foodRecord = $("<div>");
			var newFood = $("<p>");
			//newFood.html(food.foodDetails[i].foodname + "|" + food.foodDetails[i].price);
			newFood.html("Roti canai" + "|" + "RM1.20")
			foodRecord.append(newFood);
			foodRecord.append(viewBtn);
			foodRecord.append(rmBtn);
			taskContent.append(foodRecord);
			foodRecord.children().css({display:"inline-block"});
		}
	});
	
});

$(document).ready(function(){
	$("#task-2").on("click",".remove-food",function(){
		var foodToBeRemoved = $(this).parent();
		var modalContent = $(".modal-content");
		modalContent.empty();
		var modalTitle = $("<h5>");
		modalTitle.html("Remove Food#1");
		var confirmBtn = $("<button>");
		confirmBtn.html("Confirm");
		confirmBtn.attr("id","confirm");
		var cancelBtn = $("<button>");
		cancelBtn.html("Cancel");
		cancelBtn.attr("data-dismiss","modal");
		modalContent.append(modalTitle);
		modalContent.append(confirmBtn);
		modalContent.append(cancelBtn);
		$("#confirm").click(function(){
			confirmBtn.attr("data-dismiss","modal");
			foodToBeRemoved.remove();
		});
		
	});
});
$(document).ready(function(){
	$("#task-2").on("click",".view-food",function(){
		var modalContent = $(".modal-content");
		modalContent.empty();
		var foodDetail = $("<div>");
		var foodImgDisp = $("<span>");
		var foodName = $("<h5>");
		foodName.html("Food Name: "+"Roti Canai");
		var foodPrice = $("<p>");
		foodPrice.html("Food Price: " + "RM"+1.00);
		var foodDesc = $("<p>");
		foodDesc.html("Malaysian Food =) ");
		foodDetail.append(foodName);
		foodDetail.append(foodPrice);
		foodDetail.append(foodDesc);
		foodDetail.css({float:"left"});
		var foodImage = $("<p>");
		foodImage.html("Insert image here");
		foodImgDisp.append(foodImage);
		foodImgDisp.css({border:"2px solid black"});
		modalContent.append(foodDetail);
		modalContent.append(foodImgDisp);
		
		$(".view-food").attr("data-target",".bd-example-modal-lg");
		$(".view-food").attr("data-toggle","modal");
		
	});
});

$(document).ready(function(){
	$("#add-food").click(function(){
		$("#task").show();
		$("#task-2").hide();
		$("#fdbck-page").hide();
	});
});

$(document).ready(function(){
	$("#view-fdbck").click(function(){
		$("#task").hide();
		$("#task-2").hide();
		$("#fdbck-page").show();
		var fdbckTitle = $("<p>");
		var tableNo = 5;
		fdbckTitle.html("Customer at Table No:" + tableNo + "said:")
		var fdbckContent = $("<p>");
		fdbckContent.html("Food was delicious");
		$("#fdbck-page").append(fdbckTitle);
		$("#fdbck-page").append(fdbckContent);
	});
});

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
});

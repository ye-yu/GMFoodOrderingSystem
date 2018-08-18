Static Class Main Programme
Begin
	Private foods: Array(Food)
	viewTable(size: Integer)
		Load ('/table.php?request=STATUS&seat_size=' + size)
		Retrieve tablenumber from the page
		Return tablenumber
	
	reserveTable(tableno: Integer)
		Load ('/table.php?request=RESERVE&table_number=' + tableno)
		Retrieve successful: Boolean from the page
		Return successful
	
	checkOrder(orderID: String): Boolean
		Declare order: Ordering
		Set order = new Ordering(TRUE)
		Declare isExisting: Boolean
		Set isExisting = Process order.loadOrder(id)
		Return isExisting
		
	loadMenu(updateMenu: Boolean): Array(Food)
		If updateMenu, Then
			foods = NULL
			Load ('/order.php?request=FOOD&food_id=ALL')
			Retrieve content: String from the page
			Declare foodListID: Array(String)
			Set foodListID = Parse Array(String) from content
			For Loop: i = the range of the array foodListID
				Declare food: Food
				Set Food = New Food(foodListID[i])
				Append food into foods
			End Loop
		Return foods
Exit

/*
Remarks: Correct the return type at the class diagram
*/
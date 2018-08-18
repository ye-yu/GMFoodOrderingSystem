Class Ordering
Begin
	Private orderID: String
	Private orderDate: Date
	Private orderTotal: Double
	Private orderPickTime: Time
	Private orderFeedback: String
	Private orderReadyStatus: Boolean
	Private orderFoods: Food[]
	
	Public Order()
		Set orderID = Process getIDFromDatabase()
		Exit
	
	Public Order(createEmpty: Boolean): Void
		If Not createEmpty, Then
			Set orderID = Process getIDFromDatabase()
		End If
		Exit

	Public getIDFromDatabase()
		Load ('/order.php?request=ID')
		Retrieve ID from the page
		Return ID
		

	Public loadOrder(id: Integer): Boolean
		Declare result: Dictionary(String, String)
		Set result = Process getDataFromDatabase(id)
		If result == NULL, then
			Return FALSE
		End If
		Set orderID = result['id']
		Set orderDate = result['date']
		Set orderTotal = result['total']
		Set orderPickTime = result['pickuptime']
		Set orderReadyStatus = result['readystatus']
		Set orderFoods = NULL
		Declare orderFoodsString: Array(String)
		Set orderFoodsString = Parse Array(String) from result['foodlistid']
		For Loop: i = the range of array orderFoodsString
			Declare food: Food
			Set food = new Food(orderFoodsString[i])
			Append food to orderFoods
		End Loop
		Return TRUE
		Exit

	Public getDataFromDatabase(id: Integer)
		Load('/order.php?request=ORDER&order_id=' + id)
		Set result = Retrieve JSON string from the page
		Return result
	
	Public addMenu(food: Food)
		Append food to foodlist[]
		calculateTotal()
		Exit
	
	Public removeMenu(food: Food)
		Remove food from foodlist[]
		calculateTotal
		Exit
	
	Private calculateTotal()
		Load ('/order.php?id=' + orderID + '&request=total')
		Retrieve total from the page
		Set orderTotal = total
		Return
	
	//Get Methods
	Public getOrderID()
		Return orderID
		
	Public getTotal()
		Return orderTotal
	
	Public getOrderReadyStatus()
		Return orderReadyStatus
		
	Public getFoods(): Array(Food)
		Return orderFoodsString
	
	//Set Methods
	Public setDate(date: Date)
		orderDate = date
		Exit
	
	Public setOrderReadyStatus(status: Boolean)
		Load ('/order.php?id=' + orderID + '&set_status=' + status)
		Set orderReadyStatus = status
		Exit
Exit

/*  
Remarks
1. Changes in class diagram:
	i. orderID data type is changed to String type
	ii. orderFeedback is a String type
	iv. Remove these methods:
		a) setTotal()
		b) setOrderStatus()
		c) getOrderStatus()
		
	v. Add these methods:
		a) loadOrder(id: Integer)
		b) getDataFromDatabase(id: Integer)
		c) getIDFromDatabase()
		d) calculateTotal()
		e) setOrderReadyStatus(status: Boolean)
		f) getOrderReadyStatus()
		g) getFoods()

	vi. Remove these attributes:
		a) orderStatus
		b) foodlist
	
	vii. Add these attributes:
		a) orderReadyStatus
		b) orderFoods

		viii. Change class name to Ordering
*/
Class Customer
Begin
	Private custID: String
	Private custName: String
	Private custPhoneNo: String
	Private order: Order
	
	Customer()
		Set custID = Process getIDFromDatabase()
		Exit
	
	Customer(createEmpty: Boolean)
		If Not createEmpty, Then
			Set custID = Process getIDFromDatabase()
		EndIf
		Exit
	Customer(name: String)
		Set custID = Process getIDFromDatabase(name)
		Exit
	
	Public addOrder(ord: Order)
		Set order = ord
		Exit
		
	Public cancelOrder()
		Set order = NULL
		Exit
		
	Public getIDFromDatabase()
		Load ('/customer.php?request=ID')
		Retrieve ID from the page
		Return ID
		
	Public getIDfromDatabase(name: String)
		Load ('/customer.php?findID=' + name)
		Retrieve ID from the page
		Return ID
	
	Public placeOrder(): Boolean
		Declare orders: String
		Set orders = Process stingify(order)
		Declare customerInformation: Array(String)
		Append custID, custName, custPhoneNo, orders to customerInformation
		Connect to ('/customer.php?action=PLACE_ORDER') by connection method POST with contents (customerInformation)
		Retrive status from the page
		Set status = Parse status as Boolean
		Return status 
		
	//Get methods
	Public getCustID()
		Return custID
	
	Public getCustName()
		Return custName
	
	Public getCustPhoneNo()
		Return custPhoneNo
		
	Public getOrder()
		Return order
		
	//Set methods		
	Public setCustName(name: String)
		Set custName = name
		Load ('/customer.php?id=' + custID + '&name=' + custName)
		Exit
		
	Public setCustPhoneNo(phoneNo: String)
		Set custPhoneNo = phoneNo
		Load ('/customer.php?id=' + custID + '&phone_no=' + custPhoneNo)
		Exit

Exit

/*
Remarks:
1. Changes in class diagram
	i. Change custID datatype to String
	ii. Correct the parameter of the method addOrder
	iii. add three methods:
		a) getIDfromDatabase()
		b) getIDfromDatabase(name: String)
		c) getOrder()
		d) placeOrder()
	iv. Remove setID()
*/
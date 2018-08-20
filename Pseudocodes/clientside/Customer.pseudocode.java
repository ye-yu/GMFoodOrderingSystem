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

    Public addOrder(ord: Order): Void
        Set order = ord
        Exit
        
    Public cancelOrder(): Void
        Set order = NULL
        Exit
        
    Public getIDFromDatabase(): String
        Load ('/serverside/php/customer.php?request=ID')
        Retrieve ID from the page
        Return ID
        
    Public getIDfromDatabase(name: String): String
        Load ('/serverside/php/customer.php?request=FIND_ID&name=' + name)
        Retrieve ID from the page
        Return ID

    Public placeOrder(): Boolean
        Declare orders: String
        Set orders = Process stingify(order)
        Declare customerInformation: Array(String)
        Append custID, custName, custPhoneNo, orders to customerInformation
        Connect to ('/serverside/php/customer.php?action=PLACE_ORDER') by connection method POST with contents (customerInformation)
        Retrive status from the page
        Set status = Parse status as Boolean
        Return status 
        
    //Get methods
    Public getCustID(): String
        Return custID

    Public getCustName(): String
        Return custName

    Public getCustPhoneNo(): String
        Return custPhoneNo
        
    Public getOrder(): Array(order)
        Return order
        
    //Set methods		
    Public setCustName(name: String): Void
        Set custName = name
        Load ('/serverside/php/customer.php?action=SET_NAME&id=' + custID + '&name=' + custName)
        Exit
        
    Public setCustPhoneNo(phoneNo: String): Void
        Set custPhoneNo = phoneNo
        Load ('/serverside/php/customer.php?action=SET_PHONE_NO&id=' + custID + '&phone_no=' + custPhoneNo)
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
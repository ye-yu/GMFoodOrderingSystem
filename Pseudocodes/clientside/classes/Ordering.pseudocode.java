Class Ordering
Begin
    Private orderID: String
    Private orderDate: Date
    Private orderTotal: Double
    Private orderPickTime: Time
    Private orderFeedback: String
    Private orderReadyStatus: Boolean
    Private orderFoods: Food[]

    Public Ordering()
        Set orderID = Process getIDFromDatabase()
		Set orderDate = Date now
        Exit

    Public Ordering(createEmpty: Boolean)
        If Not createEmpty, Then
            Set orderID = Process getIDFromDatabase()
        End If
		Set orderDate = Date now
        Exit

    Public getIDFromDatabase(): Void
        Load ('/serverside/php/order.php?request=ID')
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

    Public getDataFromDatabase(id: Integer): Dictionary(String, String)
        Load('/serverside/php/order.php?request=ORDER&order_id=' + id)
        Set content = Retrieve JSON string from the page
        Declare result: Dictionary(String, String)
        Set result = Parse Dictionary(String, String) from content
        Return result

    Public addMenu(food: Food): Void
        Append food to foodlist[]
        calculateTotal()
        Exit

    Public removeMenu(food: Food): Void
        Remove food from foodlist[]
        calculateTotal
        Exit

    Private calculateTotal(): Void
        Load ('/serverside/php/order.php?request=TOTAL&id=' + orderID)
        Retrieve total from the page
        Set orderTotal = total
        Return

    //Get Methods
    Public getOrderID(): String
        Return orderID
        
    Public getTotal()
        Return orderTotal

    Public getOrderReadyStatus()
        Load ('/serverside/php/order.php?request=STATUS&id=' + orderID)
        Retrieve content: String from the page
        Set orderReadyStatus = Parse Boolean from content
        Return orderReadyStatus
        
    Public getFoods(): Array(Food)
        Return orderFoodsString

    Public getFeedBack(): String
        Return orderFeedback
		
	Public getPickTime(): Time
		Return orderPickTime

    //Set Methods
    Public setDate(date: Date): Void
        Set orderDate = date
        Exit

    Public setPickTime(time: Time): Void
        Set orderPickTime = time
        Exit
        
    Public setFeedback(feed: String): Void
        Set orderFeedback = feed
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
		e) getOrderReadyStatus()
		f) getFoods()
		g) setPickTime(time: Time)
		h) setFeedback(feed: String)
		i) getFeedBack()
		j) getPickTime()

	vi. Remove these attributes:
		a) orderStatus
		b) foodlist
	
	vii. Add these attributes:
		a) orderReadyStatus
		b) orderFoods

		viii. Change class name to Ordering
*/
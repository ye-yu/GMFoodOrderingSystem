Static Class Kitchen
Begin
    Private Static foodQueue: Dictionary(String, Array(Food))

    Public Static retrieveOrderFromDatabase(): Void
        Load('/order.php?request=ORDER&order_id=ALL&ready_status=FALSE')
        Declare orders: Dictionary(String, Array(Food))
        Declare content: Dictionary(String, String)
        Set content = Retrieve JSON string from the page and parse Array(String)
        For Loop: i = the range of length of content
            Declare order: Ordering
            Set order = new Ordering(TRUE)
            Process order.loadOrder(content[i])
            Append order to orders
        End Loop
        Merge orders with foodQueue
        Exit

    Public Static updateOrderStatus(orderID: String, foodID: String, status: String): Void
        Connect to ('/order.php?action=UPDATE_ORDER') by connection method 'post' with contents ('order_id': orderID, 'food_ID': foodID)
        Retrieve successful from the page
        If Not successful, Then
            Process updateOrderStatus(orderID, foodID, status)
        End If
        Exit
Exit

/*
Remarks:
1. Changes in class diagram
	i. add static attribute orderQueue
	ii. remove UpdateOrderStatus
	iii. add updateFoodStatus()
	iv. remove commit update to database
*/
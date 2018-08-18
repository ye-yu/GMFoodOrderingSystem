Static Class Counter
Begin
    Private Static receiptID
	Public Static printReceipt(): Void
		Load ('pay.php?request=RECEIPT&receipt_id=' + receiptID)
		Set result = Retrieve JSON string from the page
		Declare content: Dictionary(String, String)
		Set content = parse result as Dicionary(String, String)
		Print content
		Exit

	Public Static pay(method: Integer): Boolean
		Load ('/pay.php?receipt_id=' + receiptID + '&method=' + method)
		Retrieve payment status
		Parse payment status as Boolean
		Return payment status
	
	Public Static findOrderByTable(tableno: Integer): Array(String)
		Load ('pay.php?request=ORDERSTATUSES&table_no=' + tableno)
		Set result = Retrieve JSON string from the page
		Declare content: Array(String)
		Set content = parse result as Array(String)
		Return content
	
	Public Static findOrderByOrderID(id: Integer): Boolean
		Declare order: Ordering
		Set order = new Ordering(TRUE)
		Declare isExisting: Boolean
		Set isExisting = Process order.loadOrder(id)
		If isExisting, Then
			If order.getOrderReadyStatus, Then
				Process generateReceiptID(order.getOrderID())
				Return TRUE
			End If
		End If
		Return FALSE
	
	Public Static generateReceiptID(orderID: Integer): Void
		Load ('/pay.php?request=GENERATE&orderID=' + orderID)
		Retrieve id from the page
		Set receiptID = id
		Exit
		
	Public Static emptyReceiptID(): Void
		Set receiptID = NULL
		Exit
Exit

/*
Remarks
1. Changes in Class diagram
    i. add static attribute receiptID
	ii. add static method findOrderByTable
	iii. add static method findOrderByOrderID
	iv. remove static method findOrder()
	v. remove static method usevoucher()
	vii. remove recordOrderAsPaid()
	viii. remove setOrder()
*/
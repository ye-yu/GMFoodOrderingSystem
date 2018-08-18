Declare noOfCustomer: Integer
Declare tableNumber: Integer
Declare reserved: Boolean
Declare customers: Array(Customer)

//Hardcoded 
Set tableNumber = 1
Set reserved = FALSE

waitingForReservation()
    While TRUE
        Load ('/table.php?request=TABLESTATUS&table_no=' + tableNumber)
        Retrieve status: Boolean from the page
        If Not status, Then
            Sleep for 1 second
        Else
            tableIsReserved()
            Break loop
        End If
    End Loop
    Exit

tableIsReserved()
    Load ('/table.php?request=RESERVATION&table_no=' + tableNumber)
    Retrieve numberOfCustomer: Integer from the page
    Set noOfCustomer = numberOfCustomer
    Set reserved = TRUE
    Exit

waitingContinueOnClick()
    If Not reserved, Then
        noOfCustomer = 1
        reserved = TRUE
    End If
    Declare waitingDOM: document
    Set waitingDOM = document.getElementById('waiting')
    Set waitingDOM.attribute = 'noshow'
    Declare nocDOM: document
    Set nocDOM = document.getElementById('numberOfCustomer')
    Set nocDOM.innerHTML = noOfCustomer
    Exit

splitTheBillYesOnClick()
    For Loop: i = the range of noOfCustomer
        Set customer[i] = new Customer
    End Loop
    changeSplitTheBillContent(FALSE) // this means yes button is clicked
    Exit

splitTheBillNoOnClick()
    changeSplitTheBillContent(TRUE) // 1this means no button
    
changeSplitTheBillContent(dismissNotification: Boolean)
    Declare splitDOM: document
    Set splitDOM = document.getElementById('splitTheBill')
    If dismissNotification, Then
            Set splitDOM.attribute = 'noshow'
    Else
            Set splitDOM.innerHTML = Modify content to show reminder, plus a button that respond to changeSplitTheBillContent(TRUE) // this means the reminder has been read
    EndIf
    Exit


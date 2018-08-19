Declare noOfCustomer: Integer
Declare tableNumber: Integer
Declare reserved: Boolean
Declare customers: Array(Customer)
Declare customersWithOrder: Dictionary(Customer, Ordering)

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
    dismissWaiting()
    Exit

dismissWaiting()
    Declare waitingDOM: document
    Set waitingDOM = document.getElementById('waiting')
    Set waitingDOM.attribute = 'noshow'
    Declare nocDOM: document
    Set nocDOM = document.getElementById('numberOfCustomer')
    Set nocDOM.innerHTML = noOfCustomer
    Exit

splitTheBillYesOnClick()
    For Loop: i = the range of noOfCustomer
        Set customers[i] = new Customer(tableNumber + "" + i)
        Set customersWithOrder[customers[i]] = new Ordering()
    End Loop
    changeSplitTheBillContent(FALSE) // this means yes button is clicked
    Exit

splitTheBillNoOnClick()
    changeSplitTheBillContent(TRUE) // 1this means no button
    Exit
    
changeSplitTheBillContent(dismissNotification: Boolean)
    Declare splitDOM: document
    Set splitDOM = document.getElementById('splitTheBill')
    If dismissNotification, Then
            Set splitDOM.attribute = 'noshow'
    Else
            refreshCustomerFoodOrder()
            Set splitDOM.innerHTML = Modify content to show reminder, plus a button that respond to changeSplitTheBillContent(TRUE) // this means the reminder has been read
    EndIf
    Exit

refreshCustomerFoodOrder()
    Declare customersDOM: document
    Set customersDOM = document.getElementById('customerOrders')
    For Loop: i = the range of noOfCustomer
        Declare subElement: document
        Set subElement = documet.createElement('div')
        Set subElement.attribute = 'customer'
        Set subElement.innerHTML += Display every order of customersWithOrder[customers[i]]
        Set subElement.innerHTML += Add button to call startOrdering(i) // i means the current customer number
        Process customersDOM.appendChild(subElement)
    End Loop
    Exit

startOrdering(customerNumber: Integer)
    Save all global attribes to cookie
    Declare form: document.createElement('form')
    Set form = createForm(form, customerNumber)
    Process form.submit()
    Exit
    
createForm(form: document, customerNumber: Integer)
    Set form.method = 'post'
    Set form.action = '/ordering.html'
    Declare subElement: document
    Set subElement = document.createElement('input')
    Set subElement.type = 'hidden'
    Set subElement.name = 'customer'
    Set subElement.value = customerNumber + " " + tableNumber
    Process form.appendChild(subElement)
    Set subElement = document.createElement('input')
    Set subElement.type = 'hidden'
    Set subElement.name = 'orders'
    Set subElement.value = JSON.stringify(customersWithOrder[])
    Process form.appendChild(subElement)
    Return form

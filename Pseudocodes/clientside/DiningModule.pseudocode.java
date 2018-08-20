Declare numberOfCustomer: Integer

dineInButtonOnClick()
	Declare popup: document
	Set popup = document.getElementById('enterNumberOfCustomer')
	Set popup.attribute = 'show'
	Exit

reserveTable(numberOfCustomer)
	Declare popup: document
	Set popup = document.getElementById('enterNumberOfCustomer')
	Set popup.attribute = 'noshow'
	Set popup = document.getElementById('reservingLoading')
	Set popup.attribute = 'show'
	Load ('/table.php?request=RESERVATION&no_of_customer=' + numberOfCustomer)
	Retrieve tableNumber: Integer from the page
	Set popup.attribute = 'noshow'
	Set popup = document.getElementById('reservation')
	Set popup.attribute = 'show'
	If (tableNumber < 0), Then
		Set popup.innerHTML = Display reservation failed message
	Else
		Set popup.innerHTML = Display the table number
	End If
	Exit
		
popupCloseButton(element: document)
	Set element.attribute = 'noshow'
	Exit
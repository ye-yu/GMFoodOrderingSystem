Static Class Manager
Begin
	Private loginSuccessful: Boolean
	Private foodOfInterest: Food
	
	Public Static loginToDatabase(username: String, password: String): Void
		Connect to ('/admin.php?') with connection method POST with content('USERNAME': username, 'PASSWORD': password)
		Retrieve successful: Boolean from the page
		Set loginSuccessful = successful
		Exit
Exit

/*

*/
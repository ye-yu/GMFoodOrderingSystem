Static Class Manager
Begin
    Private loginSuccessful: Boolean
    Private foodOfInterest: Food

    Public Static loginToDatabase(username: String, password: String): Void
        Connect to ('/admin.php?action=LOGIN') with connection method POST with content('username': username, 'password': password)
        Retrieve successful: Boolean from the page
        Set loginSuccessful = successful
        Exit
Exit

/*

*/
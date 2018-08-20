Static Class Manager
Begin
    Private loginSuccessful: Boolean
    Private foodOfInterest: Food

    Public Static loginToDatabase(username: String, password: String): Void
        Connect to ('/admin.php?action=LOGIN') with connection method 'post' with content('username': username, 'password': password)
        Retrieve successful: Boolean from the page
        Set loginSuccessful = successful
        Exit
		
	Public Static getMenu(): Array(Food)
		Declare foods: Array(Food)
		Load ('/order.php?request=FOOD&food_id=ALL')
		Retrieve content: String from the page
		Declare foodListID: Array(String)
		Set foodListID = Parse Array(String) from content
		For Loop: i = the range of the array foodListID
			Declare food: Food
			Set Food = New Food(foodListID[i])
			Append food into foods
		End Loop
        Return foods
	
	Public Static selectFood(food); Void
		Set foodOfInterest = food
		Exit
	
	Public Static createFood(): Food
		Declare food: Food
		Set food = new Food()
		Return food
	
	Public Static addFoodToDatabase(): Boolean
		Declare contents: Dictionary(String, String)
		Set contents['id'] = foodOfInterest.getFoodID()
		Set contents['name'] = foodOfInterest.getFoodName()
		Set contents['price'] = foodOfInterest.getFoodPrice()
		Set contents['description'] = foodOfInterest.getFoodDescription()
		Set contents['link'] = foodOfInterest.getFoodImageLink()
		Connect to ('/admin.php?action=ADD_FOOD') by connection method 'post' with content(contents)
		Retrieve successful: Boolean from the page
		Return successful
	
	Public Static removeFoodFromDatabase(id: String): Boolean
		Connect to ('/admin.php?action=REMOVE_FOOD') by connection method 'post' with content('id', id)
		Retrieve successful: Boolean from the page
		Return successful
Exit

/*
Remarks:
1. Change viewMenu() to getMenu()
2. Change setMenuOfInterest() to selectFood()
3. Change addFood() to addFoodToDatabase()
4. Remove commitToDatabase()
5. Add removeFoodFromDatabase()
*/
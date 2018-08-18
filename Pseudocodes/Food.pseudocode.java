Class Food
Begin
	Private foodID: String
	Private foodName: String
	Private foodPrice: Float
	Pricate foodDescription: String
	
	Food(id: String): Void
		If id != NULL, Then
			Process loadFood(id)
		Else
			Load ('/order.php?request=ID')
			Retrieve ID: String from the page
			Set foodID = ID
		End If
		Exit
		
	Public loadFood(id: String): Void
		Load ('/order.php?request=FOOD&food_ID=' + id)
		Retrieve content: String from the page
		Declare food: Dictionary(String, String)
		Set food = Parse Dictionary(String, String) from content
		Set foodID = id
		Set foodName = food['name']
		Set foodPrice = Parse Float from food['price']
		Set foodDescription = food['description']
	
	//Get methods
	Public getFoodID(): String
		Return foodID
	
	Public getFoodName(): String
		Return foodName
	
	Public getFoodPrice(): Float
		Return foodPrice
	
	Public getFoodDescription: String
		Return foodDecription
	
	//Set methods
	Public setFoodID(id: String): Void
		Set foodID = id
		Exit
		
	Public setFoodName(name: String): Void
		Set foodName = name
		Exit
	
	Public setFoodPrice(price: Float): Void
		Set foodPrice = price
		Exit
	
	Public setFoodDescription(desc: String): Void
		Set foodDecription = desc
		Exit
		
Exit

/*
Remarks
1. Changes in class diagram:
	i. remove drinkname
	ii. add the rest of the attributes from the data dictionary
*/
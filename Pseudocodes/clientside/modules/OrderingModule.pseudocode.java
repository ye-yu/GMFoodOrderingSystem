Declare itemsInCart: Integer
Set itemsInCart = 0

Declare foodsByCategory: Dictionary(String, Array(Food))
Declare foods: Array(Food)
getMenu()

getMenu()
	Load ('/order.php?request=FOOD&food_id=ALL&group_by=CATEGORY')
	Retrieve content: Dictionary(String, Array(String)) from the page
	For Loop: i = the key of content
		Declare foodArray: Array(Food)
		For Loop: k = the range of content[i]
			Declare food: Food
			Set food = new Food(content[i][k])
			Append food to foodArray
			Append food to foods
		End Loop 
		Set foodsByCategory[i] = foodArray
	End Loop



//For modifying the elements in the 
//list of foods in the menu
Declare menuHeader: document
Set menuHeader = document.getElementById('menuheader')
Declare cartNumber: document
Set cartNumber = document.getElementById('cartnumber')
Declare menuList: document
Set menuList: document.getElementById('menulist')

//Given that the radio button 'Category'
//is mapped to this function when on
//click
categoryOnClick()
	Set menuHeader.innerHTML = 'Categories'
	Set menuList.innerHTML = ''
	Declare categories
	For Loop: i = the key of foodsByCategory
		Set menuList.appendChild(createCategoryBox(i, foodsByCategory[i][0].getImageLink()))
	End Loop
	Exit

createCategoryBox(element: document, image: String)
	Declare box: document
	Set box = document.createElement('div')
	Set box.attribute = 'listbox'
	
	
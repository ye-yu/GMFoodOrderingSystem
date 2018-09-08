food = []
while(True):
	x = input("=>")
	if (x == "x"):
		break;
	food.append(x)
print("document.getElementById('ordering-content').innerHTML = '';")
print("var itemlisting = null;")
print("var string = '';")
print("for(var i = 0; i < ; i++) {")
print("if(i % 3 == 0){")
print("	itemlisting = document.createElement('div');")
print("	itemlisting.className = 'container-fluid bg-3 text-center';")
print("	itemlisting.innerHTML = ''")
print("string += '			  <div class=\"row\">';")
print("}")
for i in range(len(food)):
	print("string += '" + food[i] + "';")
print("if(i % 3 == 2) {")
print("	string += '			  </div>';")
print("itemlisting.innerHTML += string;")
print("string = '';")
print("document.getElementById('ordering-content').appendChild(itemlisting);")
print("}")
print("}")
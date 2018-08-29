from random import randint
def idgenerator():
	chars = "QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm1234567890"
	x = ""
	for i in range(10):
		x = x + chars[randint(0, 26+26+10-1)]
	return x
	
food = []
while(True):
	x = input("=>")
	if (x == "x"):
		break;
	food.append(x)
for i in range(len(food)):
	print("insert into food values('" + idgenerator() + "', '" + food[i] + "', " + str(randint(0,20)) + "." + str(randint(0,9)) + "0, 'drink', 'Amet doloribus ut iste aut eum veritatis et. Harum consectetur eum sed atque. Explicabo consequatur quod mollitia eum atque voluptatum vero ullam. Vitae consequatur ut placeat quos aperiam voluptatum. Voluptatem quia et rerum iure aperiam facere qui at.', null);")
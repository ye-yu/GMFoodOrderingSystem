s = []
while(True):
	x = input("=>")
	if(x == "x"):
		break;
	s.append(x)
print("var stg = '';")
for i in range(len(s)):
	print("stg += '" + s[i] + "';")
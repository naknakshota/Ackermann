#
#Ackerman Function in Python3
#    Author: @Shota Nakamura
#

####More information on Ackerman functions can be found on https://en.wikipedia.org/wiki/Ackermann_function
def f1(m : int, n : int):
	if(m == 0): 
		return n
	elif(n == 1):
		return 2**m
	else:
		return f1(m-1,f1(m-1,n+1))
	
def f2(m : int, n: int):
	if(m==0):
		return 1
	elif(n==0):
		return 1
	elif(m==1):
		return 2*n
	else: 
		return f2(m-1,f2(m,n-1))

//	This quick little program proves my ability to complete the FizzBuzz test.

//	Rules: print out every number from 1 to 100 EXCEPT:
//		For numbers divisible by 3, print out 'Fizz...'
//		For numbers divisible by 5, print out 'Buzz...'
//		For numbers divisible by 3 *and* 5, print out 'FIZZBUZZ!'

#include <iostream>

using namespace std;

int main() {
	//	alert user to program specification
	cout << "FizzBuzz test!  For all numbers inclusive from 1 through 100,\n";
	cout << "print 'Fizz' if the number is divisible by 3, 'Buzz' if the number\n";
	cout << "is divisible by 5, and 'FIZZBUZZ!' if the number is divisible by\n";
	cout << "both!  Otherwise just print out the number.\n\n";

	//	for loop iterates on i from 1 through 100
	for( unsigned i = 1; i < 101; i++ ) {
		//	if i divisible by 3 and 5, FIZZBUZZ!
		if( i % 3 == 0 && i % 5 == 0 ) cout << "FIZZBUZZ!\n";
		//	if i divisible by 3 and not 5, Fizz
		else if( i % 3 == 0 ) cout << "Fizz...\n";
		//	if i divisible by 5 and not 3, Buzz
		else if( i % 5 == 0 ) cout << "Buzz...\n";
		//	if not divisible by 3 and not by 5, print number
		else cout << i << endl;
	}

	//	alert user program is complete
	cout << "Done!\n\n";

	//	return
	return 0;
}	//	main

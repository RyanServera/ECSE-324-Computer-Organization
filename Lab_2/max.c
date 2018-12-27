extern int MAX_2(int x, int y);

int main(){
	int a[5] = {111, 21, 3, 44, 5}; // instantiate array
	int max_val;
	int i;
	int length = sizeof(a)/sizeof(a[0]); // find size of array
	max_val = a[0];	// set the first the max

	for(i = 1; i < length; i++){

		// calls the subroutine to find the max  
		max_val = MAX_2(max_val, a[i]); 

	}

	// returns the max value
	return max_val;
}
int main(){

	// initialize array 
	int a[5] = {1, 20, 3, 4, 5};
	
	// max value variable
	int max_val;

	// counter
	int i;

	// length of the array
	int length = sizeof(a)/sizeof(a[0]);
	
	for(i = 0; i < length; i++){
	
		// iterate through the array and store largest value
		if(i == 0){
	        max_val = a[i];
	    	}else{
	        if(a[i] > max_val){
	            max_val = a[i];
	        }
	    }
	}
	// return max value 
	return max_val;
}
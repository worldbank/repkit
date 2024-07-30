* test 1 (unstable results)

* Load data 
sysuse auto, clear

bys mpg:  /// sorting by mpg	
gen dup = cond(_N==1,0,_n)
	
drop if dup > 1
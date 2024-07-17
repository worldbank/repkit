* test 2 (stable results)

sysuse auto, clear

bys make:  /// sorting by mpg	
gen dup = cond(_N==1,0,_n)
	
drop if dup > 1
	
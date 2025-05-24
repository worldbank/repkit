	
	local tag "v3.1"
	net install repkit, from("C:\Users\WB462869\github\repkit\src") replace
	
	clear all
	reproot, project("repkit") roots("clone") prefix("repkit_") 
	local testfldr "${repkit_clone}/src/tests"
	
	cap mkdir "`testfldr'/dev-env"
	
	// Test all commands in the package
	local commands_to_test lint repado repadolog repkit reproot reprun
	foreach cmd of local commands_to_test {
		noi di "RUN TESTS FOR: `cmd'"
		do "`testfldr'/`cmd'/`cmd'.do"
	}

	

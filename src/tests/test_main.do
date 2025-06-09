
	
	clear all
	
	* Save original PLUS folder to restore in end of file
	local original_plus "`c(sysdir_plus)'"
	
	* Get required roots
	reproot, project("repkit") roots("clone") prefix("repkit_") 
	local testfldr "${repkit_clone}/src/tests"
	
	* Make sure env folder for test version exists
	cap mkdir "`testfldr'/dev-env"
	repado using "`testfldr'/dev-env" 
	
	net install repkit, from("C:\Users\WB462869\github\repkit\src") replace
	
	* Test all commands in the package
	local commands_to_test lint repado repadolog repkit reproot reprun
	foreach cmd of local commands_to_test {
		
		* Run this commands test file
		noi di "RUN TESTS FOR: `cmd'"
		do "`testfldr'/`cmd'/`cmd'.do"
		
		* Reset ado-folder if changed when testing repado
		repado using "`testfldr'/dev-env" , lessverbose
	}

	* reset original settings
	repado using "`original_plus'" , lessverbose
	

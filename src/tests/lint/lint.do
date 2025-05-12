    * Always important to version control built-in Stata functions
    version 16.0
    
    * Do not use reproot when testing commands in repkit
    
	* Fill in your root path here
    global repkit_clone "C:/WBG/repos/repkit"
    
    * Use locals for all non-root paths
    local testfldr "${repkit_clone}/src/tests"

    * Use the /dev-env folder as a dev environment
    cap mkdir    "`testfldr'/dev-env"
    repado using "`testfldr'/dev-env"

    * Make sure the version of repkit in the dev environment us up to date with all edits.
    cap net uninstall repkit
    net install repkit, from("${repkit_clone}/src") replace

    ************************
    * Run tests

    lint "`testfldr'/lint/test-files/bad.do"
  
    lint "`testfldr'/lint/test-files/simple.do"

    

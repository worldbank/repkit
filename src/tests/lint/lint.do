    * Always important to version control built-in Stata functions
    version 14.1
    
    noi di "`c(username)'"

    * Do not use reproot when testing commands in repkit
    
    if "`c(username)'" == "WB462869" {
        global repkit_clone "C:\Users\wb462869\github\repkit"
    }
    * Fill in your root path here
    if "`c(username)'" == "bbdaniels" {
        global repkit_clone "/Users/bbdaniels/GitHub/repkit"
    }

    if "`c(username)'" == "wb558768" {
        global repkit_clone "C:/Users/wb558768/Documents/GitHub/repkit"
    }

    * Use locals for all non-root paths
    local testfldr "${repkit_clone}/src/tests"

    * Use the /dev-env folder as a dev environment
    cap mkdir    "`testfldr'/dev-env"
    repado using "`testfldr'/dev-env"

    * Make sure repkit is installed also in the dev environment
    cap which repkit
    if _rc == 111 ssc install repkit

    * Make sure the version of repkit in the dev environment us up to date with all edits.
    cap net uninstall repkit
    net install repkit, from("${repkit_clone}/src") replace

    ************************
    * Run tests

    lint "`testfldr'/lint/test-files/bad.do"
  
    lint "`testfldr'/lint/test-files/simple.do"

    

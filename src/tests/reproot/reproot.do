
    cap which repkit
    if _rc == 111 {
        di as error `"{pstd}This test file use features from the package {browse "https://worldbank.github.io/repkit/":repkit}. Click {stata ssc install repkit} to install it and run this file again.{p_end}"'
    }

    *************************************
    * Set root path
    * This is the only test file that cannot 
    * use reproot as it is testing reproot

    di "Your username: `c(username)'"
    * Set each user's root path
    if "`c(username)'" == "`c(username)'" {
        global root "C:/Users/wb462869/github/repkit"
    }
    * Set all other user's root paths on this format
    if "`c(username)'" == "" {
        global root ""
    }

    * Set global to the test folder
    global src   "${root}/src"
    global tests "${src}/tests"

    * Set up a dev environement for testing locally
    cap mkdir    "${tests}/dev-env"
    repado using "${tests}/dev-env"

    * If not already installed in dev-env, add repkit to the dev environment
    cap which repkit
    if _rc == 111 ssc install repkit

    * Install the latest version of repkit to the dev environment
    net uninstall repkit
    net install repkit, from("${src}") replace

    * Test 1 - this should all work without error
    local prj1 "reproot-test-1"
    local pref "test1_"

    * Reset globals
    global `pref'clone ""
    global `pref'data ""

    * Run command
    reproot, project("`prj1'") roots("clone") prefix("`pref'") verbose
    reproot, project("`prj1'") roots("clone data") optroot("nonexist") prefix("`pref'")
    reproot, project("`prj1'") roots("clone data") prefix("`pref'")

    * Test 2 - this project has two clone roots
    local prj2 "reproot-test-2"
    local pref "test2_"

    * Reset globals
    global `pref'clone ""

    * Run command - expected error as two roots named clone exist
    cap reproot, project("`prj2'") roots("clone") prefix("`pref'")
    di _rc
    if !(_rc == 99) reproot, project("`prj2'") roots("clone") prefix("`pref'")
    
    
    * Run command - expected error as nonexist is set as required root
    cap reproot, project("`prj1'") roots("clone data nonexist") prefix("`pref'")
    di _rc
    if !(_rc == 99) reproot, project("`prj1'") roots("clone data nonexist") prefix("`pref'")

    cap which repkit
    if _rc == 111 {
        di as error `"{pstd}This test file use features from the package {browse "https://dime-worldbank.github.io/repkit/":repkit}. Click {stata ssc install repkit} to install it and run this file again.{p_end}"'
    }

    *************************************
    * Set root path
    * TODO: Update with reprun once published

    di "Your username: `c(username)'"
    * Set each user's root path
    if "`c(username)'" == "`c(username)'" {
        global root "C:/Users/wb462869/github//repkit"
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

    /* TODO: Uncomment once adodown is published
    * If not already installed, add adodown to the dev environment
    cap which adodown
    if _rc == 111 ssc install adodown
    */

    * Install the latest version of repkit to the dev environment
    cap net uninstall repkit
    net install repkit, from("${src}") replace

    * Test basic case of the command reproot

    global data ""
    global clone ""
    global kb_data ""
    global kb_clone ""

    reproot, project("repkit") roots("clone") prefix("kb_")
    di "${clone}"
    di "${kb_clone}"
    
    reproot, project("repkit") roots("clone data") prefix("kb_")
    
    reproot, project("repkit") roots("clone data") prefix("kb_")

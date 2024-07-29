

    * Do not use reproot when testing commands in repkit
    * Kristoffer's root path
    if "`c(username)'" == "wb462869" {
        global repkit_clone "C:\Users\wb462869\github\repkit"
    }
    * Fill in your root path here
    if "`c(username)'" == "bbdaniels" {
        global repkit_clone "/Users/bbdaniels/GitHub/repkit"
    }

    if "`c(username)'" == "wb558768" {
        global repkit_clone "C:/Users/wb558768/Documents/GitHub/repkit"
    }

    * Set global to ado_fldr
    global src_fldr  "${repkit_clone}/src"
    global test_fldr "${src_fldr}/tests"
    global run_fldr  "${test_fldr}/reprun"
    global tf        "${run_fldr}/targets"
    global sf        "${run_fldr}/single-file"
    global mf        "${run_fldr}/multi-file"
    global lf        "${run_fldr}/loop-file"
    global wca       "${run_fldr}/with-clear-all"
    global waf       "${run_fldr}/with-ado-folder"
    global swu		 "${run_fldr}/stable-with-unstable"

    * Install the version of this package in
    * the plus-ado folder in the test folder

    cap mkdir    "${test_fldr}/dev-env/"
    repado using "${test_fldr}/dev-env/"
    cap net uninstall repkit
    net       install repkit, from("${src_fldr}") replace

    file close _all

    * Example 0 - Ben's files
    clear
    cap mkdir "${tf}/output-1"
    cap mkdir "${tf}/output-2"
    cap mkdir "${tf}/output-3"
    cap mkdir "${tf}/comments"

    reprun "${tf}/comments.do" using "${tf}/comments" , debug

    reprun "${tf}/target-1.do" using "${tf}/output-1" , debug
    reprun "${tf}/target-1.do" using "${tf}/output-1" , v debug
    reprun "${tf}/target-1.do" using "${tf}/output-1" , c debug
    reprun "${tf}/target-1.do" using "${tf}/output-2" , s(loop)
    reprun "${tf}/target-1.do" using "${tf}/output-3" , v s(rng)
    reprun "${tf}/target-1.do" ,  verbose
    reprun "${tf}/target-mmm.do"

    * Example A - single file
    cap mkdir "${sf}/output"
    reprun "${sf}/main.do" using "${sf}/output" , verbose

    * Example B - multiple file
    cap mkdir "${mf}/output"
    reprun "${mf}/main.do" using "${mf}/output"

    * Example C - multiple file
    cap mkdir "${mf}/output_verbose"
    reprun "${mf}/main.do" using "${mf}/output_verbose"

    * Example D - multiple file
    cap mkdir "${lf}/output"
    reprun "${lf}/main.do" using "${lf}/output" , verbose s(loop)

    * Example E - with clear all
    cap mkdir "${wca}/output"
    reprun "${wca}/main.do" using "${wca}/output" , debug

    * Example F - with project ado-folder
    cap mkdir "${waf}/output"
    reprun "${waf}/main.do" using "${waf}/output" , debug

    * Example g - output with stable and unstable do-files
    cap mkdir "${swu}/output"
    reprun "${swu}/main.do" using "${swu}/output"

    net install repkit, from("${src_fldr}") replace

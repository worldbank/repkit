
    * Kristoffer's root path
    if "`c(username)'" == "wb462869" {
        global clone "C:\Users\wb462869\github\repkit"
    }
    * Fill in your root path here
    if "`c(username)'" == "bbdaniels" {
        global clone "/Users/bbdaniels/GitHub/repkit"
    }

    * Set global to ado_fldr
    global src_fldr  "${clone}/src"
    global test_fldr "${src_fldr}/tests"
    global run_fldr  "${test_fldr}/reprun"
    global tf        "${run_fldr}/targets"
    global sf        "${run_fldr}/single-file"
    global mf        "${run_fldr}/multi-file"
    global lf        "${run_fldr}/loop-file"
    global wca       "${run_fldr}/with-clear-all"
    global waf       "${run_fldr}/with-ado-folder"

    * Install the version of this package in 
    * the plus-ado folder in the test folder
    repado , adopath("${test_fldr}/plus-ado/") mode(strict)
    cap net uninstall repkit
    net install repkit, from("${src_fldr}") replace

    file close _all

    * Example 0 - Ben's files
    clear
    cap mkdir "${tf}/output-1"
    cap mkdir "${tf}/output-2"
    cap mkdir "${tf}/output-3"
    reprun "${tf}/target-1.do" using "${tf}/output-1" , debug
    reprun "${tf}/target-1.do" using "${tf}/output-2" , s(srng loop)
    reprun "${tf}/target-1.do" using "${tf}/output-3" , compact  s(rng srng dsig)
    reprun "${tf}/target-1.do"  ,  verbose

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
    reprun "${waf}/main.do" using "${waf}/output" , debug 

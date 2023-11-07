
    * Kristoffer's root path
    if "`c(username)'" == "wb462869" {
        global clone "C:\Users\wb462869\github\repkit"
    }
    * Fill in your root path here
    if "`c(username)'" == "bbdaniels" {
        global clone "/Users/bbdaniels/GitHub/repkit"
    }

    * Set global to ado_fldr
    global ado_fldr "${clone}/src/ado"
    global run_fldr "${clone}/src/tests/reprun"
    global tf       "${run_fldr}/targets"
    global sf       "${run_fldr}/single-file"
    global mf       "${run_fldr}/multi-file"
    global lf       "${run_fldr}/loop-file"

    qui do          "${ado_fldr}/reprun.ado"
    qui do          "${ado_fldr}/reprun_dataline.ado"

    file close _all

    * Example 0 - Ben's files
    reprun "${tf}/target-1.do" using "${tf}/"
    reprun "${tf}/target-1.do" using "${tf}/" , s(srng)
    reprun "${tf}/target-1.do" using "${tf}/" , compact  s(rng srng dsig)
    reprun "${tf}/target-1.do"  ,  verbose
-
    * Example A - single file
    reprun "${sf}/main.do" using "${sf}/output" , verbose

    * Example B - multiple file
    reprun "${mf}/main.do" using "${mf}/output"

    * Example C - multiple file
    reprun "${mf}/main.do" using "${mf}/output_verbose"

    * Example D - multiple file
    reprun "${lf}/main.do" using "${lf}/output" , verbose

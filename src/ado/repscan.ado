

cap program drop repscan
program define repscan, rclass

{
    
    version 14.1
    
    // take do-file as argument
    args do_file
    
    // reading file
    file open myfile using "`do_file'", read
    display("Scanning file `do_file':")
    file read myfile line
    
    //iterating through lines, saving lines in rows
    local n_line = 1
    while r(eof) == 0 {
            
        display("    Scanning line `n_line'...")
        
        // checking possible reproducibility issues
        _check_merge_mm       "`line'"
        _check_dup_drop_force "`line'"
        _check_sort           "`line'"
        _check_sortseed       "`line'"
        _check_bysort         "`line'"
        _check_reclink        "`line'"
        
        // increment in line counter and content
        local n_line = `n_line' + 1
        file read myfile line
            
    }
    file close myfile
    
}

end

/***************************************************************************
****************************************************************************

  Auxiliary functions

****************************************************************************
***************************************************************************/

    /*************************************************************************
      check_merge_mm: detects the use of a many-to-many merge on a local string
    *************************************************************************/
    cap program drop _check_merge_mm
    program define _check_merge_mm
    {
        // Take the name of a string local as the argument
        args mystring

        // Check if "merge m:m" is present
        local regx "^\s*merge +m:m"
        if ustrregexm("`mystring'", "`regx'") {
            display as result `"        m:m merge found"'
        }
    }
    end
    
    /*************************************************************************
      check_dup_drop_force: detects the use of a forced drop of duplicates
    *************************************************************************/
    cap program drop _check_dup_drop_force
    program define _check_dup_drop_force
    {
        // Take the name of a string local as the argument
        args mystring
        
        // Check if the line is a forced drop of duplicates with the syntax:
        // duplicates drop *, force
        local regx "^\s*duplicates +drop[^,]*, +force"
        if ustrregexm("`mystring'", "`regx'") {
            display as result `"        Forced drop of duplicates found"'
        }
    }
    end
    
    /*************************************************************************
      check_sort: detects the use of a sort
    *************************************************************************/
    cap program drop _check_sort
    program define _check_sort
    {
        // Take the name of a string local as the argument
        args mystring
        
        // Check if the line is sorting
        local regx "^\s*sort +"
        if ustrregexm("`mystring'", "`regx'") {
            display as result `"        Sort found"'
        }
    }
    end
    
    /*************************************************************************
      check_sortseed: detects the use of a sortseed
    *************************************************************************/
    cap program drop _check_sortseed
    program define _check_sortseed
    {
        // Take the name of a string local as the argument
        args mystring
        
        // Check if the line is a sortseed
        local regx "^\s*set +sort(seed|rngstate)"
        if ustrregexm("`mystring'", "`regx'") {
            display as result `"        Sortseed found"'
        }
    }
    end
    
    /*************************************************************************
      check_bysort: detects the use of a sortseed
    *************************************************************************/
    cap program drop _check_bysort
    program define _check_bysort
    {
        // Take the name of a string local as the argument
        args mystring
        
        // Check if the line is a bysort
        local regx "^\s*bys[^:]{2,}:"
        if ustrregexm("`mystring'", "`regx'") {
            display as result `"        bysort found"'
        }
    }
    end
    
    /*************************************************************************
      check_reclink: detects the use of reclink
    *************************************************************************/
    cap program drop _check_reclink
    program define _check_reclink
    {
        // Take the name of a string local as the argument
        args mystring
        
        // Check if the line uses reclink
        local regx "\s*reclink"
        if ustrregexm("`mystring'", "`regx'") {
            display as result `"        reclink found"'
        }
    }
    end

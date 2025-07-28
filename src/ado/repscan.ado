

cap program drop repscan
program define repscan

{
    
    version 14.1
    
    syntax anything,   ///
        [              ///
            complete   ///
        ]
    
    // take do-file as argument
    args do_file
    
    // complete scan of issues or basic scan
    if !missing("`complete'") {
        local complete = 1
    }
    else {
        local complete = 0
    }
    
    // reading file
    cap file close _myfile
    file open _myfile using "`do_file'", read
    display("Scanning do-file `do_file':")
    file read _myfile line
    
    
    // defining locals for line counter and multiline checks
    local n_line      = 1
    local setseed     = 0
    local set_version = 0
    
    // iterating through lines
    while r(eof) == 0 {
            
        // checking if line has "REPSCAN OK"
        _check_repscan_ok        `"`line'"'
        
        if `r(_repscan_ok)' == 1 {
            // do nothing
        }
        else {
            
            // 1 - Critical checks are always performed
        
                // checking single-line reproducibility issues
                _check_merge_mm       `"`line'"' `n_line'
                _check_dup_drop_force `"`line'"' `n_line'
                
                // detection for multi-line issues: setseed
                if `setseed' == 0 {
                    _check_setseed    `"`line'"'
                    local setseed = `r(_setseed)'
                }
                
                // checking multiline issue: runiform without setseed
                if `setseed' == 0 {
                    _check_runiform   `"`line'"' `n_line'
                }
            
            // 2 - Other checks are only performed in complete mode
            
            if `complete' == 1 {
                
                // checking single-line reproducibility issues
                _check_sort           `"`line'"' `n_line'
                _check_sortseed       `"`line'"' `n_line'
                _check_bysort         `"`line'"' `n_line'
                _check_reclink        `"`line'"' `n_line'
                
                // detection for multi-line issues: version
                if `set_version' == 0 {
                    _check_version    `"`line'"'
                    local set_version = `r(_set_version)'
                }
                
                // checking multiline issue: setseed without version
                if `set_version' == 0 {
                    _check_setseed_as_issue `"`line'"' `n_line'
                }
                
            }
        }

        // increment in line counter and update content
        local n_line = `n_line' + 1
        file read _myfile line
            
    }
    file close _myfile
    
}

end

/***************************************************************************
****************************************************************************

  Auxiliary functions

****************************************************************************
***************************************************************************/

    /*************************************************************************
      check_version: detects version is set
        Note that it doesn't print a detection message but returns a scalar
    *************************************************************************/
    cap program drop _check_version
    program define _check_version, rclass
    {
        // Take the name of a string local as the argument
        args mystring
        
        // Check if "version XX" is present
        local regx "^\s*version +\d{1,2}"
        if ustrregexm(`"`mystring'"', "`regx'") {
            return scalar _set_version = 1
        }
        else {
            return scalar _set_version = 0
        }
    }
    end

    /*************************************************************************
      check_repscan_ok: detects "REPSCAN OK" at the end of a line
        Note that it doesn't print a detection message but returns a scalar
    *************************************************************************/
    cap program drop _check_repscan_ok
    program define _check_repscan_ok, rclass
    {
        // Take the name of a string local as the argument
        args mystring
        
        // Check if "set seed" is present
        local regx "REPSCAN +(?:O|o)(?:K|k) *$"
        if ustrregexm(`"`mystring'"', "`regx'") {
            return scalar _repscan_ok = 1
        }
        else {
            return scalar _repscan_ok = 0
        }
    }
    end

    /*************************************************************************
      check_runiform: detects the use of runiform
    *************************************************************************/
    cap program drop _check_runiform
    program define _check_runiform
    {
        // Take the name of a string local as the argument
        args mystring n_line
        
        // Check if "runiform" is present
        local regx "= +runiform\("
        if ustrregexm(`"`mystring'"', "`regx'") {
            display as result `"    Line `n_line': found runiform() without setting a seed first"'
        }
    }
    end
    
    
    /*************************************************************************
      check_setseed: detects the use of set seed.
        Note that it doesn't print a detection message but returns a scalar
    *************************************************************************/
    cap program drop _check_setseed
    program define _check_setseed, rclass
    {
        // Take the name of a string local as the argument
        args mystring
        
        // Check if "set seed" is present
        local regx "^\s*set +seed +\d+"
        if ustrregexm(`"`mystring'"', "`regx'") {
            return scalar _setseed = 1
        }
        else {
            return scalar _setseed = 0
        }
    }
    end
    
    /*************************************************************************
      check_setseed_as_issue: also detects the use of set seed.
        But note this functions prints the result as an issue flagged
        instead of returning a scalar
    *************************************************************************/
    cap program drop _check_setseed_as_issue
    program define _check_setseed_as_issue
    {
        // Take the name of a string local as the argument
        args mystring n_line
        
        // Check if "set seed" is present
        local regx "^\s*set +seed +\d+"
        if ustrregexm(`"`mystring'"', "`regx'") {
            display as result `"    Line `n_line': found set seed without setting the version first"'
        }
    }
    end

    /*************************************************************************
      check_merge_mm: detects the use of a many-to-many merge on a local string
    *************************************************************************/
    cap program drop _check_merge_mm
    program define _check_merge_mm
    {
        // Take the name of a string local as the argument
        args mystring n_line

        // Check if "merge m:m" is present
        local regx "^\s*merge +m:m"
        if ustrregexm(`"`mystring'"', "`regx'") {
            display as result `"    Line `n_line': m:m merge found"'
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
        args mystring n_line
        
        // Check if the line is a forced drop of duplicates with the syntax:
        // duplicates drop *, force
        local regx "^\s*duplicates +drop[^,]*, +force"
        if ustrregexm(`"`mystring'"', "`regx'") {
            display as result `"    Line `n_line': forced drop of duplicates found"'
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
        args mystring n_line
        
        // Check if the line is sorting
        local regx "^\s*sort +"
        if ustrregexm(`"`mystring'"', "`regx'") {
            display as result `"    Line `n_line': sort found"'
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
        args mystring n_line
        
        // Check if the line is a sortseed
        local regx "^\s*set +sort(seed|rngstate)"
        if ustrregexm(`"`mystring'"', "`regx'") {
            display as result `"    Line `n_line': sortseed found"'
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
        args mystring n_line
        
        // Check if the line is a bysort
        local regx "^\s*bys[^:]{2,}:"
        if ustrregexm(`"`mystring'"', "`regx'") {
            display as result `"    Line `n_line': bysort found"'
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
        args mystring n_line
        
        // Check if the line uses reclink
        local regx "^\s*reclink"
        if ustrregexm(`"`mystring'"', "`regx'") {
            display as result `"    Line `n_line': reclink found"'
        }
    }
    end

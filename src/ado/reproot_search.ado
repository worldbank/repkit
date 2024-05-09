*! version 2.0 20240509 - DIME Analytics & LSMS Team, The World Bank - dimeanalytics@worldbank.org, lsms@worldbank.org

cap program drop   reproot_search
    program define reproot_search, rclass

qui {

    version 14.1

    syntax ,                  ///
        path(string)          ///
        recsleft(numlist) ///
      [                       ///
        skipdirs(string)      ///
        recurse               ///
      ]

    * Initiate dir counter at 1
    local d_count 1
    local next_recsleft = `recsleft' - 1
    local rootdirs ""

    local root_file "reproot.yaml"

    /***************************************************
      Initiate things in the original call
    ***************************************************/

    * Start a timer if orginal run.
    if missing("`recurse'") {
      * TODO: do not hardcode timer number, find first availible
      timer clear 68
      timer on 68
    }

    /***************************************************
      Look for reproot file
    ***************************************************/

    * Test if this location has a root file
    cap confirm file "`path'/`root_file'"
    * File found, handle it
    if (_rc == 0) {
      noi di as text "{phang}{bf:root:} {it:`path'}{p_end}"
      local rootdirs `""`path'""'
    }

    /***************************************************
      Recurse over dirs
    ***************************************************/

    * test if recursion depth is met
    if (`next_recsleft'>=0) {
      * List all sub-folders (if any) in this directory
      cap local dir_list : dir `"`path'"' dirs  "*", respectcase

      * Handle file not found error
      if (_rc == 601) {
        noi di as text _n "{phang}{red:Warning:} Directory {inp:`path'} could not be searched. Check if the folder path is corrupt. It could also be that the path is longer than what your opertive system can handle.{p_end}"
        local dir_list ""
      }

      *Run command again to throw unandled error to user
      else if (_rc == 0) local dir_list : dir `"`path'"' dirs  "*", respectcase

      * Recure into dirs unless it is part of skip folders
      foreach dir of local dir_list {
        if !(`: list dir in skipdirs') {
          reproot_search,             ///
            path("`path'/`dir'")      ///
            recsleft(`next_recsleft') ///
            skipdirs(`skipdirs')      ///
            recurse
          local d_count = `d_count' + `r(num_dir_searched)'
          if !missing(`"`r(rootdirs)'"') {
            local rootdirs `"`rootdirs' `r(rootdirs)'"'
          }
        }
      }
    }

    /***************************************************
      Return number of dirs counted
    ***************************************************/

    return local num_dir_searched `d_count'
    return local rootdirs `"`rootdirs'"'

    /***************************************************
      If original call, output info
    ***************************************************/

    if missing("`recurse'") {
      timer off 68
      qui timer list 68
      return local timer `r(t68)'
    }
}
end

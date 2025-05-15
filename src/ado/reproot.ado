*! version 3.2 20250324 - DIME Analytics & LSMS Team, The World Bank - dimeanalytics@worldbank.org, lsms@worldbank.org

cap program drop   reproot
    program define reproot, rclass

qui {

    version 14.1

    * Update the syntax. This is only a placeholder to make the command run
    syntax , Project(string) Roots(string) [OPTRoots(string) prefix(string) clear verbose]

    noi di _n "{hline}"

    /***************************************************
      Initiate locals
    ***************************************************/

    * Hardcoded file names
    local env_file  "~/reproot-env.yaml"
    local root_file "reproot.yaml"

    * Counters
    local tot_time 0
    local tot_dirs 0

    * Data locals
    local rootfiles    ""
    local all_roots    : list roots | optroots
    local roots_set    ""
    local roots_notset ""

    /***************************************************
      Test if all roots are already loaded
    ***************************************************/

    * If clear is used, then add all roots to roots_notset,
    * and search for all of them again
    if !missing("`clear'") {
      local roots_notset "`all_roots'"
    }

    * If clear is not used, test what root globals are already set,
    * and search only for roots not already set in root globals
    else {

      /***************************************************
        Test that all roots to look for has legal names
      ***************************************************/
      foreach root of local all_roots {
        validate_global_name, rootname(`"`root'"') prefix("`prefix'")
        if r(is_legal_name) == 0 {
          local illegal_names `"`illegal_names' `prefix'`root'"'
        }
      }
      if !missing(`"`illegal_names'"') {
        local illegal_names = trim(`"`illegal_names'"')
        if !missing("`prefix'") local prefix_str "with prefix "
        noi di as error `"{phang}The following root global names`prefix_str' are not valid global names [`illegal_names']. Stata does not share an exhaustive documentation for legal global names, but these names failed our test. Even though some non-standard English letters are allowed, try to only use standard English letters and numbers. Underscores "_" may be used, but may not be the first character. Do not use any other special characters.{p_end}"' _n
        error 198
        exit
      }

      * Test which roots if any are already loaded
      foreach root of local all_roots {
        * Test if root exists with prefix
        if missing("${`prefix'`root'}") {
          local roots_notset : list roots_notset | root
        }
        else local roots_set : list roots_set | root
      }
    }

    /***************************************************
      Output any roots are already set
    ***************************************************/

    if !missing("`roots_set'") {
      noi di as text _n "{pstd}These roots were already set in these globals:{p_end}"
      foreach root of local roots_set {
        local prefix_root "`prefix'`root'"
        noi di as text "{phang2}- Global: {result:`prefix_root'} - Root: {result:${`prefix_root'}}{p_end}"
      }
    }

    /***************************************************
      Output if all roots are already set
    ***************************************************/

    if missing("`roots_notset'") {
      noi di as result _n "{pstd}All required roots are already loaded. No search for roots will be done.{p_end}" _n _n "{hline}"

      ** The command ends here
    }

    * There are roots to search for
    else {

    /***************************************************
      Output that at least some roots were not loaded
    ***************************************************/

      noi di as text _n "{pstd}These required roots were not already loaded:{p_end}"
      foreach root of local roots_notset {
        noi di as text  "{pmore}- {bf:`root'}{p_end}"
      }
      noi di as text _n "{pstd}Starting search of file system.{p_end}" _n

      /***************************************************
        Read env file before search
      ***************************************************/

      * Get home dir using cd, and then restore users pwd
      local pwd = "`c(pwd)'"
      cd ~
      local homedir = "`c(pwd)'"
      cd "`pwd'"

      * Test if this location has a root file
      cap confirm file "`env_file'"
      if (_rc) {
        noi di as error `"{phang}No file {inp:reproot-env.yaml} found in home directory {browse "`homedir'"}. This file is required to set up once per computer to use {cmd:reproot}. See instructions on how to set up this file {browse "https://worldbank.github.io/repkit/articles/reproot-files.html":here}. Starting {stata reproot_setup:setup wizard}....{p_end}"' _n
        noi reproot_setup
        exit
      }

      * Get reprootpaths and skipdirs from env file
      noi reproot_parse env , file("`env_file'")
      local searchpaths `"`r(searchpaths)'"'
      local skipdirs `"`r(skipdirs)'"'

      * Test that the environment file has at least one search path
      if missing(`"`searchpaths'"') {
        noi di as error `"{phang}The file {inp:reproot-env.yaml} found in home directory {browse "`homedir'"} has no paths and will therefore not find any roots. See instructions on how to set up this file {browse "https://worldbank.github.io/repkit/articles/reproot-files.html":here}.{p_end}"' _n
        error 99
        exit
      }

      /***************************************************
        Search each reprootpaths
      ***************************************************/

      foreach searchpath of local searchpaths {

        noi di as smcl  `"{hline}"' _n

        * Parse max recursion and search path from reprootpath
        gettoken maxrecs search_path : searchpath, parse(":")
        local search_path = substr("`search_path'",2,.)

        * Search next folder
        noi di as result  `"{pstd}{ul:Searching folder: `search_path', with folder depth: `maxrecs'}{p_end}"'
        noi reproot_search, ///
          path(`"`search_path'"') skipdirs(`"`skipdirs'"') recsleft(`maxrecs')

        * Get time, dir_count, and roots found
        local time = `r(timer)'
        local dirs = `r(num_dir_searched)'
        local this_rootdirs = `"`r(rootdirs)'"'

        * Output this search
        noi di_search_results, ///
          time(`time') dcount(`dirs') rootdirs(`"`this_rootdirs'"') `verbose'

        * Add these rootdirs to the list of all dirs
        local rootdirs = trim(`"`rootdirs' `this_rootdirs'"')

        * Update the time and dir_count to the grand totals
        local tot_time = `tot_time' + `time'
        local tot_dirs = `tot_dirs' + `dirs'
      }

      * Deduplicate the list in case the same root was found in multiple paths
      local rootdirs : list uniq rootdirs

      * Output the grand total
      noi di as smcl `"{hline}"'
      noi di_search_results, total ///
        time(`tot_time') dcount(`tot_dirs') rootdirs(`"`rootdirs'"') `verbose'
      noi di as smcl `"{hline}"'


      /***************************************************
        Parse the root files
      ***************************************************/

      * List of roots found for this project
      local found_roots ""

      * Parse all rootfile and filter out roots for this project
      foreach rootdir of local rootdirs {

        * parse this root
        reproot_parse root, file("`rootdir'/`root_file'")
        local root = "`r(root)'"

        * Filter for this project and roots
        if "`project'" == "`r(project)'" & `:list root in all_roots'  {

          *Test if root is duplicates
          if (`:list root in found_roots') {
            noi di as error `"{phang}Duplicate root found for root name [`root']. A root with name [`root'] was found at [{browse "`rootdir'"}] after it had already been found at [{browse "```prefix'`root'''"}]. All roots must have a unique name within a project. No root globals were set.{p_end}"' _n
            error 99
            exit
          }

          * Add root to found root and set local with this root's path
          local found_roots "`found_roots' `root'"
          tempname `prefix'`root'
          local   ``prefix'`root'' "`rootdir'"
        }
      }

      * Test that all required roots are found
      local required_roots_not_found : list roots - found_roots
      if !missing("`required_roots_not_found'") {
        noi di as error _n `"{phang}The following required root(s) [`required_roots_not_found'] were not found. No root globals were set.{p_end}"'
        error 99
        exit
      }

      * Display what optional roots were not found
      local optional_roots_not_found : list optroots - found_roots
      if !missing("`optional_roots_not_found'") {
        noi di as text _n `"{phang}The following optional root(s) [`optional_roots_not_found'] were not found.{p_end}"'
      }

      * Set all roots
      foreach root of local found_roots {
        local gname "`prefix'`root'"
        local path `"```prefix'`root'''"'
        noi di _n as text "{pstd}Root {it:`root'} was set to {result:`path'} using global {result:{c S|}{c -(}`gname'{c )-}} {p_end}"
        global `gname' "`path'"
      }

      noi di _n `"{hline}"'
    }

    * Return all root dires found regardless if they were for this project
    return local rootdirs "`rootdirs'"

}
end

cap program drop   di_search_results
    program define di_search_results

  syntax, time(numlist) dcount(numlist) [rootdirs(string) total verbose]

  local time: display %8.2f `time'
  local dcount: display %14.0fc `dcount'
  local time   = trim("`time'")
  local dcount = trim("`dcount'")

  local rcount: list sizeof rootdirs

  if missing("`total'") local intro_str "In this search directory"
  else local intro_str "In total"

  noi di as result _n `"{pstd}`intro_str', `dcount' directories were searched in `time' seconds, and `rcount' unique reproot root(s) were found.{p_end}"' _n

  if !missing("`verbose'") {
    noi di as result "{pstd}The following root folders were found:{p_end}"
    foreach rootdir of local rootdirs {
      local rootdir_list "`rootdir_list'- {it:`rootdir'}{break}"
    }
    noi di as text `"{pmore}`rootdir_list'{p_end}"' _n
  }
end


cap program drop   validate_global_name
    program define validate_global_name, rclass

    syntax, rootname(string) [prefix(string)]

    * Create a test value to be stored
    local test_value = "test-repkit-%-1234"

    * Create the global name that will be used
    local gname "`prefix'`rootname'"
    cap local preserve_value `"${`gname'}"'

    * Use the global name to test if it can be used to
    * store and retreive the global name
    capture {
      * Load the test value into the global name
      global `gname' = `"`test_value'"'
      * Stata does not give error on global names such as "te&st",
      * but those names fail when retreiving the global
      assert `"`test_value'"' == `"${`gname'}"'
      * Reset global
      global `gname' = "`preserve_value'"
    }

    * Return 1 if the name was legal (i.e. capture returned 0)
    local return_code = _rc == 0
    return scalar is_legal_name = `return_code'

end

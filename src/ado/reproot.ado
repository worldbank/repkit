cap program drop   reproot
    program define reproot, rclass

    * Update the syntax. This is only a placeholder to make the command run
    syntax , Project(string) Roots(string) [prefix(string) clear]

    noi di _n "{hline}"

    * initiate locals
    local tot_time 0
    local tot_dirs 0
    local rootfiles ""

    local env_file  "~/reproot-env.yaml"
    local root_file "reproot.yaml"

    /***************************************************
      Test if all roots are already loaded
    ***************************************************/

    local roots_set ""
    local roots_notset ""

    * If clear is used, then add all roots to roots_notset,
    * and search for all of them again
    if !missing("`clear'") {
      local roots_notset "`roots'"
    }

    * If clear is not used, test what root globals are already set,
    * and search only for roots not already set in root globals
    else {
        * Test which roots if any are already loaded
      foreach root of local roots {
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

      * Get home dir
      local pwd = "`c(pwd)'"
      cd ~
      local homedir = "`c(pwd)'"
      cd "`pwd'"

      * Test if this location has a root file
      cap confirm file "`env_file'"
      if (_rc) {
        noi di as text `"{phang}No file {inp:reproot-env.yaml} found in home directory {it:`homedir'}. This file is required to set up once per computer to use {cmd:reproot}. See instructions on how to set up this file here (TODO: LINK).{p_end}"' _n
        error 601
        exit
      }

      * Get reprootpaths and skipdirs from env file
      reproot_parse env , file("`env_file'")
      local envpaths `"`r(envpaths)'"'
      local skipdirs `"`r(skipdirs)'"'

      /***************************************************
        Search each reprootpaths
      ***************************************************/

      foreach envpath of local envpaths {

        noi di as smcl  `"{hline}"' _n

        * Parse max recursion and search path from reprootpath
        gettoken maxrecs search_path : envpath, parse(":")
        local search_path = substr("`search_path'",2,.)

        * Search next folder
        noi di as result  `"{pstd}{ul:Searching folder: `search_path', with folder depth: `maxrecs'}{p_end}"'
        reproot_search, ///
          path(`"`search_path'"') skipdirs(`"`skipdirs'"') recsleft(`maxrecs')

        * Get time, dir_count, and roots found
        local time = `r(timer)'
        local dirs = `r(num_dir_searched)'
        local this_rootdirs = `"`r(rootdirs)'"'

        * Output this search
        di_search_results, ///
          time(`time') dcount(`dirs') rootdirs(`"`this_rootdirs'"')

        * Add these rootdirs to the list of all dirs
        local rootdirs = trim(`"`rootdirs' `this_rootdirs'"')

        * Update the time and dir_count to the grand totals
        local tot_time = `tot_time' + `time'
        local tot_dirs = `tot_dirs' + `dirs'
      }

      * Output the grand total
      noi di as smcl `"{hline}"'
      di_search_results, total ///
        time(`tot_time') dcount(`tot_dirs') rootdirs(`"`rootdirs'"')
      noi di as smcl `"{hline}"'


      /***************************************************
        Parse the root files
      ***************************************************/

      local found_roots ""

      foreach rootdir of local rootdirs {
        reproot_parse root, file("`rootdir'/`root_file'")
        local this_root         "`r(root)'"
        local this_root_global  "`prefix'`this_root'"
        local this_root_project "`r(project)'"

        * Test if this root belongs the relevant project
        if "`project'" == "`this_root_project'" {

          * Test if root was already found, if not then add to found_roots
          if (`: list this_root in found_roots') {
            noi di as error _n "{pstd}A second root called {result:`this_root)'} was found for this project found in folder {result:`rootdir'}.{p_end}"
            error 99
            exit
          }
          local found_roots : list found_roots | this_root
          noi di "found_roots `found_roots'"

          local found_str "Root {result:`this_root'} for project {result:`this_root_project'} found"


          if (`: list this_root in roots') {
            * Output that a relevant root has been found
            noi di _n as text "{pstd}`found_str'. Setting global {result:{c S|}{c -(}`this_root_global'{c )-}} to: {result:`rootdir'}{p_end}"

            global `this_root_global' "`rootdir'"
          }
          * Root not required - just skip it
          else {
            noi di _n as text "{pstd}`found_str', but root not required, so no global is set for this root.{p_end}"
          }
        }
      }
      noi di _n `"{hline}"'
    }

    * Return all root dires found regardless if they were for this project
    return local rootdirs "`rootdirs'"

    // Remove then command is no longer in beta
    noi repkit "beta reproot"
end


cap program drop   di_search_results
    program define di_search_results

  syntax, time(numlist) dcount(numlist) [rootdirs(string) total]

  local time: display %8.2f `time'
  local dcount: display %14.0fc `dcount'

  local rcount: list sizeof rootdirs

  local time   = trim("`time'")
  local dcount = trim("`dcount'")

  if missing("`total'") local intro_str "In this search directory"
  else local intro_str "In total"

  noi di as result _n `"{pstd}`intro_str', `dcount' directories were searched in `time' seconds, and `rcount' reproot   root(s) were found.{p_end}"' _n
end

*! version 3.1 20240926 - DIME Analytics & LSMS Team, The World Bank - dimeanalytics@worldbank.org, lsms@worldbank.org

cap program drop   reproot_setup
    program define reproot_setup

qui {

    version 14.1

    * Update the syntax. This is only a placeholder to make the command run
    syntax, [ ///
      searchpaths(string) ///
      recursedepth(numlist min=1 max=1) ///
      skipdirs(string) ///
      debug_home_location(string) ///
    ]

    ********************************************************
    * Get the home folder where the environment file is located

    * Get home folder using cd and then restore the original cd
    local preserve_pwd "`c(pwd)'"
    cd ~
    local home_fld "`c(pwd)'"
    cd "`preserve_pwd'"

    * Only update the global in the first run. If this is
    * the second run after the dialog box, then keep the global
    if missing("${reproot_setup_env_file}") {
      * This is used for testing purpose during development only
      if !missing("`debug_home_location'") local home_fld  "`debug_home_location'"
      * Set the default location of the environment file
      global reproot_setup_env_file `"`home_fld'/reproot-env.yaml"'
    }

    * Test if env file already exists
    cap confirm file "${reproot_setup_env_file}"
    if (_rc)  local env_file_exists 0
    else      local env_file_exists 1

    ********************************************************
    * Run the dialog box if no search paths were provided

    if missing(`"`searchpaths'"') {
      * Read values in existing env file if it exists
      reproot_dlg_input_parsing

      * Open the dialog box
      db reproot

      * The output from the dialog box is parsed in reproot_dlg_input_parsing,
      * which calls the reproot_setup command again with the input from the dialog box
    }

    else {
      ********************************************************
      * Test the inputs

      * Test that search path exists
      foreach searchpath of local searchpaths {
        test_searchpath, searchpath("`searchpath'") error
      }

      ********************************************************
      * Modify the environment file

      if (`env_file_exists') {
        noi reproot_update_envfile, ///
          searchpaths(`"`searchpaths'"') recursedepth("`recursedepth'") skipdirs(`"`skipdirs'"')
        noi di as result _n "{pstd}Reproot environment file successfully updated!{p_end}"
      }
      else {
        noi reproot_write_envfile, ///
          searchpaths(`"`searchpaths'"') recursedepth("`recursedepth'") skipdirs(`"`skipdirs'"')
        noi di as result _n "{pstd}Reproot environment file successfully created!{p_end}"
      }

      * Reset global
      global reproot_setup_env_file ""
    }
}
end

* Create the env file
cap program drop   reproot_write_envfile
    program define reproot_write_envfile, rclass
qui {
    syntax, [ ///
      searchpaths(string)  ///
      recursedepth(string) ///
      skipdirs(string)     ///
    ]

    * Initiate the tempfile handlers and tempfiles needed
    tempname env_handle
    tempfile env_tmpfile

    * Set default recurse depth if one is provided
    if missing("`recursedepth'") local recursedepth 4

    * Deduplicate the search paths and skip folders names
    local searchpaths : list uniq searchpaths
    local skipdirs    : list uniq skipdirs

    * Open template to read from and new tempfile to write to
    file open `env_handle' using `env_tmpfile' , write

    * Write the recurse 
    file write `env_handle' "recursedepth: `recursedepth'" _n "paths:" _n
    foreach searchpath of local searchpaths {
      test_searchpath, searchpath(`"`searchpath'"')
      file write `env_handle' `"    - "`searchpath'""' _n
    }
    file write `env_handle' "skipdirs:" _n
    foreach skipdir of local skipdirs {
      file write `env_handle' `"    - "`skipdir'""' _n
    }
    file close `env_handle'

    copy `env_tmpfile' "${reproot_setup_env_file}", replace
}
end

* Create the env file
cap program drop   reproot_update_envfile
    program define reproot_update_envfile, rclass
qui {
    syntax, [ ///
      searchpaths(string)  ///
      recursedepth(string) ///
      skipdirs(string)     ///
    ]

    * Parse the env file
    reproot_parse env, file("${reproot_setup_env_file}") asis

    * If recurse depth is missing in input, read it from file
    if missing("`recursedepth'") local recursedepth `r(recdepth)'
    
    * Concatenate search paths and skip folders names in input with the ones in the file
    local searchpaths `"`r(searchpaths)' `searchpaths'"'
    local skipdirs    `"`r(skipdirs)' `skipdirs'"'
   
    * Create the env file - essentially overwrites the file with new input
    reproot_write_envfile, ///
      searchpaths(`"`searchpaths'"') recursedepth("`recursedepth'") skipdirs(`"`skipdirs'"')

}
end

**********************************************************************
* Dialog box utils

* Parse the env file and prepare it for the dialog box
cap program drop   reproot_dlg_input_parsing
    program define reproot_dlg_input_parsing, rclass
    
    * Initiate locals
    local env_i  = 1
    local skip_i = 1
    
    * Test if env file already exists
    cap confirm file "${reproot_setup_env_file}"
    
    * If env file does not exist, return default values
    if _rc {
        * Set search paths to default values
        return local  searchpath1_text ""
        return scalar searchpath1_default = 0
        * Set default to 4
        return scalar recdepth = 4 
        * Set skip dirs to default values
        return local  skipdir1_text ".git"
        return scalar skipdir1_default = 0
    } 
    
    * If env file exists, parse the file and get current values
    else {
      * Parse the env file
      reproot_parse env, file("${reproot_setup_env_file}") asis
      return scalar recdepth = `r(recdepth)'
      
      * Parse search paths
      local searchpaths `"`r(searchpaths)'"'
      foreach searchpath of local searchpaths {
         return local  searchpath`env_i'_text `"`searchpath'"'
         return scalar searchpath`env_i'_default = 1 //Checks the box for this path
         local ++env_i
      }
      
      * Parse skip dirs
      local skipdirs `"`r(skipdirs)'"'
      foreach skipdir of local skipdirs {
         return local  skipdir`skip_i'_text `"`skipdir'"'
         return scalar skipdir`skip_i'_default = 1 //Checks the box for this folder name
         local ++skip_i
      }
    }
    
    * Make sure that checkboxes are are unchecked when there is no value
    forvalues env_default_i = `env_i'/8 {
        return scalar searchpath`env_default_i'_default = 0
    }
    forvalues skip_default_i = `skip_i'/6 {
        return scalar skipdir`skip_default_i'_default = 0
    }

end


**********************************************************************
* General utils

* TEST searchpath
cap program drop   test_searchpath
    program define test_searchpath, rclass
qui {
    syntax, [searchpath(string) error]

    if !missing(`"`searchpath'"') {
      * Parse the searchpath that can be on either of these formats:
      *  - "4:C:\Users\user1234\github"
      *  - "C:\Users\user1234\github"
      gettoken depth path : searchpath, parse(":")

      * Test if searchpath has depth prepended
      cap confirm integer number `depth'
      * no depth prepended, use searchpath as is
      if _rc local path = `"`searchpath'"'
      * depth prepended, use path after removing parse char
      else   local path = substr("`path'",2,.)

      *Test that path exist
      mata : st_numscalar("r(dirExist)", direxists(`"`path'"'))
      local path_exists `r(dirExist)'
      return local path_exists `path_exists'

      * If the path exists, return it
      if (`path_exists' == 1) {
        return local existing_path `path'
      }
      * if path does not exists, and error is used, throw error
      else {
        if !missing("`error'") {
          noi di as error `"{phang}The folder in "`path'" does not exists, you may only use folders that already exist.{p_end}"'
          error 693
          exit
        }
      }
    }
}
end

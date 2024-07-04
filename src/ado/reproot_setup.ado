*! version XX XXXXXXXXX ADAUTHORNAME ADCONTACTINFO

cap program drop   reproot_setup
    program define reproot_setup

qui {

    version /* ADD VERSION NUMBER HERE */

    * Update the syntax. This is only a placeholder to make the command run
    syntax, [ENVPaths(string)]

    * Test that envpath exists
    foreach envpath in `"`envpaths'"' {
      test_envpath, envpath(`"`envpath'"') error
    }

    * Hardcoded file names
    local env_file  "~/reproot-env-test.yaml"

    * Test if env file already exists
    cap confirm file "`env_file'"
    if (_rc)  local env_file_exists 0
    else      local env_file_exists 1

    if (`env_file_exists') {
        noi di as result _n `"{pstd}An environment file was found in the home folder [`home_fld']. To modify this file, see {browse "https://worldbank.github.io/repkit/articles/reproot-files.html":this guide}.{p_end}"'
    }
    else {
      noi reproot_setup_envfile, env_file("`env_file'") envpaths(`" "`envpaths'" "')
    }
}
end

cap program drop   reproot_setup_envfile
    program define reproot_setup_envfile

qui {

    syntax, env_file(string) [envpaths(string)]

    * Get home folder using cd and then restore the orginal cd
    local preserve_pwd "`c(pwd)'"
    cd ~
    local home_fld "`c(pwd)'"
    cd "`preserve_pwd'"

    * Ask for confirmation
    noi di as result _n `"{pstd}No environment file was found in the home folder [`home_fld']. This command can set up a template. In the workflow of {inp:reproot}, this file must be located in the home folder.{p_end}"' _n(2) `"{pstd}Do you want to set up a template in the home folder?{p_end}"'
    global setup_confirmation ""
    while (!inlist(upper("${setup_confirmation}"),"Y", "N")) {
      noi di as txt `"{pstd}Enter "Y" to set up an environment template file or enter "N" to abort."', _request(setup_confirmation)
    }
    if upper("${setup_confirmation}") == "N" {
      noi di as txt "{pstd}Environment file creation aborted - nothing was created.{p_end}"
      error 1
      exit
    }

    noi di as result _n `"{pstd}The environment file will only work if it has at least one environment search paths. Read more about the environment file and its settings in the {browse "https://worldbank.github.io/repkit/articles/reproot-files.html":this guide}.{p_end}"' _n(2) `"{pstd}Do you want to add search folders? It is possible to do this later see the guide (also linked to in the help file for this command) for how to modify this file later.{p_end}"'

    global path_to_add ""
    while (!inlist(upper("${path_to_add}"),"BREAK","DONE")) {
      noi display_envpath, envpaths(`"`envpaths'"')
      noi di as txt `"{pstd}Enter a single folder path or enter "DONE" to create the file with these files, or "BREAK" to abort."', _request(path_to_add)

      * Do not test of add keywords
      if (!inlist(upper("${path_to_add}"),"BREAK","DONE")) {
        test_envpath, envpath(${path_to_add})
        if (`r(path_exists)' == 0)  noi di as txt "{pstd}{red:Warning}:This path does not exist.{p_end}"
        else local envpaths `"`envpaths' "${path_to_add}" "'
      }
    }

    * Abort if break was the key word
    if upper("${path_to_add}") == "BREAK" {
      noi di as txt "{pstd}Environment file creation aborted - nothing was created.{p_end}"
      error 1
      exit
    }

    noi create_env_file, env_file("`env_file'") envpaths(`"`envpaths'"')
}
end


* DISPLAY ENVPATH
cap program drop   create_env_file
    program define create_env_file, rclass
qui {
    syntax, env_file(string) [envpaths(string)]

    * Initiate the tempfile handlers and tempfiles needed
    tempname env_handle
    tempfile env_tmpfile

    * Open template to read from and new tempfile to write to
    file open `env_handle' using `env_tmpfile' , write

    * Write the smcl tag at top of file to
    file write `env_handle' "recursedepth: 4" _n "paths:" _n
    foreach envpath of local envpaths {
      file write `env_handle' `"    - `envpath'"' _n
    }
    file write `env_handle' "skipdirs:" _n `"    - ".git""'

    file close `env_handle'

    copy `env_tmpfile' `"`env_file'"'

    noi di as result _n "{pstd}Environment file was succsfully written to home folder.{p_end}"
}
end

* TEST ENVPATH
cap program drop   test_envpath
    program define test_envpath, rclass
qui {
    syntax, envpath(string) [error]

    * Parst the envpath that can either be
    *  - "4:C:\Users\user1234\github"
    *  - "C:\Users\user1234\github"
    gettoken depth path : envpath, parse(":")

    * Test if envpath has depth prepended
    cap confirm integer number `depth'
    * no depth prepended, use envpath as is
    if _rc local path = `"`envpath'"'
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
        noi di as error `"{phang}The folder in "`path'" does not exists, you may only use folders that already exists.{p_end}"'
        error 693
        exit
      }
    }
}
end


* DISPLAY ENVPATH
cap program drop   display_envpath
    program define display_envpath, rclass
qui {
    syntax, [envpaths(string)]
    if !missing("`envpaths'") {
      local di_paths ""
      * Test that envpath exists
      foreach envpath of local envpaths {
        local di_paths "`di_paths'{break}- `envpath'"
      }
      noi di as result _n `"{pstd}This is the list of paths that will be added:`di_paths'{p_end}"' _n
    }
}
end

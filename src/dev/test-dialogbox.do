clear all

adopath ++ "C:\Users\WB462869\github\repkit\src\ado"

cap program drop   reproot_parse_setup
    program define reproot_parse_setup, rclass

    version 14.1
    
    noi di "run reproot_parse_setup"
    
    qui do "C:\Users\WB462869\github\repkit\src\ado\reproot_parse.ado"
    
    local env_file  "~/reproot-env.yaml"
    
    * If no env file exists, set default recurse value to 4
    cap confirm file "`env_file'"
    if _rc {
        return scalar recdepth = 6 // Set default to 4
    } 
    
    * If env file exists, parse the file and get current values
    else {
      reproot_parse env, file("`env_file'")
      //return list
    
      return scalar recdepth = `r(recdepth)'
      
      * Parse env paths
      local searchpaths `"`r(searchpaths)'"'
      local env_i = 1
      foreach searchpath of local searchpaths {
         return local  searchpath`env_i'_text `"`searchpath'"'
         return scalar searchpath`env_i'_default = 1
         local ++env_i
      }
      
      * Parse skip dirs
      local skipdirs `"`r(skipdirs)'"'
      
      local skip_i = 1
      foreach skipdir of local skipdirs {
         return local  skipdir`skip_i'_text `"`skipdir'"'
         return scalar skipdir`skip_i'_default = 1
         local ++skip_i
      }
    }
    
    * Set all the other locals to unchecked
    forvalues env_default_i = `env_i'/10 {
        return scalar searchpath`env_default_i'_default = 0
    }
    forvalues skip_default_i = `skip_i'/6 {
        return scalar skipdir`skip_default_i'_default = 0
    }

end

cap program drop   reproot_setup2
    program define reproot_setup2

    version 14.1

    syntax,

    reproot_parse_setup
    return list
    
    db reproot, debug
end

cap program drop   reproot_dlg_output_parsing
    program define reproot_dlg_output_parsing

    version 14.1

    syntax , [ searchdepth(string)            ///
      searchpath1(string) searchpath2(string) ///
      searchpath3(string) searchpath4(string) ///
      searchpath5(string) searchpath6(string) ///
      searchpath7(string) searchpath8(string) ///
      skipdir1(string) skipdir2(string) skipdir3(string) ///
      skipdir4(string) skipdir5(string) skipdir6(string) ///
    ]
	
	noi di "searchdepth: `searchdepth'"
	
	local searchpaths ""
	forvalues i = 1/8 {
		if !missing("`searchpath`i''") local searchpaths `"`searchpaths' "`searchpath`i''""'
	}
	
	local skipdirs ""
	forvalues i = 1/6 {
		if !missing("`skipdir`i''") local skipdirs `"`skipdirs' "`skipdir`i''""'
	}
	
	noi di `"searchpaths: `searchpaths'"'
	noi di `"skipdirs: `skipdirs'"'
	//create_env_file , searchpaths(string) recursedepth("`searchdepth'") skipdirs(string)
	
end

reproot_setup2

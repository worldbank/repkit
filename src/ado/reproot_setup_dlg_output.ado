*! version 3.2 20250324 - DIME Analytics & LSMS Team, The World Bank - dimeanalytics@worldbank.org, lsms@worldbank.org

* Parse the output from the reproot_setup dialog box and send it back to reproot_setup
cap program drop   reproot_setup_dlg_output
    program define reproot_setup_dlg_output

    version 14.1

    syntax , [ ///
      searchdepth(string)                                                            ///
      searchpath1(string) searchpath2(string) searchpath3(string) searchpath4(string) ///
      searchpath5(string) searchpath6(string) searchpath7(string) searchpath8(string) ///
      skipdir1(string) skipdir2(string) skipdir3(string)                              ///
      skipdir4(string) skipdir5(string) skipdir6(string)                              ///
    ]

    * Make sure at least one search path is provided
    if missing("`searchpath1'") {
        noi di as error "{phang}At least one search path needs to be provided.{p_end}"
        error 693
        exit
    }

    * Parse the search paths to a single compounded string
        local searchpaths ""
        forvalues i = 1/8 {
            if !missing("`searchpath`i''") local searchpaths `"`searchpaths' "`searchpath`i''""'
        }
    * Parse the skipdirs to a single compounded string
        local skipdirs ""
        forvalues i = 1/6 {
            if !missing("`skipdir`i''") local skipdirs `"`skipdirs' "`skipdir`i''""'
        }
        
    * Call the reproot_setup command again with the input from the dialog box
    reproot_setup, searchpaths(`"`searchpaths'"') ///
                   searchdepth("`searchdepth'") ///
                   skipdirs(`"`skipdirs'"' ) 

end

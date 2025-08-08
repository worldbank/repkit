*! version 4.0 20250729 - DIME Analytics & LSMS Team, The World Bank - dimeanalytics@worldbank.org, lsms@worldbank.org

program 	 lint

    version 14.1

  syntax anything [using/],        	///
									/// Options
    [                   			///
      Verbose           			///
      NOSUMmary         			///
      Indent(string)    			///
      Linemax(string)   			///
      Correct(string)   			///
      Excel(string)     			///
      AUTOmatic         			///
      replace           			///
      force            			///
	  debug							///
    ]

/*******************************************************************************
********************************************************************************

	PART 1: Prepare inputs

********************************************************************************
*******************************************************************************/

/*******************************************************************************
	Set defaults
*******************************************************************************/

  * set indent size = 4 if missing
  if missing("`indent'")		local indent "4"

  * Set number of spaces used for indentation and tab replacement
* Prefer indent(), fall back to space() for backward compatibility
if ("`indent'" != "") {
    local indentval = "`indent'"
}
else if ("`space'" != "") {
    local indentval = "`space'"
}
else {
    local indentval = 4
}


  * set linemax = 80 if missing
  if missing("`linemax'")		local linemax "80"

  * if !missing("`excel'")   cap erase `excel'
  if !missing("`excel'")		cap rm `excel'

  * set excel = "" if excel is missing
  if missing("`excel'")      	local excel ""

  * set a constant for the suppress option being used
  local suppress_flag "1"
  if !missing("`verbose'")    	local suppress_flag "0"

  * set a constant for the summary option being used
  local summary_flag "1"
  if !missing("`nosummary'")  	local summary_flag "0"

  * In debug mode, print status
  if !missing("`debug'") 		di "Inputs prepared"


/*******************************************************************************
	Prepare file paths
*******************************************************************************/

// Check format of do-file to be linted ----------------------------------------

	* File or Folder to be detected
	gettoken anything : anything

	* Check if main input is a file or a folder
	local input =  `"`anything'"'

	_testpath "`input'", ext(`"".do", ".ado""') argument(lint's main argument) exists `debug'
	local folder =  "`r(folder)'"
    local file 	 =  "`r(file)'"

// Check do-file with corrections ----------------------------------------------

	if !missing("`using'") {

		* Can only be used when linting a do-file
		if missing("`file'") {
			di as error "{phang}Option [using] cannot be used when linting a directory. To use this option, specify a do-file as lint's main argument.{p_end}"
			error 198
		}

		_testpath "`using'", ext(`"".do", ".ado""') argument(lint's [using] argument) `debug'
		local output = "`r(file)'"

		* Unless force is used, the output file should have a different name than the input
		if missing("`force'") & ("`input'" == "`output'") {
			di as error "{phang}It is recommended to use different file names for lint's main argument and its [using] argument. This is because it is slightly possible that the corrected do-file created by the command will break something in your code, and you may want to keep a backup. If you want still to replace the current do-file with the do-file corrected by lint, use the option [force]. {p_end}"
			error 198
		}
    }

// Check Excel with corrections ------------------------------------------------

	if !missing("`excel'") {

		_checkopenpyxlinstall

		_testpath "`excel'", ext(`"".xls", ".xlsx""') argument(lint's [excel] argument) `debug'
		local excel = "`r(file)'"
	}

// In debug mode, print file paths ---------------------------------------------

  if !missing("`debug'") {
  	di "Folder: `folder'"
	di "File: `file'"
	di "Excel: `excel'"
	di "Input: `input'"
	di "Output: `output'"
  }

// Check if python is installed ------------------------------------------------

	_checkpyinstall

	* Check that the Python function is defined
	qui: findfile stata_linter_detect.py
	if c(os) == "Windows" {
		local ado_path = subinstr(r(fn), "\", "/", .)
	}
	else {
		local ado_path = r(fn)
	}

// Check that versions of all auxiliary files are the same ---------------------

_checkversions

/*******************************************************************************
********************************************************************************

	PART 2: Execute linter

********************************************************************************
*******************************************************************************/

/*******************************************************************************
	Detect issues
*******************************************************************************/

    * Check a single do-file
    if !missing("`file'") {

		if   missing("`using'") {
			local header header
		}

		if (!missing("`verbose'") |	(`summary_flag' == 1) | !missing("`excel'") | !missing("`using'")) {
				local footer footer
		}

		_detect, ///
			file("`file'") excel("`excel'") ado_path("`ado_path'") ///
			indent("`indentval'") linemax("`linemax'") ///
			suppress_flag("`suppress_flag'") summary_flag("`summary_flag'") ///
			`header' `footer'
    }

    * Check all do-files in a folder
    else if !missing("`folder'") {

        local files: dir "`folder'" files "*.do"

        foreach file of local files {

			_detect, ///
				file("`folder'/`file'") excel("`excel'") ado_path("`ado_path'") ///
				indent("`indentval'") linemax("`linemax'") ///
				suppress_flag("`suppress_flag'") summary_flag("`summary_flag'") ///
				header footer
		}
	}

	* In debug mode, print status
	if !missing("`debug'") noi di "Exiting detect function"

/*******************************************************************************
	Correct issues
*******************************************************************************/

	if !missing("`using'") {

		_correct, ///
			input("`input'") output("`output'") ///
			indent("`indentval'")linemax("`linemax'") ///
			`replace' `force' `automatic' `debug'

	}

end

/*******************************************************************************
********************************************************************************

	PART 3: Auxiliary functions

********************************************************************************
*******************************************************************************/

// Correct ---------------------------------------------------------------------

program			_correct

	syntax, ///
		input(string) output(string) ///
		indent(string) linemax(string) ///
		[replace force automatic debug]

	* Check that the Python function is defined
    qui: findfile stata_linter_correct.py
    if c(os) == "Windows" {
      local ado_path = subinstr(r(fn), "\", "/", .)
    }
    else {
      local ado_path = r(fn)
    }

  * Display a message if the correct option is added, so the output can be separated
    display as text 	" "
    display as result 	_dup(60) "-"
    display as result 	"Correcting {bf:do-file}"
    display as result	_dup(60) "-"
    display as text 	" "

	* Import relevant python libraries
    python: import sys, os
		python: from sfi import Macro
    python: sys.path.append(os.path.dirname(r"`ado_path'"))
    python: from stata_linter_correct import *
		python: import stata_linter_detect as sld
		python: import stata_linter_utils as slu

	* Checking which issues are present in the dofile so we ask for their correction
		python: Macro.setLocal('_delimiter',  str(slu.detect_delimit_in_file(r"`input'")))
		python: Macro.setLocal('_hard_tab',   str(slu.detect_hard_tab_in_file(r"`input'")))
		python: Macro.setLocal('_bad_indent', str(slu.detect_bad_indent_in_file(r"`input'", "`indentval'", "`indentval'")))
		python: Macro.setLocal('_long_lines', str(slu.detect_line_too_long_in_file(r"`input'", "`linemax'")))
		python: Macro.setLocal('_no_space_before_curly', str(slu.detect_no_space_before_curly_bracket_in_file(r"`input'")))
		python: Macro.setLocal('_blank_before_curly', str(slu.detect_blank_line_before_curly_close_in_file(r"`input'")))
		python: Macro.setLocal('_dup_blank_line', str(slu.detect_duplicated_blank_line_in_file(r"`input'")))

	* If no issue was found, the function ends here.
	* Otherwise _correct continues.
	 if ("`_delimiter'" == "False" & ///
	     "`_hard_tab'" == "False" & ///
			 "`_bad_indent'" == "False" & ///
			 "`_long_lines'" == "False" & ///
			 "`_no_space_before_curly'" == "False" & ///
			 "`_blank_before_curly'" == "False" & ///
			 "`_dup_blank_line'" == "False") {
			 display as result `"{phang}Nothing to correct.{p_end}"'
	     display as result `"{phang}The issues lint is able to correct are not present in your dofile.{p_end}"'
			 display as result `"{phang}No output files were generated.{p_end}"'
	 }
	 else {

	* Counter of number of issues being corrected
	  local _n_to_correct 0

  * Correct the output file, looping for each python command
    foreach fun in 	delimit_to_three_forward_slashes ///
		 				tab_to_space ///
						indent_in_bracket ///
						too_long_line ///
						space_before_curly ///
						remove_blank_lines_before_curly_close ///
						remove_duplicated_blank_lines {

			* If the issue is not present, we continue with the next one
			if ("`_delimiter'" == "False" & "`fun'" == "delimit_to_three_forward_slashes") {
			    continue
			}
			else if ("`_hard_tab'" == "False" & "`fun'" == "tab_to_space") {
					continue
			}
			else if ("`_bad_indent'" == "False" & "`fun'" == "indent_in_bracket") {
					continue
			}
			else if ("`_long_lines'" == "False" & "`fun'" == "too_long_line") {
					continue
			}
			else if ("`_no_space_before_curly'" == "False" & "`fun'" == "space_before_curly") {
					continue
			}
			else if ("`_blank_before_curly'" == "False" & "`fun'" == "remove_blank_lines_before_curly_close") {
					continue
			}
			else if ("`_dup_blank_line'" == "False" & "`fun'" == "remove_duplicated_blank_lines") {
					continue
			}

			if missing("`automatic'") {

          noi di ""
          global confirmation "" //Reset global

          while (upper("${confirmation}") != "Y" & upper("${confirmation}") != "N" & upper("${confirmation}") != "BREAK") {
					    if ("${confirmation}" != "") {
									noi di as txt "{pstd} Invalid input. {p_end}"
									noi di as txt "{pstd} Please type {bf:Y} or {bf:N} and hit enter. Type {bf:BREAK} and hit enter to exit. {p_end}"
									noi di ""
							}
              if ("`fun'" == "delimit_to_three_forward_slashes") {
							    di as result "{pstd} Avoid using [delimit], use three forward slashes (///) instead. {p_end}"
              }
              else if ("`fun'" == "tab_to_space") {
              		di as result "{pstd} Avoid using hard tabs, use soft tabs (white spaces) instead. {p_end}"
              }
              else if ("`fun'" == "indent_in_bracket") {
                  di as result "{pstd} Indent commands inside curly brackets. {p_end}"
              }
              else if ("`fun'" == "space_before_curly") {
                  di as result "{pstd} Use white space before opening curly brackets. {p_end}"
              }
							else if ("`fun'" == "too_long_line") {
                  di as result "{pstd} Limit line length to `linemax' characters. {p_end}"
              }
              else if ("`fun'" == "remove_blank_lines_before_curly_close") {
                  di as result "{pstd} Remove redundant blank lines before closing brackets. {p_end}"
              }
              else if ("`fun'" == "remove_duplicated_blank_lines") {
                  di as result "{pstd} Remove duplicated blank lines. {p_end}"
              }
              noi di as txt "{pstd} Do you want to correct this? To confirm type {bf:Y} and hit enter, to abort type {bf:N} and hit enter. Type {bf:BREAK} and hit enter to stop the code. See option {help lint:automatic} to not be prompted before creating files. {p_end}", _request(confirmation)
          }

          // Copy user input to local
          local createfile = upper("${confirmation}")

          // If user wrote "BREAK" then exit the code
          if ("`createfile'" == "BREAK") error 1
      }

    // if automatic is used, always run the corresponding function
    else {
	      local createfile "Y"
	  }

		* If option [manual] was used and input was [N], function won't be used for this issue
		if ("`createfile'" == "N") {
		    noi di as result ""
		}
		* If option input was [Y], or if option [automatic] was used, run the function
		else if ("`createfile'" == "Y") {

		    local _n_to_correct = `_n_to_correct' + 1

				* If this is the first issue to correct, create the output file
				if `_n_to_correct' == 1 {

				    if (missing("`force'")) {
						    qui copy "`input'" "`output'", replace
				    }
				}

		    python: `fun'(r"`output'", r"`output'", "`indentval'", "`indentval'", "`linemax'")
		}
    }

	* Print link to corrected output file if it was created
   if `_n_to_correct' > 0 {
	     display as result `"{phang}Corrected do-file saved to {browse "`output'":`output'}.{p_end}"'
	 }
	 }


end

// Detect ----------------------------------------------------------------------

program			_detect

		syntax , ///
				file(string) ado_path(string) ///
				indent(string) linemax(string) ///
				suppress_flag(string) summary_flag(string) ///
				[excel(string) header footer]

		* Import relevant python functions
		python: import sys, os
		python: sys.path.append(os.path.dirname(r"`ado_path'"))
		python: from stata_linter_detect import *

		* Stata result header
		if !missing("`header'") {
			di as result ""
			di as result "Linting file: `file'"
			di as result ""
		}

		* Actually run the Python code
        python: r = stata_linter_detect_py("`file'", "`indentval'", "`suppress_flag'", "`summary_flag'", "`excel'", "`linemax'", "`indentval'")

		* Stata result footer
		if !missing("`footer'") {

				display as result 	_dup(85) "-"

			if "`excel'" != "" {
				display as result 	`"{phang}File {browse "`excel'":`excel'} created.{p_end}"'
			}

				display as result 	`"{phang}For more information about coding guidelines visit the {browse "https://worldbank.github.io/dime-data-handbook/coding.html#the-dime-analytics-stata-style-guide":DIME Analytics Stata Style Guide.}{p_end}"'
		}



end

// File Paths ------------------------------------------------------------------

program		 _testpath, rclass

	syntax anything, argument(string) ext(string) [details(string) debug exists]

	if !missing("`debug'") di "Entering subcommand _filepath"

	* Standardize file path
	local path = subinstr(`"`anything'"', "\", "/", .)

	* If a folder, test that folder exists
	if !regex(`"`path'"', "\.") {
	    _testdirectory 	`path'	, argument(`argument') details(`details') 	   `debug'
		local folder 	`path'
	}

	* If a file, parse information
	else {
	    _testfile  `path'		, argument(`argument') ext(`"`ext'"') `exists' `debug'
		local file `path'
	}

	return local folder "`folder'"
	if !missing("`debug'") di `"Folder: `folder'"'

	return local file 	"`file'"
	if !missing("`debug'") di `"File: `file'"'

	if !missing("`debug'") di "Exiting subcommand _filepath"

end

// Test file format ------------------------------------------------------------

program		 _testfile, rclass

	syntax anything, ext(string) argument(string) [debug exists]

	if !missing("`debug'") di "Entering subcommand _testfile"


	if !missing("`exists'") {
	    confirm file `anything'
	}

	* Get index of separation between file name and file format
	local r_lastdot = strlen(`anything') - strpos(strreverse(`anything'), ".")

	* File format starts at the last period and ends at the end of the string
	local suffix     = substr(`anything', `r_lastdot' + 1, .)

	if !inlist("`suffix'", `ext') {
	    di as error `"{phang}File `anything' is not a valid input for `argument'. Only the following file extensions are accepted: `ext'.{p_end}"'
		error 198
	}

end

// Check if folder exists ------------------------------------------------------

program      _testdirectory

	syntax anything, argument(string) [details(string) debug]

	if !missing("`debug'") di "Entering subcommand _testdirectory"

	* Test that the folder for the report file exists
	 mata : st_numscalar("r(dirExist)", direxists(`anything'))
	 if `r(dirExist)' == 0  {
	 	noi di as error `"{phang}Directory `anything', used `argument', does not exist. `details'{p_end}"'
		error 601
	 }

end


// Error checks ----------------------------------------------------------------

program 		_checkpyinstall

	* Check if python is installed
	cap python search
	if _rc {
		noi di as error `"{phang}For this command, Python installation is required. Refer to {browse "https://blog.stata.com/2020/08/18/stata-python-integration-part-1-setting-up-stata-to-use-python/":this page} for how to integrate Python to Stata. {p_end}"'
		exit
	}

	* Check if pandas package is installed
	cap python which pandas
	if _rc {
		noi di as error `"{phang}For this command to run, the Python package "pandas" needs to be installed. Refer to {browse "https://blog.stata.com/2020/09/01/stata-python-integration-part-3-how-to-install-python-packages/":this page} for how to install Python packages. {p_end}"'
		exit
	}

end

program 		_checkopenpyxlinstall

	* Check if openpyxl package is installed
	cap python which openpyxl
	if _rc {
		noi di as error `"{phang}For this command to run, the Python package "openpyxl" needs to be installed. Refer to {browse "https://blog.stata.com/2020/09/01/stata-python-integration-part-3-how-to-install-python-packages/":this page} for how to install Python packages. {p_end}"'
		exit
	}

end

// Check that lint runs on Stata 16 or above

program			 _checkversions

    if (`c(stata_version)' < 16 ) { 
    noi di as error "{phang}You are using Stata version `c(stata_version)'. This command requires the Stata-Python integration that was only introduced in Stata 16. To make the other commands in the `repkit` package `lint` is part of available to a large audience, this package targets the older Stata version 14.1, but this specific command requires at least Stata 16.{p_end}"
    error 198
    }

end

************************************************************* Have a lovely day!

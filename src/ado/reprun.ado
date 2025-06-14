*! version 3.4 20250609 - DIME Analytics & LSMS Team, The World Bank - dimeanalytics@worldbank.org, lsms@worldbank.org

program define reprun, rclass
qui {

    version 14.1

	* Store start time
    local start_time = clock(c(current_time), "hms")

    syntax anything [using/] , [Verbose] [Compact] [noClear] [Debug] [Suppress(passthru)]

    /*****************************************************************************
      Syntax parsing and setup
    *****************************************************************************/

    * Get the name of just the file without the path
    local dofile `anything'
    local orig_fname = substr(`"`dofile'"',strrpos(`"`dofile'"',"/")+1,.)

    local output `using'
    if `"`output'"' == `""' {
      local output = substr(`"`dofile'"',1,strrpos(`"`dofile'"',"/"))
    }

    if !missing("`debug'") di `"`dofile' || `output'"'

    if missing(`"`clear'"') {
      clear          // Data matches, zeroed out by default
      set seed 123456789 // Use Stata default setting when starting routine
    }

    /*************************************************************************
      Test input
    *************************************************************************/

    *Test that output location exist
    mata : st_numscalar("r(dirExist)", direxists("`output'"))
    if (`r(dirExist)' == 0) {
      noi di as error `"{phang}The folder used in [output(`output')] does not exist.{p_end}"'
      error 693
      exit
    }

    * Cannot choose verbose and compact
    if !missing(`"`verbose'"') local compact ""

    /*************************************************************************
      Set up output structure
    *************************************************************************/

    local dirout "`output'/reprun"
    * Remove existing output if it exists
    mata : st_numscalar("r(dirExist)", direxists("`dirout'"))
    if (`r(dirExist)' == 1) rm_output_dir, folder("`dirout'")
    * Create the new output folder structure
    mkdir "`dirout'"

    * Create the subfolders in the output folder structure
    foreach outdir_run in run1 run2 {
      * Create a local to folder path and create the folder
      local d`outdir_run' "`dirout'/`outdir_run'"
      mkdir "`d`outdir_run''"
    }

    /*************************************************************************
      Generate the run 1 and run 2 do-files
    *************************************************************************/
	
	
	
    noi di as res ""
    noi di as err "{phang}Starting reprun. Creating the do-files for run 1 and run 2.{p_end}"
    noi reprun_recurse, dofile("`dofile'") output("`dirout'") stub("m")
    local code_file_run1 "`r(code_file_run1)'"
    local code_file_run2 "`r(code_file_run2)'"
    if "`r(mmmflag)'" != ""  local mmmflag "`mmmflag' `r(mmmflag)'"
    if "`r(sssflag)'" != ""  local sssflag "`sssflag' `r(sssflag)'"
    noi di as err "{phang}Done creating the do-files for run 1 and run 2.{p_end}"

    /*************************************************************************
      Execute the run 1 and run 2 file to write the data files
    *************************************************************************/

    * Run 1
    noi di as err `"{phang}Executing "`orig_fname'" for run 1.{p_end}"'
    clear
    do "`code_file_run1'"
    noi di as err `"{phang}Done executing "`orig_fname'" for run 1.{p_end}"'

    * Run 2
    noi di as err `"{phang}Executing "`orig_fname'" for run 2.{p_end}"'
    clear
    do "`code_file_run2'"
    noi di as err `"{phang}Done executing "`orig_fname'" for run 2.{p_end}"'

    /*************************************************************************
      Compare the data files and output the result
    *************************************************************************/

    * Output locals
    local outputcolumns "10 37 64 91 110"
    tempname h_smcl
    tempfile f_smcl

    noi di as res "{phang}Generating the report for comparing the two runs.{p_end}"

    * Set up output smcl file
    file open `h_smcl' using `f_smcl', write
    noi write_and_print_output, h_smcl(`h_smcl') intro_output

    * Set up the titles for the first recursive call
    noi write_and_print_output, h_smcl(`h_smcl') l1(" ") ///
      l2(`"{phang}Checking file:{p_end}"')
    noi print_filetree_and_verbose_title, ///
      files(`" "`dofile'" "') h_smcl(`h_smcl') `verbose' `compact'
    output_writetitle , outputcolumns("`outputcolumns'")
    noi write_and_print_output, h_smcl(`h_smcl') ///
      l1("`r(topline)'") l2("`r(state_titles)'") ///
      l3("`r(col_titles)'") l4("`r(midline)'")

    * Start the recursive call
    noi recurse_comp_lines , dirout("`dirout'") stub("m") ///
      orgfile(`"`dofile'"') outputcolumns("`outputcolumns'") ///
      `verbose' `compact' h_smcl(`h_smcl') `suppress'

    * Write line that close table
    output_writetitle , outputcolumns("`outputcolumns'")
    noi write_and_print_output, h_smcl(`h_smcl') ///
      l1(`"{phang}Done checking file:{p_end}"') ///
      l2(`"{pstd}{c BLC}{hline 1}> `dofile'{p_end}"') l3("{hline}")		
	  
	if "`mmmflag'" != "" {
		noi write_and_print_output, h_smcl(`h_smcl') ///
		l1(" ") ///
		l2(`"{pstd}{red:Reproducibility Warning:} Your code contains many-to-many merges on lines:`mmmflag'.{p_end}"') ///
		l3(`"{pstd}As the {mansection D merge:Stata Manual} says: {it:if you think you need to perform an m:m merge, then we suspect you are wrong}.{p_end}"') ///
		l4(`"{pstd}Reference the above section of the Stata Manual for troubleshooting.{p_end}"')
		
	}
	
	if "`sssflag'" != "" {
		noi write_and_print_output, h_smcl(`h_smcl') ///
		l1(" ") ///
		l2(`"{pstd}{red:Reproducibility Warning:} Your code set the sortseed on lines:`sssflag'.{p_end}"') ///
		l3(`"{pstd}As the {mansection D sort:Stata Manual} says: {it:You must be sure that the ordering really does not matter. If that is the case, then why did you sort in the first place?}{p_end}"') ///
		l4(`"{pstd}Reference the above section of the Stata Manual for troubleshooting.{p_end}"')
		
	}  

	

	  
	  
    file close `h_smcl'

  /*****************************************************************************
        Write smcl file to disk and clean up intermediate files unless debugging
  *****************************************************************************/

    copy `f_smcl' "`dirout'/`orig_fname'.reprun.smcl" , replace
    noi di as res ""
    noi di as res `"{phang}SMCL-file with report written to: {view "`dirout'/`orig_fname'.reprun.smcl"}{p_end}"'

    if missing("`debug'") {
      rm_output_dir , folder("`dirout'/run1/")
      rm_output_dir , folder("`dirout'/run2/")
    }
  }

  //display timer
  * Store end time
	local end_time = clock(c(current_time), "hms")

	* Calculate and display elapsed time
	local elapsed_time = (`end_time' - `start_time') / 1000
	local hours = floor(`elapsed_time' / 3600)
	local minutes = floor(mod(`elapsed_time', 3600) / 60)
	local seconds = mod(`elapsed_time', 60)

	noi di as res ""
	if (`elapsed_time' >= 3600) {
		noi di as res `"{phang}Total run time: `hours':`minutes':`seconds' (HH:MM:SS){p_end}"'
	} 
	
	else if (`elapsed_time' >= 60) {
		noi di as res `"{phang}Total run time: `minutes':`seconds' (MM:SS){p_end}"'
	} 
	
	else {
		noi di as res `"{phang}Total run time: `seconds' seconds{p_end}"'
	}

end

  /***************************************************************************
  ****************************************************************************

   Sub-programs for: Writing run 1 and run 2 dofile

  ****************************************************************************
  ***************************************************************************/

  * Go over the do-file to create run 1 and run 2 do-files.
  * Run 1 and 2 are identical to each other.
  program define   reprun_recurse, rclass
  qui {

    syntax, dofile(string asis) output(string) stub(string)

    /*************************************************************************
      Create the files that this recursive call needs
    *************************************************************************/

    * For each run there will be two files file.
    * One code do-file that is a copy of the original file but writes states.
    * One data txt-file that the states are written to
    foreach run in 1 2 {
      * Create code and data output file for each run
      tempname code_`run' data_`run'
      *Create locals for the file
      local code_f`run' "`output'/run`run'/`stub'.do"
      local data_f`run' "`output'/run`run'/`stub'.txt"
      * Create the files
      file open `code_`run'' using "`code_f`run''", write
      file open `data_`run'' using "`data_f`run''", write
    }

    /*************************************************************************
      Loop over all lines in the do-file
    *************************************************************************/

    * Line write locals
    local lnum   = 1 // line number tracker
    local leof   = 0 // end-of file tracker
    local subf_n = 0 // tracker of sub-dofiles

    * Line parse locals
    local block_stack      ""
    local loopblock        0
    local commentblock     0
    local last_line        ""
    local loop_stack       ""
    local lastline_capture 0

    * Open the orginal file
    tempname   code_orig

    file open `code_orig' using `dofile', read

    * Loop until end of file
    while `leof' == 0 {
        * Read next line
        file read `code_orig' line
        local leof = `r(eof)'

        /* Lines with /// are concatenated to long single lines.
        If the previous line was a /// line then that content is
        in the last_line local which is here concatenated. */
        local line = `"`macval(last_line)' `macval(line)'"'

        * Analyze line in parser to see if this line needs
        * and special handling
        org_line_parse, line(`"`macval(line)'"')
        local write_dataline = `r(write_dataline)'
        local firstw         = `"`r(firstw)'"'
        local secondw        = `"`r(secondw)'"'
        local thirdw         = `"`r(thirdw)'"'
        local line_wrap      = `r(line_wrap)'
        local block_end      = `r(block_end)'
        local block_add      = `"`r(block_add)'"'
        local has_rc         = `"`r(has_rc)'"'

        * If this row is a closed curly bracket then
        * remove most recent word from stack
        if (`r(block_end)' == 1) {
          local block_pop : word 1 of `block_stack'
          local block_stack = subinstr("`block_stack'","`block_pop'","",1)

          if inlist("`block_pop'","foreach","forvalues","while") {
            local loop_stack = strreverse("`loop_stack'")
            local loop_pop : word 1 of `loop_stack'
            local loop_stack = strreverse( ///
              subinstr("`loop_stack'","`loop_pop'","",1))
          }
        }

        * Add if/else/noi/qui to block stack
        if !missing("`r(block_add)'") {
          local block_stack "`r(block_add)' `block_stack' "
        }

        * Reset default locals for this line
        local write_recline = 0

        * Remove /// and pass this line to be included in next line as
        * multiline code is being written to one line in the write/check files
        if (`line_wrap' == 1) {
          local break_pos = strpos(`"`macval(line)'"',"///")
          local last_line = substr(`"`macval(line)'"',1,`break_pos'-1)
        }

        * Not part of a multiline line
        else {

          * Reset the last line locals
          local last_line = ""
          local line_command = "OTHER"
          local dofile ""
          local doflag 0
          local looptype ""
          local loopflag 0

          // Sanitize that string!
          local 0 `"`macval(line)'"'


          // Identify all commands in line
          while `"`0'"' != "" {

            gettoken 1 0 : 0 , quotes
            if strpos(`"`1'"',"//") local 0 "" // End on comments
            if strpos(`"`1'"',"*") & "`line_command'" == "OTHER" local 0 "" // End on comments

            // di as err `"`1'  // `0'"'

            cap get_command, word(`"`1'"')

            if `doflag' == 1 local dofile = `"`1'"'
            if `loopflag' == 1 local looptype = "`1'"

            * Dofiles
            if "`r(command)'" == "do" | "`r(command)'" == "run" {
              local doflag = 1
            }
            else local doflag 0

            * Loops
            if "`r(command)'" == "foreach" | "`r(command)'" == "forvalues" {
              local loopflag = 1
            }
            else local loopflag 0

            local line_command = "`line_command' `r(command)'"
            mac shift
          }
            local line_command : list uniq line_command

          * If MMM
          if (strpos("`line_command'","mmm")) {
            di as err "Reproducibility Warning: Many-to-many merge on Line `lnum'"
            return local mmmflag = `lnum'
          }

          * If SSS
          if (strpos("`line_command'","sss")) {
            di as err "Reproducibility Warning: Sortseed set on Line `lnum'"
            return local sssflag = `lnum'
          }

          * If using capture, log it and take second word as command
          if (strpos("`line_command'","capture")) {
            local lastline_capture = 1
            local write_dataline = 0
          }
          * Handle row that is not capture
          else {
            * Test if _rc was used on line that is
            * not immedeatly after line with capture
            if `lastline_capture' == 0 & `has_rc' == 1 {
              noi di as error "{pstd}To make sure that {cmd:reprun} runs correctly, {cmd:_rc} is only allowed to be used immediately after the line where {cmd:capture} was used. See this article (TODO) for examples on how code can be rewritten to satisfy this requirement. Line number `lnum'.{p_end}"
              error 99
              exit
            }
            * Make sure that is capture local is reset
            local lastline_capture = 0
          }

          * Line is do or run, so call recursive function
          if (strpos(`"`line_command'"',"do")) | (strpos("`line_command'","run")) {

            * Write line handling recursion in data file
            local write_recline = 1

            * Get the file path from the second word
            local file = `"`dofile'"'
            local file_rev = strreverse(`"`file'"')

            * Only recurse on .do files and add .do when no extension is used
            if strpos(`"`file'"' , ".do") {
              local recurse 1
            }
            else if strpos(`"`file'"' , ".ado") {
              local recurse 0 // skip recursing reprun on adofiles
            }
            else {
              local recurse 1
              local file "`file'.do"
            }

            * Skip recursion instead of error if file not found
            cap confirm file `file'
            if _rc {
              local recurse 0
              di as err `"      Skipping recursion -- file not found: `file' "'
            }

            * Test if it should recurse or not
            if `recurse' == 1 {


              * Keep working on the stub
              local recursestub "`stub'_`++subf_n'"



              noi reprun_recurse, dofile(`file')     ///
                    output("`output'")   ///
                    stub("`recursestub'")
              local sub_f1 "`r(code_file_run1)'"
              local sub_f2 "`r(code_file_run2)'"


              * Substitute the original sub-dofile with the check/write ones
              if !strpos(`"`file'"',`"""') local file `""`file'""'

              local run1_line = ///
                subinstr(`"`line'"',`file',`""`sub_f1'""',1)
              local run2_line = ///
                subinstr(`"`line'"',`file',`""`sub_f2'""',1)

              *Correct potential ""path"" to "path"
              local run1_line = subinstr(`"`run1_line'"',`""""',`"""',.)
              local run2_line = subinstr(`"`run2_line'"',`""""',`"""',.)
            }
          }

          * No special thing with row needing alteration, write row as is
          else {

            * Copy the lines as is
            local run1_line `"`macval(line)'"'
            local run2_line `"`macval(line)'"'

            * Load the local in memory - important to
            * build file paths in recursive calls
            if (strpos("`line_command'","local")) | (strpos("`line_command'","global")) {
              // Capture in case running the macro requires data in memory
              capture `line'
            }

            * Write foreach/forvalues to block stack and
            * it's macro name to loop stack
            if (strpos("`line_command'","foreach")) {
              local block_stack   "foreach `block_stack' "
              local loop_stack = trim("`loop_stack' `looptype'")
            }

            if (strpos("`line_command'","forvalues")) {
              local block_stack   "forvalues `block_stack' "
              local loop_stack = trim("`loop_stack' `looptype'")
            }

            * Write while to block stack and
            * also "while" to loop stack as it does not have a macro name
            if strpos("`line_command'","while") {
              local block_stack   "while `block_stack' "
              local loop_stack = trim("`loop_stack' while")
            }
          }

          if (`write_recline' == 1) {
            file write `code_1' `"reprun_dataline, run(1) lnum(`lnum') datatmp("`data_f1'") recursestub(`recursestub') orgsubfile(`file')"' "`macval(rcout)'" _n
            file write `code_2' `"reprun_dataline, run(2) lnum(`lnum') datatmp("`data_f2'") recursestub(`recursestub') orgsubfile(`file')"' "`macval(rcout)'" _n
          }

          * Write the line copied from original file
          file write `code_1' `"`macval(run1_line)'"' _n "`macval(rcin)'" _n
          file write `code_2' `"`macval(run2_line)'"' _n "`macval(rcin)'" _n

          if (`write_dataline' == 1) {
            * prepare loop_string with macros
            local loop_str = ""
            foreach loop_macname of local loop_stack {
              if ("`loop_macname'"=="while") {
                local loop_str = "`macval(loop_str)' while"
              }
              else {
                local loop_str = ///
                  "`macval(loop_str)' `loop_macname':\``loop_macname''"
              }
            }

            * Write lines to run file 1 and 2
            file write `code_1' `"reprun_dataline, run(1) lnum(`lnum') datatmp("`data_f1'") looptracker("`macval(loop_str)'")"' _n "`macval(rcout)'" _n
            file write `code_2' `"reprun_dataline, run(2) lnum(`lnum') datatmp("`data_f2'") looptracker("`macval(loop_str)'")"' _n "`macval(rcout)'" _n
          }
        }
        local ++lnum
    }

    /*************************************************************************
      Close all tempfiles
    *************************************************************************/

    foreach fh in `code_orig' `code_1' `code_2' `data_1' `data_2' {
      file close `fh'
    }

    /*************************************************************************
      Return tempfiles so they can be used in when the test is run
    *************************************************************************/
    return local code_file_run1 "`code_f1'"
    return local code_file_run2 "`code_f2'"
  }

  end

  program define org_line_parse , rclass

    syntax, line(string)

    *Define defaults to be returned
    local write_dataline 1
    local firstw        ""
    local secondw       ""
    local thirdw        ""
    local line_wrap     0
    local block_add     ""
    local block_end     0
    local has_rc        0

    * Get the first words
    tokenize `" `macval(line)' "'

    ***********************************
    * Handle quietly and noisily
    ***********************************

    get_command , word(`"`1'"')
    local line_command = "`r(command)'"

    if inlist("`line_command'","quietly","noisily") {
      * Test if beginning of a noi/qui block
      if strpos(`"`macval(line)'"',"{") {
        local block_add "`line_command'"
      }
      * Retokenize without the noi/qui syntax (including the ":")
      local nline = subinstr(`"`macval(line)'"',"`1'","",1)
      if (`"`2'"' == ":") ///
        local nline = subinstr(`"`macval(nline)'"',"`2'","",1)
      if (substr(`"`1'"',1,1)==":") ///
        local nline = subinstr(`"`macval(nline)'"',":","",1)
      tokenize `" `macval(nline)' "'
    }

    ***********************************
    * Handle if-else
    ***********************************

    if inlist("`line_command'","if","else") {
      if strpos(`"`macval(line)'"',"{") {
        local block_add "`line_command'"
      }
    }

    ***********************************
    * Parse the line
    ***********************************

    local firstw  `"`macval(1)'"'
    local secondw `"`macval(2)'"'
    local thirdw  `"`macval(3)'"'

    * Empty line - skip writing to data file
    if (itrim(trim(`"`macval(line)'"')) == "") {
      local write_dataline 0
    }

    * Closed curly bracket - End of block
    else if (substr(`"`firstw'"',1,1)=="}") {
      local write_dataline 0
      local block_end = 1
    }

    /* /// line wrap  */
    if (strpos(`"`macval(line)'"',"///"))   local line_wrap 1

    /* Uses _rc  */
    if (strpos(`"`macval(line)'"'," _rc ")) local has_rc 1

    * Return all info
    return local write_dataline `write_dataline'
    return local firstw         `"`macval(firstw)'"'
    return local secondw        `"`macval(secondw)'"'
    return local thirdw         `"`macval(thirdw)'"'
    return local line_wrap      `line_wrap'
    return local block_end      `block_end'
    return local block_add      "`block_add'"
    return local has_rc         "`has_rc'"

  end

  * This program see if the string passed in word() is a match
  * (full word or abbreviation) to a command that toggles some
  * special beavior when writing the write and check files
  program define get_command, rclass

      syntax, [word(string)]

      local wlen = strlen(`"`word'"')

      local commands ""
      local commands "`commands' do ru:n"                    // File execution
      local commands "`commands' foreach forv:alues while"   // Iterations
      local commands "`commands' if else"                    // Logic
      local commands "`commands' loc:al gl:obal"             // Macros
      local commands "`commands' qui:etly n:oisily"          // Qui/noi
      local commands "`commands' cap:ture"                   // Qui/noi
      local match = 0

      foreach command of local commands {
        if (`match'==0) {
          gettoken abbr rest : command, parse(":")
          local rest = subinstr("`rest'",":","",1)
          local labbr = strlen("`abbr'")

          *Test if minimum abbreviation is the same
          if (substr(`"`word'"',1,`labbr')=="`abbr'") {
            *Test if remaining part of the word match the rest of the command
            if (substr(`"`word'"',`labbr'+1,.)==substr("`rest'",1,`wlen'-`labbr')) {
               return local command `"`abbr'`rest'"'
               local match = 1
            }
          }
        }
      }

      if "`word'" == "m:m" {
        return local command "mmm"
        local match = 1
      }

      if "`word'" == "sortseed" {
        return local command "sss"
        local match = 1
      }

      * No match, return OTHER
      if (`match'==0) {
          return local command "OTHER"
      }

  end

  /*****************************************************************************
  ******************************************************************************

   Sub-programs for: Comparing results in data files line by line

  ******************************************************************************
  *****************************************************************************/

  program define   recurse_comp_lines, rclass
  qui {
    syntax, dirout(string) stub(string) orgfile(string) ///
    outputcolumns(string) h_smcl(string) [verbose] [compact] [suppress(passthru)]


    local df1 "`dirout'/run1/`stub'.txt"
    local df2 "`dirout'/run2/`stub'.txt"

    tempname handle_df1 handle_df2
    file open `handle_df1' using "`df1'", read
    file open `handle_df2' using "`df2'", read

    local prev_line1 ""
    local prev_line2 ""

    * Local for empty tables
    local any_lines_written 0

    * Loop over all lines in the two data files
    local eof = 0
    while `eof' == 0 {

      * Read next line of data file 1
      file read `handle_df1' line1
      local eof1 = `r(eof)'
      * Read next line of data file 2
      file read `handle_df2' line2
      local eof2 = `r(eof)'

      *****************************
      * Test lines to see if the comparison is valid
      *****************************

      *Test if both lines are identitical
      local lines_identical = (`"`line1'"'==`"`line2'"')

      * Testing that not just one
      local eof = (`eof1' + `eof2')/2
      if (`eof' == .5) {
        noi di "Only one data file came to an end, that is an error"
        error 198
      }

      * Test if rows are recurse rows
      local is_recurse1 = ("`: word 1 of `line1''" == "recurse")
      local is_recurse2 = ("`: word 1 of `line2''" == "recurse")
      local recurse = (`is_recurse1' + `is_recurse2')/2
      if (`recurse' == .5) {
        noi di as error "Internal error: It should never be the case that only one row is a recurse row"
        error 198
      }
      else if (`recurse' == 1 & `lines_identical' == 0) {
        noi di as error "Internal error: Both rows are recurse but they are different"
        error 198
      }

      *****************************
      * Test lines to see if the comparison is valid
      *****************************

      * Skip rest if reached end of file
      if (`eof' != 1) {

        * If line is a recurse line, then recurese over that file
        if (`recurse' == 1 ) {

          * Getting stub name and orig ndofile name from recurse line
          local new_stub    : word 2 of `line1'
          local new_orgfile : word 3 of `line1'

          * Write end to previous table, write the file tree for the next
          * recursion, and write the beginning of that table
          if (`any_lines_written' == 1 ) {
		  	* Close the table for his file
			output_writetitle , outputcolumns("`outputcolumns'")
			noi write_and_print_output, h_smcl(`h_smcl') ///
			l1("`r(botline)'") l2(" ") ///
            l3(`"{pstd} Stepping into sub-file:{p_end}"')
		}
		else {
			* If the table is empty
			output_writetitle , outputcolumns("`outputcolumns'")
			noi write_and_print_output, h_smcl(`h_smcl') ///
			l1("`r(botline)'") l2("No mismatches and/or changes detected") l3(" ") ///
			l4(`"{pstd} Stepping into sub-file:{p_end}"')
		}

          noi print_filetree_and_verbose_title, ///
            files(`" `orgfile' "`new_orgfile'" "') h_smcl(`h_smcl') `verbose' `compact'
          output_writetitle , outputcolumns("`outputcolumns'")
          noi write_and_print_output, h_smcl(`h_smcl') ///
            l1("`r(topline)'") l2("`r(state_titles)'") ///
            l3("`r(col_titles)'") l4("`r(midline)'")

          * Make the recurisive call for next file
          noi recurse_comp_lines , dirout("`dirout'") stub("`new_stub'") ///
            orgfile(`" `orgfile' "`new_orgfile'" "') ///
            outputcolumns("`outputcolumns'") h_smcl(`h_smcl') `verbose' `compact' `suppress'

          * Step back into this data file after the recursive call and:
          * Write file tree, and write the titles to the continuation for
          * this file
          noi write_and_print_output, h_smcl(`h_smcl') ///
            l1(`"{phang} Stepping back into file:{p_end}"')
          noi print_filetree_and_verbose_title, ///
            files(`" `orgfile' "') h_smcl(`h_smcl') `verbose' `compact'
          output_writetitle , outputcolumns("`outputcolumns'")
          noi write_and_print_output, h_smcl(`h_smcl') ///
              l1("`r(topline)'") l2("`r(state_titles)'") ///
              l3("`r(col_titles)'") l4("`r(midline)'")
        }
        * Line is data and not recurse : compare the lines
        else {

          * Compare if lines are different across runs, but also if lines has changed since last line
          compare_data_lines, ///
            l1("`line1'") pl1("`prev_line1'") ///
            l2("`line2'") pl2("`prev_line2'") ///
            `suppress'

          * Only display line if there is a mismatch, or if option verbose
          * is used, also output if there is a change from previous line
          local write_outputline 0

            * Check each value individually for changes and mismatches
            foreach matchtype in rng srng dsum {
              * Test if any line is "Change"
              local any_change = ///
                strpos("`r(`matchtype'_c1)'`r(`matchtype'_c2)'","Change")
              if (`any_change' > 0 & !missing(`"`verbose'"')) ///
                local write_outputline 1
              * Test if any line is "Mismatch"
              local any_mismatch = ///
                max(strpos("`r(`matchtype'_m)'","ERR"),strpos("`r(`matchtype'_m)'","DIFF"))
              if (`any_mismatch' > 0) & missing(`"`compact'"') local write_outputline 1
              * Compact display
              if ("`matchtype'"!="dsum") & (`any_mismatch' > 0) & (`any_change' > 0) local write_outputline 1
            }

          * If line is supposed to be outputted, write line
          if (`write_outputline' == 1 ) {
            output_writerow ,                                                  ///
              outputcolumns("`outputcolumns'") lnum("`r(lnum)'")               ///
              rng1("`r(rng_c1)'")   rng2("`r(rng_c2)'")   rngm("`r(rng_m)'")   ///
              srng1("`r(srng_c1)'") srng2("`r(srng_c2)'") srngm("`r(srng_m)'") ///
              dsum1("`r(dsum_c1)'") dsum2("`r(dsum_c2)'") dsumm("`r(dsum_m)'") ///
              loopiteration("`r(loopt)'")
            noi write_and_print_output, h_smcl(`h_smcl') l1("`r(outputline)'")
			local any_lines_written 1
          }

          * Load these lines into pre_line locals for next run
          local prev_line1 "`line1'"
          local prev_line2 "`line2'"
        }
      }
      * End of this data file
      else {
	  	* If the table is not empty
	  	if (`any_lines_written' == 1 ) {
			* Close the table for his file
			output_writetitle , outputcolumns("`outputcolumns'")
			noi write_and_print_output, h_smcl(`h_smcl') ///
			l1("`r(botline)'") l2(" ")
		}
		else {
			* If the table is empty
			output_writetitle , outputcolumns("`outputcolumns'")
			noi write_and_print_output, h_smcl(`h_smcl') ///
			l1("`r(botline)'") l2("No mismatches and/or changes detected") l3(" ")
		}
      }
    }
  }
  end

  program define   compare_data_lines, rclass

      syntax, l1(string) l2(string) [pl1(string) pl2(string) suppress(string)]

      * Parse all lines and put then into locals to be compared
      foreach line in l1 l2 pl1 pl2 {
        local data "``line''"
        while !missing(`"`data'"') {
            * Parse next key:value pair of data
            gettoken keyvaluepair data : data, parse("&")
            local data = substr("`data'",2,.) // remove parse char
            * Get key and value from pair and return
            gettoken key value : keyvaluepair, parse(":")
            local `line'_`key' = substr("`value'",2,.) // remove parse char
        }
      }

      * Testing an returning line number
      if ("`l1_l'" != "`l2_l'") {
          noi di as error "Internal error: The line number should always be the same in data line from run 1 and run 2. But in this case line number in run 1 it is `l1_l', and in run 2 it is `l1_2'"
          error 198
      }
      return local lnum "`l1_l'"

      if ("`l1_loopt'" != "`l1_loopt'") {
          noi di as error "Internal error: The looptracker should always be the same in data line from run 1 and run 2. But in this case looptracker in run 1 it is `l1_loopt', and in run 2 it is `l2_loopt'"
          error 198
      }

      // Suppress loop info
      if ("`l1_loopt'" == "`pl1_loopt'") & !missing("`l1_loopt'") & strpos("`suppress'","loop") ///
        local l1_loopt ""
      return local loopt "`l1_loopt'"

      * Logic for minimal SRNG checker
        local l1_srng = "`l1_srngstate'"
        local pl1_srng = "`pl1_srngstate'"

        if ("`l1_srngstate'" != "`pl1_srngstate'") & ("`l2_srngcheck'" != "`l1_srngcheck'") {
          local l2_srng = "`l2_srngstate'"
          local pl2_srng = "`pl2_srngstate'"
        }
        else {
          local l2_srng = "`l1_srngstate'"
          local pl2_srng = "`pl1_srngstate'"
        }

      local arrow "{c -}{c -}{c -}{c -}{c -}>"

      * Comparing all states since previous line and between runs
      foreach state in rng srng dsum {

        * Compare state in each run compared to previous line
        local `state'_c1 = ""
        local change1 0
        if ("`l1_`state''" != "`pl1_`state''") & ("`pl1_`state''"!="") {
          local `state'_c1 = "Change"
          local change1 1
        }

        local `state'_c2 = ""
        local change2 0
        if ("`l2_`state''" != "`pl2_`state''") & ("`pl2_`state''"!="") {
          local `state'_c2 = "Change"
          local change2 1
        }

        // Ignore RNG if seed is still on default seed
        if ("`state'" == "rng") {
          set seed 123456789
          if ("`l1_`state''" == "`c(rngstate)'") {
            local `state'_c1 = ""
            local `state'_c2 = ""
            local l1_`state' = "DEFAULT"
            local l2_`state' = "DEFAULT"
            local change1 0
            local change2 0
          }
        }


        ************************************************************
        * Compare states across runs

        * Match
        if ("`l1_`state''" == "`l2_`state''") {
          if !missing("``state'_c1'``state'_c2'") return local `state'_m "OK!"
          if strpos(" `suppress' "," `state' ") {
            return local `state'_m ""
            local `state'_c1 = ""
            local `state'_c2 = ""
          }
        }

        * Return the labels for each state
        return local `state'_c1 "``state'_c1'"
        return local `state'_c2 "``state'_c2'"

        * Not matching
        else {
          * Stata changes in both runs, but to different values
          if (`change1' & `change2') {
            return local `state'_m "{err:DIFF}"
          }
          * Neither value changed, they were different from before
          else if (!`change1' & !`change2') {
            return local `state'_m ""
          }
          * Only one value changed - that is an error
          else {
            return local `state'_m "{err:ERR}"
          }
        }


      }
  end

  /*****************************************************************************
  ******************************************************************************

   Sub-programs for: Output results

  ******************************************************************************
  *****************************************************************************/

  * This sub-program prints output to file and screen.
  * It can print up to 6 lines at the same time l1-l6
  * It has a shorthand to print the intro output
  program define   write_and_print_output, rclass

    syntax , h_smcl(string) [intro_output ///
      l1(string) l2(string) l3(string) l4(string) l5(string) l6(string)]

    * Prepare setup lines
    if !missing("`intro_output'") {
      local l1 " "
      local l2 "{hline}"
      local l3 "`line'{phang}reprun output created by user `c(username)' at `c(current_date)' `c(current_time)'{p_end}"
      local l4 "`line'{phang}Operating System `c(machine_type)' `c(os)' `c(osdtl)'{p_end}"
      local l5 "`line'{phang}Stata `c(edition_real)' - Version `c(stata_version)' running as version `c(version)'{p_end}"
      local l6 "{hline}"
    }

    * Output and write the lines
    forvalues line = 1/6 {
      if !missing(`"`l`line''"') {
        noi di as res `"`l`line''"'
        file write `h_smcl' `"`l`line''"' _n
      }
    }
  end

 	program define output_writerow, rclass

    syntax , outputcolumns(numlist) lnum(string) ///
      [rng1(string)  rng2(string)  rngm(string) ///
      srng1(string) srng2(string) srngm(string) ///
      dsum1(string) dsum2(string) dsumm(string) ///
      loopiteration(string)]

    local c1 : word 1 of `outputcolumns'
    local c2 : word 2 of `outputcolumns'
    local c3 : word 3 of `outputcolumns'
    local c4 : word 4 of `outputcolumns'
    local c5 : word 5 of `outputcolumns'

    * Line number
    local out_line "{c |} `lnum' {col `c1'}"

    * Rng state
    local c1 = (`c1' + 9)
    local out_line "`out_line'{c |} `rng1'{col `c1'}"
    local c1 = (`c1' + 9)
    local out_line "`out_line'  `rng2'{col `c1'}"
    local out_line "`out_line'  `rngm'{col `c2'}"

    * Sort rng state
    local c2 = (`c2' + 9)
    local out_line "`out_line'{c |} `srng1'{col `c2'}"
    local c2 = (`c2' + 9)
    local out_line "`out_line'  `srng2'{col `c2'}"
    local out_line "`out_line'  `srngm'{col `c3'}"

    * Datasignature
    local c3 = (`c3' + 9)
    local out_line "`out_line'{c |} `dsum1'{col `c3'}"
    local c3 = (`c3' + 9)
    local out_line "`out_line'  `dsum2'{col `c3'}"
    local out_line "`out_line'  `dsumm'{col `c4'}"


    local out_line "`out_line'{c |} `loopiteration'"
    return local outputline `out_line'

  end

  program define output_writetitle, rclass

    syntax , outputcolumns(string)

    local c1 : word 1 of `outputcolumns'
    local c2 : word 2 of `outputcolumns'
    local c3 : word 3 of `outputcolumns'
    local c4 : word 4 of `outputcolumns'
    local c5 : word 5 of `outputcolumns'

    local h1 = `c1'-2
    local h2 = `c2'-`c1'-1
    local h3 = `c3'-`c2'-1
    local h4 = `c4'-`c3'-1
    local h5 = `c5'-`c4'-1

    * Top-line
    local tt "{c TT}"
    local tl "{c TLC}{hline `h1'}`tt'{hline `h2'}`tt'{hline `h3'}`tt'{hline `h4'}"
    return local topline "`tl'`tt'{hline `h5'}"

    * State titel line
    local sl "{c |}{col `c1'}"
    local sl "`sl'{c |}{dup 6: }Seed RNG State{col `c2'}"
    local sl "`sl'{c |}{dup 6: }Sort Order RNG{col `c3'}"
    local sl "`sl'{c |}{dup 6: }Data Checksum{col `c4'}"
    return local state_titles "`sl'{c |}"

    * Column title line
    local ct "{c |} Run 1  {c |} Run 2  {c |} Match  "
    local cl "{c |} Line # {col `c1'}"
    local cl "`cl'`ct'{col `c2'}`ct'{col `c3'}`ct'{col `c4'}{c |}"
    return local col_titles "`cl' Loop iteration:"

    * Middle-line
    local mt "{c +}"
    local ml "{c LT}{hline 8}`mt'"
    local ml "`ml'{hline 8}`mt'{hline 8}`mt'{hline 8}`mt'"
    local ml "`ml'{hline 8}`mt'{hline 8}`mt'{hline 8}`mt'"
    local ml "`ml'{hline 8}`mt'{hline 8}`mt'{hline 8}`mt'"
    return local midline "`ml'{hline `h5'}"

    * Bottom-line
    local bt "{c BT}"
    local bl "{c BLC}{hline 8}`bt'"
    local bl "`bl'{hline 8}`bt'{hline 8}`bt'{hline 8}`bt'"
    local bl "`bl'{hline 8}`bt'{hline 8}`bt'{hline 8}`bt'"
    local bl "`bl'{hline 8}`bt'{hline 8}`bt'{hline 8}`bt'"
    return local botline "`bl'{hline `h5'}"

  end

  * Print file tree
  program define   print_filetree_and_verbose_title, rclass
    syntax , files(string) h_smcl(string) [verbose] [compact]
    local file_count = 0

    foreach file of local files {
      noi write_and_print_output, h_smcl(`h_smcl') ///
        l1(`"{pstd}{c BLC}{hline `++file_count'}> `file'{p_end}"')
    }

    noi di ""
    if missing("`verbose'") & missing("`compact'") {
      noi di as res "{phang}Lines where Run 1 and Run 2 mismatch for any value:{p_end}"
    }

    if !missing("`verbose'") {
      noi di as res "{phang}Lines where Run 1 and Run 2 mismatch {ul:or} change for any value:{p_end}"
    }

    if !missing("`compact'") {
      noi di as res "{phang}Lines where Run 1 and Run 2 mismatch {ul:and} change for any value:{p_end}"
    }

  end

  /*****************************************************************************
  ******************************************************************************

   Utility sub-programs

  ******************************************************************************
  *****************************************************************************/

  * This program can delete all your folders on your computer if used incorrectly.
  cap program drop rm_output_dir
  	program define rm_output_dir

  	syntax , folder(string)

    *Test that folder exist
    mata : st_numscalar("r(dirExist)", direxists("`folder'"))
    if (`r(dirExist)' != 0) {

    	* File paths can have both forward and/or back slash.
      * We'll standardize them so they're easier to handle
    	local folderStd			= subinstr(`"`folder'"',"\","/",.)

    	* List directories, files and other files
      local dlist : dir `"`folderStd'"' dirs  "*" , respectcase
      local flist : dir `"`folderStd'"' files "*"	, respectcase
    	local olist : dir `"`folderStd'"' other "*"	, respectcase
      local files `"`flist' `olist'"'

    	* Recursively call this command on all subfolders
    	foreach dir of local dlist {
    		rm_output_dir , folder(`"`folderStd'/`dir'"')
    	}

    	* Remove files in this folder
    	foreach file of local files {
    		rm `"`folderStd'/`file'"'
    	}

    	* Remove this folder as it is now empty
    	rmdir `"`folderStd'"'
    }
  end

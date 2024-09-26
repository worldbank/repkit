*! version 3.1 20240926 - DIME Analytics & LSMS Team, The World Bank - dimeanalytics@worldbank.org, lsms@worldbank.org

cap program drop   repadolog
    program define repadolog

qui {

    version 14.1

    * Update the syntax. This is only a placeholder to make the command run
    syntax [using/], [Detail Save SAVEPath(string) QUIetly]

    *Get the full user input
    local full_user_input = "repadolog " + trim(itrim(`"`0'"'))
    local full_user_input : subinstr local full_user_input "\" "/" , all
    if (!strpos(`"`full_user_input'"',",")) {
      local full_user_input `"`full_user_input' ,"'
    }

    ****************************************************************************
    ****************************************************************************
    * Handle input
    ****************************************************************************

    ************************
    * Find trk file to use

    * If no file path was used, find the trk file along the adopaths
    if missing("`using'") {
      findfile stata.trk
      if missing("`r(fn)'") {
        noi di as error "No stata.trk file was found across the adopaths"
        error 99
        exit
      }
      else {
        local trkfile   "`r(fn)'"
        local trkfolder = subinstr("`trkfile'","/stata.trk","",.)
      }
    }
    else {
      * If user included "stata.trk" in filepath, then remove to standardize
      if (substr("`using'",-9,9) == "stata.trk") {
        local using = substr("`using'",1,strlen("`using'")-10)
      }
      * Test if a file exists in that location
      cap confirm file "`using'/stata.trk"
      if _rc {
        noi di as error `"{pstd}No stata.trk file was found at location provided in using: {inp:`using'}{p_end}"'
        error 99
        exit
      }
      local trkfolder "`using'"
      local trkfile   "`trkfolder'/stata.trk"
    }


    noi di as text _n "{pstd}Using {bf:stata.trk} file found at location {bf:`trkfolder'/}{p_end}"

    ************************
    * Handle csv output options

    * Test if either option for outputting csv is used
    if !missing("`save'`savepath'") {
      local csvused 1
      * Test if savepath() option is used
      if !missing("`savepath'") {
        * Test if file is a csv file
        if (substr("`savepath'",-4,4) != ".csv") {
          noi di as error `"{pstd}The file in {opt savepath(`savepath') is not a CSV-file.}{p_end}"'
          error 99
          exit
        }
      }
      * savepath is not used, save the report in the same location as the trk
      else {
        local savepath   "`trkfolder'/repadolog.csv"
      }
    }
    * Niether save or savepath is used
    else {
      local csvused 0
    }


    ****************************************************************************
    ****************************************************************************
    * Execute the command
    ****************************************************************************

    ************************
    * Set up the frame

    * Create a frame to store all pkg info and command info
    tempname pkg_frame
    frame create `pkg_frame' ///
      str500(package_name distribution_date download_date command_name checksum) strL(notes commands source) byte(is_cmd)

    * Read the trk file
    tempname trk_read
    file open `trk_read'  using "`trkfile'", read

    * Initiate commands local
    local commands ""
    local cmd_count = 0

    ************************
    * Parse the trk file

    * Read first line
    file read `trk_read' line

    * Write lines as-is until section
    while (r(eof)==0) {

        * Escape tricky characters
        local line : subinstr local line "'"   `"" _char(39) ""', all
        local line : subinstr local line "`"   `"" _char(96) ""', all

        * Get the source the command is installed from
        if (substr(`"`macval(line)'"',1,2) == "S ") {
          local source `=trim(substr(`"`line'"',3,.))'
        }

        * Get package name
        if (substr(`"`macval(line)'"',1,2) == "N ") {
          local pkgname `=trim(substr(`"`line'"',3,.))'
        }

        * Get download date
        if (substr(`"`macval(line)'"',1,2) == "D ") {
          local downdate `=trim(substr(`"`line'"',3,.))'
        }

        * Get commands
        if (lower(substr(`"`macval(line)'"',1,2)) == "f ") {
          noi parse_command `=trim(substr(`"`line'"',3,.))', trkfolder("`trkfolder'")
          if ("`r(is_ado)'" == "1") {
            local cmd_count = `cmd_count' + 1
            local commands "`commands', `r(command_name)'"
            local cmd_name_`cmd_count' = "`r(command_name)'"
            local cmd_chck_`cmd_count' = "`r(checksum)'"
            local cmd_note_`cmd_count' = `"`r(notes)'"'
          }
        }

        * Get distribution date
        if (substr(`"`macval(line)'"',1,21) == "d Distribution-Date: ") {
          local distdate `=trim(substr(`"`line'"',22,.))'
        }

        if (substr(`"`macval(line)'"',1,2) == "e") {

          * Distribution date is options, explicitly set N/A when missing
          if missing("`distdate'") local distdate "No date in stata.trk"

          local commands = trim(subinstr("`commands'",",","",1))

          * Write package line to the data frame
          frame post `pkg_frame' ("`pkgname'") ("`distdate'") ("`downdate'") ("") ("") ("") ("`commands'") ("`source'") (0)

          * Write command line to the data frame
          forvalues i = 1/`cmd_count' {
            frame post `pkg_frame' ("`pkgname'") ("`distdate'") ("`downdate'") ("`cmd_name_`i''") ("`cmd_chck_`i''") (`"`cmd_note_`i''"') ("") ("`source'") (1)
          }

          * Resetting all locals
          local pkgname  ""
          local distdate ""
          local downdate ""
          local commands ""
          local cmd_count = 0
          local source   ""
        }
        * Read next line
        file read `trk_read' line
    }

    ****************************************************************************
    ****************************************************************************
    * Perform output
    ****************************************************************************

    * A list of package info vars always included
    local pkg_vars "package_name distribution_date download_date"

    * Handle what to include in output based on the option detail used or not
    if missing("`detail'") {
      local roworder package_name command_name source //package name first - source break ties
      local colorder "`pkg_vars' commands source"
      local keepcondition "is_cmd == 0"
    }
    else {
      local roworder command_name package_name source //command name first - source break ties
      local colorder "command_name `pkg_vars' checksum notes source"
      local keepcondition "is_cmd == 1"
    }

    * Display and save output
    frame `pkg_frame' {
      * Keep only relevant rows, and sort as needed
      keep if `keepcondition'
      sort `roworder'
      order `colorder'
      * Output in result window if applicable
      if missing("`quietly'") noi list `colorder', abbreviate(32)
      * Save if applicable
      if `csvused' == 1 {
        qui export delimited `colorder' using `"`savepath'"', replace quote
      }
    }
    if `csvused' == 1 {
      noi di as text _n `"{pstd}{inp:repadolog} report written to {browse "`savepath'":`savepath'}.{p_end}"'
    }
    else {
      noi di as text _n `"{pstd}No report saved to disk. To save a {inp:repadolog} report in the same location as your {it:stata.trk} file, {stata `"`full_user_input' save"' :click here}. To save the report in a custom location run this command again using the {opt savepath()} option.{p_end}"'
    }
}
end

cap program drop   parse_command
    program define parse_command, rclass

qui {
    syntax anything, trkfolder(string)
    local cpath "`anything'"

    * Test that file is ado-file
    if (substr("`cpath'",-4,4) == ".ado") {
      * Extract command name
      local cname = substr("`cpath'",3,strlen("`cpath'")-6)

      * See if the file is found or if the file path in the trk file is broken
      cap confirm file "`trkfolder'/`cpath'"
      if _rc {
        local cksum "N/A"
        local notes "N/A"
      }

      * File path works, generate results based on the file content
      else {
        * Get size and checksum of the file content
        checksum "`trkfolder'/`cpath'"
        local cksum "`r(filelen)':`r(checksum)'"

        **************************
        * Read the content of the file and extract all notes,
        * i.e. lines starting with !*

        * Read the ado-file
        tempname ado_read
        file open `ado_read'  using "`trkfolder'/`cpath'", read
        * Read first line of the ado-file
        file read `ado_read' line

        * Loop over all lines
        local notes ""
        while (r(eof)==0) {

          * Escape tricky characters
          local line : subinstr local line "'"   `"" _char(39) ""', all
          local line : subinstr local line "`"   `"" _char(96) ""', all

          * Test if line is a notes line
          if (substr(trim(`"`macval(line)'"'),1,2) == "*!") {
            local notes `"`macval(notes)', `macval(line)'"'
          }
          * Read next line of the ado-file
          file read `ado_read' line
        }

        * Clean up notes
        local notes =trim(itrim(subinstr(`"`macval(notes)'"',",","",1)))
      }

      * Return dofile locals
      return local is_ado       1
      return local command_name "`cname'"
      return local checksum     "`cksum'"
      return local notes        `"`macval(notes)'"'
    }

    * Not an ado file
    else {
      return local is_ado       0
    }
}
end

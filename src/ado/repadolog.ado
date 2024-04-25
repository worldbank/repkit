*! version XX XXXXXXXXX ADAUTHORNAME ADCONTACTINFO

cap program drop   repadolog
    program define repadolog

qui {

    version /* ADD VERSION NUMBER HERE */

    * Update the syntax. This is only a placeholder to make the command run
    syntax [using/], [Detail SAVEcsv CSVpath(string) QUIetly]

    *Get the full user input
    local full_user_input = "repadolog " + trim(itrim(`"`0'"'))
    local full_user_input : subinstr local full_user_input "\" "/" , all

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

    ************************
    * Handle csv output options

    * Test if either option for outputting csv is used
    if !missing("`savecsv'`csvpath'") {
      local csvused 1
      * Test if csvpath() option is used
      if !missing("`csvpath'") {
        * Test if file is a csv file
        if (substr("`csvpath'",-4,4) != ".csv") {
          noi di as error `"{pstd}The file in {opt csvpath(`csvpath') is not a CSV-file.}{p_end}"'
          error 99
          exit
        }
      }
      * csvpath is not used, save the report in the same location as the trk
      else {
        local csvpath   "`trkfolder'/repadolog.csv"
      }
    }
    * Niether savecsv or csvpath is used
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
      str500(package_name distribution_date download_date command_name checksum notes) str2000(commands source) byte(is_cmd)

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
        //noi di `"`macval(line)'"'

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
            local cmd_note_`cmd_count' = "`r(notes)'"
          }
        }

        * Get distribution date
        if (substr(`"`macval(line)'"',1,21) == "d Distribution-Date: ") {
          local distdate `=trim(substr(`"`line'"',22,.))'
        }

        if (substr(`"`macval(line)'"',1,2) == "e") {

          * Distribution date is options, explicitly set N/A when missing
          if missing("`distdate'") local distdate "N/A"

          local commands = trim(subinstr("`commands'",",","",1))

          * Write package line to the data frame
          frame post `pkg_frame' ("`pkgname'") ("`distdate'") ("`downdate'") ("") ("") ("") ("`commands'") ("`source'") (0)

          * Write command line to the data frame
          forvalues i = 1/`cmd_count' {
            frame post `pkg_frame' ("`pkgname'") ("`distdate'") ("`downdate'") ("`cmd_name_`i''") ("`cmd_chck_`i''") ("`cmd_note_`i''") ("") ("`source'") (1)
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
      local roworder package_name command_name //package name first
      local colorder "`pkg_vars' commands source"
      local cond "is_cmd == 0"
    }
    else {
      local roworder command_name package_name //command name first
      local colorder "command_name `pkg_vars' checksum notes source"
      local cond "is_cmd == 1"
    }

    * Display and save output
    noi frame `pkg_frame' {
      sort `roworder'
      order `colorder'
      if missing("`quietly'") noi list `colorder' if `cond', abbreviate(32)
      if `csvused' == 1 {
        export delimited `colorder' using `"`csvpath'"' if `cond', replace quote
      }
    }
    if `csvused' == 1 {
      noi di as text `"{pstd}Ado log report written to {browse "`trkfolder'/repadolog.csv":`trkfolder'/repadolog.csv}.{p_end}"'
    }
    else {
      // TODO
    }

    // Remove then command is no longer in beta
    noi repkit "beta repadolog"
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
          * Test if line is a notes line
          if (substr(trim(`"`macval(line)'"'),1,2) == "*!") {
            local notes `"`macval(notes)', `macval(line)'"'
          }
          * Read next line of the ado-file
          file read `ado_read' line
        }

        * Clean up notes
        local notes = trim(subinstr(`"`macval(notes)'"',",","",1))
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

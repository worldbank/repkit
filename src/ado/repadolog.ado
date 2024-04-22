*! version XX XXXXXXXXX ADAUTHORNAME ADCONTACTINFO

cap program drop   repadolog
    program define repadolog

qui {

    version /* ADD VERSION NUMBER HERE */

    * Update the syntax. This is only a placeholder to make the command run
    syntax [using/], [details]

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

    * Create a frame for
    tempname prov_frame
    frame create `prov_frame' str50(package_name  distribution_date) str50 download_date str2000(commands source)

    * Read the trk file
    tempname trk_read
    file open `trk_read'  using "`trkfile'", read

    * Read first line
    file read `trk_read' line

    * Write lines as-is until section
    while r(eof)==0 {

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

        * Get distribution date
        if (substr(`"`macval(line)'"',1,21) == "d Distribution-Date: ") {
          local distdate `=trim(substr(`"`line'"',22,.))'
        }

        if (substr(`"`macval(line)'"',1,2) == "e") {

          * Distribution date is options, explicitly set N/A when missing
          if missing("`distdate'") local distdate "N/A"

          * Write to the data frame
          frame post `prov_frame' ("`pkgname'") ("`distdate'") ("`downdate'") ("commands") ("`source'")

          * Resetting all locals
          local pkgname  ""
          local distdate ""
          local downdate ""
          local commands ""
          local source   ""
        }
        * Read next line
        file read `trk_read' line
    }

    //noi frames dir
    noi frame `prov_frame': list

    frame `prov_frame': export delimited "`trkfolder'/repadolog.csv", replace quote
    noi di as text `"{pstd}Ado log report written to {browse "`trkfolder'/repadolog.csv":`trkfolder'/repadolog.csv}.{p_end}"'

    // Remove then command is no longer in beta
    noi repkit "beta repadolog"
}
end

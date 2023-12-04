*! version 1.0 05NOV2023 DIME Analytics dimeanalytics@worldbank.org

cap program drop   repkit
    program define repkit, rclass

    version 13.0

    * UPDATE THESE LOCALS FOR EACH NEW VERSION PUBLISHED
  	local version "1.0"
  	local versionDate "05NOV2023"

  	syntax [anything]

    * Prepare returned locals
    return local versiondate     "`versionDate'"
    return local version		      = `version'

    * Display output
    noi di ""
    local cmd    "repkit"
    local vtitle "This version of {inp:`cmd'} installed is version:"
    local btitle "This version of {inp:`cmd'} was released on:"
    local col2 = max(strlen("`vtitle'"),strlen("`btitle'"))
    noi di as text _col(4) "`vtitle'" _col(`col2')"`version'"
    noi di as text _col(4) "`btitle'" _col(`col2')"`versionDate'"

end

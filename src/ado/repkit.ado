cap program drop   repkit
    program define repkit, rclass

    * UPDATE THESE LOCALS FOR EACH NEW VERSION PUBLISHED
  	local version "0.1"
  	local versionDate "22AUG2023"

  	syntax [anything]

  	version 12

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

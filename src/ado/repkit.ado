*! version 1.0 05NOV2023 DIME Analytics dimeanalytics@worldbank.org

cap program drop   repkit
    program define repkit, rclass

    version 13.0

    * UPDATE THESE LOCALS FOR EACH NEW VERSION PUBLISHED
  	local version "1.0"
  	local versionDate "05NOV2023"
    local cmd    "repkit"

  	syntax [anything]

  	version 12

    * Prepare returned locals
    return local versiondate     "`versionDate'"
    return local version		      = `version'

    if missing(`"`anything'"') {
      * Display output
      noi di ""
      local vtitle "This version of {inp:`cmd'} installed is version:"
      local btitle "This version of {inp:`cmd'} was released on:"
      local col2 = max(strlen("`vtitle'"),strlen("`btitle'"))
      noi di as text _col(4) "`vtitle'" _col(`col2')"`version'"
      noi di as text _col(4) "`btitle'" _col(`col2')"`versionDate'"
    }
    else {

      * Tokenize the subcommand and its potential options
      tokenize `anything'
      local subcmd "`1'"
      local subtwo "`2'"
      local subthree "`3'"
      local subfour "`4'"

      if ("`subcmd'" == "beta") {

        noi di "{hline}" _n
        noi di as text "{pstd}{ul:{red:Warning:} This command currently only released as a beta release}{p_end}" _n
        noi di as text "{pstd}We're excited to introduce a beta release of the command {inp:`subtwo'}. Feedback from users like you will help us refine and finalize this command. We, especially during the beta phase, welcome bug reports, feature requests, and any other comments at: https://github.com/dime-worldbank/repkit/issues. {p_end}" _n
        noi di as text "{pstd}Please note that during the beta release we might rename or remove options without building in backward compatibility, and some still eperimental features might not be fully documented.{p_end}" _n
        noi di _n "{hline}"
      }

      else {
        noi di "{pstd}The sub-command [`subcmd'] used with `cmd' is not valid.{p_end}"
        error 99
        exit
      }
    }
end

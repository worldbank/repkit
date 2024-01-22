*! version 1.1 17DEC2024 DIME Analytics dimeanalytics@worldbank.org

cap program drop   repado
    program define repado, rclass

qui {

    version 13.0

    syntax [using/], ///
      /// Optional commands
      [ ///
      nostrict ///
      lessverbose ///
      /// Old undocumented but still supported yntax
      adopath(string) ///
      mode(string) ///
      ]

    /***************************************************************************
    ****************************************************************************
      TEST INPUT
    ****************************************************************************
    ***************************************************************************/

    * If using is used, use that path, otherwise use old syntax
    if !missing("`using'") {
      local adopath "`using'"
    }

    * Mimic stata's built in check for using
    if missing("`adopath'") {
      noi di as error "using required"
      error 100
      exit
    }

    * Test adopath input
    mata : st_numscalar("r(dirExist)", direxists("`adopath'"))
    if (`r(dirExist)' == 0) {
      noi di as error `"{phang}The folder path [`adopath'] in adopath(`adopath') does not exist.{p_end}"'
      error 99
    }


    * Test that if the old undocumented option mode() was used,
    * its value is still strict/nostrict or missing
    if !inlist("`mode'","strict","nostrict","") {
      noi di as error `"{phang}When using the old and undocumented but still supported option {inp:mode()}, its value  must be {inp:strict} or {inp:nostrict}. See helpfile {help repado} for the option {inp:nostrict} that replaced the option {inp:mode()}.{p_end}"'
      error 99
    }

    *** Handling supporting the old undocumented command mode
    * Option nostrict not used
    if missing("`strict'") {
      * Neither is mode, so use default strict mode
      if missing("`mode'") local mode "strict"
      //else: kept value from mode() already in `mode'
    }
    * Option nostrict is used
    else {
      * test that mode(strict) was not used with nostrict
      if ("`mode'" != "strict") local mode "nostrict"
      else {
        * nostrict was used with strict - thats ambigious
        noi di as error `"{pstd}Option {inp:nostrict} cannot be used together with value {sf:"strict"} in the old undocummented option {inp:mode()}.{p_end}"'
      }
    }

    /***************************************************************************
    ****************************************************************************
      ADO PATH SECTION
    ****************************************************************************
    ***************************************************************************/

    ****
    * STRICT MODE

    if ("`mode'" == "strict") {

      * Set PLUS to adopath and list it first, then list BASE first.
      * This means that BASE is first and PLUS is second.
      sysdir set  PLUS `"`adopath'"'
      adopath ++  PLUS
      adopath ++  BASE

      * Keep removing adopaths with rank 3 until only BASE and PLUS,
      * that has rank 1 and 2, are left in the adopaths
      local morepaths 1
      while (`morepaths' == 1) {
        capture adopath - 3
        if _rc local morepaths 0
      }

      * Update the paths where mata search for commands to mirror adopath
      mata: mata mlib index

    }

    ****
    * NO STRICT MODE

    else {
      * Set PERSONAL path to ado path
      sysdir set  PERSONAL `"`adopath'"'
      adopath ++  PERSONAL
      adopath ++  BASE
    }

    * Print user output
    noi print_output, adopath("`adopath'") mode("`mode'") `lessverbose'

    return local repado_mode "`mode'"
    return local repado_path "`adopath'"

}  //quietly
end


cap program drop   print_output
    program define print_output

    syntax , adopath(string) mode(string) [lessverbose]

    ****
    * Print Intro

    * Strict intro
    if ("`mode'" == "strict") {
      noi di as text _n `"{pstd}{inp:repado} has set the PLUS adopath for this Stata session to {inp:`adopath'} and removed all other adopaths except for BASE. PLUS has second priority after BASE.{p_end}"'

    }
    * No strict intro
    else {
      noi di as text _n `"{pstd}{inp:repado} has set the PERSONAL adopath for this Stata session to {inp:`adopath'} and given it second priority after BASE. All other adopaths remain unchanged.{p_end}"'
    }

    ****
    * Print details unless lessverbose is used
    if missing("`lessverbose'") {

      noi di as text _n "{pstd}This means that in this session (until you restart Stata), the following is true:{p_end}"

      * Strict details
      if ("`mode'" == "strict") {
        noi di as text `"{phang}- Only Stata's built-in commands in BASE and user-written commands installed in the new PLUS folder {inp:`adopath'} are available to scripts run in this session.{p_end}"'
        noi di as text `"{phang}- If a script runs without error in this session, it indicates that all user-written commands required by that script are in the new PLUS folder {inp:`adopath'}.{p_end}"'
        noi di as text `"{phang}- Any other user who has access to the same folder {inp:`adopath'} (shared over Git, a syncing service, etc.) will use the exact same version of the commands installed at that location if they also use {inp:repado} to point to that folder..{p_end}"'
        noi di as text `"{phang}- In this session, both {help ssc install} and {help net install} will install new commands in the new PLUS folder {inp:`adopath'} instead of the previous location where PLUS was pointing.{p_end}"'
      }

      * Nostrict details
      else {
        noi di as text `"{phang}- User-written commands installed in the new PERSONAL folder {inp:`adopath'} are available to scripts run in this session{p_end}"'
        noi di as text `"{phang}- Stata's built-in commands in BASE and user-written commands installed in other adopaths, such as PLUS, are also available.{p_end}"'
        noi di as text `"{phang}- The exact version of user-written commands installed in the new PERSONAL folder {inp:`adopath'} will be used instead of any other version of a user-written command installed with the same name in the PLUS folder.{p_end}"'
        noi di as text `"{phang}- Any other user who has access to the same folder {inp:`adopath'} (shared over Git, a syncing service, etc.) will use the exact same version of the commands installed at that location if they also use {inp:repado} to point to that folder.{p_end}"'
        noi di as text `"{phang}- If a script runs without error in this session, then all user-written commands required in the script are either installed in the new PERSONAL folder {inp:`adopath'}, or in any of the other adopaths specified on this user's machine.{p_end}"'
        noi di as text `"{phang}- Both {help ssc install} and {help net install} will install commands in the PLUS folder as usual and not in the new PERSONAL folder {inp:`adopath'}.{p_end}"'
      }

      ****
      * Print outro
      noi di as text _n "{pstd}You can run {stata adopath} to see your current setting. These settings will be restored the next time you restart Stata.{p_end}"
    }

end

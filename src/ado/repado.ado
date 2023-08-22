cap program drop   repado
    program define repado

qui {
    syntax , adopath(string) mode(string) [lessverbose]

    /***************************************************************************
    ****************************************************************************
      TEST INPUT
    ****************************************************************************
    ***************************************************************************/

    * Test adopath input
    mata : st_numscalar("r(dirExist)", direxists("`adopath'"))
    if (`r(dirExist)' == 0) {
      noi di as error `"{phang}The folder path [`adopath'] in adopath(`adopath') does not exist.{p_end}"'
      error 99
    }

    * Test mode input
    if !inlist("`mode'","strict","nostrict") {
      noi di as error `"{phang}The mode {inp:`mode'} specified in {inp:mode(`mode')} is not valid. Only {inp:strict} and {inp:strict} is allowed. See helpfile {help repado} for more details.{p_end}"'
      error 99
    }

    /***************************************************************************
    ****************************************************************************
      ADO PATH SECTION
    ****************************************************************************
    ***************************************************************************/

    local ouptput "{inp:repado} has for this Stata session"

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

      noi di as text _n `"{pstd}`ouptput' set the PLUS adopath to {inp:`adopath'} and removed all adopaths other than PLUS and BASE.{p_end}"'

      if missing("`lessverbose'") {
        noi di as text _n "{pstd}This means that, until you restart your Stata session, the following is true:{p_end}"
        noi di as text `"{phang}- Only Stata's built-in commands in BASE and user-written commands installed in PLUS ({it:`adopath'}) are availible to scripts run in this session.{p_end}"'
        noi di as text `"{phang}- All user-written commands used in scripts that runs without error in this session are successfully installed in PLUS ({it:`adopath'}).{p_end}"'
        noi di as text `"{phang}- Any other user who runs this script using the same folder {it:`adopath'} (shared over Git, a syncing service etc.) will use the exact same version of commands installed at that location.{p_end}"'
        noi di as text `"{phang}- Both {help ssc install} and {help net install} will in this Stata session only install commands in PLUS ({it:`adopath'}).{p_end}"'
      }
    }

    * NOSTRICT MODE
    else {

      * Set PERSONAL path to ado path
      sysdir set  PERSONAL `"`adopath'"'
      adopath ++  PERSONAL
      adopath ++  BASE

      noi di as text _n `"{pstd}`ouptput' has set the PERSONAL adopath to {inp:`adopath'} and given it second priority only after BASE.{p_end}"'

      if missing("`lessverbose'") {
        noi di as text _n "{pstd}This means that, until you restart your Stata session, the following is true:{p_end}"
        noi di as text `"{phang}- User-written commands installed in PERSONAL ({it:`adopath'}) are made availible to scripts run in this session.{p_end}"'
        noi di as text `"{phang}- Stata's built-in commands in BASE and user-written commands installed in other adopaths, for example PLUS, are also availibe.{p_end}"'
        noi di as text `"{phang}- The exact version of user-written commands installed in PERSONAL ({it:`adopath'}) folder will be used instead of any other version of user-written command installed with the same name.{p_end}"'
        noi di as text `"{phang}- Any other user who runs this script using the same folder {it:`adopath'} (shared over Git, a syncing service etc.) will use the exact same version of commands installed at that location.{p_end}"'
        noi di as text `"{phang}- User-written commands used in scripts that runs without error in this session may be installed in PERSONAL ({it:`adopath'}) but they might also be installed in user specific adopaths.{p_end}"'
        noi di as text `"{phang}- Both {help ssc install} and {help net install} will install commands in PLUS as usual and not in PERSONAL ({it:`adopath'}).{p_end}"'
      }
    }

    if missing("`lessverbose'") noi di as text _n "{pstd}Run {stata adopath} to see your current setting. These settings will be restored next time you restart Stata.{p_end}"

}
end

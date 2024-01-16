
  local src "C:\Users\wb462869\github\repkit\src"
  local ado "`src'/ado"
  local out "`src'/tests/output/repado"

  do "`ado'/repkit.ado"
   
  * Test base case
  repkit
  
  * test beta output
  repkit "beta_output dimetest"

  * Test that invalid command is caught
  cap repkit "invalid subcommand"
  assert _rc == 99
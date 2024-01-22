
  * TODO: replace with reproot
  local repkit "C:/Users\wb462869\github\repkit\"

  * Load the commands
  do "`repkit'/src/ado/repkit.ado"

  * Test base case
  repkit

  * test beta output
  repkit "beta dimetest"

  * Test that invalid command is caught
  cap repkit "invalid subcommand"
  assert _rc == 99


	// Restart test file fresh
	clear all
	reproot, project("repkit") roots("clone") prefix("repkit_") 
	local testfldr "${repkit_clone}/src/tests"

  * Use the /dev-env folder as a dev environment
  cap mkdir    "`testfldr'/dev-env"
  repado using "`testfldr'/dev-env"

  * Make sure the version of repkit in the dev environment us up to date with all edits.
  cap net uninstall repkit
  net install repkit, from("${repkit_clone}/src") replace

  local out    "`testfldr'/repado/output"
  cap mkdir 	"`out'"
  cap mkdir 	"`out'/ado"

  ***********************************************
  **** Test all different mode settings

  repado , adopath("`out'/ado") mode("nostrict")
  return list
  assert "`r(repado_mode)'" == "nostrict"
  assert "`r(repado_path)'" == "`out'/ado"

  repado using "`out'/ado", mode("nostrict")
  assert "`r(repado_mode)'" == "nostrict"
  assert "`r(repado_path)'" == "`out'/ado"

  repado using "`out'/ado"
  assert "`r(repado_mode)'" == "strict"
  assert "`r(repado_path)'" == "`out'/ado"

  repado , adopath("`out'/ado") mode("strict")
  assert "`r(repado_mode)'" == "strict"
  assert "`r(repado_path)'" == "`out'/ado"

  repado , adopath("`out'/ado") nostrict
  assert "`r(repado_mode)'" == "nostrict"
  assert "`r(repado_path)'" == "`out'/ado"

  repado , adopath("`out'/ado")
  assert "`r(repado_mode)'" == "strict"
  assert "`r(repado_path)'" == "`out'/ado"

  repado using "`out'/ado", mode("nostrict")
  assert "`r(repado_mode)'" == "nostrict"
  assert "`r(repado_path)'" == "`out'/ado"

  repado using "`out'/ado", mode("strict")
  assert "`r(repado_mode)'" == "strict"
  assert "`r(repado_path)'" == "`out'/ado"

  repado using "`out'/ado",
  assert "`r(repado_mode)'" == "strict"
  assert "`r(repado_path)'" == "`out'/ado"

  repado using "`out'/ado", nostrict
  assert "`r(repado_mode)'" == "nostrict"
  assert "`r(repado_path)'" == "`out'/ado"


  // rest the ado-folder to the dev-env folder for next tests
  cap mkdir    "`testfldr'/dev-env"
  repado using "`testfldr'/dev-env"

  * TODO: replace with reproot
  local repkit "C:/Users\wb462869\github\repkit\"
  local out    "`repkit'/src/tests/repado/output"
  cap mkdir 	"`out'"
  cap mkdir 	"`out'/ado"

  * Load the commands
  do "`repkit'/src/ado/repado.ado"

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


  local src "C:\Users\wb462869\github\repkit\src"
  local ado "`src'/ado"
  local out "`src'/tests/output/repado"

  do "`ado'/repado.ado"

  //repado , adopath("`out'/ado") mode("nostrict")
  repado , adopath("`out'/ado") mode("strict")
  

//   repado , adopath("`out'/ado") mode("nostrict") lessverbose
//   repado , adopath("`out'/ado") mode("strict") lessverbose
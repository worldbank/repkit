    
  local adodown "C:\Users\wb462869\github\adodown"
  local repkit  "C:\Users\wb462869\github\repkit"


  do "C:\Users\wb462869\github\adodown\src\ado\ad_sthlp.ado"

  ad_sthlp , adf("`repkit'")
  
  //ad_command create reprun , adf("`repkit'") pkg(repkit)

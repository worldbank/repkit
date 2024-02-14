  * Kristoffer's root path
  if "`c(username)'" == "wb462869" {
      global clone "C:/Users/wb462869/github/"
  }
  * Fill in your root path here
  if "`c(username)'" == "bbdaniels" {
      global clone "/Users/bbdaniels/GitHub/"
  }
  
  local rk "${clone}/repkit"
  local ad_src "${clone}/adodown/src"

  
  cap net uninstall adodown
  net install adodown, from("`ad_src'") replace
 
  
  //ad_command create reproot , adf("`rk'") pkg(repkit) 
  
  ad_command create testasdsad , adf("`rk'") pkg(repkit) undoc

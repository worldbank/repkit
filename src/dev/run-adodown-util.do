  * Kristoffer's root path
  if lower("`c(username)'") == "wb462869" {
      global clone "C:/Users/wb462869/github/"
  }
  * Fill in your root path here
  if "`c(username)'" == "bbdaniels" {
      global clone "/Users/bbdaniels/GitHub/"
  }
  
   if "`c(username)'" == "ankritisingh" {
      global clone "/Users/ankritisingh/GitHub/"
  }
  
   if "`c(username)'" == "wb558768" {
      global clone "C:/Users/wb558768/Documents/GitHub/"
  }
  
  local rk "${clone}/repkit"
  
  //ad_sthlp , adfolder("`rk'") commands(repadolog)
  
  //ad_publish, adf("`rk'") undoc("reproot_parse reproot_search reprun_dataline") //ssczip
  
  ad_command create reproot_setup, adf("`rk'") pkg(repkit)

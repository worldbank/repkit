  * Kristoffer's root path
  if "`c(username)'" == "wb462869" {
      global clone "C:/Users/wb462869/github/repkit"
  }
  * Fill in your root path here
  if "`c(username)'" == "bbdaniels" {
      global clone "/Users/bbdaniels/GitHub/repkit"
  }

  do "https://raw.githubusercontent.com/lsms-worldbank/adodown/main/src/ado/ad_sthlp.ado"

  ad_sthlp , adf("${clone}")

  //ad_command create reprun_dataline , adf("`repkit'") pkg(repkit)

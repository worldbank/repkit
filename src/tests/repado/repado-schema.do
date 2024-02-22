

global repkit "/Users/bbdaniels/GitHub/repkit"

repado using "${repkit}/src/tests/dev-env"

copy "https://github.com/graykimbrough/uncluttered-stata-graphs/raw/master/schemes/scheme-uncluttered.scheme" ///
  "${repkit}/src/tests/plus-ado/scheme-uncluttered.scheme" , replace

  set scheme uncluttered , perm
  graph set eps fontface "Helvetica"

  sysuse auto, clear
  scatter price mpg



// End

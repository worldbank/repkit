  // Restart test file fresh
  clear all
  reproot, project("repkit") roots("clone") prefix("repkit_") 
  

  local rk "${repkit_clone}/repkit"
  
  //ad_sthlp , adfolder("${repkit_clone}") // commands(repadolog)
  
  //ad_update, adfolder("${repkit_clone}") pkgname("repkit") newpkg(minor)  
  
  ad_publish, adf("${repkit_clone}") undoc("reproot_parse reproot_search reprun_dataline reproot_setup_dlg_output") ssczip
  


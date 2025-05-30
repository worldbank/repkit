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

  ************************
    * Run tests
    
   pause off // set to pause on to run one at the time
   if 1 {
    * Test the command repadolog on four example files
    repadolog using "`testfldr'/repadolog/test-trk-files/test1", detail
    pause
    repadolog using "`testfldr'/repadolog/test-trk-files/test2", detail
    pause
    repadolog using "`testfldr'/repadolog/test-trk-files/test3", detail
    pause
    repadolog using "`testfldr'/repadolog/test-trk-files/test4", detail
 }
    * Test on the stata.trk in the current PLUS folder
    pause
    repadolog, detail save
    
    repadolog, savepath("`testfldr'/repadolog/testoutput.csv")
    
    
    // Add more tests here...

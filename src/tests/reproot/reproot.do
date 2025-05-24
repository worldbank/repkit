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

    * Test 1 - this should all work without error
    local prj1 "reproot-test-1"
    local pref "test1_"

    * Reset globals
    global `pref'clone ""
    global `pref'data ""

    noi di as text "{pstd}{red:Warning}: Make sure you have reproot set up such that it searches the subfolders of ${tests}/reproot{p_end}"
    
    * Run command
    reproot, project("`prj1'") roots("clone") prefix("`pref'") verbose
    reproot, project("`prj1'") roots("clone data") optroot("nonexist") prefix("`pref'")
    reproot, project("`prj1'") roots("clone data") prefix("`pref'")

    * Test 2 - this project has two clone roots
    local prj2 "reproot-test-2"
    local pref "test2_"

    * Reset globals
    global `pref'clone ""

    * Run command - expected error as two roots named clone exist
    cap reproot, project("`prj2'") roots("clone") prefix("`pref'")
    di _rc
    if !(_rc == 99) reproot, project("`prj2'") roots("clone") prefix("`pref'")
    
    
    * Run command - expected error as nonexist is set as required root
    cap reproot, project("`prj1'") roots("clone data nonexist") prefix("`pref'")
    di _rc
    if !(_rc == 99) reproot, project("`prj1'") roots("clone data nonexist") prefix("`pref'")
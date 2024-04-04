    * This test file use utilities from the repkit package - https://github.com/worldbank/repkit
    * Test if package is installed, otherwise throw error telling user to install repkit
    cap which repkit
    if _rc == 111 {
        di as error "{pstd}You need to have {cmd:repkit} installed to run this reproducibility package. Click {stata ssc install repkit, replace} to do so.{p_end}"
    }

    ************************
    * Set up root paths (if not already set), and set up dev environment

    * Always important to version control built-in Stata functions
    version 14.1

    * Use reproot to manage root path
    reproot, project("repkit") roots("clone data robsfolder") prefix("repkit_")

    * Use locals for all non-root paths
    local testfldr "${repkit_clone}/src/tests"

    * Use the /dev-env folder as a dev environment
    cap mkdir    "`testfldr'/dev-env"
    repado using "`testfldr'/dev-env"

    * Make sure repkit is installed also in the dev environment
    cap which repkit
    if _rc == 111 ssc install repkit

    * Make sure the version of repkit in the dev environment us up to date with all edits.
    cap net uninstall repkit
    net install repkit, from("${repkit_clone}/src") replace

    ************************
    * Run tests
    
    pause on

    * Test basic case of the command repadolog
    repadolog
    pause
    repadolog using "`testfldr'/repadolog/test-trk-files/test1"
    pause
    repadolog using "`testfldr'/repadolog/test-trk-files/test2"
    pause
    repadolog using "`testfldr'/repadolog/test-trk-files/test3"
    pause
    repadolog using "`testfldr'/repadolog/test-trk-files/test4"

    // Add more tests here...

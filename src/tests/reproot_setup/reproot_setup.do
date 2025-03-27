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
    reproot, project("repkit") roots("clone") prefix("repkit_")

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
    ************************
    * Run tests
	************************
	************************
	
	pause on

	************************
	************************
	* Test 1
	
    ************************
    * 1.1 Test dialog box when no file exists

    local test_homefolder "`testfldr'/reproot_setup/dialog_box"
	cap mkdir "`test_homefolder'"

    * Test basic case of the command reproot_setup
    cap rm "`test_homefolder'/reproot-env.yaml"
    reproot_setup, debug_home_location("`test_homefolder'")
	
	* Pause is needed as the dialog box does not halt the execution of this command
	pause
	
    ************************
    * 1.2 add a path that exists on all windows computers
	
    if c(os) == "Windows" {
        reproot_setup, searchpaths("C:\Users") debug_home_location("`test_homefolder'")
    }
    
    ************************
    * 1.3 Test dialog box when file exists

    * Test basic case of the command reproot_setup
    reproot_setup, debug_home_location("`test_homefolder'")
	
	* Pause is needed as the dialog box does not halt the execution of this command
	pause

.	************************
	************************
	* Test 2 - TODO

{smcl}
{* *! version 4.0 20250729}{...}
{hline}
{pstd}help file for {hi:reproot}{p_end}
{hline}

{title:Title}

{phang}{bf:reproot} - Command for managing root file paths.
{p_end}

{title:Syntax}

{phang}{bf:reproot} , {bf:{ul:p}roject}({it:string}) {bf:{ul:r}oots}({it:string}) [ {bf:{ul:optr}oots}({it:string}) {bf:{ul:pre}fix}({it:string}) {bf:clear} {bf:verbose}]
{p_end}

{synoptset 16}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:{ul:p}roject}({it:string})}The project name to search roots for{p_end}
{synopt: {bf:{ul:r}oots}({it:string})}Required root name(s) to search for{p_end}
{synopt: {bf:{ul:optr}oots}({it:string})}Optional root name(s) to also search for{p_end}
{synopt: {bf:{ul:pre}fix}({it:string})}Adds a project-specific prefix to root globals{p_end}
{synopt: {bf:clear}}Always search for roots even if already loaded{p_end}
{synopt: {bf:verbose}}More verbose output about roots found{p_end}
{synoptline}

{phang}{inp:reproot} is a framework designed to streamline file path management across teams, eliminating the need for project-specific setup by individual users. Once {inp:reproot} is configured on a user{c 39}s computer (see instructions below), root paths can be automatically loaded for all projects using {inp:reproot} on that machine. 
{p_end}

{phang}The framework operates by requiring the team to save a root file in each root folder essential to the project. These root folders could include the root of a Git repository, a shared folder on OneDrive/Dropbox, or a network drive where project files are stored. As long as the folder is accessible via the file system, a root file can be placed there. File paths to specific files can then be referenced in the code as relative paths from these roots.
{p_end}

{phang}To ensure efficient root file searches, users must configure a {inp:reproot-env} file. This file specifies the directories and subdirectories that {inp:reproot} should scan for root files, optimizing the search process to take less than a second. 
{p_end}

{phang}The {inp:reproot-env} file can be set up using the utility command {inp:reproot_setup}. Simply run this command in the Stata command window without any options and follow the instructions in the dialog box. 
{p_end}

{phang}While manual configuration of the {inp:reproot-env} file is possible, it is strongly recommended to use the utility command to ensure the file is correctly formatted and saved in the expected location. The file must be saved in the directory returned by the Stata command {inp:cd ~}. This ensures accessibility for all users without requiring additional root path setup. 
{p_end}

{phang}For detailed instructions on setting up the {inp:reproot-env} file, refer to this {browse "https://worldbank.github.io/repkit/articles/reproot-files.html":article}. The remainder of this help file focuses on using the {inp:reproot} command after the setup is complete. 
{p_end}

{title:Options}

{pstd}{bf:{ul:p}roject}({it:string}) specifies the name of the current project. When searching for root files, only root files associated with this project will be considered. Use a project name that is unique across all team members{c 39} computers.
{p_end}

{pstd}{bf:{ul:r}oots}({it:string}) defines the required roots for the project. For each root found, a global variable is created based on the root name, containing the file path to the root file{c 39}s location. Roots not listed in this option (or in {inp:optroots()}) will not have globals set, even if they are found. Unless the {bf:clear} option is used, existing globals are not overwritten. The command also verifies that a global exists for each specified root and that it is non-empty. 
{p_end}

{pstd}{bf:{ul:optr}oots}({it:string}) allows specifying optional roots. These are treated like the roots in {inp:roots()} but do not trigger an error if they are not found. 
{p_end}

{pstd}{bf:{ul:pre}fix}({it:string}) enables setting a project-specific prefix for global variables. This is recommended to avoid conflicts with globals from other projects. For example, using {bf:prefix({c 34}abc_{c 34})} will create globals like {inp:abc_data} and {inp:abc_code} instead of {inp:data} and {inp:code}. 
{p_end}

{pstd}{bf:clear} forces the command to overwrite existing globals that match the names of the roots specified in {bf:roots()}, with the {bf:prefix()} applied if used. By default, the command skips searching for roots that are already set.
{p_end}

{pstd}{bf:verbose} provides detailed output about the roots found during execution. This is useful for debugging and understanding which roots were successfully located.
{p_end}

{title:Examples}

{pstd}Below are examples of how to use the {inp:reproot} command in a do-file. To set up the required {inp:.yaml} files, use the utility command {inp:reproot_setup}. 
{p_end}

{dlgtab:Example 1}

{pstd}This example searches the paths specified in the {inp:reproot-env.yaml} file for root files associated with the project {inp:my_proj}. If found, it sets the globals {inp:data} and {inp:clone} to the file paths of the corresponding root files. 
{p_end}

{input}{space 8}reproot , project("my_proj") roots("data clone")
{text}
{title:Feedback, bug reports and contributions}

{pstd}Read more about these commands on {browse "https://github.com/worldbank/repkit":this repo} where this package is developed. Please provide any feedback by {browse "https://github.com/worldbank/repkit/issues":opening an issue}. PRs with suggestions for improvements are also greatly appreciated.
{p_end}

{title:Authors}

{pstd}LSMS Team, The World Bank lsms@worldbank.org  
DIME Analytics, The World Bank dimeanalytics@worldbank.org
{p_end}

{smcl}
{* *! version 1.2 20240222}{...}
{hline}
{pstd}help file for {hi:reproot}{p_end}
{hline}

{title:Title}

{phang}{bf:reproot} - Command for managing root file paths.
{p_end}

{title:Syntax}

{phang}{bf:reproot} , {bf:{ul:p}roject}({it:string}) {bf:{ul:r}oots}({it:string}) [ {bf:{ul:pre}fix}({it:string}) {bf:clear}]
{p_end}

{synoptset 15}{...}
{synopthdr:options}
{synoptline}
{synopt: {bf:{ul:p}roject}({it:string})}The project name to search roots for.{p_end}
{synopt: {bf:{ul:r}oots}({it:string})}The root name(s) to search for.{p_end}
{synopt: {bf:{ul:pre}fix}({it:string})}Adds a project-specific prefix to root globals.{p_end}
{synopt: {bf:clear}}Always search for roots even if already loaded.{p_end}
{synoptline}

{phang}{inp:reproot} is a framework for automatically handling file paths across 
teams without requiring project-specific setup from individual users.
Each user needs to set up {inp:reproot} once on their computer (see the next paragraph). 
Afterward, users can automatically load root paths with
no manual setup in all projects using {inp:reproot} on that computer. 
{p_end}

{phang}{inp:reproot} works by having the team save a root file in root folders required in the project. 
Such root folders could be the root of a Git clone folder,
the root of a OneDrive/DropBox folder where data is shared,
or the root of a project folder on a network drive where files are shared, etc.
As long as the folder is accessible from the file system,
a root can be placed in that folder.
File paths to specific files can then be expressed in the code as
relative paths from any of those roots.
{p_end}

{phang}To avoid searching the entire file system for roots (which would take too much time),
each user needs to configure a {inp:reproot-env} file. 
This file lists which folders and how many sub-folders of those folders
{inp:reproot} should search for root files. 
This setup should make the search take less than a second.
{p_end}

{phang}The {inp:reproot-env} file should be created in the folder that 
Stata outputs when running the code {inp:cd ~}. 
This location can be accessed by all users without having to set any root paths first.
{p_end}

{phang}Read more about setting up this file in
this {browse "https://worldbank.github.io/repkit/articles/reproot-files.html":article}.
The rest of this help file will focus on how to use this command once those files are set up.
{p_end}

{title:Options}

{pstd}{bf:project}({it:string}) indicates the name of the current project. When searching for root files, only root files for this project will be considered. Use a project name that will remain unique across all team members{c 39} computers.
{p_end}

{pstd}{bf:roots}({it:string}) indicates which roots are expected to be found for this project.
The command creates a global based on the root name of that root
if that root folder is found.
The content of the global will be the file path to the location of the root file.
This command does not set globals for roots not listed here,
even if such roots for this project were found.
Unless the {bf:clear} option is used,
the command does not overwrite any global that already existed before running the command.
Finally, the command tests that there is a global named after each root and
that all of them are non-empty.
{p_end}

{pstd}{bf:prefix}({it:string}) allows the user to set a project-specific global prefix.
This is strongly recommended to ensure that a global from another project
is not mistaken as a global for the current project.
Unless the {bf:clear} option is used,
a global already set with a common name, such as {inp:data} or {inp:code}, 
will be interpreted as a root global with that name for the current project.
The {bf:prefix()} option allows a project-specific prefix that is set to all globals.
So, if {bf:prefix({c 34}abc_{c 34})} is used, then the globals {inp:data} and {inp:code} 
will be set to {inp:abc_data} and {inp:abc_code}. 
{p_end}

{pstd}{bf:clear} overwrites globals that already exist with the name that {inp:reproot} would creaet. 
This is all the roots listed in {bf:roots()} with
the {bf:prefix()} prepended if that option is used.
The default behavior is to not search for roots that are already set up.
If all globals are already set, then the command does not execute the search for roots.
{p_end}

{title:Examples}

{pstd}These examples demonstrate how to include {inp:reproot} in the do-file. 
See this {browse "https://worldbank.github.io/repkit/articles/reproot-files.html":article}
for information on how to set up the {inp:.yaml} files this command needs to run. 
{p_end}

{dlgtab:Example 1.}

{pstd}In this example, the command searches the search paths indicated in
the {inp:reproot-env.yaml} file for root files for the project {inp:my_proj}. 
Then it sets the globals {inp:data} and {inp:clone} to the file location where 
root files with those names for this project are found.
{p_end}

{input}{space 8}reproot , project("my_proj") roots("data clone")
{text}
{title:Feedback, bug reports and contributions}

{pstd}Read more about these commands on {browse "https://github.com/worldbank/repkit":this repo} where this package is developed. Please provide any feedback by {browse "https://github.com/worldbank/repkit/issues":opening an issue}. PRs with suggestions for improvements are also greatly appreciated.
{p_end}

{title:Authors}

{pstd}LSMS Team, The World Bank lsms@worldbank.org
DIME Analytics, The World Bank dimenalytics@worldbank.org
{p_end}

{smcl}
{* *! version 4.0 20250729}{...}
{hline}
{pstd}help file for {hi:reproot_setup}{p_end}
{hline}

{title:Title}

{phang}{bf:reproot_setup} - This command sets up and modifies the settings file used in {inp:reproot} 
{p_end}

{title:Syntax}

{dlgtab:Normal usage:}

{phang}This mode opens the setup settings in a dialog box.  
It is not intended to be included in code used by others.  
This command is designed to be run interactively in Stata{c 39}s command window.
{p_end}

{phang}{bf:reproot_setup}
{p_end}

{dlgtab:Advanced usage:}

{phang}This mode bypasses the dialog box and allows the user to set up and modify the settings file programmatically.  
It is intended only for advanced use cases.
{p_end}

{phang}{bf:reproot_setup} , {bf:searchpaths}({it:string}) {bf:searchdepth}({it:integer}) {bf:skipdirs}({it:string})
{p_end}

{synoptset 20}{...}
{p2coldent:{it:options}}Description{p_end}
{synoptline}
{synopt: {bf:searchpaths}({it:string})}Root paths to be added to the settings file{p_end}
{synopt: {bf:searchdepth}({it:integer})}New depth of sub-folders to search{p_end}
{synopt: {bf:skipdirs}({it:string})}Folder names to ignore to be added to the settings file{p_end}
{synoptline}

{title:Description}

{pstd}This command helps set up the settings file used in the command {browse "https://worldbank.github.io/repkit/reference/reproot.html":reproot}.
{p_end}

{pstd}The settings file needs to be configured once per computer, specifying the locations on the file system where project folders are stored. This command simplifies that process.
{p_end}

{pstd}Additionally, this command can modify an existing settings file.
{p_end}

{title:Options}

{pstd}{bf:searchpaths}({it:string}) adds search paths to the settings file. If adding multiple paths, enclose each path in quotes and then enclose the full list as a compound string. Paths may include a path-specific search depth for each path.
{p_end}

{pstd}{bf:searchdepth}({it:integer}) sets a general search depth for paths that do not have a path-specific search depth.
{p_end}

{pstd}{bf:skipdirs}({it:string}) lists folder names that {inp:reproot} should ignore. Sub-folders within ignored folders will also be excluded. 
{p_end}

{title:Feedback, Bug Reports, and Contributions}

{pstd}Learn more about these commands on {browse "https://github.com/worldbank/repkit":this repository}, where this package is developed. Please provide feedback by {browse "https://github.com/worldbank/repkit/issues":opening an issue}. Pull requests with suggestions for improvements are also welcome.
{p_end}

{title:Authors}

{pstd}LSMS Team, The World Bank lsms@worldbank.org,
DIME Analytics, The World Bank dimeanalytics@worldbank.org
{p_end}

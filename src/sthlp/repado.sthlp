{smcl}
{* 01 Jan 1960}{...}
{hline}
{pstd}help file for {hi:repado}{p_end}
{hline}

{title:Title}

{phang}{bf:repado} - a command to handle ado-file dependencies
{p_end}

{title:Syntax}

{phang}{bf:repado} , {bf:adopath}({it:string}) {bf:mode}({it:string}) [{bf:lessverbose}]
{p_end}

{synoptset 15}{...}
{synopthdr:options}
{synoptline}
{synopt: adopath({it:string})}The file path to the ado-folder to use{p_end}
{synopt: mode({it:string})}Indicate {it:strict} or {it:nostrict} mode{p_end}
{synopt: lessverbose}Have less explanatory details in the output{p_end}
{synoptline}

{title:Description}

{pstd}This command is used to make sure that all users in a project use the exact same version of the commands the project code requires. This is done by creating a folder that we will call the ado-folder. This folder should be shared with the rest of the code of the project. This will work no matter how the files are shared. It can be using a syncing service like DropBox, a Git repository, a network drive, an external hard drive, a .zip folder etc.
{p_end}

{pstd}Using {inp:repado} in the {it:strict} mode, means that no other commands can be used apart from Stata{c 39}s built in commands and the commands in the shared ado-folder.
The commands that users have installed on their computers will not be available.
These settings are restored next time Stata is restarted.
{p_end}

{pstd}Using {inp:repado} in the {it:nostrict} mode, means that built-commands and the commands ado-folder are available to the script in addition to any command any user has installed on their computer. However, if a command is installed on a user{c 39}s computer that has the same name as a command in the ado-folder, then the exact version of the command in the ado-folder will be used.
These settings are restored next time Stata is restarted.
{p_end}

{pstd}While it might seem more convenient to use the {it:nostrict} as default as it makes more command available to the user, we strongly recommend that for all projects that are expected to be reproducible, you use the {it:strict} mode. This is because if you run a script without {c 34}{it:command ... is unrecognized}{c 34} errors in {it:strict} mode, then you are guaranteed that all commands that script requires are indeed in the ado-folder. If you share the ado-folder with the rest of your code, then you know anyone reproducing your code will run your code using the exact same version of your dependencies.
{p_end}

{title:Options}

{pstd}{bf:adopath}({it:string}) is used to specify where the ado-folder is located within the project folder. To make this reproducible across computers we recommend using a reproducible way of setting the root paths.
{p_end}

{pstd}{bf:mode}({it:string}) is used to specify which mode is used. It must be specified and can either be {it:strict} or {it:nostrict}. See the Description section above for a description of the differences between the two modes.
{p_end}

{pstd}{bf:lessverbose} is used to reduce the output that this command produces. The default without this option is that this command outputs how the adopaths has been modified and how that makes running your code different.
{p_end}

{title:Examples}

{dlgtab:Example 1}

{pstd}In this example the ado-folder is a folder called {inp:ado} in the folder that the global {inp:myproj} is pointing to.
{p_end}

{input}{space 8}repado , adopath({c 34}{c S|}{c -(}myproj{c )-}/ado{c 34}) mode({c 34}strict{c 34})
{text}
{title:Feedback, bug reports and contributions}

{pstd}Read more about the commands in this package at https://dime-worldbank.github.io/repkit.
{p_end}

{pstd}Please provide any feed back by opening and issue at https://github.com/dime-worldbank/repkit.
{p_end}

{pstd}PRs with suggestions for improvements are also greatly appreciated.
{p_end}

{title:Authors}

{pstd}DIME Analytics, The World Bank dimenalytics@worldbank.org
{p_end}

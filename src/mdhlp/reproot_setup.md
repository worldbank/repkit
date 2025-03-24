# Title

__reproot_setup__ - This command sets up and modifies the settings file used in `reproot`

# Syntax

_Normal usage:_

This mode opens the setup settings in a dialog box.
Do not include this command in code used by other.
This intended to be run interractively in Stata's command window.

__reproot_setup__ 

_Advanced usage:_

This mode bypasses the dialog box and allows the user to 
setup and modify the settings file programmatically.
This is only intended for advanced use cases.

__reproot_setup__ , __searchpaths__(_string_) __searchdepth__(_integer_) __skipdirs__(_string_)

| _options_ | Description |
|-----------|-------------|
| __searchpaths__(_string_) | Root paths to be added to the settings file |
| __searchdepth__(_integer_) | New depth of sub-folders to search |
| __skipdirs__(_string_) | Folder names to ignore to be added to the settings file |

# Description

This command helps setting up the settings file used in the command
[reproot](https://worldbank.github.io/repkit/reference/reproot.html).

The settings file needs to be set up once per computer, listing the location on the file system where project folders are located. This command simplifies that process.

This command can also modify an existing settings file.

# Options

__searchpaths__(_string_) is used to add search paths to the settings file.
If adding multiple paths, then enclose each path in quotes and then enclose the full list as a compounded link.
The paths may include a path specific search depth for this path.

__searchdepth__(_integer_) is used to set a general search depth for paths that does not have a path specific search depth.

__skipdirs__(_string_) is used to list folder names for folders that `reproot` should ignore when found. Sub-folders in ignored folders will also be ignored.

# Feedback, bug reports and contributions

Read more about these commands on [this repo](https://github.com/worldbank/repkit) where this package is developed. Please provide any feedback by [opening an issue](https://github.com/worldbank/repkit/issues). PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
DIME Analytics, The World Bank dimeanalytics@worldbank.org

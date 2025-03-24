# Title

__reproot_setup__ - This command sets up and modifies the settings file used in `reproot`

# Syntax

## Normal usage:

This mode opens the setup settings in a dialog box.  
It is not intended to be included in code used by others.  
This command is designed to be run interactively in Stata's command window.

__reproot_setup__

## Advanced usage:

This mode bypasses the dialog box and allows the user to set up and modify the settings file programmatically.  
It is intended only for advanced use cases.

__reproot_setup__ , __searchpaths__(_string_) __searchdepth__(_integer_) __skipdirs__(_string_)

| _options_ | Description |
|-----------|-------------|
| __searchpaths__(_string_) | Root paths to be added to the settings file |
| __searchdepth__(_integer_) | New depth of sub-folders to search |
| __skipdirs__(_string_) | Folder names to ignore to be added to the settings file |

# Description

This command helps set up the settings file used in the command [reproot](https://worldbank.github.io/repkit/reference/reproot.html).

The settings file needs to be configured once per computer, specifying the locations on the file system where project folders are stored. This command simplifies that process.

Additionally, this command can modify an existing settings file.

# Options

__searchpaths__(_string_) adds search paths to the settings file. If adding multiple paths, enclose each path in quotes and then enclose the full list as a compound string. Paths may include a path-specific search depth for each path.

__searchdepth__(_integer_) sets a general search depth for paths that do not have a path-specific search depth.

__skipdirs__(_string_) lists folder names that `reproot` should ignore. Sub-folders within ignored folders will also be excluded.

# Feedback, Bug Reports, and Contributions

Learn more about these commands on [this repository](https://github.com/worldbank/repkit), where this package is developed. Please provide feedback by [opening an issue](https://github.com/worldbank/repkit/issues). Pull requests with suggestions for improvements are also welcome.

# Authors

LSMS Team, The World Bank lsms@worldbank.org,
DIME Analytics, The World Bank dimeanalytics@worldbank.org

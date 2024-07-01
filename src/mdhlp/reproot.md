# Title

__reproot__ - Command for managing root file paths.

# Syntax

__reproot__ , __**p**roject__(_string_) __**r**oots__(_string_) [ __**optr**oots__(_string_) __**pre**fix__(_string_) __clear__ __verbose__]

| _options_ | Description |
|-------------|-----------------|
| __**p**roject__(_string_) | The project name to search roots for |
| __**r**oots__(_string_) | Required root name(s) to search for |
| __**optr**oots__(_string_) | Optional root name(s) to also search for |
| __**pre**fix__(_string_) | Adds a project-specific prefix to root globals |
| __clear__ | Always search for roots even if already loaded |
| __verbose__ | More verbose output about roots found |

`reproot` is a framework for automatically handling file paths across
teams without requiring project-specific setup from individual users.
Each user needs to set up `reproot` once on their computer (see the next paragraph).
Afterward, users can automatically load root paths with
no manual setup in all projects using `reproot` on that computer.

`reproot` works by having the team save a root file in root folders required in the project.
Such root folders could be the root of a Git clone folder,
the root of a OneDrive/DropBox folder where data is shared,
or the root of a project folder on a network drive where files are shared, etc.
As long as the folder is accessible from the file system,
a root can be placed in that folder.
File paths to specific files can then be expressed in the code as
relative paths from any of those roots.

To avoid searching the entire file system for roots (which would take too much time),
each user needs to configure a `reproot-env` file.
This file lists which folders and how many sub-folders of those folders
`reproot` should search for root files.
This setup should make the search take less than a second.

The `reproot-env` file should be created in the folder that
Stata outputs when running the code `cd ~`.
This location can be accessed by all users without having to set any root paths first.

Read more about setting up this file in
this [article](https://worldbank.github.io/repkit/articles/reproot-files.html).
The rest of this help file will focus on how to use this command once those files are set up.

# Options

__project__(_string_) indicates the name of the current project. When searching for root files, only root files for this project will be considered. Use a project name that will remain unique across all team members' computers.

__roots__(_string_) indicates which roots are expected to be found for this project.
The command creates a global based on the root name of that root
if that root folder is found.
The content of the global will be the file path to the location of the root file.
This command does not set globals for roots not listed in this option
(or in `optroots()` - see below),
even if such roots for this project were found.
Unless the __clear__ option is used,
the command does not overwrite any global that
already had content before running the command.
Finally, the command tests that there is a global named after each root and
that all of them are non-empty.

__optroots__(_string_) allows the users to set optional roots.
They will be treated the same way as the roots in `roots()` with
the one exception that no error is thrown if this root is not found.

__prefix__(_string_) allows the user to set a project-specific global prefix.
This is strongly recommended to ensure that a global from another project
is not mistaken as a global for the current project.
Unless the __clear__ option is used,
a global already set with a common name, such as `data` or `code`,
will be interpreted as a root global with that name for the current project.
The __prefix()__ option allows a project-specific prefix that is set to all globals.
So, if __prefix("abc_")__ is used, then the globals `data` and `code`
will be set to `abc_data` and `abc_code`.

__clear__ overwrites globals that already exist with the name that `reproot` would create.
This is all the roots listed in __roots()__ with
the __prefix()__ prepended if that option is used.
The default behavior is to not search for roots that are already set up.
If all globals are already set, then the command does not execute the search for roots.

__verbose__ makes the command output more information about what roots were found.
This option is helpful for debugging when trying to figure out what roots are found and not found.

# Examples

These examples demonstrate how to include `reproot` in the do-file.
See this [article](https://worldbank.github.io/repkit/articles/reproot-files.html)
for information on how to set up the `.yaml` files this command needs to run.

## Example 1.

In this example, the command searches the search paths indicated in
the `reproot-env.yaml` file for root files for the project `my_proj`.
Then it sets the globals `data` and `clone` to the file location where
root files with those names for this project are found.

```
reproot , project("my_proj") roots("data clone")
```

# Feedback, bug reports and contributions

Read more about these commands on [this repo](https://github.com/worldbank/repkit) where this package is developed. Please provide any feedback by [opening an issue](https://github.com/worldbank/repkit/issues). PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
DIME Analytics, The World Bank dimeanalytics@worldbank.org

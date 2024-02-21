# Title

__reproot__ - Command for root file path management.

# Syntax

__reproot__ , __**p**roject__(_string_) __**r**oots__(_string_) [ __**pre**fix__(_string_) __clear__]

| _options_ | Description |
|-----------|-------------|
| __**p**roject__(_string_) | The project name to search roots for |
| __**r**oots__(_string_) | The root name(s) to search for |
| __**pre**fix__(_string_) | Adds project-specific prefix to root globals |
| __**clear**__ | Always search for roots even if already loaded |


`reproot` is a framework for automatically handle file paths
across teams where users need to do no project specific setup.
Each user only need to set up `reproot` once on their computer
(see next paragraph).
After that, a user can automatically load root path with no manual set up,
in all projects that are using `reproot`.

`reproot` works by the team saving a root-file in root folders required in the project.
Such root folder could be the root of a Git clone folder,
the root of a OneDrive/DropBox folder where data is shared,
the root of a project folder of a network drive where files are shared, etc.
As long as the folder is accessible from the file-system,
a root can be placed in that folder.
File paths to specific files can then in the code be expressed as
relative paths from that any of those roots.

In order to not have to search the full file-system for roots
(that would take too long time)
each user needs to configure a `reproot-env` file.
This file lists which folders and how many sub-folders of those folders
`reproot` should search for root files.
This should make the search take less than a second.

The `reproot-env` file should be created in the folder that Stata outputs
when running the code `cd ~`.
This location can be accessed for all users without
having to set any root-paths first.

Read more about how to set up this file in this article (TODO TODO).

# Options

__**p**roject__(_string_) indicates the name of the current project.
When searching for root-files,
only root-files for this project will be considered.
Use a project name that will remain unique across all team members' computers.

__**r**oots__(_string_) indicates what
roots are expected to be found for this project.
The command creates a global with the same name
as the root if that root is found.
The content of the global will be the file path
to the location of the root file.
This command does not set globals for roots not listed here,
even if such roots for this project were found.
Unless the option `clear` is used, the command does not overwrite any global that already existed before running the command.
Finally, the command tests that there is a global named after each root
and that all of them are non-empty.

__**pre**fix__(_string_) allows the user to set a project-specific prefix.
This is strongly recommend to make sure that a global from another project
is not mistaken as a global for the current project.
Unless option __clear__ is used, a global already set with a common name,
such as `data` or `code`, will be interpreted as a root global with that name
for the current project. The `prefix()` option allows a project-specific prefix
that is set to all globals. So, if `prefix("abc_")` is used, then the globals
`data` and `code` will be set to `abc_data` and `abc_code`.

__clear__ overwrites globals that already exists
with the same name as the roots listed in `roots()`.
The default behavior to not search for roots that already are set up.
If all globals are already set then the command does not
execute the search for roots..

# Examples

These example is only for how to include `reproot` in the do-file. See this article TODO for information on how to set up the `.yaml` files this command needs to run.

## Example 1.

In this example, the command searches the search paths indicated in the `reproot-env.yaml` file for root files for the project `my_proj`. Then it sets the globals `data` and `clone` to the file location where root files with those names for this project are found.

```
reproot , project("my_proj") roots("data clone")
```

# Feedback, bug reports and contributions

Read more about the commands in this package at https://worldbank.github.io/repkit.

Please provide any feed back by opening and issue at https://github.com/worldbank/repkit.

PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org
DIME Analytics, The World Bank dimenalytics@worldbank.org

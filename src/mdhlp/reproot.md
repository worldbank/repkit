# Title

__reproot__ - Cammand for root file path management.

# Syntax

__reproot__ , __**p**roject__(_string_) __**r**oots__(_string_) [ __**pre**fix__(_string_) __clear__]

| _options_ | Description |
|-----------|-------------|
| __**p**roject__(_string_) | The name of the project to search roots for |
| __**r**oots__(_string_) | The name of the root(s) that are expected to be found |
| __**pre**fix__(_string_) | Adds project-specific prefix to root globals |
| __**clear**__ | Overwrite root globals already defined |


# Description

`reproot` is a framework for automatically handle file paths
across teams where users need to do no project specific setup.
Each user only need to set up `reproot` once on their computer,
and then the same setting can be used across all users.

The user needs to configure a `reproot-env` file where
they list what high level folders to search.
Examples of high-level folders are the Dropbox/OneDrive folder,
the Git folder with all clones, a network drive etc.
This setting is needed as it is too slow too search
all folders on the computer.
Read more about how to set up this file in this article (TODO TODO).

# Options
<!-- Longer description (paragraph length) of all options, their intended use case and best practices related to them. -->

__**p**roject__(_string_) is used to
indicate the project name to search for roots.
Since this command is intended to
be used for many projects on a computer,
each root file will have a project name value that
will identify for which project this root is relevant.

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

Read more about the commands in this package at https://dime-worldbank.github.io/repkit.

Please provide any feed back by opening and issue at https://github.com/dime-worldbank/repkit.

PRs with suggestions for improvements are also greatly appreciated.

# Authors

DIME Analytics, The World Bank dimenalytics@worldbank.org

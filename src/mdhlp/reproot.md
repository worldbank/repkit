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

`reproot` is a framework designed to streamline file path management across teams, eliminating the need for project-specific setup by individual users. Once `reproot` is configured on a user's computer (see instructions below), root paths can be automatically loaded for all projects using `reproot` on that machine.

The framework operates by requiring the team to save a root file in each root folder essential to the project. These root folders could include the root of a Git repository, a shared folder on OneDrive/Dropbox, or a network drive where project files are stored. As long as the folder is accessible via the file system, a root file can be placed there. File paths to specific files can then be referenced in the code as relative paths from these roots.

To ensure efficient root file searches, users must configure a `reproot-env` file. This file specifies the directories and subdirectories that `reproot` should scan for root files, optimizing the search process to take less than a second.

The `reproot-env` file can be set up using the utility command `reproot_setup`. Simply run this command in the Stata command window without any options and follow the instructions in the dialog box.

While manual configuration of the `reproot-env` file is possible, it is strongly recommended to use the utility command to ensure the file is correctly formatted and saved in the expected location. The file must be saved in the directory returned by the Stata command `cd ~`. This ensures accessibility for all users without requiring additional root path setup.

For detailed instructions on setting up the `reproot-env` file, refer to this [article](https://worldbank.github.io/repkit/articles/reproot-files.html). The remainder of this help file focuses on using the `reproot` command after the setup is complete.

# Options

__**p**roject__(_string_) specifies the name of the current project. When searching for root files, only root files associated with this project will be considered. Use a project name that is unique across all team members' computers.

__**r**oots__(_string_) defines the required roots for the project. For each root found, a global variable is created based on the root name, containing the file path to the root file's location. Roots not listed in this option (or in `optroots()`) will not have globals set, even if they are found. Unless the __clear__ option is used, existing globals are not overwritten. The command also verifies that a global exists for each specified root and that it is non-empty.

__**optr**oots__(_string_) allows specifying optional roots. These are treated like the roots in `roots()` but do not trigger an error if they are not found.

__**pre**fix__(_string_) enables setting a project-specific prefix for global variables. This is recommended to avoid conflicts with globals from other projects. For example, using __prefix("abc_")__ will create globals like `abc_data` and `abc_code` instead of `data` and `code`.

__clear__ forces the command to overwrite existing globals that match the names of the roots specified in __roots()__, with the __prefix()__ applied if used. By default, the command skips searching for roots that are already set.

__verbose__ provides detailed output about the roots found during execution. This is useful for debugging and understanding which roots were successfully located.

# Examples

Below are examples of how to use the `reproot` command in a do-file. For details on setting up the required `.yaml` files, refer to this [article](https://worldbank.github.io/repkit/articles/reproot-files.html).

## Example 1

This example searches the paths specified in the `reproot-env.yaml` file for root files associated with the project `my_proj`. If found, it sets the globals `data` and `clone` to the file paths of the corresponding root files.

```
reproot , project("my_proj") roots("data clone")
```

# Feedback, bug reports and contributions

Read more about these commands on [this repo](https://github.com/worldbank/repkit) where this package is developed. Please provide any feedback by [opening an issue](https://github.com/worldbank/repkit/issues). PRs with suggestions for improvements are also greatly appreciated.

# Authors

LSMS Team, The World Bank lsms@worldbank.org  
DIME Analytics, The World Bank dimeanalytics@worldbank.org

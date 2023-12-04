# Title

__repado__ - a command to handle ado-file dependencies

# Syntax

__repado__ , __adopath__(_string_) __mode__(_string_) [__lessverbose__]

| _options_ | Description |
|-----------|-------------|
| adopath(_string_) | The file path to the ado-folder to use   |
| mode(_string_)    | Indicate _strict_ or _nostrict_ mode |
| lessverbose       | Have less explanatory details in the output |

# Description

This command is used to make sure that all users in a project use the exact same version of the commands the project code requires. This is done by creating a folder that we will call the ado-folder. This folder should be shared with the rest of the code of the project. This will work no matter how the files are shared. It can be using a syncing service like DropBox, a Git repository, a network drive, an external hard drive, a .zip folder etc.

Using `repado` in the _strict_ mode, means that no other commands can be used apart from Stata's built in commands and the commands in the shared ado-folder.
The commands that users have installed on their computers will not be available.
These settings are restored next time Stata is restarted.

Using `repado` in the _nostrict_ mode, means that built-commands and the commands ado-folder are available to the script in addition to any command any user has installed on their computer. However, if a command is installed on a user's computer that has the same name as a command in the ado-folder, then the exact version of the command in the ado-folder will be used.
These settings are restored next time Stata is restarted.

While it might seem more convenient to use the _nostrict_ as default as it makes more command available to the user, we strongly recommend that for all projects that are expected to be reproducible, you use the _strict_ mode. This is because if you run a script without "_command ... is unrecognized_" errors in _strict_ mode, then you are guaranteed that all commands that script requires are indeed in the ado-folder. If you share the ado-folder with the rest of your code, then you know anyone reproducing your code will run your code using the exact same version of your dependencies.

# Options

__adopath__(_string_) is used to specify where the ado-folder is located within the project folder. To make this reproducible across computers we recommend using a reproducible way of setting the root paths.

__mode__(_string_) is used to specify which mode is used. It must be specified and can either be _strict_ or _nostrict_. See the Description section above for a description of the differences between the two modes.

__lessverbose__ is used to reduce the output that this command produces. The default without this option is that this command outputs how the adopaths has been modified and how that makes running your code different.

# Examples

## Example 1

In this example the ado-folder is a folder called `ado` in the folder that the global `myproj` is pointing to.

```
repado , adopath("${myproj}/ado") mode("strict")
```


# Feedback, bug reports and contributions

Read more about the commands in this package at https://dime-worldbank.github.io/repkit.

Please provide any feed back by opening and issue at https://github.com/dime-worldbank/repkit/issues.

PRs with suggestions for improvements are also greatly appreciated.

# Authors

DIME Analytics, The World Bank dimenalytics@worldbank.org

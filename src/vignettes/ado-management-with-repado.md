# Using `repado` for Ado-File Management

_This is a comprehensive guide on how to use `repado`. For a shorter and more technical syntax documentation, refer to the [helpfile](https://worldbank.github.io/repkit/reference/repado.html)._

## Background

To ensure long-term reproducibility of a research package, it is essential to share both the exact version of the project code and the exact versions of its dependencies. Dependencies refer to any commands used in the project code that are not defined within the code itself. This includes both Stata's built-in commands and community-contributed commands installed from external sources.

The code for these dependencies is just as important for reproducibility as the project code itself. Stata offers robust and user-friendly version control for its built-in commands, which will be briefly discussed in this article. However, the main focus here is on using `repado`, a command designed to enable long-term version control for community-contributed commands.

Both built-in and community-contributed commands are periodically updated to introduce improvements or fix bugs. While it is generally advisable to use the latest versions when starting a new project, research reproducibility—and, by extension, research transparency—requires that results can be reproduced exactly as originally generated, even if the original process was suboptimal or contained bugs.

### Version Control of Stata's Built-In Commands

Stata makes version control of its built-in commands straightforward through the `version` command. Built-in commands remain unchanged between Stata releases, and by specifying a version number, you ensure that commands like `regress`, `generate`, etc., behave exactly as they did in that release.

For example, placing the following at the top of your do-file ensures compatibility with Stata 14.1:

```stata
version 14.1
```

You can add this line to each script, but if your project uses a main script for reproducibility, it's sufficient to include it only at the top of that main script.

Note that you can only set the version to your current Stata release or an earlier one—not to a newer release. To use features from a newer version, you must purchase an upgrade to your Stata installation. While newer releases generally offer improvements, you should not set the version higher than the oldest Stata version used by any project collaborator. Sub-releases (e.g., 14.1) often include important fixes and are typically available for free to users of the main release. If a sub-release exists for your target version, it is advisable to specify it.

### Version Control of Community-Contributed Commands

Many other programming languages have version-controlled repositories for community-contributed commands (or libraries). For example, R uses CRAN, and Python uses sources like `pip` and `conda`. With these systems, it is sufficient to share the exact versions of code dependencies used in a reproducibility package to ensure it runs identically to how it did at the time of publication.

In Stata, however, the primary source for community-contributed commands is SSC (Statistical Software Components). While packages on SSC are versioned, SSC only provides access to the most recent version of each command, not to previous versions. Once a dependency from SSC used in a reproducibility package is updated, it is no longer possible to execute the code identically to how it was executed at the time of publication.

In practice, most updates to dependencies do not change results. However, some updates definitely will, or may even cause the reproducibility code to crash. In either case, the results in the reproducibility package can no longer be considered reproducible.

The `repado` command in the `repkit` package provides a Stata solution for long-term version-control of community-contributed commands. Since the main source of commands in Stata is not fully versioned, and commands are sometimes published from independent sources, this tool functions differently from common tools in R and Python.

## Using `repado`

### How Stata Installs Commands

When you install commands in Stata using `ssc install` or `net install`, Stata downloads the necessary files and saves them in a designated folder called the "PLUS folder". The PLUS folder is included in Stata's ado-paths. You can view your current ado-paths settings by running the `adopath` command in Stata. The output will look something like this:

```
  [1]  (BASE)      "C:\Program Files\Stata17\ado\base/"
  [2]  (SITE)      "C:\Program Files\Stata17\ado\site/"
  [3]              "."
  [4]  (PERSONAL)  "C:\Users\user123\ado\personal/"
  [5]  (PLUS)      "C:\Users\user123\ado\plus/"
  [6]  (OLDPLACE)  "c:\ado/"
```

Stata’s built-in commands are stored in the `BASE` folder. You should never modify this path or any of its contents. In addition to `BASE` and `PLUS`, there are other paths where Stata looks for commands when executing code. These are typically only used in special setups or exist for backward compatibility.

The order of this list matters. Stata first looks for a command in path `[1]`, and if the command is not found there, it moves to `[2]`, and so on. If no command is found in any of the listed paths, Stata throws an error stating that the command is unrecognized.

**Advanced notes:** Stata identifies commands solely by their names, not by their version, source, or author. For example, if you create a command named `regress` and save it in the PLUS folder, Stata will still use the built-in `regress` command from the `BASE` folder, since `BASE` has higher priority in the ado-paths. Similarly, if you create a command called `estout` (which is also the name of a widely used community-contributed command) and save it in your ado-paths, Stata will use your version as long as you do not have `estout` from SSC installed in a path with higher priority. If you run code from someone else who used `estout` from SSC, Stata will execute your version without any indication that it is a different command.
### Principle Behind `repado`

Stata allows users to modify the ado-paths, and `repado` leverages this to manage project-specific ado-folders. The team creates an ado-folder within the project directory and points `repado` to that folder. `repado` then sets the PLUS folder to the project ado-folder and removes all other ado-paths except for the BASE folder. Note that Stata restores the default ado-paths each time it is restarted, so changes made by `repado` are only temporary for the current Stata session.

While `repado` is configured to use the project ado-folder, commands installed via `ssc install` or `net install` will be placed in that folder. Anyone running project code that use `repado`  will only use the commands installed in the project ado-folder. It does not matter if another user has a different version of a command in their default PLUS folder or does not have it installed at all—the project will always use the version in the project ado-folder.

When sharing a reproducibility package, the project ado-folder should be distributed alongside the project code. This ensures that anyone reproducing the results—now or in the future—will use exactly the same versions (practically the same command files) as the original author. This approach works regardless of what version if the most recent at that time or any other changes to the original source of the command after the package is created.

**Important note:** When sharing third-party code as part of your reproducibility package, ensure you have the appropriate licensing rights. Commands installed from SSC are distributed under the GPL v3 (https://www.gnu.org/licenses/gpl-3.0.txt), which allows redistribution as part of a reproducibility package, provided the commands are not modified or relicensed. However, licensing terms may change, so it is your responsibility to verify your rights at the time of publication. If you have installed commands from sources other than SSC, check the applicable license. If in doubt, contact the author for permission.

## Setting Up the Project's Ado-Folder

Using `repado` is best done at the beginning of a project, but it can be implemented at any stage. The first step is to create the ado-folder.

We recommend creating the ado-folder inside the `code` directory, as this simplifies the process of eventually creating reproducibility package. Make it a separate folder within the `code` directory, and only modify the contents of the ado-folder using `ssc install` or `net install`. A suitable name for this folder is `ado`, but there is no technical requirement for the name—it can be named anything you prefer.

### A Simple Example

Consider a project with the following folder structure, which will be used throughout this guide:

```
myproject/
├─ code/
│  ├─ ado/
│  ├─ projectcode/
├─ data/
├─ outputs/
```

In this case, the basic use of `repado` is as follows:

```stata
* Set user root folder
global root "C:\Users\user123\github\myproject"

* Point repado to the ado-folder
repado using "${root}/code/ado"
```

If running the `adopath` command, the output will now be:

```
[1]  (BASE)      "C:\Program Files\Stata17\ado\base/"
[2]  (PLUS)      "C:\Users\user123\github\myproject/code/ado"
```

Note three key aspects after running `repado`:

1. The `BASE` ado-folder remains unchanged. Removing or modifying it would make Stata's built-in commands unavailable.
2. The `PLUS` folder now points to the project ado-folder. Regardless of how the project folder is shared (e.g., via Git/GitHub, cloud services like OneDrive or Dropbox, network drives, or even as a .zip archive), the exact command files will be available to anyone with access to the project folder.
3. All other ado-paths are removed, so commands installed by the user in other locations (which is uncommon) are no longer available. While this might seem inconvenient at first, it ensures that all commands needed for the project are contained within the project's ado-folder.

Remember that all settings discussed here are reset when Stata is restarted.

### Installing Commands in the Ado-Folder

As mentioned earlier, `ssc install` and `net install`  
place packages in the `PLUS` folder.  
Since the `PLUS` folder now points to the project ado-folder,  
any actions like `ssc install`, `ssc uninstall`, `ssc update`, and `adoupdate`  
will affect only the project ado-folder—provided Stata is not restarted.

In the `repado` workflow,  
you should avoid including `ssc install` or any other commands  
that install or update community-contributed commands within your do-files.  
Instead, these actions should be performed interactively  
through the _Command window_ in Stata’s main window.

Only one user needs to install each required command  
into the project ado-folder.  
After that, any other team member—or any future reproducer—  
can run the code using the version of the commands in the project ado-folder,  
without needing to install anything in their own Stata installations.

### When to Use `nostrict` Mode

`repado` offers a `nostrict` option, which is only intended to be used temporarily (if at all). In `nostrict` mode, the project ado-folder is set as the `PERSONAL` directory instead of `PLUS`. This gives `PERSONAL` the second-highest priority after `BASE`, meaning commands in the project ado-folder will take precedence over those in the user's default `PLUS` folder.

The `nostrict` mode is useful when users want access to commands already installed in their default `PLUS` folder and wish to test them within the project before deciding to install them in the project ado-folder. This can be especially helpful in large teams, where users may want to experiment before making a command available to everyone. It is also useful for using commands with meta-functionality (such as linters or tools for removing unused variables) that are not directly involved in generating project results.

However, we strongly recommend that, even if `nostrict` mode is used during some part of the development, the final reproducibility package should be created in `strict` mode (i.e., without the `nostrict` option). This ensures that all dependencies required by the project code are either built-in commands or are installed in the project ado-folder, guaranteeing full reproducibility.


## `repado` Cannot Install Itself

One limitation of `repado` is that, while it can ensure all of a project's code dependencies are provided, it cannot install itself. Even if `repado` is included in the project ado-folder, it must still be installed in each user's default `PLUS` folder to manage ado-folders in the first place.

Below, we suggest our recommended mitigation for this limitation, as well as an alternative approach to `repado` that achieves the same results but involves more lines of code and the project team needs to make sure it is set up correctly.
### Mitigation

A recommended mitigation is to include code that checks whether `repkit` is already installed in the user's PLUS folders. Do-files intended for broad distribution should never automatically install packages on a user's system, as this is generally considered poor practice. Instead, it is best to provide a clear and polite prompt instructing the user to install `repkit` if it is not already present. See the example below:

```stata
* Check if repkit is installed
cap which repkit
if _rc == 111 {
  di as error "{pstd}You need to have {cmd:repkit} installed to run this reproducibility package. Click {stata ssc install repkit} to do so.{p_end}"
}
```

### Alternative

As an alternative, the code underlying `repado` can be copied directly into the project's main do-file. This approach replicates the functionality of `repado` within the project code, achieving the same results without requiring users to have `repkit` installed. Since `repkit` is published under the MIT license, this is fully permitted.

The ado-folder must still be created as described above. Afterward, you can add that folder using one of the two examples below. Both examples assume the same folder structure as previously outlined.

**Example 1:** In this example, the same results are achieved as when using `repado` in strict mode. This version maintains only the project ado-folder and the `BASE` folder in the ado-paths. After running this code, you can install commands in the project ado-folder using `ssc install`, and only commands in the project ado-folder or built-in commands will be available to your project.

```stata
* Set user root folder
global root "C:\Users\user123\github\myproject"

* Set PLUS to the project ado-folder and add it to the ado-paths.
sysdir set PLUS "${root}/code/ado"
adopath ++ PLUS
adopath ++ BASE

* Remove all ado-paths with rank 3 or higher, leaving only BASE and PLUS.
local morepaths 1
while (`morepaths' == 1) {
  capture adopath - 3
  if _rc local morepaths 0
}
```
**Example 2:** This example is similar to the first, but does not use the `PLUS` folder. By avoiding `PLUS`, you eliminate the risk of users accidentally running `adoupdate` and updating all commands in the project ado-folder. This is especially helpful if you are not using Git, as such changes cannot be easily reverted. If you are using Git and tracking the ado-folder in your repository, this distinction is less critical.

```stata
* Set user root folder
global root "C:\Users\user123\github\myproject"

* Add the project ado-folder as an unnamed path, then add BASE.
* This results in BASE as the first path and the project ado-folder as the second.
adopath ++ "${root}/code/ado"
adopath ++ BASE

* Remove all ado-paths with rank 3 or higher, leaving only BASE and the project ado-folder.
local morepaths 1
while (`morepaths' == 1) {
  capture adopath - 3
  if _rc local morepaths 0
}
```

You can create a future-proof reproducibility package using `repado` or either of the two code examples above. The `repado` command is provided to simplify this process and abstract away technical details. Ultimately, it is up to each team to choose the method that best fits their workflow.

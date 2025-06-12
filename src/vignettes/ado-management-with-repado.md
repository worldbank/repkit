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
to those in R and Python.

However, the `repado` command in the `repkit` package
provides a Stata solution to the challenge of
version controlling community-contributed commands.

## Using `repado`

### The Best Practice `repado` Implements

In Stata, the best practice for
version controlling community-contributed commands is to first include
the ado-files of the commands used in the reproducibility package.
Then, your project code should code that ensures all users
utilize these files exclusively.
To achieve this, the project must incorporate some technical code
to set the "_ado-paths_".
The motivation behind `repado` is to encapsulate this technical code
within an accessible command,
making this feature available to a wider audience of Stata users.

You can view your default ado-paths by running
the `adopath` command within your Stata installation.
Simply enter `adopath` and press Enter,
 and you will see output in the following format.
 The exact paths will differ:

```
  [1]  (BASE)      "C:\Program Files\Stata17\ado\base/"
  [2]  (SITE)      "C:\Program Files\Stata17\ado\site/"
  [3]              "."
  [4]  (PERSONAL)  "C:\Users\user123\ado\personal/"
  [5]  (PLUS)      "C:\Users\user123\ado\plus/"
  [6]  (OLDPLACE)  "c:\ado/"
```

These locations are where your Stata installation
looks for commands, from top to bottom.
If Stata finds the command a user has used in the first folder,
it will use that command.
If it doesn't find a command with that name in the first folder,
it will continue to search in subsequent folders until
it finds a matching command or exhausts the list and throws an error,
such as `command [...] is unrecognized`.

Built-in commands are located in the `BASE` path, which should not be changed.
Commands installed via `ssc install` and `net install`
are placed in the `PLUS` folder.
However, as seen in the example,
the default `PLUS` location is specific to each user.
In practice, different users may have different versions of
the commands required for a project installed in their `PLUS` folder.

The objective of `repado` is to ensure that all users
employ commands installed in a shared location,
and this shared location is the exclusive source
for the project's command dependencies.

## Setting Up the Project's Ado-Folder

Using `repado` is best done at the beginning of the project,
but it can be implemented at any point of a project.
The first requirement is to create a folder referred to as the ado-folder.
A suitable name for this folder is `ado`, but it can be given any name.

The ado-folder should be created in a location distinct from the project code.
This separation is crucial to differentiate code owned by
the project team from code authored by others.
Commands from SSC can be republished as per the `GPL v3` license.
However, if commands are installed from other sources,
different licenses might apply.

### A Simple Example

Consider a project with the following folder structure.
This example project will be used throughout this guide.

```
myproject/
├─ code/
│  ├─ ado/
│  ├─ projectcode/
├─ data/
├─ outputs/
```

In this case, the basic use of `repado` would be as follows:

```stata
* Set user root folder
global root "C:\Users\user123\github\myproject"

* Point repado to the ado-folder
repado, adopath("${root}/code/ado") mode(strict)
```

Upon re-running the `adopath` command, the output will now be:

```
[1]  (BASE)      "C:\Program Files\Stata17\ado\base/"
[2]  (PLUS)      "C:\Users\user123\github\myproject/code/ado"
```

It's important to note three key aspects after running `repado`.

First, the `BASE` folder remains intact.
Removing it would render Stata's built-in commands unavailable.

Second, the `PLUS` folder now points to the ado-folder
shared within the project.
The project folder can be shared via various means,
such as Git repositories, syncing services (OneDrive, Dropbox),
network drives, or even in a .zip archive
(common for reproducibility packages but less so for collaborative sharing).

Third, all other paths are removed,
meaning commands installed by the user in other locations
are no longer available.
Although this might initially seem inconvenient,
it serves as a useful tool to ensure that all commands
needed for the project are contained within the project's ado-folder.
Later, we will explore how this can be relaxed using the `mode()` option.
However, for teams aiming to guarantee project reproducibility,
it's advisable to use `mode(strict)` as the default.

Remember that all settings discussed here are reset when Stata is restarted.

### Installing Commands in the Ado-Folder

The project now has a project ado-folder and
a mechanism to ensure that all users employ commands installed in that folder.
However, no commands have been installed in the folder yet.
An easy way to do so is facilitated by how `repado` changed the ado-paths.

As mentioned earlier, `ssc install` and `net install`
place packages in the `PLUS` folder.
Since the `PLUS` folder now points to the project ado-folder,
any actions like `ssc install`, `ssc update`, and `adoupdate`
will affect only the project ado-folder, provided Stata is not restarted.

In the `repado` workflow,
you should avoid including `ssc install` or any other commands
that install or update community-contributed commands within your do-file.
Instead, this should be done interactively through
the "Command" window in Stata's main interface.
Only one user needs to install each required command
into the project ado-folder.
Subsequently, any other team member or future project reproducer
will use the version of the commands in the project ado-folder
without needing to install anything in their Stata installations.

Using the strict mode (`mode(strict)`) ensures that
the project code exclusively source commands from the project ado-folder,
guaranteeing uniformity in command versions for all current and future users.

### When Not to Use Strict Mode

In short, strict mode (`mode(strict)`) should be used almost always
and especially for reproducibility packages.
However, the no-strict mode (`mode(nostrict)`) exists to enable a user
to utilize a command already installed on their computer
before deciding to install it in the project ado-folder.
In no-strict mode, the project ado-folder path is
set to `PERSONAL` instead of `PLUS`.
`PERSONAL` is given the second highest priority after `BASE` in this mode,
meaning `PERSONAL` is given higher priority compared to `PLUS`.
Thus, a command installed in the project ado-folder
will be used over a command with the same name
(typically the same command but a different version)
in the user's default `PLUS` folder.

It's important to note that the no-strict mode workflow
is not guaranteed to be reproducible and
is only intended to be used temporarily.

## Drawbacks of `repado`

Once `repado` is set up and utilized,
there are no drawbacks from a reproducibility perspective.
It aligns with all the gold standards for future-proofing
the reproducibility of a reproducibility package.
However, there are two aspects that users of `repado` should consider.

### Licenses and Republishing of Commands

The first aspect pertains to licenses and
whether republishing of commands is allowed.
This is particularly relevant to reproducibility packages published publicly.
Commands from SSC are published under the `GPL v3`,
where republishing is permitted.
However, it's important to review the `GPL v3` for
specific requirements regarding how to republish the commands.
If other sources are used,
the project team will need to ascertain whether they are allowed to
publish a reproducibility package containing these commands.

### `repado` Cannot Install Itself

The other aspect to consider is that,
even after `repado` is set up in the project code,
each user needs to install `repkit` on their own computers
before the `repado` functionality will work on their computers.
This is the case even if `repkit` is installed in the project ado-folder.
Below, we suggest our recommended mitigation for this aspect,
as well as an alternative approach that
achieves the same results but involves more lines of code.

We will never add any commands to the `repkit` package
that are used for analysis or generate outcomes in a project.
This is why it is acceptable to depend on users installing `repkit`
before reproducing the results of a project.

Initially, this functionality was implemented as
a feature in the `ieboilstart` command in the `ietoolkit` package.
However, it was later realized that this was not a good idea,
as other commands in `ietoolkit` are used to generate results.
To version control all dependencies used for generating results,
the functionality now in `repado` cannot
share a package with any command used for that purpose.

### Mitigation

One mitigation to this is to include code that tests
if `repkit` is already installed on a user's computer.
A do-file intended for potential wide distribution
should never include code that automatically
installs anything on other users' computers.
That practice is inconsiderate and is generally considered bad practice.
However, it is a good practice to include a polite prompt
instructing the user to install `repkit` in order to run the code
if the package is not already installed.
See the example below:

```stata
* Make sure that repkit is installed
* If not, prompt user to install it from ssc
cap which repkit  
if _rc == 111 {
    di as error "{pstd}You need to have {cmd:repkit} installed to run this reproducibility package. Click {stata ssc install repkit} to do so.{p_end}"
}
```

### Alternative

As an alternative, the code from `repado` can be copied
into the project's main file.
`repkit` is published using the MIT license where this is perfectly allowed.
The ado-folder must still be created in the same way as described above.
Afterward, you can add that folder using one of the two examples below.
Both examples assume the same folder structure as previously outlined.

Before using any of these examples, ensure they are utilizing
the most recent version of the code used in the `repado` command
[here](https://github.com/worldbank/repkit/blob/main/src/ado/repado.ado).

**Example 1:** In this example, the same results are achieved
as when using `repado` in strict mode.
This version maintains only the project ado-folder
and the `BASE` folder in the ado-paths.
After running this code, you can still install commands
in the project ado-folder using `ssc install` and
use other commands that use the `PLUS` folder.

```stata
* Set user root folder
global root "C:\Users\user123\github\myproject"

* Set PLUS to adopath and list it first, then list BASE first.
* This means that BASE is first and PLUS is second.
sysdir set  PLUS "${root}/code/ado"
adopath ++  PLUS
adopath ++  BASE

* Keep removing adopaths with rank 3 until only BASE and PLUS,
* that has rank 1 and 2, are left in the adopaths
local morepaths 1
while (`morepaths' == 1) {
  capture adopath - 3
  if _rc local morepaths 0
}
```

**Example 2:** This example is identical to the first one,
with the exception that `PLUS` is not used.
This eliminates the risk of any user accidentally using
`adoupdate` to update all commands in the project ado-folder.
This aspect is especially useful when not using Git,
as mistakes like this cannot be easily reverted.
If Git is employed, and all content in the ado-folder
is tracked in the repository, this difference becomes less significant.

```stata
* Set user root folder
global root "C:\Users\user123\github\myproject"

* Set the project adopath as an unnamed path and list it first, then list BASE first.
* This means that BASE is first and PLUS is second.
adopath ++  "${root}/code/ado"
adopath ++  BASE

* Keep removing adopaths with rank 3 until only BASE and the project ado-folder,
* that has rank 1 and 2, are left in the adopaths
local morepaths 1
while (`morepaths' == 1) {
  capture adopath - 3
  if _rc local morepaths 0
}
```

It is equally possible to create a future-proof reproducibility package
using `repado` or either of the two examples provided here.
We have offered `repado` in the form of a command to make this process easier
and to abstract away technical code.
In the end, it is up to each team to decide which method to employ.

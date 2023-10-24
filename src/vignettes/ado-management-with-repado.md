# Using `repado` for Ado-File Management

_This is a comprehensive guide on how to use `repado`. For a shorter and more technical syntax documentation, refer to the [helpfile](https://dime-worldbank.github.io/repkit/reference/repado.html)._

## Background

To create a fully reproducible reproducibility package for a research project,
you need the following four elements:

1. The exact same data
2. The exact same project code
3. The exact same project code dependencies
4. The exact same computation environment

Sharing the same project data and code is straightforward and
is typically done by publishing the data and code to an archive.
Using the same computation environment is more complicated
and often involves using software like Docker.
However, this article will focus on how to
share the same project code dependencies and will primarily cover Stata.

### Reproducible Code Dependencies

Writing code is about creating precise instructions that a computer can follow.
This precision is crucial for ensuring reproducibility in research.
The code used in a project includes both the code written by the team
and the code within all the commands that the project code relies on.
Users running different versions of these commands
may obtain different results, even if they use the same project code and data.
Therefore, it's essential to establish a method for
version controlling all the code (including the code for any commands used)
that the project code depends on,
which is commonly referred to as code dependencies.

All programming languages have two types of code dependencies:
built-in commands and community-contributed commands.
It's equally important to version control both of these.

### Version Control of Built-In Commands

The most effective way to version control built-in commands is to
run the exact same version of the programming software.
This is typically more straightforward in open-source software,
as older software versions can be easily installed.
In Stata, while running the exact same version is ideal,
built-in commands can be version controlled using the `version` command.
The `version` command allows Stata users to utilize built-in commands
from any version equal to or older than the version they have installed.

This command can be added to the top of each script,
as it doesn't consume much time to execute.
However, if the project uses a main script for one-click reproducibility,
it's sufficient to place this line at the top of the main script.
See example below.
Be sure to replace `12.1` with the version the project is targeting.
Unless a specific new feature is required,
it's advisable not to choose the most recent version to ensure
reproducibility for as many users as possible.

```
  version 12.1
```

### Version Control of Community-Contributed Commands

In most other programming languages, there are version-controlled archives for
community-contributed commands (or libraries).
For R, there is CRAN, and for Python, there are archives like `pip` and `conda`.
Tools for these archives make older versions of commands available,
and in these languages, these tools can be used to specify
the required commands and their exact versions when reproducing a project.
When a user reproduces such a project,
these tools install the exact version of these dependencies.

In Stata, the primary archive for community-contributed commands is
SSC (Statistical Software Components).
SSC is not version controlled,
and only the most recent version of a command is made available.
For this reason, there is no tool in Stata that functions similarly
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

```
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
[here](https://github.com/dime-worldbank/repkit/blob/main/src/ado/repado.ado).

**Example 1:** In this example, the same results are achieved
as when using `repado` in strict mode.
This version maintains only the project ado-folder
and the `BASE` folder in the ado-paths.
After running this code, you can still install commands
in the project ado-folder using `ssc install` and
use other commands that use the `PLUS` folder.

```
* Set user root folder
global root "C:\Users\user123\github\myproject"

* Set PLUS to adopath and list it first, then list BASE first.
* This means that BASE is first and PLUS is second.
sysdir set  PLUS "${root}/code/ado"'
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

```
* Set user root folder
global root "C:\Users\user123\github\myproject"

* Set PLUS to adopath and list it first, then list BASE first.
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

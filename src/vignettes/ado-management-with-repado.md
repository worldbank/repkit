# Using `repado` for ado-file management

_This is a long format guide how to use `repado`, see the [helpfile](https://dime-worldbank.github.io/repkit/reference/repado.html) for a shorter and more technical syntax documentation._

---

To make an reproducibility package for a research project fully reproducible, these four things are needed:

1. The exact same data
1. The exact same project code
1. The exact same project code dependencies
1. The exact same computation environment

Sharing the same project data and code is straightforward.
Typically done by publishing data and code to an archive.
Using the same computation environment is more complicated and
tend to involve using software like Docker.
However, this article will only cover how to
share the same project code dependencies in Stata.

## Reproducible code dependencies

Writing code is writing a set of very exact instructions a computer can follow.
This is why writing code is essential for reproducible research.
However, the code used in a project is both the code written by the team
as well as the code in all commands that code uses.
Users using different versions of commands can get different results
even if they are using the same project code and data.
It is therefore important to make sure that a reproducible research project
has a method to version control all code the project code depends on.
This code is what is called the code dependencies.

All programming languages have two types of code dependencies.
Built-in commands and community-contributed commands.
It is equally important to version control both of those.

### Version control built-in commands

The best way to version control built-in commands is to run
the exact same version of a programming software.
This tend to be easier in open-source software where
older versions of software can easily be installed.
In Stata, while running the exact same version of Stata is always best,
built-in commands can be version controlled using the command `version`.
The command `version` allows a Stata user to use
built-in commands from any version equal or older than
the version that user has installed.

This command can be put at the top of each script as it takes no time to run.
However, if the project use a main-script for one-click reproducibility,
then it is sufficient to put this line at the top of the main-script.
Obviously, replace `12.1` with whatever version the project is targeting.
Unless a specific new feature is required,
it is advisable to not pick the most recent version in order to
make the project reproducible for as many users as possible.

```
  version 12.1
```

### Version control community-contributed commands

Most other languages has version controlled archives
for community-contributed commands (or libraries).
For R there is CRAN and for Python there is `pip` and `conda`.
Since these libraries make old versions of commands available
there are in these languages tools for how to indicate what
commands and what exact versions of those command a project requires.
When a user reproducing a project using one of these tools,
that user can use that tool to get
the exact same versions of all commands from the central archive.

The main archive of community-contributed commands in Stata is SSC.
SSC is not version controlled.
The only version made available is the most recent version of the command.
For this reason there is tool in Stata that work the same way as those tools in R and Python.

However, the `repado` command in the `repkit` package provide a tool
that in a different way solves the requirement to
version control community-contributed commands.

## Using `repado`

### The best practice `repado` is automating

The best-practice in Stata to version control community-contributed commands
is to include the ado-files of the commands used in the reproducibility package,
and then include code that makes all users only use those files.
To accomplish this, the project needs to include some technical code
(to set the "_ado-paths_") and get the details right.
The motivation behind `repado` is to put this technical code
in an easy-to-use command to make this feature accessible to more Stata users.

You can see your default ado-paths by running the command `adopath`
in your Stata installation.
Just enter `adopath` and hit enter and you will see an output on this format.
The exact paths will differ.

```
  [1]  (BASE)      "C:\Program Files\Stata17\ado\base/"
  [2]  (SITE)      "C:\Program Files\Stata17\ado\site/"
  [3]              "."
  [4]  (PERSONAL)  "C:\Users\user123\ado\personal/"
  [5]  (PLUS)      "C:\Users\user123\ado\plus/"
  [6]  (OLDPLACE)  "c:\ado/"
```

These are all the locations your Stata installation will look for commands.
Stata will look in the order top to down.
If Stata finds the command a user has used in the first folder, Stata will use that command. If it does not find a command with that name in the first folder it will repeat this on the second folder.
This continue until Stata has found a command with that name, or the list is exhausted and Stata throws the error `command [...] is unrecognized`

Built-in commands are found in the `BASE` path.
We should not change that path.
`ssc install` and `net install` installs commands in `PLUS`.
But as can be seen, the default location where commands are installed
is a location specific to that user.
It is very possible (actually almost always the case)
that different users have different versions of the command
required for a project installed in this folder.

The goal of `repado` is that all users should use commands installed in a shared location, and that this shared location is the only location the project code can use commands from.

## Set up the project ado-folder

Using `repado` is best done from the very beginning of the project,
but it can also be done at the end of a project.
The first requirement is to create a folder.
This folder will be referred to as the ado-folder
and a good name for this folder is `ado`, but it can be called anything.

The ado-folder should be created in a location
that is separate from the project code.
This is important to be able to distinguish which code is
owned by the project team and which code is authored by someone else.
Commands from SSC are allowed to be republished
according to the `GPL v3` license.
If commands are installed from elsewhere, then other licenses might apply.

### Simple example

Let's assume a project has this folder structure:

```
myproject/
├─ code/
│  ├─ ado/
│  ├─ projectcode/
├─ data/
├─ outputs/
```

Then the base case of `repado` would be:

```
* Set user root folder
global root "C:\Users\user123\github\myproject"

* Point repado to the ado-folder
repado, adopath("${root}/code/ado") mode(strict)
```

If then running `adopath` command again, the output is:

```
[1]  (BASE)      "C:\Program Files\Stata17\ado\base/"
[2]  (PLUS)      "C:\Users\user123\github\myproject/code/ado"
```

All settings `repado` has the same scope as a global.
This means that any settings it changes are restored when Stata is re-started.
Let's point out three important things after `repado` ran.

First, note that the `BASE` folder is still there.
Without it, Stata's built-in commands would no longer be available.

Second, note that the `PLUS` folder is now pointing to
a ado-folder shared in the project.
In this case, the project folder is shared over a Git repository,
but the project folder can be shared in any other way.
Such as syncing services (OneDrive, Dropbox etc.), network drives etc.
It can also be shared in a .zip archive.
That is not commonly done for collaborative sharing,
but is commonly used when sharing reproducibility packages.

Third, note that all other paths are removed.
This means that any commands the user had installed on their computer
in other location are no longer available.
While this might first seem like a inconvenience,
it on the contrary a convenience tool to help project make sure that all commands a project needs are indeed in the project ado-folder.
We will soon show how this can be relaxed using the `mode()` option.
However, if the team wants to make sure their project is reproducible,
they should use `mode(strict)` as the default.

Remember that all settings discussed here are restored when Stata is restarted.

### Installing commands in the ado-folder

The project now has a project ado-folder and
a way to make sure that all users only use commands installed in that folder.
However, no commands has yet been installed in that folder.
The way `repado` changed your settings makes this easy.

As already said above,
`ssc install` and `net install` installs packages in the `PLUS` folder,
and the `PLUS` folder is now pointing to the project ado-folder.
This means, until you restart Stata,
`ssc install`, `ssc update`,
`adoupdate` will only affect the project ado-folder.

You should in the `repado` workflow never have `ssc install` or any other command that installs or updates community-contributed commands in your do-file.
In this workflow it should only be done interactively in the "Command" window in the main interface of Stata.
Only one user needs to do install each command needed into the project ado-folder.
Then any other team member or anyone reproducing the project in the future will
use the version of the commands in the project ado-folder.

Using the strict mode (`mode(strict)`) guarantees that all commands
used by the project are indeed in the project ado-folder.
This way, it is guaranteed that any user in the future will use
exactly the same version of these community contributed commands in the future.

### When to not use strict mode

Short answer: rarely, and never for a reproducibility package.
However, the no-strict mode (`mode(nostrict)`) exists to
allow a user to use a command installed on their computer
before deciding to install it in the project ado-folder.
In no-strict mode the project ado-folder path is set to
`PERSONAL` instead of `PLUS`.
`PERSONAL` is given higher priority (second only to `BASE`) than `PLUS`.
So a command installed in the project ado-folder will be used
before a command with the same name
(typically the same command but a different version)
in the users default `PLUS` folder.

The no-strict mode workflow is not guaranteed to be reproducible,
and that is why it should only be used temporarily.

## Drawbacks of `repado`

Once `repado` is set up and used there are no drawbacks
from a reproducibility perspective.
This stratifies all gold-standards we have identified for
future-proofing the reproducibility of a reproducibility package.
However, there are two aspects users of `repado` should consider.

### Licenses and re-publishing commands

The first aspect is licenses and if republishing of commands are allowed.
This applies to reproducibility packages published publicly.
Commands from SSC are published under the `GPL v3`
where re-publication is allowed.
However, read the `GPL v3` for details on
the requirement forhow to republish the commands.
If other sources are used,
then the team will have to find out themselves if they are allowed
to publish a reproducibility package with these commands.

### `repado` cannot install itself

The other aspect is that even if `repado` is set up and
`repkit` is installed in the project ado-folder,
each user needs to install `repkit` on their own computers
for `repado` to work before it is set up.
Below we suggest our recommended mitigation of this aspect,
as well as an alternative that archive
the same results but with more lines of code.

We will never add any commands to the `repkit` package that
is used for analysis or in any other way generate outcomes in a project.
This is why it is ok to rely on users installing `repkit` before reproducing
results of a project.
Initially this functionality was implemented as a feature in the `ieboilstart`
command in the `ietoolkit` package.
We soon realized that was a bad idea as other commands in `ietoolkit`
is used to generate results.
To version control all dependencies used to generate results,
the functionality now in `repado` cannot share
package as any command used for that.

### Mitigation

A do-file intended for potential wide distribution should never include code that automatically installs anything on other users computers.
That is simply inconsiderate and bad practice.
However, it is a good practice to include a polite prompt telling a user that in order to run the code `repkit` needs to be installed. See the example below.

```
* Make sure that repkit is installed
* If not, prompt user to install it from ssc
cap which repkit  
if _rc == 111 {
    di as error "{pstd}You need to have {cmd:repkit} installed to run this reproducibility package. Click {stata ssc install repkit} to do so.{p_end}"
}
```

### Alternative

As an alternative, the code from `repado` can be
copied into the main file of the project.
The ado-folder must still be created the same way as described above.
Once that is done, you can add that folder using one of these two examples.
Both these examples assume the same folder structure as above.

Before using this code, check that it is indeed using
the most recent version of the code used in the command `repado`
[here](https://github.com/dime-worldbank/repkit/blob/main/src/ado/repado.ado).

**Example 1.** In this example, the exact same results is achieved
as when using `repado` in strict mode.
For example, no other ado-paths are kept apart from `BASE` and
after running this code you can still install commands
in the project ado-folder using `ssc install` etc.

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

**Example 2.** In this example, it is still only
the project ado-folder and the `BASE` folder that is left in the ado-paths.
So far it is identical to `repado` in strict mode.
But the difference is that `PLUS` is not used
so there is no risk that any user accidentally use `adoupdate`
to update all commands in the project ado-folder.
Since SSC is not versioned (the original motivation for `repado`)
it would be difficult to restore exact versions of commands
if they were overwritten in an `adoupdate`.
This aspect is especially useful if not using git
where a mistake like this cannot be easily reverted.
If git is used and all content in the ado-folder is tracked in the repository,
then this makes little difference.

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

It is equally possible to create a future proof reproducibility package
using `repado` or either of the two examples here.
We have provided `repado` in the form of a command to make this easier
and to abstract away technical code,
but in the end it is up to each team which method to use.

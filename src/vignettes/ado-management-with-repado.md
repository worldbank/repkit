# Using `repado` for ado-file management

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

The best-practice in Stata to version control community-contributed commands
is to include the ado-files of the commands used in the reproducibility package,
and then include code that makes all users only use those files.
To accomplish this, the project needs to include some technical code
(to set the "_adopaths_") and get the details right.
The motivation behind `repado` is to put this technical code
in an easy-to-use command to make this feature accessible to more Stata users.

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


### Basic usage

Let's assume a project has this folder structure:

```
myproject/
├─ code/
│  ├─ ado/
│  ├─ projectcode/
├─ data/
├─ outputs/
```

Then the base case of `repado` would be

```
* Set user root folder
global root "C:\Users\user123\github\myproject"

* Point repado to the ado-folder
repado, adopath("${root}/code/ado") mode(strict)
```



### Installing command


## Drawbacks of `repado`

In order for `repado` work each user must have the package `repkit` installed.
In some always

### Mitigation

### Alternative

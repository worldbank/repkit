# reproot files

For the `reproot` command, there are two files that need to be set up in order to use the command: `reproot-env.yaml` and `reproot.yaml`. This article will explain these files.

The first file, `reproot-env.yaml`, needs to be set up once per computer that is using `reproot`. So, each user needs to set it up once, but then the same file can be used on that computer for all projects using `reproot`.

The other file, `reproot.yaml`, needs to be set up once for each project in each "_root folder_" location (see the next section for an explanation of the concept of root folders). So, if one user in a project sets up these files, then all users in that project can use those files as long as those files are shared in the project folder over GitHub, OneDrive/DropBox, network drives, or whatever sharing technology the team is using

## What is a "root folder"?

A root folder is a folder from which other file paths required by the project's code can be expressed as a relative file path from that root folder.

In a single-rooted project, there might be only one root folder. For example, the top folder of a project folder on DropBox/OneDrive, or the root of a project's Git clone. `reproot` handles single-rooted projects well, but there are other tools with minimal manual input that handle them just as well.

A project can also be multi-rooted. A common example of a multi-rooted project is when a team collaborates on code using Git but shares data over a network drive or a sync service like DropBox/OneDrive. In such a project, file paths need to be expressed as relative paths from either the root of the Git clone or the top folder in the project folder on DropBox/OneDrive.

The motivation behind `reproot` was to develop a tool that can handle multi-rooted projects without requiring more than minimal manual input.

## reproot files

### `reproot.yaml` - the root file

A `reproot.yaml` file, from here-on called the _root file_, is placed in each root folder. `reproot` works by searching a computer's file system for these root files. Each root file needs to be a `.yaml` file with the exact name `reproot.yaml`, and its content should be:

```yaml
project_name : <project_name>
root_name    : <root_name>
```

`<project_name>` is the name of the project this root belongs to. Two projects using `reproot` on the same computer may not have the same project name. `<root_name>` is a name to describe that root folder. The root name may not be duplicated within a project. Common names for roots are `data` or `code`.

Let's go back using the multi-rooted example project where data is shared on DropBox/OneDrive and code on Git. Let's call this project `my-research-project`. The root file in the top folder of the DropBox/OneDrive folder would look like this:

```yaml
project_name : "my-resarch-project"
root_name    : "data"
```

And the root file in the top-folder of the Git clone would look like this:

```yaml
project_name : "my-resarch-project"
root_name    : "code"
```

If these files are shared over DropBox/OneDrive/Git/Network, etc. among the other files shared in that method, then the root file only needs to be set up once per location by a single member of the project. Then all other project members can use the same files.

A template root file can be downloaded from [here](https://github.com/worldbank/repkit/blob/main/src/dev/reproot.yaml) for you to download it and modify it to your needs.

### `reproot-env.yaml` - the settings file

Searching all folders on a computer file system would make `reproot` prohibitively slow. However, with some simple settings, the number of folders that need to be searched can be drastically reduced. These settings are done in the `reproot-env.yaml` file.

The settings file needs to be saved in your home folder. It cannot be saved in a custom location as the problem that `reproot` is solving is to define custom file paths with minimal manual setup. If a user needs to manually define the file path to the `reproot-env.yaml `file before using `reproot`, then `reproot` has not solved the problem it intends to solve.

The home folder is a folder that on Windows, Mac, and Linux computers can be expressed using the `~`. You can check what your home folder is in Stata by running `cd ~`. The output you see on your screen is your home folder.

The `reproot-env.yaml` file has three settings: `recursedepth`, `searchpaths` and `skipdirs`.

#### `recursedepth`

* Required: Yes
* Format: A single integer

The recurse depth sets how many sub-folders `reproot` should look into from each _search path_ (see below). If the recurse depth is set to 1, then `reproot` will only look for root files in the folder of the search path. If it is set to 2, it will look for root files in the folder of the search path as well as in that folder's sub-folder. If it is set to 3, it will also look in those sub-folders' sub-folder and so on.

A lower recurse depth will be faster, but it might prevent `reproot` from finding all root files. The higher recurse depth, the more folders will be searched for root paths, but that will slow down the search.

It is typically better to add more search paths rather than increasing the recurse depth a lot. However, the best trade-off between the number of search paths and depends on how you have organized the files on your computer. You should experiment until you've found a combination of search paths and recurse depth that both find all the root files and do so within a reasonable time.

#### `searchpaths`

* Required: Yes
* Format: A list of strings that are absolute file paths

This setting `reproot-env.yaml` file lists one or several start locations for `reproot` to search. These locations should be parent folders (or ancestor folders) of the root folders.

For example, if you have root files in all your git clones in a folder called `C:/Users/home-folder/github`, as in `C:/Users/home-folder/github/project-A/reproot.yaml` and `C:/Users/home-folder/github/project-B/reproot.yaml`, then the `C:/Users/home-folder/github` folder would be an excellent path to include in the search paths as the root files for both _project-A_ and _project-B_ can be quickly found from there.

Similarly, if you have a lot of projects with root files in your `C:/Users/home-folder/OneDrive/work` folder might want to add that search path as well. You might notice that both `C:/Users/home-folder/github` and C`:/Users/home-folder/OneDrive/work` include the path `C:/Users/home-folder`. Does that mean that `C:/Users/home-folder` is a good folder to use as a search path? No! It is not.

`C:/Users/home-folder` will also include folders like `Documents`, `Downloads`, `Images`, `Desktop`, etc. in addition to a lot of system folders where you never would have project files. In this case, it is much better to have the two search paths `C:/Users/home-folder/github` and `C:/Users/home-folder/OneDrive` instead of just the one `C:/Users/home-folder`.

So pick the most restrictive path as a search path that still will include a lot of root files. Again, the most optimal setting will depend on how you organize your files on your computer. Experiment until you have found a balance that works well for you.

It is possible to set a different recurse depth for a specific search path. If you include a number and then a colon at the beginning of your search path, as in `3:C:/Users/wb462869/github`, then the recurse depth for that search path will be 3 no matter what the `recursedepth` setting says.

#### `skipdirs`

* Required: No
* Format: A list of strings that are folder names

There are some folders that never include root files. Skipping such folders reduces the time it takes for `reproot` to search for root files. If you are using Git, then each of your clones will have a folder called `.git`. This folder is typically hidden, but if you are using Git, it is there. `reproot` will search this folder that typically has a lot of sub-folders. By including this folder in skip dirs, `reproot` will not spend time searching that folder.

#### Example

n this example, the default recurse depth is set to 4. Two search paths are included. The first one has a recurse depth set to 2 that overrides the default recurse depth for that search path. Lastly, this setting is set to skip all folders with the name `.git`.

```yaml
recursedepth: 4
searchpaths:
    - "2:C:/Users/home-folder/github"
    - "C:/Users/home-folder/OneDrive/work"
skipdirs:
    - ".git"
```

This file can be downloaded from [here](https://github.com/worldbank/repkit/blob/main/src/dev/reproot-env.yaml) for you to download it and modify it to your needs.

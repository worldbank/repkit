# reproot files

_This is a comprehensive guide to the files used in `reproot`. For documentation focusing on syntax and option descriptions, refer to the [help file](https://worldbank.github.io/repkit/reference/reproot.html)._

To use the `reproot` command, two types of files need to be set up: `reproot-env.yaml` and `reproot.yaml`. This article explains both files.

The first file, `reproot-env.yaml`, needs to be set up once per computer using `reproot`. Each user sets it up once, and the same file can be used for all projects on that computer.

The second file, `reproot.yaml`, needs to be set up once for each project in each "_root folder_" location (see the next section for an explanation of root folders). If one user in a project sets up these files and shares them in the project folder via GitHub, OneDrive/DropBox, network drives, or other sharing technologies, all users in the project can use those files.

## What is a "root folder"?

A root folder is a directory from which all files used in a project can be referenced using a relative path that is consistent for all users. The absolute path to the root folder—called the "_root path_"—may differ between users due to factors such as where the project is stored on their computer or the operating system they use. The relative path from the root folder to a specific file can be expressed int he code as it remains the same for everyone. But the root path must be managed separately, which is where `reproot` comes in.

In a single-rooted project, there is one root folder from which all project files can be accessed via relative paths. For example, if both code and data are shared using a syncing service like DropBox or OneDrive, the root folder would be the top-level project folder within that service. While `reproot` can handle single-rooted projects, other tools can also manage them with minimal manual setup.

Projects can also be multi-rooted. A common scenario is when a team collaborates on code using Git but shares data via a network drive or a syncing service like DropBox or OneDrive. In such cases, file paths need to be expressed as relative paths from either the root of the Git repository or the top-level folder in the syncing service. Then two root paths to different root folders needs to be defined and managed.

The motivation behind `reproot` is to provide a tool that can handle multi-rooted projects with minimal manual configuration.

## `reproot.yaml` - the root file

A `reproot.yaml` file—referred to as the _root file_—is placed in each root folder. `reproot` works by searching your computer's file system for these root files. Each root file must be a `.yaml` file named exactly `reproot.yaml`, with the following content:

```yaml
project_name : <project_name>
root_name    : <root_name>
```
Where: 

- `<project_name>`: Is the name of the project this root belongs to. No two projects using `reproot` on the same computer may have the same project name.
- `<root_name>`: Is a descriptive name for the root folder. Root names must be unique within a project. Common examples include `data` or `code`.

For example, in a multi-rooted project where data is shared via DropBox/OneDrive and code via Git, suppose the project is called `my-research-project`. The root file in the top-level DropBox/OneDrive folder would look like:

```yaml
project_name : "my-research-project"
root_name    : "data"
```

And the root file in the top-level Git clone folder would look like:

```yaml
project_name : "my-research-project"
root_name    : "code"
```

If these files are shared via DropBox, OneDrive, Git, or a network drive, they only need to be set up once per location by a single project member. All other project members can then use the same files.

A template root file is available [here](https://github.com/worldbank/repkit/blob/main/src/dev/reproot.yaml) for you to download and modify as needed.

### `reproot-env.yaml` - the environment settings file

Searching all folders on a computer's file system would make `reproot` prohibitively slow. However, with a few simple settings, the number of folders that need to be searched can be drastically reduced. These settings are configured in the `reproot-env.yaml` file.

This settings file must be saved in your _home folder_. The home folder is a directory that, on Windows, Mac, and Linux computers, can be referenced using `~`. You can check your home folder in Stata by running `cd ~`. The output displayed is your home folder.

It cannot be saved in a custom location, because the purpose of `reproot` is to manage custom locations, and this file is needed to search for them. If a user had to manually specify a custom file path to the `reproot-env.yaml` file before using `reproot`, the tool would not be solving the problem it is designed to address.

If a user tries to use `reproot` without having this file set up, they will get a helpful error message explaining with an option to open up a dialog box where this file can be configured and saved in the correct location.

The `reproot-env.yaml` file has three settings: `recursedepth`, `paths`, and `skipdirs`.

#### `recursedepth`

* Required: Yes
* Format: A single integer

The `recursedepth` setting determines how many levels of subfolders `reproot` will search within each _search path_ (see below). If `recursedepth` is set to 1, `reproot` will only look for root files in the specified search path folder itself. If set to 2, it will also search in each immediate subfolder. A value of 3 means it will search in subfolders of subfolders, and so on.

A lower `recursedepth` will make searches faster but may prevent `reproot` from finding all root files. A higher value increases the number of folders searched, which can slow down the process.

It is generally better to add more specific search paths rather than increasing `recursedepth` significantly. The optimal balance between the number of search paths and the recurse depth depends on how your files are organized. Experiment to find a combination that locates all root files efficiently.

#### `paths`

* Required: Yes  
* Format: A list of strings that are absolute file paths

The `paths` setting in the `reproot-env.yaml` file specifies one or more starting locations for `reproot` to search. These should be parent folders of your root folders. Paths must always be absolute, starting with `C:/` on Windows or `/Users/` on Mac.

For example, if your root files are located in all your Git clones under `C:/Users/home-folder/github` (such as `C:/Users/home-folder/github/project-A/reproot.yaml` and `C:/Users/home-folder/github/project-B/reproot.yaml`), then `C:/Users/home-folder/github` is a good path to include, as it allows `reproot` to quickly find root files for both projects.

Similarly, if you have many projects with root files in `C:/Users/home-folder/OneDrive/work`, you may want to add that path as well. You might notice that both `C:/Users/home-folder/github` and `C:/Users/home-folder/OneDrive/work` share the parent path `C:/Users/home-folder`. However, using `C:/Users/home-folder` as a search path is not recommended, as it also contains folders like `Documents`, `Downloads`, `Images`, `Desktop`, and other system folders where project files are unlikely to be found. In this case, it is better to specify the more restrictive paths `C:/Users/home-folder/github` and `C:/Users/home-folder/OneDrive` rather than the broader `C:/Users/home-folder`.

Choose the most specific search paths that still include all your root files. The optimal configuration depends on how your files are organized, so experiment to find what works best for you.

You can also set a custom recurse depth for a specific search path by prefixing the path with a number and a colon (e.g., `3:C:/Users/wb462869/github`). In this case, the recurse depth for that path will be 3, regardless of the global `recursedepth` setting.

#### `skipdirs`

* Required: No  
* Format: A list of strings representing folder names

Some folders never contain root files and can be safely skipped to speed up the search process. For example, if you use Git, each repository contains a hidden `.git` folder with many subfolders that do not contain root files. By listing such folder names in `skipdirs`, `reproot` will ignore them during its search, improving performance.

#### Example

In this example, the default recurse depth is set to 4. Two search paths are included: the first path has a custom recurse depth of 2 (overriding the default for that path), and the second uses the default. The configuration also skips all folders named `.git`.

```yaml
recursedepth: 4
paths:
    - "2:C:/Users/home-folder/github"
    - "C:/Users/home-folder/OneDrive/work"
skipdirs:
    - ".git"
```

A template for this file is available [here](https://github.com/worldbank/repkit/blob/main/src/dev/reproot-env.yaml) for you to download and modify as needed.

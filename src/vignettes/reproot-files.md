# reproot files

For the `reproot` command there are two files that needs to be set up in order to use the command. `reproot-env.yaml` and `reproot.yaml`. This article will explain those files.

The first file `reproot-env.yaml` needs to be set up once per computer that is using `reproot`. So each user needs to set it up once, but then the same file can be used on that computer for all projects on that computer using `reproot`.

The other file `reproot.yaml` file needs to be set up once for each project in each "_important_" folder location. More on what an "_important_" folder location is below. So, if one user in a project sets up these files, then all users in that project can use those files as long as those files are shared in the project folder over GitHub, OneDrive/DropBox, network drives or whatever sharing technology the team is using.


## `reproot.yaml` - the root file

A `reproot.yaml` file, from here-on called the **_root file_**, is places in each important root folders in a project. An important location is a location from which other files can be referenced using relative paths. This would be the top-folder, and then the file-path to all sub-folders and all files in those sub-folders can be expressed as a relative path from that top-folder.

In a single-rooted folder there is only one such top-folder. For example,

## `reproot-env.yaml` - the settings file

`reproot` search

# Using custom schemes when using `repado`

The recommended installation location for custom schemes
is the `PERSONAL` folder.
If you are using `repado` in `nostrict` mode,
then this is not an issue as the `PERSONAL` folder is still accessible.

However, if you are using `repado` in `strict` mode,
then the `PERSONAL` folder is no longer accessible.
In this case we recommend installing the custom schemes
in the `PLUS` folder,
which will be the same folder as provided in the `adopath()` option.

This means that you will have to install schemas you frequently use
in each project specific ado-folder.
While that might seem as extra work,
it is beneficial in the sense that
all other members of the project team has access to the same schema.
So once one member installs the schema there,
then all project members have access to the exact version of that schema,
as soon as the files are shared with the rest of the team.

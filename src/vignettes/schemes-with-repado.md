# Using custom schemes when using `repado`

The recommended installation location for custom schemes
is the `PERSONAL` folder.
If you are using `repado` in `nostrict` mode,
then this is not an issue as the `PERSONAL` folder is still accessible.
However, if you are using `repado` in `strict` mode,
then the `PERSONAL` folder is no longer accessible.
In this case we recommend installing the custom schemes
in the folder used in the `adopath()` option.

A simple implementation is as follows:
```
  global myproject "/path/to/project/"
  repado , adopath("${myproject}/ado") mode(strict)

  local url "https://github.com/graykimbrough/uncluttered-stata-graphs/raw/master/schemes/scheme-uncluttered.scheme" 
  copy "`url" "${myproject}/ado/scheme-uncluttered.scheme" , replace

  set scheme uncluttered , perm
  graph set eps fontface "Helvetica"

  sysuse auto, clear
  scatter price mpg
```

This means that, by installing the project's scheme
in the project-specific ado-folder,
you will ensure that
all project members and replicators
are guaranteed exactly-matching outputs.

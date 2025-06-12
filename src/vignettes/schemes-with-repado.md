# Using custom schemes with `repado`

Stata's recommended location for installing custom schemes is the `PERSONAL` folder. If you are using `repado` in `nostrict` mode, the `PERSONAL` folder remains accessible and this is still a good place. Note that we only recommend the `nostrict` mode temporarily.

In the default `strict` mode that we recommend, the `PERSONAL` folder is no longer available. In this case, we recommend installing custom schemes in the project ado-folder 

A simple implementation is as follows:

```stata
  global myproject "/path/to/project/"
  repado , adopath("${myproject}/ado") mode(strict)

  local url "https://github.com/graykimbrough/uncluttered-stata-graphs/raw/master/schemes/scheme-uncluttered.scheme" 
  copy "`url" "${myproject}/ado/scheme-uncluttered.scheme" , replace

  set scheme uncluttered , perm
  graph set eps fontface "Helvetica"

  sysuse auto, clear
  scatter price mpg
```

By installing the project's scheme in the project-specific ado-folder, you ensure that all project members and replicators will produce exactly matching outputs.

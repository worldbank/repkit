*! version 1.1 17DEC2024 DIME Analytics dimeanalytics@worldbank.org

* Command intended to exclusively be run from the run files
* that the command iedorep is generating

cap program drop   reprun_dataline
    program define reprun_dataline, rclass

    version 13.0

    syntax ,              ///
      run(string)         /// run 1 or 2
      lnum(string)        /// line number for output
      [ ///
      datatmp(string)     /// The tempfile that holds the RNG etc. data
      recursestub(string) /// keep track of sub-do-file
      orgsubfile(string)  ///
      looptracker(string) /// keeps track of inside a loop
      ]

    * Save everything that is sitting in r() now and give it back after
    return add

    * Open `data_store' file
    tempname   data_store
    file open `data_store' using "`datatmp'", write append

    * If not a recurse row then write data
    if missing("`recursestub'") {

      * Adding rng state
      local rng "`c(rngstate)'"
      *Get the states to be checked
      local srng "`c(sortrngstate)'"
      datasignature
      local dsig "`r(datasignature)'"
      * Trim looptracker to remove excessive spaces
      local loopt = trim("`looptracker'")

      *Build data line
      local line "l:`lnum'&rng:`rng'&srngstate:`srng'&data:`output'`data'&dsig:`dsig'&loopt:`loopt'&srngcheck:`srngcheck'"
    }

    * Recurse line
    else {
      *Build recurse instructions line
      local line `"recurse `recursestub' "`orgsubfile'" "'
    }

    *Write line and close file
    file write `data_store' `"`line'"' _n
    file close `data_store'
end

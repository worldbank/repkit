*! version XX XXXXXXXXX ADAUTHORNAME ADCONTACTINFO

* Command intended to exclusively be run from the run files
* that the command iedorep is generating

cap program drop   reprun_dataline
    program define reprun_dataline, rclass


      syntax , run(string)    ///
        lnum(string) datatmp(string)           [ ///
        recursestub(string) orgsubfile(string)   ///
        looptracker(string) ]

      * Save everything that is sitting in r() now and give it back after
      return add

      * Open data_store file
      file open data_store using "`datatmp'", read

        // Get the most recent data
        local stop 0
        while !`stop' {
          file read data_store old
          if r(eof)==1 {
            local stop = 1
          }
          else local olddata = `"`macval(old)'"'
        }

        while !missing(`"`olddata'"') {
            * Parse next key:value pair of data
            gettoken keyvaluepair olddata : olddata, parse("&")
            local old = substr("`olddata'",2,.) // remove parse char
            * Get key and value from pair and return
            gettoken key value : keyvaluepair, parse(":")
            local prev_`key' = substr("`value'",2,.) // remove parse char
        }

        file close data_store

* Open data_store file
file open data_store using "`datatmp'", write append

      * If not a recurse row then write data
      if missing("`recursestub'") {

        * This is so long it makes testing hard - add later
        local rng "`c(rngstate)'"
        *Get the states to be checked
        local srng "`c(sortrngstate)'"
        datasignature
        local dsig "`r(datasignature)'"

        * Trim data
        local loopt = trim("`looptracker'")

        * Handle data line
        local output = substr(`"`datatmp'"',1,strrpos(`"`datatmp'"',".txt")-1)
        local data = "/`lnum'`looptracker'"
        local data = subinstr("`data'"," ","_",.)
        local data = subinstr("`data'",":","-",.)
        local data = `"`data'.dta"'

        cap cf _all using "`prev_data'"
        local err = _rc

        if inlist(`err',9,198) & `run' == 1 {
          cap mkdir "`output'"
          save "`output'`data'" , replace emptyok
          local srngcheck = `err'
        }
        if !inlist(`err',9,198) & `run' == 1 {
          local srngcheck = "`err'"
          local output = ""
          local data = "`prev_data'"
        }
        if inlist(`err',9,198) & `run' == 2 {
          local output = subinstr(`"`output'"',"run2","run1",.)
          cap cf _all using "`output'`data'
          local srngcheck = _rc
          local output = subinstr(`"`output'"',"run1","run2",.)
          cap mkdir "`output'"
          save "`output'`data'" , replace emptyok
        }
        if !inlist(`err',9,198) & `run' == 2 {
          local output = subinstr(`"`prev_data'"',"run2","run1",.)
          cap cf _all using "`output'
          local srngcheck = _rc
          local data = ""
          local output = subinstr(`"`output'"',"run1","run2",.)
        }

        *Build data line
        local line "l:`lnum'&rng:`rng'&srngstate:`srng'&data:`output'`data'&dsig:`dsig'&loopt:`loopt'&srngcheck:`srngcheck'"
      }

      * Recurse line
      else {
        *Build recurse instructions line
        local line `"recurse `recursestub' "`orgsubfile'" "'
      }

      *Write line and close file
      file write data_store `"`line'"' _n
      file close data_store
    end

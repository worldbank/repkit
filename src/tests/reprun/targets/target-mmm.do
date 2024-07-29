//

clear

sysuse auto.dta

  tempfile a
  save `a' , replace

merge m:m foreign using `a' , nogen

isid make, sort
sort foreign

local MYFAKELOCAL = `MYFAKELOCAL' + 1

su price

di as err "Should be 6165... `r(mean)'"

di as err "Should be 6165... `r(mean)'"

#d cr

isid make, sort

bys foreign : gen x2 = _N

// TEST COMMENT

global something "nothing"

expand 2 , gen(check)

isid make check, sort

sort foreign

di as err "RUNFILE: THIS VALUE SHOULD ALWAYS BE THE NUMBER ONE: `MYFAKELOCAL'"

gen x = _n

set sortseed 12345

cap duplicates drop make , force



//

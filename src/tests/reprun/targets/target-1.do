//

clear

sysuse auto.dta

isid make, sort
sort foreign

local MYFAKELOCAL = `MYFAKELOCAL' + 1

su price

di as err "Should be 6165... `r(mean)'"

di as err "Should be 6165... `r(mean)'"

#d cr

// TEST COMMENT

global something "nothing"

forv i = 1/5 {
  gen varx`i' = rnormal()
  if `i' == 3 set seed 847
}

expand 2 , gen(check)

isid make check, sort

sort foreign

di as err "RUNFILE: THIS VALUE SHOULD ALWAYS BE THE NUMBER ONE: `MYFAKELOCAL'"

gen x = _n
gen y = rnormal()



cap duplicates drop make , force

do "target-2.do" // missing do-file

if (1 == 1) & (1 == 1) do "${tf}/target-2.do"


//

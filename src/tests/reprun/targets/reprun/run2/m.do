 //
reprun_dataline, run(2) lnum(1) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") looptracker("")
 
 clear
reprun_dataline, run(2) lnum(3) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") looptracker("")
 
 sysuse auto.dta
reprun_dataline, run(2) lnum(5) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") looptracker("")
 
 isid make, sort
reprun_dataline, run(2) lnum(7) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") looptracker("")
 sort foreign
reprun_dataline, run(2) lnum(8) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") looptracker("")
 
 local MYFAKELOCAL = `MYFAKELOCAL' + 1
reprun_dataline, run(2) lnum(10) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") looptracker("")
 
 su price
reprun_dataline, run(2) lnum(12) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") looptracker("")
 
 di as err "Should be 6165... `r(mean)'"
reprun_dataline, run(2) lnum(14) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") looptracker("")
 
 #d cr
reprun_dataline, run(2) lnum(16) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") looptracker("")
 
 // TEST COMMENT
reprun_dataline, run(2) lnum(18) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") looptracker("")
 
 global do "nothing"
reprun_dataline, run(2) lnum(20) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") looptracker("")
 
 forv run = 1/5 {
reprun_dataline, run(2) lnum(22) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") looptracker(" run:`run'")
   gen varx`run' = rnormal()
reprun_dataline, run(2) lnum(23) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") looptracker(" run:`run'")
   if `run' == 3 set seed 847
reprun_dataline, run(2) lnum(24) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") looptracker(" run:`run'")
 }
 
 expand 2 , gen(check)
reprun_dataline, run(2) lnum(27) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") looptracker("")
 
 isid make check, sort
reprun_dataline, run(2) lnum(29) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") looptracker("")
 
 sort foreign
reprun_dataline, run(2) lnum(31) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") looptracker("")
 
 di as err "RUNFILE: THIS VALUE SHOULD ALWAYS BE THE NUMBER ONE: `MYFAKELOCAL'"
reprun_dataline, run(2) lnum(33) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") looptracker("")
 
 gen x = _n
reprun_dataline, run(2) lnum(35) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") looptracker("")
 gen y = rnormal()
reprun_dataline, run(2) lnum(36) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") looptracker("")
 
 
 
 duplicates drop make , force
reprun_dataline, run(2) lnum(40) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") looptracker("")
 
 
reprun_dataline, run(2) lnum(43) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") recursestub(m_1) orgsubfile(/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets/target-2.do)
 do "/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m_1.do"
reprun_dataline, run(2) lnum(43) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") looptracker("")
 
 
 //
reprun_dataline, run(2) lnum(46) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m.txt") looptracker("")
 

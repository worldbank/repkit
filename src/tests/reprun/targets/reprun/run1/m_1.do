 //
reprun_dataline, run(1) lnum(1) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run1/m_1.txt") looptracker("")
 
 clear
reprun_dataline, run(1) lnum(3) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run1/m_1.txt") looptracker("")
 
 sysuse auto.dta , clear
reprun_dataline, run(1) lnum(5) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run1/m_1.txt") looptracker("")
 
 local MYFAKELOCAL = `MYFAKELOCAL' + 1
reprun_dataline, run(1) lnum(7) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run1/m_1.txt") looptracker("")
 
 #d cr
reprun_dataline, run(1) lnum(9) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run1/m_1.txt") looptracker("")
 
 expand 2 , gen(check)
reprun_dataline, run(1) lnum(11) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run1/m_1.txt") looptracker("")
 
 isid make check, sort
reprun_dataline, run(1) lnum(13) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run1/m_1.txt") looptracker("")
 
 sort foreign
reprun_dataline, run(1) lnum(15) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run1/m_1.txt") looptracker("")
 
 di as err "SAME FROM THE SUBROUTINE: `MYFAKELOCAL'"
reprun_dataline, run(1) lnum(17) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run1/m_1.txt") looptracker("")
 
 forv run = 1/5 {
reprun_dataline, run(1) lnum(19) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run1/m_1.txt") looptracker(" run:`run'")
   foreach type in A B "C" {
reprun_dataline, run(1) lnum(20) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run1/m_1.txt") looptracker(" run:`run' type:`type'")
     if "`type'" == "A" set seed 8475
reprun_dataline, run(1) lnum(21) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run1/m_1.txt") looptracker(" run:`run' type:`type'")
     gen var`type'`run' = rnormal()
reprun_dataline, run(1) lnum(22) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run1/m_1.txt") looptracker(" run:`run' type:`type'")
   }
 }
 
 gen x = _n
reprun_dataline, run(1) lnum(26) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run1/m_1.txt") looptracker("")
 gen y = rnormal()
reprun_dataline, run(1) lnum(27) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run1/m_1.txt") looptracker("")
 
 set seed 123455
reprun_dataline, run(1) lnum(29) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run1/m_1.txt") looptracker("")
 
 duplicates drop make , force
reprun_dataline, run(1) lnum(31) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run1/m_1.txt") looptracker("")
 
reprun_dataline, run(1) lnum(33) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run1/m_1.txt") recursestub(m_1_1) orgsubfile(/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets/target-3.do)
 do "/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run1/m_1_1.do"
reprun_dataline, run(1) lnum(33) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run1/m_1.txt") looptracker("")
 
 
 //
reprun_dataline, run(1) lnum(36) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run1/m_1.txt") looptracker("")
 

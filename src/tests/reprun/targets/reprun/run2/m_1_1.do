 //
reprun_dataline, run(2) lnum(1) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m_1_1.txt") looptracker("")
 
 clear
reprun_dataline, run(2) lnum(3) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m_1_1.txt") looptracker("")
 
 sysuse auto.dta , clear
reprun_dataline, run(2) lnum(5) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m_1_1.txt") looptracker("")
 
 local MYFAKELOCAL = `MYFAKELOCAL' + 1
reprun_dataline, run(2) lnum(7) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m_1_1.txt") looptracker("")
 
 #d cr
reprun_dataline, run(2) lnum(9) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m_1_1.txt") looptracker("")
 
 expand 2 , gen(check)
reprun_dataline, run(2) lnum(11) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m_1_1.txt") looptracker("")
 
 isid make check, sort
reprun_dataline, run(2) lnum(13) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m_1_1.txt") looptracker("")
 
 sort foreign
reprun_dataline, run(2) lnum(15) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m_1_1.txt") looptracker("")
 
 di as err "SAME FROM THE SUBROUTINE: `MYFAKELOCAL'"
reprun_dataline, run(2) lnum(17) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m_1_1.txt") looptracker("")
 
 gen x = _n
reprun_dataline, run(2) lnum(19) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m_1_1.txt") looptracker("")
 gen y = rnormal()
reprun_dataline, run(2) lnum(20) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m_1_1.txt") looptracker("")
 
 set seed 123455
reprun_dataline, run(2) lnum(22) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m_1_1.txt") looptracker("")
 
 duplicates drop make , force
reprun_dataline, run(2) lnum(24) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m_1_1.txt") looptracker("")
 
 
 //
reprun_dataline, run(2) lnum(27) datatmp("/Users/bbdaniels/GitHub/repkit/src/tests/reprun/targets//reprun/run2/m_1_1.txt") looptracker("")
 

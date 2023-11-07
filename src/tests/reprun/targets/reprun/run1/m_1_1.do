 //
reprun_dataline, run(1) lnum(1) datatmp("C:\Users\wb462869\github\repkit/src/tests/reprun/targets//reprun/run1/m_1_1.txt") looptracker("")
 
 clear
reprun_dataline, run(1) lnum(3) datatmp("C:\Users\wb462869\github\repkit/src/tests/reprun/targets//reprun/run1/m_1_1.txt") looptracker("")
 
 sysuse auto.dta , clear
reprun_dataline, run(1) lnum(5) datatmp("C:\Users\wb462869\github\repkit/src/tests/reprun/targets//reprun/run1/m_1_1.txt") looptracker("")
 
 local MYFAKELOCAL = `MYFAKELOCAL' + 1
reprun_dataline, run(1) lnum(7) datatmp("C:\Users\wb462869\github\repkit/src/tests/reprun/targets//reprun/run1/m_1_1.txt") looptracker("")
 
 #d cr
reprun_dataline, run(1) lnum(9) datatmp("C:\Users\wb462869\github\repkit/src/tests/reprun/targets//reprun/run1/m_1_1.txt") looptracker("")
 
 expand 2 , gen(check)
reprun_dataline, run(1) lnum(11) datatmp("C:\Users\wb462869\github\repkit/src/tests/reprun/targets//reprun/run1/m_1_1.txt") looptracker("")
 
 isid make check, sort
reprun_dataline, run(1) lnum(13) datatmp("C:\Users\wb462869\github\repkit/src/tests/reprun/targets//reprun/run1/m_1_1.txt") looptracker("")
 
 sort foreign
reprun_dataline, run(1) lnum(15) datatmp("C:\Users\wb462869\github\repkit/src/tests/reprun/targets//reprun/run1/m_1_1.txt") looptracker("")
 
 di as err "SAME FROM THE SUBROUTINE: `MYFAKELOCAL'"
reprun_dataline, run(1) lnum(17) datatmp("C:\Users\wb462869\github\repkit/src/tests/reprun/targets//reprun/run1/m_1_1.txt") looptracker("")
 
 gen x = _n
reprun_dataline, run(1) lnum(19) datatmp("C:\Users\wb462869\github\repkit/src/tests/reprun/targets//reprun/run1/m_1_1.txt") looptracker("")
 gen y = rnormal()
reprun_dataline, run(1) lnum(20) datatmp("C:\Users\wb462869\github\repkit/src/tests/reprun/targets//reprun/run1/m_1_1.txt") looptracker("")
 
 set seed 123455
reprun_dataline, run(1) lnum(22) datatmp("C:\Users\wb462869\github\repkit/src/tests/reprun/targets//reprun/run1/m_1_1.txt") looptracker("")
 
 duplicates drop make , force
reprun_dataline, run(1) lnum(24) datatmp("C:\Users\wb462869\github\repkit/src/tests/reprun/targets//reprun/run1/m_1_1.txt") looptracker("")
 
 
 //
reprun_dataline, run(1) lnum(27) datatmp("C:\Users\wb462869\github\repkit/src/tests/reprun/targets//reprun/run1/m_1_1.txt") looptracker("")
 

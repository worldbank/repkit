* The run_fldr global is set in repkit\src\tests\reprun\reprun.do
local fldr  "${run_fldr}/multi-file"

clear
set obs 10
do "`fldr'/B sub1.do"
do `fldr'/B-sub2.do

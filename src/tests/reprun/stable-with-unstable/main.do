/*******************************************************************************
To test how results are displayed if some do-files have changes and other don't
*******************************************************************************/

local fldr  "${run_fldr}/stable-with-unstable"


do "`fldr'/test1.do"
do "`fldr'/test2.do"
do "`fldr'/test3.do"

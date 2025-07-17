
* Practices flagged by repscan

** Merge many-to-many
merge m:m key using "data.dta"

** Forced drop of duplicates
duplicates drop, force

** Sorts
sort var1

** Seeting sort seeds
set sortseed     1234
set sortrngstate 1234

** Bysorts
bys    var1 var2: egen groups = group(var3 var4)
bysort var1 var2: egen groups = group(var3 var4)

** reclink
reclink province using data.dta
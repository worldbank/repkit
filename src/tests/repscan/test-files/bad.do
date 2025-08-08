
* Practices flagged by repscan

** runiform() without a seed
gen myvar1 = runiform()

** Setting random seed without version
set seed 5678

** Setting random seed after version--should not be flagged
version 16.0
set seed 5678

** runiform() after setting random seed--should not be flagged
gen myvar2 = runiform()

** Merge many-to-many
merge m:m key using "data.dta"

** Forced drop of duplicates
duplicates drop, force

** Forced drop of duplicates with REPSCAN OK --should not be flagged
duplicates drop, force // REPSCAN OK

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

* Finished! *
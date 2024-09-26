# reprun - examples 

This section presents examples and outputs for the `reprun` command, demonstrating its use for ensuring reproducibility in analyses. For detailed information on the command, please refer to the [helpfile.](https://worldbank.github.io/repkit/reference/reprun.html)

## Example 1

This is the most basic usage of `reprun`. Specified in any of the following ways, either in the Stata command window or as part of a new do-file, `reprun` will execute the complete do-file "_myfile.do_" once (Run 1), and record the "seed RNG state", "sort order RNG", and "data checksum" after the execution of every line, as well as the exact data in certain cases. `reprun` will then execute "_myfile.do_" a second time (Run 2), and find all _changes_ and _mismatches_ in these states throughout Run 2. A table of mismatches will be reported in the Results window, as well as in a SMCL file in a new directory called `/reprun/` in the same location as "_myfile.do_". 


```stata
reprun "path/to/folder/myfile.do"
```

or 

```stata
local myfolder "/path/to/folder"
reprun "`myfolder'/myfile.do"
```

## Example 2

This example is similar to example 1, but the `/reprun/` directory containing the SMCL file will be stored in the location specified by the `using` argument.

```stata
reprun "path/to/folder/myfile.do" using "path/to/report"
```

or 

```stata
local myfolder "/path/to/folder"
reprun "`myfolder'/myfile.do" using "`myfolder'/report"
```

## Example 3

Assume "_myfile1.do_" contains the following code:

```stata
sysuse census, clear
isid state, sort
gen group = runiform() < .5
```

Running a reproducibility check on this do-file using `reprun` will generate a table listing _mismatches_ in Stata state between Run 1 and Run 2. 

```
reprun "path/to/folder/myfile1.do"
```

A table of mismatches will be reported in the Results window, as well as in a SMCL file in a new directory called `/reprun/` in the same location as "_myfile1.do_" and will look like:

```stata
--------------------------------------------------------------------------------------------------------------
    reprun output created by user wb558768 at 26 Sep 2024 11:24:39
    Operating System PC (64-bit x86-64) Windows 64-bit
    Stata MP - Version 18 running as version 14.1
--------------------------------------------------------------------------------------------------------------
 
    Checking file:
    +-> C:/Users/wb558768/reprun-example/myfile1.do
+------------------------------------------------------------------------------------------------------------
|        |      Seed RNG State      |      Sort Order RNG      |      Data Checksum       |
| Line # | Run 1  | Run 2  | Match  | Run 1  | Run 2  | Match  | Run 1  | Run 2  | Match  | Loop iteration:
|--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+------------------
| 3      | Change   Change   DIFF   |                          | Change   Change   DIFF   |
+------------------------------------------------------------------------------------------------------------
 
    Done checking file:
    +-> C:/Users/wb558768/reprun-example/myfile1.do
-------------------------------------------------------------------------------------------------------------
```


The table shows that Line 3 is flagged. Line 3 (`gen group = runiform() < .5`) generates a new variable `group` based on a random uniform distribution. The RNG state will differ between Run 1 and Run 2 unless the random seed is explicitly set before this command. As a result, a mismatch in the "seed RNG state" as well as "data checksum" will be flagged.

The issue can be resolved by setting a seed before the command:

```stata
sysuse census, clear
isid state, sort
set seed 346290
gen group = runiform() < .5
```

Running the reproducibility check on the modified do-file using `reprun` will confirm that there are no mismatches in Stata state between Run 1 and Run 2:

```stata
------------------------------------------------------------------------------------------------------------
    reprun output created by user wb558768 at 26 Sep 2024 11:29:35
    Operating System PC (64-bit x86-64) Windows 64-bit
    Stata MP - Version 18 running as version 14.1
------------------------------------------------------------------------------------------------------------
 
    Checking file:
    +-> C:/Users/wb558768/reprun-example/myfile1.do
+------------------------------------------------------------------------------------------------------------
|        |      Seed RNG State      |      Sort Order RNG      |      Data Checksum       |
| Line # | Run 1  | Run 2  | Match  | Run 1  | Run 2  | Match  | Run 1  | Run 2  | Match  | Loop iteration:
|--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+------------------
+------------------------------------------------------------------------------------------------------------
No mismatches and/or changes detected
 
    Done checking file:
    +-> C:/Users/wb558768/reprun-example/myfile1.do
-------------------------------------------------------------------------------------------------------------
```

## Example 4

Using the  `verbose` option generates more detailed tables where any lines across Run 1 and Run 2 mismatch **or** change for any value. 

```stata
reprun "path/to/folder/myfile1.do", verbose
```

In addition to the output in Example 3, it will also report line 2 for **changes** in "sort order RNG" and "data checksum:

```stata

-------------------------------------------------------------------------------------------------------------
    reprun output created by user wb558768 at 26 Sep 2024 11:26:38
    Operating System PC (64-bit x86-64) Windows 64-bit
    Stata MP - Version 18 running as version 14.1
-------------------------------------------------------------------------------------------------------------
 
    Checking file:
    +-> C:/Users/wb558768/reprun-example/myfile1.do
+------------------------------------------------------------------------------------------------------------
|        |      Seed RNG State      |      Sort Order RNG      |      Data Checksum       |
| Line # | Run 1  | Run 2  | Match  | Run 1  | Run 2  | Match  | Run 1  | Run 2  | Match  | Loop iteration:
|--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+------------------
| 2      |                          | Change   Change   OK!    | Change   Change   OK!    |
| 3      | Change   Change   DIFF   |                          | Change   Change   DIFF   |
+------------------------------------------------------------------------------------------------------------
 
    Done checking file:
    +-> C:/Users/wb558768/reprun-example/myfile1.do
-------------------------------------------------------------------------------------------------------------
```

## Example 5 

Assume "_myfile2.do_" contains the following code:

```stata
sysuse auto, clear
sort mpg 
gen sequence = _n
```

Running a reproducibility check on this do-file using __reprun__ will generate a table listing _mismatches_ in Stata state between Run 1 and Run 2. 

```stata
reprun "path/to/folder/myfile2.do"
```

In "_myfile2.do_", Line 2 sorts the data by the non-unique variable `mpg`, causing the sort order to vary between runs. This results in a mismatch in the "sort order RNG". Consequently, Line 2 and Line 3 (`gen sequence = _n`) will be flagged for "data checksum" mismatches due to the differences in sort order, leading to discrepancies in the generated `sequence` variable, as shown in the results below:

```stata
-------------------------------------------------------------------------------------------------------------
    reprun output created by user wb558768 at 26 Sep 2024 11:27:34
    Operating System PC (64-bit x86-64) Windows 64-bit
    Stata MP - Version 18 running as version 14.1
-------------------------------------------------------------------------------------------------------------
 
    Checking file:
    +-> C:/Users/wb558768/reprun-example/myfile2.do
+------------------------------------------------------------------------------------------------------------
|        |      Seed RNG State      |      Sort Order RNG      |      Data Checksum       |
| Line # | Run 1  | Run 2  | Match  | Run 1  | Run 2  | Match  | Run 1  | Run 2  | Match  | Loop iteration:
|--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+------------------
| 2      |                          | Change   Change   DIFF   | Change   Change   DIFF   |
| 3      |                          |                          | Change   Change   DIFF   |
+------------------------------------------------------------------------------------------------------------
 
    Done checking file:
    +-> C:/Users/wb558768/reprun-example/myfile2.do
-------------------------------------------------------------------------------------------------------------
```

The issue can be resolved by sorting the data on a unique combination of variables:

```stata
sysuse auto, clear
sort mpg make
gen sequence = _n
```

## Example 6

Using the `compact` option generates less detailed tables where only lines with mismatched seed or sort order RNG changes during Run 1 or Run 2, and mismatches between the runs, are flagged and reported. 

```
reprun "path/to/folder/myfile2.do", compact
```

The output will be similar to Example 5, except that line 3 will no longer be flagged for "data checksum":

```stata
-------------------------------------------------------------------------------------------------------------
    reprun output created by user wb558768 at 26 Sep 2024 11:30:59
    Operating System PC (64-bit x86-64) Windows 64-bit
    Stata MP - Version 18 running as version 14.1
-------------------------------------------------------------------------------------------------------------
 
    Checking file:
    +-> C:/Users/wb558768/reprun-example/myfile2.do
+------------------------------------------------------------------------------------------------------------
|        |      Seed RNG State      |      Sort Order RNG      |      Data Checksum       |
| Line # | Run 1  | Run 2  | Match  | Run 1  | Run 2  | Match  | Run 1  | Run 2  | Match  | Loop iteration:
|--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+------------------
| 2      |                          | Change   Change   DIFF   | Change   Change   DIFF   |
+------------------------------------------------------------------------------------------------------------
 
    Done checking file:
    +-> C:/Users/wb558768/reprun-example/myfile2.do
-------------------------------------------------------------------------------------------------------------
```

## Example 7

`reprun` will perform a reproducibility check on a do-file, including all do-files it calls recursively. For example, the main do-file might contain the following code that calls on "_myfile1.do_" (Example 3) and "_myfile2.do_" (Example 5):

```stata
local myfolder "/path/to/folder"
do "`myfolder'/myfile1.do"
do "`myfolder'/myfile2.do"
```

```stata
reprun ""path/to/folder/main.do"
```

`reprun` on "_main.do_" performs reproducibility checks across "_main.do_", as well as "_myfile1.do_", and "_myfile2.do_" and the result will look like:

```stata
------------------------------------------------------------------------------------------------------------
    reprun output created by user wb558768 at 26 Sep 2024 11:33:05
    Operating System PC (64-bit x86-64) Windows 64-bit
    Stata MP - Version 18 running as version 14.1
------------------------------------------------------------------------------------------------------------
 
    Checking file:
    +-> C:/Users/wb558768/reprun-example/main.do
+------------------------------------------------------------------------------------------------------------
|        |      Seed RNG State      |      Sort Order RNG      |      Data Checksum       |
| Line # | Run 1  | Run 2  | Match  | Run 1  | Run 2  | Match  | Run 1  | Run 2  | Match  | Loop iteration:
|--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+------------------
+------------------------------------------------------------------------------------------------------------
No mismatches and/or changes detected
 
    Stepping into sub-file:
    +-> C:/Users/wb558768/reprun-example/main.do
    +--> C:/Users/wb558768/reprun-example/myfile1.do
+------------------------------------------------------------------------------------------------------------
|        |      Seed RNG State      |      Sort Order RNG      |      Data Checksum       |
| Line # | Run 1  | Run 2  | Match  | Run 1  | Run 2  | Match  | Run 1  | Run 2  | Match  | Loop iteration:
|--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+------------------
| 3      | Change   Change   DIFF   |                          | Change   Change   DIFF   |
+------------------------------------------------------------------------------------------------------------
 
    Stepping back into file:
    +-> C:/Users/wb558768/reprun-example/main.do
+------------------------------------------------------------------------------------------------------------
|        |      Seed RNG State      |      Sort Order RNG      |      Data Checksum       |
| Line # | Run 1  | Run 2  | Match  | Run 1  | Run 2  | Match  | Run 1  | Run 2  | Match  | Loop iteration:
|--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+------------------
| 2      | Change   Change   DIFF   | Change   Change   DIFF   | Change   Change   DIFF   |
+------------------------------------------------------------------------------------------------------------
 
    Stepping into sub-file:
    +-> C:/Users/wb558768/reprun-example/main.do
    +--> C:/Users/wb558768/reprun-example/myfile2.do
+------------------------------------------------------------------------------------------------------------
|        |      Seed RNG State      |      Sort Order RNG      |      Data Checksum       |
| Line # | Run 1  | Run 2  | Match  | Run 1  | Run 2  | Match  | Run 1  | Run 2  | Match  | Loop iteration:
|--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+------------------
| 2      |                          | Change   Change   DIFF   | Change   Change   DIFF   |
| 3      |                          |                          | Change   Change   DIFF   |
+------------------------------------------------------------------------------------------------------------
 
    Stepping back into file:
    +-> C:/Users/wb558768/reprun-example/main.do
+------------------------------------------------------------------------------------------------------------
|        |      Seed RNG State      |      Sort Order RNG      |      Data Checksum       |
| Line # | Run 1  | Run 2  | Match  | Run 1  | Run 2  | Match  | Run 1  | Run 2  | Match  | Loop iteration:
|--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+------------------
| 3      |                          | Change   Change   DIFF   | Change   Change   DIFF   |
+------------------------------------------------------------------------------------------------------------
 
    Done checking file:
    +-> C:/Users/wb558768/reprun-example/main.do
-------------------------------------------------------------------------------------------------------------
````

The output will include tables for each do-file, illustrating the following process:

- __main.do__: The initial check reveals no mismatches in "_main.do_", indicating no discrepancies introduced directly by it.

- __Sub-file 1__ ("_myfile1.do_") : `reprun` steps into "_myfile1.do_", where Line 3 is flagged for mismatches, as shown in Example 3. This table will show the issues specific to "_myfile1.do_".

- __Return to "main.do"__" : After checking "_myfile1.do_", `reprun` returns to "_main.do_". Here, Line 2 is flagged because it calls "_myfile1.do_", reflecting the issues from the sub-file.

- __Sub-file 2__ ("_myfile2.do_"): `reprun` then steps into "_myfile2.do_", where Line 2 is flagged for mismatches, as detailed in Example 5. 

- __Return to "main.do" (final check) __: After checking "_myfile2.do"_, `reprun` returns to "_main.do_". Line 3 in "_main.do_" is flagged due to the issues in "_myfile2.do_" propagating up.

In summary, `reprun` provides a comprehensive view by stepping through each do-file, showing where mismatches occur and how issues in sub-files impact the main do-file.

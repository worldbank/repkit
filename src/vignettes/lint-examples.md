# lint - Stata command for do file linter

This section presents examples for the `lint` command. For more information on the command, please refer to the [helpfile.](https://github.com/worldbank/repkit/blob/add-linter/src/mdhlp/lint.md)

## Requirements

1. Stata version 16 or higher.
2. Python 3 or higher

For setting up Stata to use Python, refer to [Stata's official documentation on Stata-Python integration](https://www.stata.com/python/) or [this article from the Stata blog](https://blog.stata.com/2020/08/18/stata-python-integration-part-1-setting-up-stata-to-use-python/) on how to set up the Stata-Python integration.
`lint` also requires the Python package `pandas` and `openpyxl`.
Refer to [this blog post](https://blog.stata.com/2020/09/01/stata-python-integration-part-3-how-to-install-python-packages/) from the Stata blog to know more about installing Python packages.

## Installation

To install `lint`, type `ssc install repkit` and restart Stata.

## Content

`lint` is an opinionated detector that attempts to improve the readability and organization of Stata do files.
The command is written based on the good coding practices of the Development Impact Evaluation Unit at The World Bank.
For these standards, refer to [DIME's Stata Coding practices](https://dimewiki.worldbank.org/wiki/Stata_Coding_Practices) and _Appendix: The DIME Analytics Stata Style Guide_ of [Development Research in Practice](https://worldbank.github.io/dime-data-handbook/coding.html#the-dime-analytics-stata-style-guide).

The `lint` command can be broken into two functionalities:

1. **detection** identifies bad coding practices in one or multiple Stata do-files
2. **correction** corrects a few of the bad coding practices detected in a Stata do-file

> _Disclaimer_: Please note that this command is not guaranteed to correct codes without changing results.
It is strongly recommended that after using this command you check if results of the do file do not change.

## Syntax and basic usage

### 1. Detection

To detect bad practices in a do-file you can run the following:

```stata
lint "my-dofile.do"
```

To run it on the example do-files provided in this repository, try:

```stata
lint "src/tests/lint/test-files/bad.do"
```

You will get a summary on your Stata console of bad coding practices that were found in your code:

```stata
-------------------------------------------------------------------------------------
Bad practice                                                          Occurrences                   
-------------------------------------------------------------------------------------
Hard tabs used instead of soft tabs:                                  Yes       
One-letter local name in for-loop:                                    3
Non-standard indentation in { } code block:                           7
No indentation on line following ///:                                 1
Missing whitespaces around operators:                                 0
Implicit logic in if-condition:                                       1
Delimiter changed:                                                    1
Working directory changed:                                            0
Lines too long:                                                       5
Global macro reference without { }:                                   0
Use of . where missing() is appropriate:                              6
Backslash detected in potential file path:                            0
Tilde (~) used instead of bang (!) in expression:                     5
-------------------------------------------------------------------------------------
```

If you want to get the lines where those bad coding practices appear you can use the option `verbose`. For example:

```stata
lint "src/tests/lint/test-files/bad.do", verbose
```

gives the following additional information before the regular output of the command.

```stata
(line 14): Use 4 white spaces instead of tabs. (This may apply to other lines as well.)
(line 15): Avoid to use "delimit". For line breaks, use "///" instead.
(line 17): This line is too long (82 characters). Use "///" for line breaks so that one line has at most 80 characters.
(line 25): After declaring for loop statement or if-else statement, add indentation (4 whitespaces).
(line 25): Always explicitly specify the condition in the if statement. (For example, declare "if var == 1" instead of "if var".)
(line 27): After declaring for loop statement or if-else statement, add indentation (4 whitespaces).
(line 32): In for loops, index names should describe what the code is looping over. Do not use an abstract index such as "ii".
(line 33): After new line statement ("///"), add indentation (4 whitespaces).
(line 33): This line is too long (145 characters). Use "///" for line breaks so that one line has at most 80 characters.
(line 34): After declaring for loop statement or if-else statement, add indentation (4 whitespaces).
(line 34): Use "!missing(var)" instead of "var < ." or "var != ." or "var ~= ."
(line 35): This line is too long (145 characters). Use "///" for line breaks so that one line has at most 80 characters.
(line 41): In for loops, index names should describe what the code is looping over. Do not use an abstract index such as "ii".
(line 41): After declaring for loop statement or if-else statement, add indentation (4 whitespaces).
(line 41): This line is too long (193 characters). Use "///" for line breaks so that one line has at most 80 characters.
(line 42): After declaring for loop statement or if-else statement, add indentation (4 whitespaces).
(line 42): Use "!missing(var)" instead of "var < ." or "var != ." or "var ~= ."
(line 43): This line is too long (145 characters). Use "///" for line breaks so that one line has at most 80 characters.
(line 48): After declaring for loop statement or if-else statement, add indentation (4 whitespaces).
(line 48): Use "!missing(var)" instead of "var < ." or "var != ." or "var ~= ."
(line 53): Use "!missing(var)" instead of "var < ." or "var != ." or "var ~= ."
(line 60): Use "!missing(var)" instead of "var < ." or "var != ." or "var ~= ."
(line 69): In for loops, index names should describe what the code is looping over. Do not use an abstract index such as "i".
(line 69): After declaring for loop statement or if-else statement, add indentation (4 whitespaces).
(line 34): Are you using tilde (~) for negation? If so, for negation, use bang (!) instead of tilde (~).
(line 42): Are you using tilde (~) for negation? If so, for negation, use bang (!) instead of tilde (~).
(line 48): Are you using tilde (~) for negation? If so, for negation, use bang (!) instead of tilde (~).
(line 53): Are you using tilde (~) for negation? If so, for negation, use bang (!) instead of tilde (~).
(line 60): Are you using tilde (~) for negation? If so, for negation, use bang (!) instead of tilde (~).
(line 73): Are you taking missing values into account properly? (Remember that "a != 0" or "a > 0" include cases where a is missing.)
```

You can also pass a folder path to detect all the bad practices in all the do-files that are in the same folder. For example:

```stata
lint "src/tests/lint/test-files"
```

will apply the linter to all the do-files in that folder, showing a table output for each of them.

### 2. Correction

If you want to correct bad practices in a do-file you can run the following:

```stata
lint "bad.do" using "bad_corrected.do"   
```

To run this functionality on an example do-file provided int his repository, you can try:

```stata
lint "src/tests/lint/test-files/bad.do" using "src/tests/lint/test-files/bad_corrected.do"
```

The lint command will create a do-file called `bad_corrected.do`.
Stata will ask you if you would like to perform a set of corrections for each bad practice detected, one by one.
You can add the option `automatic` to perform the corrections automatically and skip the manual confirmations.
It is strongly recommended that the output file has a different name from the input file, as the original do-file should be kept as a backup.
If a do-file with the name `bad_corrected.do` already exists in your folder, you can overwrite it with the option `replace`.

As a result of this command, a piece of Stata code as the following:

```stata
#delimit ;

foreach something in something1 something2 something3 something4 something5 something6
  something7 something8{ ; // some comment
  do something ;
} ;

#delimit cr

```

becomes:

```stata
foreach something in something1 something2 something3 something4 something5 ///
  something6 something7 something8 {  // some comment
  do something  
}
```

and

```stata
if something ~= 1 & something != . {
do something
if another == 1 {
do that
}
}
```

becomes

```stata
if something ~= 1 & something != . {
  do something
  if another == 1 {
      do that
  }
}
```

### Other options

You can use the following options with the `lint` command:

- Options related to the **detection** feature:
  - `verbose`: show all the lines where bad practices appear.
  - `nosummary`: suppress the summary of bad practices.
  - `excel()`: export detection results to Excel.

- Options exclusive to the **correction** feature:
  - `automatic`: correct all bad coding practices without asking if you want each bad coding practice detected to be corrected or not.
  - `replace`: replace the existing output file.
  - `force`: allow the output file name to be the same as the name of the input file (not recommended).

- Options for **both** features:
  - `indent()`: specify the number of whitespaces used for indentation (default is 4).
  - `linemax()`: maximum number of characters in a line (default: 80)
  - `space()`: number of whitespaces used instead of hard tabs (default is 4).

## Recommended use

To minimize the risk of crashing a do-file, the `correction` feature works based on fewer rules than the `detection` feature.
That is, it can flag more bad coding practices with `lint "input_file"` than the practices corrected with `lint "input_file" using "output_file"`.
Therefore, after writing a do-file, you can first `detect` bad practices to check how many bad coding practices are contained in the do-file and later decide whether you would like to use the correction feature.

If there are not too many bad practices, you can go through the lines flagged by the `detection` feature and manually correct them.
This also avoids potential crashes by the `correction` feature.

If there are many bad practices detected, you can use the `correction` feature first to correct some of the flagged lines, and then you can `detect` again and `correct` the remaining bad practices manually.
We strongly recommend not overwriting the original input do-file so it can remain as a backup in case `correct` introduces unintended changes in the code.
Additionally, we recommend checking that the results of the do-file are not changed by the correction feature.

## Troubleshooting the Stata-Python integration for users with IT restrictions

In our experience working in Windows computers with IT and admin-access restrictions, the most common problem when executing Python code from Stata is not finding a Python package that is installed in the system.
The reason for this problem is usually that there is more than one Python environment installed in the computer, and Stata is integrated with one of them but the installation of packages from the command line (usually executed with `pip install package-name`) is installing the package for the other environment.
This can be solved with the following steps:

### 1. Check which Python environment is referenced from Stata

Type in the Stata command line `python query` and take note of the Python executable listed next to `set python_exec`. For example:

```
. python query
-----------------------------------------------------------------------------------------------------
    Python Settings
      set python_exec      C:\wbg\Anaconda3\python.exe
      set python_userpath  

    Python system information
      initialized          no
      version              3.9.7
      architecture         64-bit
      library path         C:\wbg\Anaconda3\python39.dll

```

The Python executable for this case is located in `C:\wbg\Anaconda3\python.exe`.

### 2. Point to your Python executable referenced from Stata when using `pip`

Open the Windows command prompt and install any Python libraries with the following command:

```
"path" -m pip install package-name
```

Where `"path"` is the complete file path to the Python executable referenced from Stata, which you know from step 1.
This will tell Windows to use that Python executable for the installation of libraries.
For instance, to install pandas in the example mentioned above, the command would be:

```
C:\wbg\Anaconda3\python.exe -m pip install pandas
```

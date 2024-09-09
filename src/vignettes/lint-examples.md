# lint - Stata command for do file linter

This section presents examples for the `lint` command. For more information on the command, please refer to the [helpfile.](https://github.com/worldbank/repkit/blob/add-linter/src/mdhlp/lint.md)

## Installation

### Installing in Stata

To install `lint`, type `ssc install repkit` and restart Stata.


### Python stand-alone installation

To install the linter to run directly with Python and not via Stata, clone this repository and then run the following command on your terminal:

```python
pip install -e src/
```

This will also install `pandas` and `openpyxl` if they are not currently installed.

## Requirements

1. Stata version 16 or higher.
2. Python 3 or higher

For setting up Stata to use Python, refer to [this web page](https://blog.stata.com/2020/08/18/stata-python-integration-part-1-setting-up-stata-to-use-python/).
`lint` also requires the Python package `pandas` and `openpyxl`.
Refer to [this web page](https://blog.stata.com/2020/09/01/stata-python-integration-part-3-how-to-install-python-packages/) to know more about installing Python packages.

## Content

`lint` is an opinionated detector that attempts to improve the readability and organization of Stata do files.
The command is written based on the good coding practices of the Development Impact Evaluation Unit at The World Bank.
For these standards, refer to [DIME's Stata Coding practices](https://dimewiki.worldbank.org/wiki/Stata_Coding_Practices) and _Appendix: The DIME Analytics Coding Guide_ of [Development Research in Practice](https://worldbank.github.io/dime-data-handbook/).

The `lint` command can be broken into two functionalities:

1. **detection** identifies bad coding practices in one or multiple Stata do-files
2. **correction** corrects a few of the bad coding practices detected in a Stata do-file

> _Disclaimer_: Please note that this command is not guaranteed to correct codes without changing results.
It is strongly recommended that after using this command you check if results of the do file do not change.

## Syntax and basic usage

```stata
lint "input_file" using "output_file", options  
```

### 1. Detection

To detect bad practices in a do-file you can run the following:

```stata
lint "test/bad.do"
```

and on your Stata console you will get a summary of bad coding practices that were found in your code:

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
lint "test/bad.do", verbose
```

Gives the following information before the regular output of the command.

```stata
(line 14): Use 4 white spaces instead of tabs. (This may apply to other lines as well.)
(line 15): Avoid to use "delimit". For line breaks, use "///" instead.
(line 17): This line is too long (82 characters). Use "///" for line breaks so that one line has at m
> ost 80 characters.
(line 25): After declaring for loop statement or if-else statement, add indentation (4 whitespaces).
(line 25): Always explicitly specify the condition in the if statement. (For example, declare "if var
>  == 1" instead of "if var".)
...
```

You can also pass a folder path to detect all the bad practices in all the do-files that are in the same folder.

### 2. Correction

If you would like to correct bad practices in a do-file you can run the following:

```stata
lint "test/bad.do" using "test/bad_corrected.do"   
```

In this case, the lint command will create a do-file called `bad_corrected.do`.
Stata will ask you if you would like to perform a set of corrections for each bad practice detected, one by one.
You can add the option `automatic` to perform the corrections automatically and skip the manual confirmations.
It is strongly recommended that the output file has a different name from the input file, as the original do-file should be kept as a backup.

As a result of this command, a piece of Stata code as the following:

```stata
#delimit ;

foreach something in something something something something something something
  something something{ ; // some comment
  do something ;
} ;

#delimit cr

```

becomes:

```stata
foreach something in something something something something something something ///
  something something {  // some comment
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
  - `tab_space()`: number of whitespaces used instead of hard tabs (default is 4).

## Recommended use

To minimize the risk of crashing a do-file, the `correction` feature works based on fewer rules than the `detection` feature.
That is, we can can detect more bad coding practices with `lint "input_file"` in comparison to `lint "input_file" using "output_file"`.
Therefore, after writing a do-file, you can first `detect` bad practices to check how many bad coding practices are contained in the do-file and later decide whether you would like to use the correction feature.

If there are not too many bad practices, you can go through the lines flagged by the `detection` feature and manually correct them.
This also avoids potential crashes by the `correction` feature.

If there are many bad practices detected, you can use the `correction` feature first to correct some of the flagged lines, and then you can `detect` again and `correct` the remaining bad practices manually.
We strongly recommend not overwriting the original input do-file so it can remain as a backup in case `correct` introduces unintended changes in the code.
Additionally, we recommend checking that the results of the do-file are not changed by the correction feature.


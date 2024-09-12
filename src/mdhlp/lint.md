# Title

__lint__ -  detects and corrects bad coding practices in Stata do-files following the [DIME Analytics Stata Style Guide](https://worldbank.github.io/dime-data-handbook/coding.html#the-dime-analytics-stata-style-guide).

For this command to run, you will need Stata version 16 or greater, Python, and the Python package [Pandas](https://pandas.pydata.org) installed.

To install Python and integrate it with Stata, refer to [this page](https://blog.stata.com/2020/08/18/stata-python-integration-part-1-setting-up-stata-to-use-python/).

To install Python packages, refer to [this page](https://blog.stata.com/2020/09/01/stata-python-integration-part-3-how-to-install-python-packages/).

# Syntax

__lint__ "_input_file_" [using "_output_file_"] , [_options_]

The lint command can be broken into two functionalities:

1. __Detection__ identifies bad coding practices in a Stata do-files

2. __Correction__ corrects bad coding practices in a Stata do-file.

If an _output_file_ is specified with __using__, then the linter will apply the __Correction__ functionality and will write a new file with corrections. If not, the command will only apply the __Detection__ functionality, returning a report of suggested corrections and potential issues of the do-file in Stata's Results window. Users should note that not all the bad practices identified in __Detection__ can be amended by __Correction__.


| _options_ | Description |
|-----------|-------------|
| __**v**erbose__ | Report bad practices and issues found on each line of the do-file. |
| __**nosum**mary__ | Suppress summary table of bad practices and potential issues. |
| __**i**ndent__(_integer_) | Number of whitespaces used when checking indentation coding practices (default: 4). |
| __**s**pace__(_integer_) | Number of whitespaces used instead of hard tabs when checking indentation practices (default: same as indent). | 
| __**l**inemax__(_integer_) | Maximum number of characters in a line when checking line extension practices (default: 80). |
| __**e**xcel__(_filename_) | Save an Excel file of line-by-line results. |
| __force__ | Allow the output file name to be the same as the name of the input file; overwriting the original do-file. __The use of this option is not recommended__ because it is slightly possible that the corrected do-file created by the command will break something in your code and you should always keep a backup of it. |
| __**auto**matic__ | Correct all bad coding practices without asking if you want each bad coding practice to be corrected or not.  By default, the command will ask the user about each correction interactively after producing the summary report. |
| __replace__ | Overwrite any existing _output_ file. |


# Description

## Detect functionality 

__Bad style practices and potential issues detected:__

__Use whitespaces instead of hard tabs__

- Use whitespaces (usually 2 or 4) instead of hard tabs.


__Avoid abstract index names__

- In for-loop statements, index names should describe what the code is looping over. For example, avoid writing code like this:

```
  foreach i of varlist cassava maize wheat { }
``` 

- Instead, looping commands should name the index local descriptively:

```
  foreach crop of varlist cassava maize wheat { }
```


__Use proper indentations__

- After declaring for-loop statements or if-else statements, add indentation with whitespaces (usually 2 or 4) in the lines inside the loop.

    
__Use indentations after declaring newline symbols (///)__

- After a new line statement (///), add indentation (usually 2 or 4 whitespaces).


__Use the "!missing()" function for conditions with missing values__

- For clarity, use `!missing(var)` instead of `var < .` or `var != .`


__Add whitespaces around math symbols (+, =, <, >)__

- For better readability, add whitespaces around math symbols.  For example, do `gen a = b + c if d == e` instead of `gen a=b+c if d==e`.


__Specify the condition in an "if" statement__

- Always explicitly specify the condition in the if statement.  For example, declare `if var == 1` instead of just using `if var`.


__Do not use "#delimit", instead use "///" for line breaks__

- More information about the use of line breaks [here](https://worldbank.github.io/dime-data-handbook/coding.html#line-breaks).


__Do not use cd to change current folder__

- Use absolute and dynamic file paths. More about this [here](https://worldbank.github.io/dime-data-handbook/coding.html#writing-file-paths).


__Use line breaks in long lines__

- For lines that are too long, use `///` to divide them into multiple lines.  It is recommended to restrict the number of characters in a line to 80 or less.


__Use curly brackets for global macros__

- Always use `${ }` for global macros.  For example, use `${global_name}` instead of `$global_name`.


__Include missing values in condition expressions__

- Condition expressions like `var != 0` or `var > 0` are evaluated to true for missing values. Make sure to explicitly take missing values into account by using `missing(var)` in expressions.


__Check if backslashes are not used in file paths__

- Check if backslashes `(\)` are not used in file paths. If you are using them, then replace them with forward slashes `(/)`. Users should note that the linter might not distinguish perfectly which uses of a backslash are file paths. In general, this flag will come up every time a backslash is used in the same line as a local, glocal, or the cd command.


__Check if tildes (~) are not used for negations__

- If you are using tildes `(~)` are used for negations, replace them with bangs `(!)`.

## Correct functionality

__Coding practices to be corrected:__


Users should note that the Correct feature does not correct all the bad practices detected.  It only corrects the following:

- Replaces the use of `#delimit` with three forward slashes `(///)` in each line affected by `#delimit`

- Replaces hard tabs with soft spaces (4 by default). The amount of spaces can be set with the `tab_space()` option

- Indents lines inside curly brackets with 4 spaces by default. The amount of spaces can be set with the `indent()` option

- Breaks long lines into multiple lines. Long lines are considered to have more than 80 characters by default, but this setting can be changed with the option `linemax()`.  Note that lines can only be split in whitespaces that are not inside parentheses, curly brackets, or double quotes. If a line does not have any whitespaces, the linter will not be able to break a long line.

- Adds a whitespace before opening curly brackets, except for globals

- Removes redundant blank lines after closing curly brackets

- Removes duplicated blank lines

If the option `automatic` is omitted, Stata will prompt the user to confirm that they want to correct each of these bad practices only in case they are detected.  If none of these are detected, it will show a message saying that none of the bad practices it can correct were detected.


# Examples

The following examples illustrate the basic usage of lint. Additional examples can be found [here](https://github.com/worldbank/repkit/blob/add-linter/src/vignettes/lint-examples.md)
 
## Detecting bad coding practices

The basic usage is to point to a do-file that requires revision as follows:

```
lint "test/bad.do"
```

For the detection feature you can use all the options but _automatic_, _force_, and _replace_, which are part of the correction functionality.

__**Options:**__

1. Show bad coding practices line-by-line

```
lint "test/bad.do", verbose
```

 2. Remove the summary of bad practices
 
```
lint "test/bad.do", nosummary
```

3. Specify the number of whitespaces used for detecting indentation practices (default: 4):

```
lint "test/bad.do", indent(2)
```


4. Specify the number of whitespaces used instead of hard tabs for detecting indentation practices (default: same value used in indent):

```
lint "test/bad.do", tab_space(6)
```


5. Specify the maximum number of characters in a line allowed when detecting line extension (default: 80):

```
lint "test/bad.do", linemax(100)
```


6. Export to Excel the results of the line by line analysis

```
lint "test/bad.do", excel("test_dir/detect_output.xlsx")
```

7. You can also use this command to test all the do-files in a folder:

```
lint "test/"
```

## Correcting bad coding practices

The basic usage of the correction feature requires to specify the input do-file and the output do-file that will have the corrections. If you do not include any options, the linter will ask you confirm if you want a specific bad practice to be corrected for each bad practice detected:

1. Basic correction use (the linter will ask what to correct):

```
lint "test/bad.do" using "test/bad_corrected.do"
```


2. Automatic use (Stata will correct the file automatically):

```
lint "test/bad.do" using "test/bad_corrected.do", automatic
```


3. Use the same name for the output file (note that this will overwrite the input file, this is not recommended):

```
lint "test/bad.do" using "test/bad.do", automatic force
```


4. Replace the output file if it already exists

```
lint "test/bad.do" using "test/bad_corrected.do", automatic replace
```


# Feedback, bug reports and contributions

Read more about these commands on [this repo](https://github.com/worldbank/repkit) where this package is developed. Please provide any feedback by [opening an issue](https://github.com/worldbank/repkit/issues). PRs with suggestions for improvements are also greatly appreciated.

# Authors

DIME Analytics, The World Bank dimeanalytics@worldbank.org


# Linting rules

This article lists the linting rules that the `lint` command detects and can optionally correct. For a more detailed discussion about these rules, see the DIME Analytics [Stata Style Guide](https://worldbank.github.io/dime-data-handbook/coding.html#the-dime-analytics-stata-style-guide).

## Bad style practices and potential issues detected:

### Use whitespaces instead of hard tabs

Use whitespaces (usually 2 or 4) instead of hard tabs.

### Avoid abstract index names

In for-loop statements, index names should describe what the code is looping over. For example, avoid writing code like this:

```
    foreach i of varlist cassava maize wheat { }
```

Instead, looping commands should name the index local descriptively:

```
    foreach crop of varlist cassava maize wheat { }
```

### Use proper indentation

After declaring for-loop or if-else statements, add indentation with whitespaces (usually 2 or 4) to the lines inside the loop.

### Use indentation after declaring newline symbols `///`

After a new line statement `///`, add indentation (usually 2 or 4 whitespaces).

### Use the `!missing()` function for conditions with missing values

For clarity, use `!missing(var)` instead of `var < .` or `var != .`

### Add whitespaces around math symbols (`+`, `=`, `<`, `>`)

For better readability, add whitespaces around math symbols. For example, use `gen a = b + c if d == e` instead of `gen a=b+c if d==e`.

### Specify the condition in an `if` statement

Always explicitly specify the condition in the if statement. For example, write `if var == 1` instead of just `if var`.

### Do not use `#delimit`; instead, use `///` for line breaks

More information about the use of line breaks [here](https://worldbank.github.io/dime-data-handbook/coding.html#line-breaks).

### Do not use cd to change the current folder

Use absolute and dynamic file paths. More about this [here](https://worldbank.github.io/dime-data-handbook/coding.html#writing-file-paths).

### Use line breaks in long lines

For lines that are too long, use `///` to divide them into multiple lines. 
It is recommended to restrict the number of characters in a line to 80 or less.

### Use curly brackets for global macros

Always use `${ }` for global macros. For example, use `${global_name}` instead of `$global_name`.

### Include missing values in condition expressions

Condition expressions like `var != 0` or `var > 0` are evaluated to true for missing values. 
Make sure to explicitly take missing values into account by using `missing(var)` in expressions.

### Check that backslashes (`\`) are not used in file paths

Check that backslashes `\` are not used in file paths. If you are using them, replace them with forward slashes `/`. 
Users should note that the linter might not perfectly distinguish which uses of a backslash are file paths. 
In general, this flag will come up every time a backslash is used in the same line as a local, global, or the cd command.

### Check that tildes `~` are not used for negations

If you are using tildes `~` for negations, replace them with bangs `!`.

## Correction functionality

### Coding practices to be corrected:

Users should note that the Correct feature does not correct all the bad practices detected. It only corrects the following:

- Replaces the use of `#delimit` with three forward slashes `///` in each line affected by `#delimit`
- Replaces hard tabs with soft spaces (4 by default). The number of spaces can be set with the `tab_space()` option
- Indents lines inside curly brackets with 4 spaces by default. The number of spaces can be set with the `indent()` option
- Breaks long lines into multiple lines. Long lines are considered to have more than 80 characters by default, but this setting can be changed with the option `linemax()`. Note that lines can only be split at whitespaces that are not inside parentheses, curly brackets, or double quotes. If a line does not have any whitespaces, the linter will not be able to break a long line.
- Adds a whitespace before opening curly brackets, except for globals
- Removes redundant blank lines after closing curly brackets
- Removes duplicated blank lines

If the `automatic` option is omitted, Stata will prompt the user to confirm that they want to correct each of these bad practices only if they are detected. If none of these are detected, it will show a message saying that none of the bad practices it can correct were detected.




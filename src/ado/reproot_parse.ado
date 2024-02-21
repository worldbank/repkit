*! version 1.1 20230822 - DIME Analytics & LSMS Team, The World Bank - dimeanalytics@worldbank.org, lsms@worldbank.org

cap program drop   reproot_parse
    program define reproot_parse, rclass

qui {

    version 14.1
    
    * Update the syntax. This is only a placeholder to make the command run
    syntax anything, file(string)

    if ("`anything'" == "env")       {
      reproot_parse_env , file("`file'")
      return local envpaths = `"`r(envpaths)'"'
      return local skipdirs = `"`r(skipdirs)'"'
    }
    else if ("`anything'" == "root") {
      reproot_parse_root, file("`file'")
      return local project = `"`r(project)'"'
      return local root    = `"`r(root)'"'
    }
    else {
      noi di as error "{ptsd}reproot_parse: incorrect subcommand [`anything']{p_end}"
      error 198
      exit
    }
}
end

cap program drop   reproot_parse_env
    program define reproot_parse_env, rclass

    syntax, file(string)

    local paths    ""
    local skipdirs ""
    local recursedepth 31 // Default depth = Stata max recursion

    /**********************************************************
      READ YAML FILE LINE BY LINE
    **********************************************************/

    * Open template to read from and new tempfile to write to
    tempname   re_file
    file open `re_file' using "`file'", read
    file read `re_file' line

    local linenum = 1

    * Read YAML content into string
    while r(eof)==0 {

      // noi di ""
      // noi di `"`line'"'
      local this_indent = 0
      local this_keyword = ""
      local this_value   = ""
      local valid_value = 0

      * Count indent of this line - and set indent dependent locals
      count_indent, line(`"`line'"')
      local this_indent = "`r(indent)'"
      if (`this_indent' == 0) {
        local is_list 0
        local list_of ""
      }

      * Trim line to remove indent
      local line = trim(`"`line'"')

      *****************************************
      * Parse items that are part of a list
      if (`is_list' == 1) {
        parse_listitem, line(`"`line'"') allowed_value("string")
        local this_value   = `"`r(list_value)'"'
        if (`r(valid_value)' == 0) {
          noi di as error `"{pstd}Invalid list item on line `linenum' in file [`file']: [`line']{p_end}"'
          error 98
        }
        * Add to local named after the key word this list is part of, paths etc.
        local `list_of' `"``list_of'' `this_value'"'
      }

      *****************************************
      * Parse top level keywords

      else {
        parse_keyword, line(`"`line'"') ///
          allowed_keys("paths skipdirs recursedepth")
        local this_keyword = "`r(keyword)'"
        local this_value   = `"`r(value)'"'

        if ("`this_keyword'" == "paths") {
          parse_value, value(`"`this_value'"') allowed_values("list string")
          local valid_value = `r(valid_value)'
        }
        else if ("`this_keyword'" == "skipdirs") {
          parse_value, value(`"`this_value'"') allowed_values("list string")
          local valid_value = `r(valid_value)'
        }
        else if ("`this_keyword'" == "recursedepth") {
          parse_value, value(`"`this_value'"') allowed_values("number")
          local valid_value = `r(valid_value)'
        }
        else {
          noi di as error `"{pstd}Icorrect keyword used on line `linenum' in file [`file']: [`line']{p_end}"'
          error 98
        }

        * Output error if invalid value
        if (`valid_value' == 0) {
          noi di as error `"{pstd}In valid value in file [`file'] on line `linenum': [`line']{p_end}"'
          error 98
        }

        * Unless value is beginning of list, add the value to this keyword
        if (`"`this_value'"' != "begin_list") {
          local `this_keyword' `"`this_value'"'
        }
        else {
          local is_list = 1
          local list_of = "`this_keyword'"
        }
      }

      * Read next line
      file read `re_file' line
      local linenum = 1 + `linenum'
    }

    /**********************************************************
      PREPARE VALUES TO RETURN
    **********************************************************/

    * Add default recurse depth if path does not have custom depth
    local formatted_paths ""
    foreach path of local paths {
      noi prepend_recdepth , path(`path') recursedepth(`recursedepth')
      local formatted_paths `"`formatted_paths' "`r(path)'" "'
    }

    return local envpaths = trim(`"`formatted_paths'"')
    return local skipdirs `"`skipdirs'"'
end

cap program drop   reproot_parse_root
    program define reproot_parse_root, rclass

    * Update the syntax. This is only a placeholder to make the command run
    syntax, file(string)

    /**********************************************************
      READ YAML FILE LINE BY LINE
    **********************************************************/

    * Open template to read from and new tempfile to write to
    tempname   re_file
    file open `re_file' using "`file'", read
    file read `re_file' line

    local linenum = 1

    while r(eof)==0 {

      local this_indent = 0
      local this_keyword = ""
      local this_value   = ""
      local valid_value = 0

      * Make sure that the root file does not have any indent
      count_indent, line(`"`line'"')
      if (`r(indent)' != 0) {
        noi di as error `"{pstd}The root file [`file'] has an indent in line `linenum': [`line']. The root file is not allowed to have any indents.{p_end}"'
        error 98
        exit
      }

      * Trim line to remove indent
      local line = trim(`"`line'"')

      * Parse the line for keyword and value
      parse_keyword, line(`"`line'"') allowed_keys("project_name root_name")
      local this_keyword = trim("`r(keyword)'")
      local this_value   = trim("`r(value)'")

      if ("`this_keyword'" == "project_name") {
        parse_value, value(`"`this_value'"') allowed_values("string")
        local valid_value = `r(valid_value)'
      }
      else if ("`this_keyword'" == "root_name") {
        parse_value, value(`"`this_value'"') allowed_values("string")
        local valid_value = `r(valid_value)'
      }
      else {
        noi di as error `"{pstd}Incorrect keyword used on line `linenum' in file [`file']: [`line']{p_end}"'
        error 98
      }

      * Add value named after this
      local `this_keyword' `"`this_value'"'

      * Read next line
      file read `re_file' line
      local linenum = 1 + `linenum'
    }

    * Test that both required keywords were used
    local has_required_keys = 1
    if missing("`project_name'") local has_required_keys = 0
    if missing("`root_name'")    local has_required_keys = 0
    if (`has_required_keys'==0) {
      noi di as error `"{pstd}The root file [`file'] is missing at least one of the keywords project and root. Both are required{p_end}"'
      error 98
      exit
    }

    * Return rpoject and root
    return local project = trim("`project_name'")
    return local root    = trim("`root_name'")

end


* Parse out keyword from top level item
cap program drop   parse_keyword
    program define parse_keyword, rclass

    syntax, line(string) [allowed_keys(string)]

    * Parse key and value from line
    gettoken keyword value : line, parse(": ")

    * Trim and clean the locals
    local keyword = trim("`keyword'")
    local value = trim(subinstr(`"`value'"',":","",1))

    if !missing("`allowed_keys'") & !(`: list keyword in allowed_keys') {
      noi di as error `"{pstd}The keyword [`keyword'] in line [`line'] is not allowed in the context it is used. Allowed keywords in that context are: [`allowed_keys'].{p_end}"'
      error 99
    }
    else {
      if missing(`"`value'"') local value "begin_list"
      * Return the indend
      return local keyword `"`keyword'"'
      return local value   `"`value'"'
    }
end

cap program drop   parse_value
    program define parse_value, rclass

    syntax, value(string) allowed_values(string)

    local valid = 0

    * Test if valid number
    if (strpos("`allowed_values'","number")) {
      cap confirm number `value'
      if (_rc != 7) local valid = 1
    }

    * Test if valid list
    if (strpos("`allowed_values'","list")) {
      if (`"`value'"' == "begin_list") local valid = 1
    }

    * Test if valid dpuble quoted string with cahr(34) (i.e. ")
    * as first and last character
    if (strpos("`allowed_values'","string")) {
      * Test that first and last charchter is char(34) - (.i.e ")
      local c1 = (substr(`"`macval(value)'"',1,1) == char(34))
      local c2 = (substr(strreverse(`"`macval(value)'"'),1,1) == char(34))
      * test that the string do not have more than 2 char(34) - (.i.e ")
      local s1 = !(strpos(subinstr(`"`macval(value)'"',char(34),"",2),char(34)))

      * Test that all above resulted in valid
      if ((`c1') & (`c2') & (`s1')) local valid = 1
    }

    return local valid_value `valid'

end

cap program drop   parse_listitem
    program define parse_listitem, rclass

    syntax, line(string) allowed_value(string)

    local valid = 1

    * Parse key and value from line
    gettoken bullet value : line
    if (trim(`"`bullet'"') != "-") local valid = 0

    local value = trim(`"`value'"')

    parse_value, value(`"`value'"') allowed_values("`allowed_value'")
    if (`r(valid_value)' == 0) local valid = 0

    return local list_value  `"`value'"'
    return local valid_value `valid'

end

cap program drop   prepend_recdepth
    program define prepend_recdepth, rclass

    syntax , path(string) recursedepth(numlist)

    * Get part before first :
    gettoken depth : path, parse(":")

    * Test if part before : is a valid depth, otherwise add general depth
    cap confirm number `depth'
    if (_rc) local returnpath `"`recursedepth':`path'"'
    else     local returnpath `"`path'"'

    return local path `"`returnpath'"'
end

* Count indents, throws error if any non-standard single space is used.
cap program drop   count_indent
    program define count_indent, rclass

    syntax, line(string)

    * Get the line length
    local linelen = strlen(`"`line'"')
    * Initiate locals
    local i             = 0
    local indent_count  = 0

    * Loop over each character
    while (`i'<`linelen') {
      * Get next character
      local c = substr(`"`line'"',`++i',1)

      * increment indent with 1 if a regular space
      if (`"`c'"' == char(32)) {
        local indent_count = 1 + `indent_count'
      }
      * Test for non standard whitespaces (tabs etc)
      * This list comes from https://www.stata.com/manuals/fnstringfunctions.pdf
      * in str function ustrltrim
      else if inlist(`"`c'"',char(9),char(10),char(11),char(12),char(13)) {
        * Set indent count to -1 and terminate while loop if found
        local indent_count = -1
        local i = `linelen'
      }
      * If non-whitespace then terminate while loop as no more indent
      else local i = `linelen'
    }

    * Return the indend
    return local indent `indent_count'
end

adopath + "C:\Users\WB462869\github\repkit\src\ado"

cap program drop   reproot_output_test2
    program define reproot_output_test2, rclass

    version 14.1

    syntax, recursion_depth(numlist) searchpath(string)
//     syntax [anything]

    noi di "oi"
    noi di "recursion_depth: `recursion_depth'"
    noi di "searchpath: `searchpath'"
end


cap program drop   reprootdefaults
    program define reprootdefaults, rclass

    version 14.1
    
    noi di "reprootdefaults"
    
    local rd 4 //get dynamically from envfile
    
    return scalar recdepth = `rd'
    return local  spath1_text = "testoi"

end

cap program drop   reproot_setup2
    program define reproot_setup2

    version 14.1

    syntax,
    
    reprootdefaults
    return list
    db reproot
end

reproot_setup2




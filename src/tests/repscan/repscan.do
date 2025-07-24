
// Basic functionality
display("Scanning a do-file, critical checks only")
repscan "../tests/repscan/test-files/bad.do"

// Advanced functionality
display("Scanning a do-file, all checks")
repscan "../tests/repscan/test-files/bad.do", complete

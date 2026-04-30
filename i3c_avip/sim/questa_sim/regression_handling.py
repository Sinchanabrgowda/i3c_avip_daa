import os
import sys

if len(sys.argv) < 2:
    print("Usage: python regression_handling.py <testlist>")
    sys.exit(1)

testlist = sys.argv[1]

with open(testlist, 'r') as f:
    tests = [line.strip() for line in f if line.strip() and not line.startswith("#")]

for test in tests:
    print("Running test: {}".format(test))
    
    cmd = "make simulate test={}".format(test)
    ret = os.system(cmd)
    
    if ret != 0:
        print("Test FAILED: {}".format(test))
    else:
        print("Test PASSED: {}".format(test))

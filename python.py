import os
import subprocess
import string
import sys
import datetime

filepath = "backup/python.txt"

try:
    cmd = "pip list"
    result = subprocess.check_output(cmd, shell=True)
    result = result.replace(" (", "%%")
    result = result.replace(")"," ")
    result = result.replace("\n", "\n##")
    f = open(filepath, 'wb')
    f.write("##")
    f.write(result)
    f.close()

    print "Python env backup success!"
except:
    print "Error: Python backup fail"

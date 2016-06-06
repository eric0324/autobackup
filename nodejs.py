# -*- coding: utf-8 -*-
import os
import sys
import subprocess
import string
import re

filepath = "backup/nodejs.txt"

try:
    cmd = "npm ls -g"
    result = subprocess.check_output(cmd, shell=True)
    result = result.replace("@", "%%")
    result2 = re.sub(r'((│|├|└)\s(┬|─|└|├|└)*)|((├|└)(┬|─|└|├|└)*)', "##", result)
    result = re.sub(r'(##)((\s)^|(##)*)*', "##", result2)
    result = result.replace("##  ##", "##")
    result = result.replace("##    ##", "##")
    result = result.replace("##      ##", "##")
    result = result.replace("  ## ", "##")
    result = result.replace("## ", "")
    result = result.replace("  /usr/local/lib", "")
    f = open(filepath, 'wb')
    f.write("  ")
    f.write(result)
    f.close()

    print "NodeJS env backup success!"
except:
    print "Error: NodeJS backup fail"

# -*- coding: utf-8 -*-
import os
import sys
import subprocess
import string
import re

filepath = "backup/atom_backup.txt"

try:
    cmd = "apm list --bare"
    result = subprocess.check_output(cmd, shell=True)
    result = result.replace("@", "%%")
    result = result.replace("\n", "\n##")
    result = result.replace("####", "")
    f = open(filepath, 'wb')
    f.write("##")
    f.write(result)
    f.close()

    print "Atom env backup success!"
except:
    print "Error: Atom backup fail"

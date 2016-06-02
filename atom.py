# -*- coding: utf-8 -*-
import os
import sys
import subprocess
import string
import re

def backup():
    cmd = "apm list --bare"
    result = subprocess.check_output(cmd, shell=True)
    result = result.replace("@", "%%")
    result = result.replace("\n", "##")
    result = result.replace("####", "")
    print result
    f = open('atom_backup.txt', 'wb')
    f.write("##")
    f.write(result)
    f.close()

    print "Atom env backup success!"


def reinstall():
    argv = sys.argv

    cmd = "apm install " + argv[2]
    result = subprocess.check_output(cmd, shell=True)
    print "Reduce " + argv[2] + " success!"


#Main function
argv = sys.argv

if argv[1] == '-b':
    backup()
elif argv[1] == '-r':
    reinstall()

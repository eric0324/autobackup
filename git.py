# -*- coding: utf-8 -*-
import os
import sys
import subprocess
import string
import re

def backup():
    cmd = "cat ~/.gitconfig"
    result = subprocess.check_output(cmd, shell=True)
    f = open('.gitconfig', 'wb')
    f.write(result)
    f.close()

    print "Git env backup success!"


def reinstall():
    cmd = "cp .gitconfig ~/.gitconfig"
    subprocess.check_output(cmd, shell=True)
    print "Reduce success!"


#Main function
argv = sys.argv

if argv[1] == '-b':
    backup()
elif argv[1] == '-r':
    reinstall()

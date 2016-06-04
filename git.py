# -*- coding: utf-8 -*-
import os
import sys
import subprocess
import string
import re

def backup():
    cmd = "cp -p ~/.gitconfig ~/.`whoami`_env/git"
    result = subprocess.check_output(cmd, shell=True)
    #print "Git env backup success!"


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
elif argv[1] == '-c':
    cmd = 'find ~/ -name ".gitconfig" -mtime -1'
    result = subprocess.check_output(cmd, shell=True)
    if result == '.gitconfig':
        backup()

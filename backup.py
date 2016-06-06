# -*- coding: utf-8 -*-
import os
import sys
import subprocess
import string
import re

argv = sys.argv

def allBackup():
    python()
    ruby()
    nodejs()
    git()
    atom()
    vim()

def python():
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

def ruby():
    filepath = "backup/ruby.txt"

    try:
        cmd = "gem list --local"
        result = subprocess.check_output(cmd, shell=True)
        result = result.replace(" (", "%%")
        result = result.replace(")"," ")
        result = result.replace("\n", "\n##")

        f = open(filepath, 'wb')
        f.write("##")
        f.write(result)
        f.close()

        print "Ruby env backup success!"
    except:
        print "Error: Ruby backup fail"

def nodejs():
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


def git():
    try:
        cmd = "cp -p ~/.gitconfig backup"
        result = subprocess.check_output(cmd, shell=True)
        print "Git env backup success!"
    except:
        print "Error: Git backup fail"


def atom():
    filepath = "backup/atomg.txt"

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

def vim():
    print "Do something"

#Main function

if argv[1] == '-all':
    allBackup()
elif argv[1] == '-python':
    python()
elif argv[1] == '-ruby':
    ruby()
elif argv[1] == '-nodejs':
    nodejs()
elif argv[1] == '-git':
    git()
elif argv[1] == '-atom':
    atom()
elif argv[1] == '-vim':
    vim()

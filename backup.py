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
    filepath = "~/env_backup/python"

    try:
        print "Start python backup",
        cmd = "pip list"
        result = subprocess.check_output(cmd, shell=True)
        result = result.replace(" (", "%%")
        result = result.replace(")"," ")
        result = result.replace("\n", "\n##")
        f = open(filepath, 'wb')
        f.write("##")
        f.write(result)
        f.close()

        print " ..done"
    except:
        print "Error: Python backup fail"

def ruby():
    filepath = "~/env_backup/ruby"

    try:
        print "Start Ruby backup",
        cmd = "gem list --local"
        result = subprocess.check_output(cmd, shell=True)
        result = result.replace(" (", "%%")
        result = result.replace(")"," ")
        result = result.replace("\n", "\n##")

        f = open(filepath, 'wb')
        f.write("##")
        f.write(result)
        f.close()

        print " ..done"
    except:
        print "Error: Ruby backup fail"

def nodejs():
    filepath = "~/env_backup/nodejs"

    try:
        print "Start NodeJS backup",

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

        print "Start NodeJS backup ..done"
    except:
        print "Error: NodeJS backup fail"


def git():
    try:
        print "Start Git backup",
        cmd = "cp -p ~/.gitconfig ~/env_backup"
        result = subprocess.check_output(cmd, shell=True)
        cmd = "mv ~/env_backup/.gitconfig ~/env_backup/git"
        result = subprocess.check_output(cmd, shell=True)
        print " ..done"
    except:
        print "Error: Git backup fail"


def atom():
    filepath = "~/env_backup/atom"

    try:
        print "Start Atom backup",
        cmd = "apm list --bare"
        result = subprocess.check_output(cmd, shell=True)
        result = result.replace("@", "%%")
        result = result.replace("\n", "\n##")
        result = result.replace("####", "")
        f = open(filepath, 'wb')
        f.write("##")
        f.write(result)
        f.close()

        print " ..done"
    except:
        print "Error: Atom backup fail"

def vim():
    try:
        print "Start Vim backup",
    	cmd = "cp -p ~/.vimrc ~/env_backup/vim"
    	result = subprocess.check_output(cmd, shell=True)
        cmd = "mv ~/env_backup/.vimrc ~/env_backup/vim"
        result = subprocess.check_output(cmd, shell=True)

    	print " ..done"
    except:
	print "Error: Vim backup fail"

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

# -*- coding: utf-8 -*-
import os
import sys
import subprocess
import string
import re

argv = sys.argv

#Restore all
def allRecovery():
    python()
    ruby()
    nodejs()
    git()
    atom()
    vim()

def python():
    cmd = "rm -rf ~/usr/local/lib/python2.7/dist-packages"
    result = subprocess.check_output(cmd, shell=True)
    cmd = "cat backup/python.txt"
    result = "sudo pip install "
    result += subprocess.check_output(cmd, shell=True)
    result = result.replace("##", "")
    result2 = re.sub(r'%%(\d|\.)*', "", result)
    result2 = result2.replace("\n", "")

    #print result2

    result = subprocess.check_output(result2, shell=True)

    print "Python env recovery success!"

def ruby():
    cmd = "sudo gem uninstall -aIx"
    result = subprocess.check_output(cmd, shell=True)
    cmd = "cat backup/ruby.txt"
    result = subprocess.check_output(cmd, shell=True)
    result = result.replace("##", "sudo gem install ")
    result2 = re.sub(r'%%(\d|\.|\s|,)*', "\n", result)
    resul2 = result.replace("x86_64-darwin-14, 3.16.14.11 x86_64-darwin-14", "")

    result = subprocess.check_output(result2, shell=True)

    print "Python env recovery success!"


def nodejs():

    cmd = "sudo rm -rf ~/.local/lib/node_modules"
    result = subprocess.check_output(cmd, shell=True)
    cmd = "cat backup/nodejs.txt"
    result = subprocess.check_output(cmd, shell=True)
    result = result.replace("##", "sudo npm install -g ")
    result2 = re.sub(r'%%(\d|\.|\s|,)*', "\n", result)
    result2 = result2.replace("-rc4", "")

    result = subprocess.check_output(result2, shell=True)

    print "Nodejs env recovery success!"

def git():
    cmd = "cp -p backup/.gitconfig ~/.gitconfig"
    result = subprocess.check_output(cmd, shell=True)
    print "Git env recovery success!"

def atom():
    cmd = "rm -rf ~/.atom/packages"
    result = subprocess.check_output(cmd, shell=True)
    cmd = "cat backup/atom.txt"
    result = subprocess.check_output(cmd, shell=True)
    result = result.replace("##", "sudo apm install ")
    result2 = re.sub(r'%%(\d|\.)*', "", result)

    result = subprocess.check_output(result2, shell=True)

    print "Atom env recovery success!"


def vim():
    print "do something"
    #TO-DO



#Main function

argv = sys.argv

try:
    if argv[1] == '-all':
        allRecovery()
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
except:
    print "Wrong argument."

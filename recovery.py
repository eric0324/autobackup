# -*- coding: utf-8 -*-
import os
import sys
import subprocess
import string
import re

argv = sys.argv

#Processing backup path
cmd = "cat .config"
result = subprocess.check_output(cmd, shell=True)
path = re.split("DESDIR=([^\n]+)", result)
#print path[1]

#Restore all
"""
def allRecovery():
    python()
    ruby()
    nodejs()
    git()
    atom()
    vim()
"""

def python():

    cmd = "apt-get install python-pip"
    result = subprocess.check_output(cmd, shell=True)

    cmd = "rm -rf ~/usr/local/lib/python2.7/dist-packages"
    result = subprocess.check_output(cmd, shell=True)
    cmd = "cat " + path[1] + "/python"
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
    cmd = "cat " + path[1] + "/ruby"
    result = subprocess.check_output(cmd, shell=True)
    result = result.replace("##", "sudo gem install ")
    result2 = re.sub(r'%%(\d|\.|\s|,)*', "\n", result)
    resul2 = result.replace("x86_64-darwin-14, 3.16.14.11 x86_64-darwin-14", "")

    result = subprocess.check_output(result2, shell=True)

    print "Python env recovery success!"


def nodejs():

    cmd = "sudo rm -rf ~/.local/lib/node_modules"
    result = subprocess.check_output(cmd, shell=True)
    cmd = "cat " + path[1] + "/nodejs"
    result = subprocess.check_output(cmd, shell=True)
    result = result.replace("##", "sudo npm install -g ")
    result2 = re.sub(r'%%(\d|\.|\s|,)*', "\n", result)
    result2 = result2.replace("-rc4", "")

    result = subprocess.check_output(result2, shell=True)

    print "Nodejs env recovery success!"

def git():
    cmd = "mv ~/env_backup/git ~/env_backup/.gitconfig"
    result = subprocess.check_output(cmd, shell=True)
    cmd = "cp -p " + path[1] + "/.gitconfig ~/.gitconfig"
    result = subprocess.check_output(cmd, shell=True)
    print "Git env recovery success!"

def atom():
    cmd = "rm -rf ~/.atom/packages"
    result = subprocess.check_output(cmd, shell=True)
    cmd = "cat " + path[1] + "/atom"
    result = subprocess.check_output(cmd, shell=True)
    result = result.replace("##", "sudo apm install ")
    result2 = re.sub(r'%%(\d|\.)*', "", result)

    result = subprocess.check_output(result2, shell=True)

    print "Atom env recovery success!"


def vim():
    cmd = "cp -p " + path[1] + "/vim ~/.vimrc"
    result = subprocess.check_output(cmd, shell=True)
    cmd = "vim +PluginInstall +qall"
    result = subprocess.check_output(cmd, shell=True)
    cmd = "vim +PluginClean +qall"
    result = subprocess.check_output(cmd, shell=True)

    print "Vim env recovery success!"



#Main function

argv = sys.argv

envArgv  = argv[1];
argv[1] = re.sub(r'-', "", argv[1])

cmd = "cd " + path[1] + " && git checkout " + argv[2] + " " + argv[1]
result = subprocess.check_output(cmd, shell=True)

try:
    if envArgv == '-python':
        python()
    elif envArgv == '-ruby':
        ruby()
    elif envArgv == '-nodejs':
        nodejs()
    elif envArgv == '-git':
        git()
    elif envArgv == '-atom':
        atom()
    elif envArgv == '-vim':
        vim()
except:
    print "Wrong argument."

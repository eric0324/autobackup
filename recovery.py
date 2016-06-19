# -*- coding: utf-8 -*-
import os
import sys
import subprocess
import string
import re

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

    cmd = "sudo apt-get install python-pip"
    result = subprocess.check_output(cmd, shell=True)

    cmd = "sudo rm -rf /usr/local/lib/python2.7/dist-packages"
    result = subprocess.check_output(cmd, shell=True)
    cmd = "cat " + path + "/python"
    result = "sudo pip install "
    result += subprocess.check_output(cmd, shell=True)
    result = result.replace("##", "")
    result2 = re.sub(r'%%(\d|\.)*', "", result)
    result2 = result2.replace("\n", "")

    #print result2

    result = subprocess.check_output(result2, shell=True)

    print "Python env recovered successully!"

def ruby():
    cmd = "sudo gem uninstall -aIx"
    result = subprocess.check_output(cmd, shell=True)
    cmd = "cat " + path + "/ruby"
    result = subprocess.check_output(cmd, shell=True)
    result = result.replace("##", "sudo gem install ")
    result2 = re.sub(r'%%(\d|\.|\s|,)*', "\n", result)
    resul2 = result.replace("x86_64-darwin-14, 3.16.14.11 x86_64-darwin-14", "")

    result = subprocess.check_output(result2, shell=True)

    print "Python env recovered successully!"


def nodejs():

    cmd = "sudo rm -rf ~/.local/lib/node_modules"
    result = subprocess.check_output(cmd, shell=True)
    cmd = "cat " + path + "/nodejs"
    result = subprocess.check_output(cmd, shell=True)
    result = result.replace("##", "sudo npm install -g ")
    result2 = re.sub(r'%%(\d|\.|\s|,)*', "\n", result)
    result2 = result2.replace("-rc4", "")

    result = subprocess.check_output(result2, shell=True)

    print "Nodejs env recovered successully!"

def git():
    cmd = "cp -p " + path + "/git ~/.gitconfig"
    result = subprocess.check_output(cmd, shell=True)
    print "Git env recovery success!"

def atom():
    cmd = "rm -rf ~/.atom/packages"
    result = subprocess.check_output(cmd, shell=True)
    cmd = "cat " + path + "/atom"
    result = subprocess.check_output(cmd, shell=True)
    result = result.replace("##", "sudo apm install ")
    result2 = re.sub(r'%%(\d|\.)*', "", result)

    result = subprocess.check_output(result2, shell=True)

    print "Atom env recovered successully!"


def vim():
    cmd = "cp -p " + path + "/vim ~/.vimrc"
    result = subprocess.check_output(cmd, shell=True)
    cmd = "vim +PluginClean! +qall 2> /dev/null"
    result = subprocess.check_output(cmd, shell=True)
    cmd = "vim +PluginInstall +qall 2> /dev/null"
    result = subprocess.check_output(cmd, shell=True)
    
    vim_plugins = open(os.path.expanduser('~/.vimrc'), 'r')
    for line in vim_plugins:
	line = os.linesep.join([s for s in line.splitlines() if s])
        if line == ("Plugin 'Valloric/YouCompleteMe'"):

            print "YouCompleteMe Plugin detected:\n\tInstalling required component(s):\n\t\tcmake"
            cmd = "sudo apt-get install build-essential cmake"
            result = subprocess.check_output(cmd, shell=True)
            print "\t...done\n"

            print "Required component(s) installed.\n\n******\nPlease remember to go to /home/`whoami`/.vim/bundle/YouCompleteMe directory and run the command './install.py' to install it. For more information regarding installation guide, please refer to https://github.com/Valloric/YouCompleteMe.\n*******\n"
            break
        
    vim_plugins.close()

    print "Vim env recovered successully!"



#Main function
"""
argv[1]: recovery.py
argv[2]: recovery env
argv[3]: path if exits.
path: DESDIR=g
"""
argv = sys.argv

try:
    if len(argv) ==4 :
        path = argv[3]
    else :
        currentPath = os.path.dirname(os.path.abspath(__file__))
        cmd = "cat " + currentPath +"/.config"
        result = subprocess.check_output(cmd, shell=True)
        path = re.split("DESDIR=([^\n]+)", result)
        path = path[1]
except:
    print "[Error]: Wrong argument."

envArgv  = argv[1];
argv[1] = re.sub(r'-', "", argv[1])

cmd = "cd " + path + " && git checkout " + argv[2] + " " + argv[1]
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

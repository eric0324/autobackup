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

    cmd = "rm -rf ~/usr/local/lib/python2.7/dist-packages"
    result = subprocess.check_output(cmd, shell=True)
    cmd = "cat " + path + "/python"
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
    cmd = "cat " + path + "/ruby"
    result = subprocess.check_output(cmd, shell=True)
    result = result.replace("##", "sudo gem install ")
    result2 = re.sub(r'%%(\d|\.|\s|,)*', "\n", result)
    resul2 = result.replace("x86_64-darwin-14, 3.16.14.11 x86_64-darwin-14", "")

    result = subprocess.check_output(result2, shell=True)

    print "Python env recovery success!"


def nodejs():

    cmd = "sudo rm -rf ~/.local/lib/node_modules"
    result = subprocess.check_output(cmd, shell=True)
    cmd = "cat " + path + "/nodejs"
    result = subprocess.check_output(cmd, shell=True)
    result = result.replace("##", "sudo npm install -g ")
    result2 = re.sub(r'%%(\d|\.|\s|,)*', "\n", result)
    result2 = result2.replace("-rc4", "")

    result = subprocess.check_output(result2, shell=True)

    print "Nodejs env recovery success!"

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

    print "Atom env recovery success!"


def vim():
    cmd = "cp -p " + path + "/vim ~/.vimrc"
    result = subprocess.check_output(cmd, shell=True)
    cmd = "rm -rf ~/.vim/bundle/*"
    result = subprocess.check_output(cmd, shell=True)
    cmd = "git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim"
    result = subprocess.check_output(cmd, shell=True)
    cmd = "vim +PluginInstall +qall"
    result = subprocess.check_output(cmd, shell=True)
    
    vim_plugins = open(os.path.expanduser('~/.vimrc'), 'r')
    for line in vim_plugins:
        if line == ("Plugin 'Valloric/YouCompleteMe'\n" or 
                    "Plugin 'Valloric/YouCompleteMe'"):

            cmd = "sudo apt-get install build-essential cmake"
            result = subprocess.check_output(cmd, shell=True)

            cmd = "cd ~/.vim/bundle/YouCompleteMe;git submodule update --init --recursive"
            result = subprocess.check_output(cmd, shell=True)

            cmd = "cd ~/.vim/bundle/YouCompleteMe;./install.py --all"
            result = subprocess.check_output(cmd, shell=True)
            break

    vim_plugins.close()

    print "Vim env recovery success!"



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
        path = path
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

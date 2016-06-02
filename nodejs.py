# -*- coding: utf-8 -*-
import os
import sys
import subprocess
import string
import re

def backup():
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
        result = result.replace("\n", "")
        result = result.replace("  /usr/local/lib", "")
        f = open('nodejs_backup.txt', 'wb')
        f.write("  ")
        f.write(result)
        f.close()

        print "NodeJS env backup success!"
        return
    except:
        print "Error: NodeJS backup fail"


def reinstall():
    argv = sys.argv

    cmd = "npm install " + argv[2]
    result = subprocess.check_output(cmd, shell=True)
    print "Reduce " + argv[2] + " success!"


#Main function
argv = sys.argv

if argv[1] == '-b':
    backup()
elif argv[1] == '-r':
    reinstall()

# -*- coding: utf-8 -*-
hi

try:
    cmd = "cp -p ~/.gitconfig backup"
    result = subprocess.check_output(cmd, shell=True)
    print "Git env backup success!"
except:
    print "Error: Git backup fail"

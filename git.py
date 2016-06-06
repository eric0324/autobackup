# -*- coding: utf-8 -*-
import os
import sys
import subprocess
import string
import re

try:
    cmd = "cp -p ~/.gitconfig backup"
    result = subprocess.check_output(cmd, shell=True)
    print "Git env backup success!"
except:
    print "Error: Git backup fail"

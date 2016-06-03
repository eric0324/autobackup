import os
import subprocess
import string
import sys
import datetime

def backup():
    try:
        cmd = "pip list"
        result = subprocess.check_output(cmd, shell=True)
        result = result.replace(" (", " ")
        result = result.replace(")"," ")
        #result = result.replace("\n", "##")
        #filepath = "~/env_backup/python_env/"
        filepath = datetime.datetime.now().strftime('%Y%m%d')
        #filepath += "_python_backup.txt"
        f = open(filepath, 'wb')
        #f.write("##")
        f.write(result)
        f.close()

        print "Python env backup success!"
    except:
        print "Error: Python backup fail"

def reinstall():
    argv = sys.argv

    cmd = "pip install " + argv[2]
    result = subprocess.check_output(cmd, shell=True)
    print "Reduce " + argv[2] + " success!"


#Main function
argv = sys.argv

if argv[1] == '-b':
    backup()
elif argv[1] == '-r':
    reinstall()

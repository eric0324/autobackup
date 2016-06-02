import os
import sys
import subprocess
import string

def backup():
    try:
        cmd = "gem list --local"
        result = subprocess.check_output(cmd, shell=True)
        result = result.replace(" (", "%%")
        result = result.replace(")"," ")
        result = result.replace("\n", "##")

        f = open('ruby_backup.txt', 'wb')
        f.write("##")
        f.write(result)
        f.close()

        print "Ruby env backup success!"
        return
    except:
        print "Error: Ruby backup fail"

def reinstall():
    argv = sys.argv

    cmd = "gem install " + argv[2]
    result = subprocess.check_output(cmd, shell=True)
    print "Reduce " + argv[2] + " success!"


#Main function
argv = sys.argv

if argv[1] == '-b':
    backup()
elif argv[1] == '-r':
    reinstall()

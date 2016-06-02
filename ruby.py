import os
import subprocess
import string

cmd = "gem list --local"
result = subprocess.check_output(cmd, shell=True)
result = result.replace(" (", "%%")
result = result.replace(")"," ")
result = result.replace("\n", "##")

f = open('ruby_backup.txt', 'wb')
print result
f.write("##")
f.write(result)

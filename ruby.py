import os
import subprocess
cmd="gem list --local"
result = subprocess.check_output(cmd, shell=True)

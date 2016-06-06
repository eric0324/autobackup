def allRecovery:
    python()
    ruby()
    nodejs()
    git()
    atom()
    vim()


def python:
    argv = sys.argv

    cmd = "pip install " + argv[2]
    result = subprocess.check_output(cmd, shell=True)
    print "Reduce " + argv[2] + " success!"

def ruby:
    argv = sys.argv

    cmd = "gem install " + argv[2]
    result = subprocess.check_output(cmd, shell=True)
    print "Reduce " + argv[2] + " success!"


def nodejs:
    argv = sys.argv

    cmd = "npm install " + argv[2]
    result = subprocess.check_output(cmd, shell=True)
    print "Reduce " + argv[2] + " success!"

def git:


def atom:
    argv = sys.argv

    cmd = "apm install " + argv[2]
    result = subprocess.check_output(cmd, shell=True)
    print "Reduce " + argv[2] + " success!"


def vim:


#Main function
argv = sys.argv

if argv[1] == '-b':
    backup()
elif argv[1] == '-r':
    reinstall()

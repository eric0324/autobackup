# [CS312] UNIX final project
This README would normally document whatever steps are necessary to get the application up and running.

## System dependencies
* Ubuntu 16.04 LTS

## Configuration
* run `env_bk.sh -s` and enjoy it!


## Services

* `env_bk.sh -s`:  Scan your environment, create .env backup (if it does not exist), then do the first backup.
* `env_bk.sh -r -(plugin name) (commit hash) (directory)`: Restore specified environment.`directory` as `path/dir` not necessary
* `env_bk.sh -r`: Setting the date and environment.(Date Format:` day month year-hour min-sec`.)
* `env_bk.sh -m (directory) `: Set other backup directory.
* `env_bk.sh -m (timer)`: Set up automatic backup interval.
* `env_bk.sh -d `: Stop the backup schedule.

## API

* `backup.py -all`:  Backup all env.
* `backup.py -ruby`:  Backup Ruby env.
* `backup.py -pthon`: Backup Python env.
* `backup.py -nodejs`: Backup NodeJS env.
* `backup.py -atom`: Backup Atom env.
* `backup.py -git`: Backup Git env.
* `backup.py -vim`: Backup Vim env.

---

* `recovery.py -all`:  Recovery all env.
* `recovery.py -Python`:  Recovery python env.
* `recovery.py -Ruby`:  Recovery ruby env.
* `recovery.py -nodejs`:  Recovery NodeJS env.
* `recovery.py -atom`:  Recovery Atom env.
* `recovery.py -git`:  Recovery git env.
* `recovery.py -vim`:  Recovery vim env.


## Contributors
* [eric0324](https://github.com/eric0324)
* [lck930526](https://github.com/lck930526)
* [s1023350](https://github.com/s1023350)
* [qhsiaw](https://github.com/qhsiaw)

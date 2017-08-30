"""
Backup script for HomeLibraryCatalog instance deployed to VPS
"""


import os.path
from toolpot.linux.systemd import control, control_isrunning
from toolpot.scripting import archive, make_name, rotate


BACKUP_NAME = "morebooks"
DATA = ["$HOME/data/uploads", "$HOME/data/database.sqlite"]
DESTINATION = "$HOME/data/backup"
SERVER = "apache2"


def main():
    """Backup local data for running HomeLibraryCatalog instance"""
    target = os.path.expandvars(DESTINATION)
    valuables = [os.path.expandvars(x) for x in DATA]

    restart = control_isrunning(SERVER)
    if restart: control(SERVER, "stop")
    archive(os.path.join(target, make_name(BACKUP_NAME)), *valuables)
    if restart: control(SERVER, "start", wait=False)
    rotate(target, BACKUP_NAME)


if __name__ == "__main__":
    main()

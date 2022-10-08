#!/usr/bin/env python3

"""watchvalheimlog.py  logfile-to-watch
Watch Valheim log for save messages, and backup the saves.
Watch for shutdown message, and shut down the container and/or server.
Needs env vars POST_BACKUP_HOOK  SHUTDOWN_HOOK
"""

import argparse
import os
import subprocess
import time
import tailhead

def main(logfile,debug=False):
    for line in tailhead.follow_path(logfile):
        if line is not None:
            output = line
            if debug:
                print("line read", output, flush=True)  # # debug
            if "World save writing finished" in line:
                backup()
            if "INFO - Shutdown complete" in line:
                shutdown()
        else:
            time.sleep(0.1)  # reduce cpu usage?

def backup():
    '''make a backup'''
    print("make a backup",flush=True)
    backuphook=os.environ.get('POST_BACKUP_HOOK')
    #backuphook.replace("@BACKUP_FILE@",backupfile)
    result=subprocess.run(backuphook.split())
    print("backup result:",result)

def shutdown():
    '''shut down container and/or server'''
    print('shutdown now',flush=True)
    shutdownhook=os.environ.get('SHUTDOWN_HOOK')
    result=subprocess.run(shutdownhook)
    print("shutdown result:",result)    # probably never see this

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("logfile", help="logfile to tail")
    parser.add_argument("--debug", "-d")
    args = parser.parse_args()
    logfile = args.logfile
    debug = args.debug
    if debug:
        print("debug enabled",flush=True)
    main(logfile,debug=debug)

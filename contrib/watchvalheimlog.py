#!/usr/bin/env python3

"""watchvalheimlog.py  logfile-to-watch
Watch Valheim log for save messages, and backup the saves.
Watch for shutdown message, and shut down the container and/or server.
Needs env vars WATCH_SAVE_HOOK  SHUTDOWN_HOOK
"""

import argparse
import os
import subprocess
import sys
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
    backuphook=os.environ.get('WATCH_SAVE_HOOK')
    #backuphook.replace("@BACKUP_FILE@",backupfile)
    print("backup hook %s" % (backuphook),flush=True)
    result=subprocess.run(backuphook.split())
    print("backup result:",result,flush=True)

def shutdown():
    '''shut down container and/or server'''
    shutdownhook=os.environ.get('SHUTDOWN_HOOK')
    if shutdownhook:
        print('shutdown now',flush=True)
        result=subprocess.run(shutdownhook)
        print("shutdown result:",result,flush=True)    # probably never see this
    else:
        print("shutdown hook not defined",flush=True)

def usage(msg=None):
    '''print usage and/or error'''
    print("Usage: watchvalehimlog.py <logfile>",flush=True)
    if msg:
        print(msg,flush=True)
        sys.exit(1)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("logfile", help="logfile to tail")
    parser.add_argument("--debug", "-d")
    args = parser.parse_args()
    # check args
    backuphook=os.environ.get('WATCH_SAVE_HOOK')
    if not backuphook:
        usage("missing env var WATCH_SAVE_HOOK")
    '''
    shutdownhook=os.environ.get('SHUTDOWN_HOOK')
    if not shutdownhook:
        usage("missing env var SHUTDOWN_HOOK")
    '''
    logfile = args.logfile
    # test logfile
    try:
        with open(logfile,"rt") as fh:
            fh.seek(0,2)    # seek end of file
    except FileNotFoundError as e:
        usage("file not found or not readable/seekable " + logfile + e)
    debug = args.debug
    if debug:
        print("debug enabled",flush=True)
    print("watchvalheimlog.py starting, file %s" % (logfile),flush=True)
    print("backuphook", backuphook, flush=True)
    main(logfile,debug=debug)

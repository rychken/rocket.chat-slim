#! /usr/bin/env python

import os
import sys
import subprocess as sp

bash = ['/bin/bash', '-i', '-c']

DEBUG = True
DEBUG = False

def in_either(path, search):
    return search in path

def in_dir(path, search):
    path = os.path.dirname(path)
    return search in path

def in_file(path, search):
    fname = os.path.basename(path)
    return search in fname

def run(cmd):
    if DEBUG:
        print cmd
    else:
        os.system(cmd)

replace = sys.argv[1]
with_new = sys.argv[2]

master = [
    x for x in sp.Popen(bash+['non_ignored'], stdout=sp.PIPE).stdout.read().splitlines() 
        if in_either(x, replace)]
    
# FILES
files = [x for x in master if in_file(x, replace)]
for fullpath in files:
    new_fname = os.path.basename(fullpath).replace(replace, with_new)
    new_fullpath = os.path.join(os.path.dirname(fullpath), new_fname)
    cmd = 'git mv %s %s' %(fullpath, new_fullpath)
    run(cmd)

master = [
    x for x in sp.Popen(bash+['non_ignored'], stdout=sp.PIPE).stdout.read().splitlines() 
        if in_either(x, replace)]

# DIRS
def walk(start):
    for dirName, subdirList, fileList in os.walk(start):
        if dirName == '.':
            continue
        cmd = 'git ls-files --error-unmatch %s > /dev/null 2>&1' % dirName
        if sp.call(cmd, shell=True):
            # dir not tracked
            continue
        if replace in dirName:
            newDirName = dirName.replace(replace, with_new)
            cmd = 'git mv %s %s' %(dirName, newDirName)
            run(cmd)
            return walk(start)
        for subdir in subdirList:
            walk(subdir)

walk(os.path.dirname(os.path.realpath(__file__)))

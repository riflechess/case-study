#!/bin/bash

set -e

workingdir="/tmp/cs"                        # working dir for file creation
maxfiles=5000                               # max files to create in working dir
maxfilebytes=1000000                        # max file size (bytes) to create
lfsbinary="/home/cmx/dev/case-study/target/release/lfs"                    # location of lfs binary

numfiles=$(( $RANDOM % $maxfiles ))
tmpdir="$workingdir/$(tr -dc A-Za-z0-9 </dev/urandom | head -c 4)"
totalfilesize=0

function log {
  echo "$(date +%Y%m%d_%H%M%S) - $1"
}

# validate we have jq and lfs binary is available
function check_prereqs {
  if ! which jq >> /dev/null ; then
    log "jq not found, exiting..."
    exit 1
  fi

  if [ ! -f "$lfsbinary" ]; then
    log "lfs binary $lfsbinary not found, exiting..."
    exit 1
  fi
}

# populate working directory with random # of files, with random sizes
function populate_directory {
  mkdir "$tmpdir"
  for((i=1; i<=$numfiles; i++))
  do  
      filesize=$(( $RANDOM % $maxfilebytes ));
      dd if=/dev/zero bs=$filesize count=1 of=$tmpdir/$i.bin 2> /dev/null
      let "totalfilesize += $filesize"
  done
  log "$numfiles files created in $tmpdir"
  log "$totalfilesize bytes total"
}

# validate filecount from lfs matches what we created
function test_filecount {
  log "FILECOUNT TEST: checking $tmpdir count with lfs..." 
  lfscount=$($lfsbinary $tmpdir | jq '.files | length')
  log "lfs filecount in $tmpdir is $lfscount"
  if [[ "$lfscount" -eq "$numfiles" ]] ; then
    log "FILECOUNT PASS"
  else
    log "FILECOUNT FAIL ($numfiles expected, $lfscount actual)"
    return 1 
  fi
}

# validate total filesize from lfs matches what we created
function test_filesize {
  log "FILESIZE TEST: checking $tmpdir total file size with lfs..."
  lfssize=$($lfsbinary $tmpdir |  jq '.files[] | {size} | add' |  awk '{sum = sum + $1}END{print sum}') 
  log "lfs file size in $tmpdir is $lfssize"
  if [[ "$lfssize" -eq "$totalfilesize" ]] ; then
    log "FILESIZE PASS"
  else
    log "FILESIZE FAIL ($totalfilesize expected, $lfssize actual)"
    return 1 
  fi
}

# remove temp dir containing the random files
function cleanup {
  rm -R "$tmpdir" && log "$tmpdir removed"
}

log "***LFS test module***"
log "workingdir:   $workingdir"
log "maxfiles:     $maxfiles"
log "maxfilebytes: $maxfilebytes"

check_prereqs
populate_directory

if test_filecount && test_filesize ; then
  log "Tests completed successfully."
else
  log "Tests failed."
fi

cleanup
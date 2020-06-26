#!/usr/bin/env bash

# check the shit that CrapiCorp can't get right .... 

# input arguments:
# 1 - {{user `complete_directory`}} (eg '/scratch/completed')
# 2 - {{.BuildName}} (packer-windows-2019-amd64-libvirt)

BLD=$1
OUT=$2
[[ -n "$3" ]] && CMP=$3
STAMP=$(date +%y%m%d-%H%M%S)

FLOG=findlog-$BLD-$STAMP.log
> $FLOG

flog() {
  printf ">>> %s\n" "$*" | tee -a $FLOG
}

echo "Find log - logging to '$FLOG'"

flog "STAMP - find log starts"
[[ -n "$BLD" ]] && flog "Bould Artifact: $BLD"
[[ -n "$OUT" ]] && flog "    Output dir: $OUT"
[[ -n "$CMP" ]] && flog " Completed dir: $CMP"
find $(dirname $OUT) >> $FLOG

echo "Find log - COMPLETE"

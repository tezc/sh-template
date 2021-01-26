#!/bin/sh
set -e
cd "$(dirname "$0")"
cwd=$(pwd)

cleanup () {
  if [ -n "$1" ]; then
    kill "$(jobs -p)" || true
    echo "Aborted by $1"
  elif [ $status -ne 0 ]; then
    kill "$(jobs -p)" || true
    echo "Failure (status $status)"
  else
    echo "Success"
  fi

  echo "cleanup"
  cd $cwd
  #cleanup here: rm -rf .
}

trap 'status=$?; cleanup; exit $status' EXIT
trap 'trap - HUP; cleanup SIGHUP; kill -HUP $$' HUP
trap 'trap - INT; cleanup SIGINT; kill -INT $$' INT
trap 'trap - TERM; cleanup SIGTERM; kill -TERM $$' TERM

echo $cwd

#Commmands here.


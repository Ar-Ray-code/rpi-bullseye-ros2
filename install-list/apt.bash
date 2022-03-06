#!/bin/bash
# Qiita  : https://qiita.com/digitarhythm/items/f2fa3efd92f27c557918
# GitHub : https://github.com/digitarhythm/apt-install

#=====================================================
# apt.bash install at once from package list file
#=====================================================
TARGET="$@"

if [ -z ${TARGET} ]; then
  echo "Usage:"
  echo "apt-install [package name | package list file]"
  exit
fi

if [ -f ${TARGET} ]; then
  for line in `cat ${TARGET}`
  do
    if [ -n "${line}" ]; then
      ret=`dpkg -l ${line} | egrep "i\s*?${line}"`
      if [ -z "${ret}" ]; then
        sudo apt-get install ${line} -y
      fi
    fi
  done
else
  sudo apt-get install ${TARGET} -y
fi
#!/bin/bash
set -e

if [ -z "$1" ] ; then
  echo "Usage: $0 filename"
  exit 1
fi

defaults import com.manytricks.Moom "$1"

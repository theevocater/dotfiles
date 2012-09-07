#!/bin/bash

git submodule foreach --recursive git checkout master
git submodule foreach --recursive git pull

#git submodule update

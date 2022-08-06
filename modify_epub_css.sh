#!/bin/bash

epub=$1
good_css=$2

path=$(unzip -l $1 |grep css |awk '{print $4}')
dir=$(dirname "$path")
filename=$(basename "$path")

mkdir -p $dir
cp $good_css $dir/$filename
zip -r $epub $path
rm -rf $dir

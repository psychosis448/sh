#!/bin/bash
# file: purge_image_meta.sh
# description: purge image metadata via jhead and/or exiftool
# author: psychosis448
# date: 2019-03-07
# version: 0.1
# ATTENTION: overwrites original, might degrade image quality

for i in "$@"; do
  case ${i} in
    jhead)
      if hash jhead 2>/dev/null; then
        find -E . -type f -regex ".*\.(jpg|jpeg|JPG|JPEG)" -exec jhead -purejpg {} \;
        echo ${i} "executed"
      else echo "jhead is not installed"
      fi
      ;;
    exiftool)
      if hash exiftool 2>/dev/null; then
        exiftool -all= -r. -overwrite_original -ext jpg .
        exiftool -all= -r. -overwrite_original -ext jpeg .
        exiftool -all= -r. -overwrite_original -ext JPG .
        exiftool -all= -r. -overwrite_original -ext JPEG .
        exiftool -all= -r. -overwrite_original -ext png .
        exiftool -all= -r. -overwrite_original -ext PNG .
        echo ${i} "executed"
      else echo "exiftool is not installed"
      exit 1
      fi
      ;;
    *)
      echo ${i} "is not defined, only jhead and exiftool"
      exit 1
  esac
done

exit 0

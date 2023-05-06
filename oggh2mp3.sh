#!/bin/bash
if [ $# -eq 0 ]
then
  echo "Please provide a file path as the argument."
else
  mkdir "$1.tmp/"
  derez -only icns "$1" > "$1.tmp/tmp1"
  cat "$1.tmp/tmp1" | grep -o '"[[:xdigit:][:space:]]\+"' | sed 's/"//g' > "$1.tmp/tmp2"
  xxd -r -p "$1.tmp/tmp2" "$1.tmp/icns"
  mkdir "$1.tmp/outdir/"
  icnsutil e "$1.tmp/icns" -o "$1.tmp/outdir/"

  ffmpeg -i "$1" -vn -ar 44100 -ac 2 -ab 320k -map_metadata 0:s:a -f mp3 "$1.tmp/tmp3.mp3"
  ffmpeg -i "$1.tmp/tmp3.mp3" -i "$1.tmp/outdir/512x512.png" -map 0:0 -map 1:0 -c copy -id3v2_version 3 -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (front)" "$1.mp3"

  rm -rf "$1.tmp/"
  echo "Success"
fi

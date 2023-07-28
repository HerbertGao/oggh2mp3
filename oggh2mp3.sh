#!/bin/bash

# 检查命令行参数
if [ $# -eq 0 ]; then
  echo "Please provide a file path as the argument."
  exit 1
fi

file="$1"
tmp_dir="$(mktemp -d)"

# 将原始文件转换为MP3
ffmpeg -i "$file" -vn -ar 44100 -ac 2 -codec:a libmp3lame -qscale:a 2 -id3v2_version 3 -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (front)" "${file%.*}.mp3"

# 提取ICNS图标
derez -only icns "$file" | grep -o '"[[:xdigit:][:space:]]\+"' | sed 's/"//g' | xxd -r -p > "$tmp_dir/icns"

# 创建输出目录
mkdir "$tmp_dir/outdir"

# 提取专辑封面
icnsutil e "$tmp_dir/icns" -o "$tmp_dir/outdir/"

# 合并专辑封面和MP3文件
ffmpeg -i "${file%.*}.mp3" -i "$tmp_dir/outdir/512x512.png" -map 0:0 -map 1:0 -c copy -id3v2_version 3 -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (front)" "${file%.*}_with_cover.mp3"

# 清除临时文件
rm -rf "$tmp_dir"

echo "Success"
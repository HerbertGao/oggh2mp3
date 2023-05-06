# oggh2mp3

QQ音乐Mac版 oggh格式音频文件带专辑封面转 mp3格式脚本

oggh格式的音频文件为vorbis格式，专辑封面是icns格式的10张图片作为图标，并没有在音频文件的流或metadata里存储。

目前大致思路为：
从oggh中提取icns图标的资源文件，再转换成icns文件，从中提取出512x512的png文件；
ffmpeg将vorbis的音频文件转换成mp3，再将png文件压入mp3文件，获得最终结果。

因为不熟悉相关工具包用法，选择了一个比较笨的方式来转换，待以后学习之后再改良吧。

## Dependencies

- Command Line Tools
  - `xcode-select --install`
- [relikd/icnsutil](https://github.com/relikd/icnsutil)
  - `pip3 install icnsutil`
- ffmpeg
  - `brew install ffmpeg`

## Usage
```shell
chmod +x oggh2mp3.sh
oggh2mp3 [INPUT.oggh]
```

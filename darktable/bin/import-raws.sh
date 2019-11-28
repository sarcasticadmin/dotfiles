#!/bin/sh

# shellcheck disable=SC2148
usage(){
  cat << EOF
usage: "$(basename "$0")" [OPTIONS] ARGS

Script to import photos from SD card

OPTIONS:
  -h      Show this message

EOF
}

while getopts "h" OPTION
do
  case $OPTION in
    h )
      usage
      exit 0
      ;;
    \? )
      usage
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

#echo "${ARG1:-'notset'}"

# http://www.exiv2.org/sample.html
# find . -type f -exec exiv2 -K Exif.Photo.DateTimeOriginal -pt {} \; | awk '{ gsub(":", "_"); print $4}'
# exiv2 -g FileNumber -pt DSC_0040.NEF | awk '{ print $4 }'
read -p 'where were these taken? ' LOC

RAWDATE=$(exiv2 -K Exif.Photo.DateTimeOriginal -pt $(ls |sort -V | head -n 1) | awk '{ gsub(":", ""); print $4}')

TARGETDIR="${HOME}/photos/staging/${LOC}-${RAWDATE}"

mkdir -p "$TARGETDIR"

rsync -avz --progress . "$TARGETDIR"

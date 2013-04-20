#!/bin/bash -eu

### start-configuration-part ###
name='unknown'__goto__
declare -i age=10
switch=false
### end-configuration-part ###

author='__user__'
version='0.01'

help() {
  echo "Usage: ${0##*/} [-h|v] [-d] [-n name] [-a age] [-s] [file ...]

    Description ...

    Options:

    -n name         Parameter description
    -a age          Parameter description
    -s              Parameter description
    -h              Help
    -v              Show program version"
  test $# -gt 0 && echo "$*" >&2
  exit $#
}

while getopts ':n:a:shv' option
do
  case $option in
    n) name="$OPTARG";;
    a) age=$OPTARG;;
    s) switch=true;;
    h) help;;
    v) echo -e "${0##*/} $version\nAuthor $author"; exit;;
   \?) help "Unknown option '-$OPTARG'.";;
    :) help "Option -$OPTARG needs an argument.";;
  esac
done

shift $((OPTIND-1))
declare -a files=("$@")

# code
echo $name
echo $age
echo $switch # use if $switch
echo "Other parameters: ${files[*]:-}"


# shellcheck disable=SC2148
usage(){
  cat << EOF
usage: "$(basename "$0")" [OPTIONS] ARGS

Simple template of getopts

OPTIONS:
  -h      Show this message
  -e      Echo first arg

EXAMPLES:
  To print out arg1:

      "$(basename "$0")" arg1

EOF
}

while getopts "he:" OPTION
do
  case $OPTION in
    e )
      ARG1=$OPTARG
      ;;
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

echo "${ARG1:-'notset'}"

#!/bin/sh

has_root () {
  if [ "$(id -u)" != 0 ]; then
    echo "${RED}Sorry, must be root to run this script${RESET}"
    exit 1
  fi
}

has_decent_cpu () {
  if [ "$CORES" -lt 4 ]; then
    echo "${BOLD}${YELLOW}Warning:${RESET} ${CORES} CPU cores, expect a long build time"
    echo ""
    sleep 1
  fi
}

github_fetch () {
  REPOSITORY="$1"
  ROOT_DIR="$(pwd)"
  TEMP_DIR="$(mktemp -d)"
  TARGET_DIR="$(basename "$REPOSITORY")"
  GITHUB_URL="https://github.com/$REPOSITORY/archive/master.tar.gz"

  if [ -z "$1" ]; then
    echo "Usage: $0 user/repo"
    exit 1
  else
    cd "$TEMP_DIR" || exit

    wget "$GITHUB_URL" -q --show-progress --progress=bar:force 2>&1
    tar -zxf "master.tar.gz" --strip-components=1 --checkpoint=.100

    echo
    mv "$TEMP_DIR" "$ROOT_DIR/$TARGET_DIR"
  fi
}

log () {
  echo "${BOLD}${GREEN}➜ ${RESET} ${1} ${BOLD}${2}${RESET}"
}

success () {
  echo "${BOLD}${GREEN}✔ ${RESET} ${1}"
}

error () {
  echo "${BOLD}${RED}(╯°□°）╯︵ ┻━┻ ${RESET} ${1}"
  exit 1
}

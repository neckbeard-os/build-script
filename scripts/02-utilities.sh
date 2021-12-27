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

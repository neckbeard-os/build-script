#!/usr/bin/env bash
if [[ "$#" == 0 ]]; then printf '%s\n' "No commit message"; else MESSAGE="${@}"; git add . && git commit -s -m "${MESSAGE}" && git push; fi
exit 0

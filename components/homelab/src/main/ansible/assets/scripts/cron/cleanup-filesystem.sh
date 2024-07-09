#!/bin/bash
## Sometimes applications leave traces in the form of files and folders. Virtual machines
## running  Windows often leave `System Volume Information` folders behind and IntelliJ leaves some
## logfiles behind (among other files and folders). This script deletes these files and folders.
## The script is configured as a cronjob and runs regularly.
##
## === Script Arguments
## The script does not accept any parameters.
##
## === Script Example
## [source, bash]
## ....
## ./cleanup-filesystem.sh
## ....


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


readonly BLACKLIST=(
  "System Volume Information"
  "java_error_in_idea_*.log"
  ".DS_Store"
  "firefox.tmp"
)

echo -e "$LOG_INFO Run $0"

for entry in "${BLACKLIST[@]}"; do
  echo -e "$LOG_INFO Scan for folder $Y$entry$D"
  result=$(find "$HOME" -name "$entry")

  if [ -z "$result" ]; then
    echo -e "$LOG_INFO No results found"
  else
    while IFS= read -r line; do
      echo -e "$LOG_INFO Remove $line"
      rm -rf "$line"
      done <<< "$result"
  fi
done

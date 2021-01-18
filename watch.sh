#!/usr/bin/env bash

# ----------------------------------------------------------------------------
# A small script for continuous compilation using fd and entr.
# 
#  1. Set $SOURCE_DIR (the top-level folder containing source code).
#  2. Set $WATCH_TYPE (see following table).
#  3. Set any other relevant environment variables described in the table.
#  4. Run `watch`.
#
# `watch`, unfortunately, often needs to be restarted if files are moved or
# deleted. I'm still not 100% sure why, but at least it's not that much of a
# hassle.
#
# Steps 1-3 can most easily be done using `direnv`.
#
# Supported formats:
#
#   Language   Build type     $WATCH_TYPE   Other environment variables
#   --------   ----------     -----------   ---------------------------
#
#   Python     Sphinx dirhtml PY_DIRHTML    $BUILD_DIR: output directory,
#                                                       relative to $SOURCE_DIR
#                                              (default: docs/dirhtml)
#
#   Haskell    cabal          HS_CABAL      $CABAL_TARGET: target to build
#                                              (default: empty string)
#
# ----------------------------------------------------------------------------

# Set up default configurations
if [[ "${WATCH_TYPE}" == "PY_DIRHTML" ]]; then
    if [ -z "$BUILD_DIR" ]; then BUILD_DIR=docs/dirhtml; fi
    watch_filetypes=(rst py)
    watch_command="sphinx-build -a -E -b dirhtml ${SOURCE_DIR} ${SOURCE_DIR}/${BUILD_DIR}"
elif [[ "${WATCH_TYPE}" == "HS_CABAL" ]]; then
    watch_filetypes=(hs)
    watch_command="cabal build ${CABAL_TARGET}"
fi

# Build the `fd` command
fd_command=fd
for ft in ${watch_filetypes[@]}; do
    fd_command="${fd_command} -e ${ft}"
done
fd_command="${fd_command} . ${SOURCE_DIR}"

# Echo commands to user
echo "watch: fd_command is:       ${fd_command}"
echo "watch: watch_command is:    ${watch_command}"
echo "watch: Press Space, or edit a file, to trigger the first compilation."

RESET='\033[0m'
RED='\033[38;5;203m'
GREEN='\033[38;5;77m'

# Run the loop
while true; do
    # The sleep 0.5 is needed in order to get a nonzero exit code when mashing
    # Ctrl-C. entr by itself only returns nonzero if entr itself failed; it
    # doesn't care what the command it ran did or didn't do.
    sleep 0.5 && ${fd_command} | entr -pzd sh -c "${watch_command}"
    if [[ $? -ne 0 && $? -ne 2 ]]; then
        echo -n -e "${RED}"
        date -u +"%Y-%m-%d %H:%M:%S"
        echo "watch: compile failed"
        echo -n -e "${RESET}"
        break
    else
        echo -n -e "${GREEN}"
        date -u +"%Y-%m-%d %H:%M:%S"
        echo "watch: compile done"
        echo -n -e "${RESET}"
        continue
    fi
done

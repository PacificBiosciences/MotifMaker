#!/bin/bash

# Source the smrtanalysis setup.sh file
. $($(dirname $(readlink -f "$0"))/../../admin/bin/getsetupfile)

# Script for running MotifMaker inside SMRTpipe
# Relies on a java environment and $SEYMOUR_HOME
java -Xmx8000m -jar ${SMRT_TOPDIR}/analysis/lib/java/motif-maker-0.2.one-jar.jar $@ || exit $?

#!/bin/bash -eu

# Dependencies
#   teem
#   matlab

SCRIPT=$(readlink -m "$(type -p $0)")
SCRIPTDIR=$(dirname "$SCRIPT")
source "$SCRIPTDIR/util.sh"

usage() {
echo -e "Usage:
    ${0##*/} <t1> <t2Out>

<t1>        a T1 nrrd
<t2Out>     generated T2 nrrd
"
}
 
[ $# -eq 2 ] || { usage; exit 1; }

t1=$1
t2Out=$2
t1Tmp=$(mktemp)-t1.nrrd

log "Make '$t2Out'"
run unu convert -t float -i "$t1" -o "$t1Tmp"
cmdMatlab="addpath $SCRIPTDIR; T1toT2conversion('$t1Tmp', '$t2Out'); quit"
binMatlab="matlab -nosplash -nodesktop"
$binMatlab -r "$cmdMatlab"
log "Made '$t2Out'"

# clean up
rm "$t1Tmp"

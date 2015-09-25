#!/bin/bash -eu

function verify() {
if md5sum $1 | cut -d' ' -f1 | diff - <(echo $2); then
    echo "$1 PASS"
else
    echo "$1 FAIL"
    return 1
fi
}

case=01011
source $threet/SetUpData.sh

verify "$t1" c1a0cf7373ba930988442c8492054e11
rm -f t2.nrrd
../T1toT2conversion.sh "$t1" t2.nrrd

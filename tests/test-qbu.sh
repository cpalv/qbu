#!/bin/bash

expect() {
	exitcode=$?
	testname=$1
	expected_exitcode=$2
	if [ $exitcode -ne $expected_exitcode ]; then
		echo "$testname failed: got $exitcode expected $expected_exitcode"
		exit 1
	fi
	echo "$testname: passed"
}

# Check if script fails successfully
../qbu.sh &>/dev/null || expect "no args" 1
../qbu.sh ../honey.txt &>/dev/null || expect "not a block device" 1
# A proof by oxymoron!

exit 0

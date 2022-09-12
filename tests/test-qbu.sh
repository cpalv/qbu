#!/bin/bash

expect() {
	exitcode=$?
	[ $exitcode -ne $1 ] && echo "test failed, got $exitcode expected $1" && \
		exit 1
}

../qbu.sh &>/dev/null && expect 1
../qbu.sh ../honey.txt &>/dev/null && expect 1

exit 0

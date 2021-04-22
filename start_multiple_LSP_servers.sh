#!/bin/bash

COUNT=$1
INITIAL_PORT=$2
CURRENT_LANG=`git branch | grep \* | cut -d ' ' -f2`


for ((currCOUNT=1; currCOUNT <= $COUNT; currCOUNT++)) {

	if [ $# -eq 2 ]; then
		let port=$currCOUNT+$INITIAL_PORT;
	else
		let port=$currCOUNT+4000;
	fi
	#echo $port
	bash -x manage_LSP_instance.sh start $CURRENT_LANG $port
}

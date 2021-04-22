#!/bin/bash

LSP_NAME=$1
PORT=$2 

while [[ `screen -ls | grep -e LSP-$LSP_NAME-$PORT` ]] && [[ ! `lsof -t -i:$PORT` ]]
do 
	sleep 1
done

if [ -d "LSP_BUILDS/$LSP_NAME-$PORT" ]; then

	rm -rf LSP_BUILDS/$LSP_NAME-$PORT

fi

# wait until LSP is finished

while [[ `lsof -t -i:$PORT` ]]
do 
	sleep 10
done

# if the LSP has been killed, there folder should be restored with files -> delete it

if [ -d "LSP_BUILDS/$LSP_NAME-$PORT" ]; then

	rm -rf LSP_BUILDS/$LSP_NAME-$PORT

fi
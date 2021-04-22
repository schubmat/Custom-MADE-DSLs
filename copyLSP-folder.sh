#!/bin/bash

LANGUAGE_NAME=$1
PORT=$2

cd LSP_BUILDS

cp -r $LANGUAGE_NAME $LANGUAGE_NAME-$PORT 

#cp -r `ls -A | grep -v xtext-lsp` xtext-lsp-$LSP_NAME-$PORT



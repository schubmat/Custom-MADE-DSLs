#!/bin/bash

BUILD_DIR=$1
languageName=$2
version=$3

#-------------------------------
# ---------- build it ----------
#-------------------------------

./gradlew assembleDist
# cp build to LSP_BUILDS folder
cp `find . -name "*ide*tar"` $BUILD_DIR
# 
cd $BUILD_DIR
# extract it
tar xvvf *tar
mv org.xtext.example.mydsl.ide-$version $languageName-_-$version
# clean up
rm *.tar
# leave BUILD into tmpLangFolder
cd -
#

# install the new language into the local maven repo
./gradlew install

# go back to git language repo (root)
cd ..

BUILD_DIR="LSP_BUILDS"

# sync changes in language repository
( 
flock -e 200

	git checkout -b $languageName-_-$version
	# sync grammar into new branch
	rsync -av tmpLang-$languageName-$version/org.xtext.example.mydsl/* org.xtext.example.mydsl/

	git add *.xtext *.xtend
	git commit -m "Initialized new $languageName"
	git push

) 200>/tmp/$BUILD_DIR.lockfile 

# clean up
rm -rf tmpLang-$languageName-$version 
	


#!/bin/bash

BUILD_DIR=$1
languageName=$2
version=$3


buildLangServerBinaryFromSubfolder() {

	GENUINE_BUILD_DIR=$1
	BUILD_DIR=../$GENUINE_BUILD_DIR
	languageName=$2
	version=$3

	# check if LSP has been built in the mean time
	if [ ! -d "$BUILD_DIR/$languageName-$version" ]; then

		if [ ! -d "$BUILD_DIR" ]; then
		# syncronize folder creation, but only do if it's really neccessary
			(
			flock -e 200
				# create build directory if necessary
				if [ ! -d "$BUILD_DIR" ]; then
					mkdir $BUILD_DIR;
				fi	
			) 200>/tmp/$GENUINE_BUILD_DIR.lockfile 
		fi 

		# build it
		./gradlew distZip

		# syncronize copying the binary
		(
			flock -e 200
			
			# cp build to LSP_BUILDS folder
			cp `find . -name "*ide*zip"` $BUILD_DIR

			# 
			cd $BUILD_DIR
			# extract it
			unzip -o *.zip -d $languageName-$version

			# clean up
			rm *.zip
			# leave
			cd -
			#

		) 200>/tmp/CopyToBuildDir.lock 		
	fi
}

########################################################################
################################ SCRIPT ################################
########################################################################

( 
flock -e 200

	# checkout LSP configuration to be started --- not used currently
	git checkout $languageName#$version
	# copy plain project without git meta data and branches
	git checkout-index -a -f --prefix=tmpBuildFolder-$languageName-$version/

) 200>/tmp/$BUILD_DIR.lockfile 

# enter build dir
cd tmpBuildFolder-$languageName-$version/

# build language server binary
buildLangServerBinaryFromSubfolder $BUILD_DIR $languageName $version

# install language
./gradlew install

# exit and 
cd ..
# clean up
#pwd
echo " ## BEFORE"
ls tmpBuildFolder*
echo " ## "
rm -rf tmpBuildFolder-$languageName-$version/
echo " ## AFTER"
ls tmpBuildFolder*
echo " ##"
# 
#sleep 5s

# rsync -aP --exclude=$BUILD_DIR * ../___$languageName-$version
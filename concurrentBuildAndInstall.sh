#!/bin/bash

BUILD_DIR=$1
languageName=$2
version=$3


buildLangServerBinaryFromSubfolder() {

	GENUINE_BUILD_DIR=$1
	BUILD_DIR=../$GENUINE_BUILD_DIR
	languageName=$2
	version=$3

	currTime=`date "+%H:%M:%S"`;
	echo "## $currTime -- building $languageName in version $version --> locking /tmp/$languageName-_-$version.lockfile " >> ../.logfile
	#
	(
	flock -e 200

	# check if LSP has been built in the mean time
	if [ ! -d "$BUILD_DIR/$languageName-_-$version" ]; then

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
		./gradlew assembleDist

		# syncronize copying the binary
		(
		flock -e 200
			
			# cp build to LSP_BUILDS folder
			cp `find . -name "*ide*tar"` $BUILD_DIR
			# 
			cd $BUILD_DIR
			# extract it
			tar xvvf *tar
			mv org.xtext.example.mydsl.ide-$version $languageName-_-$version
			# clean up
			rm *.tar

		) 200>/tmp/CopyToBuildDir.lock 		
	fi

	) 200>/tmp/$languageName-_-$version.lockfile 
	#
	currTime=`date "+%H:%M:%S"`;
	echo "## $currTime -- finished building $languageName in version $version -- releasing /tmp/$languageName-_-$version.lockfile " >> ../.logfile
}

########################################################################
################################ SCRIPT ################################
########################################################################

( 
flock -e 200

	# checkout LSP configuration to be started --- not used currently
	git checkout $languageName-_-$version
	# copy plain project without git meta data and branches
	git checkout-index -a -f --prefix=tmpBuildFolder-$languageName-$version/

) 200>/tmp/$BUILD_DIR.lockfile 

# enter build dir
cd tmpBuildFolder-$languageName-$version/

# build language server binary
buildLangServerBinaryFromSubfolder $BUILD_DIR $languageName $version

# configure Standalone Xtext Generator Setup
echo "version = ${version}-${languageName}" > gradle.properties

# install language
./gradlew install

# exit and 
cd ..
# clean up
rm -rf tmpBuildFolder-$languageName-$version/
# 

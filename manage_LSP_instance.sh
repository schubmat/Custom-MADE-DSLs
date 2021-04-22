#!/bin/bash
command=$1
languageName=$2
commandParamOne=$3 
commandParamTwo=$4

########################################################################
############################## FUNCTIONS ###############################
########################################################################

performTask() {

	BUILD_DIR="LSP_BUILDS"
	buildTask=$1
	languageName=$2
	version=$3

		if [ $buildTask == "initialize" ]; then
			# build_LSP_binary $BUILD_DIR $languageName $version
			# installLanguageIntoLocalMavenRepo
			buildLangServerAndInstallConcurrently $BUILD_DIR $languageName $version

		elif [ $buildTask == "install" ]; then

			# create tempory build folder
			createTemporaryFolderCopyForBuild $languageName $version
			# enter it
			cd tmpBuildFolder-$languageName-$version/
			# install it
			installLanguageIntoLocalMavenRepo
			# leave it
			cd ..	
			# clean it
			rm -rf tmpBuildFolder-$languageName-$version/

		elif [ $buildTask == "build" ]; then

			# create tempory build folder
			createTemporaryFolderCopyForBuild $languageName $version
			# enter it
			cd tmpBuildFolder-$languageName-$version/
			# install it
			buildLangServerBinaryFromSubfolder $BUILD_DIR $languageName $version
			# leave it
			cd ..	
			# clean it
			rm -rf tmpBuildFolder-$languageName-$version/
		fi
}

buildLangServerBinaryFromSubfolder() {

	GENUINE_BUILD_DIR=$1
	BUILD_DIR=../$GENUINE_BUILD_DIR
	languageName=$2
	version=$3

	# check if LSP has been built in the mean time
	if [ ! -d "$BUILD_DIR/$languageName_-_$version" ]; then

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
			mv org.xtext.example.mydsl.ide-$version $languageName_-_$version
			# clean up
			rm *.tar

		) 200>/tmp/CopyToBuildDir.lock 
		#
		# no further directory changes needed as everything in the flock block is done in a separate process
	fi
}

buildLangServerAndInstallConcurrently() {

	BUILD_DIR=$1
	languageName=$2
	version=$3

	screen -dmS concurrentBuildAndInstall-$languageName bash -c "bash -x concurrentBuildAndInstall.sh $BUILD_DIR $languageName $version"			
	#screen -dmS concurrentBuildAndInstall-$languageName -L -Logfile concurrentBuildAndInstall-$languageName.log bash -c "bash -x concurrentBuildAndInstall.sh $BUILD_DIR $languageName $version"			
	
	# instal it
	# mkdir ../___$languageName
	# rsync -aP --exclude=$BUILD_DIR * ../___$languageName
	# cd ../___$languageName
	# ./gradlew install
	# cd -
	# rm -rf ../___$languageName
	# 
}

createTemporaryFolderCopyForBuild() {

	languageName=$1
	version=$2

	( 
	flock -e 200

		# checkout LSP configuration to be started --- not used currently
		git checkout $languageName_-_$version
		# copy plain project without git meta data and branches
		git checkout-index -a -f --prefix=tmpBuildFolder-$languageName-$version/

	) 200>/tmp/$BUILD_DIR.lockfile 

}

installLanguageIntoLocalMavenRepo() {

	# instal it
	./gradlew install
}

########################################################################
################################ SCRIPT ################################
########################################################################

BUILD_DIR="LSP_BUILDS"

#----------------------------------------------------------------------
#------------------------------- INIT ---------------------------------
#----------------------------------------------------------------------
    
# for all available languages (equiv. to all branches but main and dev) build the 
# LSP wrapper binaries and install the language build into the local repository
if [[ $command == "init" ]]; then

	git branch > branches.current
	availableBranches=`cat branches.current | grep -v develop | grep -v main | grep -v templateLang`
	# remove asteriks of current branch
	availableBranches=${availableBranches//"*"/" "}  

	for currLang in $availableBranches; do 

		_languageName=${currLang%_-_*}  
		_version=${currLang#*_-_}

		performTask initialize $_languageName $_version
	done

	rm branches.current

#----------------------------------------------------------------------
#------------------------------- START --------------------------------
#----------------------------------------------------------------------

# otherwise start an LSP instance accordingly
elif [[ $command == "start" ]]; then

	version=$commandParamOne
	port=$commandParamTwo

	if [ ! -d $BUILD_DIR/$languageName_-_$version ]; then

		performTask build $languageName $version

	fi 

	# start LSP in screen
	# ls=`find . -type d -name "bin" | grep $BUILD_DIR/$languageName_-_$version`
	#
	cd `find . -type d -name "bin" | grep $BUILD_DIR/$languageName_-_$version`
	#
	# echo "###"
	# echo `pwd`
	# echo "###"
	#echo "screen -dmS LSP-$languageName_-_$version-$port bash -c \"./mydsl-socket $port\""
	screen -dmS LSP-$languageName_-_$version-$port bash -c "./mydsl-socket $port"

	# go back to root folder 
	# projectRoot=`pwd | awk -v rootFolder="$BUILD_DIR" '{print substr($_,0,index($_,rootFolder)-1)}'`
	# echo "changing back to $projectRoot"
	# cd $projectRoot

#----------------------------------------------------------------------
#-------------------------------- KILL --------------------------------
#----------------------------------------------------------------------

## --- if kill is specified, kill a concrete instance
elif [[ $command == "kill" ]]; then

	port=$commandParamOne

	if [[ `screen -ls | grep -e LSP-$languageName -e $commandParamOne` ]]; then 
		screen -ls | grep -e LSP-$languageName -e $commandParamOne | cut -d. -f1 | awk '{print $1}' | xargs kill -9;
		screen -wipe
	fi
## --- if killAll is specified, kill all LSP instances
elif [[ $command == "killAll" ]]; then
	if [[ `screen -ls | grep -e LSP-` ]]; then 
		screen -ls | grep -e LSP- | cut -d. -f1 | awk '{print $1}' | xargs kill -9;
		screen -wipe
	fi
## --- if killAll-FromLanguage is specified, kill all LSP instances running that language
elif [[ $command == "killAll-FromLanguage" ]]; then

	if [[ `screen -ls | grep -e LSP-$languageName-` ]]; then 
		screen -ls | grep -e LSP-$languageName- | cut -d. -f1 | awk '{print $1}' | xargs kill -9;
		screen -wipe
	fi

#----------------------------------------------------------------------
#---------------------- CREATE NEW LSP PROJECT ------------------------
#----------------------------------------------------------------------

## will create a copy of an LSP project in order to start with an git example project
elif [[ $command == "createNewLanguage" ]]; then

	BUILD_DIR="LSP_BUILDS"
	version=$commandParamOne

	# briefly lock lock the folder
	( 
	flock -e 200

		git checkout templateLang		
		# last slash is important, otherwise it will not be interpreted as a folder
		git checkout-index -a -f --prefix=tmpLang-$languageName_-_$version/

	) 200>/tmp/$BUILD_DIR.lockfile 

	# fix build configuration
	# adapt name configuration
	gradleConfig=`cat settings.gradle | head -3`
	echo $gradleConfig > settings.gradle
	echo "rootProject.name = '$languageName'" > settings.gradle
	# adapt version configuration
	echo "version = $version" > gradle.properties

#----------------------------------------------------------------------
#---------------------- BUILD NEW LSP PROJECT ------------------------
#----------------------------------------------------------------------

## will create a copy of an LSP project in order to start with an git example project
elif [[ $command == "buildNewLSP" ]]; then

	BUILD_DIR="LSP_BUILDS"
	version=$commandParamOne

	cd tmpLang-$languageName_-_$version

	# validate status by buliding it
	./gradlew compileJava

	# the build did not work and thus we won't clean up the lang
	if [ $? != 0 ]; then
		exit 1
	# the build worked, thus we want to clean up
	else 
		screen -dmS BUILD-$languageName_-_$version bash -c "bash buildLSPAndInstallLanguage.sh ../LSP_BUILDS $languageName $version"
		exit 0
	fi


#----------------------------------------------------------------------
#------------------------------- ELSE ---------------------------------
#----------------------------------------------------------------------

# otherwise
else
	echo "Unknown command - please retry"
fi


# USAGE EXAMPLES

### start an LSP on port "4400" with language "grammar_MDR" 

# bash manage_LSP_instance.sh start grammar_MDR 4400

### kill all a specific LSP instance running the "grammar_MDR" on port 4400

# bash manage_LSP_instance.sh kill grammar_MDR 4400

### kill all LSP instances

# bash manage_LSP_instance.sh killAll 

### kill all LSP instances running the "grammar_MDR" language

# bash manage_LSP_instance.sh killAll-FromLanguage grammar_MDR

### initialize all languages

# bash manage_LSP_instance.sh init 
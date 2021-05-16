git branch > tmp.txt
availableBranches=`cat tmp.txt | grep -v develop | grep -v main `
# remove asteriks of current branch
availableBranches=${availableBranches//"*"/" "}  

for currBranch in $availableBranches; do 
	git checkout $currBranch
	git pull
	git merge develop
	git push
	sleep 30s
done

git checkout develop

rm tmp.txt
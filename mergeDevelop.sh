git branch > tmp.txt
availableBranches=`cat tmp.txt | grep -v develop | grep -v master `
# remove asteriks of current branch
availableBranches=${availableBranches//"*"/" "}  

for currBranch in $availableBranches; do 
	git checkout $currBranch
	git pull
	git merge develop
	git push
done

git checkout develop

rm tmp.txt
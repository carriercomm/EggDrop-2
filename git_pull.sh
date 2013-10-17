#!/bin/bash
# used to keep tabs on commits to github via eggdrop bot. Just create a simple tcl script to exec
# this script and echo the results to chan or where ever you feel like
# make sure you perform a git clone https://github.com/someone/something.git then set your gitpath etc correctly
# ev0x - v1.0 17/10/2013
gitpath="/opt/git/omega-services/"
scriptpath="/opt/eDrop/scripts/git"
cd $gitpath
pull=`git pull > /dev/null 2>&1`
commit=`git rev-parse --verify HEAD`
#echo $commit
last_commit=`cat $scriptpath/com.txt`
#echo $last_commit
if [ "$commit" != "$last_commit" ]; then
        echo "$commit" > $scriptpath/com.txt
        url="https://github.com/omegaservices/omega-services/commit/$commit"

        content=`wget -qO- "$url"`


        path=`echo $content | grep -i "octicon-diff-modified" | awk -F "#diff-0\">" '{print $2}' | awk -F "</" '{print $1}'`
        rev=`echo $content | grep -i "View file @" | awk -F "code>" '{print $2}' | awk -F "</" '{print $1}'`
        author=`wget -qO- "$url" | grep -i "author-name" | awk -F "author\">" '{print $2}' | awk -F "</" '{print $1}'`
        comment=`wget -qO- "$url" | grep -i "<p class=\"commit-title\">" -A1 | egrep -v "^$|commit-title" | sed -e 's/^ *//g' -e 's/ *$//g'`
        branch=`echo $content | grep -i "repo_commits repo_tags repo_branches" | awk -F "repo_branches " '{print $2}' | awk -F "\">" '{print $1}'`

        #now put it all together
        out="[\x0311GitCommit:\x03] \x02$branch\x02 \x0314by\x03 \x02$author\x02 [\x0304*\x03] \x02$rev\x02 \x0314$path\x03 \x02$comment\x02"

        echo -e "$out"
fi

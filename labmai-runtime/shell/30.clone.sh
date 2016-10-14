#/bin/bash

confirm "clone $node节点的代码" && {
    mkdir -p $envROOT/gini-modules

    tmpGitRP="$shellPath/clone"

    tmpRepoFile="$tmpGitRP/git-repos"
    cat $tmpRepoFile | while read tmpLine
    do
        if [ "$tmpLine" != "" ];
        then
            tmpURL=`echo $tmpLine | sed -e "s/{{{NODE}}}/$node/g"`
            tmpURL=`echo $tmpURL | sed -e "s#{{{ENVROOT}}}#$envROOT#g"`
            git clone $tmpURL
        fi
    done

    tmpGitFS=`ls -v $tmpGitRP`
    for tmpGitF in $tmpGitFS
    do
        if [[ $tmpGitF == *\.sh ]]
        then
            source $currentPath/export.sh
            source $tmpGitRP/$tmpGitF
        fi
    done

}


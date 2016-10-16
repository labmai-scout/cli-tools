#/bin/bash

`hasDocker0` && {
    confirm "clone $node节点的代码" && {
        tmpModulesPath="$envROOT/gini-modules"
        mkdir -p $tmpModulesPath

        tmpGitRP="$shellPath/clone"
        tmpDocker0IP=`getDocker0IP`

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
                source $tmpGitRP/$tmpGitF
            fi
        done

        for tmpDIR in $(ls -d $tmpModulesPath/)
        do 
            tmpDIRPATH=${tmpDIR%%/};
            tmpDIRNAME=${tmpDIRPATH:${#tmpModulesPath}}
            if [ "$tmpDIRNAME" == "gini" ]
            then
                continue
            fi

            `replaceNow $tmpDIR`

            if [ "$tmpDIRNAME" == "$node" ]
            then
                `$tmpDIRPATH/install`
                `$tmpDIRPATH/update`
                continue
            fi
            `hasDocker0` && {
                `docker exec -t gini sh -lc "/data/gini-modules/gini/bin/gini @${tmpDIRPATH} install"`
                `docker exec -t gini sh -lc "/data/gini-modules/gini/bin/gini @${tmpDIRPATH} cache"`
                `docker exec -t gini sh -lc "/data/gini-modules/gini/bin/gini @${tmpDIRPATH} composer init -nf"`
                `docker exec -t gini sh -lc "composer update -d ${tmpDIRPATH} --no-dev"`
                `docker exec -t gini sh -lc "/data/gini-modules/gini/bin/gini @${tmpDIRPATH} orm update"`
                `docker exec -t gini sh -lc "/data/gini-modules/gini/bin/gini @${tmpDIRPATH} web update"`
            }
        done

    }

}

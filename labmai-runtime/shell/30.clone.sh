#/bin/bash

`hasDocker0` && {
    confirm "git clone 代码" && {
        tmpModulesPath="$envROOT/gini-modules"
        mkdir -p $tmpModulesPath

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
    }

    confirm "执行git代码的初始化" && {
        tmpModulesPath="$envROOT/gini-modules"
        tmpContainersPath="$envROOT/containers"
        tmpOPWD=$pwd
        cd $tmpContainersPath
        source ./restart.sh
        cd $tmpOPWD

        tmpGitFS=`ls -v $tmpGitRP`
        for tmpGitF in $tmpGitFS
        do
            if [[ $tmpGitF == *\.sh ]]
            then
                source $tmpGitRP/$tmpGitF
            fi
        done

        for tmpDIR in $(ls -d $tmpModulesPath/*/)
        do 
            tmpDIRPATH=${tmpDIR%%/};
            tmpDIRNAME=${tmpDIRPATH:${#tmpModulesPath}+1}

            if [ "$tmpDIRNAME" == "gini" ]
            then
                continue
            fi

            replaceNow $tmpDIR

            if [ "$tmpDIRNAME" == "node" ]
            then
                continue
            fi

            # `hasDocker0` && {
            #     docker exec -t gini sh -lc "/data/gini-modules/gini/bin/gini @${tmpDIRNAME} composer init -nf"
            #     docker exec -t gini sh -lc "composer update -d ${tmpDIRPATH} --no-dev"
            #     docker exec -t gini sh -lc "/data/gini-modules/gini/bin/gini @${tmpDIRNAME} install"
            #     docker exec -t gini sh -lc "/data/gini-modules/gini/bin/gini @${tmpDIRNAME} cache"
            #     docker exec -t gini sh -lc "/data/gini-modules/gini/bin/gini @${tmpDIRNAME} orm update"
            #     docker exec -t gini sh -lc "/data/gini-modules/gini/bin/gini @${tmpDIRNAME} web update"
            # }
        done

    }

}

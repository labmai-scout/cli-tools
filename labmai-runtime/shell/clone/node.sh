#/bin/bash

`hasDocker0` && {
    confirm "初始化node环境" && {
        #node/admin-order-review
        tmpAPPP="$envROOT/gini-modules/node/admin-order-review"
        if [ -d $tmpAPPP ];
        then
            mkdir -p "$tmpAPPP/data"
            `touch "$tmpAPPP/data/bpm.cli.robot.work.pid"`
            `chown -R www-data:www-data "$tmpAPPP/data/bpm.cli.robot.work.pid"`
        fi

        #node/lab-orders
        tmpNodeP="$envROOT/gini-modules/node"
        tmpAPPP="$tmpNodeP/lab-orders"
        mkdir -p "$tmpAPPP/data"
        `chown -R www-data:www-data "$tmpAPPP/data"`
        replaceNow $tmpNodeP


        confirm "初始化${node}的数据库" && {
            tmpDBNames=("NODE_admin NODE_gateway NODE_lab_grants NODE_lab_inventory NODE_lab_orders NODE_lab_waste NODE_lab_waste_bottle")
            tmpDockerIP=`getDocker0IP`
            for tmpDBName in $tmpDBNames
            do
                tmpDBName=`echo $tmpDBName | sed -e "s/NODE/$node/g"`
                createTable $tmpDBName
            done
        }

        `hasDocker0` && {
            confirm "gini 初始化APP运行环境" && {
                for tmpDIR in $(ls -d $tmpNodeP/*/)
                do
                    tmpDIRPATH=${tmpDIR%%/};
                    tmpDIRNAME=${tmpDIRPATH:${#tmpNodeP}+1}
                    cp $tmpNodeP/default.env $tmpNodeP/$tmpDIRNAME/.env
                    docker exec -t gini sh -lc "/data/gini-modules/gini/bin/gini @node/${tmpDIRNAME} composer init -nf"
                    docker exec -t gini sh -lc "composer update -d node/${tmpDIRPATH} --no-dev"
                    docker exec -t gini sh -lc "/data/gini-modules/gini/bin/gini @node/${tmpDIRNAME} install"
                    docker exec -t gini sh -lc "/data/gini-modules/gini/bin/gini @node/${tmpDIRNAME} cache"
                    docker exec -t gini sh -lc "/data/gini-modules/gini/bin/gini @node/${tmpDIRNAME} orm update"
                    docker exec -t gini sh -lc "/data/gini-modules/gini/bin/gini @node/${tmpDIRNAME} web update"
                done
            }
        }

        # confirm "初始化${node}的admin-order-review数据" && {
        #     docker exec -it gini sh -lc '/data/gini-modules/gini/bin/gini @node/admin-order-review bpm node tools add-process'
        # }

        # confirm "初始化${node}的lab-inventory数据" && {
        #     docker exec -t gini sh -lc '/data/gini-modules/gini/bin/gini @node/lab-inventory inventory type fill'
        #     docker exec -t gini sh -lc '/data/gini-modules/gini/bin/gini @node/lab-inventory inventory template tableinit'
        #     docker exec -t gini sh -lc '/data/gini-modules/gini/bin/gini @node/lab-inventory inventory template chemical'
        # }

        # confirm "初始化${node}的lab-grants数据" && {
        #     docker exec -t gini sh -lc '/data/gini-modules/gini/bin/gini @node/lab-grants grants portion initpublic'
        # }
    }
}

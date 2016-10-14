#/bin/bash

confirm "初始化image-cache环境" && {
    tmpDiskD="$envROOT/image-cache"
    mkdir -p $tmpDiskD
    `chown -R www-data:www-data $tmpDiskD`
    `cp $envROOT/gini-modules/node/default.env $envROOT/gini-modules/image-cache/.env`
    tmpDefaultENVFile='$envROOT/gini-modules/node/default.env'
    while read -r tmpLine
    do
        if [[ $tmpLine == IMAGE_CACHE_CLIENT_ID* ]]
        then
            tmpICCI=${tmpLine:22}
            continue
        fi
        if [[ $tmpLine == IMAGE_CACHE_CLIENT_SECRET* ]]
        then
            tmpICCS=${tmpLine:26}
            continue
        fi
    done < "$tmpDefaultENVFile"
    if [ "$tmpICCI" != "" ]
    then
        tmpICDY="$envROOT/gini-modules/image-cache/data/client/${tmpICCI}.yml"
        `echo '---' > ${tmpICDY}`
        `echo "id: ${tmpICCI}" >> ${tmpICDY}`
        `echo "secret: ${tmpICCS}" >> ${tmpICDY}`
        `echo 'sizes: ' >> ${tmpICDY}`
        `echo '- 2x' >> ${tmpICDY}`
        `echo '- 3x' >> ${tmpICDY}`
        `echo '- "32"' >> ${tmpICDY}`
        `echo '- "40"' >> ${tmpICDY}`
        `echo '- "48"' >> ${tmpICDY}`
        `echo '- "64"' >> ${tmpICDY}`
        `echo '- "70"' >> ${tmpICDY}`
        `echo '- "100"' >> ${tmpICDY}`
        `echo '- "128"' >> ${tmpICDY}`
        `echo '- "140"' >> ${tmpICDY}`
        `echo '- "144"' >> ${tmpICDY}`
        `echo '- "256"' >> ${tmpICDY}`
        `echo '...' >> ${tmpICDY}`
    fi
}

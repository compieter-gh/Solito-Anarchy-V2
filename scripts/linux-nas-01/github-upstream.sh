#!/usr/bin/bash

#Log File & Paths
ROOT_PATH=$(git root)
HOSTNAME=$HOSTNAME
DATE=$(date +'%Y_%m_%d_%I_%M_%p_')
EXTENSION=".log"
LOG_FILE=${ROOT_PATH}/scripts/${HOSTNAME}/logs-github/${DATE}

#SRC/DEST dirs
SRCDIR_1="/srv/daemon-data" #legacy
SRCDIR_2="/var/lib/pterodactyl/volumes"

#Server SRC DIRS
PROXY_ANARCHY_UUID="${SRCDIR_2}/38041d33-5b50-4dde-962e-95709f1d73be"
HUB_ANARCHY_UUID="${SRCDIR_2}/73056572-85e8-4979-b304-f6c247d0a599"
ANARCHY_UUID="${SRCDIR_2}/b095d9ae-9446-4019-af77-fa93ccd746d6"
CREATIVE_ANARCHY_UUID="${SRCDIR_2}/7e094680-db9b-4355-a294-f5644ae6e7eb"
CRAZY_ANARCHY_UUID="${SRCDIR_2}/49974344-b65f-48cb-9b18-4ee9cbdcb180"

#Server DEST DIRS
PROXY_ANARCHY_DEST="${ROOT_PATH}/servers/proxy_anarchy/"
HUB_ANARCHY_DEST="${ROOT_PATH}/servers/hub_anarchy/"
ANARCHY_DEST="${ROOT_PATH}/servers/anarchy/"
CREATIVE_ANARCHY_DEST="${ROOT_PATH}/servers/creative_anarchy/"
CRAZY_ANARCHY_DEST="${ROOT_PATH}/servers/crazy_anarchy/"

IP_NODE_0="10.0.1.10"
IP_NODE_1="10.0.1.11"

USER="root"

#IMPORTANT: ORDER MATTERS!!
SRV_SRC_LIST=( "${PROXY_ANARCHY_UUID}" "${HUB_ANARCHY_UUID}" "${ANARCHY_UUID}" "${CREATIVE_ANARCHY_UUID}" "${CRAZY_ANARCHY_UUID}" )
SRV_DEST_LIST=( "${PROXY_ANARCHY_DEST}" "${HUB_ANARCHY_DEST}" "${ANARCHY_DEST}" "${CREATIVE_ANARCHY_DEST}" "${CRAZY_ANARCHY_DEST}" )
SRV_IP_LIST=( "${IP_NODE_1}" "${IP_NODE_1}" "${IP_NODE_1}" "${IP_NODE_1}" "${IP_NODE_1}" )


#Include/Exlcude files
INCLUDE_GITHUB="${ROOT_PATH}/scripts/${HOSTNAME}/include-github.txt"
EXCLUDE_GITHUB="${ROOT_PATH}/scripts/${HOSTNAME}/exclude-github.txt"


#Msg for github
MSG_GIT="Updated Upstream (servers)"

#Sync all servers
exec 1>${LOG_FILE}"github-upstream"${EXTENSION} 2>&1

cd ${ROOT_PATH}

git pull

rm -rf ${ROOT_PATH}/servers/*

for (( i=0; i<${#SRV_IP_LIST[@]}; i++ ));
do 
    rsync -avm --include-from=${INCLUDE_GITHUB} --exclude-from=${EXCLUDE_GITHUB} --delete --delete-excluded -e ssh ${USER}@${SRV_IP_LIST[$i]}:${SRV_SRC_LIST[$i]}/* ${SRV_DEST_LIST[$i]}; 
done

#Sync all scripts 
#rsync -a --include-from=${INCLUDE_GITHUB} --exclude-from=${EXCLUDE_GITHUB} --delete --delete-excluded /root/scripts/* ${ROOT_PATH}/scripts/linux-srv-01/ #linux-srv-01
#rsync -a --include-from=${INCLUDE_GITHUB} --exclude-from=${EXCLUDE_GITHUB} --delete --delete-excluded -e ssh root@10.0.1.13:/mnt/volume1/NetBackup/scripts/* ${ROOT_PATH}/scripts/linux-nas-01/ #linux-nas-01

#Add the files to github and upstream them with a commit
git add -A
git commit -m "${MSG_GIT}"
git push

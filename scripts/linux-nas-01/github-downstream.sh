#!/usr/bin/bash

#USE THIS SCRIPT WITH CAUSTION!! Last time i used this i wiped my whole server.

#Log File & Paths
ROOT_PATH=$(git root)
HOSTNAME=$HOSTNAME
DATE=$(date +'%Y_%m_%d_%I_%M_%p_')
EXTENSION=".log"
LOG_FILE=${ROOT_PATH}/scripts/${HOSTNAME}/logs-github/${DATE}

#SRC/DEST dirs
SRCDIR_1="/srv/daemon-data/" #legacy
SRCDIR_2="/var/lib/pterodactyl/volumes/"

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
SRV_SRC_LIST=( "${PROXY_ANARCHY_UUID}" )
SRV_DEST_LIST=( "${PROXY_ANARCHY_DEST}" )
SRV_IP_LIST=( "${IP_NODE_1}" )

#Include/Exlcude files
INCLUDE_GITHUB="${ROOT_PATH}/scripts/${HOSTNAME}/include-github.txt"
EXCLUDE_GITHUB="${ROOT_PATH}/scripts/${HOSTNAME}/exclude-github.txt"

cd ${ROOT_PATH}

exec 1>${LOG_FILE}"github-downstream"${EXTENSION} 2>&1

#Make sure source is updated
#git checkout main
#git pull

#Sync all servers
for (( i=0; i<${#SRV_IP_LIST[@]}; i++ ));
do 
    rsync -av --delete --existing -e ssh ${SRV_DEST_LIST[$i]}/* ${USER}@${SRV_IP_LIST[$i]}:${SRV_SRC_LIST[$i]};
done
#!/usr/bin/env bash


BACK_UP_HOST=${BACK_UP_HOST:-10.60.0.53}
BACK_UP_PORT=${BACK_UP_PORT:-5432}
BACK_UP_USER=${BACK_UP_USER:-admin}
BACK_UP_PASSWORD=${BACK_UP_PASSWORD:-244466666}
BACK_UP_LOCATION=${BACK_UP_LOCATION:-.}
BACK_UP_DATABASE_LIST=${BACK_UP_DATABASE_LIST:-banners,chart,prod_db,storage}

# Use for scp
SSH_KEY_FILE=${SSH_KEY_FILE:-""}
SSH_HOST=${SSH_HOST:-""}
SSH_LOCATION=${SSH_LOCATION:-""}

export PGPASSWORD=$BACK_UP_PASSWORD

# dump . 192.168.4.79 5432 admin 244466666 prod_db
function dump() {
    local BACK_UP_LOCATION=$1
    local BACK_UP_HOST=$2
    local BACK_UP_PORT=$3
    local BACK_UP_USER=$4
    local BACK_UP_PASSWORD=$5
    local BACK_UP_DATABASE=$6

    local TODAY=$( date +"%Y" )/$( date +"%m" )/$( date +"%d" )
    local LOC=$BACK_UP_LOCATION/$TODAY
    local NAME="$BACK_UP_DATABASE-$( date +"%H.%M" ).gz"

    echo "$( date +"%Y.%m.%d-%H.%M" ) $LOC/$NAME"
    mkdir -p $LOC
    pg_dump -h $BACK_UP_HOST \
                -U $BACK_UP_USER \
                -d $BACK_UP_DATABASE | gzip  > $LOC/$NAME

    if [[ ! -z "$SSH_KEY_FILE" ]]; then
        ssh -o StrictHostKeyChecking=no -i $SSH_KEY_FILE $SSH_HOST "mkdir -p $SSH_LOCATION/$TODAY"
        scp -o StrictHostKeyChecking=no -i $SSH_KEY_FILE $LOC/$NAME $SSH_HOST:$SSH_LOCATION/$TODAY
    fi
}


# echo "URL:  postgres://$BACK_UP_USER:$BACK_UP_PASSWORD@$BACK_UP_HOST:$BACK_UP_PORT/$BACK_UP_DATABASE_LIST"
while [ true ]; do
    echo "$( date +"%Y.%m.%d-%H.%M" ) Start backup"
    IFS=',' read -r -a array <<< $BACK_UP_DATABASE_LIST
    for it_database in "${array[@]}"
    do
        echo "$( date +"%Y.%m.%d-%H.%M" ) Backup database $it_database"
        dump $BACK_UP_LOCATION $BACK_UP_HOST $BACK_UP_PORT \
            $BACK_UP_USER $BACK_UP_PASSWORD $it_database
        echo "$( date +"%Y.%m.%d-%H.%M" ) Backup database $it_database done"
    done


    echo "$( date +"%Y.%m.%d-%H.%M" ) Backup database done. Wait for next time"
    while [ true ]; do 
        if [ "$( date +"%H" )" ==  "2" ]; then
            break
        fi
        if [ "$( date +"%H" )" ==  "02" ]; then
            break
        fi
        sleep 10m
    done

    sleep 23h
done


# Dump
# pg_dump -h 192.168.4.79 -U admin -d prod_db | gzip  > dump.gz
# cat dump.gz | gunzip | psql -h 10.150.0.14 -p 5433 -U admin -d prod_db
# date +"%Y:%m:%d-%T"


# WAL



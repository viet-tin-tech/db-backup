#!/usr/bin/env bash

# dump . 192.168.4.79 5432 admin 244466666 prod_db
function dump() {
    local BACK_UP_LOCATION=$1
    local BACK_UP_HOST=$2
    local BACK_UP_PORT=$3
    local BACK_UP_USER=$4
    local BACK_UP_PASSWORD=$5
    local BACK_UP_DATABASE=$6

    NAME="$( date +"%Y.%m.%d-%T" )"
    LOC=$BACK_UP_LOCATION/dump/$( date +"%Y.%m.%d" )
    NAME="$BACK_UP_DATABASE-$NAME"
    echo "$( date +"%Y.%m.%d-%T" ) [$LOC]/$NAME"
    mkdir -p $LOC
    PGPASSWORD=$BACK_UP_PASSWORD \
        pg_dump -h $BACK_UP_HOST \
                -U $BACK_UP_USER \
                -d $BACK_UP_DATABASE | gzip  > $LOC/$NAME.gz
}


# dump . 192.168.4.79 5432 admin 244466666 prod_db
function dump_all() {
    local BACK_UP_LOCATION=$1
    local BACK_UP_HOST=$2
    local BACK_UP_PORT=$3
    local BACK_UP_USER=$4
    local BACK_UP_PASSWORD=$5

    local NAME="$( date +"%Y.%m.%d-%T" )"
    local LOC=$BACK_UP_LOCATION/dump/$( date +"%Y.%m.%d" )

    echo "$( date +"%Y.%m.%d-%T" ) [$LOC]/$NAME"
    mkdir -p $LOC
    PGPASSWORD=$BACK_UP_PASSWORD \
        pg_dumpall -h $BACK_UP_HOST -U $BACK_UP_USER | gzip  > $LOC/$NAME.gz
}


BACK_UP_HOST=${BACK_UP_HOST:-192.168.4.79}
BACK_UP_PORT=${BACK_UP_PORT:-5432}
BACK_UP_USER=${BACK_UP_USER:-admin}
BACK_UP_PASSWORD=${BACK_UP_PASSWORD:-244466666}
BACK_UP_LOCATION=${BACK_UP_LOCATION:-.}
BACK_UP_DATABASE_LIST=${BACK_UP_DATABASE_LIST:-banners,chart,prod_db}


echo "URL:  postgres://$BACK_UP_USER:$BACK_UP_PASSWORD@$BACK_UP_HOST:$BACK_UP_PORT/$BACK_UP_DATABASE_LIST"
while [ true ]; do
    IFS=',' read -r -a array <<< $BACK_UP_DATABASE_LIST
    for it_database in "${array[@]}"
    do
        echo "$( date +"%Y.%m.%d-%T" ) Backup database $it_database"
        dump $BACK_UP_LOCATION $BACK_UP_HOST $BACK_UP_PORT \
            $BACK_UP_USER $BACK_UP_PASSWORD $it_database
        echo "$( date +"%Y.%m.%d-%T" ) Backup database $it_database done"
    done


    echo "$( date +"%Y.%m.%d-%T" ) Backup database done. Wait for next time"
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



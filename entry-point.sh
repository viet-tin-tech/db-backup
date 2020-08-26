source ./backup.sh

if [ -z "$BACK_UP_LOCATION" ]; then 
    BACK_UP_LOCATION="."
fi

if [ -z "$BACK_UP_HOST" ]; then
    BACK_UP_HOST="192.168.4.79"
fi

if [ -z "$BACK_UP_PORT" ]; then
    BACK_UP_PORT="5432"
fi


if [ -z "$BACK_UP_USER" ]; then
    BACK_UP_USER="admin"
fi

if [ -z "$BACK_UP_PASSWORD" ]; then
    BACK_UP_PASSWORD="244466666"
fi

if [ -z "$BACK_UP_DATABASE" ]; then
    BACK_UP_DATABASE="prod_db"
fi


while [ true ]; do
    echo "$( date +"%Y:%m.:%d-%T" ) Backup system"
    dump $BACK_UP_LOCATION $BACK_UP_HOST $BACK_UP_PORT \
          $BACK_UP_USER $BACK_UP_PASSWORD $BACK_UP_DATABASE
    echo "$( date +"%Y.%m.%d-%T" ) Backup system done"
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



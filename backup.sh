# dump . 192.168.4.79 5432 admin 244466666 prod_db
function dump {
    BACK_UP_LOCATION=$1
    BACK_UP_HOST=$2
    BACK_UP_PORT=$3
    BACK_UP_USER=$4
    BACK_UP_PASSWORD=$5
    BACK_UP_DATABASE=$6

    LOC=$BACK_UP_LOCATION/dump/$( date +"%Y.%m.%d-%T" )
    echo "[$LOC]"
    mkdir -p $LOC
    PGPASSWORD=$BACK_UP_PASSWORD \
        pg_dump -h $BACK_UP_HOST \
                -U $BACK_UP_USER \
                -d $BACK_UP_DATABASE | gzip  > $LOC/dump.gz
}




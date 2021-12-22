#!/usr/bin/env bash

export PGPASSWORD=${PGPASSWORD:-244466666}

RESTORE_DATABASE=$1
DUMP_FILE=$2

psql -U admin -h 10.60.0.53 postgres -c "CREATE DATABASE $RESTORE_DATABASE;"
gunzip -c $DUMP_FILE | psql -U admin -h 10.60.0.53 $RESTORE_DATABASE
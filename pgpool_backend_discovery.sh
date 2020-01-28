#!/bin/bash

# Get list of pgpool-II database backend name which to monitor.

# Load the pgpool connection option parameters.
source $(dirname "$(realpath "$0")")/pgpool_funcs.conf

CMD="show pool_nodes"
result=$(psql -A --field-separator=',' -h $PGPOOLHOST -p $PGPOOLPORT -U $PGPOOLROLE -d $PGPOOLDATABASE -t -X -c "${CMD}" 2>&1)
if [ $? -ne 0 ]; then
	echo "$result"
	exit
fi

IFS=$'\n'

for backendrecord in $result; do
	BACKENDID=`echo $backendrecord | awk -F, '{print $1}'`
	BACKENDNAME=`echo $backendrecord | awk -F, '{print $2}'`
	BACKENDPORT=`echo $backendrecord | awk -F, '{print $3}'`
	backendlist="$backendlist,"'{"{#BACKEND}":"'$BACKENDNAME'", "{#BACKENDPORT}":"'$BACKENDPORT'", "{#BACKENDID}":"'$BACKENDID'"}'
done

echo '{"data":['${backendlist#,}']}'


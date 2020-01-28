#!/bin/bash

# Load the pgpool connection option parameters.
source $(dirname "$(realpath "$0")")/pgpool_funcs.conf

CMD="show transaction_read_only"
result=$(psql -A --field-separator=',' -h $PGPOOLHOST -p $PGPOOLPORT -U $PGPOOLROLE -d $PGPOOLDATABASE -t -X -c "${CMD}"  2>&1)

if [ $? -ne 0 ]; then
	echo "$result"
	exit
fi

IFS=$'\n'

echo "${result}";


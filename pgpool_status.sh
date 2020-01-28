#!/bin/bash

# Load the psql connection option parameters.
source $(dirname "$(realpath "$0")")/pgpool_funcs.conf

psql -t -X -A -h $PGPOOLHOST -p $PGPOOLPORT -U $PGPOOLROLE $PGPOOLDATABASE -c "select 1" 2>/dev/null
if [ $? -ne 0 ]; then
	echo 0
fi

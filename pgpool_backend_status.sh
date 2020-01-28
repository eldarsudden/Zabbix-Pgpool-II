#!/bin/bash

# Get status of pgpool-II database backend which you want to monitor.

CMD="show pool_nodes"
TIME=` date +%s`

# Load the pgpool connection option parameters.
source $(dirname "$(realpath "$0")")/pgpool_funcs.conf

IFS=$'\n'

if [ -z $1 ] || [ -z $2 ]; then 
	echo "No params specified"
	exit 1
fi

METRIC=$1
BACKEND=$2

pool_nodes=$(psql -A --field-separator=',' -h $PGPOOLHOST -p $PGPOOLPORT -U $PGPOOLROLE -d $PGPOOLDATABASE -t -X -c "${CMD}" | grep "${BACKEND}"  2>&1)

BACKENDID=`echo $pool_nodes | awk -F, '{ print $1 }'`
BACKENDNAME=`echo $pool_nodes | awk -F, '{ print $2 }'`
BACKENDPORT=`echo $pool_nodes | awk -F, '{ print $3  }'`
BACKENDREPLICATIONDELAY=`echo $pool_nodes | awk -F, '{ print $9 }'`
BACKENDLASTSTATUSCHANGE=`echo $pool_nodes | awk -F, '{ print $10 }'`
BACKENDSTATE=`echo $pool_nodes | awk -F, '{ print $4 }'`
BACKENDWEIGHT=`echo $pool_nodes | awk -F, '{ print $5 }'`
BACKENDROLE=`echo $pool_nodes | awk -F, '{ print $6 }'`

case "$METRIC" in
	pgpool.backend.id)
		echo "${BACKENDID}"	
		exit 0
		;;
	pgpool.backend.weight)
		echo "${BACKENDWEIGHT}"	
		exit 0
		;;
	pgpool.backend.role)
		echo "${BACKENDROLE}"	
		exit 0
		;;
	pgpool.backend.status)
		echo "${BACKENDSTATE}"	
		exit 0
		;;
	pgpool.backend.last.status.change)	
		echo "${BACKENDLASTSTATUSCHANGE}"	
		exit 0
		;;
	*)
	echo "'$METRIC' s not supported."
	exit 1
	;;
esac

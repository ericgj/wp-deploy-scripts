#!/usr/bin/env sh

# This is intended to be used in the -e parameter of a mysql invocation, e.g.
#   mysql -p -e "${relink.sh http://old.url http://new.url}" mydb
#
# Easiest if you have a my.cnf set up with the host, user, etc. set up
#

if [ $# -ne 2 ]; then
  echo "Usage: `basename $0` old_url new_url"
  exit -1
fi

echo "set @oldurl=$1; set @newurl=$2; source ./scripts/mysql/relink.sql;"

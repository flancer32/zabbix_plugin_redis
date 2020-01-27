#!/bin/bash
## ===========================================================================
#   Script to generate Redis monitoring data in JSON format
#   for 'zabbix-agent'.
## ===========================================================================
# collect working variables/data
BIN_REDIS=$(whereis -b redis-cli | cut -d" " -f2) # /usr/bin/redis-cli
DATA_INFO=$(${BIN_REDIS} INFO | tr -d '\r')       # get info and remove trailing '\r' from output

##
#   Extract stats and save it into env. vars.
##
# find lines with 'grep', cut second field after ":" and put it into env. variable:
ITEM_VERSION=$(grep "^redis_version:" <<<"${DATA_INFO}" | cut -d: -f2)
ITEM_UPTIME=$(grep "^uptime_in_seconds:" <<<"${DATA_INFO}" | cut -d: -f2)
ITEM_USED_MEMORY=$(grep "^used_memory:" <<<"${DATA_INFO}" | cut -d: -f2)
ITEM_USED_MEMORY_RSS=$(grep "^used_memory_rss:" <<<"${DATA_INFO}" | cut -d: -f2)
ITEM_KEYSPACE_HITS=$(grep "^keyspace_hits:" <<<"${DATA_INFO}" | cut -d: -f2)
ITEM_KEYSPACE_MISSES=$(grep "^keyspace_misses:" <<<"${DATA_INFO}" | cut -d: -f2)
ITEM_CONNECTED_CLIENTS=$(grep "^connected_clients:" <<<"${DATA_INFO}" | cut -d: -f2)
ITEM_RDB_LAST_SAVE_TIME=$(grep "^rdb_last_save_time:" <<<"${DATA_INFO}" | cut -d: -f2)
ITEM_TOTAL_CONNECTIONS_RECEIVED=$(grep "^total_connections_received:" <<<"${DATA_INFO}" | cut -d: -f2)
ITEM_REJECTED_CONNECTIONS=$(grep "^rejected_connections:" <<<"${DATA_INFO}" | cut -d: -f2)
ITEM_EXPIRED_KEYS=$(grep "^expired_keys:" <<<"${DATA_INFO}" | cut -d: -f2)
ITEM_EVICTED_KEYS=$(grep "^evicted_keys:" <<<"${DATA_INFO}" | cut -d: -f2)

# compose output JSON for Zabbix server:
echo -n "{"
echo -n "\"version\": \"${ITEM_VERSION}\","
echo -n "\"uptime\": ${ITEM_UPTIME},"
echo -n "\"used_memory\": ${ITEM_USED_MEMORY},"
echo -n "\"used_memory_rss\": ${ITEM_USED_MEMORY_RSS},"
echo -n "\"keyspace_hits\": ${ITEM_KEYSPACE_HITS},"
echo -n "\"keyspace_misses\": ${ITEM_KEYSPACE_MISSES},"
echo -n "\"connected_clients\": ${ITEM_CONNECTED_CLIENTS},"
echo -n "\"rdb_last_save_time\": ${ITEM_RDB_LAST_SAVE_TIME},"
echo -n "\"total_connections_received\": ${ITEM_TOTAL_CONNECTIONS_RECEIVED},"
echo -n "\"rejected_connections\": ${ITEM_REJECTED_CONNECTIONS},"
echo -n "\"expired_keys\": ${ITEM_EXPIRED_KEYS},"
echo -n "\"evicted_keys\": ${ITEM_EVICTED_KEYS}"
echo -n "}"

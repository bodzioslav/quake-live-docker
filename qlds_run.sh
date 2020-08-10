#!/bin/bash

QLDS_EXECUTABLE="/opt/steam/qlds/run_server_x64.sh"

SERVER_PORT="${SERVER_PORT:-27960}"
SERVER_NAME="${SERVER_NAME:-\"My QLDS Server\"}"
SERVER_ID="${SERVER_ID:-default}"
SERVER_PATH="/opt/steam/qlds/.quakelive/${SERVER_ID}"

SERVER_MAXCLIENTS="${SERVER_MAXCLIENTS:-20}"
SERVER_MAPPOOL="${SERVER_MAPPOOL:-mappool_ffa.txt}"
#SERVER_TAGS="${SEVER_TAGS:-\"qlds,quake live\"}"

RCON_ENABLE="${RCON_ENABLE:-1}"
RCON_PORT="${RCON_PORT:-28960}"

STATS_ENABLE="${ZMQ_STATS_ENABLE:-1}" 
STATS_PORT="${SERVER_PORT}"

OPTIONS=( "+set net_strict" "1" "+set net_port" "${SERVER_PORT}" "+set sv_hostname" "${SERVER_NAME}" "+set fs_homepath" "${SERVER_PATH}" "+set sv_mapPoolFile" "${SERVER_MAPPOOL}" \
  "+set sv_maxClients" "${SERVER_MAXCLIENTS}" "+set zmq_rcon_enable" "${RCON_ENABLE}" "+set zmq_rcon_port" "${RCON_PORT}" "+set zmq_stats_enable" "${STATS_ENABLE}" \
  "+set zmq_stats_port" "${SERVER_PORT}" )

EXTRA_OPTIONS=( "$@" )

if [ -n "${SERVER_PASS}" ]; then
  OPTIONS+=("+set g_password" "${SERVER_PASS}")
fi

if [ -n "${RCON_PASS}" ]; then
  OPTIONS+=("+set zmq_rcon_password" "${RCON_PASS}")
fi

if [ -n "${STATS_PASS}" ]; then
  OPTIONS+=("+set zmq_stats_password" "${STATS_PASS}")
fi

if [ -n "${ADMIN_STEAMID}" ]; then
  echo "${ADMIN_STEAMID}|admin" > "/opt/steam/qlds/baseq3/access.txt"
fi

exec "${QLDS_EXECUTABLE}" "${OPTIONS[@]}" "${EXTRA_OPTIONS[@]}"

#!/usr/bin/env bashio
set -e

# https://github.com/hassio-addons/bashio
    
bashio::log.info "Public key:"  
cat ~/.ssh/id_ed25519.pub 

BASE="ssh -o StrictHostKeyChecking=no -o ExitOnForwardFailure=yes -o ServerAliveInterval=60 -N"  

SRV="$(bashio::config 'remote_port'):$(bashio::config 'local_host'):$(bashio::config 'local_port') $(bashio::config 'ssh_user')@$(bashio::config 'ssh_host')"

if ! bashio::config.equals 'ssh_port' 22; then
    SRV="-p $(bashio::config 'ssh_port') ${SRV}"
fi 

set +e

while true
do
    if ! bashio::config.is_empty 'before'; then
        CMD="${BASE} ${SRV} $(bashio::config 'before')"
        bashio::log.info "[ $(date +'%m-%d-%Y') ] run: ${CMD}"
        eval $CMD
    fi

    CMD="${BASE} ${SRV}"
    bashio::log.info "[ $(date +'%m-%d-%Y') ] run tunnel: ${CMD}"
    eval $CMD

    sleep 15
done

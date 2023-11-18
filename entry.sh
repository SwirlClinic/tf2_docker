#!/bin/bash

# Copypasta'd from https://github.com/CM2Walki/CSGO/blob/master/etc/entry.sh
mkdir -p "${STEAMAPPDIR}" || true   
mkdir -p "${STEAMAPPDIR}/${STEAMAPP}"
mkdir -p "${CUSTOM_CONFIG_DIR}/${STEAMAPP}"

echo "Checking/Installing SteamCMD"
echo "${APP}/${STEAMAPP}_update.txt"

steamcmd +runscript "${APP}/${STEAMAPP}_update.txt"

if [ ! -d "${CUSTOM_CONFIG_DIR}/${STEAMAPP}/addons/metamod" ]; then
    LATESTMM=$(wget -qO- https://mms.alliedmods.net/mmsdrop/"${METAMOD_VERSION}"/mmsource-latest-linux)
    wget -qO- https://mms.alliedmods.net/mmsdrop/"${METAMOD_VERSION}"/"${LATESTMM}" | tar xvzf - -C "${CUSTOM_CONFIG_DIR}/${STEAMAPP}"	
fi

if [ ! -d "${CUSTOM_CONFIG_DIR}/${STEAMAPP}/addons/sourcemod" ]; then
    LATESTSM=$(wget -qO- https://sm.alliedmods.net/smdrop/"${SOURCEMOD_VERSION}"/sourcemod-latest-linux)
    wget -qO- https://sm.alliedmods.net/smdrop/"${SOURCEMOD_VERSION}"/"${LATESTSM}" | tar xvzf - -C "${CUSTOM_CONFIG_DIR}/${STEAMAPP}"
fi


# Copy steamappdir with preserved attributes without overwriting and doing so with symbolic links so we do not have to actually copy
cp -ans ${CUSTOM_CONFIG_DIR}/* ${SERVE_DIR}
cp -ans ${STEAMAPPDIR}/* ${SERVE_DIR}
cd "${SERVE_DIR}"

bash "${SERVE_DIR}/srcds_run" -game "${STEAMAPP}" -console -autoupdate \
			-steam_dir "${STEAMCMDDIR}" \
			-steamcmd_script "${APP}/${STEAMAPP}_update.txt" \
			-usercon \
			+fps_max "${SRCDS_FPSMAX}" \
			-tickrate "${SRCDS_TICKRATE}" \
			-port "${SRCDS_PORT}" \
			+tv_port "${SRCDS_TV_PORT}" \
			+clientport "${SRCDS_CLIENT_PORT}" \
			-maxplayers_override "${SRCDS_MAXPLAYERS}" \
			+game_type "${SRCDS_GAMETYPE}" \
			+game_mode "${SRCDS_GAMEMODE}" \
			+mapgroup "${SRCDS_MAPGROUP}" \
			+map "${SRCDS_STARTMAP}" \
			+sv_setsteamaccount "${SRCDS_TOKEN}" \
			+net_public_adr "${SRCDS_NET_PUBLIC_ADDRESS}" \
			-ip "${SRCDS_IP}" \
			+host_workshop_collection "${SRCDS_HOST_WORKSHOP_COLLECTION}" \
			+workshop_start_map "${SRCDS_WORKSHOP_START_MAP}" \
			-authkey "${SRCDS_WORKSHOP_AUTHKEY}" \
			"${ADDITIONAL_ARGS}"
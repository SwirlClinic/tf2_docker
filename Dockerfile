FROM ghcr.io/swirlclinic/mariposa:master

ENV APP "/app"
ENV STEAMAPPID 232250 
ENV STEAMAPP tf
ENV STEAMCMDDIR "${HOME}/.local/share/Steam/steamcmd"
ENV STEAMAPPDIR "${APP}/${STEAMAPP}-dedicated" 
ENV CUSTOM_CONFIG_DIR "${APP}/custom-config" 
ENV SERVE_DIR "${APP}/serve" 
ENV METAMOD_VERSION 1.11 
ENV SOURCEMOD_VERSION 1.11

ENV SRCDS_FPSMAX=300 \
	SRCDS_TICKRATE=128 \
	SRCDS_PORT=27015 \
	SRCDS_TV_PORT=27020 \
	SRCDS_CLIENT_PORT=27005 \
	SRCDS_NET_PUBLIC_ADDRESS="0" \
	SRCDS_IP="0" \
	SRCDS_MAXPLAYERS=32 \
	SRCDS_TOKEN=0 \
	SRCDS_STARTMAP="ctf_2fort" \
	SRCDS_MAPGROUP="mg_active" \
	SRCDS_GAMETYPE=0 \
	SRCDS_GAMEMODE=1 \
	SRCDS_HOSTNAME="New \"${STEAMAPP}\" Server" \
	SRCDS_WORKSHOP_START_MAP=0 \
	SRCDS_HOST_WORKSHOP_COLLECTION=0 \
	SRCDS_WORKSHOP_AUTHKEY="" \
	ADDITIONAL_ARGS=""



# set -x will print all commands to terminal
RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		wget \
		ca-certificates \
		lib32z1 \
	&& mkdir -p "${STEAMAPPDIR}" \
	&& mkdir -p "${CUSTOM_CONFIG_DIR}" \
	&& rm -rf "${SERVE_DIR}" \
	&& mkdir -p "${SERVE_DIR}" \
	&& { \
		echo '@ShutdownOnFailedCommand 1'; \
		echo '@NoPromptForPassword 1'; \
		echo 'force_install_dir '"${STEAMAPPDIR}"''; \
		echo 'login anonymous'; \
		echo 'app_update '"${STEAMAPPID}"''; \
		echo 'quit'; \
	   } > "${APP}/${STEAMAPP}_update.txt"

COPY entry.sh "${APP}/"

RUN chmod +x "${APP}/entry.sh" \
	&& chown -R "${USER}:${USER}" "${APP}/entry.sh" "${STEAMAPPDIR}" "${APP}/${STEAMAPP}_update.txt" "${CUSTOM_CONFIG_DIR}" "${SERVE_DIR}" \	
	&& rm -rf /var/lib/apt/lists/* 

VOLUME ${STEAMAPPDIR}
VOLUME ${CUSTOM_CONFIG_DIR}

USER ${USER}

WORKDIR ${APP}

CMD ["bash", "entry.sh"]
ENTRYPOINT []
# Expose ports
EXPOSE 27015/tcp \
	27015/udp \
	27020/udp
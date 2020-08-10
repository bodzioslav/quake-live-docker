FROM debian:buster

ARG steam_user=anonymous
ARG steam_password=

# Install SteamCMD and create Steam user
RUN apt update && apt install -y lib32gcc1 curl && \
  mkdir -p /opt/steam && useradd -d /opt/steam -s /bin/bash steam && \
  curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar -C /opt/steam -zxf - && \
  chown -R steam:steam /opt/steam && \
# Cleanup
  apt autoremove -y curl && \
  rm -rf /var/lib/apt/lists/*

# Drop root privileges
USER steam

# Install QLDS
ADD --chown=steam:steam qlds_run.sh /usr/local/bin/qlds_run.sh

RUN mkdir /opt/steam/qlds && chmod +x /usr/local/bin/qlds_run.sh && \ 
  /opt/steam/steamcmd.sh +login $steam_user $steam_password +force_install_dir /opt/steam/qlds +app_update 349090 validate +quit

ENTRYPOINT ["/usr/local/bin/qlds_run.sh"]

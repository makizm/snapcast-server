FROM debian:bullseye-slim

ARG ARCH=armhf
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update

# 266125280a06a4e5e50a50c228969f44a4c11fb748bd7b0e9fb3a5c10c80e15f snapserver_0.26.0-1_amd64.deb
# 6731b1b6c9dd9b60fcb387a4a381c2e816f4cf3a0827e62b0ba82675a379ab57 snapserver_0.26.0-1_armhf.deb

# install dependencies
RUN apt-get install -y curl alsa-topology-conf alsa-ucm-conf dbus libapparmor1 libasound2 libasound2-data \
	libavahi-client3 libavahi-common-data libavahi-common3 libdbus-1-3 libexpat1 libflac8 libgomp1 \
	libogg0 libopus0 libsoxr0 libvorbis0a libvorbisenc2

# fetch snapcast server package
RUN curl -o snapserver.deb -L https://github.com/badaix/snapcast/releases/download/v0.26.0/snapserver_0.26.0-1_${ARCH}.deb

RUN if [ "$ARCH" == "amd64" ]; then echo 266125280a06a4e5e50a50c228969f44a4c11fb748bd7b0e9fb3a5c10c80e15f snapserver.deb | sha256sum -c || exit 1; fi
RUN if [ "$ARCH" == "armhf" ]; then echo 6731b1b6c9dd9b60fcb387a4a381c2e816f4cf3a0827e62b0ba82675a379ab57 snapserver.deb | sha256sum -c || exit 1; fi

# install snapcast server
RUN dpkg -i snapserver.deb

RUN rm snapserver.deb

USER snapserver

VOLUME ["/tmp/snapfifo", "/tmp/snapfifo"]

EXPOSE 1704 1780

CMD ["snapserver"]
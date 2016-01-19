#!/bin/bash

docker build -q -t naelyn/steam . || {
	echo "could not build fresh image" >&2
	exit 1
}

docker kill steam 2>/dev/null || true
docker rm steam || true

set -e

mkdir -p /home/steam

#	-v /etc/machine-id:/etc/machine-id:ro \
#	--link pulseaudio:pulseaudio \
#	-e PULSE_SERVER=pulseaudio \

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

#    -v /etc/machine-id:/etc/machine-id \
# --rm
#	-v /dev/shm:/dev/shm \
#	--device /dev/snd \
##
exec docker run --rm -it \
	-v /etc/localtime:/etc/localtime:ro \
	-v /var/run/dbus:/var/run/dbus \
	-v $XSOCK:$XSOCK:rw \
    -v $XAUTH:$XAUTH:rw \
    -v /run/user/1000/pulse:/run/user/1000/pulse \
    -v /var/lib/dbus:/var/lib/dbus \
	-v /home/steam:/home/naelyn \
	-e DISPLAY=$DISPLAY \
    -e "XAUTHORITY=${XAUTH}" \
	--device /dev/dri \
	--privileged \
	--name steam \
	naelyn/steam

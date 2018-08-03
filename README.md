
https://hub.docker.com/r/toomscj7/rpki3-validator-alpine/

RIPE RPKI 3 validator service running in docker.  You will also need the rpki 3 rtr-server container from my other repository (https://github.com/sethgarrett/rpki-rtr-server-alpine/).

docker run -d -p 8323:8323 -p 8081:8081 toomscj7/rpki3-rtr-server-alpine

docker run -d -p 8088:8080 toomscj7/rpki3-validator-alpine

Both services set to listen on all interfaces.  Configured to be ran on the same docker host.  

rtr-server container connects to rpki3-alpine validator on host.docker.internal

rtr server rpki-rtr-server.sh modified with the following to support host.docker.internal on a Linux host.

#Fixes Linux ability to call host.docker.internal

function fix_linux_internal_host() {
  DOCKER_INTERNAL_HOST="host.docker.internal"

  if ! grep $DOCKER_INTERNAL_HOST /etc/hosts > /dev/null ; then
    DOCKER_INTERNAL_IP=`/sbin/ip route|awk '/default/ { print $3 }'`
    echo -e "$DOCKER_INTERNAL_IP\t$DOCKER_INTERNAL_HOST" | tee -a /etc/hosts > /dev/null
    echo 'Added $DOCKER_INTERNAL_HOST to hosts /etc/hosts'
  fi
}

fix_linux_internal_host

#!/usr/bin/env bash
#
# The BSD License
#
# Copyright (c) 2010-2018 RIPE NCC
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#   - Redistributions of source code must retain the above copyright notice,
#     this list of conditions and the following disclaimer.
#   - Redistributions in binary form must reproduce the above copyright notice,
#     this list of conditions and the following disclaimer in the documentation
#     and/or other materials provided with the distribution.
#   - Neither the name of the RIPE NCC nor the names of its contributors may be
#     used to endorse or promote products derived from this software without
#     specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

if [ "$listen_any" = true ]; then 
  echo "#server.address=localhost" >> /usr/src/rpki-valid/rpki-validator-3.0-312/conf/application.properties
else 
  echo "server.address=localhost" >> /usr/src/rpki-valid/rpki-validator-3.0-312/conf/application.properties 
fi

if [ "$get_arin_tal" = true ]; then
  wget https://www.arin.net/resources/rpki/arin-ripevalidator.tal -O /usr/src/rpki-valid/rpki-validator-3.0-312/preconfigured-tals/arin-ripevalidator.tal
fi


function warn {
    echo -e "[ warning ] $1"
}

function error_exit {
    echo -e "[ error ] $1"
    exit 1
}

EXECUTION_DIR=`dirname "$BASH_SOURCE"`
cd ${EXECUTION_DIR}

if [ -z ${JAVA_CMD} ]; then
  if [ -z ${JAVA_HOME} ]; then
    warn "Neither JAVA_CMD nor JAVA_HOME are set, will try to find java on path."
    export JAVA_CMD=`which java`
  else
    export JAVA_CMD="${JAVA_HOME}/bin/java"
  fi
else
  warn "JAVA_CMD is set"
fi

if [ ! -x $JAVA_CMD ]; then
  error_exit "Cannot find java, please install java 8 or higher"
fi

JAR=${JAR:-"./lib/rpki-validator-3.jar"}
CONFIG_DIR=${CONFIG_DIR:-"./conf"}

CONFIG_FILE="${CONFIG_DIR}/application.properties"

function parse_config_line {
    local CONFIG_KEY="$1"
    local VALUE=`grep "^$CONFIG_KEY" "$CONFIG_FILE" | sed 's/#.*//g' | awk -F "=" '{ print $2 }'`

    if [ -z "$VALUE" ]; then
        error_exit "Cannot find value for: $CONFIG_KEY in config-file: $CONFIG_FILE"
    fi
    eval "$2=$VALUE"
}

parse_config_line "jvm.memory.initial" JVM_XMS
parse_config_line "jvm.memory.maximum" JVM_XMX

MEM_OPTIONS="-Xms$JVM_XMS -Xmx$JVM_XMX"

exec ${JAVA_CMD} ${MEM_OPTIONS} -Dspring.config.location="classpath:/application.properties,file:${CONFIG_DIR}/application-defaults.properties,file:${CONFIG_FILE}" -jar "${JAR}"


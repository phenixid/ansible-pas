#!/bin/bash
#
# Start Phenix Server
#

PHENIX_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
echo "INFO: Using PHENIX_HOME: ${PHENIX_HOME}"

PHENIX_VERSION=$( ${PHENIX_HOME}/bin/version.sh )
echo "INFO: Using PHENIX_VERSION: ${PHENIX_VERSION}"

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Java settings
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

JAVA="$PHENIX_HOME/jre/bin/java"

JAVA_HEAP_SIZE=2G

JAVA_OPTS="-server -d64"

# Memory heap size settings (use same value for min and max)
JAVA_OPTS="${JAVA_OPTS} -Xms${JAVA_HEAP_SIZE} -Xmx${JAVA_HEAP_SIZE}"

# Assertions
#JAVA_OPTS="${JAVA_OPTS} -ea"

# GC
JAVA_OPTS="${JAVA_OPTS} -XX:+HeapDumpOnOutOfMemoryError"
JAVA_OPTS="${JAVA_OPTS} -XX:+UseParNewGC"
JAVA_OPTS="${JAVA_OPTS} -XX:+UseConcMarkSweepGC"
JAVA_OPTS="${JAVA_OPTS} -XX:+CMSParallelRemarkEnabled"
JAVA_OPTS="${JAVA_OPTS} -XX:SurvivorRatio=8"
JAVA_OPTS="${JAVA_OPTS} -XX:MaxTenuringThreshold=1"
JAVA_OPTS="${JAVA_OPTS} -XX:CMSInitiatingOccupancyFraction=75"
JAVA_OPTS="${JAVA_OPTS} -XX:+UseCMSInitiatingOccupancyOnly"
JAVA_OPTS="${JAVA_OPTS} -XX:MaxDirectMemorySize=512G"


# JMX/management
#JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.management.jmxremote.port=7199"
#JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.management.jmxremote.ssl=false"
#JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.management.jmxremote.authenticate=false"

#
# Entropy gathering device
#
# Enable when running i virtualized environments
#
#JAVA_OPTS="${JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom"

# Debug
#JAVA_OPTS="${JAVA_OPTS} -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005"

#Adding from command line#
for var in "$@"
    do
          echo ${var}
           if [[ "$var" == "-D"* ]]
            then
               JAVA_OPTS="${JAVA_OPTS} ${var}"
            fi
done

# Misc
JAVA_OPTS="${JAVA_OPTS} -Djava.awt.headless=true -Dfile.encoding=UTF-8"
JAVA_OPTS="${JAVA_OPTS} -Dhazelcast.phone.home.enabled=false"
JAVA_OPTS="${JAVA_OPTS} -Dstorage.useWAL=true"
#Set timeout until WS client connection is established
JAVA_OPTS="${JAVA_OPTS} -Djavax.xml.ws.client.connectionTimeout=6000"
#Set timeout until the WS client receives a response
JAVA_OPTS="${JAVA_OPTS} -Djavax.xml.ws.client.receiveTimeout=6000"
JAVA_OPTS="${JAVA_OPTS} -Dorg.terracotta.quartz.skipUpdateCheck=true"
JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.xml.internal.ws.request.timeout=6000"
JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.xml.internal.ws.connect.timeout=6000"




##################Proxy settings,To use proxy uncomment and change parameters to fit your environment#######
#http.proxyHost (default: <none>)
#http.proxyPort (default: 80)
#https.proxyHost(default: <none>)
#https.proxyPort (default: 443)
#JAVA_OPTS="${JAVA_OPTS} -Dhttp.proxyHost=127.0.0.1 -Dhttp.proxyPort=8080 -Dhttps.proxyHost=127.0.0.1 -Dhttps.proxyPort=8433"
#############################################

# Logging
JAVA_OPTS="${JAVA_OPTS} -Dlog4j.configurationFile=${PHENIX_HOME}/config/log4j2.xml"
JAVA_OPTS="${JAVA_OPTS} -Djava.util.logging.config.file=${PHENIX_HOME}/config/logging.properties"
JAVA_OPTS="${JAVA_OPTS} -Dorg.vertx.logger-delegate-factory-class-name=com.phenixidentity.server.Log4j2LogDelegateFactory"
JAVA_OPTS="${JAVA_OPTS} -Dhazelcast.logging.type=log4j2"

# Vertx
JAVA_OPTS="${JAVA_OPTS} -Dvertx.home=${PHENIX_HOME}"
JAVA_OPTS="${JAVA_OPTS} -Dvertx.clusterManagerFactory=org.vertx.java.spi.cluster.impl.hazelcast.HazelcastClusterManagerFactory"
JAVA_OPTS="${JAVA_OPTS} -Dvertx.mods=${PHENIX_HOME}/mods"
JAVA_OPTS="${JAVA_OPTS} -Dvertx.pool.worker.size=20"

# Message Gateway Client
JAVA_OPTS="${JAVA_OPTS} -Dmsggw.connection.timeout=4"
JAVA_OPTS="${JAVA_OPTS} -Dmsggw.socket.timeout=4"


# Application
JAVA_OPTS="${JAVA_OPTS} -Dcom.phenixidentity.globals.asyncStoreRequestTimeout=10000"
JAVA_OPTS="${JAVA_OPTS} -Dcom.phenixidentity.globals.http.port=8443"
JAVA_OPTS="${JAVA_OPTS} -Dapplication.name=PhenixServer"

# Override java user.home to enable loading modules from bundled repo in installation (isof m2 repo in user home)
JAVA_OPTS="${JAVA_OPTS} -Duser.home=${PHENIX_HOME}"

# Is running on PhenixID appliance/default

JAVA_OPTS="${JAVA_OPTS} -Dcom.phenixidentity.operatingPlattform=default"

# Classpath
JAVA_CP="-cp ${PHENIX_HOME}/classes"

for file in ${PHENIX_HOME}/lib/*.jar
do
    if [[ -f $file ]]; then
        JAVA_CP="${JAVA_CP}:$file"
    fi
done

SERVER_OPTS=$@

# Run in foreground
RUN_IN_FOREGROUND=$(echo "$SERVER_OPTS" | grep -- "--fg")
SERVER_OPTS=$(echo ${SERVER_OPTS} | sed 's/--fg//g')

JAVA_CMD="${JAVA} ${JAVA_OPTS} ${JAVA_CP} com.phenixidentity.server.Server runmod com.phenixidentity~phenix-node~${PHENIX_VERSION} -conf ${PHENIX_HOME}/config/boot.json ${SERVER_OPTS}"

echo "INFO: Start command: ${JAVA_CMD}"

if [[ ! -z ${RUN_IN_FOREGROUND} ]]; then
    ( cd ${PHENIX_HOME}; nohup ${JAVA_CMD} 2>&1 | tee ${PHENIX_HOME}/logs/nohup.out )
else
    ( cd ${PHENIX_HOME}; nohup ${JAVA_CMD} > ${PHENIX_HOME}/logs/nohup.out 2>&1 & )
fi

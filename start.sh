#!/bin/bash

export NODE_CONFIG_DIR=${NODE_CONFIG_DIR:=config}
export NODE_ENV=${NODE_ENV:=development}

echo "Environment: $NODE_ENV"

function startf(){
    APP=$1
    PIDFILE=$APP.pid

    if [ -e $PIDFILE ]; then
        PID=$(cat $PIDFILE)
        if [ -z "$PID" ]; then
            echo "Cleaning up empty PID file $PIDFILE" >&2
            rm -f $PIDFILE
        elif pidof nodejs | grep -q "$PID"; then
            echo "Not starting $APP, running PID $PID" >&2
            return 1
        else
            echo "Process $PID no longer running; deleting $PIDFILE" >&2
            rm -f $PIDFILE
        fi
    fi
    echo "node $APP" >&2
    node $APP
}

startf ./dummy-servers/MemStore-server.js # this is a no-op unless "MemStore" is a configured storage type.
startf ./dummy-servers/resource-server.js # this is a no-op unless resource_server.type is "dummy"
startf ./src/server.js
exit 0

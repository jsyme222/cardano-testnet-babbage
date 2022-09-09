#!/bin/bash

cardano-node run --config /mount/preprod-node-config.json --topology /mount/preprod-topology-config.json --database-path /data/db --socket-path /ipc/node.socket

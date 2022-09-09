#!/bin/bash

cardano-node run --config /mount/preview-node-config.json --topology /mount/preview-topology-config.json --database-path /data/db --socket-path /ipc/node.socket

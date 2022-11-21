#!/bin/bash

cardano-node run --config /mount/config.json --topology /mount/topology.json --database-path /data/db --socket-path /ipc/node.socket

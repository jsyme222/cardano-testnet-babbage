#!/user/bin/bash

networkName=${1:-'preview'}
containerDirection=${2-'up'}
containerAction=$3
testnetDir="$HOME/.local/share/cardano-testnet-node"

if [[ ! -d $testnetDir ]]
then
	. ./install.sh
fi

docker-compose -f $testnetDir/docker-compose-$networkName.yml $containerDirection $containerAction

#!/usr/bin/bash

function installCardanoTestnet() {
	dir="$HOME/.local/share/cardano-testnet-node"
	previewDir="$dir/preview/mount"
	preprodDir="$dir/preprod/mount"
	binFile="$HOME/.local/bin/cardano-testnet"

	if [[ ! -d $dir ]]; then
		mkdir $dir
	fi
	if [[ ! -d $previewDir ]]; then
		mkdir -p $previewDir
	fi
	if [[ ! -d $preprodDir ]]; then
		mkdir -p $preprodDir
	fi

	cp ./docker-compose-preview.yml docker-compose-preprod.yml $dir
	echo "Installed docker-compose files at $dir"
	cp ./preview/mount/* $previewDir
	echo "Installed preview files at $previewDir"
	cp ./preprod/mount/* $preprodDir
	echo "Installed preprod files at $preprodDir"

	if [[ ! -f $binFile ]]; then
		touch $binFile
		echo "#!/usr/bin/bash" >>$binFile
		echo 'networkName=${1:-"preview"}' >>$binFile
		echo 'containerDirection=${2-"up"}' >>$binFile
		echo 'containerAction=$3' >>$binFile
		echo 'testnetDir="$HOME/.local/share/cardano-testnet-node"' >>$binFile
		echo 'docker-compose -f $testnetDir/docker-compose-$networkName.yml $containerDirection $containerAction' >>$binFile
		chmod +x $binFile
	fi

	echo "Installed Commands at $HOME/.local/bin"
}

function removeCardanoTestnet() {
	echo "This will remove ALL data for both testnets. Are you sure?"
	read -p "yes/no:  " confirm
	echo "RESPONSE: $confirm"
	if [[ "$confirm" != "yes" ]]; then
		echo "Data preserved"
	else
		sudo rm -rf $HOME/.local/share/cardano-testnet-node/ && rm $HOME/.local/bin/cardano-testnet
		echo "Caradano-node data removed."
	fi
}

#!/bin/bash

alias tip="cardano-cli query tip --testnet-magic $MAGIC"

function getUtxo() {
	cardano-cli query utxo --address $1 --testnet-magic $MAGIC
}

alias utxo="getUtxo"

function toBase16() {
	name=$1
	echo -n $name | basenc --base16 | tr '[:upper:]' '[:lower:]'
}

function mintToken() {
	policyDir=./policy
	if ! [[ -d "$policyDir" ]]; then
		echo "No policy dir found"
		read -p "Policy dir: " policyDir
	fi
	if [[ -z "$txhash" || -z "$txix" || -z "$funds" ]]; then
		echo "No transaction details stored:"
		echo "	- \$txhash"
		echo "	- \$txix"
		echo "	- \$funds"
		return 0
	fi
	if [[ -z "$ADDR" ]]; then
		echo "No change address/Payment wallet set:"
		echo "	- \$ADDR"
		read -p "Address: " ADDR
	fi

	testnet="--testnet-magic $MAGIC"
	tokenname=$(toBase16 $1)
	tokenamount=$2
	policyid=$(cat $policyDir/policyID)
	output="2000000"
	fee="300000"

	echo "$tokenname, $tokenamount, $policyid"

	echo "Minting $tokenamount $1"
	echo "Starting..."

	cardano-cli transaction build-raw \
		--fee $fee \
		--tx-in $txhash#$txix \
		--tx-out $ADDR+$output+"$tokenamount $policyid.$tokenname" \
		--mint "$tokenamount $policyid.$tokenname" \
		--minting-script-file $policyDir/policy.script \
		--out-file mint.raw

	fee=$( cardano-cli transaction calculate-min-fee \
		--tx-body-file mint.raw \
		--tx-in-count 1 --tx-out-count 1 \
		--witness-count 2 $testnet \
		--protocol-params-file protocol.json | cut -d " " -f1 )

	echo "FEE: $fee"

	output=$(expr $funds - $fee)

	cardano-cli transaction build-raw \
		--fee $fee \
		--tx-in $txhash#$txix \
		--tx-out $ADDR+$output+"$tokenamount $policyid.$tokenname" \
		--mint "$tokenamount $policyid.$tokenname" \
		--minting-script-file $policyDir/policy.script \
		--out-file mint.raw

	read -p "Payment signing key file: " sKey

	cardano-cli transaction sign \
		--signing-key-file $sKey \
		--signing-key-file $policyDir/policy.skey \
		$testnet --tx-body-file mint.raw \
		--out-file mint.signed

	cardano-cli transaction submit --tx-file mint.signed $testnet
}

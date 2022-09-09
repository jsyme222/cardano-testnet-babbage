# cardano-testnet-babbage

### This repo contains the docker-compose files and associated config files to run and interact with a cardano testnet (preview and pre-production) node 1.35.3+

</br>
</br>

> INSTALL NOTE: If you want to install the docker-compose/config files to run the nodes with a quick command there is an `install.sh ` file included. (Ubuntu 22+ tested only)

- To **install** the files run:
  > `. ./install && installCardanoTestnet`
- To **run** the node:
  > `cardano-testnet`
- This will default to the "preview" network. To run the preprod network:
  > `cardano-testnet preprod`
- To **uninstall**:
  > `. ./install.sh && removeCardanoTestnet`

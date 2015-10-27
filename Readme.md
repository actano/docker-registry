# Start private docker registry

## Prerequisites

* have a domain for the registry
* TLS certificate for the domain

## Configure authentication

You can configure basic auth for the registry by creating a password file. You can use

    docker run --entrypoint htpasswd registry:2 -Bbn <username> <password> > htpasswd

for example, to create a login for user `<username>` with password `<password>` and output it to a `htpasswd` file.

## Starting the registry

Simply run the `start.sh` script with the following arguments

* `-D <domain>` - where `<domain>` is the FQDN for your registry
* `-d <data dir>` - where `<data dir>` is the directory where the images which get inserted into the registry are stored
* `-c <cert file>` - where `<cert file>` is the path to the certificate file of your TLS certificate
* `-k <key file>` - where `<key file>` is the path to the private key file of your TLS certificate
* `-a <auth file>` - where `<auth file>` is the path to the auth file from the previous section used for basic auth

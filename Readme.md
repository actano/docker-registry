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

## Cleaning up the registry

1. Clean up stale manifests, i.e. meta data of images which are obsolete: run `cleanupManifestsWithoutTags.sh`.
(Remember to set `USERNAME` and `PASSWORD` variables in the script and to adjust `REGISTRY_DIR` and `REGISTRY_URL` as necessary)
2. Garbage collect non-reachable image layers:
  * Start a shell in the running registry container: `docker exec -it registry sh`
  * Run the garbage collect command: `registry garbage-collect --dry-run /etc/docker/registry/config.yml`
    First dry run. If everything looks sane, run the command again without `--dry-run`.

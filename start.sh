#!/bin/bash

function usage() {
    echo "Usage: $0 -D <domain> -d <data dir> -c <cert file> -k <key file> -a <auth file>"
    exit 1
}

function abspath() {
    echo "$(cd "$(dirname $1)" && pwd)/$(basename $1)"
}

while getopts ":D:d:c:k:a:" opt; do
    case "${opt}" in
        D)
            DOMAIN=$OPTARG
            ;;
        d)
            DATA_DIR=$(abspath $OPTARG)
            ;;
        c)
            CERT_FILE=$(abspath $OPTARG)
            ;;
        k)
            KEY_FILE=$(abspath $OPTARG)
            ;;
        a)
            AUTH_FILE=$(abspath $OPTARG)
            ;;
        *)
            usage
            ;;
    esac
done

if [ -z "$CERT_FILE" ] || [ -z "$KEY_FILE" ] || [ -z "$AUTH_FILE" ] || [ -z "$DATA_DIR" ] || [ -z "$DOMAIN" ]; then
    usage
fi

docker run -d -p 443:5000 --restart=always --name registry \
  -v $DATA_DIR:/var/lib/registry \
  -v $CERT_FILE:/certs/domain.crt \
  -v $KEY_FILE:/certs/domain.key \
  -v $AUTH_FILE:/auth/htpasswd \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
  -e REGISTRY_AUTH=htpasswd \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  registry:2

docker run -d -p 8080:80 --name frontend \
  -e ENV_DOCKER_REGISTRY_HOST=$DOMAIN \
  -e ENV_DOCKER_REGISTRY_PORT=443 \
  -e ENV_DOCKER_REGISTRY_USE_SSL=1 \
  konradkleine/docker-registry-frontend:v2

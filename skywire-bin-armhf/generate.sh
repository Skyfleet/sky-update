#!/usr/bin/env bash

openssl req \
    -new \
    -x509 \
    -newkey rsa:2048 \
    -sha256 \
    -nodes \
    -keyout /usr/lib/skycoin/skywire/ssl/key.pem \
    -days 3650 \
    -out /usr/lib/skycoin/skywire/ssl/cert.pem \
    -config /usr/lib/skycoin/skywire/ssl/certificate.cnf

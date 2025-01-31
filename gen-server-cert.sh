#!/bin/bash

TUTORIAL_HOME=.

# install cfssl sudo apt install golang-cfssl

cfssl gencert -ca=$TUTORIAL_HOME/generated/cacerts.pem \
-ca-key=$TUTORIAL_HOME/generated/rootCAkey.pem \
-config=$TUTORIAL_HOME/ca-config.json \
-profile=client $TUTORIAL_HOME/server-domain.json | cfssljson -bare $TUTORIAL_HOME/generated/client


openssl x509 -in generated/client.pem -text -noout

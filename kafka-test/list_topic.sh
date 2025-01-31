#!/bin/bash
#
bootstrap_server=""

# list topics in the cluster
kafka-topics --bootstrap-server $bootstrap_server \
  --command-config mtls.config \
  --list

#!/bin/bash
#
bootstrap_server=""

# list topics in the cluster
kafka-console-consumer --bootstrap-server $bootstrap_server \
	--consumer.config mtls.config \
  	--topic clickstream_copy


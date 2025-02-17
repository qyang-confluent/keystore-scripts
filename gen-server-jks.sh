#!/bin/bash
#
server=$1
serverKey=$2
ca=$4
caKey=$5
password=$3

server=./generated/client.pem
serverKey=./generated/client-key.pem
ca=./generated/cacerts.pem
caKey=./generated/rootCAkey.pem
password=testme

if [ -e ./jks/keystore.jks ];then
  rm  ./jks/keystore.jks
else
  mkdir -p jks
fi


echo "Check $server certificate"
#openssl x509 -in "${server}" -text -noout

openssl pkcs12 -export \
	-in "${ca}" \
	-inkey "${caKey}" \
	-out ./jks/ca-pkcs.p12 \
	-name testCA \
	-passout pass:mykeypassword

keytool -importkeystore \
	-deststorepass "${password}" \
	-destkeypass "${password}" \
	-destkeystore ./jks/keystore.jks \
	-deststoretype pkcs12 \
	-srckeystore ./jks/ca-pkcs.p12 \
	-srcstoretype PKCS12 \
	-srcstorepass mykeypassword

rm -f ./jks/keystore.jks

openssl pkcs12 -export \
	-in "${server}" \
	-inkey "${serverKey}" \
	-out ./jks/pkcs.p12 \
	-name testService \
	-passout pass:mykeypassword

keytool -importkeystore \
	-deststorepass "${password}" \
	-destkeypass "${password}" \
	-destkeystore ./jks/keystore.jks \
	-deststoretype pkcs12 \
	-srckeystore ./jks/pkcs.p12 \
	-srcstoretype PKCS12 \
	-srcstorepass mykeypassword

keytool -import -trustcacerts -noprompt -alias "testCA" -file "${ca}" -keystore "./jks/keystore.jks" -deststorepass "${password}" 

echo "Validate Keystore"
keytool -list -v -keystore ./jks/keystore.jks -storepass "${password}"

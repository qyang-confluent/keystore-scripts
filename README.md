# Create one certificate for all components

When testing, it's often helpful to generate your own certificates to validate the architecture and deployment.

In this scenario workflow, you'll create one client certificate. You'll use the same certificate authority.

Set the `TUTORIAL_HOME` path to ease directory references in the commands you run:
```
export TUTORIAL_HOME=<Git repository path>/assets/certs
```

This scenario workflow requires the following CLI tools to be available on the machine you
are using:

- openssl
- cfssl

## Setting the Subject Alternate Names

The Subject Alternate Names are specified in the `hosts` section of the $TUTORIAL_HOME/server-domain.json 
files. If you want to change any of the above assumptions, then edit the $TUTORIAL_HOME/server-domain.json 
files accordingly.

## Create a certificate authority

In this step, you will create:

* Certificate authority (CA) private key (`ca-key.pem`)
* Certificate authority (CA) certificate (`ca.pem`)

1. Generate a private key called rootCAkey.pem for the CA:

```
openssl genrsa -out $TUTORIAL_HOME/generated/rootCAkey.pem 2048
```

2. Generate the CA certificate.

```
openssl req -x509  -new -nodes \
  -key $TUTORIAL_HOME/generated/rootCAkey.pem \
  -days 3650 \
  -out $TUTORIAL_HOME/generated/cacerts.pem \
  -subj "/C=US/ST=CA/L=MVT/O=TestOrg/OU=Cloud/CN=TestCA"
```

3. Check the validatity of the CA

```
openssl x509 -in $TUTORIAL_HOME/generated/cacerts.pem -text -noout
```

## Create a client Certificate 

```
cfssl gencert -ca=$TUTORIAL_HOME/generated/cacerts.pem \
-ca-key=$TUTORIAL_HOME/generated/rootCAkey.pem \
-config=$TUTORIAL_HOME/ca-config.json \
-profile=client $TUTORIAL_HOME/server-domain.json | cfssljson -bare $TUTORIAL_HOME/generated/client
```

## Create Java JKS keystore
```
server=client.pem
serverKey=client-key.pem
ca=cacerts.pem
caKey=rootCAkey.pem
password=testme

openssl x509 -in ${server} -text -noout

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

echo "Validate Keystore"
keytool -list -v -keystore ./jks/keystore.jks -storepass "${password}"
#you can run this to automate it sh ../gen-server-jks.sh client.pem client-key.pem testme cacerts.pem rootCAkey.pem
```

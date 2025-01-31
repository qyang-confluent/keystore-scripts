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
```

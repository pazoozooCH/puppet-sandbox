# For more details, see https://inftec.atlassian.net/wiki/display/TEC/SSL+Encryption

# Create CA test certificate:

openssl genrsa -out root-ca.key

# Create Certificate
## FQDN: InfTec Local Test Certificate Authority
openssl req -new -x509 -key root-ca.key -out root-ca.pem

# Create new private key and certification request
## PEM pass phrase: test
## FQDN: puppet.example.com
openssl req -newkey rsa -keyout test.key -out test.req

# Sign request

# Prepare CA files
mkdir -p demoCA/newcerts
touch demoCA/index.txt
echo 01 >demoCA/serial

# Sign request
openssl ca -keyfile root-ca.key -cert root-ca.pem -in test.req -out test.pem

# Create certificate with alt names
cp /etc/ssl/openssl.cnf openssl-test-alt.cnf
## Edit file to use subjectAltName and v3_req extensions. See http://apetec.com/support/GenerateSAN-CSR.htm

## Create new private key
openssl genrsa -out test-alt.key

## Create a new signing request
openssl req -new -out test-alt.req -key test-alt.key -config openssl-test-alt.cnf
### Test with:
openssl req -text -in test-alt.req

## Sign the request
openssl ca -keyfile root-ca.key -cert root-ca.pem -in test-alt.req -out test.pem

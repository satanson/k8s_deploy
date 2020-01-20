  cfssl genkey -initca ca-csr.json | cfssljson -bare ca
  cfssl gencert -ca ca.pem -ca-key ca-key.pem -config ca-config.json -profile client client.json |cfssljson -bare client
  cfssl gencert -ca ca.pem -ca-key ca-key.pem -config ca-config.json -profile peer peer0.json |cfssljson -bare peer0
  cfssl gencert -ca ca.pem -ca-key ca-key.pem -config ca-config.json -profile peer peer1.json |cfssljson -bare peer1
  cfssl gencert -ca ca.pem -ca-key ca-key.pem -config ca-config.json -profile peer peer2.json |cfssljson -bare peer2
  cfssl gencert -ca ca.pem -ca-key ca-key.pem -config ca-config.json -profile server  server.json |cfssljson -bare server

  openssl pkcs12 -export -in server.pem -inkey server-key.pem -out server.pk12 -name serverkey -passout pass:123456
  keytool -importkeystore -deststorepass 123456 -destkeypass 123456 -destkeystore server.keystore -srckeystore server.pk12 -srcstoretype PKCS12 -srcstorepass 123456 -alias serverkey
  keytool -importkeystore -srckeystore server.keystore -destkeystore server.keystore -deststoretype pkcs12
  openssl x509 -outform der -in server.pem -out server.crt
  openssl x509 -outform der -in ca.pem -out ca.crt
openssl x509 -in ca.pem -text -noout
openssl x509 -in server.crt --inform -text -noout
openssl rsa -outform der -in server-key.pem -out server.key

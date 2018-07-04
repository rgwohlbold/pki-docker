#!/bin/bash
export OUTDIR="/openvpn"

ca() {
    # Establish CA
    echo -en "docker-vpn\n" | easyrsa build-ca nopass

    # Copy CA certificate
    mkdir -p "$OUTDIR/ca"
    cp "/etc/easy-rsa/pki/private/ca.key" "$OUTDIR/ca"
    cp "/etc/easy-rsa/pki/ca.crt" "$OUTDIR/ca"
}

ca_sign_client() {
    echo -en "yes\n" | easyrsa sign-req client "$1"
}

ca_sign_server() {
    echo -en "yes\n" | easyrsa sign-req server "$1"
}

server() {
    if [ "$1" = "" ]; then
        $1="server"
    fi
    # TODO make 2048
    # Generate Diffie-Hellman params file and HMAC key
    openssl dhparam -out "$OUTDIR/dh.pem" 512
    openvpn --genkey --secret "$OUTDIR/ta.key"

    # Generate request and key
    echo -en "\n" | easyrsa gen-req "$1" nopass
    ca_sign_server "$1"

    # Copy data
    mkdir -p "$OUTDIR/server"
    cp "/etc/easy-rsa/pki/private/$1.key" "$OUTDIR/server"
    cp "/etc/easy-rsa/pki/issued/$1.crt" "$OUTDIR/server"
}

client() {
    if [ "$1" = "" ]; then
        $1="client"
    fi

    echo -en "\n" | easyrsa gen-req "$1" nopass
    ca_sign_client "$1"

    # Copy data
    mkdir -p "$OUTDIR/client_$1"
    cp "/etc/easy-rsa/pki/private/$1.key" "$OUTDIR/client_$1/client_$1.key"
    cp "/etc/easy-rsa/pki/issued/$1.crt" "$OUTDIR/client_$1/client_$1.crt"
}

export EASYRSA="$(pwd)"
easyrsa init-pki

case "$1" in
"ca")
    ca
    ;;
"server")
    server server
    ;;
"client")
    name="$(dd if=/dev/urandom count=1 | sha256sum | cut -c1-6)"
    client "$name"
    ;;
"full")
    ca
    server server
    name="$(dd if=/dev/urandom count=1 | sha256sum | cut -c1-6)"
    client "$name"
    ;;
*)
    cat <<EOF
Options:
- ca --> Generate the CA certificate
- server --> Generate the server certificates
- client --> Generate a client certificate
- full --> Generate CA, server and client certificates
EOF
    ;;
esac

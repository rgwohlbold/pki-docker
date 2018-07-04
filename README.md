# pki-docker

**WARNING: THIS IMAGE DOES NOT FOLLOW GOOD SECURITY PRACTICES, SUCH AS NEVER SHARING KEYS WITH ANYBODY. ALL KEYS SHOULD BE KEPT SECRET AT ALL TIMES. I DO NOT TAKE ANY LIABILITY FOR ANY DAMAGES THAT ARISE BECAUSE OF THE USE OF THIS SCRIPT.**

## General
pki-docker is a quick and dirty way to setup a public key infrastructure.

It creates a Certificate Authority (CA) and generates keys and certificates for a server and multiple clients. It is not suited for VPNs that are used by multiple people because
keys and certificates are visible to the CA. Keys should only be distributed to their respective machines.

The command to run the image is 
```
docker run --rm --mount type=bind,source="<DIRECTORY>/certs",target=/openvpn --mount type=bind,source="<DIRECTORY"/easy-rsa",target=/etc/easy-rsa vpn-docker:latest /data/generate_keys.sh full
```
This generates the CA, a server and a client certificate. 

To generate additional clients when the CA is already established, run 
```
docker run --rm --mount type=bind,source="<DIRECTORY>/certs",target=/openvpn --mount type=bind,source="<DIRECTORY>/easy-rsa",target=/etc/easy-rsa vpn-docker:latest /data/generate_keys.sh client
```

The easy-rsa data will be stored under ```easy-rsa/```, the certificates can be found under ```certs/```.
Simple set of scripts to set up a barebones Openvpn server with a single client.
Note: this server does not support ip forwarding (without modification), so
can only be used for a virtual subnet.

Disclaimer: This is not meant to be secure. Do not use this for sensitive data.

### Usage

`./generate.sh` - Generate keys, certificates, and a single ovpn client config.
Outputs to `dist/`.
`./run.sh` - Uses the generate keys to start an openvpn server.

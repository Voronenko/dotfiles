On a new computer, where you intend to encrypt/decrypt using key from Yubikey,
copy contents of this folder to `~/.gnupg`

Depending on state, you might want to kill/restart gpg agent with

`pkill gpg-agent` or`gpgconf --kill gpg-agent`

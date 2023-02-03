# ykoauth-cli

CLI for getting TOTP codes from a Yubikey

# Usage

Simply insert your yubikey and run `ykoauth-cli` and you'll get a fuzzy-searchable list of token stored on the yubikey

```
   Nextcloud:example
   Google:example@gmail.com
   Amazon:me@example.com
   PayPal:example
   DigitalOcean:me@example.com
   Patreon:me@example.com
   HackerOne:example
>  Microsoft:me@example.com

$
```

Once a token is selected it will be printed and, if the (default) `clipboard` feature is enabled, copied to clipboard.

# Dependencies

- `pcsclite` for communicating with the yubikey
- `libX11` (optional) for the `clipboard` feature
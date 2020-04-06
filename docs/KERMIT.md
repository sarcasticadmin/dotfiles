# Kermit

## Overriding configs

Inside a kermit config file its possible to override a kermit parameter

```
set speed 9600
if defined \%1 set speed \%1
```

Then to override it while calling `kermit`:

```
kermit myconfig.kermit = 115200
```

This will cause `kermit` to connect at 115200 instead of the default 9600 baud.

# NinoTNC

[KISS TNC](https://www.tnc-x.com/kiss.htm)

## Testing

Original instruction for Windows: https://groups.io/g/ninotnc/message/204

Set the baud for the device:

```
~$ stty 57600 -F /dev/ttyACM0
```

Send the following command to the device:

```
$ echo -ne '\xC0\x0C\xC0' > /dev/ttyACM0
```

Check the reponse:

```
~$ cat -v < /dev/ttyACM0
M-@M-`2.35-@^C^C
```

Good, looks like the TNC is working with version 2.35 of the firmware.

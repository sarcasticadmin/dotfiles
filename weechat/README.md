# sec.conf
This is ignored by git since it contains sensitive info. Upon initial config of weechat make sure setup the following:

Local passphrase:
```
/secure passphrase this is my secret passphrase
```

Freenode passphrase for user:
```
/secure set freenode_password xxxxxxx
```

Restart weechat

# ssl
ssl CA root and intermediate for `freenode` since default ssl ca location vary between distros. Currently
these CAs are kept in:
```
%h/ssl/ca.crt
```

Append any additional CAs for other servers if necessary

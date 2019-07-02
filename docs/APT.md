# Apt

## My desired default

Make sure to configure apt to default to:

```
-o Dpkg::Options::="--force-confold"
```

This will allow `dpkg` to not prompt a user for what to do with a conflicting default config
file from a package and instead just add a suffix `.dpkg-dist`. Similar to `.rpm`'s default
behavior

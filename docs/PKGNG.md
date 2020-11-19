# PKGNG

## Fetching pkgs for local distribution

To download freebsd pkgs locally:

```
pkg fetch -d -U --output . mons
```
> NOTE: this can be run as a normal user

## Nginx catching

Source: https://forums.freebsd.org/threads/local-cache-for-pkgs.60859/

nginx.conf:

```


       server {
                listen          80;
                server_name     freebsd-pkg.dmz.localdomain.lan freebsd-pkg.lan.localdomain.lan freebsd-pkg.localdomain.lan;

                location / {
                        root                    /var/cache/packages/freebsd/;
                        try_files               $uri @cache;
                }
                location @cache {
                        root                    /var/cache/packages/freebsd/;
                        proxy_store             on;
                        proxy_pass              https://pkg.freebsd.org;
                        proxy_cache_lock        on;
                        proxy_cache_lock_timeout        20s;
                        proxy_cache_revalidate  on;
                        proxy_cache_valid       200 301 302 24h;
                        proxy_cache_valid       404 10m;
                }
        } 

```

Make sure that the cache dir is owned by `www`:

```
mkdir -p /var/cache/packages/freebsd
chown www:www /var/cache/packages/freebsd
```

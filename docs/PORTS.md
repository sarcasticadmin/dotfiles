# Ports

## Generating a patch file

Start with the top section 4.4
https://www.freebsd.org/doc/en_US.ISO8859-1/books/porters-handbook/slow-patch.html

Also note that if you need to do this conditionally (based on freebsd version, etc.), then suffix patch with `extra-`
and add the conditional block like:

```
.include <bsd.port.options.mk>

# Patch in the iconv const qualifier before this
.if ${OPSYS} == FreeBSD && ${OSVERSION} < 1100069
EXTRA_PATCHES=  ${PATCHDIR}/extra-patch-fbsd10
.endif

.include <bsd.port.mk>
```
> OSVERSION can be looked up by `uname -U`


## Generating a patch for bugzilla

Assuming your ports tree was cloned down with `git`:

```
git format-patch HEAD~<num of commits to convert to patch>
```
> Ref: http://nickdesaulniers.github.io/blog/2017/05/16/submitting-your-first-patch-to-the-linux-kernel-and-responding-to-feedback/

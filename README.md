# PGPMIME Mail

PGP/MIME is a mail standard for signing and encrypting emails. This repository
has some supplemental software to use PGP/MIME in form of scripts.

## Prerequisites

### Perl modules

The scripts depend on some Perl modules.

* [MIME::QuotedPrint](http://search.cpan.org/~gaas/MIME-Base64-3.15/QuotedPrint.pm)
* [MIME::Lite](http://search.cpan.org/~yves/MIME-Lite-3.01/lib/MIME/Lite.pm)
* [File::Temp](http://search.cpan.org/~dagolden/File-Temp-0.2304/lib/File/Temp.pm)

### Shell commands

These shell commands (programs) should be available:

* `getent passwd <username>`
* `hostname -f`
* `gpg2`

### Other

The scripts use `/tmp` to store a few kilobytes of temporary data. The written
data will be tidied up, when not needed anymore.

## Scripts

At the moment, there is only one single script to sign emails. The
collection of scripts will be extended in some future.

### pgpmime-sign.pl

This script takes two arguments, destination email address and subject, and
needs the mail body to be piped to `stdin`. It constructs a signed email which
is ready to be piped in into `sendmail` or equivalent.

#### Syntax

```
pgpmime-sign.pl email-addr subject < mail-body
```

#### Examples

```
pgpmime-sign.pl john@example.org "Here comes a signed email!" < mail.txt
```

```
echo "Well, hello!" | pgpmime-sign.pl john@example.org "Here comes a signed email!"
```

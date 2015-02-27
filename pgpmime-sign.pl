#!/usr/bin/perl

use strict;

use MIME::QuotedPrint;
use MIME::Lite;
use File::Temp qw / tempfile /;

my ($to,$subject) = @ARGV;
die "Destination and subject missing." if (length($to)==0 || length($subject)==0);

my $user = quotemeta $ENV{"LOGNAME"};
my @host = `hostname -f`;
my $host = qq/$host[0]/;
chomp $host;
my @fullname = `getent passwd "$user" | cut -f 5 -d ':'`;
my $fullname = $fullname[0];
chomp $fullname;
my $from = qq/"$fullname" <$user\@$host>/;

my $body = join("", <STDIN>);

my $email = MIME::Lite->new(Type=>'multipart/signed');

$email->attr('content-type.protocol'=>'application/pgp-signature');
$email->attr('content-type.micalg'=>'PGP-SHA512');
$email->attach(Type=>'text/plain', Encoding=>'quoted-printable', Data=>$body);

my $FILE;
my ($FILE, $tmpfile) = tempfile( DIR => "/tmp");
close(FILE);

# convert to CRLF
my $part = ($email->parts)[0]->as_string;
$part =~ s/\n/\r\n/g;

open(FILE, "|gpg2 --digest-algo SHA512 -a --detach-sign > \"$tmpfile\"");
print FILE $part;
close(FILE);

open(FILE, "$tmpfile");
my $signature = join("", <FILE>);
close(FILE);


$email->attach(Type=>'application/pgp-signature', Filename=>'signature.asc', Disposition=>'attachment', Encoding=>'7bit', Data=>$signature);
$email->add('To'=>$to);
$email->add('From'=>$from);
$email->add('Subject'=>$subject);

unlink $tmpfile || warn "Could not delete $tmpfile";

$email->print(\*STDOUT);

exit 0;

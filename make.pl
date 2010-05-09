#!/usr/bin/env perl

use warnings;
use strict;

use lib q{.};
use PerlProvides;
use Template;

my $tt = Template->new();

open my $pkgbuild_file, '>', 'PKGBUILD' or die "open PKGBUILD:$!";

$tt->process( 'PKGBUILD.tt',
              { provides => scalar perl_provides( '5.012' ) },
              'PKGBUILD' ) or die "TT process failed: ", $tt->error;

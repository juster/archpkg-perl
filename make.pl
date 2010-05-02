#!/usr/bin/env perl

use warnings;
use strict;

use lib q{.};
use Perl512Provides;
use Template;

my $tt = Template->new();

open my $pkgbuild_file, '>', 'PKGBUILD'
    or die "open PKGBUILD:$!";

$tt->process( 'PKGBUILD.tt', { provides => provides_text },
              'PKGBUILD' )
    or die "TT process failed: ", $tt->error;

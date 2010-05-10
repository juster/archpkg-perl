#!/usr/bin/env perl

use warnings;
use strict;
use lib q{.};

use PerlProvides qw(perl_provides);
use File::Path   qw(remove_tree);
use Template     qw();

my $tt = Template->new();

open my $pkgbuild_file, '>', 'PKGBUILD' or die "open PKGBUILD:$!";

$tt->process( 'PKGBUILD.tt',
              { provides => scalar perl_provides( '5.012' ) },
              'PKGBUILD' ) or die "TT process failed: ", $tt->error;

remove_tree( $_ ) for qw/ src pkg /;

system 'makepkg -f';

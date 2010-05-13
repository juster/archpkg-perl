#!/usr/bin/env perl

use warnings;
use strict;
use lib q{.};

use PerlProvides qw(perl_provides);
use File::Path   qw(remove_tree);
use Getopt::Long qw(GetOptions);
use Template     qw();

my ($SKIP_TEST);
GetOptions( 'skiptest' => \$SKIP_TEST );

my $tt = Template->new();

open my $pkgbuild_file, '>', 'PKGBUILD' or die "open PKGBUILD:$!";

$tt->process( 'PKGBUILD.tt',
              { provides => scalar perl_provides( '5.012' ),
                skiptest => $SKIP_TEST,
               },
              'PKGBUILD' ) or die "TT process failed: ", $tt->error;

remove_tree( $_ ) for qw/ src pkg /;

system 'makepkg -f';

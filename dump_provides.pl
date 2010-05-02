#!/usr/bin/perl

use warnings;
use strict;
use lib q{.};
use Perl512Provides;
use 5.010;

my %provides = generate_provides();

say q{provides=(};
say "$_=$provides{$_}" for keys %provides;
say q{)};

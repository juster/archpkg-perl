#!/usr/bin/perl

use warnings;
use strict;
use lib q{.};
use PerlProvides;

print qq{provides=(\n}, scalar perl_provides( '5.012' ), qq{)\n};

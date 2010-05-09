#!/usr/bin/env perl
use warnings;
use strict;

package PerlProvides;

use CPANPLUS::Dist::Arch qw(dist_pkgname dist_pkgver);
use CPANPLUS::Backend    qw();
use Module::CoreList     qw();
use ALPM; # for ALPM::Package::vercmp

use Exporter;
our @ISA = qw(Exporter);

our @EXPORT = qw(perl_provides);

my %provides_for_ver;
sub perl_provides
{
    Carp::croak 'Must supply a perl version as argument'
        unless @_ > 0;
    my $version = shift;

    return $provides_for_ver{ $version }
        if exists $provides_for_ver{ $version };

    my $be      = CPANPLUS::Backend->new();
    my $modlist = $Module::CoreList::version{ $version }
        or die qq{Try updating perl or the Module::CoreList module.
Module::CoreList does not have info for perl $version};

    my $provides = $provides_for_ver{ $version } = {};

    # Store the package & version unless we have a newer version stored.
    my $store_ref = sub {
        my ($pkgname, $pkgver) = @_;

        CHECK:
        { 
            last CHECK unless exists $provides->{ $pkgname };
            my $cmp = ALPM::Package::vercmp( $provides->{ $pkgname },
                                             $pkgver );
            return if $cmp >= 0;
        }
        $provides->{ $pkgname } = $pkgver;
        return;
    };
    
    MOD_LOOP:
    for my $module ( keys %$modlist ) {
        my $mod_obj = $be->module_tree( $module );
        unless ( $mod_obj ) {
            warn "Could not find module: $module\n";
            next MOD_LOOP;
        }

        my $pkgname = dist_pkgname( $mod_obj->package_name() );
        my $mod_ver = $modlist->{ $module };
        my $pkgver  = $mod_ver ? dist_pkgver( $mod_ver ) : 0;

        $store_ref->( $pkgname, $pkgver );
    }

    delete $provides->{ perl };
    return wantarray ? %$provides : _to_string( $provides );
}

sub _to_string
{
    my $provides = shift;

    return join q{}, map { "$_=$provides->{$_}\n" } sort keys %$provides;
}

1;

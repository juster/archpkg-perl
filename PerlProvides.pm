#!/usr/bin/env perl
use warnings;
use strict;

use CPANPLUS::Dist::Arch qw(dist_pkgname dist_pkgver);
use CPANPLUS::Backend    qw();
use Module::CoreList     qw();
use ALPM; # for ALPM::Package::vercmp

use Exporter;
our @ISA = qw(Exporter);

our @EXPORT = qw/ generate_provides provides_text /;

my %provides_ver_of;

sub _have_newer_pkgver
{
    my ($pkgname, $pkgver) = @_;
    return 0 unless exists $provides_ver_of{ $pkgname };
    return ( 1 > ALPM::Package::vercmp( $provides_ver_of{ $pkgname },
                                        $pkgver ));
}

sub generate_provides
{
    my $be      = CPANPLUS::Backend->new();
    my $modlist = $Module::CoreList::version{ 5.012 }
        or die 'We need a more recent version of Module::CoreList';


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

    
        $provides_ver_of{ $pkgname } = $pkgver
            unless _have_newer_pkgver( $pkgname, $pkgver );
    }

    return %provides_ver_of;
}

sub provides_text
{
    my %provides = generate_provides;

    delete $provides{'perl'};
    return join q{}, map { "$_=$provides{$_}\n" } sort keys %provides;
}

1;

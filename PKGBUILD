# $Id: PKGBUILD 54319 2009-10-08 13:26:47Z francois $
# Maintainer: kevin <kevin.archlinux.org>
# Contributor: judd <jvinet.zeroflux.org>
# Contributor: francois <francois.archlinux.org> 
pkgname=perl
pkgver=5.12.0
pkgrel=0
pkgdesc="Practical Extraction and Report Language"
arch=(i686 x86_64)
license=('GPL' 'PerlArtistic')
url="http://www.perl.org"
groups=('base')
depends=('gdbm' 'db>=4.8' 'coreutils' 'glibc' 'sh')
source=(http://www.perl.com/CPAN/src/perl-${pkgver}.tar.bz2
    perlbin.sh )
provides=(
perl-ansicolor=2.02
perl-app-cpan=1.5701
perl-archive-extract=0.38
perl-archive-tar=0.02
perl-attribute-handlers=0.87
perl-autodie=2.06_01
perl-autoloader=1.06
perl-b-debug=1.12
perl-b-lint=0.01
perl-base=2.15
perl-bignum=0.01
perl-cgi=1.01
perl-class-isa=0.36
perl-compress-raw-bzip2=2.024
perl-compress-raw-zlib=2.024
perl-constant=1.20
perl-cpan=1.00
perl-cpanplus=0
perl-cpanplus-dist-build=0.46
perl-data-dumper=2.125
perl-db-file=1.820
perl-devel-peek=1.04
perl-devel-ppport=3.19
perl-digest=1.16
perl-digest-md5=2.39
perl-digest-sha=5.47
perl-dprof=20080331.00
perl-encode=1.01
perl-encoding-warnings=0.11
perl-exporter=5.64_01
perl-extutils-cbuilder=0.27
perl-extutils-command=1.16
perl-extutils-constant=0.02
perl-extutils-embed=1.28
perl-extutils-install=1.44
perl-extutils-makemaker=6.56
perl-extutils-manifest=1.57
perl-extutils-parsexs=2.21
perl-file-fetch=0.24
perl-file-path=2.08_01
perl-file-temp=0.22
perl-filter=1.08
perl-filter-simple=0.84
perl-getopt-long=2.38
perl-if=0.05
perl-io=0.07
perl-io-compress=1.000
perl-io-zlib=1.10
perl-ipc-cmd=0.54
perl-ipc-sysv=2.01
perl-libnet=0.01
perl-locale-codes=2.07
perl-locale-maketext=1.13
perl-locale-maketext-simple=0.21
perl-log-message=0
perl-log-message-simple=0.06
perl-math-bigint=0.05
perl-math-bigint-fastcalc=0.19
perl-math-bigrat=0.24
perl-math-complex=1.2
perl-memoize=0.65
perl-mime-base64=3.08
perl-module-build=0.77
perl-module-corelist=2.29
perl-module-load=0.16
perl-module-load-conditional=0.34
perl-module-loaded=0.06
perl-module-pluggable=0.3
perl-net-ping=2.36
perl-next=0.64
perl-object-accessor=0.36
perl-package-constants=0.02
perl-params-check=0.26
perl-parent=0.223
perl-parse-cpan-meta=1.40
perl-pathtools=3.30
perl-pod-escapes=1.04
perl-pod-latex=0.58
perl-pod-parser=1.31
perl-pod-perldoc=0
perl-pod-plainer=1.02
perl-pod-simple=3.13
perl-podlators=1.10
perl-safe=2.25
perl-scalar-list-utils=1.22
perl-selfloader=1.17
perl-shell=0.72_01
perl-storable=2.22
perl-switch=2.16
perl-sys-syslog=0.27
perl-term-cap=1.12
perl-term-ui=0
perl-test=1.25_02
perl-test-harness=3.17
perl-test-simple=0.94
perl-text-balanced=2.02
perl-text-parsewords=3.27
perl-text-soundex=3.03_01
perl-text-tabswrap=2009.0305
perl-thread-queue=2.11
perl-thread-semaphore=2.09
perl-threads=1.75
perl-threads-shared=1.32
perl-tie-file=0.97_02
perl-tie-refhash=1.38
perl-time-hires=1.9719
perl-time-local=1.1901_01
perl-time-piece=0
perl-unicode-collate=0.52_01
perl-unicode-normalize=1.03
perl-version=0.82
perl-win32=0.39
perl-win32api-file=0.1101
perl-xsloader=0.10
perlio-via-quotedprint=0.06

)
options=('!makeflags' '!purge')

build() {
  cd ${srcdir}/${pkgname}-${pkgver}

  if [ "${CARCH}" = "x86_64" ]; then
    # for x86_64
    arch_opts="-Dcccdlflags='-fPIC'"
  else 
    # for i686
    arch_opts=""
  fi
  ./Configure -des -Dusethreads -Duseshrplib -Doptimize="${CFLAGS}" -Dprefix=/usr \
    -Dinstallprefix=${pkgdir}/usr -Dvendorprefix=/usr \
    -Dprivlib=/usr/share/perl5/core_perl \
    -Darchlib=/usr/lib/perl5/core_perl \
    -Dsitelib=/usr/share/perl5/site_perl/${pkgver} \
    -Dsitearch=/usr/lib/perl5/site_perl/${pkgver} \
    -Dvendorlib=/usr/share/perl5/vendor_perl \
    -Dvendorarch=/usr/lib/perl5/vendor_perl \
    -Dotherlibdirs=/usr/lib/perl5/current:/usr/lib/perl5/site_perl/current \
    -Dscriptdir='/usr/bin/perlbin/core' \
    -Dsitescript='/usr/bin/perlbin/site' \
    -Dvendorscript='/usr/bin/perlbin/vendor' \
    -Dinc_version_list=none \
    -Dman1ext=1perl -Dman3ext=3perl ${arch_opts}

  make || return 1
  TEST_JOBS=4 make test_harness || return 1
  make install

  ### Perl Settings ###
  # Change man page extensions for site and vendor module builds.
  sed -e '/^man1ext=/ s/1perl/1p/' -e '/^man3ext=/ s/3perl/3pm/' \
      -i ${pkgdir}/usr/lib/perl5/core_perl/Config_heavy.pl

  ### CPAN Settings ###
  # Set CPAN default config to use the site directories.
  sed -e '/(makepl_arg =>/   s/""/"INSTALLDIRS=site"/' \
      -e '/(mbuildpl_arg =>/ s/""/"installdirs=site"/' \
      -i ${pkgdir}/usr/share/perl5/core_perl/CPAN/FirstTime.pm

  ### CPANPLUS Settings ###
  # Set CPANPLUS default config to use the site directories.
  sed -e "/{'makemakerflags'}/ s/'';/'INSTALLDIRS=site';/" \
      -e "/{'buildflags'}/     s/'';/'installdirs=site';/" \
      -i ${pkgdir}/usr/share/perl5/core_perl/CPANPLUS/Config.pm

  # Profile script so set paths to perl scripts.
  install -D -m755 ${srcdir}/perlbin.sh \
                   ${pkgdir}/etc/profile.d/perlbin.sh

  (cd ${pkgdir}/usr/bin; mv perl${pkgver} perl)
  (cd ${pkgdir}/usr/bin/perlbin/core; \
      ln -sf c2ph pstruct; ln -sf s2p psed)
  grep -Rl "${pkgdir}" ${pkgdir}/usr | \
      xargs sed -i "s^${pkgdir}^^g"

  # Remove all pod files *except* those under /usr/share/perl5/core_perl/pod/
  # (FS#16488)
  rm -f $pkgdir/usr/share/perl5/core_perl/*.pod
  for d in $pkgdir/usr/share/perl5/core_perl/*; do
    if [ -d $d -a $(basename $d) != "pod" ]; then
      find $d -name *.pod -delete
    fi
  done

  find $pkgdir/usr/lib -name *.pod -delete
  find $pkgdir -name .packlist -delete
}

md5sums=('3e15696f4160775a90f6b2fb3ccc98c2'
         '9c4e3e56d71f123e92a68986df5ea924')

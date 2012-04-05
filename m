From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ibacm: Fixes to ACM package to support distros
Date: Thu, 05 Apr 2012 12:10:32 -0400
Message-ID: <4F7DC3F8.2030406@redhat.com>
References: <1828884A29C6694DAF28B7E6B8A823734519A805@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig495A3FFB3623DB355F21AF03"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823734519A805-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig495A3FFB3623DB355F21AF03
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/03/2012 03:10 PM, Hefty, Sean wrote:
> Set of changes to fixup the ibacm package for inclusion into RedHat 6.
> Changes are based on feedback from Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>.
> These are primarily changes to the build files, along with name changes=

> to the man pages and sample configuration files.
>=20
> Rename the ib_acm service to match the package name, ibacm.
>=20
> Rename the ibacm configuration files to use the prefix 'ibacm' instead
> of 'acm'.  The new sample files are 'ibacm_addr.cfg' and 'ibacm_opts.cf=
g'.
>=20
> Move location of ACM lock and configuration files and ibacm.pid
> files.  They are currently in non-standard locations.
>=20
> Modify ibacm and ib_acme to use $sysconfdir and $bindir configure=20
> values.  The ibacm_addr.cfg and ibacm_opt.cfg files will now be=20
> read/written to $sysconfdir/rdma by default.  And ibacm will execute
> $bindir/ib_acme if it needs to create the ibacm_addr.cfg file.  Without=

> $bindir, the ibacm service can fail to launch ib_acme when started
> from an init script.
>=20
> Add init script as part of install.  The init script is installed
> into $sysconfdir/init.d.
>=20
> Fixup man pages based on changes.
>=20
> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  Makefile.am    |   30 +++++++++----
>  acm_addr.cfg   |   24 ----------
>  acm_opts.cfg   |  130 ------------------------------------------------=
--------
>  ibacm.init     |  102 ++++++++++++++++++++++++++++++++++++++++++++
>  ibacm.spec.in  |   68 ++++++++++++++++++++++-------
>  ibacm_addr.cfg |   24 ++++++++++
>  ibacm_opts.cfg |  130 ++++++++++++++++++++++++++++++++++++++++++++++++=
++++++++
>  linux/osd.h    |   12 ++++-
>  man/ib_acm.1   |  130 ------------------------------------------------=
--------
>  man/ib_acm.7   |   33 --------------
>  man/ib_acme.1  |   14 +++---
>  man/ibacm.1    |  130 ++++++++++++++++++++++++++++++++++++++++++++++++=
++++++++
>  man/ibacm.7    |   31 +++++++++++++
>  src/acm.c      |   17 ++++---
>  src/acme.c     |   16 +++----
>  15 files changed, 523 insertions(+), 368 deletions(-)
>  delete mode 100644 acm_addr.cfg
>  delete mode 100644 acm_opts.cfg
>  create mode 100644 ibacm.init
>  create mode 100644 ibacm_addr.cfg
>  create mode 100644 ibacm_opts.cfg
>  delete mode 100644 man/ib_acm.1
>  delete mode 100644 man/ib_acm.7
>  create mode 100644 man/ibacm.1
>  create mode 100644 man/ibacm.7

Thanks for this Sean.  A few last tweaks inline below:

> diff --git a/Makefile.am b/Makefile.am
> index 503ad72..58e3415 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -1,12 +1,12 @@
>  INCLUDES =3D -I$(srcdir)/include -I$(srcdir)/linux
> =20
> -AM_CFLAGS =3D -g -Wall -D_GNU_SOURCE
> +AM_CFLAGS =3D -g -Wall -D_GNU_SOURCE -DSYSCONFDIR=3D\"${sysconfdir}\" =
-DBINDIR=3D\"$(bindir)\"

OK, so you're making is so that the --sysconfdir option to configure
works now, and works via always passing sysconfdir on the build command
line (versus the other option which is to put it into config.h).  Cool.
This is a fine solution IMO.


> -EXTRA_DIST =3D src/acm_mad.h src/libacm.h \
> -	     linux/osd.h linux/dlist.h ibacm.spec.in $(man_MANS) acm_opts.cfg=
 \
> -	     acm_addr.cfg
> +EXTRA_DIST =3D src/acm_mad.h src/libacm.h ibacm.init \
> +	     linux/osd.h linux/dlist.h ibacm.spec.in $(man_MANS) ibacm_opts.c=
fg \
> +	     ibacm_addr.cfg
> +
> +install-exec-hook:
> +	if ! test -d $(DESTDIR)$(sysconfdir); then \
> +		mkdir -p $(DESTDIR)$(sysconfdir); \
> +	fi; \
> +	if ! test -d $(DESTDIR)$(sysconfdir)/rdma; then \
> +		mkdir -p $(DESTDIR)$(sysconfdir)/rdma; \
> +	fi; \
> +	if ! test -d $(DESTDIR)$(sysconfdir)/init.d; then \
> +		mkdir -p $(DESTDIR)$(sysconfdir)/init.d; \
> +	fi; \
> +	install -m 755 ibacm.init $(DESTDIR)$(sysconfdir)/init.d/ibacmd;

I'm curious why you didn't just do install -D -m 755 ibacm.init
$(DESTDIR)$(sysconfdir)/init.d/ibacmd instead of all the individual
calls to mkdir.

Also, a minor nit, but along the lines of the whole naming thing, I
would name the init script ibacm since the program is ibacm.  Usually
when the program name is used to name the init script, they match
exactly (when possible, but it's a minor issue so I wouldn't change it
once the package has been in use for a while, but that's not the case
here, it's a new package, so we can do that little cleanup with no cost
up until the package gets in wide spread use).


> +PATH=3D$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/=
bin

I'm not very keen on including /usr/local in the search path on system
binaries.  It can be done, but we would patch it out (and I imagine SuSE
would too).  It's a support issue.  Having /usr/local override the
system installed binaries means that you can end up with strange things
happening, and support scratching their head and going "what the hell is
causing that" and in the end it's because a different binary than the
one RPM installed is actually running.

> +prog=3Dibacm

And this is why I say it's best if the init script and the program have
the exact same name.  There are places that assume they are the same
unless you set this variable, and I've seen people again go scratching
their head when they forgot to set this variable and things didn't work
right, so even though setting this gets you around that problem, it's
something that can be overlooked and cause confusion and so I always
just keep the names the same if at all possible.


> diff --git a/ibacm.spec.in b/ibacm.spec.in
> index a926fea..31d5a07 100644
> --- a/ibacm.spec.in
> +++ b/ibacm.spec.in
> @@ -1,53 +1,89 @@
> -%define ver @VERSION@
> -
>  Name: ibacm
>  Version: 1.0.5
>  Release: 1%{?dist}
>  Summary: InfiniBand Communication Manager Assistant
> =20
> -Group: System Environment/Libraries
> +Group: System Environment/Daemons
>  License: GPLv2 or BSD
>  Url: http://www.openfabrics.org/
>  Source: http://www.openfabrics.org/downloads/rdmacm/%{name}-%{version}=
=2Etar.gz
> +Source1: ibacm.init

Minor nit, when you have a Source1, then the first Source should be
Source0.  rpmlint complains if you mix numbered and unnumbered source lin=
es.

>  BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} =
-n)
> =20
> -BuildRequires: libibverbs-devel >=3D 1.1-1
> +BuildRequires: libibverbs-devel >=3D 1.1-1, autoconf, libtool, libibum=
ad-devel
> +Requires(post): chkconfig
> +Requires(preun): chkconfig
> +ExcludeArch: s390, s390x
> =20
>  %description
> -ibacm assists with establishing communication over Infiniband.
> +The ib_acm daemon helps reduce the load of managing path record lookup=
s on
       ^^^^^^ Old daemon name.  Could optionally use %{name} here to
make sure it is never out of sync with the name of the package.

> +large InfiniBand fabrics by providing a user space implementation of w=
hat
> +is functionally similar to an ARP cache.  The use of ib_acm, when prop=
erly
                                                        ^^^^^^ Ditto
> +configured, can reduce the SA packet load of a large IB cluster from O=
(n^2)
> +to O(n).  The ib_acm daemon is started and normally runs in the backgr=
ound,
                 ^^^^^^ Ditto
> +user applications need not know about this daemon as long as their app=

> +uses librdmacm to handle connection bring up/tear down.  The librdmacm=

> +library knows how to talk directly to the ib_acm daemon to retrieve da=
ta.
                                             ^^^^^^ Ditto
> =20
> -%package svc
> -Summary: IB CM pre-connection service application
> -Group: System Environment/Libraries
> -Requires: %{name} =3D %{version}-%{release} %{_includedir}/infiniband/=
verbs.h
> +%package devel
> +Summary: Headers file needed when building apps to talk directly to ib=
acm.
> +Requires: %{name} =3D %{version}-%{release}
> =20
> -%description svc
> -Application daemon for IB CM pre-connection services.
> +%description devel
> +Most applications do not need to know how to talk directly to the ibac=
m
> +daemon, but it does have a socket that it listens on, and it has a
> +specific protocol for incoming/outgoing data.  So if you wish to build=

> +the ability to communicate directly with ib_acm into your own applicat=
ion,
                                            ^^^^^^ Ditto
> +the protocol used to communicate with it, and the data structures
> +involved, are in this header file.  Please note that this is an unsupp=
orted
> +method of using this daemon.  The only supported means of using this i=
s
> +via librdmacm.  As such, even though this header file is provided, no
> +further documentation is available.  One must read the source if they
> +wish to make use of this header file.
> =20
>  %prep
> -%setup -q -n %{name}-%{ver}
> +%setup -q -n %{name}-%{version}
> =20
>  %build
> -%configure
> +aclocal -I config && libtoolize --force --copy && autoheader && \
> +	automake --foreign --add-missing --copy && autoconf
> +%configure --sysconfdir=3D/etc/rdma CFLAGS=3D"$CXXFLAGS -fno-strict-al=
iasing" LDFLAGS=3D-lpthread
                ^^^^^^^^^^^^^^^^^^^^ This seems inconsistent with your
intent.  Specifically, the changes you made in the header file to honor
sysconfdir, and the changes you made above to Makefile.am, use it only
as a partial element in the path and it postfixes rdma to sysconfdir, so
won't this cause the final location to be /etc/rdma/rdma?  Maybe what
you want here is to leave sysconfdir alone (it's already specified as
part of the %configure magic) and add something like --rdmadir=3Drdma and=

then in the header file do something like:

#ifdef rdmadir
#define RDMADIR sysconfdir "/" rdmadir
#else
#define RDMADIR sysconfdir "/rdma"
#endif

>  make %{?_smp_mflags}
> =20
>  %install
>  rm -rf $RPM_BUILD_ROOT
> +make DESTDIR=3D%{buildroot} install
> +install -D -m 755 %{SOURCE1} %{buildroot}%{_initrddir}/ibacm
>  %makeinstall
> =20
>  %clean
>  rm -rf $RPM_BUILD_ROOT
> =20
> -%post -p /sbin/ldconfig
> -%postun -p /sbin/ldconfig
> +%post
> +if [ $1 =3D 1 ]; then
> +	chkconfig --add ibacm
> +fi
> +%preun
> +if [ $1 =3D 1 ]; then
> +	chkconfig --del ibacm
> +fi

BTW, here's a perfect example of the ibacm prog versys ibacmd init
script, as these scriptlets will fail because you've got the wrong name
;-)  Like I said, consistency will make everyone's life easier :-)


> diff --git a/linux/osd.h b/linux/osd.h
> index 33ea842..169e041 100644
> --- a/linux/osd.h
> +++ b/linux/osd.h
> @@ -45,9 +45,15 @@
>  #include <sys/time.h>
>  #include <netinet/in.h>
> =20
> -#define ACM_DEST_DIR "/etc/ibacm"
> -#define ACM_ADDR_FILE "acm_addr.cfg"
> -#define ACM_OPTS_FILE "acm_opts.cfg"
> +#ifndef SYSCONFDIR
> +#define SYSCONFDIR "/etc"
> +#endif
> +#ifndef BINDIR
> +#define BINDIR "/usr/bin"
> +#endif
> +#define ACM_CONF_DIR  SYSCONFDIR "/rdma"
> +#define ACM_ADDR_FILE "ibacm_addr.cfg"
> +#define ACM_OPTS_FILE "ibacm_opts.cfg"

OK, so here's the real changes to the config directory.  Like I
mentioned, you pass SYSCONFDIR, then postfix it with /rdma, so /etc/rdma
as SYSCONFDIR will result in /etc/rdma/rdma.

What we really care about is RDMADIR like I used above, we can more or
less assume SYSCONFDIR will always be /etc/ until the internet implodes
on our heads :-)  And since we don't ever put the RDMADIR into a config
file anywhere, what I might suggest is something like this:

#ifndef RDMADIR
#error This package requires that you define RDMADIR on the build
command line
#endif
#define ACM_CONF_DIR "/etc/" RDMADIR

This way it will fail to compile if people try to build it without the
proper command line define.




> diff --git a/man/ibacm.1 b/man/ibacm.1
> new file mode 100644
> index 0000000..ed4b7a5
> --- /dev/null
> +++ b/man/ibacm.1

I think a quick global search and replace for ib_acm/ibacm would be wise
on both man pages.  You need to exclude ib_acme from the search though,
so a specific full word match is needed.

OK, that's all I see.  Thanks for working on this Sean!


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



--------------enig495A3FFB3623DB355F21AF03
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPfcP5AAoJELgmozMOVy/deMUQAItgVHFwzUZzWO3onymzB+gL
+XfpPGFsQc/pdVxTk4ZioOgp5E3tC2w7iAzI5zha1pEtgSC/T36fcJA2GaekSSqy
enVVzq5HrTy49O2WfiPnIO17V115+RYFHzeR8u04WRt79kqX9RKgeN2R87dOZ/rE
ZVH6s/OtvChoFuJZB/txYKLyzumkjSuJxM7xdn8Zx2ljWTxuQw+cmV9sKnS6NHS5
I2AXQQHjBbwQpbWceXrCnn9S5vThmEYnVT35P/NSApLSVyw0vP15cMHlLgAQbS2y
2Rge3QR5x2vkoa95X5M61d/GWNKMrir44J/blqgThMoNkiM0LQ27otgelpFwnqNL
8/kYmSuPfCvDhj4tlGl5tOxjT0I89VZ3COh+OSI04VKHDuBKrygAqlECoGAQM+kb
K6BczcwCA0dE97MtM4kIqEO+2pcSAQcrUvv16DQCn5wXoSn3cMi5mAQpcvIvnhlv
0cTRroHjM96BN0PxlfAKeYL8l6Uqt6WGgYjXYdg+Y6UI0IDfZ5v0XzFvwWPvlqYR
ziTO1h8m+AlSi4/W1pkebFxnbBfckHkiUxi72sV4jgvWp6/gCCi1OgLkmbK0OFwl
xgRuaiE9bEIjsin4uoI0FrL5vgjE5C5y5kCppcjBmh5bf2baKlju09bt4HhESVXW
D/AmTTufMT9lnkfg1pu3
=Cw0T
-----END PGP SIGNATURE-----

--------------enig495A3FFB3623DB355F21AF03--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

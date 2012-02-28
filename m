From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: ibacm fixes/updates
Date: Tue, 28 Feb 2012 16:08:31 -0500
Message-ID: <4F4D424F.3040004@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAA19426B6B5E5B6562E0F06C"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAA19426B6B5E5B6562E0F06C
Content-Type: multipart/mixed;
 boundary="------------090808050508010804010902"

This is a multi-part message in MIME format.
--------------090808050508010804010902
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Sean,

We were asked to integrate this into our product for scalability
purposes.  While working on that, I ran across a number of issues that
needed fixed up (typical for a new package).  So, here's a number of
patches and fix ups for those things.

First, the package is ibacm but the binary is ib_acm.  Trust me, it's
best to pick one of the other and stick with it.  Especially since you
used ibacm for the log and pid files too.  In my build, I went ahead and
changed the binary name to match the package and log and pid file names.
 I patched the Makefile.am and reran the autoconf tools to make this
happen.  I've attached that patch.

In the package spec file don't differentiate between %{ver} and
%{version}, these should always be the same and you should never need to
use anything other than %{version}.  Your spec file had a srv component,
that I suspect was intended to hold the init script, but no init script
was ever written and the section was incomplete (so your spec file
wouldn't even build).  I rewrote the spec file so that the base
component is the service.  In truth, for this you really want it to be a
service and on by default if installed.  I've attached my spec file.
I've also attached the init script I made.

By default ibacm expects to find its configuration files in /etc/ibacm.
 This adds to the proliferation of directories in /etc/ needlessly.  We
already have a number of RDMA related directories to choose from
depending on your install (OFED =3D=3D /etc/ofed or /etc/openib in the ol=
d
days, RHEL5 =3D=3D /etc/openib from the old days, RHEL6 and Fedora are
/etc/rdma, don't know what SuSE uses).  Would be best if these files
were in the same place as the other RDMA related files.  And to make
that happen easily, it would be best if they picked up on %{sysconfdir}
from the ./configure invocation in order to set the directory.  I used a
static patch for now because I'm behind on my work, so updating the
configure script was more than I had time to do.  I'm not bothering to
include my patch as it needs done the other way so my patch is purely a
stopgap that should not see the time of day ;-)

OK, gotta run.  Would like to see this stuff picked up, especially the
init stuff.  Getting it in your release before we have one init script,
SuSE another, and OFED another will help keep things uniform.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford


--------------090808050508010804010902
Content-Type: text/plain;
 name="ibacm.init"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="ibacm.init"

#!/bin/bash
#
# Bring up/down the ibacm daemon
#
# chkconfig: 2345 25 75
# description: Starts/Stops InfiniBand ACM service
#
### BEGIN INIT INFO
# Provides:       ibacm
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Required-Start: rdma $network
# Required-Stop: rdma $network
# Should-Start: opensm
# Should-Stop: opensm
# Short-Description: Starts and stops the InfiniBand ACM service
# Description: The InfiniBand ACM service provides a user space implement=
ation
#	of someting resembling an ARP cache for InfiniBand SA queries and
#	host route lookups.
### END INIT INFO

pidfile=3D/var/run/ibacm.pid
subsys=3D/var/lock/subsys/ibacm
prog=3D/usr/sbin/ibacm

=2E /etc/rc.d/init.d/functions

start()
{
    echo -n "Starting ibacm daemon:"

    daemon $prog
    RC=3D$?
    [ $RC -eq 0 ] && touch $subsys
    echo
    return $RC
}

stop()
{
    echo -n "Stopping ibacm daemon:"

    killproc -p $pidfile $prog
    RC=3D$?
    rm -f $subsys
    echo
    return $RC
}

status()
{
    if [ ! -f $subsys -a ! -f $pidfile ]; then
    	return 3
    fi
    if [ -f $pidfile ]; then
	checkpid `cat $pidfile`
	return $?
    fi
    if [ -f $subsys ]; then
	return 2
    fi
}

restart ()
{
    stop
    start
}

condrestart ()
{
    [ -e $subsys ] && restart || return 0
}

usage ()
{
    echo
    echo "Usage: `basename $0` {start|stop|restart|condrestart|try-restar=
t|force-reload|status}"
    echo
    return 2
}

case $1 in
    start|stop|restart|condrestart|try-restart|force-reload)
	[ `id -u` !=3D "0" ] && exit 4 ;;
esac

case $1 in
    start) start; RC=3D$? ;;
    stop) stop; RC=3D$? ;;
    restart) restart; RC=3D$? ;;
    reload) RC=3D3 ;;
    condrestart) condrestart; RC=3D$? ;;
    try-restart) condrestart; RC=3D$? ;;
    force-reload) condrestart; RC=3D$? ;;
    status) status; RC=3D$? ;;
    *) usage; RC=3D$? ;;
esac

exit $RC

--------------090808050508010804010902
Content-Type: text/x-rpm-spec;
 name="ibacm.spec"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="ibacm.spec"

Name: ibacm
Version: 1.0.5
Release: 1%{?dist}
Summary: InfiniBand Communication Manager Assistant
Group: System Environment/Daemons
License: GPLv2 or BSD
Url: http://www.openfabrics.org/
Source: http://www.openfabrics.org/downloads/rdmacm/%{name}-%{version}.ta=
r.gz
Source1: ibacm.init
Patch0: ibacm-1.0.5-make.patch
Patch1: ibacm-1.0.5-conf.patch
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)=

BuildRequires: libibverbs-devel >=3D 1.1-1, autoconf, libtool, libibumad-=
devel
Requires(post): chkconfig
Requires(preun): chkconfig
ExcludeArch: s390 s390x

%description
The ib_acm daemon helps reduce the load of managing path record lookups o=
n
large InfiniBand fabrics by providing a user space implementation of what=

is functionally similar to an ARP cache.  The use of ib_acm, when properl=
y
configured, can reduce the SA packet load of a large IB cluster from O(n^=
2)
to O(n).  The ib_acm daemon is started and normally runs in the backgroun=
d,
user applications need not know about this daemon as long as their app
uses librdmacm to handle connection bring up/tear down.  The librdmacm
library knows how to talk directly to the ib_acm daemon to retrieve data.=


%package devel
Summary: Headers file needed when building apps to talk directly to ib_ac=
m
Requires: %{name} =3D %{version}-%{release}

%description devel
Most applications do not need to know how to talk directly to the ib_acm
daemon, but it does have a socket that it listens on, and it has a
specific protocol for incoming/outgoing data.  So if you wish to build
the ability to communicate directly with ib_acm into your own application=
,
the protocol used to communicate with it, and the data structures
involved, are in this header file.  Please note that this is an unsupport=
ed
method of using this daemon.  The only supported means of using this is
via librdmacm.  As such, even though this header file is provided, no
further documentation is available.  One must read the source if they
wish to make use of this header file.

%prep
%setup -q -n %{name}-%{version}
%patch0 -p1 -b .make
%patch1 -p1 -b .conf

%build
aclocal -I config && libtoolize --force --copy && autoheader && \
	automake --foreign --add-missing --copy && autoconf
%configure --sysconfdir=3D/etc/rdma CFLAGS=3D"$CXXFLAGS -fno-strict-alias=
ing" LDFLAGS=3D-lpthread
mv man/ib_acm.1 man/ibacm.1
mv man/ib_acm.7 man/ibacm.7
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=3D%{buildroot} install
install -D -m 755 %{SOURCE1} %{buildroot}%{_initrddir}/ibacm

%clean
rm -rf $RPM_BUILD_ROOT

%post
if [ $1 =3D 1 ]; then
	chkconfig --add ibacm
fi

%preun
if [ $1 =3D 0 ]; then
	chkconfig --del ibacm
fi

%files
%defattr(-,root,root,-)
%doc AUTHORS COPYING README
%{_bindir}/ib_acme
%{_sbindir}/ibacm
%{_mandir}/man1/*
%{_mandir}/man7/*
%config(noreplace) %{_sysconfdir}/rdma/*
%{_initrddir}/ibacm

%files devel
%defattr(-,root,root,-)
%{_includedir}/infiniband/acm.h

%changelog
* Tue Feb 28 2012 Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> - 1.0.5-1
- Ininital version for rhel6
- Related: bz700285


--------------090808050508010804010902
Content-Type: text/x-patch;
 name="ibacm-1.0.5-make.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="ibacm-1.0.5-make.patch"

diff -up ibacm-1.0.5/Makefile.am.dist ibacm-1.0.5/Makefile.am
--- ibacm-1.0.5/Makefile.am.dist	2010-12-10 15:05:18.000000000 -0500
+++ ibacm-1.0.5/Makefile.am	2012-02-28 13:25:36.662261951 -0500
@@ -3,10 +3,10 @@ INCLUDES =3D -I$(srcdir)/include -I$(srcdi
 AM_CFLAGS =3D -g -Wall -D_GNU_SOURCE
=20
 bin_PROGRAMS =3D util/ib_acme
-sbin_PROGRAMS =3D svc/ib_acm
-svc_ib_acm_SOURCES =3D src/acm.c
+sbin_PROGRAMS =3D svc/ibacm
+svc_ibacm_SOURCES =3D src/acm.c
 util_ib_acme_SOURCES =3D src/acme.c linux/acme_linux.c src/libacm.c linu=
x/libacm_linux.c src/parse.c
-svc_ib_acm_CFLAGS =3D $(AM_CFLAGS)
+svc_ibacm_CFLAGS =3D $(AM_CFLAGS)
 util_ib_acme_CFLAGS =3D $(AM_CFLAGS)
=20
 ibacmincludedir =3D $(includedir)/infiniband
@@ -15,12 +15,19 @@ ibacminclude_HEADERS =3D include/infiniban
=20
 man_MANS =3D \
 	man/ib_acme.1 \
-	man/ib_acm.1 \
-	man/ib_acm.7
+	man/ibacm.1 \
+	man/ibacm.7
=20
 EXTRA_DIST =3D src/acm_mad.h src/libacm.h \
 	     linux/osd.h linux/dlist.h ibacm.spec.in $(man_MANS) acm_opts.cfg \=

 	     acm_addr.cfg
=20
+install-exec-hook:
+	if ! test -d $(DESTDIR)$(sysconfdir); then \
+		mkdir -p $(DESTDIR)$(sysconfdir); \
+	fi; \
+	install -m 644 acm_opts.cfg $(DESTDIR)$(sysconfdir)/acm_opts.cfg; \
+	install -m 644 acm_addr.cfg $(DESTDIR)$(sysconfdir)/acm_addr.cfg;=20
+
 dist-hook: ibacm.spec
 	cp ibacm.spec $(distdir)

--------------090808050508010804010902--

--------------enigAA19426B6B5E5B6562E0F06C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPTUJPAAoJELgmozMOVy/d1kEP+QEEGpSQFpuybnhBskGE6qRP
KfIZ6Iq5gDO1iwUZmh5jP6icAHQguXdeLS/RxGNvn96uo4xnackagJYIN7R8+rI8
/JYL+caOgGfuZL0AStccwpU11lrBx0kNX9plBukAPZm1xOcBgacIGFkOfb7UQOwM
P6dfS+QYJtM92Pb2ByBEnm/G3NiNK5UVWHpinwb4Bt21YYTBTaxHHHoVEuTh5Jnt
dJLK7Q1XMPMQoxhs6On30rqwqlQN9/VSV8jiA9r6G4GKnlnnkjVBFsY7I5zKCSZ8
MbRGbcWAlzS8wmjZUxVXRB9LkrBeWGPpff6CVqlViWJ0LrWha/hoLn67sdor2GjR
lIOR9jAdQ30OdaiqhGXqqVCmv+iiyklEhupTUWa+wtOT6v1LLpzwgaEUUuKghFr6
5/Ex1+5hQWyTEvWwuVaULgkvjO9u22iFXGP9pp1fyauaAuF6LaoPFAF/hw8Uo7cy
qAoYrQJL420QN479M5A6DFwRNCMM3BjZEgPIVrjk0HjzxZABK6bSJsXSkXSdg1DG
ZPneO964HVodnJ5kaTaLG2xyk4wFIj6YnD/FO9cXQRYRxeAh5PyP9YMdbvbOFCnp
ND4ydjo8zJ0aL1aJMqpdlrl1MuJbFxtpSUy25BkQdNDQUWmkQnjaCJ7xjKhwqZ4+
mSZVdyw8u151k8sllKAj
=SE3R
-----END PGP SIGNATURE-----

--------------enigAA19426B6B5E5B6562E0F06C--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

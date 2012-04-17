From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] ibacm: Fixes to ACM package to support distros
Date: Tue, 17 Apr 2012 12:35:29 -0400
Message-ID: <4F8D9BD1.7090007@redhat.com>
References: <1828884A29C6694DAF28B7E6B8A823734519B3C4@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6770AE78F305F48EEC7E4CFA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823734519B3C4-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6770AE78F305F48EEC7E4CFA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/06/2012 01:12 PM, Hefty, Sean wrote:
> ibacm: Fixes to ACM package to support distros
>=20
> From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
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
> Modify ibacm and ib_acme to use $sysconfdir, $bindir, and rdmadir
> configure values.  The ibacm_addr.cfg and ibacm_opt.cfg files will now =
be
> read/written to $sysconfdir/$rdmadir by default, with rdmadir defaultin=
g
> to 'rdma' if not specified..  And ibacm will execute
> $bindir/ib_acme if it needs to create the ibacm_addr.cfg file.  Without=

> $bindir, the ibacm service can fail to launch ib_acme when started
> from an init script.
>=20
> Add init script as part of install.  The init script is installed
> into $sysconfdir/init.d.  The init script is processed by configure,
> so that it executes the correct ibacm service that was installed.
>=20
> Fixup man pages based on changes.
>=20
> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> Changes from v1:
>=20
> Removed mkdir calls from Makefile and replaced them with -D install opt=
ion.
>=20
> Removed setting PATH in init script.  Init script is now processed by c=
onfigure
> to handle the case where the daemon is not installed in /usr/sbin.
> Renamed init script to match package / daemon name.
>=20
> User can now specify the directory for configuration files by setting
> rdmadir=3D<some_directory> when running configure.  By default rdmadir=3D=
rdma.
> rdmadir is passed to the compiler as a define.
>=20
> Fixed other minor issues, like name changes in man pages.

This looks good enough to me Sean.  Ack to the version 2 patch set.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



--------------enig6770AE78F305F48EEC7E4CFA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPjZvRAAoJELgmozMOVy/d950P/2bFb3kXomWhmwFiJlpTxQYE
3tYyouFmZCbyYaU1FgKcqA+PSSN8ACvZXgUJ3vei5Yh3ZUA8G/UaGKp8+5oTDQs6
pih7yPGM09OdSKyrB70TPFWAWHD41Qbcs+ekqgTNEBIh+k8YWanfk8s2DjKwWnIm
ZfNKHAHuUZGf58qCGiLqDkuo6rsWjQR10QDtZeDqZ6aBarL3uM/dlMBW5OeS2v1g
9du2Ajlrzo6c5w4xRxl6a5dmB/42Z/Pha+pTnmmppmltC4B0F50ns6m/2OcN6mks
JoHDEespwm08CMeQPwzZ5k6PKvoLGiTtU7CutW+sB/oobb2vgyQMDeIe/hF0Xf+4
O1YikMFbJU7M8hJ4QOWO9ABm3OZ85+YU9U49nWM+G9e+hHdRpxK8zkqWuArIoutm
S4QL9G3G1ZE1QeENemCi4VEGfbgkSWpgk38GbQqTkckIhzQ3GkMqCPM0Ysu4C+17
/zz1mJGng3Ih+Klunh5/zdqjI8KuHo1WQtX8c70jIAX0iC5OGFdQhgsey6UO6SBf
1frPI1yru92wxqKOqD45k812AjC8trtt+d+1MAYyu0beRuYowgNnYqPBizYV4YAQ
+YF65Ain5Qb2u/dQDfVsL0Z4w0VWwaKBICpqWeLFN8khz5dQJWBrKA/CDQfXHBkT
AOe5C5SX8eKIPTkFKf+u
=l1SX
-----END PGP SIGNATURE-----

--------------enig6770AE78F305F48EEC7E4CFA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

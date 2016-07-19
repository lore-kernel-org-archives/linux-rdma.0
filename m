From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [ANNOUNCE] New libibverbs-1.2.1 release
Date: Tue, 19 Jul 2016 16:33:04 -0400
Message-ID: <daf86e0f-edeb-25c1-1ef0-d29461aea69e@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="J3BtFiP5sRDa05jaEM0cHnfUINqf1GIMt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--J3BtFiP5sRDa05jaEM0cHnfUINqf1GIMt
Content-Type: multipart/mixed; boundary="oINqqqvddxIp7STnJsuuidivwCLLCVvmI"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <daf86e0f-edeb-25c1-1ef0-d29461aea69e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [ANNOUNCE] New libibverbs-1.2.1 release

--oINqqqvddxIp7STnJsuuidivwCLLCVvmI
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

An updated version of libibverbs has been released.  The new source code
is available at the official git repo:

git://git.kernel.org/pub/scm/libs/infiniband/libibverbs.git

Tarballs are available for download at:

http://www.openfabrics.org/downloads/verbs/

Highlights of changes in this release:

Ability to block reception of multicast packets you send
Addition of memory window verbs support
Addition of MR reregistration support
Addition of support for scattering extended frame check values on raw
Ethernet queue pair receives
Addition of extended create queue pair verb
Addition of completion timestamp support
Fixes for ARM memory barriers


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--oINqqqvddxIp7STnJsuuidivwCLLCVvmI--

--J3BtFiP5sRDa05jaEM0cHnfUINqf1GIMt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXjo6AAAoJELgmozMOVy/dbO4P/R7Frme1g6EexJHqcyX3lmAK
8KPjjZRJodBuggZnZ44hu+sJ4EfhUadaTBBnp2EieJFEgztbTqMREIYSlfw+ucRc
jej1TpbNirSdpyVqf1qMHENVyBWPzMjQa6TmLnDGFPtVfo5913hDaf61JiK5AgXC
LgDCWPegJdlas6KKG9O9mvsrVHTsCVrLNThIV4enuJksZi3lHv7VjmyG8kLJuQ7H
3X8+l5nZYGuD5QlOiUo9c7mwTTNXLRQWk75oRTT+3Qj/1yEX5F2YqwtmIZaLOqOJ
IZaWD/C/Mq3p23QQpQe70fbR440iP5zeBDtacZj3nRcXEWZv40JDcAMYllBx7sXL
974EiXJwj/glyP36Vv16xXVXgvMM6a4cQFzFHMBjPZalaJR4G5RFnqGx8HVsSnrW
Dajfy2VyR6oeyK9QUEy8kcTpLi0GTdOcaYcvGf9Qd3Gu5PhlzMaKXrBJF7kgwN6B
FTeUBLTViFRiM0IwgNUikSvlGHm7TOreZsxJQwwxHXP126azV9VeHjoCZOjXziWJ
GCKhtgM1iWsvVVEYniqtlWMumJmt3horsiRo6VX2DRWxx6lQkeMzDqmGMK4r1xGL
wjl0tTlFjHe3FPJAXMMGab6xA9oCiWvh/LlcurrwPLPSvkphseIR2Th9WH3YW20s
7bhruJ7gSg+sqgUJAykY
=zT9b
-----END PGP SIGNATURE-----

--J3BtFiP5sRDa05jaEM0cHnfUINqf1GIMt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

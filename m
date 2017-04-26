From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: rdmacm-utils: Missing man pages for cmtime and udpong
Date: Wed, 26 Apr 2017 11:22:42 +0200
Message-ID: <1493198562.3837.2.camel@profitbricks.com>
References: <1493040510.17795.3.camel@profitbricks.com>
         <20170425180423.GT14088@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-SOrXNA1vAsoGrNRzwhX3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170425180423.GT14088-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-SOrXNA1vAsoGrNRzwhX3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Dienstag, den 25.04.2017, 21:04 +0300 schrieb Leon Romanovsky:
> On Mon, Apr 24, 2017 at 03:28:30PM +0200, Benjamin Drung wrote:
> > Hi,
> >=20
> > the rdmacm-utils binaries cmtime and udpong do not have a
> > corresponding
> > =C2=A0man page. Please add some since Debian recommends to ship man
> > pages
> > for all binaries.
>=20
> Is it requirement or recommendation?

I looked it up. It's considered a bug. The Debian policy says in =C2=A712.1=
:

"Each program, utility, and function should have an associated manual
page included in the same package. It is suggested that all
configuration files also have a manual page included as well. Manual
pages for protocols and other auxiliary things are optional.

If no manual page is available, this is considered as a bug and should
be reported to the Debian Bug Tracking System (the maintainer of the
package is allowed to write this bug report themselves, if they so
desire). Do not close the bug report until a proper man page is
available."

See https://www.debian.org/doc/debian-policy/ch-docs.html

--=20
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Web:=C2=A0https://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss.

--=-SOrXNA1vAsoGrNRzwhX3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJZAGbiAAoJEN2M1aXejH56POUQAID0nmEUQ/xD7YK70jeH5U7Y
ad9SIuqGVkKNVesIiB6E8sU3ros7mudVUHomib6/EMPxRDtQ6n5QQSJg7ijyd4Kr
S6Bmx2TNE9cpeeA+2UK/2ZrJHi9JfCjr55thHl3R7I3BU1ANtjv8lTNJKY4rynlG
i00mihsgZRhEh1yiyaLU3ZRnz8sPT5ttcywsKDqfUM3pKoXH0K1+DjoVc/mRPTNW
GDFIKdfzGcLUk0vFVnBM12jbdvXuqGesL2c5oxYL7epQ0Sr8vs9tUF/nfSb53s6t
4kTDLhycFJDN7d2FiYc1BNZpx7g+DI96BZjKV8wO9UmgvkkbX6aPKqrbMEUbFQxg
i0PrMP1F9OZVzqhlnfQv76h8qLWvIS9ldDlywbcTD0ff85EorUOCp7N/dJ3XcjsR
3+uvrLZLSSOyaiYj6Ea9z1VRCAv8Q7eqXnA3VCRktQxdH13fvjGhfZnTEzwvH3gY
NS2HrILtjBBBUrdvEw3tTb84Co/JZtFlENu6MAA2gUok/mMdwz8EKOuISRU86QG9
SdGDtbIh7zqLZRGkSPur7VmES+eSDoXpbxpJQh8fPcizPOC+WN0qrTtIlMwjdwZI
LnXewmbd1orj9OZOC1O0bkyJLIA6CHcyK7fBaJdSzoKGNwAw626c1sGFUK+fSp1u
vS113/RTthyiiRgxcXQx
=i2Hm
-----END PGP SIGNATURE-----

--=-SOrXNA1vAsoGrNRzwhX3--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

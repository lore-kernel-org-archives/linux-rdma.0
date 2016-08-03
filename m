From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rdmavt: Eliminate redundant opcode test in mr ref
 clear
Date: Tue, 02 Aug 2016 22:47:31 -0400
Message-ID: <1470192451.18081.51.camel@redhat.com>
References: <20160728010735.GB3158@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-o8BTwQkqxHrsmPfjfp5/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160728010735.GB3158-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-o8BTwQkqxHrsmPfjfp5/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-07-27 at 21:07 -0400, ira.weiny wrote:
> The use of the specific opcode test is redundant since
> all ack entry users correctly manipulate the mr pointer
> to selectively trigger the reference clearing.
>=20
> The overly specific test hinders the use of implementation
> specific operations.
>=20
> The change needs to get rid of the union to insure that
> an atomic value is not seen as an MR pointer.
>=20
> Reviewed-by: Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=C2=A0

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-o8BTwQkqxHrsmPfjfp5/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoVtDAAoJELgmozMOVy/dYbMQAKwgMfPeDz4Fp1HWsljyt3I5
ziSUJLKsfhNLQkhtpfKZaFcpiUhbz8zcuqMKlU9SIm/OJfQzSGmCWuIkWDLasfAm
OBr0/5WG/BxyqfgCvz6ZvlOmPhw41LW6a6ZenP/tkBQPInOYaUNmJUv2wcJkLYfQ
GaDnDgkf5blK3X7tTRm3CFU022PZbCIh6QlbqEESLfGb67J66K4VjBAYKNENYZv3
jpfNiB9DqiF5lp9TjdisAlKtp7XT249HI2JaALZOnVel8qMui4e/5I5bjY+1/9Ii
iXr3MbTuEy7cogiGKuo8C0ReiWW7yZ8NrEPqy37uBr8Rvm0lSGorPyslbyx7jOsj
f4S2sKrSgrY0mk7GQAhTB1VSGfkS1ilMSnNXdYOSa2Me+B9V/ePTyTIXSE6BpmbV
QcDadjF/9k8aRUJSoKh4854yEvfb5c8eWujxw7Gzf38ooUULyX2kx22ZsA1lgkQd
FEYMpUO+hxGoQQleGAn82aTp+NgIL19aCzWA/Gp/trgKYa8PRyFodoUNM91fZhpk
P4Iw2AIgkFXHsPEY1XssTjpOnoP9i6dCwHOcCsrCD0TAWpUvWTwQsPZNZEY/DKXp
PqzyK4/QxZpweCw0WGBp5P9SS/TUadXDny6cYAso8X+NyeqyFfqf3F57nTq9APQc
4ORflWHuYwKEqg7E2vd1
=iA0Z
-----END PGP SIGNATURE-----

--=-o8BTwQkqxHrsmPfjfp5/--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

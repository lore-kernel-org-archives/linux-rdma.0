From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/3] Fixes for cbuild and travis
Date: Wed, 17 Jan 2018 10:49:49 -0500
Message-ID: <1516204189.3403.256.camel@redhat.com>
References: <20180115211347.5651-1-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-2qkGDYHDDXTJ2Zabo1PJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180115211347.5651-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-2qkGDYHDDXTJ2Zabo1PJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-01-15 at 14:13 -0700, Jason Gunthorpe wrote:
> From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Fix the unconditional travis failures with the latest suse tumbleweed doc=
ker
> images
>=20
> Fix perplexing travis failures with no output from sparse.
>=20
> Use clang 5.0
>=20
> This is a PR:
>=20
> https://github.com/linux-rdma/rdma-core/pull/283
>=20
> Jason Gunthorpe (3):
>   cbuild: Support distros that only ship python3
>   travis: Do not loose ninja output if ninja fails during sparse
>   travis: Use clang-5.0
>=20
>  .travis.yml           |  6 +++---
>  buildlib/cbuild       | 16 ++++++++++------
>  buildlib/travis-build | 10 +++++-----
>  3 files changed, 18 insertions(+), 14 deletions(-)
>=20

This was merged yesterday.  I forgot to email the list, sorry.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-2qkGDYHDDXTJ2Zabo1PJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpfcJ0ACgkQuCajMw5X
L93dmA//QoIidiFhlLaPhzmoItAa/W6qFSfIFUvcmy/3IRy+qCWA/RcxNfRqsY6t
7rQHHIZOdoHbZFGhodU9jGFwA3LkGs91L+MrAVl4CSvpp2O/8VyiDWNiSAeKntX4
4P6fC13GB8wBb6EPelurdKs7S4fKk4/3CgfG51JO7vLad7UTVIIhy/xqQed0n8Mr
jIlK/dnKDE/y97uEjEY94IAOq8ljd/0awio2wyxlPaELXx5wYi7bqubJjCj5nYiF
Qe4wqJpGYHs2LazhMpOPKtdE4fSyPvDJR1UmtnP3mZfu0noXimOYX8uK05sDYJTz
h093VZ0+8B/e+VJQkL/tb2L1MmUsPj25PEkhA/+W2qMvNKqH5nzByARiItOVs2Kn
//0N6f0TmH7fXVIP2yE5IRU9tm+UsOr0h0aX21AZOc1Ce70OdkWNhjho8P08qTsa
7lRznfsAk6VUi9fOUUTw3hzbCSyEArd+AFck3fG2BDH7FRQM3MPKrfnLpsWhZavV
jzYmZdTrTX01DG92AdUIOIIqqB2Y+H9cG4DGnEwIOUnu3bMYBLUFO9HjWCHedbPd
OiIGtsImE6gi7qWKcyzdVd5ijFXrerZOs8InGnXrakxg9veOkZ/fCySPYRXGTjFP
XpC4kwsI+LVVJRwobXJdA6UVZt+pmsBzE2MWoWUy5Y2Y2MShHOc=
=94dT
-----END PGP SIGNATURE-----

--=-2qkGDYHDDXTJ2Zabo1PJ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch] ib/rxe: double free on error
Date: Sat, 18 Jun 2016 14:03:30 +0300
Message-ID: <20160618110330.GF5408@leon.nu>
References: <20160618084021.GB21713@mwanda>
 <20160618103430.GC5408@leon.nu>
 <20160618110003.GJ32247@mwanda>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hNweOTLwwbnii4NA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160618110003.GJ32247@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--hNweOTLwwbnii4NA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 18, 2016 at 02:00:03PM +0300, Dan Carpenter wrote:
> On Sat, Jun 18, 2016 at 01:34:30PM +0300, Leon Romanovsky wrote:
> >  drivers/infiniband/hw/rxe/rxe.c | 29 ++++++-----------------------
> >  1 file changed, 6 insertions(+), 23 deletions(-)
> >=20
> > diff --git a/drivers/infiniband/hw/rxe/rxe.c b/drivers/infiniband/hw/rx=
e/rxe.c
> > index 48c41e00..156a1021 100644
> > --- a/drivers/infiniband/hw/rxe/rxe.c
> > +++ b/drivers/infiniband/hw/rxe/rxe.c
> > @@ -165,42 +165,25 @@ static int rxe_init_port_param(struct rxe_port *p=
ort)
> >   */
> >  static int rxe_init_ports(struct rxe_dev *rxe)
> >  {
> > -	int err;
> > -	struct rxe_port *port;
> > -
> > -	port =3D &rxe->port;
> > +	struct rxe_port *port =3D  rxe->port;
>=20
> This won't compile.

Interesting, it compiled locally. I'll check it now.

>=20
> Just give me Reported-by credit not authorship.
>=20
> regards,
> dan carpenter
>=20

--hNweOTLwwbnii4NA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXZSqBAAoJEORje4g2clinJgYP/3N1j2ZZkjxgNgOvvkLrtRl1
0XMrV0zmh2TzvLw8X6e41zDfeerAR4OSyAFUZLZYM4YMF7n2pg/+wZDf2iuBpYFQ
cSOvfKbQulKF446nbmBqlr/CcyjouzUNoNTQP1qsnj6y2YYwgyCScF0JcA1K85DP
DdBkJjmIXg1ve7hqiIQtNtUJw8fCucHk9ZnFmhZMql5APK1OJ2/iMoE7epTwncAa
SJIsLM8CvOJY3YywxsAc4sIe8A5AxfwvmCDwZkCJtv1w3He//oYYxuFtP2M4HbEj
4yuFEznMs8RHkp+AC9Xbp/5vLgHjMKgp2TYD44VrHa124kMZaEODAgImmSNm6BdM
4BHM4HH1T7PCvasNWAhi+z51Fwd7aQtXgD+TTKLlYN8MOEUxgtp65TzkZsXW0BKR
0cpC28LZD2xWfA3N7wUZQ2k9+HNQxlKGQ3VTgVV/mFf6FBVg51HngR4Caa/Y09A8
ntZVuW99UD+jFGUZtm8QS9u5OITFYDreCaZc2t2nmEmMub33JnByssdX9N7S/wtC
FIEu+xgy1KLdGKS4kNJSVJ+nUY1A2gQ4P3njBDGuktxRhHKcE9GUVnaNkJ1r/TNf
LLVFOeRrhUGDkeGiNdObwpQoSG54Vs4GLOsBn0QI17A9I+JnCYcQzm3v+6cWYXG7
tnOhT5O62v0nd2ybRMJZ
=CU8f
-----END PGP SIGNATURE-----

--hNweOTLwwbnii4NA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [patch] ib/rxe: double free on error
Date: Sat, 18 Jun 2016 14:22:07 +0300
Message-ID: <20160618112207.GG5408@leon.nu>
References: <20160618084021.GB21713@mwanda>
 <20160618103430.GC5408@leon.nu>
 <20160618110003.GJ32247@mwanda>
 <20160618110330.GF5408@leon.nu>
Reply-To: leon@kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yJLks8MEB0SlUFSu"
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160618110330.GF5408@leon.nu>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Moni Shoua <monis@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--yJLks8MEB0SlUFSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 18, 2016 at 02:03:30PM +0300, Leon Romanovsky wrote:
> On Sat, Jun 18, 2016 at 02:00:03PM +0300, Dan Carpenter wrote:
> > On Sat, Jun 18, 2016 at 01:34:30PM +0300, Leon Romanovsky wrote:
> > >  drivers/infiniband/hw/rxe/rxe.c | 29 ++++++-----------------------
> > >  1 file changed, 6 insertions(+), 23 deletions(-)
> > >=20
> > > diff --git a/drivers/infiniband/hw/rxe/rxe.c b/drivers/infiniband/hw/=
rxe/rxe.c
> > > index 48c41e00..156a1021 100644
> > > --- a/drivers/infiniband/hw/rxe/rxe.c
> > > +++ b/drivers/infiniband/hw/rxe/rxe.c
> > > @@ -165,42 +165,25 @@ static int rxe_init_port_param(struct rxe_port =
*port)
> > >   */
> > >  static int rxe_init_ports(struct rxe_dev *rxe)
> > >  {
> > > -	int err;
> > > -	struct rxe_port *port;
> > > -
> > > -	port =3D &rxe->port;
> > > +	struct rxe_port *port =3D  rxe->port;
> >=20
> > This won't compile.
>=20
> Interesting, it compiled locally. I'll check it now.

Thanks, I accidentally pushed wrong version.

>=20
> >=20
> > Just give me Reported-by credit not authorship.
> >=20
> > regards,
> > dan carpenter
> >=20



--yJLks8MEB0SlUFSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXZS7fAAoJEORje4g2clinJVMQALfrc5wAbUNWy/jWXpNnRlAr
/lMvQ4xLUrGOHaOPNV76Cl7lZ28UIkh4nFhsE3zAkHsD5wdPOrzHGKyprOBe3D9e
6X4BygctkVFcmjzxhFPnsph0JtSi9HTBrfYoOZ3Yix+Z5Wm6NtQRNXFm7pu3hkF/
gVyGFFPqwwHx2GVyOo/dvJbYHupvWEXf4hHL8kjLl/L/26Yhc+NMIR30/MLrszqa
1EmNhlG/kCKERwXxhM1wVCFiTQAd2puV4/aq2H4289+Bap0XPK72aj5gNvXp5Fee
Ps+E2aNsgXqbjvLe274XzalQ4mGqzqCie3emqNnfjwGYeCzd9/1H71heCPj5YYti
2TJkZKfE+TZv9cmoG+sbo0GJc8mIYxPk8Y08OX2RivTXlGn2R3EOeglY0yA6SBJ5
y9BPzU7dozCFNcfyM4dECC8vqfhwM1YRESbviQfYhtWRl6JUg9yZleAckrJSNQ9J
MBk0NUgTxZizmZJY0ARnvAXtPOgud5vDvi+d7KgJ2DWPc5ZSyTzEqSE4706AF9L6
qJB659NaFXmOdLED7PfWXsm7Mga9pOer9RyrNNPNC6w9cHcHDM180/+3766G79aP
4YUSXbvdlbxbwlCcz/vjKTXUxdcEcl3dR7R/cu/+bLf6i36cWy160szayAV8v/6t
Q/C/LpfpafpGzZvIpRKG
=ZHVI
-----END PGP SIGNATURE-----

--yJLks8MEB0SlUFSu--

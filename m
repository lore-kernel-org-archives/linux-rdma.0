From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH rdma-next v1 0/4] Expose ENCAP mode to mlx5_ib
Date: Mon, 17 Jun 2019 16:18:56 -0400
Message-ID: <51c50b108d2ab2fc7ff22bf7b38053adca0c365e.camel@redhat.com>
References: <20190612122014.22359-1-leon@kernel.org>
         <20190616124357.GH4694@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-cDVk982+pcQY7caxNPz5"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190616124357.GH4694@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>, Parav Pandit <parav@mellanox.com>, Petr Vorel <pvorel@suse.cz>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


--=-cDVk982+pcQY7caxNPz5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2019-06-16 at 12:44 +0000, Leon Romanovsky wrote:
> On Wed, Jun 12, 2019 at 03:20:10PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >=20
> > Changelog v0->v1:
> >  * Added patch to devlink to use declared enum for encap mode
> > instead of u8
> >  * Constify input argumetn to encap mode function
> >  * fix encap variable type to be boolean
> >=20
> > -----------------------------------------------------------------
> > ----
> > Hi,
> >=20
> > This is short series from Maor to expose and use enacap mode inside
> > mlx5_ib.
> >=20
> > Thanks
> >=20
> > Leon Romanovsky (1):
> >   net/mlx5: Declare more strictly devlink encap mode
> >=20
> > Maor Gottlieb (3):
> >   net/mlx5: Expose eswitch encap mode
>=20
> Those two applied to mlx5-next
> 82b11f071936 net/mlx5: Expose eswitch encap mode
> 98fdbea55037 net/mlx5: Declare more strictly devlink encap mode
>=20
> >   RDMA/mlx5: Consider eswitch encap mode
> >   RDMA/mlx5: Enable decap and packet reformat on FDB
>=20
> Doug, Jason
>=20
> Can you please take those two patches in addition to latest mlx5-
> next?

Done, thanks.


--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57
2FDD

--=-cDVk982+pcQY7caxNPz5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAl0H9bAACgkQuCajMw5X
L917uA//e5x498U/O5qfHU6XmC/M8F30bbBP9608RzJTu6smZnw0HysLX98g9AeA
99dod1NvL8XSm6vJkZDFeMuCVHTXSIbnujEWbk5hSnqmgFxG+Q2sIG1pxmNft7zy
Bt+MWMoedRmuvQUgU3nQr8OcMRIXKaPuYCVaGvmhu5s4Q2Qy6SG3jK9ka/TN0lHP
63ke/oNQyY9Y7gnxfJRBfCfcAe+iF94S1rdWhKhQNM8E0zBJ0axzC+JcJAlm8qd/
eZX2++0FrBdDPInwWZfm8YZK41cTrit+jzZZr5EBuUdx1EoaBmUYOcXoL8kwUjM7
Sg6VzGLWoKLhJhhF2obvVZwu51x2uu1gzr2GCIN14kslxsyoxSwhOaX6YAk7bVLT
DJFcp21AEEVCi/2GZDPrWS55KI1uWy0azKfXKK9w7aDJXrs56MkJ/jII41c5IV9A
YVj6YffTL5CjMQikq6cLcOIybL9tZZtQM8OPrBhY5V23P1kXF+ZU1GTG6tnjuG9v
AHlUJ3XNCiMxtoxJfwXhhr4ifpwBeRoO7JVn3XPPIGTizAq53nNXb+QYNi3KPIYd
JhCvywYgm5Fhs6tapHuqnsIgWu5ACLEOOACHtA6G/sjRjGIreX8pck25bqAESS//
0M1XmdfGtCoInB/Zp8/pSW9dZD/pRVdh9+lY+yBiV+/LA8gcFvg=
=wE8p
-----END PGP SIGNATURE-----

--=-cDVk982+pcQY7caxNPz5--

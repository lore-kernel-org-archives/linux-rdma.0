From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH rdma-next v1 0/4] Scatter to CQE
Date: Wed, 17 Oct 2018 11:27:41 -0400
Message-ID: <f21a7543b35a9aa764cb7ba65c219819668b6baf.camel@redhat.com>
References: <20181009090515.25223-1-leon@kernel.org>
         <f59c18d5d4d02d93d3e918f93b8a4a81bdf6e5a6.camel@redhat.com>
         <20181016190008.GL3606@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-5FF+P8kpsNXUtqGKGUYU"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181016190008.GL3606@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-5FF+P8kpsNXUtqGKGUYU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-10-16 at 22:00 +0300, Leon Romanovsky wrote:
> On Tue, Oct 16, 2018 at 02:39:01PM -0400, Doug Ledford wrote:
> > On Tue, 2018-10-09 at 12:05 +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@mellanox.com>
> > >=20
> > > Changelog v0->v1:
> > >  * Changed patch #3 to use check_mask function from rdma-core instead=
 define.
> > >=20
> > > ---------------------------------------------------------------------=
-----
> > > From Yonatan,
> > >=20
> > > Scatter to CQE is a HW offload feature that saves PCI writes by
> > > scattering the payload to the CQE.
> > >=20
> > > The feature depends on the CQE size and if the CQE size is 64B, it wi=
ll
> > > work for payload smaller than 32. If the CQE size is 128B, it will wo=
rk for
> > > payload smaller than 64.
> > >=20
> > > The feature works for responder and requestor:
> > > 1. For responder, if the payload is small as required above, the data
> > > will be part of the CQE, and thus we save another PCI transaction the=
 recv buffers.
> > > 2. For requestor, this can be used to get the RDMA_READ response and
> > > RDMA_ATOMIC response in the CQE. This feature is already supported in=
 upstream.
> > >=20
> > > As part of this series, we are adding support for DC transport type a=
nd
> > > ability to enable the feature (force enable) in the requestor when SQ
> > > is not configured to signal all WRs.
> > >=20
> > > Thanks
> > >=20
> > > Yonatan Cohen (4):
> > >   net/mlx5: Expose DC scatter to CQE capability bit
> > >   IB/mlx5: Support scatter to CQE for DC transport type
> > >   IB/mlx5: Verify that driver supports user flags
> > >   IB/mlx5: Allow scatter to CQE without global signaled WRs
> > >=20
> > >  drivers/infiniband/hw/mlx5/cq.c      |  2 +-
> > >  drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 +-
> > >  drivers/infiniband/hw/mlx5/qp.c      | 93 ++++++++++++++++++++++++++=
++--------
> > >  include/linux/mlx5/mlx5_ifc.h        |  3 +-
> > >  include/uapi/rdma/mlx5-abi.h         |  1 +
> > >  5 files changed, 79 insertions(+), 22 deletions(-)
> > >=20
> > > --
> > > 2.14.4
> > >=20
> >=20
> >=20
> > Hi Leon,
> >=20
> > This series looks fine.  Let me know when the net/mlx5 portion has been
> > committed.
>=20
> Thanks Doug,
> I pushed first patch to mlx5-next
> 94a04d1d3d36 ("net/mlx5: Expose DC scatter to CQE capability bit")

Thanks Leon, mlx5-next merged in, then remainder of series applied to
for-next.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-5FF+P8kpsNXUtqGKGUYU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlvHVO0ACgkQuCajMw5X
L90qYw//X5NuyWhdl80B4FPhSb7Ygz+G6yYBDanJGlPJyYDPYU2P+reptK3/Jiv9
8nSAlgrEc4rT7g0A5w/9IAeByaIE9Uxbol7XaZzstfRzLGbnioCtKpGpzoEwB3Ze
76+XO6OUQQMGAK1DCkn4Yvn3uiNI6CRdyCOoolRNs/GPtqnAL1uBJlJdc2huISkx
jmHuSzLjZCwMhiZGVYB1Fglcg5UCax4PFtJwAA5bCMdb7tl2UTa81MAcQ0pj7Dgc
+qUWj/dhyARsrX0uWnpJhipOkR4gLB2zZEJ5SOPgcwh2izjt8M9ZgPmekvB+YHt6
3z91lugg3wu5J3B90BEr5N3NZr7sz8dGONmQpCKsnIurdAxaQ2kLChNESY/UYTGm
02RkSH3m1FYkGJfSSlKvGVHLbldMkSROlxQFL16diW3nU55zBUQ0vXI3exLh6tb6
vOWRX7BC7q/DE8luZ1r2FWl1Y+ZVHc2a1x19Svt6h4LSCKKbmL/yr1h3lG9Jrh71
+1nxagLRCErCBi4IrtADL+4W7WszMkxGzSPh4d7X+uJxZ/c9/TXeJHiwB2e+rNRo
cBYErcUQ1qz0dkUwLe/77M+k4wDd/kxseQrJhU0peSxdlKLLdqmb8YyvaxSYtusJ
Vwb+T5clzURxosfZghWtXoeU9RdoOLyR17hMjzqpU17604y0nQA=
=tT3i
-----END PGP SIGNATURE-----

--=-5FF+P8kpsNXUtqGKGUYU--

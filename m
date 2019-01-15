From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH mlx5-next] RDMA/mad: Reduce MAD scope to mlx5_ib only
Date: Tue, 15 Jan 2019 10:05:01 +0200
Message-ID: <20190115080501.GH15600@mtr-leonro.mtl.com>
References: <20190113135704.10032-1-leon@kernel.org>
 <20190114195615.GV22875@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190114195615.GV22875@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 14, 2019 at 07:56:23PM +0000, Jason Gunthorpe wrote:
> On Sun, Jan 13, 2019 at 03:57:04PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Management Datagram Interface (MAD) is applicable
> > only when physical port is Infiniband. It makes MAD
> > command logic to be completely unrelated to eth/core
> > parts of mlx5.
>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  drivers/infiniband/hw/mlx5/cmd.c              | 37 +++++++++
> >  drivers/infiniband/hw/mlx5/cmd.h              |  2 +
> >  drivers/infiniband/hw/mlx5/mad.c              | 11 ++-
> >  drivers/infiniband/hw/mlx5/mlx5_ib.h          |  3 -
> >  .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
> >  drivers/net/ethernet/mellanox/mlx5/core/mad.c | 75 -------------------
> >  include/linux/mlx5/driver.h                   |  2 -
> >  7 files changed, 47 insertions(+), 85 deletions(-)
> >  delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/mad.c
>
> Acked-by: Jason Gunthorpe <jgg@mellanox.com>

Thanks, applied to mlx5-next, which is based on -rc2.

73f5a82bb3c9 RDMA/mad: Reduce MAD scope to mlx5_ib only


>
> Jason

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcPZQtAAoJEORje4g2clinDbsP/iGjwivklUQI9QvTQnrxpt8O
d45rNXzzLAfWK5sLSCShxTzPSSpDUEAa/Auzze3wrDc7W9xMwsxL3eTD102uh7Ba
m0gO4zm+28SmZDDMYs2qaXLgH226nQSYzpSZJX9+6fTYYxtgXa1cZOent2NJkh+L
GSfHsjOtCufXqiI1hJ1LhVgN5WHlDwF7mKS2ru1LX5eP2qhAsg8xmeP8yPEppmU3
vbe1Z5Yb/moOmbRLjEY/Pn9lo0LugrFufAiyYwC3e12Bbu0kRisNGBK06C1yrB3K
YC57HtHrgytOvw9+bjVZ9GS6flCKAip45wdun5v5oM2sTR7ObKueGmDQw07QpooC
OnxQbB59kGeEQO8IGgQxUMEk1YNAEP2Koxa5+4Cr8YICMXv2dZZKEKxfVvqzw3ZA
szfUrk7lJIDHsolgKsDbS2NnI5xMUBeUjP2BK5pL2n7EdoNV0PZPf51m6jRKPLBN
t3YlJVrkeFpkc+HILEBYcMhSWppTuI2zMQAUmPaGsnzRh2g5RnZTZkrEe8SPbGGq
HJ9wnZh8NudhdZNMkJP8rhJEhqvpPI0dR5R2D8idYYDrTA1CkA893gjDMrEWAZYX
OrVWvUM/kPPVJoVugt4HC2mRyKvcRO7o0irVoRvPYh3kzjABCr+Ukb60Us1UnWgB
gP+QiNOgIbk3ORnOo72w
=7vFv
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--

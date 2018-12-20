From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH mlx5-next] IB/mlx5: Prevent allocating UMEM and UCTX as
 some general object
Date: Thu, 20 Dec 2018 08:21:33 +0200
Message-ID: <20181220062133.GH13943@mtr-leonro.mtl.com>
References: <20181219142815.21480-1-leon@kernel.org>
 <20181219191406.GX30567@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Cgrdyab2wu3Akvjd"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181219191406.GX30567@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, Yishai Hadas <yishaih@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Achiad Shochat <achiad@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--Cgrdyab2wu3Akvjd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 19, 2018 at 07:14:12PM +0000, Jason Gunthorpe wrote:
> On Wed, Dec 19, 2018 at 04:28:15PM +0200, Leon Romanovsky wrote:
> > From: Yishai Hadas <yishaih@mellanox.com>
> >
> > The driver needs to prevent a user space application to create a
> > UMEM and UCTX via the general object command.
> >
> > The UMEM must go through the kernel UMEM_REG method to prevent the user
> > from setting physical addresses by himself.  The UCTX is some internal
> > kernel object and shouldn't be exposed.
> >
> > As of not being any more part of the general object the caps bits were
> > moved to be some log_xxx indication in the general HCA caps, 0 means not
> > supported.
> >
> > The firmware code was adapted as well to match the above.
>
> This commit message is a bit wonky.. how about
>
> IB/mlx5: Use the correct commands for UMEM and UCTX allocation
>
> During testing the command format was changed to close a security
> hole. Revise the driver to use the command format that will actually
> be supported in GA firmware.
>
> Both the UMEM and UCTX are intended only for use by the kernel and
> cannot be executed using a general command.
>
> Since the UMEM and CTX are not part of the general object the caps
> bits were moved to be some log_xxx location in the general HCA caps.

I'm fine with this description too.

>
> > Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> > Reviewed-by: Achiad Shochat <achiad@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>
> Also add a fixes line please, any kernel with the devx needs this
> patch to work with GA firmware.

Fixes: a8b92ca1b0e5 ("IB/mlx5: Introduce DEVX")

>
> >  drivers/infiniband/hw/mlx5/devx.c | 34 ++++++++---------
> >  drivers/infiniband/hw/mlx5/main.c |  3 +-
> >  include/linux/mlx5/mlx5_ifc.h     | 62 +++++++++++++++++++++----------
> >  3 files changed, 58 insertions(+), 41 deletions(-)
>
> Otherwise the patch looks fine, please apply to the shared branch..

Jason,

I have procedural question. This patch is based on rdma-next and there
is diversion in both devx.c and main.c in those areas, enough do not
apply cleanly. Will it be easier if you take this patch to rdma-next,
instead me applying different patch to mlx5-next and you hitting merge
conflict later on while trying to merge it into rdma-next?

Thanks

>
> Thanks,
> Jason

--Cgrdyab2wu3Akvjd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcGzTtAAoJEORje4g2clingdEP/RWXyS76u05zM3LESAKs0uy1
4naes17aTgxS6FTKZyipetDXzlHZ06+y8MTh7nxgylPxd6GBUc6c0ZBf5x+LKTMo
8kr3Q0hWYTrM/RNm/n+mIwIiFhdlRlkStJohRRS208Zm5qqWSgGpNAAr2syPjVW8
Poy89XGZak3b7o4yWY8/Uo429XX34/m2fDL3AqnMhgwUppy87KFO7I/eC4G7OyH/
KdMQAfjjoEDG9ot6SINeRSon7Uj6bnUjZksnmK05qdr7bNMemNpOLCk3Z5k8oYER
Jm6C0obABZ+MZCzLbeM3zZNK2uETZzkTvLH6/mEN+/j5XvNEodj6o9UZFGGZ3wet
WRLXyeA8Us3SJiFS/Qh1EyRmg1HOM/owSmxldxkU7A9Uz/ccnLZbECfiKYD5RfbJ
7HBwrrA2xpq4UFb9Z3C5NySU490PyRbo8EM/SSOAcIeANBJmnkgGpDN57Lkv6uZ3
hsre++MHG/RdcCAylu8UnQ8KJ0Lagwxmq8wVojTPnD5CqU+lD25rjW895tpSUf9D
Z0jgvcQfY7MPYqe2rRUdHYBBpKhJRYhLa/Dm4NJwAEYCtqYMTTKiueres5AFzJa7
7SGx6ifzJHCLQdx6OAO8nIUB776EbK/LDb7082bqZjdPT52igwCpboyaTlh6fxBx
QnyhviaWMRKblcLIZQPw
=TJ+h
-----END PGP SIGNATURE-----

--Cgrdyab2wu3Akvjd--

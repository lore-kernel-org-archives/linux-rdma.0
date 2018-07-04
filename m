From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 3/3] IB/mlx5: Expose dump and fill memory key
Date: Wed, 4 Jul 2018 22:20:15 +0300
Message-ID: <20180704192015.GT3014@mtr-leonro.mtl.com>
References: <20180619054724.32677-1-leon@kernel.org>
 <20180619054724.32677-4-leon@kernel.org>
 <20180704190937.GA15732@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Nx8xdmI2KD3LNVVP"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180704190937.GA15732@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--Nx8xdmI2KD3LNVVP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 04, 2018 at 01:09:37PM -0600, Jason Gunthorpe wrote:
> On Tue, Jun 19, 2018 at 08:47:24AM +0300, Leon Romanovsky wrote:
> > From: Yonatan Cohen <yonatanc@mellanox.com>
> >
> > MLX5 IB HCA offers the memory key, dump_fill_mkey to boost
> > performance, when used in a send or receive operations.
> >
> > It is used to force local HCA operations to skip the PCI bus access,
> > while keeping track of the processed length in the ibv_sge handling.
> >
> > Meaning, instead of a PCI write access the HCA leaves the target
> > memory untouched, and skips filling that packet section. Similar
> > behavior is done upon send, the HCA skips data in memory relevant
> > to this key and saves PCI bus access.
> >
> > This functionality saves PCI read/write operations.
> >
> > Signed-off-by: Yonatan Cohen <yonatanc@mellanox.com>
> > Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
> > Reviewed-by: Guy Levi <guyle@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> >  drivers/infiniband/hw/mlx5/main.c | 16 +++++++++++++++-
> >  include/uapi/rdma/mlx5-abi.h      |  3 ++-
> >  2 files changed, 17 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> > index c29c7c838980..97113957398d 100644
> > +++ b/drivers/infiniband/hw/mlx5/main.c
> > @@ -1634,6 +1634,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
> >  	int err;
> >  	size_t min_req_v2 = offsetof(struct mlx5_ib_alloc_ucontext_req_v2,
> >  				     max_cqe_version);
> > +	u32 dump_fill_mkey;
> >  	bool lib_uar_4k;
> >
> >  	if (!dev->ib_active)
> > @@ -1743,8 +1744,12 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
> >  		}
> >
> >  		err = mlx5_ib_devx_create(dev, context);
> > +	}
> > +
> > +	if (MLX5_CAP_GEN(dev->mdev, dump_fill_mkey)) {
> > +		err = mlx5_cmd_dump_fill_mkey(dev->mdev, &dump_fill_mkey);
> >  		if (err)
> > -			goto out_td;
> > +			goto out_mdev;
> >  	}
>
> Dropping the if (err) after mlx5_ib_devx_create is a rebasing error,
> right?

Sorry, you are right, the fixup is pretty straightforward.

diff --git a/drivers/infiniband/hw/mlx5/main.c
b/drivers/infiniband/hw/mlx5/main.c
index 2bbafee6976c..71f3e9677622 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1739,6 +1739,8 @@ static struct ib_ucontext
*mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
                }

                err = mlx5_ib_devx_create(dev,  context);
                if (err)
 +                       goto out_td;
         }

         if (MLX5_CAP_GEN(dev->mdev, dump_fill_mkey)) {


>
> Jason

--Nx8xdmI2KD3LNVVP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbPR3vAAoJEORje4g2clintqgP/jyXFJJCBN6nrg1S/APUGXt+
KitaJz+nlztc7UDln6dmER7la04fph24SsvIvrlV9v5ZFoehoi98gv5O4G2o5sn+
yggHcPRjkmQMLpPRpq2yZZ3945wxqCOyudE9VXjBrSY/dLb83+y8WwLejZUuuxQn
tiXOKKpfrvl5aW/hsKO/nGUeZv16hkfymc/Smy5Y3jaWwvJ9FYFzbR6NsRskagQe
88oO+akRWxDQXVbebNvh8NJTLpx4qJxD5dyijYTHTx/pRih0MDoJWqo5aabNE8Bx
1EoF52nyQlIB63lMgIdvg2s1/flHhHavT5jKee+GN6vfCTJf9S/SDqgALVBGsQkg
NLScpPvNm/1U6D7YBt3iWhwILZ7Oc/o/FmLbBUyzEzeqMDNWug6B5v3uMc9T+rk+
dgJHyJrNLeQeUcoA2vuHlECdEuVY5ZL0FTlAYxpjJYMuw4PgokTM6HPPvmCnwsIS
Jqrsx3SJlUUKUPMuPAFeVmKwd8oaU/lj8E43ZLdjtizDq7aBQ8Uycd+1avND71u4
93Netg82/MhbIQRRbTNB2VtpZ5QLTYd4H875RPgeCh8gD4nV9yVj+AhHvBx05K/T
FksyljSUEXT/d7Tn1d/xWdTKe3k11YEzaQdQdU0KUqSv80wHk1o8r1WCOluFo5Jn
VEX0gI0RZBOxLPXNLypr
=8YqT
-----END PGP SIGNATURE-----

--Nx8xdmI2KD3LNVVP--

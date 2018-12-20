From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 2/5] RDMA/core: Don't depend device ODP
 capabilities on kconfig option
Date: Thu, 20 Dec 2018 19:29:56 +0200
Message-ID: <20181220172956.GC3940@mtr-leonro.mtl.com>
References: <20181220092318.32672-1-leon@kernel.org>
 <20181220092318.32672-3-leon@kernel.org>
 <20181220172045.GG29267@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="eHhjakXzOLJAF9wJ"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181220172045.GG29267@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Haggai Eran <haggaie@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--eHhjakXzOLJAF9wJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 20, 2018 at 05:20:51PM +0000, Jason Gunthorpe wrote:
> On Thu, Dec 20, 2018 at 11:23:15AM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Device capability bits are exposing what specific device supports from
> > HW perspective. Those bits are not dependent on kernel configurations
> > and RDMA/core should ensure that proper interfaces to users will be
> > disabled if CONFIG_INFINIBAND_ON_DEMAND_PAGING is not set.
> >
> > Fixes: f4056bfd8ccf ("IB/core: Add on demand paging caps to ib_uverbs_ex_query_device")
> > Fixes: 8cdd312cfed7 ("IB/mlx5: Implement the ODP capability query verb")
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> >  drivers/infiniband/core/uverbs_cmd.c | 2 --
> >  drivers/infiniband/hw/mlx5/main.c    | 2 --
> >  2 files changed, 4 deletions(-)
> >
> > diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> > index 6b12cc5f97b2..549d9eedf62e 100644
> > +++ b/drivers/infiniband/core/uverbs_cmd.c
> > @@ -3609,7 +3609,6 @@ static int ib_uverbs_ex_query_device(struct uverbs_attr_bundle *attrs)
> >
> >  	copy_query_dev_fields(ucontext, &resp.base, &attr);
> >
> > -#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> >  	resp.odp_caps.general_caps = attr.odp_caps.general_caps;
> >  	resp.odp_caps.per_transport_caps.rc_odp_caps =
> >  		attr.odp_caps.per_transport_caps.rc_odp_caps;
> > @@ -3617,7 +3616,6 @@ static int ib_uverbs_ex_query_device(struct uverbs_attr_bundle *attrs)
> >  		attr.odp_caps.per_transport_caps.uc_odp_caps;
> >  	resp.odp_caps.per_transport_caps.ud_odp_caps =
> >  		attr.odp_caps.per_transport_caps.ud_odp_caps;
> > -#endif
>
> This one is maybe OK, assuming the driver fills in 0..
>
> >  	resp.timestamp_mask = attr.timestamp_mask;
> >  	resp.hca_core_clock = attr.hca_core_clock;
> > diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> > index 6584e638387a..d7e5ba5034aa 100644
> > +++ b/drivers/infiniband/hw/mlx5/main.c
> > @@ -923,11 +923,9 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
> >  	props->hca_core_clock = MLX5_CAP_GEN(mdev, device_frequency_khz);
> >  	props->timestamp_mask = 0x7FFFFFFFFFFFFFFFULL;
> >
> > -#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> >  	if (MLX5_CAP_GEN(mdev, pg))
> >  		props->device_cap_flags |= IB_DEVICE_ON_DEMAND_PAGING;
> >  	props->odp_caps = dev->odp_caps;
> > -#endif
>
> But shouldn't this be protected? If the driver has compiled out ODP it
> shouldn't set the cap flag...

I see those capabilities as device properties and not as kernel ones.

Current situation looks bad for me, when I have same device which
reports differently information depends on some compilation flag.

If driver was compiled without CONFIG_INFINIBAND_ON_DEMAND_PAGING, the
kernel core code should be compiled without this config set too and core
code wouldn't pass any ODP related verbs/flags.

Thanks

>
> Jason

--eHhjakXzOLJAF9wJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcG9GUAAoJEORje4g2clinemYP/1v+S50WF+lj66yTLQdKqs2i
Q4HjbIAwbzNw2r8ac0G8ttlcSqasQUcl1SoKbjJP/4QlcyjonUk/O8fCRLJMCTcn
TWxJqwmDTLmk3hwjqXlSc4EyiL1wN31pNdwlJZ4DqWDmNhZ1dMoM7YJN5O2huI5P
7WSTbKrJgn/W6R3U61qqutXv/KQxB/t7KKRGV93F/xgJLB0pbjlQ6Joseu5N6InY
rXTZMdG5ULBf0RsusQVzGJlpSY3EnV7H6Us461Vk8KnOrsIgow+reMMZ25Wm1qbY
1SjLUKR3E8aaRU05/yJ/FBMTKV1qlElHTkIl6f4RW/bGBfSU2CaWIx6w6QVFOL/L
+sL+g6zx2UrWS1V8UIVatQwe+IfB0F81cc3R7gCOMkJd5STp4O3lJKLGWi5lJjDa
hMiT/rZ7fVJrTlg5Bdww7Ii+wYCzhZldelwQSh/kLER1xvY6LffwMO7Bx+68sR5c
PkYdmRooWg5dV7tqpddSgy29A6OhaZeJPiTD3cFbBjOpFZYLd/LihnQDrtuTnPh/
dlUlFN0XuZdN4ICagpeQe1ltqWaEknFGUBEGs6adAHmuJiHi0yv89CVzPM/ndMeq
lQewQW04yHQSPBh5Zw9qtmCNqxgc7c0Kr74bvJA2ELqqu3iD53Mm4I5ZLc2kC4KY
TYcRMY2B06ko2rxPWrcF
=Q3Lk
-----END PGP SIGNATURE-----

--eHhjakXzOLJAF9wJ--

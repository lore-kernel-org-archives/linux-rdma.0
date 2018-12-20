From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 2/5] RDMA/core: Don't depend device ODP
 capabilities on kconfig option
Date: Thu, 20 Dec 2018 19:50:20 +0200
Message-ID: <20181220175020.GD3940@mtr-leonro.mtl.com>
References: <20181220092318.32672-1-leon@kernel.org>
 <20181220092318.32672-3-leon@kernel.org>
 <20181220172045.GG29267@mellanox.com>
 <20181220172956.GC3940@mtr-leonro.mtl.com>
 <20181220173306.GI29267@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+KJYzRxRHjYqLGl5"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181220173306.GI29267@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Haggai Eran <haggaie@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--+KJYzRxRHjYqLGl5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 20, 2018 at 05:33:11PM +0000, Jason Gunthorpe wrote:
> On Thu, Dec 20, 2018 at 07:29:56PM +0200, Leon Romanovsky wrote:
> > On Thu, Dec 20, 2018 at 05:20:51PM +0000, Jason Gunthorpe wrote:
> > > On Thu, Dec 20, 2018 at 11:23:15AM +0200, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@mellanox.com>
> > > >
> > > > Device capability bits are exposing what specific device supports from
> > > > HW perspective. Those bits are not dependent on kernel configurations
> > > > and RDMA/core should ensure that proper interfaces to users will be
> > > > disabled if CONFIG_INFINIBAND_ON_DEMAND_PAGING is not set.
> > > >
> > > > Fixes: f4056bfd8ccf ("IB/core: Add on demand paging caps to ib_uverbs_ex_query_device")
> > > > Fixes: 8cdd312cfed7 ("IB/mlx5: Implement the ODP capability query verb")
> > > > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > > >  drivers/infiniband/core/uverbs_cmd.c | 2 --
> > > >  drivers/infiniband/hw/mlx5/main.c    | 2 --
> > > >  2 files changed, 4 deletions(-)
> > > >
> > > > diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> > > > index 6b12cc5f97b2..549d9eedf62e 100644
> > > > +++ b/drivers/infiniband/core/uverbs_cmd.c
> > > > @@ -3609,7 +3609,6 @@ static int ib_uverbs_ex_query_device(struct uverbs_attr_bundle *attrs)
> > > >
> > > >  	copy_query_dev_fields(ucontext, &resp.base, &attr);
> > > >
> > > > -#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> > > >  	resp.odp_caps.general_caps = attr.odp_caps.general_caps;
> > > >  	resp.odp_caps.per_transport_caps.rc_odp_caps =
> > > >  		attr.odp_caps.per_transport_caps.rc_odp_caps;
> > > > @@ -3617,7 +3616,6 @@ static int ib_uverbs_ex_query_device(struct uverbs_attr_bundle *attrs)
> > > >  		attr.odp_caps.per_transport_caps.uc_odp_caps;
> > > >  	resp.odp_caps.per_transport_caps.ud_odp_caps =
> > > >  		attr.odp_caps.per_transport_caps.ud_odp_caps;
> > > > -#endif
> > >
> > > This one is maybe OK, assuming the driver fills in 0..
> > >
> > > >  	resp.timestamp_mask = attr.timestamp_mask;
> > > >  	resp.hca_core_clock = attr.hca_core_clock;
> > > > diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> > > > index 6584e638387a..d7e5ba5034aa 100644
> > > > +++ b/drivers/infiniband/hw/mlx5/main.c
> > > > @@ -923,11 +923,9 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
> > > >  	props->hca_core_clock = MLX5_CAP_GEN(mdev, device_frequency_khz);
> > > >  	props->timestamp_mask = 0x7FFFFFFFFFFFFFFFULL;
> > > >
> > > > -#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> > > >  	if (MLX5_CAP_GEN(mdev, pg))
> > > >  		props->device_cap_flags |= IB_DEVICE_ON_DEMAND_PAGING;
> > > >  	props->odp_caps = dev->odp_caps;
> > > > -#endif
> > >
> > > But shouldn't this be protected? If the driver has compiled out ODP it
> > > shouldn't set the cap flag...
> >
> > I see those capabilities as device properties and not as kernel ones.
> >
> > Current situation looks bad for me, when I have same device which
> > reports differently information depends on some compilation flag.
>
> It is not device capabilities, it is a kernel API capability if the
> API is not available the bit should not be set.

Is it better? Should I resend the series?

diff --git a/drivers/infiniband/hw/mlx5/main.c
b/drivers/infiniband/hw/mlx5/main.c
index 0b68795fb04e..c95c2f545b8f 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -925,7 +925,8 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,

        if (MLX5_CAP_GEN(mdev, pg))
                props->device_cap_flags |=  IB_DEVICE_ON_DEMAND_PAGING;
-       props->odp_caps = dev->odp_caps;
+       if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING))
+               props->odp_caps =  dev->odp_caps;

        if (MLX5_CAP_GEN(mdev, cd))
                props->device_cap_flags |= IB_DEVICE_CROSS_CHANNEL;


>
> The field is badly named.
>
> Jason

--+KJYzRxRHjYqLGl5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcG9ZcAAoJEORje4g2clin2T4P/2NCD8ujC43j2iCqEZh0hyC6
kx/s5ltPLuPX/MevZBfSb1bkBPgILGCb6fwpEEwp/TpFxR4/ZPWxY5Oue7KuUnHA
nfZfjZCQ4rv71GCxV+jMuU4N51y9Lp9yFiaxH7w6Yo3ngDExOBaED9bkTUAMZUdj
iqfM5ECgEa3KDabbYWeQgu7+/qRwvYmb5FSV1lf2kTbrCPO0I0jTgx25iiQGcJ9Q
roiRzTQGA8YDzcFFZ2+OXDSoJxOwIGJooGDj/BB7xWFFgbNHVrNXoZWUPX2rQOQw
9H2PQyOf/KBQBA0TCzJxxkLsNnxS7q2LpYIwMTEWINdos3utiUMxKL98thtZdhxu
4x00mg6XHm77xdyp5EwOKIMF2mpTfHafP+WPlOX8P3mcCYJUSvrF0DbjrqhE6Fp/
7NwWFlUQ+HWlcHTpy33A2wiP+SQe6yS7/2sdGYmCEU3E2L/KcE2I9Ngx99kcxXA0
vEJQztZSnxkccrQFgsp3DG0+QS4GlF2RJYYNbS/U22lnpIqfaEXwiqfQ7ItyrYaF
DQnhHrxaHUVrM63N/Xk/gpV1UEnfW2jE4YozDVl2sFvEwcnUWCSz2YLAW8FHsiX0
peUi8oTYrLvhnPC6HivhoIFXw0Sq+eiT3sMlMxyx44yb2LRdQNa16OJMk3vHZ34h
g6qH2exIE7PK0Se/TkR0
=9Ojr
-----END PGP SIGNATURE-----

--+KJYzRxRHjYqLGl5--

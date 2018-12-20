From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next 2/5] RDMA/core: Don't depend device ODP
 capabilities on kconfig option
Date: Thu, 20 Dec 2018 17:33:11 +0000
Message-ID: <20181220173306.GI29267@mellanox.com>
References: <20181220092318.32672-1-leon@kernel.org>
 <20181220092318.32672-3-leon@kernel.org>
 <20181220172045.GG29267@mellanox.com>
 <20181220172956.GC3940@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181220172956.GC3940@mtr-leonro.mtl.com>
Content-Language: en-US
Content-ID: <583E1DD0B8E2F04FA38BACF81DD22832@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Haggai Eran <haggaie@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 20, 2018 at 07:29:56PM +0200, Leon Romanovsky wrote:
> On Thu, Dec 20, 2018 at 05:20:51PM +0000, Jason Gunthorpe wrote:
> > On Thu, Dec 20, 2018 at 11:23:15AM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@mellanox.com>
> > >
> > > Device capability bits are exposing what specific device supports fro=
m
> > > HW perspective. Those bits are not dependent on kernel configurations
> > > and RDMA/core should ensure that proper interfaces to users will be
> > > disabled if CONFIG_INFINIBAND_ON_DEMAND_PAGING is not set.
> > >
> > > Fixes: f4056bfd8ccf ("IB/core: Add on demand paging caps to ib_uverbs=
_ex_query_device")
> > > Fixes: 8cdd312cfed7 ("IB/mlx5: Implement the ODP capability query ver=
b")
> > > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > >  drivers/infiniband/core/uverbs_cmd.c | 2 --
> > >  drivers/infiniband/hw/mlx5/main.c    | 2 --
> > >  2 files changed, 4 deletions(-)
> > >
> > > diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniban=
d/core/uverbs_cmd.c
> > > index 6b12cc5f97b2..549d9eedf62e 100644
> > > +++ b/drivers/infiniband/core/uverbs_cmd.c
> > > @@ -3609,7 +3609,6 @@ static int ib_uverbs_ex_query_device(struct uve=
rbs_attr_bundle *attrs)
> > >
> > >  	copy_query_dev_fields(ucontext, &resp.base, &attr);
> > >
> > > -#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> > >  	resp.odp_caps.general_caps =3D attr.odp_caps.general_caps;
> > >  	resp.odp_caps.per_transport_caps.rc_odp_caps =3D
> > >  		attr.odp_caps.per_transport_caps.rc_odp_caps;
> > > @@ -3617,7 +3616,6 @@ static int ib_uverbs_ex_query_device(struct uve=
rbs_attr_bundle *attrs)
> > >  		attr.odp_caps.per_transport_caps.uc_odp_caps;
> > >  	resp.odp_caps.per_transport_caps.ud_odp_caps =3D
> > >  		attr.odp_caps.per_transport_caps.ud_odp_caps;
> > > -#endif
> >
> > This one is maybe OK, assuming the driver fills in 0..
> >
> > >  	resp.timestamp_mask =3D attr.timestamp_mask;
> > >  	resp.hca_core_clock =3D attr.hca_core_clock;
> > > diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/h=
w/mlx5/main.c
> > > index 6584e638387a..d7e5ba5034aa 100644
> > > +++ b/drivers/infiniband/hw/mlx5/main.c
> > > @@ -923,11 +923,9 @@ static int mlx5_ib_query_device(struct ib_device=
 *ibdev,
> > >  	props->hca_core_clock =3D MLX5_CAP_GEN(mdev, device_frequency_khz);
> > >  	props->timestamp_mask =3D 0x7FFFFFFFFFFFFFFFULL;
> > >
> > > -#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> > >  	if (MLX5_CAP_GEN(mdev, pg))
> > >  		props->device_cap_flags |=3D IB_DEVICE_ON_DEMAND_PAGING;
> > >  	props->odp_caps =3D dev->odp_caps;
> > > -#endif
> >
> > But shouldn't this be protected? If the driver has compiled out ODP it
> > shouldn't set the cap flag...
>=20
> I see those capabilities as device properties and not as kernel ones.
>=20
> Current situation looks bad for me, when I have same device which
> reports differently information depends on some compilation flag.

It is not device capabilities, it is a kernel API capability if the
API is not available the bit should not be set.

The field is badly named.

Jason

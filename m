From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next 2/5] RDMA/core: Don't depend device ODP
 capabilities on kconfig option
Date: Thu, 20 Dec 2018 17:20:51 +0000
Message-ID: <20181220172045.GG29267@mellanox.com>
References: <20181220092318.32672-1-leon@kernel.org>
 <20181220092318.32672-3-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181220092318.32672-3-leon@kernel.org>
Content-Language: en-US
Content-ID: <C71D9E34A2FA184490176122A188AB18@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Haggai Eran <haggaie@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 20, 2018 at 11:23:15AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>=20
> Device capability bits are exposing what specific device supports from
> HW perspective. Those bits are not dependent on kernel configurations
> and RDMA/core should ensure that proper interfaces to users will be
> disabled if CONFIG_INFINIBAND_ON_DEMAND_PAGING is not set.
>=20
> Fixes: f4056bfd8ccf ("IB/core: Add on demand paging caps to ib_uverbs_ex_=
query_device")
> Fixes: 8cdd312cfed7 ("IB/mlx5: Implement the ODP capability query verb")
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/core/uverbs_cmd.c | 2 --
>  drivers/infiniband/hw/mlx5/main.c    | 2 --
>  2 files changed, 4 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/co=
re/uverbs_cmd.c
> index 6b12cc5f97b2..549d9eedf62e 100644
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -3609,7 +3609,6 @@ static int ib_uverbs_ex_query_device(struct uverbs_=
attr_bundle *attrs)
> =20
>  	copy_query_dev_fields(ucontext, &resp.base, &attr);
> =20
> -#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
>  	resp.odp_caps.general_caps =3D attr.odp_caps.general_caps;
>  	resp.odp_caps.per_transport_caps.rc_odp_caps =3D
>  		attr.odp_caps.per_transport_caps.rc_odp_caps;
> @@ -3617,7 +3616,6 @@ static int ib_uverbs_ex_query_device(struct uverbs_=
attr_bundle *attrs)
>  		attr.odp_caps.per_transport_caps.uc_odp_caps;
>  	resp.odp_caps.per_transport_caps.ud_odp_caps =3D
>  		attr.odp_caps.per_transport_caps.ud_odp_caps;
> -#endif

This one is maybe OK, assuming the driver fills in 0..

>  	resp.timestamp_mask =3D attr.timestamp_mask;
>  	resp.hca_core_clock =3D attr.hca_core_clock;
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/ml=
x5/main.c
> index 6584e638387a..d7e5ba5034aa 100644
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -923,11 +923,9 @@ static int mlx5_ib_query_device(struct ib_device *ib=
dev,
>  	props->hca_core_clock =3D MLX5_CAP_GEN(mdev, device_frequency_khz);
>  	props->timestamp_mask =3D 0x7FFFFFFFFFFFFFFFULL;
> =20
> -#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
>  	if (MLX5_CAP_GEN(mdev, pg))
>  		props->device_cap_flags |=3D IB_DEVICE_ON_DEMAND_PAGING;
>  	props->odp_caps =3D dev->odp_caps;
> -#endif

But shouldn't this be protected? If the driver has compiled out ODP it
shouldn't set the cap flag...

Jason

From: Parav Pandit <parav@mellanox.com>
Subject: RE: [PATCH mlx5-next v1 1/4] net/mlx5: Declare more strictly devlink
 encap mode
Date: Thu, 13 Jun 2019 04:32:25 +0000
Message-ID: <VI1PR0501MB2271FF8A570DDBBD26CF7100D1EF0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190612122014.22359-1-leon@kernel.org>
 <20190612122014.22359-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190612122014.22359-2-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>, Petr Vorel <pvorel@suse.cz>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Wednesday, June 12, 2019 5:50 PM
> To: Doug Ledford <dledford@redhat.com>; Jason Gunthorpe
> <jgg@mellanox.com>
> Cc: Leon Romanovsky <leonro@mellanox.com>; RDMA mailing list <linux-
> rdma@vger.kernel.org>; Maor Gottlieb <maorg@mellanox.com>; Mark Bloch
> <markb@mellanox.com>; Parav Pandit <parav@mellanox.com>; Petr Vorel
> <pvorel@suse.cz>; Saeed Mahameed <saeedm@mellanox.com>; linux-
> netdev <netdev@vger.kernel.org>; Jiri Pirko <jiri@mellanox.com>
> Subject: [PATCH mlx5-next v1 1/4] net/mlx5: Declare more strictly devlink
> encap mode
>=20
> From: Leon Romanovsky <leonro@mellanox.com>
>=20
> Devlink has UAPI declaration for encap mode, so there is no need to be
> loose on the data get/set by drivers.
>=20
> Update call sites to use enum devlink_eswitch_encap_mode instead of plain
> u8.
>=20
> Suggested-by: Parav Pandit <parav@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch.h         | 8 +++++---
>  .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c    | 6 ++++--
>  include/net/devlink.h                                     | 6 ++++--
>  net/core/devlink.c                                        | 6 ++++--
>  4 files changed, 17 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> index ed3fad689ec9..e264dfc64a6e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> @@ -175,7 +175,7 @@ struct mlx5_esw_offload {
>  	DECLARE_HASHTABLE(mod_hdr_tbl, 8);
>  	u8 inline_mode;
>  	u64 num_flows;
> -	u8 encap;
> +	enum devlink_eswitch_encap_mode encap;
>  };
>=20
>  /* E-Switch MC FDB table hash node */
> @@ -356,9 +356,11 @@ int mlx5_devlink_eswitch_inline_mode_set(struct
> devlink *devlink, u8 mode,
>  					 struct netlink_ext_ack *extack);
>  int mlx5_devlink_eswitch_inline_mode_get(struct devlink *devlink, u8
> *mode);  int mlx5_eswitch_inline_mode_get(struct mlx5_eswitch *esw, int
> nvfs, u8 *mode); -int mlx5_devlink_eswitch_encap_mode_set(struct devlink
> *devlink, u8 encap,
> +int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
> +					enum devlink_eswitch_encap_mode
> encap,
>  					struct netlink_ext_ack *extack);
> -int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink, u8
> *encap);
> +int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
> +					enum devlink_eswitch_encap_mode
> *encap);
>  void *mlx5_eswitch_get_uplink_priv(struct mlx5_eswitch *esw, u8
> rep_type);
>=20
>  int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw, diff --git
> a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index e09ae27485ee..f1571163143d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -2137,7 +2137,8 @@ int mlx5_eswitch_inline_mode_get(struct
> mlx5_eswitch *esw, int nvfs, u8 *mode)
>  	return 0;
>  }
>=20
> -int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink, u8
> encap,
> +int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
> +					enum devlink_eswitch_encap_mode
> encap,
>  					struct netlink_ext_ack *extack)
>  {
>  	struct mlx5_core_dev *dev =3D devlink_priv(devlink); @@ -2186,7
> +2187,8 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink
> *devlink, u8 encap,
>  	return err;
>  }
>=20
> -int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink, u8
> *encap)
> +int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
> +					enum devlink_eswitch_encap_mode
> *encap)
>  {
>  	struct mlx5_core_dev *dev =3D devlink_priv(devlink);
>  	struct mlx5_eswitch *esw =3D dev->priv.eswitch; diff --git
> a/include/net/devlink.h b/include/net/devlink.h index
> 1c4adfb4195a..7a34fc586def 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -530,8 +530,10 @@ struct devlink_ops {
>  	int (*eswitch_inline_mode_get)(struct devlink *devlink, u8
> *p_inline_mode);
>  	int (*eswitch_inline_mode_set)(struct devlink *devlink, u8
> inline_mode,
>  				       struct netlink_ext_ack *extack);
> -	int (*eswitch_encap_mode_get)(struct devlink *devlink, u8
> *p_encap_mode);
> -	int (*eswitch_encap_mode_set)(struct devlink *devlink, u8
> encap_mode,
> +	int (*eswitch_encap_mode_get)(struct devlink *devlink,
> +				      enum devlink_eswitch_encap_mode
> *p_encap_mode);
> +	int (*eswitch_encap_mode_set)(struct devlink *devlink,
> +				      enum devlink_eswitch_encap_mode
> encap_mode,
>  				      struct netlink_ext_ack *extack);
>  	int (*info_get)(struct devlink *devlink, struct devlink_info_req *req,
>  			struct netlink_ext_ack *extack);
> diff --git a/net/core/devlink.c b/net/core/devlink.c index
> d43bc52b8840..47ae69363b07 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -1552,7 +1552,8 @@ static int devlink_nl_eswitch_fill(struct sk_buff
> *msg, struct devlink *devlink,
>  				   u32 seq, int flags)
>  {
>  	const struct devlink_ops *ops =3D devlink->ops;
> -	u8 inline_mode, encap_mode;
> +	enum devlink_eswitch_encap_mode encap_mode;
> +	u8 inline_mode;
>  	void *hdr;
>  	int err =3D 0;
>  	u16 mode;
> @@ -1628,7 +1629,8 @@ static int devlink_nl_cmd_eswitch_set_doit(struct
> sk_buff *skb,  {
>  	struct devlink *devlink =3D info->user_ptr[0];
>  	const struct devlink_ops *ops =3D devlink->ops;
> -	u8 inline_mode, encap_mode;
> +	enum devlink_eswitch_encap_mode encap_mode;
> +	u8 inline_mode;
>  	int err =3D 0;
>  	u16 mode;
>=20
> --
> 2.20.1

Netdev follows reverse Christmas tree, but otherwise,
Reviewed-by: Parav Pandit <parav@mellanox.com>

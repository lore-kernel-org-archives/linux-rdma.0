From: Parav Pandit <parav@mellanox.com>
Subject: RE: [PATCH mlx5-next v1 2/4] net/mlx5: Expose eswitch encap mode
Date: Thu, 13 Jun 2019 04:34:42 +0000
Message-ID: <VI1PR0501MB2271FD29406927D5F4327A0DD1EF0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190612122014.22359-1-leon@kernel.org>
 <20190612122014.22359-3-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190612122014.22359-3-leon@kernel.org>
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
> Subject: [PATCH mlx5-next v1 2/4] net/mlx5: Expose eswitch encap mode
>=20
> From: Maor Gottlieb <maorg@mellanox.com>
>=20
> Add API to get the current Eswitch encap mode.
> It will be used in downstream patches to check if flow table can be creat=
ed
> with encap support or not.
>=20
> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> Reviewed-by: Petr Vorel <pvorel@suse.cz>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 11 +++++++++++
>  include/linux/mlx5/eswitch.h                      | 12 ++++++++++++
>  2 files changed, 23 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> index 9ea0ccfe5ef5..0c68d93bea79 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> @@ -2452,6 +2452,17 @@ u8 mlx5_eswitch_mode(struct mlx5_eswitch
> *esw)  }  EXPORT_SYMBOL_GPL(mlx5_eswitch_mode);
>=20
> +enum devlink_eswitch_encap_mode
> +mlx5_eswitch_get_encap_mode(const struct mlx5_core_dev *dev) {
> +	struct mlx5_eswitch *esw;
> +
> +	esw =3D dev->priv.eswitch;
> +	return ESW_ALLOWED(esw) ? esw->offloads.encap :
> +		DEVLINK_ESWITCH_ENCAP_MODE_NONE;
> +}
> +EXPORT_SYMBOL(mlx5_eswitch_get_encap_mode);
> +
>  bool mlx5_esw_lag_prereq(struct mlx5_core_dev *dev0, struct
> mlx5_core_dev *dev1)  {
>  	if ((dev0->priv.eswitch->mode =3D=3D SRIOV_NONE && diff --git
> a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h index
> 0ca77dd1429c..f57c73e81267 100644
> --- a/include/linux/mlx5/eswitch.h
> +++ b/include/linux/mlx5/eswitch.h
> @@ -7,6 +7,7 @@
>  #define _MLX5_ESWITCH_
>=20
>  #include <linux/mlx5/driver.h>
> +#include <net/devlink.h>
>=20
>  #define MLX5_ESWITCH_MANAGER(mdev) MLX5_CAP_GEN(mdev,
> eswitch_manager)
>=20
> @@ -60,4 +61,15 @@ u8 mlx5_eswitch_mode(struct mlx5_eswitch *esw);
> struct mlx5_flow_handle *  mlx5_eswitch_add_send_to_vport_rule(struct
> mlx5_eswitch *esw,
>  				    int vport, u32 sqn);
> +
> +#ifdef CONFIG_MLX5_ESWITCH
> +enum devlink_eswitch_encap_mode
> +mlx5_eswitch_get_encap_mode(const struct mlx5_core_dev *dev); #else  /*
> +CONFIG_MLX5_ESWITCH */ static inline enum
> devlink_eswitch_encap_mode
> +mlx5_eswitch_get_encap_mode(const struct mlx5_core_dev *dev) {
> +	return DEVLINK_ESWITCH_ENCAP_MODE_NONE; } #endif /*
> +CONFIG_MLX5_ESWITCH */
>  #endif
> --
> 2.20.1
Reviewed-by: Parav Pandit <parav@mellanox.com>

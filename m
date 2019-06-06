From: Parav Pandit <parav@mellanox.com>
Subject: RE: [PATCH mlx5-next 1/3] net/mlx5: Expose eswitch encap mode
Date: Thu, 6 Jun 2019 13:08:46 +0000
Message-ID: <VI1PR0501MB227150ADAFACF4A5DEC26693D1170@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190606110609.11588-1-leon@kernel.org>
 <20190606110609.11588-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190606110609.11588-2-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> owner@vger.kernel.org> On Behalf Of Leon Romanovsky
> Sent: Thursday, June 6, 2019 4:36 PM
> To: Doug Ledford <dledford@redhat.com>; Jason Gunthorpe
> <jgg@mellanox.com>
> Cc: Leon Romanovsky <leonro@mellanox.com>; RDMA mailing list <linux-
> rdma@vger.kernel.org>; Maor Gottlieb <maorg@mellanox.com>; Mark Bloch
> <markb@mellanox.com>; Saeed Mahameed <saeedm@mellanox.com>;
> linux-netdev <netdev@vger.kernel.org>
> Subject: [PATCH mlx5-next 1/3] net/mlx5: Expose eswitch encap mode
>=20
> From: Maor Gottlieb <maorg@mellanox.com>
>=20
> Add API to get the current Eswitch encap mode.
> It will be used in downstream patches to check if flow table can be creat=
ed
> with encap support or not.
>=20
> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 10 ++++++++++
>  include/linux/mlx5/eswitch.h                      | 10 ++++++++++
>  2 files changed, 20 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> index 9ea0ccfe5ef5..1da7f9569ee8 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> @@ -2452,6 +2452,16 @@ u8 mlx5_eswitch_mode(struct mlx5_eswitch
> *esw)  }  EXPORT_SYMBOL_GPL(mlx5_eswitch_mode);
>=20
> +u16 mlx5_eswitch_get_encap_mode(struct mlx5_core_dev *dev) {

Encap mode as well defined devlink definition.
So instead of u16, it should return enum devlink_eswitch_encap_mode.

Since this is only reading the mode, it is better to define struct mlx5_cor=
e_dev* as const struct mlx5_core_dev *.

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
> 0ca77dd1429c..7be43c0fcdc5 100644
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
> @@ -60,4 +61,13 @@ u8 mlx5_eswitch_mode(struct mlx5_eswitch *esw);
> struct mlx5_flow_handle *  mlx5_eswitch_add_send_to_vport_rule(struct
> mlx5_eswitch *esw,
>  				    int vport, u32 sqn);
> +
> +#ifdef CONFIG_MLX5_ESWITCH
> +u16 mlx5_eswitch_get_encap_mode(struct mlx5_core_dev *dev); #else  /*
> +CONFIG_MLX5_ESWITCH */ static inline u16
> +mlx5_eswitch_get_encap_mode(struct mlx5_core_dev *dev) {
> +	return DEVLINK_ESWITCH_ENCAP_MODE_NONE; } #endif /*
> +CONFIG_MLX5_ESWITCH */
>  #endif
> --
> 2.20.1

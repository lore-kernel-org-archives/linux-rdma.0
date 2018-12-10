From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH mlx5-next 01/10] net/mlx5: Rework handling of port module
 events
Date: Mon, 10 Dec 2018 16:09:46 +0000
Message-ID: <20181210160938.GE3459@mellanox.com>
References: <20181210030442.7543-1-saeedm@mellanox.com>
 <20181210030442.7543-2-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181210030442.7543-2-saeedm@mellanox.com>
Content-Language: en-US
Content-ID: <E184A4F8888A224C8FF5A4FE04C304B7@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Mikhael Goikhman <migo@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 09, 2018 at 07:04:33PM -0800, Saeed Mahameed wrote:
> From: Mikhael Goikhman <migo@mellanox.com>
>=20
> Add explicit HW defined error values. For simplicity, keep counters for a=
ll
> statuses starting from 0, although currently status=3D0 is not used.
>=20
> Additionally, when HW signals an unexpected cable status, it is reported
> now rather than ignored. And status counter is now updated on errors.
>=20
> Signed-off-by: Mikhael Goikhman <migo@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
>  .../ethernet/mellanox/mlx5/core/en_stats.c    |  8 +-
>  .../net/ethernet/mellanox/mlx5/core/events.c  | 83 ++++++++++++-------
>  .../ethernet/mellanox/mlx5/core/lib/mlx5.h    | 19 ++---
>  3 files changed, 65 insertions(+), 45 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_stats.c
> index 748d23806391..881c54c12e19 100644
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> @@ -1087,13 +1087,13 @@ static void mlx5e_grp_per_prio_update_stats(struc=
t mlx5e_priv *priv)
>  }
> =20
>  static const struct counter_desc mlx5e_pme_status_desc[] =3D {
> -	{ "module_unplug", 8 },
> +	{ "module_unplug",       sizeof(u64) * MLX5_MODULE_STATUS_UNPLUGGED },
>  };
> =20
>  static const struct counter_desc mlx5e_pme_error_desc[] =3D {
> -	{ "module_bus_stuck", 16 },       /* bus stuck (I2C or data shorted) */
> -	{ "module_high_temp", 48 },       /* high temperature */
> -	{ "module_bad_shorted", 56 },    /* bad or shorted cable/module */
> +	{ "module_bus_stuck",    sizeof(u64) * MLX5_MODULE_EVENT_ERROR_BUS_STUC=
K },
> +	{ "module_high_temp",    sizeof(u64) * MLX5_MODULE_EVENT_ERROR_HIGH_TEM=
PERATURE },
> +	{ "module_bad_shorted",  sizeof(u64) * MLX5_MODULE_EVENT_ERROR_BAD_CABL=
E },
>  };
> =20
>  #define NUM_PME_STATUS_STATS		ARRAY_SIZE(mlx5e_pme_status_desc)
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/events.c
> index e92df7020a26..587d93ec905f 100644
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
> @@ -157,23 +157,43 @@ static int temp_warn(struct notifier_block *nb, uns=
igned long type, void *data)
>  }
> =20
>  /* MLX5_EVENT_TYPE_PORT_MODULE_EVENT */
> -static const char *mlx5_pme_status[MLX5_MODULE_STATUS_NUM] =3D {
> -	"Cable plugged",   /* MLX5_MODULE_STATUS_PLUGGED    =3D 0x1 */
> -	"Cable unplugged", /* MLX5_MODULE_STATUS_UNPLUGGED  =3D 0x2 */
> -	"Cable error",     /* MLX5_MODULE_STATUS_ERROR      =3D 0x3 */
> -};
> +static const char *mlx5_pme_status_to_string(enum port_module_event_stat=
us_type status)
> +{
> +	switch (status) {
> +	case MLX5_MODULE_STATUS_PLUGGED:
> +		return "Cable plugged";
> +	case MLX5_MODULE_STATUS_UNPLUGGED:
> +		return "Cable unplugged";
> +	case MLX5_MODULE_STATUS_ERROR:
> +		return "Cable error";
> +	default:
> +		return "Unknown status";
> +	}
> +}

Arrays are usually a bette codegen bet than switch/case unless the array is
very sparse, but it should be written as

  [MLX5_MODULE_STATUS_PLUGGED] =3D "Cable plugged",

Commit message should explain why this is being converted. Maybe it is
very sparse?

Jason

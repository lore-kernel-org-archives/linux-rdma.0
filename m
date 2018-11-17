From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH mlx5-next 11/12] {net,IB}/mlx5: Move Page fault EQ and ODP
 logic to RDMA
Date: Sat, 17 Nov 2018 20:13:53 +0000
Message-ID: <20181117201347.GA14593@mellanox.com>
References: <20181116215901.5874-1-saeedm@mellanox.com>
 <20181116215901.5874-12-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181116215901.5874-12-saeedm@mellanox.com>
Content-Language: en-US
Content-ID: <8A81C8DDC68BF4478A33AB1303FC2C19@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 16, 2018 at 01:59:00PM -0800, Saeed Mahameed wrote:
> Use the new generic EQ API to move all ODP RDMA data structures and logic
> form mlx5 core driver into mlx5_ib driver.
>=20
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
> Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
>  drivers/infiniband/hw/mlx5/main.c             |  10 +-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h          |  15 +-
>  drivers/infiniband/hw/mlx5/odp.c              | 281 +++++++++++++++++-
>  drivers/net/ethernet/mellanox/mlx5/core/dev.c |  34 ---
>  drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 252 ----------------
>  .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |   8 -
>  .../net/ethernet/mellanox/mlx5/core/main.c    |  17 +-
>  .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 -
>  include/linux/mlx5/driver.h                   |  49 ---
>  include/linux/mlx5/eq.h                       |  21 ++
>  10 files changed, 308 insertions(+), 381 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/ml=
x5/main.c
> index 6fbc0cba1bac..fcf4a0328a90 100644
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -6040,6 +6040,11 @@ static int mlx5_ib_stage_odp_init(struct mlx5_ib_d=
ev *dev)
>  	return mlx5_ib_odp_init_one(dev);
>  }
> =20
> +void mlx5_ib_stage_odp_cleanup(struct mlx5_ib_dev *dev)
> +{
> +	mlx5_ib_odp_cleanup_one(dev);
> +}
> +
>  int mlx5_ib_stage_counters_init(struct mlx5_ib_dev *dev)
>  {
>  	if (MLX5_CAP_GEN(dev->mdev, max_qp_cnt)) {
> @@ -6225,7 +6230,7 @@ static const struct mlx5_ib_profile pf_profile =3D =
{
>  		     mlx5_ib_stage_dev_res_cleanup),
>  	STAGE_CREATE(MLX5_IB_STAGE_ODP,
>  		     mlx5_ib_stage_odp_init,
> -		     NULL),
> +		     mlx5_ib_stage_odp_cleanup),
>  	STAGE_CREATE(MLX5_IB_STAGE_COUNTERS,
>  		     mlx5_ib_stage_counters_init,
>  		     mlx5_ib_stage_counters_cleanup),
> @@ -6395,9 +6400,6 @@ static struct mlx5_interface mlx5_ib_interface =3D =
{
>  	.add            =3D mlx5_ib_add,
>  	.remove         =3D mlx5_ib_remove,
>  	.event          =3D mlx5_ib_event,
> -#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> -	.pfault		=3D mlx5_ib_pfault,
> -#endif
>  	.protocol	=3D MLX5_INTERFACE_PROTOCOL_IB,
>  };
> =20
> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw=
/mlx5/mlx5_ib.h
> index b651a7a6fde9..d01af2d829b8 100644
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -880,6 +880,15 @@ struct mlx5_ib_lb_state {
>  	bool			enabled;
>  };
> =20
> +struct mlx5_ib_pf_eq {
> +	struct mlx5_ib_dev      *dev;
> +	struct mlx5_eq          *core;
> +	struct work_struct       work;
> +	spinlock_t               lock; /* Pagefaults spinlock */
> +	struct workqueue_struct  *wq;
> +	mempool_t                *pool;
> +};

I know this is being copied, but can we please not do this vertical
alignment madness in RDMA? It is such a nightmare to maintain this..

> +/* mempool_refill() was proposed but unfortunately wasn't accepted
> + * http://lkml.iu.edu/hypermail/linux/kernel/1512.1/05073.html
> + * Chip workaround.

'cheap workaround'

Jason

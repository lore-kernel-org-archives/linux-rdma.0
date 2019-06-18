From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next 11/15] RDMA/mlx5: Add vport metadata matching
 for IB representors
Date: Tue, 18 Jun 2019 10:19:31 +0000
Message-ID: <20190618101928.GE4690@mtr-leonro.mtl.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-12-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190617192247.25107-12-saeedm@mellanox.com>
Content-Language: en-US
Content-ID: <E77D49567320B841AFDC4B9A6D11C371@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Jianbo Liu <jianbol@mellanox.com>, Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 17, 2019 at 07:23:30PM +0000, Saeed Mahameed wrote:
> From: Jianbo Liu <jianbol@mellanox.com>
>
> If vport metadata matching is enabled in eswitch, the rule created
> must be changed to match on the metadata, instead of source port.
>
> Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
> Reviewed-by: Roi Dayan <roid@mellanox.com>
> Reviewed-by: Mark Bloch <markb@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx5/ib_rep.c | 11 +++++++
>  drivers/infiniband/hw/mlx5/ib_rep.h | 16 ++++++++++
>  drivers/infiniband/hw/mlx5/main.c   | 45 +++++++++++++++++++++++------
>  3 files changed, 63 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/=
mlx5/ib_rep.c
> index 22e651cb5534..d4ed611de35d 100644
> --- a/drivers/infiniband/hw/mlx5/ib_rep.c
> +++ b/drivers/infiniband/hw/mlx5/ib_rep.c
> @@ -131,6 +131,17 @@ struct mlx5_eswitch_rep *mlx5_ib_vport_rep(struct ml=
x5_eswitch *esw, int vport)
>  	return mlx5_eswitch_vport_rep(esw, vport);
>  }
>
> +u32 mlx5_ib_eswitch_vport_match_metadata_enabled(struct mlx5_eswitch *es=
w)
> +{
> +	return mlx5_eswitch_vport_match_metadata_enabled(esw);
> +}
> +
> +u32 mlx5_ib_eswitch_get_vport_metadata_for_match(struct mlx5_eswitch *es=
w,
> +						 u16 vport)
> +{
> +	return mlx5_eswitch_get_vport_metadata_for_match(esw, vport);
> +}

1. There is no need to introduce one line functions, call to that code dire=
ctly.
2. It should be bool and not u32.

Thanks

From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH mlx5-next v1 05/15] net/mlx5: Break encap/decap into two
 separated flow table creation flags
Date: Tue, 4 Sep 2018 16:02:42 -0600
Message-ID: <20180904220242.GA3895@ziepe.ca>
References: <20180828111854.14367-1-leon@kernel.org>
 <20180828111854.14367-6-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180828111854.14367-6-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 28, 2018 at 02:18:44PM +0300, Leon Romanovsky wrote:
> From: Mark Bloch <markb@mellanox.com>
> 
> Today we are able to attach encap and decap actions only to the FDB. In
> preparation to enable those actions on the NIC flow tables, break the
> single flag into two. Those flags control whatever a decap or encap
> operations can be attached to the flow table created. For FDB, if
> encapsulation is required, we set both of them.
> 
> Signed-off-by: Mark Bloch <markb@mellanox.com>
> Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
> Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 3 ++-
>  drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c           | 7 ++++---
>  include/linux/mlx5/fs.h                                    | 3 ++-
>  3 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index f72b5c9dcfe9..ff21807a0c4b 100644
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -529,7 +529,8 @@ static int esw_create_offloads_fast_fdb_table(struct mlx5_eswitch *esw)
>  		esw_size >>= 1;
>  
>  	if (esw->offloads.encap != DEVLINK_ESWITCH_ENCAP_MODE_NONE)
> -		flags |= MLX5_FLOW_TABLE_TUNNEL_EN;
> +		flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_ENCAP |
> +			  MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
>  
>  	fdb = mlx5_create_auto_grouped_flow_table(root_ns, FDB_FAST_PATH,
>  						  esw_size,
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
> index 9ae777e56529..1698f325a21e 100644
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
> @@ -152,7 +152,8 @@ static int mlx5_cmd_create_flow_table(struct mlx5_core_dev *dev,
>  				      struct mlx5_flow_table *next_ft,
>  				      unsigned int *table_id, u32 flags)
>  {
> -	int en_encap_decap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN);
> +	int en_encap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN_ENCAP);
> +	int en_decap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);

Yuk, please don't use !!.

	bool en_decap = flags & MLX5_FLOW_TABLE_TUNNEL_EN_DECAP;

Jason

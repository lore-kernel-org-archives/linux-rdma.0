From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH mlx5-next 12/12] net/mlx5: Set ODP SRQ support in firmware
Date: Thu, 31 Jan 2019 16:28:44 -0700
Message-ID: <20190131232843.GA15062@ziepe.ca>
References: <20190122064851.6032-1-leon@kernel.org>
 <20190122064851.6032-13-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190122064851.6032-13-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 22, 2019 at 08:48:51AM +0200, Leon Romanovsky wrote:
> From: Moni Shoua <monis@mellanox.com>
> 
> To avoid compatibility issue with older kernels the firmware doesn't
> allow SRQ to work with ODP unless kernel asks for it.
> 
> Signed-off-by: Moni Shoua <monis@mellanox.com>
> Reviewed-by: Majd Dibbiny <majd@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  .../net/ethernet/mellanox/mlx5/core/main.c    | 53 +++++++++++++++++++
>  include/linux/mlx5/device.h                   |  3 ++
>  include/linux/mlx5/mlx5_ifc.h                 |  1 +
>  3 files changed, 57 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> index be81b319b0dc..b3a76df0cf6c 100644
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -459,6 +459,53 @@ static int handle_hca_cap_atomic(struct mlx5_core_dev *dev)
>  	return err;
>  }
>  
> +static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
> +{
> +	void *set_ctx;
> +	void *set_hca_cap;
> +	int set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
> +	int err;
> +
> +	if (!MLX5_CAP_GEN(dev, pg))
> +		return 0;

Should a  

    if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING))
             return 0;

Be here?

Jason

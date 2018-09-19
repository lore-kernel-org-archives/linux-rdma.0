From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH mlx5-next 03/25] net/mlx5: Set uid as part of RQ commands
Date: Wed, 19 Sep 2018 11:28:55 -0600
Message-ID: <20180919172855.GN11367@ziepe.ca>
References: <20180917110418.18937-1-leon@kernel.org>
 <20180917110418.18937-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180917110418.18937-4-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 17, 2018 at 02:03:56PM +0300, Leon Romanovsky wrote:
> From: Yishai Hadas <yishaih@mellanox.com>
> 
> Set uid as part of RQ commands so that the firmware can manage the
> RQ object in a secured way.
> 
> That will enable using an RQ that was created by verbs application
> to be used by the DEVX flow in case the uid is equal.
> 
> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/net/ethernet/mellanox/mlx5/core/qp.c | 16 ++++++++++++++--
>  include/linux/mlx5/mlx5_ifc.h                |  6 +++---
>  2 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
> index 04f72a1cdbcc..0ca68ef54d93 100644
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
> @@ -540,6 +540,17 @@ int mlx5_core_xrcd_dealloc(struct mlx5_core_dev *dev, u32 xrcdn)
>  }
>  EXPORT_SYMBOL_GPL(mlx5_core_xrcd_dealloc);
>  
> +static void destroy_rq_tracked(struct mlx5_core_dev *dev, u32 rqn, u16 uid)
> +{
> +	u32 in[MLX5_ST_SZ_DW(destroy_rq_in)]   = {0};
> +	u32 out[MLX5_ST_SZ_DW(destroy_rq_out)] = {0};

= {} is the preferred version of this, right? 

{0} explicitly initializes the first element to zero and only works if
the first element happens to be something integral..

Jason

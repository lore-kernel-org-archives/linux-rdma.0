From: Eli Cohen <eli@dev.mellanox.co.il>
Subject: Re: [patch] IB/mlx5: fix error code in get_port_caps()
Date: Mon, 12 Jan 2015 10:54:57 +0200
Message-ID: <20150112085457.GA5319@mtldesk30>
References: <20150112081429.GA11818@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150112081429.GA11818@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Acked-by: Eli Cohen <eli@mellanox.com>

Thanks!

On Mon, Jan 12, 2015 at 11:14:29AM +0300, Dan Carpenter wrote:
> We should return -ENOMEM on allocation failure instead of success.
> 
> Fixes: e126ba97dba9 ('mlx5: Add driver for Mellanox Connect-IB adapters')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index 8a87404..cc4ac1e 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -997,7 +997,7 @@ static int get_port_caps(struct mlx5_ib_dev *dev)
>  	struct ib_device_attr *dprops = NULL;
>  	struct ib_port_attr *pprops = NULL;
>  	struct mlx5_general_caps *gen;
> -	int err = 0;
> +	int err = -ENOMEM;
>  	int port;
>  
>  	gen = &dev->mdev->caps.gen;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
